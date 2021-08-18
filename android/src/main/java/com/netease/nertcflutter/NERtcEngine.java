/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be 
 * found in the LICENSE file.
 */

package com.netease.nertcflutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.opengl.EGLContext;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.netease.lava.nertc.sdk.NERtc;
import com.netease.lava.nertc.sdk.NERtcEx;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam;
import com.netease.lava.nertc.sdk.NERtcMediaRelayParam.ChannelMediaRelayConfiguration;
import com.netease.lava.nertc.sdk.NERtcOption;
import com.netease.lava.nertc.sdk.NERtcParameters;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioEffectOption;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioMixingOption;
import com.netease.lava.nertc.sdk.encryption.NERtcEncryptionConfig;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamImageInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamLayout;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamTaskInfo;
import com.netease.lava.nertc.sdk.live.NERtcLiveStreamUserTranscoding;
import com.netease.lava.nertc.sdk.video.NERtcEglContextWrapper;
import com.netease.lava.nertc.sdk.video.NERtcScreenConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig;
import com.netease.lava.webrtc.EglBase;
import com.netease.lava.webrtc.EglBase10;
import com.netease.lava.webrtc.EglBase14;
import com.netease.nertcflutter.Messages.AddOrUpdateLiveStreamTaskRequest;
import com.netease.nertcflutter.Messages.AudioEffectApi;
import com.netease.nertcflutter.Messages.AudioMixingApi;
import com.netease.nertcflutter.Messages.BoolValue;
import com.netease.nertcflutter.Messages.CreateEngineRequest;
import com.netease.nertcflutter.Messages.DeleteLiveStreamTaskRequest;
import com.netease.nertcflutter.Messages.DeviceManagerApi;
import com.netease.nertcflutter.Messages.DoubleValue;
import com.netease.nertcflutter.Messages.EnableAudioVolumeIndicationRequest;
import com.netease.nertcflutter.Messages.EnableEarbackRequest;
import com.netease.nertcflutter.Messages.IntValue;
import com.netease.nertcflutter.Messages.JoinChannelRequest;
import com.netease.nertcflutter.Messages.EngineApi;
import com.netease.nertcflutter.Messages.PlayEffectRequest;
import com.netease.nertcflutter.Messages.SetAudioProfileRequest;
import com.netease.nertcflutter.Messages.SetCameraFocusPositionRequest;
import com.netease.nertcflutter.Messages.SetEffectPlaybackVolumeRequest;
import com.netease.nertcflutter.Messages.SetEffectSendVolumeRequest;
import com.netease.nertcflutter.Messages.SetLocalVideoConfigRequest;
import com.netease.nertcflutter.Messages.SetupRemoteVideoRendererRequest;
import com.netease.nertcflutter.Messages.StartAudioMixingRequest;
import com.netease.nertcflutter.Messages.SubscribeRemoteAudioRequest;
import com.netease.nertcflutter.Messages.SubscribeRemoteVideoRequest;
import com.netease.nertcflutter.Messages.VideoRendererApi;
import com.netease.yunxin.base.utils.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;


public class NERtcEngine implements EngineApi, AudioEffectApi, AudioMixingApi, DeviceManagerApi, VideoRendererApi {

    private final NERtcCallbackImpl callback;

    private final NERtcStatsObserverImpl observer;

    private final NERtcAudioProcessObserverImpl audioProcessObserver;

    private NERtcEglContextWrapper sharedEglContext = null;

    private final Context applicationContext;

    private AddActivityResultListener addActivityResultListener;

    private RemoveActivityResultListener removeActivityResultListener;

    private Activity activity;

    private final TextureRegistry registry;

    private final BinaryMessenger messenger;

    private final Map<Long, FlutterVideoRenderer> renderers = new HashMap<>();

    private CallbackMethod invokeMethod;


    @FunctionalInterface
    interface AddActivityResultListener {
        void addListener(@NonNull PluginRegistry.ActivityResultListener listener);
    }

    @FunctionalInterface
    interface RemoveActivityResultListener {
        void removeListener(@NonNull PluginRegistry.ActivityResultListener listener);
    }

//    @FunctionalInterface
//    interface ErrorCallback {
//        void onError(String errorCode, String errorDescription);
//    }

    @FunctionalInterface
    interface SuccessCallback {
        void onSuccess(long result);
    }

    @FunctionalInterface
    interface CallbackMethod {
        void invokeMethod(@NonNull String method, @Nullable Object arguments);
    }


