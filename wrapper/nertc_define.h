// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef _NERTC_DEFINE_H_
#define _NERTC_DEFINE_H_

// dart invoke c method.
const std::string kNERtcEngineInitial = "Initial";
const std::string kNERtcEngineVersion = "Version";
const std::string kNERtcEngineCreateChannel = "CreateChannel";
const std::string kNERtcJoinChannel = "JoinChannel";
const std::string kNERtcSetParameters = "SetParameters";
const std::string kNERtcEnableLocalAudio = "EnableLocalAudio";
const std::string kNERtcEnableLocalVideo = "EnableLocalVideo";
const std::string kNERtcMuteLocalAudio = "MuteLocalAudio";
const std::string kNERtcMuteLocalVideo = "MuteLocalVideo";
const std::string kNERtcLeaveChannel = "LeaveChannel";
const std::string kNERtcStartPreview = "StartPreview";
const std::string kNERtcStopPreview = "StopPreview";
const std::string kNERtcEnableDualStreamMode = "EnableDualStreamMode";
const std::string kNERtcSetLocalVideoConfig = "SetLocalVideoConfig";
const std::string kNERtcSetAudioProfile = "SetAudioProfile";
const std::string kNERtcSetChannelProfile = "SetChannelProfile";
const std::string kNERtcSubRemoteAudioStream = "SubscribeRemoteAudioStream";
const std::string kNERtcSubRemoteSubAudioStream =
    "SubscribeRemoteSubAudioStream";
const std::string kNERtcSubAllRemoteAudioStream =
    "SubscribeAllRemoteAudioStream";
const std::string kNERtcSubRemoteVideoStream = "SubscribeRemoteVideoStream";
const std::string kNERtcSubRemoteSubVideoStream =
    "SubscribeRemoteSubVideoStream";
const std::string kNERtcEnableVirtualBackground = "EnableVirtualBackground";
const std::string kNERtcEngineUploadSdkInfo = "UploadSdkInfo";
const std::string kNERtcEngineGetConnectionState = "getChannelConnection";
const std::string kNERtcSetMediaStatsObserver = "SetMediaStatsObserver";
const std::string kNERtcSetCameraCaptureConfig = "SetCameraCaptureConfig";
const std::string kNERtcSetAudioSubscribeOnlyBy = "SetAudioSubscribeOnlyBy";
const std::string kNERtcStartAudioDump = "StartAudioDump";
const std::string kNERtcStopAudioDump = "StopAudioDump";
const std::string kNERtcEnableAudioVolumeIndication =
    "EnableAudioVolumeIndication";
const std::string kNERtcAdjustRecordingSignalVolume =
    "AdjustRecordingSignalVolume";
const std::string kNERtcAdjustPlaybackSignalVolume =
    "AdjustPlaybackSignalVolume";
const std::string kNERtcAdjustLoopbackSignalVolume =
    "AdjustLoopbackRecordingSignalVolume";
const std::string kNERtcSetClientRole = "SetClientRole";
const std::string kNERtcSendSEIMsg = "SendSEIMsg";
const std::string kNERtcEngineSwitchChannel = "SwitchChannel";
const std::string kNERtcEngineStartAudioRecording = "StartAudioRecording";
const std::string kNERtcEngineStartAudioRecordingEx =
    "StartAudioRecordingWithConfig";
const std::string kNERtcEngineStopAudioRecording = "StopAudioRecording";
const std::string kNERtcEngineSetLocalMediaPriority = "SetLocalMediaPriority";
const std::string kNERtcEngineEnableMediaPub = "EnableMediaPub";
const std::string kNERtcEngineSetRemoteHighPriorityAudioStream =
    "SetRemoteHighPriorityAudioStream";
const std::string kNERtcEngineSetCloundProxy = "SetCloudProxy";
const std::string kNERtcEngineSetStreamAlignmentProperty =
    "SetStreamAlignmentProperty";
