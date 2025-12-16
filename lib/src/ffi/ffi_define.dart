// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class InvokeMethod {
  static const String kNERtcEngineInitial = "Initial";
  static const String kNERtcEngineVersion = "Version";
  static const String kNERtcEngineCreateChannel = "CreateChannel";
  static const String kNERtcEngineJoinChannel = "JoinChannel";
  static const String kNERtcEngineLeaveChannel = "LeaveChannel";
  static const String kNERtcEngineSetParameters = "SetParameters";
  static const String kNERtcEngineEnableLocalAudio = "EnableLocalAudio";
  static const String kNERtcEngineEnableLocalVideo = "EnableLocalVideo";
  static const String kNERtcEngineMuteLocalAudio = "MuteLocalAudio";
  static const String kNERtcEngineMuteLocalVideo = "MuteLocalVideo";
  static const String kNERtcEngineStartPreview = "StartPreview";
  static const String kNERtcEngineStopPreview = "StopPreview";
  static const String kNERtcEngineSetAudioProfile = "SetAudioProfile";
  static const String kNERtcEngineEnableDualStreamMode = "EnableDualStreamMode";
  static const String kNERtcEngineSetLocalVideoConfig = "SetLocalVideoConfig";
  static const String kNERtcEngineSetChannelProfile = "SetChannelProfile";
  static const String kNERtcEngineSubscribeRemoteAudioStream =
      "SubscribeRemoteAudioStream";
  static const String kNERtcEngineSubscribeRemoteSubAudioStream =
      "SubscribeRemoteSubAudioStream";
  static const String kNERtcEngineSubscribeAllRemoteAudioStream =
      "SubscribeAllRemoteAudioStream";
  static const String kNERtcEngineSubscribeRemoteVideoStream =
      "SubscribeRemoteVideoStream";
  static const String kNERtcEngineSubscribeRemoteSubVideoStream =
      "SubscribeRemoteSubVideoStream";
  static const String kNERtcEngineEnableVirtualBackground =
      "EnableVirtualBackground";
  static const String kNERtcEngineUploadSdkInfo = "UploadSdkInfo";
  static const String kNERtcEngineGetChannelConnection = "getChannelConnection";
  static const String kNERtcSetMediaStatsObserver = "SetMediaStatsObserver";
  static const String kNERtcEngineSetCaptureConfig = "SetCameraCaptureConfig";
  static const String kNERtcEngineSetAudioSubscribeOnlyBy =
      "SetAudioSubscribeOnlyBy";
  static const String kNERtcEngineStartAudioDump = "StartAudioDump";
  static const String kNERtcEngineStopAudioDump = "StopAudioDump";
  static const String kNERtcEngineEnableAudioVolumeIndication =
      "EnableAudioVolumeIndication";
  static const String kNERtcEngineAdjustRecordingSignalVolume =
      "AdjustRecordingSignalVolume";
  static const String kNERtcEngineAdjustPlaybackSignalVolume =
      "AdjustPlaybackSignalVolume";
  static const String kNERtcEngineAdjustLoopbackRecordingSignalVolume =
      "AdjustLoopbackRecordingSignalVolume";
  static const String kNERtcEngineSetClientRole = "SetClientRole";
  static const String kNERtcEngineSendSEIMsg = "SendSEIMsg";
  static const String kNERtcEngineSwitchChannel = "SwitchChannel";
  static const String kNERtcEngineStartAudioRecording = "StartAudioRecording";
  static const String kNERtcEngineStartAudioRecordingWithConfig =
      "StartAudioRecordingWithConfig";
  static const String kNERtcEngineStopAudioRecording = "StopAudioRecording";
  static const String kNERtcEngineSetLocalMediaPriority =
      "SetLocalMediaPriority";
  static const String kNERtcEngineEnableMediaPub = "EnableMediaPub";
  static const String kNERtcEngineSetRemoteHighPriorityAudioStream =
      "SetRemoteHighPriorityAudioStream";
  static const String kNERtcEngineSetCloudProxy = "SetCloudProxy";
  static const String kNERtcEngineSetStreamAlignmentProperty =
      "SetStreamAlignmentProperty";
  static const String kNERtcEngineGetNtpTimeOffset = "GetNtpTimeOffset";
  static const String kNERtcEngineTakeLocalSnapshot = "TakeLocalSnapshot";
  static const String kNERtcEngineTakeRemoteSnapshot = "TakeRemoteSnapshot";
  static const String kNERtcEngineSetLocalPublishFallbackOption =
      "SetLocalPublishFallbackOption";
  static const String kNERtcEngineSetRemoteSubscribeFallbackOption =
      "SetRemoteSubscribeFallbackOption";
  static const String kNERtcEngineStartLastMileProbeTest =
      "StartLastMileProbeTest";
  static const String kNERtcEngineStopLastMileProbeTest =
      "StopLastMileProbeTest";
  static const String kNERtcEngineAddLiveStreamTaskInfo =
      "AddLiveStreamTaskInfo";
  static const String kNERtcEngineUpdateLiveStreamTaskInfo =
      "UpdateLiveStreamTaskInfo";
  static const String kNERtcEngineRemoveLiveStreamTaskInfo =
      "RemoveLiveStreamTaskInfo";
  static const String kNERtcEngineReportCustomEvent = "ReportCustomEvent";
  static const String kNERtcEngineEnableSuperResolution =
      "EnableSuperResolution";
  static const String kNERtcEngineEnableEncryption = "EnableEncryption";
  static const String kNERtcEngineRelease = "Release";
  static const String kNERtcEnableLoopbackRecording = "EnableLoopbackRecording";
  static const String kNERtcCheckNeCastAudioDriver = "NECastAudioDriver";
  static const String kNERtcSetLocalVideoWaterMarkConfigs =
      "SetLocalVideoWaterMarkConfigs";
  static const String kNERtcAdjustUserPlaybackSignalVolume =
      "AdjustUserPlaybackSignalVolume";
  static const String kNERtcChannelGetChannelName = "GetChannelName";

  //beauty.
  static const String kNERtcEngineStartBeauty = "StartBeauty";
  static const String kNERtcEngineStopBeauty = "StopBeauty";
  static const String kNERtcEngineEnableBeauty = "EnableBeauty";
  static const String kNERtcEngineSetBeautyEffect = "SetBeautyEffect";
  static const String kNERtcEngineAddBeautyEffectFilter =
      "AddBeautyEffectFilter";
  static const String kNERtcEngineRemoveBeautyEffectFilter =
      "RemoveBeautyEffectFilter";
  static const String kNERtcEngineSetBeautyFilterLevel = "SetBeautyFilterLevel";

  //media relay.
  static const String kNERtcEngineStartChannelMediaRelay =
      "StartChannelMediaRelay";
  static const String kNERtcEngineUpdateChannelMediaRelay =
      "UpdateChannelMediaRelay";
  static const String kNERtcEngineStopChannelMediaRelay =
      "StopChannelMediaRelay";

  // device control.
  static const String kNERtcEnumerateCaptureDevices = "EnumerateCaptureDevices";
  static const String kNERtcEnumerateAudioDevices = "EnumerateAudioDevices";
  static const String kNERtcGetDeviceCount = "GetDeviceCount";
  static const String kNERtcGetDevice = "GetDevice";
  static const String kNERtcGetDeviceInfo = "GetDeviceInfo";
  static const String kNERtcReleaseDevice = "ReleaseDevice";
  static const String kNERtcSetDevice = "SetDevice";
  static const String kNERtcQueryDevice = "QueryDevice";
  static const String kNERtcSetEarback = "EnableEarback";
  static const String kNERtcSetEarbackVolume = "SetEarbackVolume";
  static const String kNERtcIsPlayoutDeviceMute = "IsPlayoutDeviceMute";
  static const String kNERtcIsRecordDeviceMute = "IsRecordDeviceMute";
  static const String kNERtcSetPlayoutDeviceMute = "SetPlayoutDeviceMute";
  static const String kNERtcSetRecordDeviceMute = "SetRecordDeviceMute";

  // render manager.
  static const String kNERtcEngineCreateRender = "CreateRender";
  static const String kNERtcEngineSetRenderMirror = "SetRenderMirror";
  static const String kNERtcEngineSetRenderScalingMode = "SetRenderScalingMode";
  static const String kNERtcEngineSetUpLocalVideoRender =
      "SetUpLocalVideoRender";
  static const String kNERtcEngineSetUpRemoteVideoRender =
      "SetUpRemoteVideoRender";
  static const String kNERtcEngineSetUpPlayingStreamRender =
      "SetUpPlayingStreamCanvas";
  static const String kNERtcEngineDisposeRender = "DisposeRender";

  //audio mixing
  static const String kNERtcEngineStartAudioMixing = "StartAudioMixing";
  static const String kNERtcEngineStopAudioMixing = "StopAudioMixing";
  static const String kNERtcEnginePauseAudioMixing = "PauseAudioMixing";
  static const String kNERtcEngineResumeAudioMixing = "ResumeAudioMixing";
  static const String kNERtcEngineSetAudioMixingSendVolume =
      "SetAudioMixingSendVolume";
  static const String kNERtcEngineGetAudioMixingSendVolume =
      "GetAudioMixingSendVolume";
  static const String kNERtcEngineSetAudioMixingPlaybackVolume =
      "SetAudioMixingPlaybackVolume";
  static const String kNERtcEngineGetAudioMixingPlaybackVolume =
      "GetAudioMixingPlaybackVolume";
  static const String kNERtcEngineGetAudioMixingDuration =
      "GetAudioMixingDuration";
  static const String kNERtcEngineGetAudioMixingCurrentPosition =
      "GetAudioMixingCurrentPosition";
  static const String kNERtcEngineSetAudioMixingPosition =
      "SetAudioMixingPosition";
  static const String kNERtcEngineSetAudioMixingPitch = "SetAudioMixingPitch";
  static const String kNERtcEngineGetAudioMixingPitch = "GetAudioMixingPitch";

  //audio effect.
  static const String kNERtcEngineStartAudioEffect = "StartAudioEffect";
  static const String kNERtcEngineStopAudioEffect = "StopAudioEffect";
  static const String kNERtcEngineStopAllAudioEffects = "StopAllAudioEffects";
  static const String kNERtcEnginePauseAudioEffect = "PauseAudioEffect";
  static const String kNERtcEngineResumeEffect = "ResumeAudioEffect";
  static const String kNERtcEnginePauseAllEffects = "PauseAllAudioEffects";
  static const String kNERtcEngineResumeAllEffects = "ResumeAllAudioEffects";
  static const String kNERtcEngineSetEffectSendVolume =
      "SetAudioEffectSendVolume";
  static const String kNERtcEngineGetEffectSendVolume =
      "GetAudioEffectSendVolume";
  static const String kNERtcEngineSetEffectPlaybackVolume =
      "SetAudioEffectPlaybackVolume";
  static const String kNERtcEngineGetEffectPlaybackVolume =
      "GetAudioEffectPlaybackVolume";
  static const String kNERtcEngineGetEffectDuration = "GetAudioEffectDuration";
  static const String kNERtcEngineGetEffectCurrentPosition =
      "GetAudioEffectCurrentPosition";
  static const String kNERtcEngineSetEffectPitch = "SetAudioEffectPitch";
  static const String kNERtcEngineGetEffectPitch = "GetAudioEffectPitch";
  static const String kNERtcEngineSetEffectPosition = "SetAudioEffectPosition";
  static const String kNERtcEngineSetExternalVideoSource =
      "SetExternalVideoSource";

  static const String kNERtcEngineSetVideoDump = "SetVideoDump";
  static const String kNERtcEngineGetParameter = "GetParameter";
  static const String kNERtcEngineSetVideoStreamLayerCount =
      "SetVideoStreamLayerCount";
  static const String kNERtcEngineEnableLocalData = "EnableLocalData";
  static const String kNERtcEngineSubscribeRemoteData = "SubscribeRemoteData";
  static const String kNERtcEngineGetFeatureSupportedType =
      "GetFeatureSupportedType";
  static const String kNERtcEngineIsFeatureSupported = "IsFeatureSupported";
  static const String kNERtcEngineSetSubscribeAudioBlocklist =
      "SetSubscribeAudioBlocklist";
  static const String kNERtcEngineSetSubscribeAudioAllowlist =
      "SetSubscribeAudioAllowlist";
  static const String kNERtcEngineGetNetworkType = "GetNetworkType";
  static const String kNERtcEngineStopPushStreaming = "StopPushStreaming";
  static const String kNERtcEngineStopPlayStreaming = "StopPlayStreaming";
  static const String kNERtcEnginePausePlayStreaming = "PausePlayStreaming";
  static const String kNERtcEngineResumePlayStreaming = "ResumePlayStreaming";
  static const String kNERtcEngineMuteVideoForPlayStreaming =
      "MuteVideoForPlayStreaming";
  static const String kNERtcEngineMuteAudioForPlayStreaming =
      "MuteAudioForPlayStreaming";
  static const String kNERtcEngineStopASRCaption = "StopASRCaption";
  static const String kNERtcEngineAiManualInterrupt = "AIManualInterrupt";
  static const String kNERtcEngineAINSMode = "SetAINSMode";
  static const String kNERtcEngineSetAudioScenario = "SetAudioScenario";
  static const String kNERtcEngineSetExternalAudioSource =
      "SetExternalAudioSource";
  static const String kNERtcEngineSetExternalSubStreamAudioSource =
      "SetExternalSubStreamAudioSource";
  static const String kNERtcEngineSetAudioRecvRange = "SetAudioRecvRange";
  static const String kNERtcEngineSetRangeAudioMode = "SetRangeAudioMode";
  static const String kNERtcEngineSetRangeAudioTeamID = "SetRangeAudioTeamID";
  static const String kNERtcEngineEnableSpatializerRoomEffects =
      "EnableSpatializerRoomEffects";
  static const String kNERtcEngineSetSpatializerRenderMode =
      "SetSpatializerRenderMode";
  static const String kNERtcEngineEnableSpatializer = "EnableSpatializer";
  static const String kNERtcEngineInitSpatializer = "IitSpatializer";
  static const String kNERtcEngineUpdateSelfPosition = "UpdateSelfPosition";
  static const String kNERtcEngineSetSpatializerRoomProperty =
      "SetSpatializerRoomProperty";

  static const String kNERtcEngineAddLocalRecorderStreamForTask =
      "AddLocalRecorderStreamForTask";
  static const String kNERtcEngineRemoveLocalRecorderStreamForTask =
      "RemoveLocalRecorderStreamForTask";
  static const String kNERtcEngineAddLocalRecorderStreamLayoutForTask =
      "AddLocalRecorderStreamLayoutForTask";
  static const String kNERtcEngineRemoveLocalRecorderStreamLayoutForTask =
      "RemoveLocalRecorderStreamLayoutForTask";
  static const String kNERtcEngineUpdateLocalRecorderStreamLayoutForTask =
      "UpdateLocalRecorderStreamLayoutForTask";
  static const String kNERtcEngineReplaceLocalRecorderStreamLayoutForTask =
      "ReplaceLocalRecorderStreamLayoutForTask";
  static const String kNERtcEngineUpdateLocalRecorderWaterMarksForTask =
      "UpdateLocalRecorderWaterMarksForTask";
  static const String kNERtcEnginePushLocalRecorderVideoFrameForTask =
      "PushLocalRecorderVideoFrameForTask";
  static const String kNERtcEngineShowLocalRecorderStreamDefaultCoverForTask =
      "ShowLocalRecorderStreamDefaultCoverForTask";
  static const String kNERtcEngineStopLocalRecorderRemuxMp4 =
      "StopLocalRecorderRemuxMp4";
  static const String kNERtcEngineRemuxFlvToMp4 = "RemuxFlvToMp4";
  static const String kNERtcEngineStopRemuxFlvToMp4 = "StopRemuxFlvToMp4";
  static const String kNERtcEngineStartPushStreaming = "StartPushStreaming";
  static const String kNERtcEngineStartPlayStreaming = "StartPlayStreaming";
  static const String kNERtcEngineStartASRCaption = "StartASRCaption";
  static const String kNERtcEngineSetMultiPathOption = "SetMultiPathOption";
}

