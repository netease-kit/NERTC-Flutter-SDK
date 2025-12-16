// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.netease.lava.nertc.sdk.NERtcDataExternalFrame;
import com.netease.lava.nertc.sdk.NERtcFeatureType;
import com.netease.lava.nertc.sdk.NERtcJoinChannelOptions;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam.ChannelMediaRelayConfiguration;
import com.netease.lava.nertc.sdk.audio.NERtcAudioStreamType;
import com.netease.lava.nertc.sdk.audio.NERtcDistanceRolloffModel;
import com.netease.lava.nertc.sdk.audio.NERtcPositionInfo;
import com.netease.lava.nertc.sdk.audio.NERtcRangeAudioMode;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerMaterialName;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRenderMode;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRoomCapacity;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRoomProperty;
import com.netease.lava.nertc.sdk.channel.NERtcChannel;
import com.netease.lava.nertc.sdk.channel.NERtcChannelCallback;
import com.netease.lava.nertc.sdk.encryption.NERtcEncryptionConfig;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamImageInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamLayout;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding;
import com.netease.lava.nertc.sdk.stats.NERtcStatsObserver;
import com.netease.lava.nertc.sdk.video.NERtcCameraCaptureConfig;
import com.netease.lava.nertc.sdk.video.NERtcCameraCaptureConfig.NERtcCaptureExtraRotation;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoFrame;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamLayerCount;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamType;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcChannelImpl implements Messages.ChannelApi {

  private static final String TAG = "NERtcChannelImpl";
  private static final int CAPTURE_PERMISSION_REQUEST_CODE = 11;
  private static final int LOOPBACK_PERMISSION_REQUEST_CODE = 12;

  private final Context applicationContext;
  private final BinaryMessenger messenger;
  private final Messages.NERtcLiveStreamEventSink liveEventSink;

  private Activity activity;
  private Intent screenCaptureIntent;
  private AddActivityResultListener addActivityResultListener;
  private RemoveActivityResultListener removeActivityResultListener;

  public NERtcChannelImpl(@NonNull Context applicationContext, @NonNull BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    this.messenger = messenger;
    this.liveEventSink = new Messages.NERtcLiveStreamEventSink(messenger);
    this.activity = null;
    this.screenCaptureIntent = null;
    this.addActivityResultListener = null;
    this.removeActivityResultListener = null;
  }

  @FunctionalInterface
  interface AddActivityResultListener {
    void addListener(@NonNull PluginRegistry.ActivityResultListener listener);
  }

  @FunctionalInterface
  interface RemoveActivityResultListener {
    void removeListener(@NonNull PluginRegistry.ActivityResultListener listener);
  }

  @FunctionalInterface
  interface SuccessCallback {
    void onSuccess(long result);
  }

  private class ChannelActivityResultListener implements PluginRegistry.ActivityResultListener {

    private final SuccessCallback successCallback;
    private final NERtcScreenConfig screenConfig;
    private final NERtcChannel channel;
    private final RemoveActivityResultListener removeListener;

    ChannelActivityResultListener(
        SuccessCallback successCallback,
        NERtcScreenConfig screenConfig,
        NERtcChannel channel,
        RemoveActivityResultListener removeListener) {
      this.successCallback = successCallback;
      this.screenConfig = screenConfig;
      this.channel = channel;
      this.removeListener = removeListener;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
      if (removeListener != null) {
        removeListener.removeListener(this);
      }
      if (requestCode == CAPTURE_PERMISSION_REQUEST_CODE) {
        if (resultCode != Activity.RESULT_OK || data == null) {
          successCallback.onSuccess(-1L);
        } else {
          screenCaptureIntent = data;
          int ret =
              channel.startScreenCapture(
                  screenConfig,
                  data,
                  new MediaProjection.Callback() {
                    @Override
                    public void onStop() {
                      super.onStop();
                      screenCaptureIntent = null;
                    }
                  });
          successCallback.onSuccess(ret);
        }
      } else if (requestCode == LOOPBACK_PERMISSION_REQUEST_CODE) {
        screenCaptureIntent = data;
        int result =
            channel.enableLoopbackRecording(
                true,
                screenCaptureIntent,
                new MediaProjection.Callback() {
                  @Override
                  public void onStop() {
                    super.onStop();
                    screenCaptureIntent = null;
                  }
                });
      }
      return false;
    }
  }

  public void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  public void setActivityResultListener(
      @Nullable AddActivityResultListener addListener,
      @Nullable RemoveActivityResultListener removeListener) {
    this.addActivityResultListener = addListener;
    this.removeActivityResultListener = removeListener;
  }

  @NonNull
  @Override
  public String getChannelName(@NonNull String channelTag) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return "";
    }
    return channel.getChannelName();
  }

  @NonNull
  public Long enableMediaPub(
      @NonNull String channelName, @NonNull Long mediaType, @NonNull Boolean enable) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null.");
      return -1L;
    }
    int result = channel.enableMediaPub(mediaType.intValue(), enable);
    return (long) result;
  }

  @NonNull
  @Override
  public Long setStatsEventCallback(String channelName) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    NERtcStatsObserver observer =
        NERtcChannelManager.getInstance().createStatsObserver(channelName);
    channel.setStatsObserver(observer);
    return 0L;
  }

  @NonNull
  @Override
  public Long clearStatsEventCallback(String channelName) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    channel.setStatsObserver(null);
    return 0L;
  }

  @Override
  public Long setChannelProfile(String channelName, Long profile) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.setChannelProfile(profile.intValue());
    return (long) result;
  }

  @Override
  public Long joinChannel(String channelName, Messages.JoinChannelRequest request) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret = -1;
    if (request.getChannelOptions() != null) {
      NERtcJoinChannelOptions options = new NERtcJoinChannelOptions();
      if (request.getChannelOptions().getCustomInfo() != null) {
        options.customInfo = request.getChannelOptions().getCustomInfo();
      }
      if (request.getChannelOptions().getPermissionKey() != null) {
        options.permissionKey = request.getChannelOptions().getPermissionKey();
      }
      ret = channel.joinChannel(request.getToken(), request.getUid(), options);
    } else {
      ret = channel.joinChannel(request.getToken(), request.getUid());
    }
    return (long) ret;
  }

  @Override
  public Long leaveChannel(String channelName) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret = channel.leaveChannel();
    return (long) ret;
  }

  @Override
  public Long setClientRole(String channelName, Long role) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.setClientRole(role.intValue());
    return (long) result;
  }

  @Override
  public Long getConnectionState(String channelName) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int state = channel.getConnectionState();
    return (long) state;
  }

  @Override
  public Long release(String channelName) {
    NERtcChannelManager.getInstance().release(channelName);
    return 0L;
  }

  @Override
  public Long enableLocalAudio(String channelName, Boolean enabled) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.enableLocalAudio(enabled);
    return (long) result;
  }

  @Override
  public Long muteLocalAudioStream(String channelName, Boolean muted) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.muteLocalAudioStream(muted);
    return (long) result;
  }

  @Override
  public Long subscribeRemoteAudio(
      @NonNull String channelName, @NonNull Long uid, @NonNull Boolean subscribe) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.subscribeRemoteAudioStream(uid, subscribe);
    return (long) result;
  }

  @Override
  public Long subscribeRemoteSubAudio(
      @NonNull String channelTag, @NonNull Long uid, @NonNull Boolean subscribe) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.subscribeRemoteSubStreamAudio(uid, subscribe);
    return (long) result;
  }

  @Override
  public Long setLocalVideoConfig(String channelName, Messages.SetLocalVideoConfigRequest arg) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    NERtcVideoConfig config = new NERtcVideoConfig();
    config.videoProfile = arg.getVideoProfile().intValue();
    config.videoCropMode = arg.getVideoCropMode().intValue();
    //    config.frontCamera = arg.getFrontCamera();
    config.frameRate = FLTUtils.int2VideoFrameRate(arg.getFrameRate().intValue());
    config.minFramerate = arg.getMinFrameRate().intValue();
    config.bitrate = arg.getBitrate().intValue();
    config.minBitrate = arg.getMinBitrate().intValue();
    config.degradationPrefer =
        FLTUtils.int2DegradationPreference(arg.getDegradationPrefer().intValue());
    config.width = arg.getWidth().intValue();
    config.height = arg.getHeight().intValue();
    config.orientationMode =
        FLTUtils.int2VideoOutputOrientationMode(arg.getOrientationMode().intValue());
    config.mirrorMode = FLTUtils.int2VideoMirrorMode(arg.getMirrorMode().intValue());
    int ret = -1;
    if (arg.getStreamType() == null) {
      ret = channel.setLocalVideoConfig(config);
    } else {
      NERtcVideoStreamType streamType =
          FLTUtils.int2VideoStreamType(arg.getStreamType().intValue());
      ret = channel.setLocalVideoConfig(config, streamType);
    }
    return (long) ret;
  }

  @Override
  public Long enableLocalVideo(String channelName, Messages.EnableLocalVideoRequest arg) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret = -1;
    if (arg.getStreamType() == null) {
      ret = channel.enableLocalVideo(arg.getEnable());
    } else {
      ret =
          channel.enableLocalVideo(
              FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()), arg.getEnable());
    }
    return (long) ret;
  }

  @Override
  public Long muteLocalVideoStream(String channelName, Boolean mute, Long type) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret = channel.muteLocalVideoStream(mute, FLTUtils.int2VideoStreamType(type.intValue()));
    return (long) ret;
  }

  @Override
  public Long switchCamera(String channelName) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int result = channel.switchCamera();
    return (long) result;
  }

  @Override
  public Long subscribeRemoteVideoStream(
      String channelName, Messages.SubscribeRemoteVideoStreamRequest arg) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret =
        channel.subscribeRemoteVideoStream(
            arg.getUid(),
            FLTUtils.int2RemoteVideoStreamType(arg.getStreamType().intValue()),
            arg.getSubscribe());
    return (long) ret;
  }

  @NonNull
  public Long subscribeRemoteSubVideoStream(
      @NonNull String channelTag, @NonNull Long uid, @NonNull Boolean subscribe) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret = channel.subscribeRemoteSubStreamVideo(uid, subscribe);
    return (long) ret;
  }

  @Override
  public Long enableAudioVolumeIndication(
      String channelName, Messages.EnableAudioVolumeIndicationRequest arg) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    int ret =
        channel.enableAudioVolumeIndication(
            arg.getEnable(), arg.getInterval().intValue(), arg.getVad());
    return (long) ret;
  }

  @Override
  public Long takeLocalSnapshot(
      @NonNull String channelName, @NonNull Long streamType, @NonNull String path) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    long ret =
        channel.takeLocalSnapshot(
            FLTUtils.int2VideoStreamType(streamType.intValue()),
            (int code, Bitmap bitmap) -> {
              if (bitmap != null) {
                OutputStream os = null;
                try {
                  File file = new File(path);
                  if (!file.exists()) {
                    file.createNewFile();
                  }
                  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    os = Files.newOutputStream(file.toPath());
                  }
                  String extension = path.substring(path.lastIndexOf(".") + 1);
                  if (extension.equalsIgnoreCase("png")) {
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, os);
                  } else if (extension.equalsIgnoreCase("jpg")
                      || extension.equalsIgnoreCase("jpeg")) {
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                  } else {
                    throw new IllegalArgumentException("Unsupported image format:" + extension);
                  }
                  assert os != null;
                  os.flush();
                } catch (IOException e) {
                  throw new RuntimeException(e);
                } finally {
                  try {
                    if (os != null) {
                      os.close();
                    }
                  } catch (IOException e) {
                    e.printStackTrace();
                  }
                }
                NERtcChannelCallback callback =
                    NERtcChannelManager.getInstance().getCallback(channelName);
                if (callback != null) {
                  ((NERtcSubCallbackImpl) callback).onTakeSnapshotResult(code, path);
                }
              }
            });
    return (long) ret;
  }

  @Override
  public Long takeRemoteSnapshot(
      @NonNull String channelName,
      @NonNull Long uid,
      @NonNull Long streamType,
      @NonNull String path) {

    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    long ret =
        channel.takeRemoteSnapshot(
            uid,
            type,
            (int code, Bitmap bitmap) -> {
              if (bitmap != null) {
                OutputStream os = null;
                try {
                  File file = new File(path);
                  if (!file.exists()) {
                    file.createNewFile();
                  }
                  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    os = Files.newOutputStream(file.toPath());
                  }
                  String extension = path.substring(path.lastIndexOf(".") + 1);
                  if (extension.equalsIgnoreCase("png")) {
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, os);
                  } else if (extension.equalsIgnoreCase("jpg")
                      || extension.equalsIgnoreCase("jpeg")) {
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                  } else {
                    throw new IllegalArgumentException("Unsupported image format:" + extension);
                  }
                  assert os != null;
                  os.flush();
                } catch (IOException e) {
                  throw new RuntimeException(e);
                } finally {
                  try {
                    if (os != null) {
                      os.close();
                    }
                  } catch (IOException e) {
                    e.printStackTrace();
                  }
                }
                NERtcChannelCallback callback =
                    NERtcChannelManager.getInstance().getCallback(channelName);
                if (callback != null) {
                  ((NERtcSubCallbackImpl) callback).onTakeSnapshotResult(code, path);
                }
              }
            });
    return (long) ret;
  }

  @Override
  public Long subscribeAllRemoteAudio(String channelTag, Boolean subscribe) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.subscribeAllRemoteAudioStreams(subscribe);
    return (long) result;
  }

  @Override
  public Long setCameraCaptureConfig(
      String channelTag, Messages.SetCameraCaptureConfigRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }

    NERtcCameraCaptureConfig config = new NERtcCameraCaptureConfig();
    Messages.NERtcCaptureExtraRotation rotation = request.getExtraRotation();
    if (rotation != null) {
      switch (rotation) {
        case K_NERTC_CAPTURE_EXTRA_ROTATION_CLOCK_WISE90:
          config.extraRotation = NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_CLOCKWISE_90;
          break;
        case K_NERTC_CAPTURE_EXTRA_ROTATION180:
          config.extraRotation = NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_180;
          break;
        case K_NERTC_CAPTURE_EXTRA_ROTATION_ANTI_CLOCK_WISE90:
          config.extraRotation = NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_ANTICLOCKWISE_90;
          break;
        case K_NERTC_CAPTURE_EXTRA_ROTATION_DEFAULT:
        default:
          config.extraRotation = NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_DEFAULT;
          break;
      }
    } else {
      config.extraRotation = NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_DEFAULT;
    }

    if (request.getCaptureWidth() != null) {
      config.captureWidth = request.getCaptureWidth().intValue();
    }
    if (request.getCaptureHeight() != null) {
      config.captureHeight = request.getCaptureHeight().intValue();
    }

    int result;
    if (request.getStreamType() == null) {
      result = channel.setCameraCaptureConfig(config);
    } else {
      NERtcVideoStreamType streamType =
          FLTUtils.int2VideoStreamType(request.getStreamType().intValue());
      result = channel.setCameraCaptureConfig(config, streamType);
    }
    return (long) result;
  }

  @Override
  public Long setVideoStreamLayerCount(String channelTag, Long layerCount) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcVideoStreamLayerCount count = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountOne;
    if (layerCount != null) {
      if (layerCount == 2) {
        count = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountTwo;
      } else if (layerCount == 3) {
        count = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountThree;
      }
    }
    int result = channel.setVideoStreamLayerCount(count);
    return (long) result;
  }

  @Override
  public Long getFeatureSupportedType(String channelTag, Long type) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    if (type != null && type == 0) {
      int result = channel.getFeatureSupportedType(NERtcFeatureType.VIRTUAL_BACKGROUND);
      return (long) result;
    }
    return -1L;
  }

  @Override
  public Long switchCameraWithPosition(String channelTag, Long position) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.switchCameraWithPosition(position.intValue());
    return (long) result;
  }

  @Override
  public void startScreenCapture(
      String channelTag, Messages.StartScreenCaptureRequest request, Messages.Result<Long> result) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      result.success(-1L);
      return;
    }
    if (activity == null) {
      Log.e(TAG, "startScreenCapture error: activity is null.");
      result.success(-2L);
      return;
    }
    if (addActivityResultListener == null) {
      Log.e(TAG, "startScreenCapture error: addActivityResultListener is null.");
      result.success(-3L);
      return;
    }
    if (removeActivityResultListener == null) {
      Log.e(TAG, "startScreenCapture error: removeActivityResultListener is null.");
      result.success(-4L);
      return;
    }

    NERtcScreenConfig config = new NERtcScreenConfig();
    if (request.getBitrate() != null) {
      config.bitrate = request.getBitrate().intValue();
    }
    if (request.getContentPrefer() != null) {
      config.contentPrefer =
          FLTUtils.int2SubStreamContentPrefer(request.getContentPrefer().intValue());
    }
    if (request.getFrameRate() != null) {
      config.frameRate = FLTUtils.int2VideoFrameRate(request.getFrameRate().intValue());
    }
    if (request.getMinBitrate() != null) {
      config.minBitrate = request.getMinBitrate().intValue();
    }
    if (request.getMinFrameRate() != null) {
      config.minFramerate = request.getMinFrameRate().intValue();
    }
    if (request.getVideoProfile() != null) {
      config.videoProfile = request.getVideoProfile().intValue();
    }

    if (screenCaptureIntent == null) {
      ChannelActivityResultListener listener =
          new ChannelActivityResultListener(
              value -> result.success(value), config, channel, removeActivityResultListener);
      addActivityResultListener.addListener(listener);
      requestScreenCapture(activity);
    } else {
      channel.startScreenCapture(
          config,
          screenCaptureIntent,
          new MediaProjection.Callback() {
            @Override
            public void onStop() {
              super.onStop();
              screenCaptureIntent = null;
            }
          });
      result.success(0L);
    }
  }

  @Override
  public Long stopScreenCapture(String channelTag) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    channel.stopScreenCapture();
    return 0L;
  }

  @Override
  public Long enableLoopbackRecording(String channelTag, Boolean enable) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    if (activity == null) {
      Log.e(TAG, "enableLoopbackRecording error: activity is null.");
      return -2L;
    }
    if (addActivityResultListener == null) {
      Log.e(TAG, "enableLoopbackRecording error: addActivityResultListener is null.");
      return -3L;
    }
    if (removeActivityResultListener == null) {
      Log.e(TAG, "enableLoopbackRecording error: removeActivityResultListener is null.");
      return -4L;
    }

    MediaProjection.Callback callback =
        new MediaProjection.Callback() {
          @Override
          public void onStop() {
            super.onStop();
            screenCaptureIntent = null;
          }
        };
    int result = 0;
    if (screenCaptureIntent != null) {
      result = channel.enableLoopbackRecording(enable, screenCaptureIntent, callback);
    } else {
      ChannelActivityResultListener listener =
          new ChannelActivityResultListener(null, null, channel, removeActivityResultListener);
      addActivityResultListener.addListener(listener);
      requestLoopback(activity);
    }
    return (long) result;
  }

  @Override
  public Long adjustLoopBackRecordingSignalVolume(String channelTag, Long volume) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.adjustLoopBackRecordingSignalVolume(volume.intValue());
    return (long) result;
  }

  @Override
  public Long setExternalVideoSource(String channelTag, Long streamType, Boolean enable) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    int result = channel.setExternalVideoSource(type, enable);
    return (long) result;
  }

  @Override
  public Long pushExternalVideoFrame(
      String channelTag, Long streamType, Messages.VideoFrame frame) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    NERtcVideoFrame videoFrame = new NERtcVideoFrame();
    if (frame.getWidth() != null) {
      videoFrame.width = frame.getWidth().intValue();
    }
    if (frame.getHeight() != null) {
      videoFrame.height = frame.getHeight().intValue();
    }
    if (frame.getRotation() != null) {
      videoFrame.rotation = frame.getRotation().intValue();
    }
    if (frame.getFormat() != null) {
      switch (frame.getFormat().intValue()) {
        case 0:
          videoFrame.format = NERtcVideoFrame.Format.I420;
          break;
        case 3:
          videoFrame.format = NERtcVideoFrame.Format.NV21;
          break;
        case 4:
          videoFrame.format = NERtcVideoFrame.Format.RGBA;
          break;
        case 5:
          videoFrame.format = NERtcVideoFrame.Format.TEXTURE_OES;
          break;
        case 6:
          videoFrame.format = NERtcVideoFrame.Format.TEXTURE_RGB;
          break;
        default:
          break;
      }
    }
    if (frame.getTimeStamp() != null) {
      videoFrame.timeStamp = frame.getTimeStamp();
    }
    videoFrame.data = frame.getData();
    if (frame.getStrideY() != null) {
      videoFrame.strideY = frame.getStrideY().intValue();
    }
    if (frame.getStrideU() != null) {
      videoFrame.strideU = frame.getStrideU().intValue();
    }
    if (frame.getStrideV() != null) {
      videoFrame.strideV = frame.getStrideV().intValue();
    }
    if (frame.getTextureId() != null) {
      videoFrame.textureId = frame.getTextureId().intValue();
    }
    videoFrame.transformMatrix = FLTUtils.toGetTransformMatrix(frame.getTransformMatrix());

    boolean ret = channel.pushExternalVideoFrame(type, videoFrame);
    return ret ? 0L : -1L;
  }

  @Override
  public Long addLiveStreamTask(
      String channelTag, Messages.AddOrUpdateLiveStreamTaskRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcLiveStreamTaskInfo taskInfo = buildLiveStreamTaskInfo(request);
    int result =
        channel.addLiveStreamTask(
            taskInfo,
            (taskId, errorCode) ->
                liveEventSink.onAddLiveStreamTask(
                    taskId,
                    (long) errorCode,
                    new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                      @Override
                      public void reply(Void aVoid) {
                        // no-op
                      }
                    }));
    return (long) result;
  }

  @Override
  public Long updateLiveStreamTask(
      String channelTag, Messages.AddOrUpdateLiveStreamTaskRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcLiveStreamTaskInfo taskInfo = buildLiveStreamTaskInfo(request);
    int result =
        channel.updateLiveStreamTask(
            taskInfo,
            (taskId, errorCode) ->
                liveEventSink.onUpdateLiveStreamTask(
                    taskId,
                    (long) errorCode,
                    new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                      @Override
                      public void reply(Void aVoid) {
                        // no-op
                      }
                    }));
    return (long) result;
  }

  @Override
  public Long removeLiveStreamTask(
      String channelTag, Messages.DeleteLiveStreamTaskRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result =
        channel.removeLiveStreamTask(
            request.getTaskId(),
            (taskId, errorCode) ->
                liveEventSink.onDeleteLiveStreamTask(
                    taskId,
                    (long) errorCode,
                    new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                      @Override
                      public void reply(Void aVoid) {
                        // no-op
                      }
                    }));
    return (long) result;
  }

  @Override
  public Long sendSEIMsg(String channelTag, Messages.SendSEIMsgRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result =
        channel.sendSEIMsg(
            request.getSeiMsg(), FLTUtils.int2VideoStreamType(request.getStreamType().intValue()));
    return (long) result;
  }

  @Override
  public Long setLocalMediaPriority(
      String channelTag, Messages.SetLocalMediaPriorityRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result =
        channel.setLocalMediaPriority(request.getPriority().intValue(), request.getIsPreemptive());
    return (long) result;
  }

  @Override
  public Long startChannelMediaRelay(
      String channelTag, Messages.StartOrUpdateChannelMediaRelayRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    ChannelMediaRelayConfiguration configuration =
        new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
    configuration.sourceMediaInfo = FLTUtils.fromMap(request.getSourceMediaInfo());
    if (request.getDestMediaInfo() != null) {
      for (Object key : request.getDestMediaInfo().keySet()) {
        Map<Object, Object> value = request.getDestMediaInfo().get(key);
        configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
      }
    }
    int result = channel.startChannelMediaRelay(configuration);
    return (long) result;
  }

  @Override
  public Long updateChannelMediaRelay(
      String channelTag, Messages.StartOrUpdateChannelMediaRelayRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    ChannelMediaRelayConfiguration configuration =
        new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
    configuration.sourceMediaInfo = FLTUtils.fromMap(request.getSourceMediaInfo());
    if (request.getDestMediaInfo() != null) {
      for (Object key : request.getDestMediaInfo().keySet()) {
        Map<Object, Object> value = request.getDestMediaInfo().get(key);
        configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
      }
    }
    int result = channel.updateChannelMediaRelay(configuration);
    return (long) result;
  }

  @Override
  public Long stopChannelMediaRelay(String channelTag) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.stopChannelMediaRelay();
    return (long) result;
  }

  @Override
  public Long adjustUserPlaybackSignalVolume(
      String channelTag, Messages.AdjustUserPlaybackSignalVolumeRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    if (request.getUid() == null || request.getVolume() == null) {
      return -1L;
    }
    int result =
        channel.adjustUserPlaybackSignalVolume(request.getUid(), request.getVolume().intValue());
    return (long) result;
  }

  @Override
  public Long setLocalPublishFallbackOption(String channelTag, Long option) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.setLocalPublishFallbackOption(option.intValue());
    return (long) result;
  }

  @Override
  public Long setRemoteSubscribeFallbackOption(String channelTag, Long option) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.setRemoteSubscribeFallbackOption(option.intValue());
    return (long) result;
  }

  @Override
  public Long enableEncryption(String channelTag, Messages.EnableEncryptionRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = -1;
    if (request.getMode() != null && request.getMode() == 0 && request.getKey() != null) {
      NERtcEncryptionConfig.EncryptionMode mode =
          NERtcEncryptionConfig.EncryptionMode.GMCryptoSM4ECB;
      NERtcEncryptionConfig config = new NERtcEncryptionConfig(mode, request.getKey(), null);
      result = channel.enableEncryption(request.getEnable(), config);
    }
    return (long) result;
  }

  @Override
  public Long setRemoteHighPriorityAudioStream(
      String channelTag, Messages.SetRemoteHighPriorityAudioStreamRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.setRemoteHighPriorityAudioStream(request.getEnabled(), request.getUid());
    return (long) result;
  }

  @Override
  public Long setAudioSubscribeOnlyBy(
      String channelTag, Messages.SetAudioSubscribeOnlyByRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    long[] users = convertToLongArray(request.getUidArray());
    int result = channel.setAudioSubscribeOnlyBy(users);
    return (long) result;
  }

  @Override
  public Long enableLocalSubStreamAudio(String channelTag, Boolean enable) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.enableLocalSubStreamAudio(enable);
    return (long) result;
  }

  @Override
  public Long enableLocalData(String channelTag, Boolean enabled) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.enableLocalData(enabled);
    return (long) result;
  }

  @Override
  public Long subscribeRemoteData(String channelTag, Boolean subscribe, Long userID) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.subscribeRemoteData(subscribe, userID);
    return (long) result;
  }

  @Override
  public Long sendData(String channelTag, Messages.DataExternalFrame frame) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcDataExternalFrame dataFrame = new NERtcDataExternalFrame();
    dataFrame.externalData = frame.getData();
    dataFrame.dataSize = frame.getDataSize();
    int result = channel.sendData(dataFrame);
    return (long) result;
  }

  @Override
  public Long reportCustomEvent(String channelTag, Messages.ReportCustomEventRequest request) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    HashMap<String, Object> params = null;
    if (request.getParam() != null) {
      params = new HashMap<>((Map<String, Object>) request.getParam());
    }
    int result =
        channel.reportCustomEvent(request.getEventName(), request.getCustomIdentify(), params);
    return (long) result;
  }

  @Override
  public Long setAudioRecvRange(
      String channelTag, Long audibleDistance, Long conversationalDistance, Long rollOffMode) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcDistanceRolloffModel model = NERtcDistanceRolloffModel.values()[rollOffMode.intValue()];
    int result =
        channel.setAudioRecvRange(
            audibleDistance.intValue(), conversationalDistance.intValue(), model);
    return (long) result;
  }

  @Override
  public Long setRangeAudioMode(String channelTag, Long audioMode) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcRangeAudioMode mode = NERtcRangeAudioMode.values()[audioMode.intValue()];
    int result = channel.setRangeAudioMode(mode);
    return (long) result;
  }

  @Override
  public Long setRangeAudioTeamID(String channelTag, Long teamID) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.setRangeAudioTeamID(teamID.intValue());
    return (long) result;
  }

  @Override
  public Long updateSelfPosition(String channelTag, Messages.PositionInfo positionInfo) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcPositionInfo info =
        new NERtcPositionInfo(
            convertToFloatArray(positionInfo.getMSpeakerPosition()),
            convertToFloatArray(positionInfo.getMSpeakerQuaternion()),
            convertToFloatArray(positionInfo.getMHeadPosition()),
            convertToFloatArray(positionInfo.getMHeadQuaternion()));
    int result = channel.updateSelfPosition(info);
    return (long) result;
  }

  @Override
  public Long enableSpatializerRoomEffects(String channelTag, Boolean enable) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.enableSpatializerRoomEffects(enable);
    return (long) result;
  }

  @Override
  public Long setSpatializerRoomProperty(
      String channelTag, Messages.SpatializerRoomProperty property) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcSpatializerRoomProperty roomProperty = new NERtcSpatializerRoomProperty();
    roomProperty.roomCapacity =
        NERtcSpatializerRoomCapacity.values()[property.getRoomCapacity().intValue()];
    roomProperty.material =
        NERtcSpatializerMaterialName.values()[property.getMaterial().intValue()];
    roomProperty.reflectionScalar = property.getReflectionScalar().floatValue();
    roomProperty.reverbGain = property.getReverbGain().floatValue();
    roomProperty.reverbTime = property.getReverbTime().floatValue();
    roomProperty.reverbBrightness = property.getReverbBrightness().floatValue();
    int result = channel.setSpatializerRoomProperty(roomProperty);
    return (long) result;
  }

  @Override
  public Long setSpatializerRenderMode(String channelTag, Long renderMode) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    NERtcSpatializerRenderMode mode = NERtcSpatializerRenderMode.values()[renderMode.intValue()];
    int result = channel.setSpatializerRenderMode(mode);
    return (long) result;
  }

  @Override
  public Long enableSpatializer(String channelTag, Boolean enable, Boolean applyToTeam) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.enableSpatializer(enable, applyToTeam);
    return (long) result;
  }

  @Override
  public Long setUpSpatializer(String channelTag) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    int result = channel.initSpatializer();
    return (long) result;
  }

  @Override
  public Long setSubscribeAudioBlocklist(String channelTag, List<Long> uidArray, Long streamType) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    long[] users = convertToLongArray(uidArray);
    NERtcAudioStreamType type = NERtcAudioStreamType.kNERtcAudioStreamTypeMain;
    if (streamType != null && streamType == 1) {
      type = NERtcAudioStreamType.kNERtcAudioStreamTypeSub;
    }
    int result = channel.setSubscribeAudioBlocklist(users, type);
    return (long) result;
  }

  @Override
  public Long setSubscribeAudioAllowlist(String channelTag, List<Long> uidArray) {
    NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(channelTag);
    if (channel == null) {
      Log.e(TAG, "channel is null");
      return -1L;
    }
    long[] users = convertToLongArray(uidArray);
    int result = channel.setSubscribeAudioAllowlist(users);
    return (long) result;
  }

  private void requestScreenCapture(@NonNull Activity activity) {
    MediaProjectionManager mediaProjectionManager =
        (MediaProjectionManager)
            applicationContext.getSystemService(Context.MEDIA_PROJECTION_SERVICE);
    if (mediaProjectionManager == null) {
      Log.e(TAG, "MediaProjectionManager is null");
      return;
    }
    Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
    this.screenCaptureIntent = captureIntent;
    activity.startActivityForResult(captureIntent, CAPTURE_PERMISSION_REQUEST_CODE);
  }

  private void requestLoopback(@NonNull Activity activity) {
    MediaProjectionManager mediaProjectionManager =
        (MediaProjectionManager)
            applicationContext.getSystemService(Context.MEDIA_PROJECTION_SERVICE);
    Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
    activity.startActivityForResult(captureIntent, LOOPBACK_PERMISSION_REQUEST_CODE);
  }

  private NERtcLiveStreamTaskInfo buildLiveStreamTaskInfo(
      Messages.AddOrUpdateLiveStreamTaskRequest request) {
    NERtcLiveStreamTaskInfo taskInfo = new NERtcLiveStreamTaskInfo();
    if (request.getTaskId() != null) {
      taskInfo.taskId = request.getTaskId();
    }
    if (request.getUrl() != null) {
      taskInfo.url = request.getUrl();
    }
    if (request.getServerRecordEnabled() != null) {
      taskInfo.serverRecordEnabled = request.getServerRecordEnabled();
    }
    if (request.getLiveMode() != null) {
      taskInfo.liveMode = FLTUtils.int2LiveStreamMode(request.getLiveMode().intValue());
    }

    NERtcLiveStreamLayout layout = new NERtcLiveStreamLayout();
    taskInfo.layout = layout;
    if (request.getLayoutWidth() != null) {
      layout.width = request.getLayoutWidth().intValue();
    }
    if (request.getLayoutHeight() != null) {
      layout.height = request.getLayoutHeight().intValue();
    }
    if (request.getLayoutBackgroundColor() != null) {
      layout.backgroundColor = request.getLayoutBackgroundColor().intValue();
    }

    if (request.getLayoutImageUrl() != null) {
      NERtcLiveStreamImageInfo imageInfo = new NERtcLiveStreamImageInfo();
      imageInfo.url = request.getLayoutImageUrl();
      if (request.getLayoutImageWidth() != null) {
        imageInfo.width = request.getLayoutImageWidth().intValue();
      }
      if (request.getLayoutImageHeight() != null) {
        imageInfo.height = request.getLayoutImageHeight().intValue();
      }
      if (request.getLayoutImageX() != null) {
        imageInfo.x = request.getLayoutImageX().intValue();
      }
      if (request.getLayoutImageY() != null) {
        imageInfo.y = request.getLayoutImageY().intValue();
      }
      layout.backgroundImg = imageInfo;
    }

    ArrayList<NERtcLiveStreamUserTranscoding> userTranscodingList = new ArrayList<>();
    if (request.getLayoutUserTranscodingList() != null) {
      ArrayList<Object> users = (ArrayList<Object>) request.getLayoutUserTranscodingList();
      for (Object obj : users) {
        if (!(obj instanceof Map)) {
          continue;
        }
        Map<?, ?> user = (Map<?, ?>) obj;
        NERtcLiveStreamUserTranscoding transcoding = new NERtcLiveStreamUserTranscoding();
        Object uid = user.get("uid");
        if (uid instanceof Number) {
          transcoding.uid = ((Number) uid).longValue();
        }
        Object videoPush = user.get("videoPush");
        if (videoPush instanceof Boolean) {
          transcoding.videoPush = (Boolean) videoPush;
        }
        Object audioPush = user.get("audioPush");
        if (audioPush instanceof Boolean) {
          transcoding.audioPush = (Boolean) audioPush;
        }
        Object adaption = user.get("adaption");
        if (adaption instanceof Number) {
          transcoding.adaption =
              FLTUtils.int2LiveStreamVideoScaleMode(((Number) adaption).intValue());
        }
        Object x = user.get("x");
        if (x instanceof Number) {
          transcoding.x = ((Number) x).intValue();
        }
        Object y = user.get("y");
        if (y instanceof Number) {
          transcoding.y = ((Number) y).intValue();
        }
        Object width = user.get("width");
        if (width instanceof Number) {
          transcoding.width = ((Number) width).intValue();
        }
        Object height = user.get("height");
        if (height instanceof Number) {
          transcoding.height = ((Number) height).intValue();
        }
        userTranscodingList.add(transcoding);
      }
    }
    layout.userTranscodingList = userTranscodingList;
    return taskInfo;
  }

  private long[] convertToLongArray(List<? extends Number> list) {
    if (list == null) {
      return new long[0];
    }
    long[] array = new long[list.size()];
    for (int i = 0; i < list.size(); i++) {
      array[i] = list.get(i).longValue();
    }
    return array;
  }

  private float[] convertToFloatArray(List<Double> list) {
    if (list == null) {
      return new float[0];
    }
    float[] array = new float[list.size()];
    for (int i = 0; i < list.size(); i++) {
      array[i] = list.get(i).floatValue();
    }
    return array;
  }
}