const std::string kNERtcEngineGetNtpTimeOffset = "GetNtpTimeOffset";
const std::string kNERtcEngineTakeLocalSnapshot = "TakeLocalSnapshot";
const std::string kNERtcEngineTakeRemoteSnapshot = "TakeRemoteSnapshot";
const std::string kNERtcEngineSetLocalPublishFallbackOption =
    "SetLocalPublishFallbackOption";
const std::string kNERtcEngineSetRemoteSubscribeFallbackOption =
    "SetRemoteSubscribeFallbackOption";
const std::string kNERtcEngineReportCustomEvent = "ReportCustomEvent";
const std::string kNERtcEngineSetExternalVideoSource = "SetExternalVideoSource";
const std::string kNERtcEngineEnableSuperResolution = "EnableSuperResolution";
const std::string kNERtcEngineEnableEncryption = "EnableEncryption";
const std::string kNERtcRelease = "Release";
const std::string kNERtcEngineCheckNeCastAudioDriver = "NECastAudioDriver";
const std::string kNERtcEngineEnableLoopbackRecording =
    "EnableLoopbackRecording";
const std::string kNERtcEngineSetLocalVideoWaterMarkConfigs =
    "SetLocalVideoWaterMarkConfigs";
const std::string kNERtcEngineAdjustUserPlaybackSignalVolume =
    "AdjustUserPlaybackSignalVolume";

// beauty.
const std::string kNERtcEngineStartBeauty = "StartBeauty";
const std::string kNERtcEngineStopBeauty = "StopBeauty";
const std::string kNERtcEngineEnableBeauty = "EnableBeauty";
const std::string kNERtcEngineSetBeautyEffect = "SetBeautyEffect";
const std::string kNERtcEngineAddBeautyEffectFilter = "AddBeautyEffectFilter";
const std::string kNERtcEngineRemoveBeautyEffectFilter =
    "RemoveBeautyEffectFilter";
const std::string kNERtcEngineSetBeautyFilterLevel = "SetBeautyFilterLevel";

// media relay.
const std::string kNERtcEngineStartChannelMediaRelay = "StartChannelMediaRelay";
const std::string kNERtcEngineStopChannelMediaRelay = "StopChannelMediaRelay";
const std::string kNERtcEngineUpdateChannelMediaRelay =
    "UpdateChannelMediaRelay";

// device control.
const std::string kNERtcEnumerateCaptureDevices = "EnumerateCaptureDevices";
const std::string kNERtcEnumerateAudioDevices = "EnumerateAudioDevices";
const std::string kNERtcGetDeviceCount = "GetDeviceCount";
const std::string kNERtcGetDevice = "GetDevice";
const std::string kNERtcGetDeviceInfo = "GetDeviceInfo";
const std::string kNERtcReleaseDevice = "ReleaseDevice";
const std::string kNERtcSetDevice = "SetDevice";
const std::string kNERtcQueryDevice = "QueryDevice";
const std::string kNERtcEnableEarback = "EnableEarback";
const std::string kNERtcSetEarbackVolume = "SetEarbackVolume";
const std::string kNERtcIsPlayoutDeviceMute = "IsPlayoutDeviceMute";
const std::string kNERtcIsRecordDeviceMute = "IsRecordDeviceMute";
const std::string kNERtcSetRecordDeviceMute = "SetRecordDeviceMute";
const std::string kNERtcSetPlayoutDeviceMute = "SetPlayoutDeviceMute";
const std::string kNERtcChannelGetChannelName = "GetChannelName";

// video render.
const std::string kNERtcEngineCreateFlutterVideoRender = "CreateRender";
const std::string kNERtcEngineDisposeFlutterVideoRender = "DisposeRender";
const std::string kNERtcEngineSetupLocalVideoRender = "SetUpLocalVideoRender";
const std::string kNERtcEngineSetupLocalSubVideoRender =
    "SetUpLocalSubVideoRender";