    NERtcEngine(@NonNull Context applicationContext, @NonNull BinaryMessenger messenger,
                @NonNull CallbackMethod method, @NonNull TextureRegistry registry) {
        this.invokeMethod = method;
        this.callback = new NERtcCallbackImpl(method);
        this.observer = new NERtcStatsObserverImpl(method);
        this.audioProcessObserver = new NERtcAudioProcessObserverImpl(method);
        this.applicationContext = applicationContext;
        this.addActivityResultListener = null;
        this.removeActivityResultListener = null;
        this.activity = null;
        this.messenger = messenger;
        this.registry = registry;
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

    static class ActivityResultListener implements PluginRegistry.ActivityResultListener {

        final SuccessCallback successCallback;
        final NERtcScreenConfig screenConfig;
        final RemoveActivityResultListener removeActivityResultListener;
        boolean alreadyCalled = false;

        ActivityResultListener(SuccessCallback successCallback, NERtcScreenConfig screenConfig,
                               RemoveActivityResultListener removeActivityResultListener) {
            this.successCallback = successCallback;
            this.screenConfig = screenConfig;
            this.removeActivityResultListener = removeActivityResultListener;
        }

        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
            if (removeActivityResultListener != null)
                removeActivityResultListener.removeListener(this);
            if (!alreadyCalled) {
                if (requestCode == CAPTURE_PERMISSION_REQUEST_CODE) {
                    if (resultCode != Activity.RESULT_OK || data == null) {
                        successCallback.onSuccess(-1);
                    } else {
                        int ret = NERtcEx.getInstance().startScreenCapture(screenConfig, data,
                                new MediaProjection.Callback() {
                                    @Override
                                    public void onStop() {
                                        super.onStop();
                                    }
                                });
                        successCallback.onSuccess(ret);
                    }

                }
            }
            alreadyCalled = true;
            return false;
        }
    }


    /////////////////////////////  NERtcEngineApi ///////////////////////////////////////////
    @Override
    public IntValue create(CreateEngineRequest arg) {
        IntValue result = new IntValue();
        if (applicationContext == null) {
            Log.e("NERtcEngine", "Create RTC engine context is required to screen capture and cannot be null.");
            result.setValue(-1L);
            return result;
        }

        String appKey = arg.getAppKey();
        if (StringUtils.isEmpty(appKey)) {
            Log.e("NERtcEngine", "Create RTC engine error: app key is null");
            result.setValue(-2L);
            return result;
        }

        NERtcOption option = new NERtcOption();
        if (arg.getLogDir() != null) {
            option.logDir = arg.getLogDir();
        }
        if (arg.getLogLevel() != null) {
            option.logLevel = arg.getLogLevel().intValue();
        }

        sharedEglContext = NERtcEglContextWrapper.createEglContext();
        option.eglContext = sharedEglContext.getEglContext();

        NERtcParameters parameters = new NERtcParameters();
        //Audio
        if (arg.getAudioAutoSubscribe() != null) {
            parameters.setBoolean(NERtcParameters.KEY_AUTO_SUBSCRIBE_AUDIO, arg.getAudioAutoSubscribe());
        }
        if (arg.getAudioAINSEnabled() != null) {
            parameters.setBoolean(NERtcParameters.KEY_AUDIO_AI_NS_ENABLE, arg.getAudioAINSEnabled());
        }

        //Video
        if (arg.getVideoEncodeMode() != null) {
            parameters.setString(NERtcParameters.KEY_VIDEO_ENCODE_MODE,
                    FLTUtils.int2VideoEncodeDecodeMode(arg.getVideoEncodeMode().intValue()));
        }
        if (arg.getVideoDecodeMode() != null) {
            parameters.setString(NERtcParameters.KEY_VIDEO_DECODE_MODE,
                    FLTUtils.int2VideoEncodeDecodeMode(arg.getVideoDecodeMode().intValue()));
        }
        if (arg.getVideoSendMode() != null) {
            parameters.setInteger(NERtcParameters.KEY_VIDEO_SEND_MODE, arg.getVideoSendMode().intValue());
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
            parameters.setInteger(NERtcParameters.KEY_SERVER_RECORD_MODE, arg.getServerRecordMode().intValue());
        }
        if (arg.getServerRecordSpeaker() != null) {
            parameters.setBoolean(NERtcParameters.KEY_SERVER_RECORD_SPEAKER, arg.getServerRecordSpeaker());
        }

        //其他参数
        if (arg.getPublishSelfStream() != null) {
            parameters.setBoolean(NERtcParameters.KEY_PUBLISH_SELF_STREAM, arg.getPublishSelfStream());
        }

        try {
            NERtcEx.getInstance().setParameters(parameters);
            NERtcEx.getInstance().init(applicationContext, appKey, callback, option);
            NERtcEx.getInstance().setAudioProcessObserver(audioProcessObserver);
            result.setValue(0L);
        } catch (Exception e) {
            Log.e("NERtcEngine", "Create RTC engine exception:" + e.toString());
            result.setValue(-3L);
        }
        return result;
    }