class AudioReverbPresentMethod {
  static const String kNERtcEngineSetLocalVoiceReverbParam =
      "SetLocalVoiceReverbParam";
  static const String kNERtcEngineSetAudioEffectPreset = "SetAudioEffectPreset";
  static const String kNERtcEngineSetVoiceBeautifierPreset =
      "SetVoiceBeautifierPreset";
  static const String kNERtcEngineSetLocalVoicePitch = "SetLocalVoicePitch";
  static const String kNERtcEngineSetLocalVoiceEqualization =
      "SetLocalVoiceEqualization";
}

class ScreenCaptureMethod {
  static const String kNERtcEngineGetScreenCaptureSources =
      "GetScreenCaptureSources";
  static const String kNERtcEngineReleaseCaptureSources =
      "ReleaseCaptureSources";
  static const String kNERtcEngineGetCaptureCount = "GetScreenCaptureCount";
  static const String kNERtcEngineGetCaptureSourceInfo =
      "GetScreenCaptureSourceInfo";

  static const String kNERtcEngineStartScreenCaptureByScreenRect =
      "StartScreenCaptureByScreenRect";
  static const String kNERtcEngineStartScreenCaptureByDisplayId =
      "StartScreenCaptureByDisplayId";
  static const String kNERtcEngineStartScreenCaptureByWindowId =
      "StartScreenCaptureByWindowId";
  static const String kNERtcEngineSetScreenCaptureSource =
      "SetScreenCaptureSource";
  static const String kNERtcEngineUpdateScreenCaptureRegion =
      "UpdateScreenCaptureRegion";
  static const String kNERtcEngineSetScreenCaptureMouseCursor =
      "SetScreenCaptureMouseCursor";
  static const String kNERtcEngineStopScreenCapture = "StopScreenCapture";
  static const String kNERtcEnginePauseScreenCapture = "PauseScreenCapture";
  static const String kNERtcEngineResumeScreenCapture = "ResumeScreenCapture";
  static const String kNERtcEngineSetExcludeWindowList = "SetExcludeWindowList";
  static const String kNERtcEngineUpdateScreenCaptureParameters =
      "UpdateScreenCaptureParameters";
}