const std::string kNERtcEngineSetupRemoteVideoRender = "SetUpRemoteVideoRender";
const std::string kNERtcEngineSetupRemoteSubVideoRender =
    "SetUpRemoteSubVideoRender";
const std::string kNERtcEngineSetupPlayingVideoRender =
    "SetUpPlayingStreamCanvas";
const std::string kNERtcEngineSetRenderMirror = "SetRenderMirror";
const std::string kNERtcEngineSetRenderScalingMode = "SetRenderScalingMode";
const std::string kNERtcFlutterRenderOnFirstFrameRender =
    "onFirstFrameRendered";
const std::string kNERtcFlutterRenderOnFrameResolutionChanged =
    "onFrameResolutionChanged";

// c invoke dart callback method.
const std::string kNERtcOnJoinChannel = "onJoinChannel";
const std::string kNERtcOnLeaveChannel = "onLeaveChannel";
const std::string kNERtcOnUserJoined = "onUserJoined";
const std::string kNERtcOnUserLeave = "onUserLeave";
const std::string kNERtcOnUserAudioStart = "onUserAudioStart";
const std::string kNERtcOnUserAudioStop = "onUserAudioStop";
const std::string kNERtcOnUserVideoStart = "onUserVideoStart";
const std::string kNERtcOnUserVideoStop = "onUserVideoStop";
const std::string kNERtcOnError = "onError";
const std::string kNERtcOnWarning = "onWarning";
const std::string kNERtcOnApiCallExecuted = "onApiCallExecuted";
const std::string kNERtcOnReleasedHwResources = "onReleasedHwResources";
const std::string kNERtcOnReconnectingStart = "onReconnectingStart";
const std::string kNERtcOnConnectionStateChange = "onConnectionStateChange";
const std::string kNERtcOnRejoinChannel = "onRejoinChannel";
const std::string kNERtcOnDisconnect = "onDisconnect";
const std::string kNERtcOnClientRoleChanged = "onClientRoleChanged";
const std::string kNERtcOnUserSubStreamAudioStart = "onUserSubStreamAudioStart";
const std::string kNERtcOnUserSubStreamAudioStop = "onUserSubStreamAudioStop";
const std::string kNERtcOnUserAudioMute = "onUserAudioMute";
const std::string kNERtcOnUserVideoMute = "onUserVideoMute";
const std::string kNERtcOnUserSubStreamAudioMute = "onUserSubStreamAudioMute";
const std::string kNERtcOnFirstAudioDataReceived = "onFirstAudioDataReceived";
const std::string kNERtcOnFirstVideoDataReceived = "onFirstVideoDataReceived";
const std::string kNERtcOnFirstAudioFrameDecoded = "onFirstAudioFrameDecoded";
const std::string kNERtcOnFirstVideoFrameDecoded = "onFirstVideoFrameDecoded";
const std::string kNERtcOnVirtualBackgroundSourceEnabled =
    "onVirtualBackgroundSourceEnabled";
const std::string kNERtcOnNetworkConnectionTypeChanged =
    "onNetworkConnectionTypeChanged";
const std::string kNERtcOnLocalAudioVolumeIndication =
    "onLocalAudioVolumeIndication";
const std::string kNERtcOnRemoteAudioVolumeIndication =
    "onRemoteAudioVolumeIndication";
const std::string kNERtcOnAudioHasHowling = "onAudioHasHowling";
const std::string kNERtcOnRecvSEIMsg = "onRecvSEIMsg";
const std::string kNERtcOnAudioRecording = "onAudioRecording";
const std::string kNERtcOnMediaRightChange = "onMediaRightChange";
const std::string kNERtcOnMediaRelayStateChanged = "onMediaRelayStateChanged";
const std::string kNERtcOnMediaRelayEvent = "onMediaRelayEvent";
const std::string kNERtcOnLocalPublishFallbackToAudioOnly =
    "onLocalPublishFallbackToAudioOnly";