    @Override
    public void release(Messages.Result<IntValue> result) {
        NERtcEx.getInstance().setStatsObserver(null);
        NERtcEx.getInstance().setAudioProcessObserver(null);
        callback.setAudioMixingCallbackEnabled(false);
        callback.setDeviceCallbackEnabled(false);
        callback.setAudioEffectCallbackEnabled(false);
        NERtc.getInstance().release();
//        for (Iterator<FlutterVideoRenderer> iterator = renderers.values().iterator(); iterator.hasNext(); ) {
//            FlutterVideoRenderer renderer = iterator.next();
//            if (renderer != null) {
//                renderer.dispose();
//            }
//            iterator.remove();
//        }
        if (sharedEglContext != null) {
            sharedEglContext.release();
            sharedEglContext = null;
        }
        IntValue value = new IntValue();
        value.setValue(0L);
        result.success(value);
    }


    @Override
    public IntValue setStatsEventCallback() {
        IntValue result = new IntValue();
        NERtcEx.getInstance().setStatsObserver(observer);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue clearStatsEventCallback() {
        IntValue result = new IntValue();
        NERtcEx.getInstance().setStatsObserver(null);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue setChannelProfile(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setChannelProfile(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue joinChannel(JoinChannelRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtc.getInstance().joinChannel(arg.getToken(), arg.getChannelName(), arg.getUid());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue leaveChannel() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().leaveChannel();
        result.setValue((long) ret);
        return result;
    }


    @Override
    public IntValue enableLocalAudio(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().enableLocalAudio(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue subscribeRemoteAudio(SubscribeRemoteAudioRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeRemoteAudioStream(arg.getUid(), arg.getSubscribe());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue subscribeAllRemoteAudio(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeAllRemoteAudioStreams(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setAudioProfile(SetAudioProfileRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setAudioProfile(arg.getProfile().intValue(), arg.getScenario().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue enableDualStreamMode(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().enableDualStreamMode(arg.getValue());
        result.setValue((long) ret);
        return result;
    }


    @Override
    public IntValue setLocalVideoConfig(SetLocalVideoConfigRequest arg) {
        IntValue result = new IntValue();
        NERtcVideoConfig config = new NERtcVideoConfig();
        config.videoProfile = arg.getVideoProfile().intValue();
        config.videoCropMode = arg.getVideoCropMode().intValue();
        config.frontCamera = arg.getFrontCamera();
        config.frameRate = FLTUtils.int2VideoFrameRate(arg.getFrameRate().intValue());
        config.minFramerate = arg.getMinFrameRate().intValue();
        config.bitrate = arg.getBitrate().intValue();
        config.minBitrate = arg.getMinBitrate().intValue();
        config.degradationPrefer = FLTUtils.int2DegradationPreference(arg.getDegradationPrefer().intValue());
        config.width = arg.getWidth().intValue();
        config.height = arg.getHeight().intValue();
        config.orientationMode = FLTUtils.int2VideoOutputOrientationMode(arg.getOrientationMode().intValue());
        config.mirrorMode = FLTUtils.int2VideoMirrorMode(arg.getMirrorMode().intValue());
        int ret = NERtcEx.getInstance().setLocalVideoConfig(config);
        result.setValue((long) ret);
        return result;
    }


    @Override
    public IntValue startVideoPreview() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().startVideoPreview();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopVideoPreview() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().stopVideoPreview();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue enableLocalVideo(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().enableLocalVideo(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    private void requestScreenCapture(@NonNull Context applicationContext, @NonNull Activity activity) {
        MediaProjectionManager mediaProjectionManager = (MediaProjectionManager) applicationContext.getSystemService(
                Context.MEDIA_PROJECTION_SERVICE);
        Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
        activity.startActivityForResult(captureIntent, CAPTURE_PERMISSION_REQUEST_CODE);
    }

    @Override
    public void startScreenCapture(Messages.StartScreenCaptureRequest arg, Messages.Result<IntValue> result) {
        if (activity == null) {
            Log.e("NERtcEngine", "startScreenCapture error: " +
                    "Android activity is required to screen capture and cannot be null.");
            IntValue value = new IntValue();
            value.setValue(-2L);
            result.success(value);
            return;
        }
        if (addActivityResultListener == null) {
            Log.e("NERtcEngine", "startScreenCapture error: " +
                    "Activity result listener is required to screen capture and cannot be null.");
            IntValue value = new IntValue();
            value.setValue(-3L);
            result.success(value);
            return;
        }
        if (removeActivityResultListener == null) {
            Log.e("NERtcEngine", "startScreenCapture error: " +
                    "Activity result listener is required to screen capture and cannot be null.");
            IntValue value = new IntValue();
            value.setValue(-4L);
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
        ActivityResultListener activityResultListener = new ActivityResultListener(result1 -> {
            IntValue value = new IntValue();
            value.setValue(result1);
            result.success(value);
        }, config, removeActivityResultListener);
        addActivityResultListener.addListener(activityResultListener);
        requestScreenCapture(applicationContext, activity);
    }

    @Override
    public IntValue stopScreenCapture() {
        IntValue result = new IntValue();
        NERtcEx.getInstance().stopScreenCapture();
        result.setValue(0L);
        return result;
    }


    @Override
    public IntValue subscribeRemoteSubStreamVideo(Messages.SubscribeRemoteSubStreamVideoRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeRemoteSubStreamVideo(arg.getUid(), arg.getSubscribe());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue subscribeRemoteVideo(SubscribeRemoteVideoRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeRemoteVideoStream(arg.getUid(),
                FLTUtils.int2RemoteVideoStreamType(arg.getStreamType().intValue()),
                arg.getSubscribe());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue muteLocalAudioStream(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().muteLocalAudioStream(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue muteLocalVideoStream(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().muteLocalVideoStream(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue startAudioDump() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().startAudioDump();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopAudioDump() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().stopAudioDump();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue enableAudioVolumeIndication(EnableAudioVolumeIndicationRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().enableAudioVolumeIndication(arg.getEnable(), arg.getInterval().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue adjustRecordingSignalVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().adjustRecordingSignalVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue adjustPlaybackSignalVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().adjustPlaybackSignalVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue addLiveStreamTask(AddOrUpdateLiveStreamTaskRequest arg) {
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
                    userTranscoding.adaption = FLTUtils.int2LiveStreamVideoScaleMode(((Number) adaption).intValue());
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
        int ret = NERtcEx.getInstance().addLiveStreamTask(taskInfo, (taskId, errorCode) -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("serial", serial);
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("taskId", taskId);
            arguments.put("errCode", errorCode);
            map.put("arguments", arguments);
            invokeMethod.invokeMethod("onOnceEvent", map);
        });
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue updateLiveStreamTask(AddOrUpdateLiveStreamTaskRequest arg) {
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
                    userTranscoding.adaption = FLTUtils.int2LiveStreamVideoScaleMode(((Number) adaption).intValue());
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
        int ret = NERtcEx.getInstance().updateLiveStreamTask(taskInfo, (taskId, errorCode) -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("serial", serial);
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("taskId", taskId);
            arguments.put("errCode", errorCode);
            map.put("arguments", arguments);
            invokeMethod.invokeMethod("onOnceEvent", map);
        });
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue removeLiveStreamTask(DeleteLiveStreamTaskRequest arg) {
        IntValue result = new IntValue();
        Long serial = arg.getSerial();
        int ret = NERtcEx.getInstance().removeLiveStreamTask(arg.getTaskId(), (taskId, errorCode) -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("serial", serial);
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("taskId", taskId);
            arguments.put("errCode", errorCode);
            map.put("arguments", arguments);
            invokeMethod.invokeMethod("onOnceEvent", map);
        });
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setClientRole(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setClientRole(FLTUtils.int2UserRole(arg.getValue().intValue()));
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getConnectionState() {
        int ret = NERtcEx.getInstance().getConnectionState();
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue uploadSdkInfo() {
        NERtcEx.getInstance().uploadSdkInfo();
        IntValue result = new IntValue();
        result.setValue((long) 0);
        return result;
    }

    @Override
    public IntValue switchChannel(Messages.SwitchChannelRequest arg) {
        int ret = NERtcEx.getInstance().switchChannel(arg.getToken(), arg.getChannelName());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue startAudioRecording(Messages.StartAudioRecordingRequest arg) {
        int ret = NERtcEx.getInstance().startAudioRecording(arg.getFilePath(),
                arg.getSampleRate().intValue(), arg.getQuality().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopAudioRecording() {
        int ret = NERtcEx.getInstance().stopAudioRecording();
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setLocalMediaPriority(Messages.SetLocalMediaPriorityRequest arg) {
        int ret = NERtcEx.getInstance().setLocalMediaPriority(arg.getPriority().intValue(), arg.getIsPreemptive());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue startChannelMediaReplay(Messages.StartOrUpdateChannelMediaReplayRequest arg) {
        ChannelMediaRelayConfiguration configuration = new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
        configuration.sourceMediaInfo = FLTUtils.fromMap(arg.getSourceMediaInfo());
        for (Object key : arg.getDestMediaInfo().keySet()) {
            Map<Object, Object> value = (Map<Object, Object>) arg.getDestMediaInfo().get(key);
            configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
        }
        int ret = NERtcEx.getInstance().startChannelMediaRelay(configuration);
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue updateChannelMediaRelay(Messages.StartOrUpdateChannelMediaReplayRequest arg) {
        ChannelMediaRelayConfiguration configuration = new NERtcMediaRelayParam().new ChannelMediaRelayConfiguration();
        configuration.sourceMediaInfo = FLTUtils.fromMap(arg.getSourceMediaInfo());
        for (Object key : arg.getDestMediaInfo().keySet()) {
            Map<Object, Object> value = (Map<Object, Object>) arg.getDestMediaInfo().get(key);
            configuration.destMediaInfo.put((String) key, FLTUtils.fromMap(value));
        }
        int ret = NERtcEx.getInstance().updateChannelMediaRelay(configuration);
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopChannelMediaRelay() {
        int ret = NERtcEx.getInstance().stopChannelMediaRelay();
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue adjustUserPlaybackSignalVolume(Messages.AdjustUserPlaybackSignalVolumeRequest arg) {
        int ret = NERtcEx.getInstance().adjustUserPlaybackSignalVolume(arg.getUid(), arg.getVolume().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setLocalPublishFallbackOption(IntValue arg) {
        int ret = NERtcEx.getInstance().setLocalPublishFallbackOption(arg.getValue().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setRemoteSubscribeFallbackOption(IntValue arg) {
        int ret = NERtcEx.getInstance().setRemoteSubscribeFallbackOption(arg.getValue().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue enableSuperResolution(BoolValue arg) {
        int ret = NERtcEx.getInstance().enableSuperResolution(arg.getValue());
        IntValue result = new IntValue();
        result.setValue((long)ret);
        return result;
    }

    @Override
    public IntValue enableEncryption(Messages.EnableEncryptionRequest arg) {
        int ret = NERtcEx.getInstance().enableEncryption(arg.getEnable(),
                new NERtcEncryptionConfig(FLTUtils.int2EncryptionMode(arg.getMode().intValue()), arg.getKey()));
        IntValue result = new IntValue();
        result.setValue((long)ret);
        return result;
    }


////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// SEI /////////////////////////////////////////////

    @Override
    public IntValue sendSEIMsg(Messages.SendSEIMsgRequest arg) {
        int ret = NERtcEx.getInstance().sendSEIMsg(arg.getSeiMsg(), FLTUtils.int2VideoStreamType(arg.getStreamType().intValue()));
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// Voice Effect /////////////////////////////////////////////


    @Override
    public IntValue setAudioEffectPreset(IntValue arg) {
        int ret = NERtcEx.getInstance().setAudioEffectPreset(arg.getValue().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setVoiceBeautifierPreset(IntValue arg) {
        int ret = NERtcEx.getInstance().setVoiceBeautifierPreset(arg.getValue().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setLocalVoicePitch(DoubleValue arg) {
        int ret = NERtcEx.getInstance().setLocalVoicePitch(arg.getValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setLocalVoiceEqualization(Messages.SetLocalVoiceEqualizationRequest arg) {
        int ret = NERtcEx.getInstance().setLocalVoiceEqualization(arg.getBandFrequency().intValue(), arg.getBandGain().intValue());
        IntValue result = new IntValue();
        result.setValue((long) ret);
        return result;
    }

////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// AudioEffectApi /////////////////////////////////////////////

    @Override
    public IntValue setAudioEffectEventCallback() {
        IntValue result = new IntValue();
        callback.setAudioEffectCallbackEnabled(true);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue clearAudioEffectEventCallback() {
        IntValue result = new IntValue();
        callback.setAudioEffectCallbackEnabled(false);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue playEffect(PlayEffectRequest arg) {
        IntValue result = new IntValue();
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
        int ret = NERtcEx.getInstance().playEffect(arg.getEffectId().intValue(), option);
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopEffect(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().stopEffect(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopAllEffects() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().stopAllEffects();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue pauseEffect(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().pauseEffect(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue resumeEffect(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().resumeEffect(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue pauseAllEffects() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().pauseAllEffects();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue resumeAllEffects() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().resumeAllEffects();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setEffectSendVolume(SetEffectSendVolumeRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setEffectSendVolume(arg.getEffectId().intValue(), arg.getVolume().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getEffectSendVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().getEffectSendVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setEffectPlaybackVolume(SetEffectPlaybackVolumeRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setEffectPlaybackVolume(arg.getEffectId().intValue(), arg.getVolume().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getEffectPlaybackVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().getEffectPlaybackVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getEffectDuration(IntValue arg) {
        IntValue result = new IntValue();
        long ret = NERtcEx.getInstance().getEffectDuration(arg.getValue().intValue());
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue getEffectCurrentPosition(IntValue arg) {
        IntValue result = new IntValue();
        long ret = NERtcEx.getInstance().getEffectCurrentPosition(arg.getValue().intValue());
        result.setValue(ret);
        return result;
    }


    //////////////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////// AudioMixingApi /////////////////////////////////////////////

    @Override
    public IntValue setAudioMixingEventCallback() {
        IntValue result = new IntValue();
        callback.setAudioMixingCallbackEnabled(true);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue clearAudioMixingEventCallback() {
        IntValue result = new IntValue();
        callback.setAudioMixingCallbackEnabled(false);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue startAudioMixing(StartAudioMixingRequest arg) {
        IntValue result = new IntValue();
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
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue stopAudioMixing() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().stopAudioMixing();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue pauseAudioMixing() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().pauseAudioMixing();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue resumeAudioMixing() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().resumeAudioMixing();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setAudioMixingSendVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setAudioMixingSendVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getAudioMixingSendVolume() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().getAudioMixingSendVolume();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setAudioMixingPlaybackVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setAudioMixingPlaybackVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getAudioMixingPlaybackVolume() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().getAudioMixingPlaybackVolume();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue getAudioMixingDuration() {
        IntValue result = new IntValue();
        long ret = NERtcEx.getInstance().getAudioMixingDuration();
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue getAudioMixingCurrentPosition() {
        IntValue result = new IntValue();
        long ret = NERtcEx.getInstance().getAudioMixingCurrentPosition();
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue setAudioMixingPosition(IntValue arg) {
        IntValue result = new IntValue();
        long ret = NERtcEx.getInstance().setAudioMixingPosition(arg.getValue());
        result.setValue(ret);
        return result;
    }

    //////////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////// DeviceApi /////////////////////////////////////////////


    @Override
    public IntValue setDeviceEventCallback() {
        IntValue result = new IntValue();
        callback.setDeviceCallbackEnabled(true);
        result.setValue(0L);
        return result;
    }

    @Override
    public IntValue clearDeviceEventCallback() {
        IntValue result = new IntValue();
        callback.setDeviceCallbackEnabled(false);
        result.setValue(0L);
        return result;
    }

    @Override
    public BoolValue isSpeakerphoneOn() {
        BoolValue result = new BoolValue();
        boolean ret = NERtcEx.getInstance().isSpeakerphoneOn();
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue setSpeakerphoneOn(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setSpeakerphoneOn(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue switchCamera() {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().switchCamera();
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setCameraZoomFactor(IntValue arg) {
        NERtcEx.getInstance().setCameraZoomFactor(arg.getValue().intValue());
        IntValue result = new IntValue();
        result.setValue(1L);
        return result;
    }

    @Override
    public DoubleValue getCameraMaxZoom() {
        DoubleValue result = new DoubleValue();
        int ret = NERtcEx.getInstance().getCameraMaxZoom();
        result.setValue((double) ret);
        return result;
    }

    @Override
    public IntValue setCameraTorchOn(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setCameraTorchOn(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setCameraFocusPosition(SetCameraFocusPositionRequest arg) {
        NERtcEx.getInstance().setCameraFocusPosition(arg.getX().floatValue(), arg.getY().floatValue());
        IntValue result = new IntValue();
        result.setValue(1L);
        return result;
    }

    @Override
    public IntValue setPlayoutDeviceMute(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setPlayoutDeviceMute(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public BoolValue isPlayoutDeviceMute() {
        BoolValue result = new BoolValue();
        boolean ret = NERtcEx.getInstance().isPlayoutDeviceMute();
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue setRecordDeviceMute(BoolValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setRecordDeviceMute(arg.getValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public BoolValue isRecordDeviceMute() {
        BoolValue result = new BoolValue();
        boolean ret = NERtcEx.getInstance().isRecordDeviceMute();
        result.setValue(ret);
        return result;
    }

    @Override
    public IntValue enableEarback(EnableEarbackRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().enableEarback(arg.getEnabled(), arg.getVolume().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setEarbackVolume(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setEarbackVolume(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setAudioFocusMode(IntValue arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().setAudioFocusMode(arg.getValue().intValue());
        result.setValue((long) ret);
        return result;
    }


    //////////////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////// VideoRendererApi /////////////////////////////////////////////

    //支持外部输入eglContext
    private EglBase.Context getEglBaseContext(Object eglContext) {
        if (eglContext instanceof android.opengl.EGLContext) {
            return new EglBase14.Context((EGLContext) eglContext);
        } else if (eglContext instanceof javax.microedition.khronos.egl.EGLContext) {
            return new EglBase10.Context((javax.microedition.khronos.egl.EGLContext) eglContext);
        }
        return null;
    }

    @Override
    public IntValue createVideoRenderer() {
        IntValue result = new IntValue();
        TextureRegistry.SurfaceTextureEntry entry = registry.createSurfaceTexture();
        if (sharedEglContext != null) {
            FlutterVideoRenderer renderer = new FlutterVideoRenderer(messenger,
                    entry, getEglBaseContext(sharedEglContext.getEglContext()));
            renderers.put(entry.id(), renderer);
            result.setValue(renderer.id());
        } else {
            result.setValue(-1L);
        }
        return result;
    }

    @Override
    public IntValue setMirror(Messages.SetVideoRendererMirrorRequest arg) {
        IntValue result = new IntValue();
        int ret = -1;
        if (arg.getTextureId() != null) {
            FlutterVideoRenderer renderer = renderers.get(arg.getTextureId());
            if (renderer != null) {
                renderer.setMirror(arg.getMirror());
                ret = 0;
            }
        }
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setupLocalVideoRenderer(IntValue arg) {
        IntValue result = new IntValue();
        FlutterVideoRenderer renderer = null;
        if (arg.getValue() != null) {
            renderer = renderers.get(arg.getValue());
        }
        int ret = NERtc.getInstance().setupLocalVideoCanvas(renderer);
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setupRemoteVideoRenderer(SetupRemoteVideoRendererRequest arg) {
        IntValue result = new IntValue();
        FlutterVideoRenderer renderer = null;
        if (arg.getTextureId() != null) {
            renderer = renderers.get(arg.getTextureId());
        }
        int ret = NERtc.getInstance().setupRemoteVideoCanvas(renderer, arg.getUid());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setupLocalSubStreamVideoRenderer(IntValue arg) {
        IntValue result = new IntValue();
        FlutterVideoRenderer renderer = null;
        if (arg.getValue() != null) {
            renderer = renderers.get(arg.getValue());
        }
        int ret = NERtcEx.getInstance().setupLocalSubStreamVideoCanvas(renderer);
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue setupRemoteSubStreamVideoRenderer(Messages.SetupRemoteSubStreamVideoRendererRequest arg) {
        IntValue result = new IntValue();
        FlutterVideoRenderer renderer = null;
        if (arg.getTextureId() != null) {
            renderer = renderers.get(arg.getTextureId());
        }
        int ret = NERtcEx.getInstance().setupRemoteSubStreamVideoCanvas(renderer, arg.getUid());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public void disposeVideoRenderer(IntValue arg) {
        FlutterVideoRenderer render = renderers.get(arg.getValue());
        if (render != null) {
            render.dispose();
            renderers.remove(arg.getValue());
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////

}