class DelegateMethod {
  static const String kNERtcOnJoinChannel = "onJoinChannel";
  static const String kNERtcOnLeaveChannel = "onLeaveChannel";
  static const String kNERtcOnUserJoined = "onUserJoined";
  static const String kNERtcOnUserLeave = "onUserLeave";
  static const String kNERtcOnUserAudioStart = "onUserAudioStart";
  static const String kNERtcOnUserAudioStop = "onUserAudioStop";
  static const String kNERtcOnUserVideoStart = "onUserVideoStart";
  static const String kNERtcOnUserVideoStop = "onUserVideoStop";
  static const String kNERtcOnError = "onError";
  static const String kNERtcOnWarning = "onWarning";
  static const String kNERtcOnApiCallExecuted = "onApiCallExecuted";
  static const String kNERtcOnReleasedHwResources = "onReleasedHwResources";
  static const String kNERtcOnReconnectingStart = "onReconnectingStart";
  static const String kNERtcOnConnectionStateChange = "onConnectionStateChange";
  static const String kNERtcOnRejoinChannel = "onRejoinChannel";
  static const String kNERtcOnDisconnect = "onDisconnect";
  static const String kNERtcOnClientRoleChanged = "onClientRoleChanged";
  static const String kNERtcOnUserSubStreamAudioStart =
      "onUserSubStreamAudioStart";
  static const String kNERtcOnUserSubStreamAudioStop =
      "onUserSubStreamAudioStop";
  static const String kNERtcOnUserAudioMute = "onUserAudioMute";
  static const String kNERtcOnUserVideoMute = "onUserVideoMute";
  static const String kNERtcOnUserSubStreamAudioMute =
      "onUserSubStreamAudioMute";
  static const String kNERtcOnFirstAudioDataReceived =
      "onFirstAudioDataReceived";
  static const String kNERtcOnFirstVideoDataReceived =
      "onFirstVideoDataReceived";
  static const String kNERtcOnFirstAudioFrameDecoded =
      "onFirstAudioFrameDecoded";
  static const String kNERtcOnFirstVideoFrameDecoded =
      "onFirstVideoFrameDecoded";
  static const String kNERtcOnVirtualBackgroundSourceEnabled =
      "onVirtualBackgroundSourceEnabled";
  static const String kNERtcOnNetworkConnectionTypeChanged =
      "onNetworkConnectionTypeChanged";
  static const String kNERtcOnLocalAudioVolumeIndication =
      "onLocalAudioVolumeIndication";
  static const String kNERtcOnRemoteAudioVolumeIndication =
      "onRemoteAudioVolumeIndication";
  static const String kNERtcOnAudioHowling = "onAudioHasHowling";
  static const String kNERtcOnLastMileQuality = "OnLastmileQuality";
  static const String kNERtcOnLastMileProbeResult = "OnLastmileProbeResult";
  static const String kNERtcOnAddLiveStreamTask = "onAddLiveStreamTask";
  static const String kNERtcOnUpdateLiveStreamTask = "onUpdateLiveStreamTask";
  static const String kNERtcOnRemoveLiveStreamTask = "onRemoveLiveStreamTask";
  static const String kNERtcOnLiveStreamStateChanged =
      "onLiveStreamStateChanged";
  static const String kNERtcOnRecvSEIMsg = "onRecvSEIMsg";
  static const String kNERtcOnAudioRecording = "onAudioRecording";
  static const String kNERtcOnMediaRightChange = "onMediaRightChange";
  static const String kNERtcOnMediaRelayStateChanged =
      "onMediaRelayStateChanged";
  static const String kNERtcOnMediaRelayEvent = "onMediaRelayEvent";
  static const String kNERtcOnLocalPublishFallbackToAudioOnly =
      "onLocalPublishFallbackToAudioOnly";
  static const String kNERtcOnRemoteSubscribeFallbackAudioOnly =
      "onRemoteSubscribeFallbackToAudioOnly";
  static const String kNERtcOnAudioMixingStateChanged =
      "onAudioMixingStateChanged";
  static const String kNERtcOnAudioMixingTimestampUpdate =
      "onAudioMixingTimestampUpdate";
  static const String kNERtcOnAudioEffectFinished = "onAudioEffectFinished";
  static const String kNERtcOnAudioEffectTimestampUpdate =
      "onAudioEffectTimestampUpdate";
  static const String kNERtcOnTakeSnapshotResult = "onTakeSnapshot";
  static const String kNERtcOnLocalVideoWatermarkState =
      "onLocalVideoWatermarkState";
  static const String kNERtcOnUserSubVideoStreamStart =
      "onUserSubVideoStreamStart";
  static const String kNERtcOnUserSubVideoStreamStop =
      "onUserSubVideoStreamStop";
  static const String kNERtcOnAsrCaptionStateChanged =
      "onAsrCaptionStateChanged";
  static const String kNERtcOnAsrCaptionResult = "onAsrCaptionResult";
  static const String kNERtcOnPlayStreamingStateChange =
      "onPlayStreamingStateChange";
  static const String kNERtcOnPlayStreamingReceiveSeiMessage =
      "onPlayStreamingReceiveSeiMessage";
  static const String kNERtcOnPlayStreamingFirstAudioFramePlayed =
      "onPlayStreamingFirstAudioFramePlayed";
  static const String kNERtcOnPlayStreamingFirstVideoFrameRender =
      "onPlayStreamingFirstVideoFrameRender";
  static const String kNERtcOnLocalAudioFirstPacketSent =
      "onLocalAudioFirstPacketSent";
  static const String kNERtcOnFirstVideoFrameRender = "onFirstVideoFrameRender";
  static const String kNERtcOnLocalVideoRenderSizeChanged =
      "onLocalVideoRenderSizeChanged";
  static const String kNERtcOnUserVideoProfileUpdate =
      "onUserVideoProfileUpdate";
  static const String kNERtcOnAudioDeviceChanged = "onAudioDeviceChanged";
  static const String kNERtcOnAudioDeviceStateChange =
      "onAudioDeviceStateChange";
  static const String kNERtcOnRemoteVideoSizeChanged =
      "onRemoteVideoSizeChanged";
  static const String kNERtcOnUserDataStart = "onUserDataStart";
  static const String kNERtcOnUserDataStop = "onUserDataStop";
  static const String kNERtcOnUserDataReceiveMessage =
      "onUserDataReceiveMessage";
  static const String kNERtcOnUserDataStateChanged = "onUserDataStateChanged";
  static const String kNERtcOnUserDataBufferedAmountChanged =
      "onUserDataBufferedAmountChanged";
  static const String kNERtcOnLabFeatureCallback = "onLabFeatureCallback";
  static const String kNERtcOnAiData = "onAiData";
  static const String kNERtcOnStartPushStreaming = "onStartPushStreaming";
  static const String kNERtcOnStopPushStreaming = "onStopPushStreaming";
  static const String kNERtcOnPushStreamingReconnecting =
      "onPushStreamingReconnecting";
  static const String kNERtcOnPushStreamingReconnectedSuccess =
      "onPushStreamingReconnectedSuccess";
  static const String kNERtcOnScreenCaptureStatus = "onScreenCaptureStatus";
  static const String kNERtcOnScreenCaptureSourceDataUpdate =
      "onScreenCaptureSourceDataUpdate";
  static const String kNERtcOnLocalRecorderStatus = "onLocalRecorderStatus";
  static const String kNERtcOnLocalRecorderError = "onLocalRecorderError";
  static const String kNERtcOnCheckNECastAudioDriverResult =
      "onCheckNECastAudioDriverResult";
}

class FlutterRenderDelegate {
  static const String kNERtcFlutterRenderOnFirstFrameRender =
      "onFirstFrameRendered";
  static const String kNERtcFlutterRenderOnFrameResolutionChanged =
      "onFrameResolutionChanged";
}

class MediaStatsDelegate {
  static const String kNERtcOnStats = "onRtcStats";
  static const String kNERtcOnLocalAudioStats = "onLocalAudioStats";
  static const String kNERtcOnRemoteAudioStats = "onRemoteAudioStats";
  static const String kNERtcOnLocalVideoStats = "onLocalVideoStats";
  static const String kNERtcOnRemoteVideoStats = "onRemoteVideoStats";
  static const String kNERtcOnNetworkQuality = "onNetworkQuality";
}