const std::string kNERtcOnRemoteSubscribeFallbackToAudioOnly =
    "onRemoteSubscribeFallbackToAudioOnly";
const std::string kNERtcOnTakeSnapshot = "onTakeSnapshot";
const std::string kNERtcOnLocalVideoWatermarkState =
    "onLocalVideoWatermarkState";
const std::string kNERtcOnUserSubVideoStreamStart = "onUserSubVideoStreamStart";
const std::string kNERtcOnUserSubVideoStreamStop = "onUserSubVideoStreamStop";
const std::string kNERtcOnAsrCaptionStateChanged = "onAsrCaptionStateChanged";
const std::string kNERtcOnAsrCaptionResult = "onAsrCaptionResult";
const std::string kNERtcOnPlayStreamingStateChange =
    "onPlayStreamingStateChange";
const std::string kNERtcOnPlayStreamingReceiveSeiMessage =
    "onPlayStreamingReceiveSeiMessage";
const std::string kNERtcOnPlayStreamingFirstAudioFramePlayed =
    "onPlayStreamingFirstAudioFramePlayed";
const std::string kNERtcOnPlayStreamingFirstVideoFrameRender =
    "onPlayStreamingFirstVideoFrameRender";
const std::string kNERtcOnLocalAudioFirstPacketSent =
    "onLocalAudioFirstPacketSent";
const std::string kNERtcOnFirstVideoFrameRender = "onFirstVideoFrameRender";
const std::string kNERtcOnLocalVideoRenderSizeChanged =
    "onLocalVideoRenderSizeChanged";
const std::string kNERtcOnUserVideoProfileUpdate = "onUserVideoProfileUpdate";
const std::string kNERtcOnAudioDeviceChanged = "onAudioDeviceChanged";
const std::string kNERtcOnAudioDeviceStateChange = "onAudioDeviceStateChange";
const std::string kNERtcOnVideoDeviceStageChange = "onVideoDeviceStageChange";
const std::string kNERtcOnRemoteVideoSizeChanged = "onRemoteVideoSizeChanged";
const std::string kNERtcOnUserDataStart = "onUserDataStart";
const std::string kNERtcOnUserDataStop = "onUserDataStop";
const std::string kNERtcOnUserDataReceiveMessage = "onUserDataReceiveMessage";
const std::string kNERtcOnUserDataStateChanged = "onUserDataStateChanged";
const std::string kNERtcOnUserDataBufferedAmountChanged =
    "onUserDataBufferedAmountChanged";
const std::string kNERtcOnLabFeatureCallback = "onLabFeatureCallback";
const std::string kNERtcOnAiData = "onAiData";
const std::string kNERtcOnStartPushStreaming = "onStartPushStreaming";
const std::string kNERtcOnStopPushStreaming = "onStopPushStreaming";
const std::string kNERtcOnPushStreamingReconnecting =
    "onPushStreamingReconnecting";
const std::string kNERtcOnPushStreamingReconnectedSuccess =
    "onPushStreamingReconnectedSuccess";
const std::string kNERtcOnScreenCaptureStatus = "onScreenCaptureStatus";
const std::string kNERtcOnScreenCaptureSourceDataUpdate =
    "onScreenCaptureSourceDataUpdate";
const std::string kNERtcOnLocalRecorderStatus = "onLocalRecorderStatus";
const std::string kNERtcOnLocalRecorderError = "onLocalRecorderError";
const std::string kNERtcOnCheckNECastAudioDriverResult =
    "onCheckNECastAudioDriverResult";

// audio reverb && preset.
const std::string kNERtcEngineSetLocalVoiceReverbParam =
    "SetLocalVoiceReverbParam";
const std::string kNERtcEngineSetAudioEffectPreset = "SetAudioEffectPreset";
const std::string kNERtcEngineSetVoiceBeautifierPreset =
    "SetVoiceBeautifierPreset";
