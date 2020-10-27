/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcflutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.netease.lava.nertc.sdk.NERtc;
import com.netease.lava.nertc.sdk.NERtcEx;
import com.netease.lava.nertc.sdk.NERtcOption;
import com.netease.lava.nertc.sdk.NERtcParameters;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioEffectOption;
import com.netease.lava.nertc.sdk.audio.NERtcCreateAudioMixingOption;
import com.netease.lava.nertc.sdk.video.NERtcRemoteVideoStreamType;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig.NERtcDegradationPreference;
import com.netease.lava.nertc.sdk.video.NERtcVideoConfig.NERtcVideoFrameRate;
import com.netease.lava.webrtc.EglBase;
import com.netease.nertcflutter.Messages.AudioEffectApi;
import com.netease.nertcflutter.Messages.AudioMixingApi;
import com.netease.nertcflutter.Messages.BoolValue;
import com.netease.nertcflutter.Messages.CreateEngineRequest;
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
import com.netease.nertcflutter.Messages.SubscribeRemoteAudioStreamRequest;
import com.netease.nertcflutter.Messages.SubscribeRemoteVideoStreamRequest;
import com.netease.nertcflutter.Messages.VideoRendererApi;
import com.netease.yunxin.base.utils.StringUtils;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;

import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_HARDWARE;
import static com.netease.lava.nertc.sdk.NERtcConstants.MediaCodecMode.MEDIA_CODEC_SOFTWARE;

public class NERtcEngine implements EngineApi, AudioEffectApi, AudioMixingApi, DeviceManagerApi, VideoRendererApi {

    private final NERtcCallbackImpl callback;

    private final NERtcStatsObserverImpl observer;

    private EglBase.Context sharedEglContext = null;

    private Context applicationContext;

    private AddActivityResultListener addActivityResultListener;

    private RemoveActivityResultListener removeActivityResultListener;

    private Activity activity;

    private final TextureRegistry registry;

    private final BinaryMessenger messenger;

