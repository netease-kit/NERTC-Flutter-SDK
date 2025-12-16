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
import android.opengl.EGLContext;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.netease.lava.nertc.sdk.LastmileProbeConfig;
import com.netease.lava.nertc.sdk.NERtc;
import com.netease.lava.nertc.sdk.NERtcASRCaptionConfig;
import com.netease.lava.nertc.sdk.NERtcConstants;
import com.netease.lava.nertc.sdk.NERtcDataExternalFrame;
import com.netease.lava.nertc.sdk.NERtcEx;
import com.netease.lava.nertc.sdk.NERtcFeatureType;
import com.netease.lava.nertc.sdk.NERtcJoinChannelOptions;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam.ChannelMediaRelayConfiguration;
import com.netease.lava.nertc.sdk.NERtcMultiPathOption;
import com.netease.lava.nertc.sdk.NERtcOption;
import com.netease.lava.nertc.sdk.NERtcParameters;
import com.netease.lava.nertc.sdk.NERtcServerAddresses;
import com.netease.lava.nertc.sdk.NERtcVersion;
import com.netease.lava.nertc.sdk.NERtcVideoCorrectionConfiguration;
import com.netease.lava.nertc.sdk.audio.NERtcAudioAINSMode;
import com.netease.lava.nertc.sdk.audio.NERtcAudioExternalFrame;
import com.netease.lava.nertc.sdk.audio.NERtcAudioRecordingConfiguration;
import com.netease.lava.nertc.sdk.audio.NERtcAudioStreamType;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioEffectOption;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioMixingOption;
import com.netease.lava.nertc.sdk.audio.NERtcDistanceRolloffModel;
import com.netease.lava.nertc.sdk.audio.NERtcPositionInfo;
import com.netease.lava.nertc.sdk.audio.NERtcRangeAudioMode;
import com.netease.lava.nertc.sdk.audio.NERtcReverbParam;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerMaterialName;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRenderMode;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRoomCapacity;
import com.netease.lava.nertc.sdk.audio.NERtcSpatializerRoomProperty;
import com.netease.lava.nertc.sdk.cdn.NERtcPlayStreamingConfig;
import com.netease.lava.nertc.sdk.cdn.NERtcPushStreamingConfig;
import com.netease.lava.nertc.sdk.cdn.NERtcStreamingRoomInfo;
import com.netease.lava.nertc.sdk.channel.NERtcChannel;
import com.netease.lava.nertc.sdk.encryption.NERtcEncryptionConfig;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamImageInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamLayout;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding;
import com.netease.lava.nertc.sdk.video.NERtcBeautyEffectType;
import com.netease.lava.nertc.sdk.video.NERtcCameraCaptureConfig;
import com.netease.lava.nertc.sdk.video.NERtcEglContextWrapper;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoFrame;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamLayerCount;
import com.netease.lava.nertc.sdk.video.NERtcVideoStreamType;
import com.netease.lava.nertc.sdk.video.NERtcVirtualBackgroundSource;
import com.netease.lava.nertc.sdk.watermark.NERtcVideoWatermarkConfig;
import com.netease.lava.nertc.sdk.watermark.NERtcVideoWatermarkImageConfig;
import com.netease.lava.nertc.sdk.watermark.NERtcVideoWatermarkTextConfig;
import com.netease.lava.nertc.sdk.watermark.NERtcVideoWatermarkTimestampConfig;
import com.netease.lava.webrtc.EglBase;
import com.netease.lava.webrtc.EglBase10Impl;
import com.netease.lava.webrtc.EglBase14Impl;
import com.netease.nertcflutter.Messages.AddOrUpdateLiveStreamTaskRequest;
import com.netease.nertcflutter.Messages.AudioEffectApi;
import com.netease.nertcflutter.Messages.AudioMixingApi;
import com.netease.nertcflutter.Messages.CreateEngineRequest;
import com.netease.nertcflutter.Messages.DeleteLiveStreamTaskRequest;
import com.netease.nertcflutter.Messages.DeviceManagerApi;
import com.netease.nertcflutter.Messages.EngineApi;
import com.netease.nertcflutter.Messages.JoinChannelRequest;
import com.netease.nertcflutter.Messages.PlayEffectRequest;
import com.netease.nertcflutter.Messages.SetMultiPathOptionRequest;
import com.netease.nertcflutter.Messages.StartASRCaptionRequest;
import com.netease.nertcflutter.Messages.StartAudioMixingRequest;
import com.netease.nertcflutter.Messages.StartPlayStreamingRequest;
import com.netease.nertcflutter.Messages.StartPushStreamingRequest;
import com.netease.nertcflutter.Messages.VideoRendererApi;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NERtcEngine
    implements EngineApi, AudioEffectApi, AudioMixingApi, DeviceManagerApi, VideoRendererApi {

  private final NERtcCallbackImpl callback;

  private final NERtcStatsObserverImpl observer;

  private NERtcEglContextWrapper sharedEglContext = null;

  private final Context applicationContext;

  private final Messages.NERtcLiveStreamEventSink _liveEventSink;

  private AddActivityResultListener addActivityResultListener;

  private RemoveActivityResultListener removeActivityResultListener;

  private Activity activity;

  private static Intent sIntent;

  private final TextureRegistry registry;

  private final BinaryMessenger messenger;

  private final Map<Long, FlutterVideoRenderer> renderers = new HashMap<>();

  private Map<String, NERtcChannel> channelMaps = new HashMap<>();

  private CallbackMethod invokeMethod;

  boolean isInitialized = false;

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

  @FunctionalInterface
  interface CallbackMethod {
    void invokeMethod(@NonNull String method, @Nullable Object arguments);
  }

  NERtcEngine(
      @NonNull Context applicationContext,
      @NonNull BinaryMessenger messenger,
      @NonNull CallbackMethod method,
      @NonNull TextureRegistry registry) {
    this.invokeMethod = method;
    this.callback = new NERtcCallbackImpl(messenger);
    this.observer = new NERtcStatsObserverImpl(messenger, "");
    this.applicationContext = applicationContext;
    this.addActivityResultListener = null;
    this.removeActivityResultListener = null;
    this.activity = null;
    this.messenger = messenger;
    this.registry = registry;
    this._liveEventSink = new Messages.NERtcLiveStreamEventSink(messenger);
  }

  void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  void setActivityResultListener(
      @Nullable AddActivityResultListener addActivityResultListener,
      @Nullable RemoveActivityResultListener removeActivityResultListener) {
    this.addActivityResultListener = addActivityResultListener;
    this.removeActivityResultListener = removeActivityResultListener;
  }

  private static final int CAPTURE_PERMISSION_REQUEST_CODE = 11;
  private static final int LOOPBACK_PERMISSION_REQUEST_CODE = 12;

  static class ActivityResultListener implements PluginRegistry.ActivityResultListener {

    final SuccessCallback successCallback;
    final NERtcScreenConfig screenConfig;
    final RemoveActivityResultListener removeActivityResultListener;
    boolean alreadyCalled = false;

    ActivityResultListener(
        SuccessCallback successCallback,
        NERtcScreenConfig screenConfig,
        RemoveActivityResultListener removeActivityResultListener) {
      this.successCallback = successCallback;
      this.screenConfig = screenConfig;
      this.removeActivityResultListener = removeActivityResultListener;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
      if (removeActivityResultListener != null) removeActivityResultListener.removeListener(this);
      if (!alreadyCalled) {
        if (requestCode == CAPTURE_PERMISSION_REQUEST_CODE) {
          if (resultCode != Activity.RESULT_OK || data == null) {
            successCallback.onSuccess(-1);
          } else {
            sIntent = data;
            int ret =
                NERtcEx.getInstance()
                    .startScreenCapture(
                        screenConfig,
                        data,
                        new MediaProjection.Callback() {
                          @Override
                          public void onStop() {
                            super.onStop();
                            sIntent = null;
                          }
                        });
            successCallback.onSuccess(ret);
          }
        } else if (requestCode == LOOPBACK_PERMISSION_REQUEST_CODE) {
          sIntent = data;
          int ret =
              NERtcEx.getInstance()
                  .enableLoopbackRecording(
                      true,
                      data,
                      new MediaProjection.Callback() {
                        @Override
                        public void onStop() {
                          super.onStop();
                          sIntent = null;
                        }
                      });
        }
      }
      alreadyCalled = true;
      return false;
    }
  }

  /////////////////////////////  NERtcEngineApi ///////////////////////////////////////////
  @Override
  public Long create(CreateEngineRequest arg) {
    long result = -1L;
    if (applicationContext == null) {
      Log.e(
          "NERtcEngine",
          "Create RTC engine context is required to screen capture and cannot be null.");
      result = -1L;
      return result;
    }

    String appKey = arg.getAppKey();
    if (TextUtils.isEmpty(appKey)) {
      Log.e("NERtcEngine", "Create RTC engine error: app key is null");
      result = -2L;
      return result;
    }

    NERtcOption option = new NERtcOption();
    if (arg.getLogDir() != null) {
      option.logDir = arg.getLogDir();
    }
    if (arg.getLogLevel() != null) {
      option.logLevel = arg.getLogLevel().intValue();
    }
    final Messages.RtcServerAddresses addresses = arg.getServerAddresses();
    if (addresses != null && addresses.getValid() == Boolean.TRUE) {
      NERtcServerAddresses serverAddresses = new NERtcServerAddresses();
      serverAddresses.channelServer = addresses.getChannelServer();
      serverAddresses.statisticsServer = addresses.getStatisticsServer();
      serverAddresses.roomServer = addresses.getRoomServer();
      serverAddresses.compatServer = addresses.getCompatServer();
      serverAddresses.nosLbsServer = addresses.getNosLbsServer();
      serverAddresses.nosUploadSever = addresses.getNosUploadSever();
      serverAddresses.nosTokenServer = addresses.getNosTokenServer();
      serverAddresses.sdkConfigServer = addresses.getSdkConfigServer();
      serverAddresses.cloudProxyServer = addresses.getCloudProxyServer();
      serverAddresses.webSocketProxyServer = addresses.getWebSocketProxyServer();
      serverAddresses.quicProxyServer = addresses.getQuicProxyServer();
      serverAddresses.mediaProxyServer = addresses.getMediaProxyServer();
      serverAddresses.statisticsDispatchServer = addresses.getStatisticsDispatchServer();
      serverAddresses.statisticsBackupServer = addresses.getStatisticsBackupServer();
      serverAddresses.useIPv6 = addresses.getUseIPv6() == Boolean.TRUE;
      option.serverAddresses = serverAddresses;
    }

    sharedEglContext = NERtcEglContextWrapper.createEglContext();
    option.eglContext = sharedEglContext.getEglContext();
    NERtcParameters parameters = new NERtcParameters();
    // 标记为flutter
    parameters.setInteger(
        (NERtcParameters.Key<Integer>)
            NERtcParameters.Key.createSpecializedKey("sdk.business.scenario.type"),
        7);

    //Audio
    if (arg.getAudioAutoSubscribe() != null) {
      parameters.setBoolean(NERtcParameters.KEY_AUTO_SUBSCRIBE_AUDIO, arg.getAudioAutoSubscribe());
    }
    if (arg.getAudioAINSEnabled() != null) {
      parameters.setBoolean(NERtcParameters.KEY_AUDIO_AI_NS_ENABLE, arg.getAudioAINSEnabled());
    }
    // 默认打开静音时本地音量上报
    // parameters.setBoolean(NERtcParameters.KEY_ENABLE_REPORT_VOLUME_WHEN_MUTE, true);

    //Video
    if (arg.getVideoEncodeMode() != null) {
      parameters.setString(
          NERtcParameters.KEY_VIDEO_ENCODE_MODE,
          FLTUtils.int2VideoEncodeDecodeMode(arg.getVideoEncodeMode().intValue()));
    }
    if (arg.getVideoDecodeMode() != null) {
      parameters.setString(
          NERtcParameters.KEY_VIDEO_DECODE_MODE,
          FLTUtils.int2VideoEncodeDecodeMode(arg.getVideoDecodeMode().intValue()));
    }
    if (arg.getVideoSendMode() != null) {
      parameters.setInteger(NERtcParameters.KEY_VIDEO_SEND_MODE, arg.getVideoSendMode().intValue());
    }
    if (arg.getVideoAutoSubscribe() != null) {
      parameters.setBoolean(NERtcParameters.KEY_AUTO_SUBSCRIBE_VIDEO, arg.getVideoAutoSubscribe());
    }
    //        if (arg.getVideoH265Enabled() != null) {
    //            parameters.setBoolean(NERtcParameters.KEY_H265_SWITCH, arg.getVideoH265Enabled());
    //        }

    //录制
    if (arg.getServerRecordAudio() != null) {
      parameters.setBoolean(NERtcParameters.KEY_SERVER_RECORD_AUDIO, arg.getServerRecordAudio());
    }
    if (arg.getServerRecordVideo() != null) {
      parameters.setBoolean(NERtcParameters.KEY_SERVER_RECORD_VIDEO, arg.getServerRecordVideo());
    }
    if (arg.getServerRecordMode() != null) {
      parameters.setInteger(
          NERtcParameters.KEY_SERVER_RECORD_MODE, arg.getServerRecordMode().intValue());
    }
    if (arg.getServerRecordSpeaker() != null) {
      parameters.setBoolean(
          NERtcParameters.KEY_SERVER_RECORD_SPEAKER, arg.getServerRecordSpeaker());
    }

    //其他参数
    //    if (arg.getPublishSelfStream() != null) {
    //      parameters.setBoolean(NERtcParameters.KEY_PUBLISH_SELF_STREAM, arg.getPublishSelfStream());
    //    }
    if (arg.getDisableFirstJoinUserCreateChannel() != null) {
      parameters.setBoolean(
          NERtcParameters.KEY_DISABLE_FIRST_USER_CREATE_CHANNEL,
          arg.getDisableFirstJoinUserCreateChannel());
    }

    try {
      NERtcEx.getInstance().setParameters(parameters);
      NERtcEx.getInstance().init(applicationContext, appKey, callback, option);
      isInitialized = true;
      result = 0L;
    } catch (Exception e) {
      Log.e("NERtcEngine", "Create RTC engine exception:" + e.toString());
      result = -3L;
    }
    return result;
  }

  @NonNull
  @Override
  public Long createChannel(@NonNull String channelName) {
    return NERtcChannelManager.getInstance().createChannel(channelName);
  }

  @NonNull
  @Override
  public Messages.NERtcVersion version() {
    NERtcVersion version = NERtcEx.version();
    Messages.NERtcVersion rtcVersion = new Messages.NERtcVersion();
    rtcVersion.setVersionCode((long) version.versionCode);
    rtcVersion.setVersionName(version.versionName);
    rtcVersion.setBuildBranch(version.buildBranch);
    rtcVersion.setBuildDate(version.buildDate);
    rtcVersion.setBuildHost(version.buildHost);
    rtcVersion.setBuildType(version.buildType);
    rtcVersion.setBuildRevision(version.buildRevision);
    rtcVersion.setEngineRevision(version.engineRevision);
    rtcVersion.setServerEnv(version.serverEnv);
    return rtcVersion;
  }

  @NonNull
  @Override
  public List<String> checkPermission() {
    List<String> list = new ArrayList<>();
    list = NERtcEx.getInstance().checkPermission(applicationContext);
    return list;
  }

  @NonNull
  @Override
  public Long setParameters(@Nullable Map<String, Object> params) {
    long result = -1L;
    NERtcParameters parameters = new NERtcParameters();
    //Audio
    if (params.containsKey("key_auto_subscribe_audio")) {
      parameters.setBoolean(
          NERtcParameters.KEY_AUTO_SUBSCRIBE_AUDIO,
          (Boolean) params.get("key_auto_subscribe_video"));
    }
    if (params.containsKey("key_auto_subscribe_video")) {
      parameters.setBoolean(
          NERtcParameters.KEY_AUTO_SUBSCRIBE_VIDEO,
          (Boolean) params.get("key_auto_subscribe_video"));
    }
    if (params.containsKey("key_enable_report_volume_when_mute")) {
      parameters.setBoolean(
          NERtcParameters.KEY_ENABLE_REPORT_VOLUME_WHEN_MUTE,
          (Boolean) params.get("key_enable_report_volume_when_mute"));
    }

    //Video
    if (params.containsKey("key_video_encode_mode")) {
      parameters.setString(
          NERtcParameters.KEY_VIDEO_ENCODE_MODE, params.get("key_video_encode_mode").toString());
    }
    if (params.containsKey("key_video_decode_mode")) {
      parameters.setString(
          NERtcParameters.KEY_VIDEO_DECODE_MODE, params.get("key_video_decode_mode").toString());
    }
    if (params.containsKey("key_video_send_mode")) {
      parameters.setInteger(
          NERtcParameters.KEY_VIDEO_SEND_MODE, (Integer) params.get("key_video_send_mode"));
    }
    if (params.containsKey("key_auto_subscribe_video")) {
      parameters.setBoolean(
          NERtcParameters.KEY_AUTO_SUBSCRIBE_VIDEO,
          (Boolean) params.get("key_auto_subscribe_video"));
    }
    if (params.containsKey("key_disable_video_decoder")) {
      parameters.setBoolean(
          NERtcParameters.KEY_DISABLE_VIDEO_DECODER,
          (Boolean) params.get("key_disable_video_decoder"));
    }

    //record
    if (params.containsKey("key_server_record_audio")) {
      parameters.setBoolean(
          NERtcParameters.KEY_SERVER_RECORD_AUDIO, (Boolean) params.get("key_server_record_audio"));
    }
    if (params.containsKey("key_server_record_video")) {
      parameters.setBoolean(
          NERtcParameters.KEY_SERVER_RECORD_VIDEO, (Boolean) params.get("key_server_record_video"));
    }
    if (params.containsKey("key_server_record_mode")) {
      parameters.setInteger(
          NERtcParameters.KEY_SERVER_RECORD_MODE, (Integer) params.get("key_server_record_mode"));
    }
    if (params.containsKey("key_server_record_speaker")) {
      parameters.setBoolean(
          NERtcParameters.KEY_SERVER_RECORD_SPEAKER,
          (Boolean) params.get("key_server_record_speaker"));
    }

    //其他参数
    if (params.containsKey("key_video_local_preview_mirror")) {
      parameters.setBoolean(
          NERtcParameters.KEY_VIDEO_LOCAL_PREVIEW_MIRROR,
          (Boolean) params.get("key_video_local_preview_mirror"));
    }
    if (params.containsKey("key_audio_bluetooth_sco")) {
      parameters.setBoolean(
          NERtcParameters.KEY_AUDIO_BLUETOOTH_SCO, (Boolean) params.get("key_audio_bluetooth_sco"));
    }
    if (params.containsKey("key_video_camera_type")) {
      parameters.setInteger(
          NERtcParameters.KEY_VIDEO_CAMERA_TYPE, (Integer) params.get("key_video_camera_type"));
    }
    if (params.containsKey("key_enable_1v1_mode")) {
      parameters.setBoolean(
          NERtcParameters.KEY_ENABLE_1V1_MODEL, (Boolean) params.get("key_enable_1v1_mode"));
    }
    if (params.containsKey("key_enable_negative_uid")) {
      parameters.setBoolean(
          NERtcParameters.KEY_ENABLE_NEGATIVE_UID, (Boolean) params.get("key_enable_negative_uid"));
    }
    if (params.containsKey("key_custom_extra_info")) {
      parameters.setString(
          NERtcParameters.KEY_CUSTOM_EXTRA_INFO, params.get("key_custom_extra_info").toString());
    }
    if (params.containsKey("key_enable_1v1_mode")) {
      parameters.setBoolean(
          NERtcParameters.KEY_ENABLE_1V1_MODEL, (Boolean) params.get("key_enable_1v1_mode"));
    }
    if (params.containsKey("sdk.getChannelInfo.custom.data")) {
      parameters.setString(
          NERtcParameters.KEY_LOGIN_CUSTOM_DATA,
          params.get("sdk.getChannelInfo.custom.data").toString());
    }
    if (params.containsKey("key_media_server_uri")) {
      NERtcParameters.Key mediaServerUri =
          NERtcParameters.Key.createSpecializedKey("key_media_server_uri");
      parameters.setString(mediaServerUri, params.get("key_media_server_uri").toString());
    }
    if (params.containsKey("key_test_server_uri")) {
      Boolean enableDevEnv = true;
      NERtcParameters.Key enableDevEnvPram =
          NERtcParameters.Key.createSpecializedKey("key_test_server_uri");
      parameters.set(enableDevEnvPram, enableDevEnv);
    }
    if (params.containsKey("sdk.enable.encrypt.log")) {
      NERtcParameters.Key enableEncrypt =
          NERtcParameters.Key.createSpecializedKey("sdk.enable.encrypt.log");
      parameters.set(enableEncrypt, (Boolean) params.get("sdk.enable.encrypt.log"));
    }
    if (params.containsKey("key_disable_first_user_create_channel")) {
      parameters.setBoolean(
          NERtcParameters.KEY_DISABLE_FIRST_USER_CREATE_CHANNEL,
          (Boolean) params.get("key_disable_first_user_create_channel"));
    }
    if (params.containsKey("key_start_with_back_camera")) {
      parameters.setBoolean(
          NERtcParameters.KEY_START_WITH_BACK_CAMERA,
          (Boolean) params.get("key_start_with_back_camera"));
    }

    if (params.containsKey("key_audio_ai_ns_enable")) {
      parameters.setBoolean(
          NERtcParameters.KEY_AUDIO_AI_NS_ENABLE, (Boolean) params.get("key_audio_ai_ns_enable"));
    }

    try {
      NERtc.getInstance().setParameters(parameters);
      result = 0;

    } catch (IllegalArgumentException e) {
      result = -1;
    }
    return result;
  }

  @Override
  public void release(Messages.Result<Long> result) {
    NERtcEx.getInstance().setStatsObserver(null);
    NERtcEx.getInstance().setAudioProcessObserver(null);
    NERtc.getInstance().release();
    NERtcChannelManager.getInstance().releaseAll();
    isInitialized = false;
    if (sharedEglContext != null) {
      sharedEglContext.release();
      sharedEglContext = null;
    }
    Long value = 0L;
    result.success(value);
  }

  @NonNull
  @Override
  public Long setStatsEventCallback() {
    NERtcEx.getInstance().setStatsObserver(this.observer);
    return 0L;
  }

  @NonNull
  @Override
  public Long clearStatsEventCallback() {
    NERtcEx.getInstance().setStatsObserver(null);
    return 0L;
  }

  @Override
  public Long setChannelProfile(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setChannelProfile(arg.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long joinChannel(@NonNull JoinChannelRequest request) {
    long result = -1L;
    int ret = -1;
    if (request.getChannelOptions() != null) {
      NERtcJoinChannelOptions options = new NERtcJoinChannelOptions();
      if (request.getChannelOptions().getCustomInfo() != null) {
        options.customInfo = request.getChannelOptions().getCustomInfo();
      }
      if (request.getChannelOptions().getPermissionKey() != null) {
        options.permissionKey = request.getChannelOptions().getPermissionKey();
      }
      ret =
          NERtcEx.getInstance()
              .joinChannel(request.getToken(), request.getChannelName(), request.getUid(), options);
    } else {
      ret =
          NERtcEx.getInstance()
              .joinChannel(request.getToken(), request.getChannelName(), request.getUid());
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long leaveChannel() {
    long result = -1L;
    int ret = NERtcEx.getInstance().leaveChannel();
    result = (long) ret;
    return result;
  }

  @Override
  public Long updatePermissionKey(@NonNull String key) {
    long result = -1L;
    int ret = NERtcEx.getInstance().updatePermissionKey(key);
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableLocalAudio(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().enableLocalAudio(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Long subscribeRemoteAudio(Messages.SubscribeRemoteAudioRequest arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().subscribeRemoteAudioStream(arg.getUid(), arg.getSubscribe());
    result = (long) ret;
    return result;
  }

  @Override
  public Long subscribeAllRemoteAudio(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().subscribeAllRemoteAudioStreams(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioProfile(Messages.SetAudioProfileRequest arg) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .setAudioProfile(arg.getProfile().intValue(), arg.getScenario().intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableDualStreamMode(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().enableDualStreamMode(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Long setCameraCaptureConfig(Messages.SetCameraCaptureConfigRequest arg) {
    long result = -1L;
    int ret;
    NERtcCameraCaptureConfig config = new NERtcCameraCaptureConfig();
    switch (arg.getExtraRotation()) {
      case K_NERTC_CAPTURE_EXTRA_ROTATION180:
        config.extraRotation =
            NERtcCameraCaptureConfig.NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_180;
        break;
      case K_NERTC_CAPTURE_EXTRA_ROTATION_CLOCK_WISE90:
        config.extraRotation =
            NERtcCameraCaptureConfig.NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_CLOCKWISE_90;
        break;
      case K_NERTC_CAPTURE_EXTRA_ROTATION_ANTI_CLOCK_WISE90:
        config.extraRotation =
            NERtcCameraCaptureConfig.NERtcCaptureExtraRotation
                .CAPTURE_EXTRA_ROTATION_ANTICLOCKWISE_90;
        break;
      default:
        config.extraRotation =
            NERtcCameraCaptureConfig.NERtcCaptureExtraRotation.CAPTURE_EXTRA_ROTATION_DEFAULT;
        break;
    }
    config.captureWidth = arg.getCaptureWidth().intValue();
    config.captureHeight = arg.getCaptureHeight().intValue();
    if (arg.getStreamType() == null) {
      ret = NERtcEx.getInstance().setCameraCaptureConfig(config);
    } else {
      NERtcVideoStreamType streamType =
          FLTUtils.int2VideoStreamType(arg.getStreamType().intValue());
      ret = NERtcEx.getInstance().setCameraCaptureConfig(config, streamType);
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long setVideoRotationMode(Long rotationMode) {
    return 30005L;
  }

  @Override
  public Long setLocalVideoConfig(Messages.SetLocalVideoConfigRequest arg) {
    long result = -1L;
    int ret;
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
    if (arg.getStreamType() == null) {
      ret = NERtcEx.getInstance().setLocalVideoConfig(config);
    } else {
      NERtcVideoStreamType streamType =
          FLTUtils.int2VideoStreamType(arg.getStreamType().intValue());
      ret = NERtcEx.getInstance().setLocalVideoConfig(config, streamType);
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long startVideoPreview(Messages.StartorStopVideoPreviewRequest arg) {
    long result = -1L;
    int ret = 0;
    if (arg.getStreamType() == null) {
      ret = NERtcEx.getInstance().startVideoPreview();
    } else {
      ret =
          NERtcEx.getInstance()
              .startVideoPreview(FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()));
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopVideoPreview(Messages.StartorStopVideoPreviewRequest arg) {
    long result = -1L;
    int ret = 0;
    if (arg.getStreamType() == null) {
      ret = NERtcEx.getInstance().stopVideoPreview();
    } else {
      ret =
          NERtcEx.getInstance()
              .stopVideoPreview(FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()));
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableLocalVideo(Messages.EnableLocalVideoRequest arg) {
    long result = -1L;
    int ret = 0;
    if (arg.getStreamType() == null) {
      ret = NERtcEx.getInstance().enableLocalVideo(arg.getEnable());
    } else {
      ret =
          NERtcEx.getInstance()
              .enableLocalVideo(
                  FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()), arg.getEnable());
    }
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long enableLocalSubStreamAudio(@NonNull Boolean enable) {
    long result = -1L;
    int ret = NERtcEx.getInstance().enableLocalSubStreamAudio(enable);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long subscribeRemoteSubStreamAudio(
      @NonNull Messages.SubscribeRemoteSubStreamAudioRequest request) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .subscribeRemoteSubStreamAudio(request.getUid(), request.getSubscribe());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long muteLocalSubStreamAudio(@NonNull Boolean muted) {
    long result = -1L;
    int ret = NERtcEx.getInstance().muteLocalSubStreamAudio(muted);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setAudioSubscribeOnlyBy(@NonNull Messages.SetAudioSubscribeOnlyByRequest request) {
    long result = -1L;
    int ret = -1;
    if (request.getUidArray() != null) {
      List<? extends Number> list = request.getUidArray();
      long[] param = new long[list.size()];
      for (int i = 0; i < list.size(); i++) {
        param[i] = ((Number) list.get(i)).longValue();
      }
      ret = NERtcEx.getInstance().setAudioSubscribeOnlyBy(param);
    } else {
      long[] param = new long[0];
      ret = NERtcEx.getInstance().setAudioSubscribeOnlyBy(param);
    }
    result = (long) ret;
    return result;
  }

  private void requestScreenCapture(
      @NonNull Context applicationContext, @NonNull Activity activity) {
    MediaProjectionManager mediaProjectionManager =
        (MediaProjectionManager)
            applicationContext.getSystemService(Context.MEDIA_PROJECTION_SERVICE);
    Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
    activity.startActivityForResult(captureIntent, CAPTURE_PERMISSION_REQUEST_CODE);
  }

  private void requestLoopback(@NonNull Context applicationContext, @NonNull Activity activity) {
    MediaProjectionManager mediaProjectionManager =
        (MediaProjectionManager)
            applicationContext.getSystemService(Context.MEDIA_PROJECTION_SERVICE);
    Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
    activity.startActivityForResult(captureIntent, LOOPBACK_PERMISSION_REQUEST_CODE);
  }

  @Override
  public void startScreenCapture(
      Messages.StartScreenCaptureRequest arg, Messages.Result<Long> result) {
    if (activity == null) {
      Log.e(
          "NERtcEngine",
          "startScreenCapture error: "
              + "Android activity is required to screen capture and cannot be null.");
      Long value = -2L;
      result.success(value);
      return;
    }
    if (addActivityResultListener == null) {
      Log.e(
          "NERtcEngine",
          "startScreenCapture error: "
              + "Activity result listener is required to screen capture and cannot be null.");
      Long value = -3L;
      result.success(value);
      return;
    }
    if (removeActivityResultListener == null) {
      Log.e(
          "NERtcEngine",
          "startScreenCapture error: "
              + "Activity result listener is required to screen capture and cannot be null.");
      Long value = -4L;
      result.success(value);
      return;
    }

    NERtcScreenConfig config = new NERtcScreenConfig();
    config.bitrate = arg.getBitrate().intValue();
    config.contentPrefer = FLTUtils.int2SubStreamContentPrefer(arg.getContentPrefer().intValue());
    config.frameRate = FLTUtils.int2VideoFrameRate(arg.getFrameRate().intValue());
    config.minBitrate = arg.getMinBitrate().intValue();
    config.minFramerate = arg.getMinFrameRate().intValue();
    config.videoProfile = arg.getVideoProfile().intValue();

    if (sIntent == null) {
      ActivityResultListener activityResultListener =
          new ActivityResultListener(
              result1 -> {
                Long value = result1;
                result.success(value);
              },
              config,
              removeActivityResultListener);
      addActivityResultListener.addListener(activityResultListener);
      requestScreenCapture(applicationContext, activity);
    } else {
      int ret =
          NERtcEx.getInstance()
              .startScreenCapture(
                  config,
                  sIntent,
                  new MediaProjection.Callback() {
                    @Override
                    public void onStop() {
                      super.onStop();
                      sIntent = null;
                    }
                  });
      result.success(0L);
    }
  }

  @Override
  public Long stopScreenCapture() {
    long result = -1L;
    NERtcEx.getInstance().stopScreenCapture();
    result = 0L;
    return result;
  }

  @NonNull
  @Override
  public Long enableLoopbackRecording(@NonNull Boolean enable) {
    long result = -1L;
    int ret = -1;
    if (activity == null) {
      Log.e(
          "NERtcEngine",
          "enableLoopbackRecording error: "
              + "Android activity is required to screen capture and cannot be null.");
      Long value = -2L;
      return value;
    }
    if (addActivityResultListener == null) {
      Log.e(
          "NERtcEngine",
          "enableLoopbackRecording error: "
              + "Activity result listener is required to screen capture and cannot be null.");
      Long value = -3L;
      return value;
    }
    if (removeActivityResultListener == null) {
      Log.e(
          "NERtcEngine",
          "enableLoopbackRecording error: "
              + "Activity result listener is required to screen capture and cannot be null.");
      Long value = -4L;
      return value;
    }

    MediaProjection.Callback projCallback =
        new MediaProjection.Callback() {
          @Override
          public void onStop() {
            super.onStop();
            sIntent = null;
          }
        };

    if (sIntent != null) {
      ret = NERtcEx.getInstance().enableLoopbackRecording(enable, sIntent, projCallback);
    } else {
      ActivityResultListener activityResultListener =
          new ActivityResultListener(null, null, removeActivityResultListener);
      addActivityResultListener.addListener(activityResultListener);
      requestLoopback(applicationContext, activity);
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long subscribeRemoteSubStreamVideo(Messages.SubscribeRemoteSubStreamVideoRequest arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().subscribeRemoteSubStreamVideo(arg.getUid(), arg.getSubscribe());
    result = (long) ret;
    return result;
  }

  @Override
  public Long subscribeRemoteVideoStream(Messages.SubscribeRemoteVideoStreamRequest arg) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .subscribeRemoteVideoStream(
                arg.getUid(),
                FLTUtils.int2RemoteVideoStreamType(arg.getStreamType().intValue()),
                arg.getSubscribe());
    result = (long) ret;
    return result;
  }

  @Override
  public Long muteLocalAudioStream(Boolean mute) {
    long result = -1L;
    int ret = NERtcEx.getInstance().muteLocalAudioStream(mute);
    result = (long) ret;
    return result;
  }

  @Override
  public Long muteLocalVideoStream(Boolean mute, Long type) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .muteLocalVideoStream(FLTUtils.int2VideoStreamType(type.intValue()), mute);
    result = (long) ret;
    return result;
  }

  @Override
  public Long startAudioDump() {
    long result = -1L;
    int ret = NERtcEx.getInstance().startAudioDump();
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long startAudioDumpWithType(@NonNull Long dumpType) {
    long result = -1L;
    int ret = NERtcEx.getInstance().startAudioDumpWithType(dumpType.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopAudioDump() {
    long result = -1L;
    int ret = NERtcEx.getInstance().stopAudioDump();
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableAudioVolumeIndication(Messages.EnableAudioVolumeIndicationRequest arg) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .enableAudioVolumeIndication(
                arg.getEnable(), arg.getInterval().intValue(), arg.getVad());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long adjustRecordingSignalVolume(Long volume) {
    long result = -1L;
    int ret = NERtcEx.getInstance().adjustRecordingSignalVolume(volume.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long adjustPlaybackSignalVolume(Long volume) {
    long result = -1L;
    int ret = NERtcEx.getInstance().adjustPlaybackSignalVolume(volume.intValue());
    result = (long) ret;
    ;
    return result;
  }

  @NonNull
  @Override
  public Long adjustLoopBackRecordingSignalVolume(@NonNull Long volume) {
    long result = -1L;
    int ret = NERtcEx.getInstance().adjustLoopBackRecordingSignalVolume(volume.intValue());
    result = (long) ret;
    ;
    return result;
  }

  @NonNull
  @Override
  public Long addLiveStreamTask(AddOrUpdateLiveStreamTaskRequest arg) {
    NERtcLiveStreamTaskInfo taskInfo = new NERtcLiveStreamTaskInfo();
    Long serial = arg.getSerial();
    if (arg.getTaskId() != null) {
      taskInfo.taskId = arg.getTaskId();
    }
    if (arg.getUrl() != null) {
      taskInfo.url = arg.getUrl();
    }
    if (arg.getServerRecordEnabled() != null) {
      taskInfo.serverRecordEnabled = arg.getServerRecordEnabled();
    }
    if (arg.getLiveMode() != null) {
      taskInfo.liveMode = FLTUtils.int2LiveStreamMode(arg.getLiveMode().intValue());
    }
    NERtcLiveStreamLayout layout = new NERtcLiveStreamLayout();
    taskInfo.layout = layout;
    if (arg.getLayoutWidth() != null) {
      layout.width = arg.getLayoutWidth().intValue();
    }
    if (arg.getLayoutHeight() != null) {
      layout.height = arg.getLayoutHeight().intValue();
    }
    if (arg.getLayoutBackgroundColor() != null) {
      layout.backgroundColor = arg.getLayoutBackgroundColor().intValue();
    }
    NERtcLiveStreamImageInfo imageInfo = new NERtcLiveStreamImageInfo();
    if (arg.getLayoutImageUrl() != null) {
      imageInfo.url = arg.getLayoutImageUrl();
      //服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
      layout.backgroundImg = imageInfo;
    }
    if (arg.getLayoutImageWidth() != null) {
      imageInfo.width = arg.getLayoutImageWidth().intValue();
    }
    if (arg.getLayoutImageHeight() != null) {
      imageInfo.height = arg.getLayoutHeight().intValue();
    }
    if (arg.getLayoutImageX() != null) {
      imageInfo.x = arg.getLayoutImageX().intValue();
    }
    if (arg.getLayoutImageY() != null) {
      imageInfo.y = arg.getLayoutImageY().intValue();
    }
    ArrayList<NERtcLiveStreamUserTranscoding> userTranscodingList = new ArrayList<>();
    layout.userTranscodingList = userTranscodingList;
    if (arg.getLayoutUserTranscodingList() != null) {
      ArrayList<Object> userList = (ArrayList<Object>) arg.getLayoutUserTranscodingList();
      for (Object obj : userList) {
        Map<String, Object> user = (Map<String, Object>) obj;
        NERtcLiveStreamUserTranscoding userTranscoding = new NERtcLiveStreamUserTranscoding();
        Object uid = user.get("uid");
        if (uid instanceof Number) {
          userTranscoding.uid = ((Number) uid).longValue();
        }
        Object videoPush = user.get("videoPush");
        if (videoPush instanceof Boolean) {
          userTranscoding.videoPush = (Boolean) videoPush;
        }
        Object audioPush = user.get("audioPush");
        if (audioPush instanceof Boolean) {
          userTranscoding.audioPush = (Boolean) audioPush;
        }
        Object adaption = user.get("adaption");
        if (adaption instanceof Number) {
          userTranscoding.adaption =
              FLTUtils.int2LiveStreamVideoScaleMode(((Number) adaption).intValue());
        }
        Object x = user.get("x");
        if (x instanceof Number) {
          userTranscoding.x = ((Number) x).intValue();
        }
        Object y = user.get("y");
        if (y instanceof Number) {
          userTranscoding.y = ((Number) y).intValue();
        }
        Object width = user.get("width");
        if (width instanceof Number) {
          userTranscoding.width = ((Number) width).intValue();
        }
        Object height = user.get("height");
        if (height instanceof Number) {
          userTranscoding.height = ((Number) height).intValue();
        }
        userTranscodingList.add(userTranscoding);
      }
    }
    int ret =
        NERtcEx.getInstance()
            .addLiveStreamTask(
                taskInfo,
                (taskId, errorCode) -> {
                  _liveEventSink.onAddLiveStreamTask(
                      taskId,
                      (long) errorCode,
                      new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                        @Override
                        public void reply(Void aVoid) {
                          // 实现reply方法
                        }
                      });
                });
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long updateLiveStreamTask(AddOrUpdateLiveStreamTaskRequest arg) {
    NERtcLiveStreamTaskInfo taskInfo = new NERtcLiveStreamTaskInfo();
    Long serial = arg.getSerial();
    if (arg.getTaskId() != null) {
      taskInfo.taskId = arg.getTaskId();
    }
    if (arg.getUrl() != null) {
      taskInfo.url = arg.getUrl();
    }
    if (arg.getServerRecordEnabled() != null) {
      taskInfo.serverRecordEnabled = arg.getServerRecordEnabled();
    }
    if (arg.getLiveMode() != null) {
      taskInfo.liveMode = FLTUtils.int2LiveStreamMode(arg.getLiveMode().intValue());
    }
    NERtcLiveStreamLayout layout = new NERtcLiveStreamLayout();
    taskInfo.layout = layout;
    if (arg.getLayoutWidth() != null) {
      layout.width = arg.getLayoutWidth().intValue();
    }
    if (arg.getLayoutHeight() != null) {
      layout.height = arg.getLayoutHeight().intValue();
    }
    if (arg.getLayoutBackgroundColor() != null) {
      layout.backgroundColor = arg.getLayoutBackgroundColor().intValue();
    }
    NERtcLiveStreamImageInfo imageInfo = new NERtcLiveStreamImageInfo();
    if (arg.getLayoutImageUrl() != null) {
      imageInfo.url = arg.getLayoutImageUrl();
      //服务器根据Url来判断Image Info 是否合法, 不合法情况下不能有Image节点参数
      layout.backgroundImg = imageInfo;
    }
    if (arg.getLayoutImageWidth() != null) {
      imageInfo.width = arg.getLayoutImageWidth().intValue();
    }
    if (arg.getLayoutImageHeight() != null) {
      imageInfo.height = arg.getLayoutHeight().intValue();
    }
    if (arg.getLayoutImageX() != null) {
      imageInfo.x = arg.getLayoutImageX().intValue();
    }
    if (arg.getLayoutImageY() != null) {
      imageInfo.y = arg.getLayoutImageY().intValue();
    }
    ArrayList<NERtcLiveStreamUserTranscoding> userTranscodingList = new ArrayList<>();
    layout.userTranscodingList = userTranscodingList;
    if (arg.getLayoutUserTranscodingList() != null) {
      ArrayList<Object> userList = (ArrayList<Object>) arg.getLayoutUserTranscodingList();
      for (Object obj : userList) {
        Map<String, Object> user = (Map<String, Object>) obj;
        NERtcLiveStreamUserTranscoding userTranscoding = new NERtcLiveStreamUserTranscoding();
        Object uid = user.get("uid");
        if (uid instanceof Number) {
          userTranscoding.uid = ((Number) uid).longValue();
        }
        Object videoPush = user.get("videoPush");
        if (videoPush instanceof Boolean) {
          userTranscoding.videoPush = (Boolean) videoPush;
        }
        Object audioPush = user.get("audioPush");
        if (audioPush instanceof Boolean) {
          userTranscoding.audioPush = (Boolean) audioPush;
        }
        Object adaption = user.get("adaption");
        if (adaption instanceof Number) {
          userTranscoding.adaption =
              FLTUtils.int2LiveStreamVideoScaleMode(((Number) adaption).intValue());
        }
        Object x = user.get("x");
        if (x instanceof Number) {
          userTranscoding.x = ((Number) x).intValue();
        }
        Object y = user.get("y");
        if (y instanceof Number) {
          userTranscoding.y = ((Number) y).intValue();
        }
        Object width = user.get("width");
        if (width instanceof Number) {
          userTranscoding.width = ((Number) width).intValue();
        }
        Object height = user.get("height");
        if (height instanceof Number) {
          userTranscoding.height = ((Number) height).intValue();
        }
        userTranscodingList.add(userTranscoding);
      }
    }
    int ret =
        NERtcEx.getInstance()
            .updateLiveStreamTask(
                taskInfo,
                (taskId, errorCode) -> {
                  _liveEventSink.onUpdateLiveStreamTask(
                      taskId,
                      (long) errorCode,
                      new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                        @Override
                        public void reply(Void aVoid) {
                          // 实现reply方法
                        }
                      });
                });
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long removeLiveStreamTask(DeleteLiveStreamTaskRequest arg) {
    long result = -1L;
    Long serial = arg.getSerial();
    int ret =
        NERtcEx.getInstance()
            .removeLiveStreamTask(
                arg.getTaskId(),
                (taskId, errorCode) -> {
                  _liveEventSink.onDeleteLiveStreamTask(
                      taskId,
                      (long) errorCode,
                      new Messages.NERtcLiveStreamEventSink.Reply<Void>() {
                        @Override
                        public void reply(Void aVoid) {
                          // 实现reply方法
                        }
                      });
                });
    result = (long) ret;
    return result;
  }

  @Override
  public Long setClientRole(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setClientRole(FLTUtils.int2UserRole(arg.intValue()));
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long getConnectionState() {
    int ret = NERtcEx.getInstance().getConnectionState();
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long uploadSdkInfo() {
    long result = -1L;
    if (!isInitialized) {
      return result;
    }
    NERtcEx.getInstance().uploadSdkInfo();
    result = (long) 0;
    return result;
  }

  @NonNull
  @Override
  public Long switchChannel(Messages.SwitchChannelRequest arg) {
    NERtcJoinChannelOptions options = new NERtcJoinChannelOptions();
    if (arg.getChannelOptions() != null) {
      options.customInfo = arg.getChannelOptions().getCustomInfo();
    }
    if (arg.getChannelOptions() != null) {
      options.permissionKey = arg.getChannelOptions().getPermissionKey();
    }
    int ret = NERtcEx.getInstance().switchChannel(arg.getToken(), arg.getChannelName(), options);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long startAudioRecording(Messages.StartAudioRecordingRequest arg) {
    int ret = -1;
    if (arg.getSampleRate() != null && arg.getQuality() != null) {
      ret =
          NERtcEx.getInstance()
              .startAudioRecording(
                  arg.getFilePath(), arg.getSampleRate().intValue(), arg.getQuality().intValue());
    }
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long startAudioRecordingWithConfig(
      @NonNull Messages.AudioRecordingConfigurationRequest request) {
    NERtcAudioRecordingConfiguration config = new NERtcAudioRecordingConfiguration();
    config.recordFilePath = request.getFilePath();
    if (request.getSampleRate() != null) {
      config.recordSampleRate = request.getSampleRate().intValue();
    }
    if (request.getQuality() != null) {
      config.recordQuality = request.getQuality().intValue();
    }
    if (request.getPosition() != null) {
      switch (request.getPosition().intValue()) {
        case 1:
          config.recordPosition =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingPosition.RECORDING;
          break;
        case 2:
          config.recordPosition =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingPosition.PLAYBACK;
          break;
        default:
          config.recordPosition =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingPosition
                  .MIXED_RECORDING_AND_PLAYBACK;
          break;
      }
    }
    if (request.getCycleTime() != null) {
      switch (request.getCycleTime().intValue()) {
        case 10:
          config.recordCycleTime =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingCycleTime.CYCLE_TIME_10;
          break;
        case 60:
          config.recordCycleTime =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingCycleTime.CYCLE_TIME_60;
          break;
        case 360:
          config.recordCycleTime =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingCycleTime.CYCLE_TIME_360;
          break;
        case 900:
          config.recordCycleTime =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingCycleTime.CYCLE_TIME_900;
          break;
        default:
          config.recordCycleTime =
              NERtcAudioRecordingConfiguration.NERtcAudioRecordingCycleTime.CYCLE_TIME_0;
          break;
      }
    }
    int ret = NERtcEx.getInstance().startAudioRecordingWithConfig(config);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopAudioRecording() {
    int ret = NERtcEx.getInstance().stopAudioRecording();
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setLocalMediaPriority(Messages.SetLocalMediaPriorityRequest arg) {
    int ret =
        NERtcEx.getInstance()
            .setLocalMediaPriority(arg.getPriority().intValue(), arg.getIsPreemptive());
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long enableMediaPub(@NonNull Long mediaType, @NonNull Boolean enable) {
    int ret = NERtcEx.getInstance().enableMediaPub(mediaType.intValue(), enable);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long startChannelMediaRelay(Messages.StartOrUpdateChannelMediaRelayRequest arg) {
    ChannelMediaRelayConfiguration configuration =
        new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
    configuration.sourceMediaInfo = FLTUtils.fromMap(arg.getSourceMediaInfo());
    for (Object key : arg.getDestMediaInfo().keySet()) {
      Map<Object, Object> value = arg.getDestMediaInfo().get(key);
      configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
    }
    int ret = NERtcEx.getInstance().startChannelMediaRelay(configuration);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long updateChannelMediaRelay(Messages.StartOrUpdateChannelMediaRelayRequest arg) {
    ChannelMediaRelayConfiguration configuration =
        new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
    configuration.sourceMediaInfo = FLTUtils.fromMap(arg.getSourceMediaInfo());
    for (Object key : arg.getDestMediaInfo().keySet()) {
      Map<Object, Object> value = arg.getDestMediaInfo().get(key);
      configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
    }
    int ret = NERtcEx.getInstance().updateChannelMediaRelay(configuration);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopChannelMediaRelay() {
    int ret = NERtcEx.getInstance().stopChannelMediaRelay();
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long adjustUserPlaybackSignalVolume(Messages.AdjustUserPlaybackSignalVolumeRequest arg) {
    int ret = -1;
    if (arg.getVolume() != null && arg.getUid() != null) {
      ret =
          NERtcEx.getInstance()
              .adjustUserPlaybackSignalVolume(arg.getUid(), arg.getVolume().intValue());
    }
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setLocalPublishFallbackOption(Long option) {
    int ret = NERtcEx.getInstance().setLocalPublishFallbackOption(option.intValue());
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioSessionOperationRestriction(@NonNull Long option) {
    long result = -1L;
    result = (long) NERtcConstants.ErrorCode.ENGINE_ERROR_NOT_SUPPORTED;
    return result;
  }

  @NonNull
  @Override
  public Long enableVideoCorrection(@NonNull Boolean enable) {
    long result = -1L;
    int ret = NERtcEx.getInstance().enableVideoCorrection(enable);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long reportCustomEvent(@NonNull Messages.ReportCustomEventRequest request) {
    long result = -1L;
    HashMap<String, Object> params = (HashMap<String, Object>) request.getParam();
    int ret =
        NERtcEx.getInstance()
            .reportCustomEvent(request.getEventName(), request.getCustomIdentify(), params);
    result = (long) ret;
    return result;
  }

  @Override
  public Long setRemoteSubscribeFallbackOption(Long option) {
    int ret = NERtcEx.getInstance().setRemoteSubscribeFallbackOption(option.intValue());
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableSuperResolution(Boolean enable) {
    int ret = NERtcEx.getInstance().enableSuperResolution(enable);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long enableEncryption(Messages.EnableEncryptionRequest arg) {
    NERtcEncryptionConfig.EncryptionMode mode = NERtcEncryptionConfig.EncryptionMode.GMCryptoSM4ECB;
    int ret = -1;
    if (arg.getMode() == 0 && arg.getKey() != null) {
      NERtcEncryptionConfig config = new NERtcEncryptionConfig(mode, arg.getKey(), null);
      ret = NERtcEx.getInstance().enableEncryption(arg.getEnable(), config);
    }
    long result = -1L;
    result = (long) ret;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// SEI /////////////////////////////////////////////

  @Override
  public Long sendSEIMsg(Messages.SendSEIMsgRequest arg) {
    int ret =
        NERtcEx.getInstance()
            .sendSEIMsg(
                arg.getSeiMsg(), FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()));
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setLocalVoiceReverbParam(@NonNull Messages.SetLocalVoiceReverbParamRequest request) {
    NERtcReverbParam param = new NERtcReverbParam();
    param.wetGain = request.getWetGain().floatValue();
    param.dryGain = request.getDryGain().floatValue();
    param.damping = request.getDamping().floatValue();
    param.decayTime = request.getDecayTime().floatValue();
    param.preDelay = request.getPreDelay().floatValue();
    param.roomSize = request.getRoomSize().floatValue();
    int ret = NERtcEx.getInstance().setLocalVoiceReverbParam(param);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// Voice Effect /////////////////////////////////////////////

  @Override
  public Long setAudioEffectPreset(Long arg) {
    int ret = NERtcEx.getInstance().setAudioEffectPreset(arg.intValue());
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setVoiceBeautifierPreset(Long arg) {
    int ret = NERtcEx.getInstance().setVoiceBeautifierPreset(arg.intValue());
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setLocalVoicePitch(Double pitch) {
    int ret = NERtcEx.getInstance().setLocalVoicePitch(pitch);
    long result = -1L;
    result = (long) ret;
    return result;
  }

  @Override
  public Long setLocalVoiceEqualization(Messages.SetLocalVoiceEqualizationRequest arg) {
    int ret = -1;
    if (arg.getBandFrequency() != null && arg.getBandGain() != null) {
      ret =
          NERtcEx.getInstance()
              .setLocalVoiceEqualization(
                  arg.getBandFrequency().intValue(), arg.getBandGain().intValue());
    }
    long result = -1L;
    result = (long) ret;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// AudioEffectApi /////////////////////////////////////////////

  @Override
  public Long playEffect(PlayEffectRequest arg) {
    long result = -1L;
    int ret = -1;
    NERtcCreateAudioEffectOption option = new NERtcCreateAudioEffectOption();
    option.path = arg.getPath();
    if (arg.getLoopCount() != null) {
      option.loopCount = arg.getLoopCount().intValue();
    }
    if (arg.getSendEnabled() != null) {
      option.sendEnabled = arg.getSendEnabled();
    }
    if (arg.getSendVolume() != null) {
      option.sendVolume = arg.getSendVolume().intValue();
    }
    if (arg.getPlaybackEnabled() != null) {
      option.playbackEnabled = arg.getPlaybackEnabled();
    }
    if (arg.getPlaybackVolume() != null) {
      option.playbackVolume = arg.getPlaybackVolume().intValue();
    }
    if (arg.getStartTimestamp() != null) {
      option.startTimestamp = arg.getStartTimestamp();
    }
    if (arg.getSendWithAudioType() != null) {
      option.sendWithAudioType =
          (arg.getSendWithAudioType().intValue() == 0)
              ? NERtcAudioStreamType.kNERtcAudioStreamTypeMain
              : NERtcAudioStreamType.kNERtcAudioStreamTypeSub;
    }
    if (arg.getProgressInterval() != null) {
      option.progressInterval = arg.getProgressInterval();
    }
    if (arg.getEffectId() != null) {
      ret = NERtcEx.getInstance().playEffect(arg.getEffectId().intValue(), option);
    }

    result = (long) ret;
    return result;
  }

  @Override
  public Long stopEffect(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().stopEffect(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopAllEffects() {
    long result = -1L;
    int ret = NERtcEx.getInstance().stopAllEffects();
    result = (long) ret;
    return result;
  }

  @Override
  public Long pauseEffect(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().pauseEffect(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long resumeEffect(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().resumeEffect(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long pauseAllEffects() {
    long result = -1L;
    int ret = NERtcEx.getInstance().pauseAllEffects();
    result = (long) ret;
    return result;
  }

  @Override
  public Long resumeAllEffects() {
    long result = -1L;
    int ret = NERtcEx.getInstance().resumeAllEffects();
    result = (long) ret;
    return result;
  }

  @Override
  public Long setEffectSendVolume(Long effectId, Long volume) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setEffectSendVolume(effectId.intValue(), volume.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long getEffectSendVolume(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().getEffectSendVolume(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long setEffectPlaybackVolume(Long effectId, Long volume) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setEffectPlaybackVolume(effectId.intValue(), volume.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long getEffectPlaybackVolume(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().getEffectPlaybackVolume(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long getEffectDuration(Long arg) {
    long result = -1L;
    long ret = NERtcEx.getInstance().getEffectDuration(arg.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long startLastmileProbeTest(@NonNull Messages.StartLastmileProbeTestRequest request) {
    long result = -1L;
    LastmileProbeConfig config = new LastmileProbeConfig();
    config.probeUplink = Boolean.TRUE.equals(request.getProbeUplink());
    config.probeDownlink = Boolean.TRUE.equals(request.getProbeDownlink());
    config.expectedUplinkBitrate = request.getExpectedUplinkBitrate().intValue();
    config.expectedDownlinkBitrate = request.getExpectedDownlinkBitrate().intValue();

    long ret = NERtcEx.getInstance().startLastmileProbeTest(config);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long stopLastmileProbeTest() {
    long result = -1L;
    long ret = NERtcEx.getInstance().stopLastmileProbeTest();
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setVideoCorrectionConfig(@NonNull Messages.SetVideoCorrectionConfigRequest request) {
    long result = -1L;
    NERtcVideoCorrectionConfiguration config = new NERtcVideoCorrectionConfiguration();
    if (request.getTopLeft() != null) {
      config.topLeft.x = request.getTopLeft().getX().floatValue();
      config.topLeft.y = request.getTopLeft().getY().floatValue();
    }
    if (request.getTopRight() != null) {
      config.topRight.x = request.getTopRight().getX().floatValue();
      config.topRight.y = request.getTopRight().getY().floatValue();
    }
    if (request.getBottomLeft() != null) {
      config.bottomLeft.x = request.getBottomLeft().getX().floatValue();
      config.bottomLeft.y = request.getBottomLeft().getY().floatValue();
    }
    if (request.getBottomRight() != null) {
      config.bottomRight.x = request.getBottomRight().getX().floatValue();
      config.bottomRight.y = request.getBottomRight().getY().floatValue();
    }
    config.canvasHeight = request.getCanvasHeight().floatValue();
    config.canvasWidth = request.getCanvasWidth().floatValue();
    config.enableMirror = Boolean.TRUE.equals(request.getEnableMirror());
    long ret = NERtcEx.getInstance().setVideoCorrectionConfig(config);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long enableVirtualBackground(@NonNull Messages.EnableVirtualBackgroundRequest request) {
    long result = -1L;
    NERtcVirtualBackgroundSource source = new NERtcVirtualBackgroundSource();
    source.backgroundSourceType = request.getBackgroundSourceType().intValue();
    source.color = request.getColor().intValue();
    source.blur_degree = request.getBlur_degree().intValue();
    source.source = request.getSource();

    long ret = NERtcEx.getInstance().enableVirtualBackground(request.getEnabled(), source);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setRemoteHighPriorityAudioStream(
      @NonNull Messages.SetRemoteHighPriorityAudioStreamRequest request) {
    long result = -1L;
    long ret =
        NERtcEx.getInstance()
            .setRemoteHighPriorityAudioStream(request.getEnabled(), request.getUid());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setCloudProxy(@NonNull Long proxyType) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setCloudProxy(proxyType.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long startBeauty() {
    long result = -1L;
    long ret = NERtcEx.getInstance().startBeauty();
    result = (long) ret;
    return result;
  }

  @Override
  public void stopBeauty() {
    long result = -1L;
    NERtcEx.getInstance().stopBeauty();
    return;
  }

  @NonNull
  @Override
  public Long enableBeauty(@NonNull Boolean enabled) {
    long result = -1L;
    long ret = NERtcEx.getInstance().enableBeauty(enabled);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setBeautyEffect(@NonNull Double level, @NonNull Long beautyType) {
    long result = -1L;
    NERtcBeautyEffectType type;
    switch (beautyType.intValue()) {
      case 0:
        type = NERtcBeautyEffectType.kNERtcBeautyWhiteTeeth;
        break;
      case 1:
        type = NERtcBeautyEffectType.kNERtcBeautyLightEye;
        break;
      case 2:
        type = NERtcBeautyEffectType.kNERtcBeautyWhiten;
        break;
      case 3:
        type = NERtcBeautyEffectType.kNERtcBeautySmooth;
        break;
      case 4:
        type = NERtcBeautyEffectType.kNERtcBeautySmallNose;
        break;
      case 5:
        type = NERtcBeautyEffectType.kNERtcBeautyEyeDis;
        break;
      case 6:
        type = NERtcBeautyEffectType.kNERtcBeautyEyeAngle;
        break;
      case 7:
        type = NERtcBeautyEffectType.kNERtcBeautyMouth;
        break;
      case 8:
        type = NERtcBeautyEffectType.kNERtcBeautyBigEye;
        break;
      case 9:
        type = NERtcBeautyEffectType.kNERtcBeautySmallFace;
        break;
      case 10:
        type = NERtcBeautyEffectType.kNERtcBeautyJaw;
        break;
      case 11:
        type = NERtcBeautyEffectType.kNERtcBeautyThinFace;
        break;
      case 12:
        type = NERtcBeautyEffectType.kNERtcBeautyFaceRuddy;
        break;
      case 13:
        type = NERtcBeautyEffectType.kNERtcBeautyLongNose;
        break;
      case 14:
        type = NERtcBeautyEffectType.kNERtcBeautyPhiltrum;
        break;
      case 15:
        type = NERtcBeautyEffectType.kNERtcBeautyMouthAngle;
        break;
      case 16:
        type = NERtcBeautyEffectType.kNERtcBeautyRoundEye;
        break;
      case 17:
        type = NERtcBeautyEffectType.kNERtcBeautyEyeCorner;
        break;
      case 18:
        type = NERtcBeautyEffectType.kNERtcBeautyVFace;
        break;
      case 19:
        type = NERtcBeautyEffectType.kNERtcBeautyUnderJaw;
        break;
      case 20:
        type = NERtcBeautyEffectType.kNERtcBeautyNarrowFace;
        break;
      case 21:
        type = NERtcBeautyEffectType.kNERtcBeautyCheekBone;
        break;
      case 22:
        type = NERtcBeautyEffectType.kNERtcBeautyFaceSharpen;
        break;
      case 23:
        type = NERtcBeautyEffectType.kNERtcBeautyMouthWider;
        break;
      case 24:
        type = NERtcBeautyEffectType.kNERtcBeautyForeheadWrinkles;
        break;
      case 25:
        type = NERtcBeautyEffectType.kNERtcBeautyDarkCircles;
        break;
      case 26:
        type = NERtcBeautyEffectType.kNERtcBeautySmileLines;
        break;
      case 27:
        type = NERtcBeautyEffectType.kNERtcBeautyShortFace;
        break;
      default:
        type = NERtcBeautyEffectType.kNERtcBeautyUnknownType;
    }

    long ret = NERtcEx.getInstance().setBeautyEffect(type, level.floatValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long addBeautyFilter(@NonNull String path, @NonNull String name) {
    long result = -1L;
    long ret = NERtcEx.getInstance().addBeautyFilter(path);
    result = (long) ret;
    return result;
  }

  @Override
  public void removeBeautyFilter() {
    long result = -1L;
    NERtcEx.getInstance().removeBeautyFilter();
    return;
  }

  @NonNull
  @Override
  public Long setBeautyFilterLevel(@NonNull Double level) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setBeautyFilterLevel(level.floatValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setLocalVideoWatermarkConfigs(
      @NonNull Messages.SetLocalVideoWatermarkConfigsRequest request) {
    long result = -1L;
    long ret;
    if (request.getConfig() == null) {
      ret =
          NERtcEx.getInstance()
              .setLocalVideoWatermarkConfigs(
                  FLTUtils.int2VideoStreamType(request.getType().intValue()), null);
      result = (long) ret;
      return result;
    }
    NERtcVideoWatermarkConfig configs = new NERtcVideoWatermarkConfig();
    switch (request.getConfig().getWatermarkType()) {
      case K_NERTC_VIDEO_WATERMARK_TYPE_TEXT:
        configs.watermarkType = NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeText;
        break;
      case K_NERTC_VIDEO_WATERMARK_TYPE_IMAGE:
        configs.watermarkType = NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeImage;
        break;
      case K_NERTC_VIDEO_WATERMARK_TYPE_TIME_STAMP:
        configs.watermarkType =
            NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeTimestamp;
        break;
    }
    if (configs.watermarkType == NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeText) {
      NERtcVideoWatermarkTextConfig textConfig = new NERtcVideoWatermarkTextConfig();
      textConfig.content = request.getConfig().getTextWatermark().getContent();
      textConfig.fontNameOrPath = request.getConfig().getTextWatermark().getFontNameOrPath();
      textConfig.wmWidth = request.getConfig().getTextWatermark().getWmWidth().intValue();
      textConfig.wmHeight = request.getConfig().getTextWatermark().getWmHeight().intValue();
      textConfig.wmAlpha = request.getConfig().getTextWatermark().getWmAlpha().floatValue();
      textConfig.wmColor = request.getConfig().getTextWatermark().getWmColor().intValue();
      textConfig.fontSize = request.getConfig().getTextWatermark().getFontSize().intValue();
      textConfig.fontColor = request.getConfig().getTextWatermark().getFontColor().intValue();
      textConfig.offsetX = request.getConfig().getTextWatermark().getOffsetX().intValue();
      textConfig.offsetY = request.getConfig().getTextWatermark().getOffsetY().intValue();
      configs.textWatermark = textConfig;
    }
    if (configs.watermarkType == NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeImage) {
      NERtcVideoWatermarkImageConfig imageConfig = new NERtcVideoWatermarkImageConfig();
      imageConfig.fps = request.getConfig().getImageWatermark().getFps().intValue();
      imageConfig.wmWidth = request.getConfig().getImageWatermark().getWmWidth().intValue();
      imageConfig.wmHeight = request.getConfig().getImageWatermark().getWmHeight().intValue();
      imageConfig.wmAlpha = request.getConfig().getImageWatermark().getWmAlpha().floatValue();
      imageConfig.offsetX = request.getConfig().getImageWatermark().getOffsetX().intValue();
      imageConfig.offsetY = request.getConfig().getImageWatermark().getOffsetY().intValue();
      imageConfig.loop = request.getConfig().getImageWatermark().getLoop().booleanValue();
      imageConfig.imagePaths =
          (ArrayList<String>) request.getConfig().getImageWatermark().getImagePaths();
      configs.imageWatermark = imageConfig;
    }
    if (configs.watermarkType
        == NERtcVideoWatermarkConfig.WatermarkType.kNERtcWatermarkTypeTimestamp) {
      NERtcVideoWatermarkTimestampConfig timestampConfig = new NERtcVideoWatermarkTimestampConfig();
      timestampConfig.fontNameOrPath =
          request.getConfig().getTimestampWatermark().getFontNameOrPath();
      timestampConfig.wmWidth = request.getConfig().getTimestampWatermark().getWmWidth().intValue();
      timestampConfig.wmHeight =
          request.getConfig().getTimestampWatermark().getWmHeight().intValue();
      timestampConfig.wmAlpha =
          request.getConfig().getTimestampWatermark().getWmAlpha().floatValue();
      timestampConfig.wmColor = request.getConfig().getTimestampWatermark().getWmColor().intValue();
      timestampConfig.fontSize =
          request.getConfig().getTimestampWatermark().getFontSize().intValue();
      timestampConfig.fontColor =
          request.getConfig().getTimestampWatermark().getFontColor().intValue();
      timestampConfig.offsetX = request.getConfig().getTimestampWatermark().getOffsetX().intValue();
      timestampConfig.offsetY = request.getConfig().getTimestampWatermark().getOffsetY().intValue();
      configs.timestampWatermark = timestampConfig;
    }
    ret =
        NERtcEx.getInstance()
            .setLocalVideoWatermarkConfigs(
                FLTUtils.int2VideoStreamType(request.getType().intValue()), configs);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setStreamAlignmentProperty(@NonNull Boolean enable) {
    long result = 0L;
    NERtcEx.getInstance().setStreamAlignmentProperty(enable);

    return result;
  }

  @NonNull
  @Override
  public Long getNtpTimeOffset() {
    long result = -1L;
    long ret = NERtcEx.getInstance().getNtpTimeOffset();
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long takeLocalSnapshot(@NonNull Long streamType, @NonNull String path) {
    long result = -1L;
    long ret =
        NERtcEx.getInstance()
            .takeLocalSnapshot(
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
                  }
                  callback.onTakeSnapshotResult(code, path);
                });
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long takeRemoteSnapshot(
      @NonNull Long uid, @NonNull Long streamType, @NonNull String path) {
    long result = -1L;
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    long ret =
        NERtcEx.getInstance()
            .takeRemoteSnapshot(
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
                  }
                  callback.onTakeSnapshotResult(code, path);
                });
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setExternalVideoSource(@NonNull Long streamType, @NonNull Boolean enable) {
    long result = -1L;
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    int ret = NERtcEx.getInstance().setExternalVideoSource(type, enable);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long pushExternalVideoFrame(@NonNull Long streamType, @NonNull Messages.VideoFrame frame) {
    NERtcVideoStreamType type = FLTUtils.int2VideoStreamType(streamType.intValue());
    long result = -1L;
    NERtcVideoFrame videoFrame = new NERtcVideoFrame();
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
    if (frame.getWidth() != null) {
      videoFrame.width = frame.getWidth().intValue();
    }
    if (frame.getHeight() != null) {
      videoFrame.height = frame.getHeight().intValue();
    }
    if (frame.getRotation() != null) {
      videoFrame.rotation = frame.getRotation().intValue();
    }
    if (frame.getTimeStamp() != null) {
      videoFrame.timeStamp = frame.getTimeStamp();
    }
    videoFrame.data = frame.getData();
    if (frame.getTextureId() != null) {
      videoFrame.textureId = frame.getTextureId().intValue();
    }
    videoFrame.transformMatrix = FLTUtils.toGetTransformMatrix(frame.getTransformMatrix());
    boolean ret = NERtcEx.getInstance().pushExternalVideoFrame(type, videoFrame);
    if (ret) {
      return (long) 0;
    } else {
      return result;
    }
  }

  @Override
  public Long setVideoDump(Long dumpType) {
    return (long)
        NERtcEx.getInstance()
            .setVideoDump(NERtcConstants.NERtcVideoDumpType.fromInt(dumpType.intValue()));
  }

  @Override
  public String getParameter(String key, String extraInfo) {
    return NERtcEx.getInstance().getParameter(key, extraInfo);
  }

  @Override
  public Long setVideoStreamLayerCount(Long layerCount) {
    NERtcVideoStreamLayerCount layout = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountOne;
    if (layerCount == 2) {
      layout = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountTwo;
    } else if (layerCount == 3) {
      layout = NERtcVideoStreamLayerCount.kNERtcVideoStreamLayerCountThree;
    }
    return (long) NERtcEx.getInstance().setVideoStreamLayerCount(layout);
  }

  @Override
  public Long enableLocalData(Boolean enabled) {
    return (long) NERtcEx.getInstance().enableLocalData(enabled);
  }

  @Override
  public Long subscribeRemoteData(Boolean subscribe, Long userID) {
    return (long) NERtcEx.getInstance().subscribeRemoteData(subscribe, userID);
  }

  @Override
  public Long getFeatureSupportedType(Long type) {
    long result = -1;
    if (type == 0) {
      return (long)
          NERtcEx.getInstance().getFeatureSupportedType(NERtcFeatureType.VIRTUAL_BACKGROUND);
    }
    return result;
  }

  @Override
  public Boolean isFeatureSupported(Long type) {
    boolean result = false;
    if (type == 0) {
      return NERtcEx.getInstance().isFeatureSupported(NERtcFeatureType.VIRTUAL_BACKGROUND);
    }
    return result;
  }

  // 兼容 List<Integer>、List<Long>、List<Double> 等所有 Number 子类
  private long[] convertToLongArray(List<? extends Number> list) {
    if (list == null || list.isEmpty()) {
      return new long[0];
    }
    long[] array = new long[list.size()];
    for (int i = 0; i < list.size(); i++) {
      Number num = list.get(i);
      // 关键：通过 Number.longValue() 转换，自动处理 Integer→long、Long→long
      array[i] = num != null ? num.longValue() : 0; // 可处理 null 元素（按需调整）
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

  @Override
  public Long setSubscribeAudioBlocklist(List<Long> uidArray, Long streamType) {
    if (uidArray == null) return -1L;
    NERtcAudioStreamType type = NERtcAudioStreamType.kNERtcAudioStreamTypeMain;
    if (streamType == 1) {
      type = NERtcAudioStreamType.kNERtcAudioStreamTypeSub;
    }
    return (long)
        NERtcEx.getInstance().setSubscribeAudioBlocklist(convertToLongArray(uidArray), type);
  }

  @Override
  public Long setSubscribeAudioAllowlist(List<Long> uidArray) {
    if (uidArray == null) return -1L;
    return (long) NERtcEx.getInstance().setSubscribeAudioAllowlist(convertToLongArray(uidArray));
  }

  @Override
  public Long getNetworkType() {
    return (long) NERtcEx.getInstance().getNetworkType();
  }

  @Override
  public Long stopPushStreaming() {
    return (long) NERtcEx.getInstance().stopPushStreaming();
  }

  @Override
  public Long stopPlayStreaming(String streamId) {
    return (long) NERtcEx.getInstance().stopPlayStreaming(streamId);
  }

  @Override
  public Long pausePlayStreaming(String streamId) {
    return (long) NERtcEx.getInstance().pausePlayStreaming(streamId);
  }

  @Override
  public Long resumePlayStreaming(String streamId) {
    return (long) NERtcEx.getInstance().resumePlayStreaming(streamId);
  }

  @Override
  public Long muteVideoForPlayStreaming(String streamId, Boolean mute) {
    return (long) NERtcEx.getInstance().muteVideoForPlayStreaming(streamId, mute);
  }

  @Override
  public Long muteAudioForPlayStreaming(String streamId, Boolean mute) {
    return (long) NERtcEx.getInstance().muteAudioForPlayStreaming(streamId, mute);
  }

  @Override
  public Long stopASRCaption() {
    return (long) NERtcEx.getInstance().stopASRCaption();
  }

  @Override
  public Long aiManualInterrupt(Long dstUid) {
    return (long) NERtcEx.getInstance().aiManualInterrupt(dstUid);
  }

  @Override
  public Long AINSMode(Long mode) {
    NERtcAudioAINSMode ainsMode = NERtcAudioAINSMode.kNERtcAudioAINSOff;
    if (mode == 1) {
      ainsMode = NERtcAudioAINSMode.kNERtcAudioAINSNormal;
    } else if (mode == 2) {
      ainsMode = NERtcAudioAINSMode.kNERtcAudioAINSEnhance;
    }
    return (long) NERtcEx.getInstance().setAINSMode(ainsMode);
  }

  @Override
  public Long setAudioScenario(Long scenario) {
    return (long) NERtcEx.getInstance().setAudioScenario(scenario.intValue());
  }

  @Override
  public Long setExternalAudioSource(Boolean enabled, Long sampleRate, Long channels) {
    return (long)
        NERtcEx.getInstance()
            .setExternalAudioSource(enabled, sampleRate.intValue(), channels.intValue());
  }

  @Override
  public Long setExternalSubStreamAudioSource(Boolean enabled, Long sampleRate, Long channels) {
    return (long)
        NERtcEx.getInstance()
            .setExternalSubStreamAudioSource(enabled, sampleRate.intValue(), channels.intValue());
  }

  @Override
  public Long setAudioRecvRange(
      Long audibleDistance, Long conversationalDistance, Long rollOffMode) {
    NERtcDistanceRolloffModel offModel = NERtcDistanceRolloffModel.values()[rollOffMode.intValue()];
    return (long)
        NERtcEx.getInstance()
            .setAudioRecvRange(
                audibleDistance.intValue(), conversationalDistance.intValue(), offModel);
  }

  @Override
  public Long setRangeAudioMode(Long audioMode) {
    NERtcRangeAudioMode mode = NERtcRangeAudioMode.values()[audioMode.intValue()];
    return (long) NERtcEx.getInstance().setRangeAudioMode(mode);
  }

  @Override
  public Long setRangeAudioTeamID(Long teamID) {
    return (long) NERtcEx.getInstance().setRangeAudioTeamID(teamID.intValue());
  }

  @Override
  public Long updateSelfPosition(Messages.PositionInfo positionInfo) {
    NERtcPositionInfo info =
        new NERtcPositionInfo(
            convertToFloatArray(positionInfo.getMSpeakerPosition()),
            convertToFloatArray(positionInfo.getMSpeakerQuaternion()),
            convertToFloatArray(positionInfo.getMHeadPosition()),
            convertToFloatArray(positionInfo.getMSpeakerQuaternion()));
    return (long) NERtcEx.getInstance().updateSelfPosition(info);
  }

  @Override
  public Long enableSpatializerRoomEffects(Boolean enable) {
    return (long) NERtcEx.getInstance().enableSpatializerRoomEffects(enable);
  }

  @Override
  public Long setSpatializerRoomProperty(Messages.SpatializerRoomProperty property) {
    NERtcSpatializerRoomProperty roomProperty = new NERtcSpatializerRoomProperty();
    roomProperty.material =
        NERtcSpatializerMaterialName.values()[property.getMaterial().intValue()];
    roomProperty.roomCapacity =
        NERtcSpatializerRoomCapacity.values()[property.getRoomCapacity().intValue()];
    roomProperty.reflectionScalar = property.getReflectionScalar().floatValue();
    roomProperty.reverbGain = property.getReverbGain().floatValue();
    roomProperty.reverbTime = property.getReverbTime().floatValue();
    roomProperty.reverbBrightness = property.getReverbBrightness().floatValue();
    return (long) NERtcEx.getInstance().setSpatializerRoomProperty(roomProperty);
  }

  @Override
  public Long setSpatializerRenderMode(Long renderMode) {
    return (long)
        NERtcEx.getInstance()
            .setSpatializerRenderMode(NERtcSpatializerRenderMode.values()[renderMode.intValue()]);
  }

  @Override
  public Long enableSpatializer(Boolean enable, Boolean applyToTeam) {
    return (long) NERtcEx.getInstance().enableSpatializer(enable, applyToTeam);
  }

  @Override
  public Long setUpSpatializer() {
    return (long) NERtcEx.getInstance().initSpatializer();
  }

  @Override
  public Long addLocalRecordStreamForTask(Messages.LocalRecordingConfig config, String taskId) {
    return 0L;
  }

  @Override
  public Long removeLocalRecorderStreamForTask(String taskId) {
    return 0L;
  }

  @Override
  public Long addLocalRecorderStreamLayoutForTask(
      Messages.LocalRecordingLayoutConfig config,
      Long uid,
      Long streamType,
      Long streamLayer,
      Long taskId) {
    return 0L;
  }

  @Override
  public Long removeLocalRecorderStreamLayoutForTask(
      Long uid, Long streamType, Long streamLayer, String taskId) {
    return 0L;
  }

  @Override
  public Long updateLocalRecorderStreamLayoutForTask(
      List<Messages.LocalRecordingStreamInfo> infos, String taskId) {
    return 0L;
  }

  @Override
  public Long replaceLocalRecorderStreamLayoutForTask(
      List<Messages.LocalRecordingStreamInfo> infos, String taskId) {
    return 0L;
  }

  @Override
  public Long updateLocalRecorderWaterMarksForTask(
      List<Messages.VideoWatermarkConfig> watermarks, String taskId) {
    return 0L;
  }

  @Override
  public Long pushLocalRecorderVideoFrameForTask(
      Long uid, Long streamType, Long streamLayer, String taskId, Messages.VideoFrame frame) {
    return 0L;
  }

  @Override
  public Long showLocalRecorderStreamDefaultCoverForTask(
      Boolean showEnabled, Long uid, Long streamType, Long streamLayer, String taskId) {
    return 0L;
  }

  @Override
  public Long stopLocalRecorderRemuxMp4(String taskId) {
    return 0L;
  }

  @Override
  public Long remuxFlvToMp4(String flvPath, String mp4Path, Boolean saveOri) {
    return 0L;
  }

  @Override
  public Long stopRemuxFlvToMp4() {
    return 0L;
  }

  @Override
  public Long sendData(Messages.DataExternalFrame frame) {
    NERtcDataExternalFrame dataFrame = new NERtcDataExternalFrame();
    dataFrame.externalData = frame.getData();
    dataFrame.dataSize = frame.getDataSize();
    int ret = NERtcEx.getInstance().sendData(dataFrame);
    return (long) ret;
  }

  @Override
  public Long pushExternalAudioFrame(Messages.AudioExternalFrame frame) {
    NERtcAudioExternalFrame audioFrame = new NERtcAudioExternalFrame();
    audioFrame.audioData = frame.getData();
    audioFrame.numberOfChannels = frame.getNumberOfChannels().intValue();
    audioFrame.sampleRate = frame.getSampleRate().intValue();
    audioFrame.syncTimestamp = frame.getSyncTimestamp();
    audioFrame.samplesPerChannel = frame.getSamplesPerChannel().intValue();
    return (long) NERtcEx.getInstance().pushExternalAudioFrame(audioFrame);
  }

  @Override
  public Long pushExternalSubAudioFrame(Messages.AudioExternalFrame frame) {
    NERtcAudioExternalFrame audioFrame = new NERtcAudioExternalFrame();
    audioFrame.audioData = frame.getData();
    audioFrame.numberOfChannels = frame.getNumberOfChannels().intValue();
    audioFrame.sampleRate = frame.getSampleRate().intValue();
    audioFrame.syncTimestamp = frame.getSyncTimestamp();
    audioFrame.samplesPerChannel = frame.getSamplesPerChannel().intValue();
    int ret = NERtcEx.getInstance().pushExternalSubStreamAudioFrame(audioFrame);
    return (long) ret;
  }

  @Override
  public Long getEffectCurrentPosition(Long arg) {
    long result = -1L;
    long ret = NERtcEx.getInstance().getEffectCurrentPosition(arg.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setEffectPitch(@NonNull Long effectId, @NonNull Long pitch) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setEffectPitch(effectId.intValue(), pitch.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long getEffectPitch(@NonNull Long effectId) {
    long result = -1L;
    long ret = NERtcEx.getInstance().getEffectPitch(effectId.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setEffectPosition(@NonNull Long effectId, Long position) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setEffectPosition(effectId.intValue(), position.intValue());
    result = (long) ret;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// AudioMixingApi /////////////////////////////////////////////

  @Override
  public Long startAudioMixing(StartAudioMixingRequest arg) {
    long result = -1L;
    NERtcCreateAudioMixingOption option = new NERtcCreateAudioMixingOption();
    option.path = arg.getPath();
    if (arg.getLoopCount() != null) {
      option.loopCount = arg.getLoopCount().intValue();
    }
    if (arg.getSendEnabled() != null) {
      option.sendEnabled = arg.getSendEnabled();
    }
    if (arg.getSendVolume() != null) {
      option.sendVolume = arg.getSendVolume().intValue();
    }
    if (arg.getPlaybackEnabled() != null) {
      option.playbackEnabled = arg.getPlaybackEnabled();
    }
    if (arg.getPlaybackVolume() != null) {
      option.playbackVolume = arg.getPlaybackVolume().intValue();
    }
    int ret = NERtcEx.getInstance().startAudioMixing(option);
    result = (long) ret;
    return result;
  }

  @Override
  public Long stopAudioMixing() {
    long result = -1L;
    int ret = NERtcEx.getInstance().stopAudioMixing();
    result = (long) ret;
    return result;
  }

  @Override
  public Long pauseAudioMixing() {
    long result = -1L;
    int ret = NERtcEx.getInstance().pauseAudioMixing();
    result = (long) ret;
    return result;
  }

  @Override
  public Long resumeAudioMixing() {
    long result = -1L;
    int ret = NERtcEx.getInstance().resumeAudioMixing();
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioMixingSendVolume(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setAudioMixingSendVolume(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long getAudioMixingSendVolume() {
    long result = -1L;
    int ret = NERtcEx.getInstance().getAudioMixingSendVolume();
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioMixingPlaybackVolume(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setAudioMixingPlaybackVolume(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long getAudioMixingPlaybackVolume() {
    long result = -1L;
    int ret = NERtcEx.getInstance().getAudioMixingPlaybackVolume();
    result = (long) ret;
    return result;
  }

  @Override
  public Long getAudioMixingDuration() {
    long result = -1L;
    long ret = NERtcEx.getInstance().getAudioMixingDuration();
    result = (long) ret;
    return result;
  }

  @Override
  public Long getAudioMixingCurrentPosition() {
    long result = -1L;
    long ret = NERtcEx.getInstance().getAudioMixingCurrentPosition();
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioMixingPosition(Long arg) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setAudioMixingPosition(arg);
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setAudioMixingPitch(@NonNull Long pitch) {
    long result = -1L;
    long ret = NERtcEx.getInstance().setAudioMixingPitch(pitch.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long getAudioMixingPitch() {
    long result = -1L;
    long ret = NERtcEx.getInstance().getAudioMixingPitch();
    result = (long) ret;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// DeviceApi /////////////////////////////////////////////

  @Override
  public Boolean isSpeakerphoneOn() {
    boolean result = NERtcEx.getInstance().isSpeakerphoneOn();
    return result;
  }

  @NonNull
  @Override
  public Boolean isCameraZoomSupported() {
    boolean result = NERtcEx.getInstance().isCameraZoomSupported();
    return result;
  }

  @NonNull
  @Override
  public Boolean isCameraTorchSupported() {
    boolean result = NERtcEx.getInstance().isCameraTorchSupported();
    return result;
  }

  @NonNull
  @Override
  public Boolean isCameraFocusSupported() {
    boolean result = NERtcEx.getInstance().isCameraFocusSupported();
    return result;
  }

  @NonNull
  @Override
  public Boolean isCameraExposurePositionSupported() {
    boolean result = NERtcEx.getInstance().isCameraExposurePositionSupported();
    return result;
  }

  @Override
  public Long setSpeakerphoneOn(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setSpeakerphoneOn(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Long switchCamera() {
    long result = -1L;
    int ret = NERtcEx.getInstance().switchCamera();
    result = (long) ret;
    return result;
  }

  @Override
  public Long setCameraZoomFactor(Double arg) {
    NERtcEx.getInstance().setCameraZoomFactor(arg.intValue());
    long result = 0L;
    return result;
  }

  @Override
  public Double getCameraMaxZoom() {
    Double result;
    int ret = NERtcEx.getInstance().getCameraMaxZoom();
    result = (double) ret;
    return result;
  }

  @Override
  public Long setCameraTorchOn(Boolean arg) {
    Long result = -1L;
    int ret = NERtcEx.getInstance().setCameraTorchOn(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Long setCameraFocusPosition(Messages.SetCameraPositionRequest arg) {
    long result = 0L;
    int ret =
        NERtcEx.getInstance()
            .setCameraFocusPosition(arg.getX().floatValue(), arg.getY().floatValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long setCameraExposurePosition(@NonNull Messages.SetCameraPositionRequest request) {
    long result = -1L;
    int ret =
        NERtcEx.getInstance()
            .setCameraExposurePosition(request.getX().floatValue(), request.getY().floatValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long setPlayoutDeviceMute(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setPlayoutDeviceMute(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Boolean isPlayoutDeviceMute() {
    boolean result;
    boolean ret = NERtcEx.getInstance().isPlayoutDeviceMute();
    result = ret;
    return result;
  }

  @Override
  public Long setRecordDeviceMute(Boolean arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setRecordDeviceMute(arg);
    result = (long) ret;
    return result;
  }

  @Override
  public Boolean isRecordDeviceMute() {
    boolean result;
    boolean ret = NERtcEx.getInstance().isRecordDeviceMute();
    result = ret;
    return result;
  }

  @Override
  public Long enableEarback(Boolean enabled, Long volume) {
    Long result = -1L;
    int ret = NERtcEx.getInstance().enableEarback(enabled, volume.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long setEarbackVolume(Long arg) {
    Long result = -1L;
    int ret = NERtcEx.getInstance().setEarbackVolume(arg.intValue());
    result = (long) ret;
    return result;
  }

  @Override
  public Long setAudioFocusMode(Long arg) {
    long result = -1L;
    int ret = NERtcEx.getInstance().setAudioFocusMode(arg.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long getCurrentCamera() {
    long result = -1L;
    int ret = NERtcEx.getInstance().getCurrentCamera();
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long switchCameraWithPosition(@NonNull Long position) {
    long result = -1L;
    int ret = NERtcEx.getInstance().switchCameraWithPosition(position.intValue());
    result = (long) ret;
    return result;
  }

  @NonNull
  @Override
  public Long getCameraCurrentZoom() {
    long result = -1L;
    int ret = NERtcEx.getInstance().getCameraCurrentZoom();
    result = (long) ret;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////// VideoRendererApi /////////////////////////////////////////////

  //支持外部输入eglContext
  private EglBase.Context getEglBaseContext(Object eglContext) {
    if (eglContext instanceof android.opengl.EGLContext) {
      return new EglBase14Impl.Context((EGLContext) eglContext);
    } else if (eglContext instanceof javax.microedition.khronos.egl.EGLContext) {
      return new EglBase10Impl.Context((javax.microedition.khronos.egl.EGLContext) eglContext);
    }
    return null;
  }

  @NonNull
  @Override
  public Long createVideoRenderer() {
    Long result = -1L;
    TextureRegistry.SurfaceTextureEntry entry = registry.createSurfaceTexture();
    if (sharedEglContext != null) {
      FlutterVideoRenderer renderer =
          new FlutterVideoRenderer(
              messenger, entry, getEglBaseContext(sharedEglContext.getEglContext()));
      renderers.put(entry.id(), renderer);
      result = renderer.id();
    } else {
      result = -1L;
    }
    return result;
  }

  @Override
  public Long setMirror(Long textureId, Boolean mirror) {
    long result = -1L;
    int ret = -1;
    if (textureId != null) {
      FlutterVideoRenderer renderer = renderers.get(textureId);
      if (renderer != null) {
        renderer.setMirror(mirror);
        ret = 0;
      }
    }
    result = (long) ret;
    return result;
  }

  @Override
  public Long setupLocalVideoRenderer(Long arg, String tag) {
    long result = -1L;
    FlutterVideoRenderer renderer = null;
    if (arg != null) {
      renderer = renderers.get(arg);
    }
    if (TextUtils.isEmpty(tag)) {
      result = NERtc.getInstance().setupLocalVideoCanvas(renderer);
    } else {
      NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(tag);
      if (channel != null) // is null, return -1.
      result = channel.setupLocalVideoCanvas(renderer);
    }
    return result;
  }

  @Override
  public Long setupRemoteVideoRenderer(Long uid, Long textureId, String tag) {
    long result = -1L;
    FlutterVideoRenderer renderer = null;
    if (textureId != null) {
      renderer = renderers.get(textureId);
    }
    if (TextUtils.isEmpty(tag)) {
      result = NERtc.getInstance().setupRemoteVideoCanvas(renderer, uid);
    } else {
      NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(tag);
      if (channel != null) result = channel.setupRemoteVideoCanvas(renderer, uid);
    }
    return result;
  }

  @Override
  public Long setupLocalSubStreamVideoRenderer(Long arg, String tag) {
    long result = -1L;
    FlutterVideoRenderer renderer = null;
    if (arg != null) {
      renderer = renderers.get(arg);
    }
    if (TextUtils.isEmpty(tag)) {
      result = NERtcEx.getInstance().setupLocalSubStreamVideoCanvas(renderer);
    } else {
      NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(tag);
      if (channel != null) result = channel.setupLocalSubStreamVideoCanvas(renderer);
    }
    return result;
  }

  @Override
  public Long setupRemoteSubStreamVideoRenderer(Long uid, Long textureId, String tag) {
    long result = -1L;
    FlutterVideoRenderer renderer = null;
    if (textureId != null) {
      renderer = renderers.get(textureId);
    }
    if (TextUtils.isEmpty(tag)) {
      result = NERtcEx.getInstance().setupRemoteSubStreamVideoCanvas(renderer, uid);
    } else {
      NERtcChannel channel = NERtcChannelManager.getInstance().getChannel(tag);
      if (channel != null) result = channel.setupRemoteSubStreamVideoCanvas(renderer, uid);
    }
    return result;
  }

  @Override
  public Long setupPlayStreamingCanvas(@NonNull String streamId, @NonNull Long textureId) {
    long result = -1L;
    FlutterVideoRenderer renderer = null;
    if (textureId != null) {
      renderer = renderers.get(textureId);
    }
    result = NERtcEx.getInstance().setupPlayStreamingCanvas(streamId, renderer);
    return result;
  }

  @Override
  public void disposeVideoRenderer(Long arg) {
    FlutterVideoRenderer render = renderers.get(arg);
    if (render != null) {
      render.dispose();
      renderers.remove(arg);
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public Long startPushStreaming(@NonNull StartPushStreamingRequest request) {
    long result = -1L;
    try {
      NERtcPushStreamingConfig config = new NERtcPushStreamingConfig();
      if (request.getStreamingUrl() != null) {
        config.streamingUrl = request.getStreamingUrl();
      }
      if (request.getStreamingRoomInfo() != null) {
        NERtcStreamingRoomInfo roomInfo = new NERtcStreamingRoomInfo();
        if (request.getStreamingRoomInfo().getUid() != null) {
          roomInfo.uid = request.getStreamingRoomInfo().getUid().longValue();
        }
        if (request.getStreamingRoomInfo().getChannelName() != null) {
          roomInfo.channelName = request.getStreamingRoomInfo().getChannelName();
        }
        if (request.getStreamingRoomInfo().getToken() != null) {
          roomInfo.token = request.getStreamingRoomInfo().getToken();
        }
        config.streamingRoomInfo = roomInfo;
      }
      int ret = NERtcEx.getInstance().startPushStreaming(config);
      result = (long) ret;
    } catch (Exception e) {
      Log.e("NERtcEngine", "startPushStreaming error", e);
      result = -1L;
    }
    return result;
  }

  @NonNull
  @Override
  public Long startPlayStreaming(@NonNull StartPlayStreamingRequest request) {
    long result = -1L;
    try {
      NERtcPlayStreamingConfig config = new NERtcPlayStreamingConfig();
      if (request.getStreamingUrl() != null) {
        config.streamingUrl = request.getStreamingUrl();
      }
      if (request.getPlayOutDelay() != null) {
        config.playOutDelay = request.getPlayOutDelay().intValue();
      }
      if (request.getReconnectTimeout() != null) {
        config.reconnectTimeout = request.getReconnectTimeout().intValue();
      }
      if (request.getMuteAudio() != null) {
        config.muteAudio = request.getMuteAudio();
      }
      if (request.getMuteVideo() != null) {
        config.muteVideo = request.getMuteVideo();
      }
      if (request.getPausePullStream() != null) {
        config.pausePullStream = request.getPausePullStream();
      }
      String streamId = request.getStreamId() != null ? request.getStreamId() : "";
      int ret = NERtcEx.getInstance().startPlayStreaming(streamId, config);
      result = (long) ret;
    } catch (Exception e) {
      Log.e("NERtcEngine", "startPlayStreaming error", e);
      result = -1L;
    }
    return result;
  }

  @NonNull
  @Override
  public Long startASRCaption(@NonNull StartASRCaptionRequest request) {
    long result = -1L;
    try {
      NERtcASRCaptionConfig config = new NERtcASRCaptionConfig();
      if (request.getSrcLanguage() != null) {
        config.srcLanguage = request.getSrcLanguage();
      }
      if (request.getSrcLanguageArr() != null) {
        config.srcLanguageArr = request.getSrcLanguageArr().toArray(new String[0]);
      }
      if (request.getDstLanguageArr() != null) {
        config.dstLanguageArr = request.getDstLanguageArr().toArray(new String[0]);
      }
      if (request.getNeedTranslateSameLanguage() != null) {
        config.needTranslateSameLanguage = request.getNeedTranslateSameLanguage();
      }
      int ret = NERtcEx.getInstance().startASRCaption(config);
      result = (long) ret;
    } catch (Exception e) {
      Log.e("NERtcEngine", "startASRCaption error", e);
      result = -1L;
    }
    return result;
  }

  @NonNull
  @Override
  public Long setMultiPathOption(@NonNull SetMultiPathOptionRequest request) {
    long result = -1L;
    try {
      NERtcMultiPathOption option = new NERtcMultiPathOption();
      if (request.getEnableMediaMultiPath() != null) {
        option.enableMediaMultiPath = request.getEnableMediaMultiPath();
      }
      if (request.getMediaMode() != null) {
        int mediaModeInt = request.getMediaMode().intValue();
        if (mediaModeInt == 0) {
          option.mediaMode = NERtcMultiPathOption.NERtcMultiPathMediaMode.MULTI_PATH_MEDIA_MODE_RED;
        } else {
          option.mediaMode =
              NERtcMultiPathOption.NERtcMultiPathMediaMode.MULTI_PATH_MEDIA_MODE_SWITCH;
        }
      }
      if (request.getBadRttThreshold() != null) {
        option.badRttThreshold = request.getBadRttThreshold().intValue();
      }
      if (request.getRedAudioPacket() != null) {
        option.redAudioPacket = request.getRedAudioPacket();
      }
      if (request.getRedAudioRtxPacket() != null) {
        option.redAudioRtxPacket = request.getRedAudioRtxPacket();
      }
      if (request.getRedVideoPacket() != null) {
        option.redVideoPacket = request.getRedVideoPacket();
      }
      if (request.getRedVideoRtxPacket() != null) {
        option.redVideoRtxPacket = request.getRedVideoRtxPacket();
      }
      int ret = NERtcEx.getInstance().setMultiPathOption(option);
      result = (long) ret;
    } catch (Exception e) {
      Log.e("NERtcEngine", "setMultiPathOption error", e);
      result = -1L;
    }
    return result;
  }
}