const std::string kNERtcEngineSetLocalVoicePitch = "SetLocalVoicePitch";
const std::string kNERtcEngineSetLocalVoiceEqualization =
    "SetLocalVoiceEqualization";

// screen capture.
const std::string kNERtcEngineGetScreenCaptureSources =
    "GetScreenCaptureSources";
const std::string kNERtcEngineReleaseCaptureSources = "ReleaseCaptureSources";
const std::string kNERtcEngineGetCaptureCount = "GetScreenCaptureCount";
const std::string kNERtcEngineGetCaptureSourceInfo =
    "GetScreenCaptureSourceInfo";

const std::string kNERtcEngineStartScreenCaptureByScreenRect =
    "StartScreenCaptureByScreenRect";
const std::string kNERtcEngineStartScreenCaptureByDisplayId =
    "StartScreenCaptureByDisplayId";
const std::string kNERtcEngineStartScreenCaptureByWindowId =
    "StartScreenCaptureByWindowId";
const std::string kNERtcEngineSetScreenCaptureSource = "SetScreenCaptureSource";
const std::string kNERtcEngineUpdateScreenCaptureRegion =
    "UpdateScreenCaptureRegion";
const std::string kNERtcEngineSetScreenCaptureMouseCursor =
    "SetScreenCaptureMouseCursor";
const std::string kNERtcEngineStopScreenCapture = "StopScreenCapture";
const std::string kNERtcEnginePauseScreenCapture = "PauseScreenCapture";
const std::string kNERtcEngineResumeScreenCapture = "ResumeScreenCapture";
const std::string kNERtcEngineSetExcludeWindowList = "SetExcludeWindowList";
const std::string kNERtcEngineUpdateScreenCaptureParameters =
    "UpdateScreenCaptureParameters";

// last mile probe test.
const std::string kNERtcEngineStartLastMileProbeTest = "StartLastMileProbeTest";
const std::string kNERtcEngineStopLastMileProbeTest = "StopLastMileProbeTest";
const std::string kNERtcEngineOnLastmileQuality = "OnLastmileQuality";
const std::string kNERtcEngineOnLastmileProbeResult = "OnLastmileProbeResult";

// live stream task.
const std::string kNERtcEngineAddLiveStreamTask = "AddLiveStreamTaskInfo";
const std::string kNERtcEngineRemoveLiveStreamTask = "RemoveLiveStreamTaskInfo";
const std::string kNERtcEngineUpdateLiveStreamTask = "UpdateLiveStreamTaskInfo";
const std::string kNERtcOnAddLiveStreamTask = "onAddLiveStreamTask";
const std::string kNERtcOnRemoveLiveStreamTask = "onRemoveLiveStreamTask";
const std::string kNERtcOnUpdateLiveStreamTask = "onUpdateLiveStreamTask";
const std::string kNERtcOnLiveStreamStateChanged = "onLiveStreamStateChanged";

// audio mixing.
const std::string kNERtcEngineStartAudioMixing = "StartAudioMixing";
const std::string kNERtcEngineStopAudioMixing = "StopAudioMixing";
const std::string kNERtcEnginePauseAudioMixing = "PauseAudioMixing";
const std::string kNERtcEngineResumeAudioMixing = "ResumeAudioMixing";
const std::string kNERtcEngineSetAudioMixingSendVolume =
    "SetAudioMixingSendVolume";
const std::string kNERtcEngineGetAudioMixingSendVolume =
    "GetAudioMixingSendVolume";
const std::string kNERtcEngineSetAudioMixingPlaybackVolume =
    "SetAudioMixingPlaybackVolume";
const std::string kNERtcEngineGetAudioMixingPlaybackVolume =
    "GetAudioMixingPlaybackVolume";
const std::string kNERtcEngineGetAudioMixingDuration = "GetAudioMixingDuration";
const std::string kNERtcEngineGetAudioMixingCurrentPosition =
    "GetAudioMixingCurrentPosition";