    private Map<Long, FlutterVideoRenderer> renderers = new HashMap<>();


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
        void onSuccess(@Nullable Object result);
    }

    @FunctionalInterface
    interface CallbackMethod {
        void invokeMethod(@NonNull String method, @Nullable Object arguments);
    }


    NERtcEngine(@NonNull Context applicationContext, @NonNull BinaryMessenger messenger,
                @NonNull CallbackMethod method, @NonNull TextureRegistry registry) {
        this.callback = new NERtcCallbackImpl(method);
        this.observer = new NERtcStatsObserverImpl(method);
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
        final Number screenProfile;
        final RemoveActivityResultListener removeActivityResultListener;
        boolean alreadyCalled = false;

        ActivityResultListener(SuccessCallback successCallback, Number screenProfile, RemoveActivityResultListener removeActivityResultListener) {
            this.successCallback = successCallback;
            this.screenProfile = screenProfile;
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
                        int ret = NERtcEx.getInstance().startScreenCapture(screenProfile.intValue(), data,
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
        NERtcParameters parameters = new NERtcParameters();
        if (arg.getAutoSubscribeAudio() != null) {
            parameters.setBoolean(NERtcParameters.KEY_AUTO_SUBSCRIBE_AUDIO, arg.getAutoSubscribeAudio());
        }
        if (arg.getVideoEncodeMode() != null) {
            parameters.setString(NERtcParameters.KEY_VIDEO_ENCODE_MODE, arg.getVideoEncodeMode() == 0 ? MEDIA_CODEC_HARDWARE : MEDIA_CODEC_SOFTWARE);
        }
        if (arg.getVideoDecodeMode() != null) {
            parameters.setString(NERtcParameters.KEY_VIDEO_DECODE_MODE, arg.getVideoDecodeMode() == 0 ? MEDIA_CODEC_HARDWARE : MEDIA_CODEC_SOFTWARE);
        }
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
        if (arg.getPublishSelfStream() != null) {
            parameters.setBoolean(NERtcParameters.KEY_PUBLISH_SELF_STREAM, arg.getPublishSelfStream());
        }
        if(arg.getVideoSendMode() != null) {
            parameters.setInteger(NERtcParameters.KEY_VIDEO_SEND_MODE, arg.getVideoSendMode().intValue());
        }

        try {
            NERtcEx.getInstance().setParameters(parameters);
            NERtcEx.getInstance().init(applicationContext, appKey, callback, option);
            EglBase.Context localSharedEglContext = getEglSharedContext();
            if (localSharedEglContext != null) {
                sharedEglContext = EglBase.create(localSharedEglContext, EglBase.CONFIG_PLAIN).getEglBaseContext();
            }
        } catch (Exception e) {
            Log.e("NERtcEngine", "Create RTC engine exception:" + e.toString());
            result.setValue(-3L);
        }
        return result;
    }

    @Override
    public IntValue release() {
        NERtcEx.getInstance().setStatsObserver(null);
        callback.setAudioMixingCallbackEnabled(false);
        callback.setDeviceCallbackEnabled(false);
        callback.setAudioEffectCallbackEnabled(false);
        sharedEglContext = null;
        NERtc.getInstance().release();
//        for (Iterator<FlutterVideoRenderer> iterator = renderers.values().iterator(); iterator.hasNext(); ) {
//            FlutterVideoRenderer renderer = iterator.next();
//            if (renderer != null) {
//                renderer.dispose();
//            }
//            iterator.remove();
//        }
        IntValue result = new IntValue();
        result.setValue(0L);
        return result;
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
    public IntValue subscribeRemoteAudioStream(SubscribeRemoteAudioStreamRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeRemoteAudioStream(arg.getUid(), arg.getSubscribe());
        result.setValue((long) ret);
        return result;
    }

    @Override
    public IntValue subscribeAllRemoteAudioStreams(BoolValue arg) {
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
        config.frameRate = toVideoFrameRate(arg.getFrameRate().intValue());
        config.minFramerate = arg.getMinFrameRate().intValue();
        config.bitrate = arg.getBitrate().intValue();
        config.minBitrate = arg.getMinBitrate().intValue();
        config.degradationPrefer = toDegradationPreference(arg.getDegradationPrefer().intValue());

        int ret = NERtcEx.getInstance().setLocalVideoConfig(config);
        result.setValue((long) ret);
        return result;
    }

    private NERtcVideoFrameRate toVideoFrameRate(int value) {
        switch (value) {
            case 7:
                return NERtcVideoFrameRate.FRAME_RATE_FPS_7;
            case 10:
                return NERtcVideoFrameRate.FRAME_RATE_FPS_10;
            case 15:
                return NERtcVideoFrameRate.FRAME_RATE_FPS_15;
            case 24:
                return NERtcVideoFrameRate.FRAME_RATE_FPS_24;
            default:
                return NERtcVideoFrameRate.FRAME_RATE_FPS_30;
        }
    }

    private NERtcDegradationPreference toDegradationPreference(int value) {
        switch (value) {
            case 1:
                return NERtcDegradationPreference.DEGRADATION_MAINTAIN_FRAMERATE;
            case 2:
                return NERtcDegradationPreference.DEGRADATION_MAINTAIN_QUALITY;
            case 3:
                return NERtcDegradationPreference.DEGRADATION_BALANCED;
            default:
                return NERtcDegradationPreference.DEGRADATION_DEFAULT;
        }
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
    public void startScreenCapture(IntValue arg, SuccessCallback successCallback) {
        if (applicationContext == null) {
            Log.e("NERtcEngine", "startScreenCapture error: Android context is required to screen capture and cannot be null.");
            successCallback.onSuccess(-1);
            return;
        }
        if (activity == null) {
            Log.e("NERtcEngine", "startScreenCapture error: Android activity is required to screen capture and cannot be null.");
            successCallback.onSuccess(-2);
            return;
        }
        if (addActivityResultListener == null) {
            Log.e("NERtcEngine", "startScreenCapture error: Activity result listener is required to screen capture and cannot be null.");
            successCallback.onSuccess(-3);
            return;
        }
        if (removeActivityResultListener == null) {
            Log.e("NERtcEngine", "startScreenCapture error: Activity result listener is required to screen capture and cannot be null.");
            successCallback.onSuccess(-4);
            return;
        }

        ActivityResultListener activityResultListener = new ActivityResultListener(successCallback, arg.getValue().intValue(), removeActivityResultListener);
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
    public IntValue subscribeRemoteVideoStream(SubscribeRemoteVideoStreamRequest arg) {
        IntValue result = new IntValue();
        int ret = NERtcEx.getInstance().subscribeRemoteVideoStream(arg.getUid(),
                arg.getStreamType() == 0 ? NERtcRemoteVideoStreamType.kNERtcRemoteVideoStreamTypeHigh : NERtcRemoteVideoStreamType.kNERtcRemoteVideoStreamTypeLow,
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


//////////////////////////////////////////////////////////////////////////////////////////////

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

    @Override
    public IntValue createVideoRenderer() {
        IntValue result = new IntValue();
        TextureRegistry.SurfaceTextureEntry entry = registry.createSurfaceTexture();
        if (sharedEglContext != null) {
            FlutterVideoRenderer renderer = new FlutterVideoRenderer(messenger, entry, sharedEglContext);
            renderers.put(entry.id(), renderer);
            result.setValue(renderer.id());
        } else {
            result.setValue(-1L);
        }
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
    public void disposeVideoRenderer(IntValue arg) {
        FlutterVideoRenderer render = renderers.get(arg.getValue());
        if (render != null) {
            render.dispose();
            renderers.remove(arg.getValue());
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////

    @SuppressWarnings("rawtypes")
    private EglBase.Context getEglSharedContext() {
        try {
            Class clazzNERtc = NERtc.getInstance().getClass();
            Field fieldRtcEngine = clazzNERtc.getDeclaredField("mRtcEngine");
            fieldRtcEngine.setAccessible(true);
            Object rtcEngine = fieldRtcEngine.get(NERtc.getInstance());
            Class clazzRtcEngine = rtcEngine.getClass();
            Method method = clazzRtcEngine.getMethod("getEglSharedContext");
            return (EglBase.Context) method.invoke(rtcEngine);
        } catch (NoSuchFieldException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }
        return null;
    }

}