const std::string kNERtcEngineSetAudioMixingPosition = "SetAudioMixingPosition";
const std::string kNERtcEngineSetAudioMixingPitch = "SetAudioMixingPitch";
const std::string kNERtcEngineGetAudioMixingPitch = "GetAudioMixingPitch";
const std::string kNERtcOnAudioMixingStateChanged = "onAudioMixingStateChanged";
const std::string kNERtcOnAudioMixingTimestampUpdate =
    "onAudioMixingTimestampUpdate";

// audio effect.
const std::string kNERtcEngineStartAudioEffect = "StartAudioEffect";
const std::string kNERtcEngineStopAudioEffect = "StopAudioEffect";
const std::string kNERtcEngineStopAllAudioEffects = "StopAllAudioEffects";
const std::string kNERtcEnginePauseAudioEffect = "PauseAudioEffect";
const std::string kNERtcEngineResumeAudioEffect = "ResumeAudioEffect";
const std::string kNERtcEnginePauseAllAudioEffects = "PauseAllAudioEffects";
const std::string kNERtcEngineResumeAllAudioEffects = "ResumeAllAudioEffects";
const std::string kNERtcEngineSetAudioEffectSendVolume =
    "SetAudioEffectSendVolume";
const std::string kNERtcEngineGetAudioEffectSendVolume =
    "GetAudioEffectSendVolume";
const std::string kNERtcEngineSetAudioEffectPlaybackVolume =
    "SetAudioEffectPlaybackVolume";
const std::string kNERtcEngineGetAudioEffectPlaybackVolume =
    "GetAudioEffectPlaybackVolume";
const std::string kNERtcEngineGetAudioEffectDuration = "GetAudioEffectDuration";
const std::string kNERtcEngineGetAUdioEffectCurrentPosition =
    "GetAudioEffectCurrentPosition";
const std::string kNERtcEngineSetAudioEffectPosition = "SetAudioEffectPosition";
const std::string kNERtcEngineSetAudioEffectPitch = "SetAudioEffectPitch";
const std::string kNERtcEngineGetAudioEffectPitch = "GetAudioEffectPitch";
const std::string kNERtcOnAudioEffectFinished = "onAudioEffectFinished";
const std::string kNERtcOnAudioEffectTimestampUpdate =
    "onAudioEffectTimestampUpdate";

// c invoke dart media stats callback method.
const std::string kNERtcOnStats = "onRtcStats";
const std::string kNERtcOnLocalAudioStats = "onLocalAudioStats";
const std::string kNERtcOnRemoteAudioStats = "onRemoteAudioStats";
const std::string kNERtcOnLocalVideoStats = "onLocalVideoStats";
const std::string kNERtcOnRemoteVideoStats = "onRemoteVideoStats";
const std::string kNERtcOnNetworkQuality = "onNetworkQuality";

const std::string kNERtcEngineSetVideoDump = "SetVideoDump";
const std::string kNERtcEngineGetParameter = "GetParameter";
const std::string kNERtcEngineSetVideoStreamLayerCount =
    "SetVideoStreamLayerCount";
const std::string kNERtcEngineEnableLocalData = "EnableLocalData";
const std::string kNERtcEngineSubscribeRemoteData = "SubscribeRemoteData";
const std::string kNERtcEngineGetFeatureSupportedType =
    "GetFeatureSupportedType";
const std::string kNERtcEngineIsFeatureSupported = "IsFeatureSupported";
const std::string kNERtcEngineSetSubscribeAudioBlocklist =
    "SetSubscribeAudioBlocklist";
const std::string kNERtcEngineSetSubscribeAudioAllowlist =
    "SetSubscribeAudioAllowlist";
const std::string kNERtcEngineGetNetworkType = "GetNetworkType";
const std::string kNERtcEngineStopPushStreaming = "StopPushStreaming";
const std::string kNERtcEngineStopPlayStreaming = "StopPlayStreaming";
const std::string kNERtcEnginePausePlayStreaming = "PausePlayStreaming";
const std::string kNERtcEngineResumePlayStreaming = "ResumePlayStreaming";
const std::string kNERtcEngineMuteVideoForPlayStreaming =
    "MuteVideoForPlayStreaming";
const std::string kNERtcEngineMuteAudioForPlayStreaming =
    "MuteAudioForPlayStreaming";
const std::string kNERtcEngineStopASRCaption = "StopASRCaption";
const std::string kNERtcEngineAiManualInterrupt = "AIManualInterrupt";
const std::string kNERtcEngineAINSMode = "SetAINSMode";
const std::string kNERtcEngineSetAudioScenario = "SetAudioScenario";
const std::string kNERtcEngineSetExternalAudioSource = "SetExternalAudioSource";
const std::string kNERtcEngineSetExternalSubStreamAudioSource =
    "SetExternalSubStreamAudioSource";
const std::string kNERtcEngineSetAudioRecvRange = "SetAudioRecvRange";
const std::string kNERtcEngineSetRangeAudioMode = "SetRangeAudioMode";
const std::string kNERtcEngineSetRangeAudioTeamID = "SetRangeAudioTeamID";
const std::string kNERtcEngineEnableSpatializerRoomEffects =
    "EnableSpatializerRoomEffects";
const std::string kNERtcEngineSetSpatializerRenderMode =
    "SetSpatializerRenderMode";
const std::string kNERtcEngineEnableSpatializer = "EnableSpatializer";
const std::string kNERtcEngineInitSpatializer = "IitSpatializer";
const std::string kNERtcEngineUpdateSelfPosition = "UpdateSelfPosition";
const std::string kNERtcEngineSetSpatializerRoomProperty =
    "SetSpatializerRoomProperty";

// local recording.
const std::string kNERtcEngineAddLocalRecorderStreamForTask =
    "AddLocalRecorderStreamForTask";
const std::string kNERtcEngineRemoveLocalRecorderStreamForTask =
    "RemoveLocalRecorderStreamForTask";
const std::string kNERtcEngineAddLocalRecorderStreamLayoutForTask =
    "AddLocalRecorderStreamLayoutForTask";
const std::string kNERtcEngineRemoveLocalRecorderStreamLayoutForTask =
    "RemoveLocalRecorderStreamLayoutForTask";
const std::string kNERtcEngineUpdateLocalRecorderStreamLayoutForTask =
    "UpdateLocalRecorderStreamLayoutForTask";
const std::string kNERtcEngineReplaceLocalRecorderStreamLayoutForTask =
    "ReplaceLocalRecorderStreamLayoutForTask";
const std::string kNERtcEngineUpdateLocalRecorderWaterMarksForTask =
    "UpdateLocalRecorderWaterMarksForTask";
const std::string kNERtcEnginePushLocalRecorderVideoFrameForTask =
    "PushLocalRecorderVideoFrameForTask";
const std::string kNERtcEngineShowLocalRecorderStreamDefaultCoverForTask =
    "ShowLocalRecorderStreamDefaultCoverForTask";
const std::string kNERtcEngineStopLocalRecorderRemuxMp4 =
    "StopLocalRecorderRemuxMp4";
const std::string kNERtcEngineRemuxFlvToMp4 = "RemuxFlvToMp4";
const std::string kNERtcEngineStopRemuxFlvToMp4 = "StopRemuxFlvToMp4";
const std::string kNERtcEngineStartPushStreaming = "StartPushStreaming";
const std::string kNERtcEngineStartPlayStreaming = "StartPlayStreaming";
const std::string kNERtcEngineStartASRCaption = "StartASRCaption";
const std::string kNERtcEngineSetMultiPathOption = "SetMultiPathOption";

#endif  // _NERTC_DEFINE_H_
