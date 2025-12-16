// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

#include <vector>
#include <inttypes.h>
#include <iostream>
#include <fcntl.h>

#ifdef _WIN32
#include <windows.h>
#include <conio.h>
#include <io.h>
#endif

#include "video_view_controller.h"

static NERtcDesktopWrapper* g_engine_wrapper = nullptr;

#ifdef _WIN32
// Windows控制台初始化函数
void InitializeConsole() {
  static bool consoleInitialized = false;
  if (!consoleInitialized) {
    // 分配控制台
    if (AllocConsole()) {
      // 重定向stdout, stdin, stderr到控制台
      freopen_s((FILE**)stdout, "CONOUT$", "w", stdout);
      freopen_s((FILE**)stderr, "CONOUT$", "w", stderr);
      freopen_s((FILE**)stdin, "CONIN$", "r", stdin);

      // 设置控制台标题
      SetConsoleTitle(L"NERTC Core Debug Console");

      // 使iostream与stdio同步
      std::ios::sync_with_stdio(true);
      std::wcout.clear();
      std::cout.clear();
      std::wcerr.clear();
      std::cerr.clear();
      std::wcin.clear();
      std::cin.clear();

      consoleInitialized = true;
      std::cout << "=== NERTC Core Debug Console Initialized ===" << std::endl;
    }
  }
}

// 日志辅助函数
void LogInfo(const std::string& message) {
  std::cout << "[INFO] " << message << std::endl;
  printf("[INFO] %s\n", message.c_str());
}

void LogError(const std::string& message) {
  std::cout << "[ERROR] " << message << std::endl;
  printf("[ERROR] %s\n", message.c_str());
}

void LogDebug(const std::string& message) {
  std::cout << "[DEBUG] " << message << std::endl;
  printf("[DEBUG] %s\n", message.c_str());
}
#endif

NERtcDesktopWrapper* NERtcDesktopWrapper::ShareInstance() {
  if (g_engine_wrapper == nullptr) {
    g_engine_wrapper = new NERtcDesktopWrapper();
  }
  return g_engine_wrapper;
}

void NERtcDesktopWrapper::DestroyInstance() {
  delete std::exchange(g_engine_wrapper, nullptr);
}

void NERtcDesktopWrapper::RegisterDartCallback(DartCallback callback) {
  dart_callback_ = callback;
}

void NERtcDesktopWrapper::RegisterDartSendPort(Dart_Port send_port) {
  send_port_ = send_port;
}

NERtcDesktopWrapper::NERtcDesktopWrapper() {
#ifdef _WIN32
  InitializeConsole();
#endif
  if (rtc_engine_ == nullptr)
    rtc_engine_ = reinterpret_cast<IRtcEngineEx*>(createNERtcEngine());
}

NERtcDesktopWrapper::~NERtcDesktopWrapper() {
  ClearChannelWrapper();
  if (rtc_engine_) delete std::exchange(rtc_engine_, nullptr);
}

int64_t NERtcDesktopWrapper::HandleMethodCall(const json& no_err_body) {
  static const std::map<std::string, MethodHandler> methodHandlers = {

      {kNERtcEngineInitial, &NERtcDesktopWrapper::HandleEngineInitial},
      {kNERtcSetParameters, &NERtcDesktopWrapper::HandleSetParameters},
      {kNERtcJoinChannel, &NERtcDesktopWrapper::HandleJoinChannel},
      {kNERtcEnableLocalAudio, &NERtcDesktopWrapper::HandleEnableLocalAudio},
      {kNERtcEnableLocalVideo, &NERtcDesktopWrapper::HandleEnableLocalVideo},
      {kNERtcMuteLocalAudio, &NERtcDesktopWrapper::HandleMuteLocalAudio},
      {kNERtcMuteLocalVideo, &NERtcDesktopWrapper::HandleMuteLocalVideo},
      {kNERtcLeaveChannel, &NERtcDesktopWrapper::HandleLeaveChannel},
      {kNERtcRelease, &NERtcDesktopWrapper::HandleRelease},
      {kNERtcEngineSetupLocalVideoRender,
       &NERtcDesktopWrapper::HandleSetupLocalVideoRender},
      {kNERtcEngineSetupRemoteVideoRender,
       &NERtcDesktopWrapper::HandleSetupRemoteVideoRender},
      {kNERtcEngineSetupPlayingVideoRender,
       &NERtcDesktopWrapper::HandleSetupPlayingVideoRender},
      {kNERtcEngineCreateFlutterVideoRender,
       &NERtcDesktopWrapper::HandleCreateFlutterVideoRender},
      {kNERtcEngineDisposeFlutterVideoRender,
       &NERtcDesktopWrapper::HandleDisposeFlutterVideoRender},
      {kNERtcSetAudioProfile, &NERtcDesktopWrapper::HandleSetAudioProfile},
      {kNERtcSetChannelProfile, &NERtcDesktopWrapper::HandleSetChannelProfile},
      {kNERtcSubRemoteAudioStream,
       &NERtcDesktopWrapper::HandleSubRemoteAudioStream},
      {kNERtcSubRemoteSubAudioStream,
       &NERtcDesktopWrapper::HandleSubRemoteSubAudioStream},
      {kNERtcSubAllRemoteAudioStream,
       &NERtcDesktopWrapper::HandleSubAllRemoteAudioStream},
      {kNERtcSubRemoteVideoStream,
       &NERtcDesktopWrapper::HandleSubRemoteVideoStream},
      {kNERtcSubRemoteSubVideoStream,
       &NERtcDesktopWrapper::HandleSubRemoteSubVideoStream},
      {kNERtcEngineSetRenderMirror,
       &NERtcDesktopWrapper::HandleSetFlutterVideoMirror},
      {kNERtcEngineSetRenderScalingMode,
       &NERtcDesktopWrapper::HandleSetFlutterVideoScalingMode},
      {kNERtcEnableDualStreamMode,
       &NERtcDesktopWrapper::HandleEnableDualStreamMode},
      {kNERtcEngineGetConnectionState,
       &NERtcDesktopWrapper::HandleGetConnectionState},
      {kNERtcEngineUploadSdkInfo, &NERtcDesktopWrapper::HandleUploadSdkInfo},
      {kNERtcSetMediaStatsObserver,
       &NERtcDesktopWrapper::HandleSetMediaStatsObserver},
      {kNERtcSetCameraCaptureConfig,
       &NERtcDesktopWrapper::HandleSetCameraCaptureConfig},
      {kNERtcSetAudioSubscribeOnlyBy,
       &NERtcDesktopWrapper::HandleSetAudioSubscribeOnlyBy},
      {kNERtcStartAudioDump, &NERtcDesktopWrapper::HandleStartAudioDump},
      {kNERtcStopAudioDump, &NERtcDesktopWrapper::HandleStopAudioDump},
      {kNERtcSetLocalVideoConfig,
       &NERtcDesktopWrapper::HandleSetLocalVideoConfig},
      {kNERtcStartPreview, &NERtcDesktopWrapper::HandleStartPreview},
      {kNERtcStopPreview, &NERtcDesktopWrapper::HandleStopPreview},
      {kNERtcEnableVirtualBackground,
       &NERtcDesktopWrapper::HandleEnableVirtualBackground},
      {kNERtcEnableAudioVolumeIndication,
       &NERtcDesktopWrapper::HandleEnableAudioVolumeIndication},
      {kNERtcAdjustRecordingSignalVolume,
       &NERtcDesktopWrapper::HandleAdjustRecordingSignalVolume},
      {kNERtcAdjustPlaybackSignalVolume,
       &NERtcDesktopWrapper::HandleAdjustPlaybackSignalVolume},
      {kNERtcAdjustLoopbackSignalVolume,
       &NERtcDesktopWrapper::HandleAdjustLoopbackRecordingSignalVolume},
      {kNERtcSetClientRole, &NERtcDesktopWrapper::HandleSetClientRole},
      {kNERtcSendSEIMsg, &NERtcDesktopWrapper::HandleSendSEIMsg},
      {kNERtcEngineSwitchChannel, &NERtcDesktopWrapper::HandleSwitchChannel},
      {kNERtcEngineStartAudioRecording,
       &NERtcDesktopWrapper::HandleStartAudioRecording},
      {kNERtcEngineStartAudioRecordingEx,
       &NERtcDesktopWrapper::HandleStartAudioRecordingEx},
      {kNERtcEngineSetLocalMediaPriority,
       &NERtcDesktopWrapper::HandleSetLocalMediaPriority},
      {kNERtcEngineEnableMediaPub, &NERtcDesktopWrapper::HandleEnableMediaPub},
      {kNERtcEngineSetRemoteHighPriorityAudioStream,
       &NERtcDesktopWrapper::HandleSetRemoteHighPriorityAudioStream},
      {kNERtcEngineSetStreamAlignmentProperty,
       &NERtcDesktopWrapper::HandleSetStreamAlignmentProperty},
      {kNERtcEngineGetNtpTimeOffset,
       &NERtcDesktopWrapper::HandleGetNtpTimeOffset},
      {kNERtcEngineSetLocalPublishFallbackOption,
       &NERtcDesktopWrapper::HandleSetLocalPublishFallbackOption},
      {kNERtcEngineSetRemoteSubscribeFallbackOption,
       &NERtcDesktopWrapper::HandleSetRemoteSubscribeFallbackOption},
      {kNERtcEngineStartLastMileProbeTest,
       &NERtcDesktopWrapper::HandleStartLastMileProbeTest},
      {kNERtcEngineStopLastMileProbeTest,
       &NERtcDesktopWrapper::HandleStopLastMileProbeTest},
      {kNERtcEngineAddLiveStreamTask,
       &NERtcDesktopWrapper::HandleAddLiveStreamTask},
      {kNERtcEngineRemoveLiveStreamTask,
       &NERtcDesktopWrapper::HandleRemoveLiveStreamTask},
      {kNERtcEngineUpdateLiveStreamTask,
       &NERtcDesktopWrapper::HandleUpdateLiveStreamTask},
      {kNERtcEngineReportCustomEvent,
       &NERtcDesktopWrapper::HandleReportCustomEvent},
      {kNERtcEngineSetExternalVideoSource,
       &NERtcDesktopWrapper::HandleSetExternalVideoSource},
      {kNERtcEngineTakeLocalSnapshot,
       &NERtcDesktopWrapper::HandleTakeLocalSnapshot},
      {kNERtcEngineTakeRemoteSnapshot,
       &NERtcDesktopWrapper::HandleTakeRemoteSnapshot},
      {kNERtcEngineEnableSuperResolution,
       &NERtcDesktopWrapper::HandleEnableSuperResolution},
      {kNERtcEngineEnableEncryption,
       &NERtcDesktopWrapper::HandleEnableEncryption},
      {kNERtcEngineCheckNeCastAudioDriver,
       &NERtcDesktopWrapper::HandleCheckNeCastAudioDriver},
      {kNERtcEngineEnableLoopbackRecording,
       &NERtcDesktopWrapper::HandleEnableLoopbackRecording},
      {kNERtcEngineSetLocalVideoWaterMarkConfigs,
       &NERtcDesktopWrapper::HandleSetLocalVideoWaterMarkConfigs},
      {kNERtcEngineAdjustUserPlaybackSignalVolume,
       &NERtcDesktopWrapper::HandleAdjustUserPlaybackSignalVolume},

      // audio reverb && preset.
      {kNERtcEngineSetLocalVoiceReverbParam,
       &NERtcDesktopWrapper::HandleSetLocalVoiceReverbParam},
      {kNERtcEngineSetAudioEffectPreset,
       &NERtcDesktopWrapper::HandleSetLocalVoiceReverbPreset},
      {kNERtcEngineSetVoiceBeautifierPreset,
       &NERtcDesktopWrapper::HandleSetVoiceBeautifierPreset},
      {kNERtcEngineSetLocalVoicePitch,
       &NERtcDesktopWrapper::HandleSetLocalVoicePitch},
      {kNERtcEngineSetLocalVoiceEqualization,
       &NERtcDesktopWrapper::HandleSetLocalVoiceEqualization},

      // screen capture.
      {kNERtcEngineReleaseCaptureSources,
       &NERtcDesktopWrapper::HandleReleaseScreenCaptureSource},
      {kNERtcEngineGetCaptureCount,
       &NERtcDesktopWrapper::HandleGetScreenCaptureCount},
      {kNERtcEngineStartScreenCaptureByScreenRect,
       &NERtcDesktopWrapper::HandleStartScreenCaptureByScreenRect},
      {kNERtcEngineStartScreenCaptureByDisplayId,
       &NERtcDesktopWrapper::HandleStartScreenCaptureByDisplayId},
      {kNERtcEngineStartScreenCaptureByWindowId,
       &NERtcDesktopWrapper::HandleStartScreenCaptureByWindowId},
      {kNERtcEngineSetScreenCaptureSource,
       &NERtcDesktopWrapper::HandleSetScreenCaptureSource},
      {kNERtcEngineUpdateScreenCaptureRegion,
       &NERtcDesktopWrapper::HandleUpdateScreenCaptureRegion},
      {kNERtcEngineSetScreenCaptureMouseCursor,
       &NERtcDesktopWrapper::HandleSetScreenCaptureMouseCursor},
      {kNERtcEngineStopScreenCapture,
       &NERtcDesktopWrapper::HandleStopScreenCapture},
      {kNERtcEnginePauseScreenCapture,
       &NERtcDesktopWrapper::HandlePauseScreenCapture},
      {kNERtcEngineResumeScreenCapture,
       &NERtcDesktopWrapper::HandleResumeScreenCapture},
      {kNERtcEngineSetExcludeWindowList,
       &NERtcDesktopWrapper::HandleSetExcludeWindowList},
      {kNERtcEngineUpdateScreenCaptureParameters,
       &NERtcDesktopWrapper::HandleUpdateScreenCaptureParameters},

      // media relay.
      {kNERtcEngineStartChannelMediaRelay,
       &NERtcDesktopWrapper::HandleStartChannelMediaRelay},
      {kNERtcEngineUpdateChannelMediaRelay,
       &NERtcDesktopWrapper::HandleUpdateChannelMediaRelay},
      {kNERtcEngineStopChannelMediaRelay,
       &NERtcDesktopWrapper::HandleStopChannelMediaRelay},

      // audio mixing.
      {kNERtcEngineStartAudioMixing,
       &NERtcDesktopWrapper::HandleStartAudioMixing},
      {kNERtcEngineStopAudioMixing,
       &NERtcDesktopWrapper::HandleStopAudioMixing},
      {kNERtcEnginePauseAudioMixing,
       &NERtcDesktopWrapper::HandlePauseAudioMixing},
      {kNERtcEngineResumeAudioMixing,
       &NERtcDesktopWrapper::HandleResumeAudioMixing},
      {kNERtcEngineSetAudioMixingSendVolume,
       &NERtcDesktopWrapper::HandleSetAudioMixingSendVolume},
      {kNERtcEngineGetAudioMixingSendVolume,
       &NERtcDesktopWrapper::HandleGetAudioMixingSendVolume},
      {kNERtcEngineSetAudioMixingPlaybackVolume,
       &NERtcDesktopWrapper::HandleSetAudioMixingPlaybackVolume},
      {kNERtcEngineGetAudioMixingPlaybackVolume,
       &NERtcDesktopWrapper::HandleGetAudioMixingPlaybackVolume},
      {kNERtcEngineGetAudioMixingDuration,
       &NERtcDesktopWrapper::HandleGetAudioMixingDuration},
      {kNERtcEngineGetAudioMixingCurrentPosition,
       &NERtcDesktopWrapper::HandleGetAudioMixingCurrentPosition},
      {kNERtcEngineSetAudioMixingPosition,
       &NERtcDesktopWrapper::HandleSetAudioMixingPosition},
      {kNERtcEngineSetAudioMixingPitch,
       &NERtcDesktopWrapper::HandleSetAudioMixingPitch},
      {kNERtcEngineGetAudioMixingPitch,
       &NERtcDesktopWrapper::HandleGetAudioMixingPitch},

      // audio effect.
      {kNERtcEngineStartAudioEffect,
       &NERtcDesktopWrapper::HandleStartAudioEffect},
      {kNERtcEngineStopAudioEffect,
       &NERtcDesktopWrapper::HandleStopAudioEffect},
      {kNERtcEngineStopAllAudioEffects,
       &NERtcDesktopWrapper::HandleStopAllAudioEffects},
      {kNERtcEnginePauseAudioEffect,
       &NERtcDesktopWrapper::HandlePauseAudioEffect},
      {kNERtcEngineResumeAudioEffect,
       &NERtcDesktopWrapper::HandleResumeAudioEffect},
      {kNERtcEnginePauseAllAudioEffects,
       &NERtcDesktopWrapper::HandlePauseAllAudioEffects},
      {kNERtcEngineResumeAllAudioEffects,
       &NERtcDesktopWrapper::HandleResumeAllAudioEffects},
      {kNERtcEngineSetAudioEffectSendVolume,
       &NERtcDesktopWrapper::HandleSetEffectSendVolume},
      {kNERtcEngineGetAudioEffectSendVolume,
       &NERtcDesktopWrapper::HandleGetEffectSendVolume},
      {kNERtcEngineSetAudioEffectPlaybackVolume,
       &NERtcDesktopWrapper::HandleSetEffectPlaybackVolume},
      {kNERtcEngineGetAudioEffectPlaybackVolume,
       &NERtcDesktopWrapper::HandleGetEffectPlaybackVolume},
      {kNERtcEngineGetAudioEffectDuration,
       &NERtcDesktopWrapper::HandleGetEffectDuration},
      {kNERtcEngineGetAUdioEffectCurrentPosition,
       &NERtcDesktopWrapper::HandleGetEffectCurrentPosition},
      {kNERtcEngineSetAudioEffectPosition,
       &NERtcDesktopWrapper::HandleSetEffectPosition},
      {kNERtcEngineSetAudioEffectPitch,
       &NERtcDesktopWrapper::HandleSetEffectPitch},
      {kNERtcEngineGetAudioEffectPitch,
       &NERtcDesktopWrapper::HandleGetEffectPitch},

      // device controller.
      {kNERtcEnumerateCaptureDevices,
       &NERtcDesktopWrapper::HandleEnumerateCaptureDevices},
      {kNERtcEnumerateAudioDevices,
       &NERtcDesktopWrapper::HandleEnumerateAudioDevices},
      {kNERtcGetDeviceCount, &NERtcDesktopWrapper::HandleGetDeviceCount},
      {kNERtcReleaseDevice, &NERtcDesktopWrapper::HandleReleaseDevice},
      {kNERtcSetDevice, &NERtcDesktopWrapper::HandleSetDevice},
      {kNERtcEnableEarback, &NERtcDesktopWrapper::HandleSetEarback},
      {kNERtcSetEarbackVolume, &NERtcDesktopWrapper::HandleSetEarbackVolume},
      {kNERtcIsPlayoutDeviceMute,
       &NERtcDesktopWrapper::HandleIsPlayoutDeviceMute},
      {kNERtcIsRecordDeviceMute,
       &NERtcDesktopWrapper::HandleIsRecordDeviceMute},
      {kNERtcSetPlayoutDeviceMute,
       &NERtcDesktopWrapper::HandleSetPlayoutDeviceMute},
      {kNERtcSetRecordDeviceMute,
       &NERtcDesktopWrapper::HandleSetRecordDeviceMute},

      // nertc beauty
      {kNERtcEngineStartBeauty, &NERtcDesktopWrapper::HandleStartBeauty},
      {kNERtcEngineStopBeauty, &NERtcDesktopWrapper::HandleStopBeauty},
      {kNERtcEngineEnableBeauty, &NERtcDesktopWrapper::HandleEnableBeauty},
      {kNERtcEngineSetBeautyEffect,
       &NERtcDesktopWrapper::HandleSetBeautyEffect},
      {kNERtcEngineAddBeautyEffectFilter,
       &NERtcDesktopWrapper::HandleAddBeautyFilter},
      {kNERtcEngineRemoveBeautyEffectFilter,
       &NERtcDesktopWrapper::HandleRemoveBeautyFilter},
      {kNERtcEngineSetBeautyFilterLevel,
       &NERtcDesktopWrapper::HandleSetBeautyFilterLevel},

      {kNERtcEngineSetVideoDump, &NERtcDesktopWrapper::HandleSetVideoDump},

      // data channel.
      {kNERtcEngineSetVideoStreamLayerCount,
       &NERtcDesktopWrapper::HandleSetVideoStreamLayerCount},
      {kNERtcEngineEnableLocalData,
       &NERtcDesktopWrapper::HandleEnableLocalData},
      {kNERtcEngineSubscribeRemoteData,
       &NERtcDesktopWrapper::HandleSubscribeRemoteData},
      {kNERtcEngineGetFeatureSupportedType,
       &NERtcDesktopWrapper::HandleGetFeatureSupportedType},
      {kNERtcEngineIsFeatureSupported,
       &NERtcDesktopWrapper::HandleIsFeatureSupported},
      {kNERtcEngineSetSubscribeAudioBlocklist,
       &NERtcDesktopWrapper::HandleSetSubscribeAudioBlocklist},
      {kNERtcEngineSetSubscribeAudioAllowlist,
       &NERtcDesktopWrapper::HandleSetSubscribeAudioAllowlist},
      {kNERtcEngineGetNetworkType, &NERtcDesktopWrapper::HandleGetNetworkType},

      // push streaming.
      {kNERtcEngineStopPushStreaming,
       &NERtcDesktopWrapper::HandleStopPushStreaming},
      {kNERtcEngineStopPlayStreaming,
       &NERtcDesktopWrapper::HandleStopPlayStreaming},
      {kNERtcEnginePausePlayStreaming,
       &NERtcDesktopWrapper::HandlePausePlayStreaming},
      {kNERtcEngineResumePlayStreaming,
       &NERtcDesktopWrapper::HandleResumePlayStreaming},
      {kNERtcEngineMuteVideoForPlayStreaming,
       &NERtcDesktopWrapper::HandleMuteVideoForPlayStreaming},
      {kNERtcEngineMuteAudioForPlayStreaming,
       &NERtcDesktopWrapper::HandleMuteAudioForPlayStreaming},
      {kNERtcEngineStopASRCaption, &NERtcDesktopWrapper::HandleStopASRCaption},
      {kNERtcEngineAiManualInterrupt,
       &NERtcDesktopWrapper::HandleAIManualInterrupt},

      // 3D audio effects.
      {kNERtcEngineAINSMode, &NERtcDesktopWrapper::HandleSetAINSMode},
      {kNERtcEngineSetAudioScenario,
       &NERtcDesktopWrapper::HandleSetAudioScenario},
      {kNERtcEngineSetExternalAudioSource,
       &NERtcDesktopWrapper::HandleSetExternalAudioSource},
      {kNERtcEngineSetExternalSubStreamAudioSource,
       &NERtcDesktopWrapper::HandleSetExternalSubStreamAudioSource},
      {kNERtcEngineSetAudioRecvRange,
       &NERtcDesktopWrapper::HandleSetAudioRecvRange},
      {kNERtcEngineSetRangeAudioMode,
       &NERtcDesktopWrapper::HandleSetRangeAudioMode},
      {kNERtcEngineSetRangeAudioTeamID,
       &NERtcDesktopWrapper::HandleSetRangeAudioTeamID},

      // spatializer
      {kNERtcEngineEnableSpatializerRoomEffects,
       &NERtcDesktopWrapper::HandleEnableSpatializerRoomEffects},
      {kNERtcEngineSetSpatializerRenderMode,
       &NERtcDesktopWrapper::HandleSetSpatializerRenderMode},
      {kNERtcEngineEnableSpatializer,
       &NERtcDesktopWrapper::HandleEnableSpatializer},
      {kNERtcEngineInitSpatializer, &NERtcDesktopWrapper::HandleIitSpatializer},
      {kNERtcEngineUpdateSelfPosition,
       &NERtcDesktopWrapper::HandleUpdateSelfPosition},
      {kNERtcEngineSetSpatializerRoomProperty,
       &NERtcDesktopWrapper::HandleSetSpatializerRoomProperty},

      // local recording
      {kNERtcEngineAddLocalRecorderStreamForTask,
       &NERtcDesktopWrapper::HandleAddLocalRecorderStreamForTask},
      {kNERtcEngineRemoveLocalRecorderStreamForTask,
       &NERtcDesktopWrapper::HandleRemoveLocalRecorderStreamForTask},
      {kNERtcEngineAddLocalRecorderStreamLayoutForTask,
       &NERtcDesktopWrapper::HandleAddLocalRecorderStreamLayoutForTask},
      {kNERtcEngineRemoveLocalRecorderStreamLayoutForTask,
       &NERtcDesktopWrapper::HandleRemoveLocalRecorderStreamLayoutForTask},
      {kNERtcEngineUpdateLocalRecorderStreamLayoutForTask,
       &NERtcDesktopWrapper::HandleUpdateLocalRecorderStreamLayoutForTask},
      {kNERtcEngineReplaceLocalRecorderStreamLayoutForTask,
       &NERtcDesktopWrapper::HandleReplaceLocalRecorderStreamLayoutForTask},
      {kNERtcEngineUpdateLocalRecorderWaterMarksForTask,
       &NERtcDesktopWrapper::HandleUpdateLocalRecorderWaterMarksForTask},
      {kNERtcEngineShowLocalRecorderStreamDefaultCoverForTask,
       &NERtcDesktopWrapper::HandleShowLocalRecorderStreamDefaultCoverForTask},
      {kNERtcEngineStopLocalRecorderRemuxMp4,
       &NERtcDesktopWrapper::HandleStopLocalRecorderRemuxMp4},
      {kNERtcEngineRemuxFlvToMp4, &NERtcDesktopWrapper::HandleRemuxFlvToMp4},
      {kNERtcEngineStopRemuxFlvToMp4,
       &NERtcDesktopWrapper::HandleStopRemuxFlvToMp4},
      {kNERtcEngineStartPushStreaming,
       &NERtcDesktopWrapper::HandleStartPushStreaming},
      {kNERtcEngineStartPlayStreaming,
       &NERtcDesktopWrapper::HandleStartPlayStreaming},
      {kNERtcEngineStartASRCaption,
       &NERtcDesktopWrapper::HandleStartASRCaption},
      {kNERtcEngineSetMultiPathOption,
       &NERtcDesktopWrapper::HandleSetMultiPathOption},
      {kNERtcEngineCreateChannel,
       &NERtcDesktopWrapper::HandleEngineCreateChannel},
  };

  std::string method = no_err_body["method"];
  if (method.empty()) {
    std::cout << "[ERROR] HandleMethodCall: method is empty!" << std::endl;
    printf("[ERROR] HandleMethodCall: method is empty!\n");
    return kNERtcErrFatal;
  }

  auto it = methodHandlers.find(method);
  if (it != methodHandlers.end()) {
    std::cout << "[INFO] Calling method: " << method << std::endl;
    const_cast<json&>(no_err_body).erase("method");
    return it->second(rtc_engine_, no_err_body);
  } else {
    std::cout << "[ERROR] Unknown method: " << method << std::endl;
    printf("[ERROR] Unknown method: %s\n", method.c_str());
    return kNERtcErrInvalidParam;
  }
}

std::string NERtcDesktopWrapper::HandleMethodCallStr(const json& no_err_body) {
  static const std::map<std::string, MethodHandler1> methodHandlers = {
      {kNERtcGetDevice, &NERtcDesktopWrapper::HandleGetDevice},
      {kNERtcGetDeviceInfo, &NERtcDesktopWrapper::HandleGetDeviceInfo},
      {kNERtcQueryDevice, &NERtcDesktopWrapper::HandleQueryDevice},
      // screen capture.
      {kNERtcEngineGetScreenCaptureSources,
       &NERtcDesktopWrapper::HandleGetScreenCaptureSource},
      {kNERtcEngineGetCaptureSourceInfo,
       &NERtcDesktopWrapper::HandleGetScreenCaptureSourceInfo},
      {kNERtcEngineGetParameter, &NERtcDesktopWrapper::HandleGetParameter},
      {kNERtcEngineVersion, &NERtcDesktopWrapper::HandleEngineVersion},
  };

  if (!IsContainsValue(no_err_body, "method") ||
      no_err_body["method"].empty()) {
    std::cout << "[ERROR] HandleMethodCallStr: method is empty!" << std::endl;
    printf("[ERROR] HandleMethodCallStr: method is empty!\n");
    return std::string();
  }

  std::string method = no_err_body["method"];
  auto it = methodHandlers.find(method);
  if (it != methodHandlers.end()) {
    std::cout << "[INFO] Calling method ex: " << method << std::endl;
    const_cast<json&>(no_err_body).erase("method");
    return it->second(rtc_engine_, no_err_body);
  } else {
    std::cout << "[ERROR] Unknown method: " << method << std::endl;
    printf("[ERROR] Unknown method: %s\n", method.c_str());
    return std::string();
  }
}

std::shared_ptr<NERtcChannelWrapper> NERtcDesktopWrapper::GetChannelWrapper(
    const std::string& channelTag) {
  std::lock_guard<std::mutex> lock(channel_map_mutex_);
  auto it = channel_map_.find(channelTag);
  if (it != channel_map_.end()) {
    return it->second;
  }
  return nullptr;
}

void NERtcDesktopWrapper::RemoveChannelWrapper(const std::string& channelTag) {
  std::lock_guard<std::mutex> lock(channel_map_mutex_);
  channel_map_.erase(channelTag);
}

void NERtcDesktopWrapper::ClearChannelWrapper() {
  std::lock_guard<std::mutex> lock(channel_map_mutex_);
  channel_map_.clear();
}

int64_t NERtcDesktopWrapper::HandleEngineInitial(IRtcEngineEx* handle,
                                                 const json& params) {
  NERtcEngineContext context{};
  // Initialize all fields to zero/null
  memset(&context, 0, sizeof(context));
  std::vector<std::string> auto_mem;
  if (!JsonConvertEngineContext(params, context, auto_mem)) {
    return kNERtcErrInvalidParam;
  }
  context.event_handler = NERtcDesktopWrapper::ShareInstance();
  context.video_use_exnternal_render =
      true;  // Enable external rendering by default

  json set_params =
      GeneratorInitialJson(params);  // Generate initial parameters
  printf("[INFO] setParameters: %s\n", set_params.dump().c_str());
  handle->setParameters(set_params.dump().c_str());
  return handle->initialize(context);
}

std::string NERtcDesktopWrapper::HandleEngineVersion(IRtcEngineEx* handle,
                                                     const json& params) {
  int build_id = 0;
  auto version = handle->getVersion(&build_id);
  return version;
}

int64_t NERtcDesktopWrapper::HandleEngineCreateChannel(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "channelName")) {
    return kNERtcErrInvalidParam;
  }

  if (nullptr == g_engine_wrapper) {
    return kNERtcErrFatal;
  }

  std::lock_guard<std::mutex> lock(g_engine_wrapper->channel_map_mutex_);
  std::string channelName = params["channelName"].get<std::string>();
  if (g_engine_wrapper->channel_map_.find(channelName) !=
      g_engine_wrapper->channel_map_.end()) {
    return kNERtcErrInvalidParam;
  }

  IRtcChannel* channel = handle->createChannel(channelName.c_str());
  if (channel == nullptr) {
    return kNERtcErrInvalidParam;
  }

  std::shared_ptr<NERtcChannelWrapper> channel_wrapper =
      std::make_shared<NERtcChannelWrapper>(
          channel, g_engine_wrapper->dart_callback_,
          g_engine_wrapper->send_port_, channelName);
  g_engine_wrapper->channel_map_[channelName] = channel_wrapper;
  return kNERtcNoError;
}

int64_t NERtcDesktopWrapper::HandleSetParameters(IRtcEngineEx* handle,
                                                 const json& params) {
  std::string convert_json = JsonConvertToLiteParameters(params);
  printf("[INFO] after convert value: %s\n", convert_json.c_str());
  return handle->setParameters(convert_json.c_str());
}

int64_t NERtcDesktopWrapper::HandleJoinChannel(IRtcEngineEx* handle,
                                               const json& params) {
  std::string token, channel_name;
  nertc::uid_t uid = 0;
  NERtcJoinChannelOptions channel_options;
  std::vector<std::string> auto_mem;
  if (!JsonConvertJoinChannel(params, token, channel_name, uid, channel_options,
                              auto_mem)) {
    std::cout << "[ERROR] HandleJoinChannel: invalid parameters!" << std::endl;
    printf("[ERROR] HandleJoinChannel: invalid parameters!\n");
    return kNERtcErrInvalidParam;
  }
  std::cout << "[INFO] JoinChannel - token: " << token
            << ", channel: " << channel_name << ", uid: " << uid << std::endl;
  printf("[INFO] JoinChannel: token: %s, channel_name: %s, uid: %" PRIu64 "\n",
         token.c_str(), channel_name.c_str(), (uint64_t)uid);
  handle->enableLocalVideo(true);
  return handle->joinChannel(token.c_str(), channel_name.c_str(), uid,
                             channel_options);
}

int64_t NERtcDesktopWrapper::HandleEnableLocalAudio(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params.value("enable", false);
  bool stream_type = params.value("streamType", 0);
  if (stream_type == 0) {
    return handle->enableLocalAudio(enable);
  } else {
    return handle->enableLocalSubStreamAudio(enable);
  }
}

int64_t NERtcDesktopWrapper::HandleEnableLocalVideo(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params.value("enable", false);
  int stream_type = params.value("streamType", 0);
  return handle->enableLocalVideo(
      static_cast<NERtcVideoStreamType>(stream_type), enable);
}

int64_t NERtcDesktopWrapper::HandleStartPreview(IRtcEngineEx* handle,
                                                const json& params) {
  if (!IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int stream_type = params.value("streamType", 0);
  return handle->startVideoPreview(
      static_cast<NERtcVideoStreamType>(stream_type));
}

int64_t NERtcDesktopWrapper::HandleStopPreview(IRtcEngineEx* handle,
                                               const json& params) {
  if (!IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int stream_type = params.value("streamType", 0);
  return handle->stopVideoPreview(
      static_cast<NERtcVideoStreamType>(stream_type));
}

int64_t NERtcDesktopWrapper::HandleMuteLocalAudio(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "mute") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  bool mute = params.value("mute", false);
  int stream_type = params.value("streamType", 0);
  if (stream_type == 0) {
    return handle->muteLocalAudioStream(mute);
  } else {
    return handle->muteLocalSubStreamAudio(mute);
  }
}

int64_t NERtcDesktopWrapper::HandleMuteLocalVideo(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "mute") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  bool mute = params.value("mute", false);
  int stream_type = params.value("streamType", 0);
  return handle->muteLocalVideoStream(
      static_cast<NERtcVideoStreamType>(stream_type), mute);
}

int64_t NERtcDesktopWrapper::HandleEnableDualStreamMode(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params.value("enable", false);
  return handle->enableDualStreamMode(enable);
}

int64_t NERtcDesktopWrapper::HandleSetLocalVideoConfig(IRtcEngineEx* handle,
                                                       const json& params) {
  int stream_type = 0;
  NERtcVideoConfig config;
  if (!JsonConvertToSetLocalVideoConfig(params, stream_type, config)) {
    return kNERtcErrInvalidParam;
  }
  return handle->setVideoConfig(static_cast<NERtcVideoStreamType>(stream_type),
                                config);
}

int64_t NERtcDesktopWrapper::HandleSetAudioProfile(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!IsContainsValue(params, "profile") ||
      !IsContainsValue(params, "scenario")) {
    return kNERtcErrInvalidParam;
  }
  int audio_profile = params.value("profile", kNERtcAudioProfileDefault);
  int audio_scenario = params.value("scenario", kNERtcAudioScenarioDefault);
  return handle->setAudioProfile(
      static_cast<NERtcAudioProfileType>(audio_profile),
      static_cast<NERtcAudioScenarioType>(audio_scenario));
}

int64_t NERtcDesktopWrapper::HandleSetChannelProfile(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "profile")) {
    return kNERtcErrInvalidParam;
  }
  int channel_profile =
      params.value("profile", kNERtcChannelProfileCommunication);
  return handle->setChannelProfile(
      static_cast<NERtcChannelProfileType>(channel_profile));
}

int64_t NERtcDesktopWrapper::HandleSubRemoteVideoStream(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  nertc::uid_t uid = params.value("uid", 0);
  if (uid == 0) {
    printf("subscribe remote stream, get uid:%lld failed", uid);
    return kNERtcErrInvalidParam;
  }
  int stream_type = params.value("streamType", 0);
  bool subscribe = params.value("subscribe", false);
  return handle->subscribeRemoteVideoStream(
      uid, static_cast<NERtcRemoteVideoStreamType>(stream_type), subscribe);
}

int64_t NERtcDesktopWrapper::HandleSubRemoteSubVideoStream(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  nertc::uid_t uid = params.value("uid", 0);
  if (uid == 0) {
    printf("subscribe remote sub stream, get uid:%lld failed", uid);
    return kNERtcErrInvalidParam;
  }
  bool subscribe = params.value("subscribe", false);
  return handle->subscribeRemoteVideoSubStream(uid, subscribe);
}

int64_t NERtcDesktopWrapper::HandleEnableVirtualBackground(IRtcEngineEx* handle,
                                                           const json& params) {
  bool enable = false;
  bool force = false;
  VirtualBackgroundSource source;
  std::vector<std::string> auto_mem;
  if (!JsonConvertToVirtualBackground(params, enable, force, source,
                                      auto_mem)) {
    std::cout << "[ERROR] HandleEnableVirtualBackground: invalid parameters!"
              << std::endl;
    printf("[ERROR] HandleEnableVirtualBackground: invalid parameters!\n");
    return kNERtcErrInvalidParam;
  }
  return handle->enableVirtualBackground(enable, source, force);
}

int64_t NERtcDesktopWrapper::HandleGetConnectionState(IRtcEngineEx* handle,
                                                      const json& params) {
  return handle->getConnectionState();
}

int64_t NERtcDesktopWrapper::HandleLeaveChannel(IRtcEngineEx* handle,
                                                const json& params) {
  return handle->leaveChannel();
}

int64_t NERtcDesktopWrapper::HandleRelease(IRtcEngineEx* handle,
                                           const json& params) {
  NERtcDesktopWrapper::ShareInstance()->ClearChannelWrapper();
  handle->release();
  return kNERtcNoError;
}

int64_t NERtcDesktopWrapper::HandleCreateFlutterVideoRender(
    IRtcEngineEx* handle, const json& params) {
  auto textureId =
      VideoViewController::GetInstance()->CreateTextureRender(handle);

  if (IsContainsValue(params, "channelTag")) {
    std::string channelTag = params["channelTag"].get<std::string>();
    VideoViewController::GetInstance()->SetChannelTag(textureId, channelTag);
  }

  std::cout << "[INFO] CreateFlutterVideoRender - textureId: " << textureId
            << std::endl;
  printf("[INFO] CreateFlutterVideoRender: textureId: %" PRId64 "\n",
         textureId);
  return textureId;
}

int64_t NERtcDesktopWrapper::HandleSetupLocalVideoRender(IRtcEngineEx* handle,
                                                         const json& params) {
  int64_t textureId = params["textureId"].get<int64_t>();
  int stream_type = params["streamType"].get<int>();
  std::cout << "[INFO] SetupLocalVideoRender - textureId: " << textureId
            << std::endl;
  std::cout << "[DEBUG] SetupLocalVideoRender params: " << params.dump()
            << std::endl;

  printf("[INFO] SetupLocalVideoRender: textureId: %" PRId64 ", params: %s\n",
         textureId, params.dump().c_str());

  VideoViewController::GetInstance()->SetupCanvas(
      textureId, 0, static_cast<nertc::NERtcVideoScalingMode>(0),
      static_cast<nertc::NERtcVideoMirrorMode>(0), 0,
      static_cast<nertc::NERtcVideoStreamType>(stream_type));
  // VideoViewController::GetInstance()->SetupCanvas(
  //     params["textureId"].get<int64_t>(),
  //     params["uid"].get<nertc::uid_t>(),
  //     static_cast<nertc::NERtcVideoScalingMode>(params["scaling_mode"].get<int>()),
  //     static_cast<nertc::NERtcVideoMirrorMode>(params["mirror_mode"].get<int>()),
  //     params["background_color"].get<uint32_t>());
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetupRemoteVideoRender(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "textureId") ||
      !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  int64_t uid = params["uid"].get<int64_t>();
  int stream_type = params["streamType"].get<int>();
  std::cout << "[INFO] SetupRemoteVideoRender - textureId: " << textureId
            << std::endl;
  printf("[INFO] SetupRemoteVideoRender: textureId: %" PRId64 ", params: %s\n",
         textureId, params.dump().c_str());
  VideoViewController::GetInstance()->SetupCanvas(
      textureId, uid, static_cast<nertc::NERtcVideoScalingMode>(0),
      static_cast<nertc::NERtcVideoMirrorMode>(0), 0,
      static_cast<nertc::NERtcVideoStreamType>(stream_type));
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetupPlayingVideoRender(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "textureId") ||
      !IsContainsValue(params, "streamId")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  std::string streamId = params["streamId"].get<std::string>();
  printf("[INFO] HandleSetupPlayingVideoRender: textureId: %" PRId64
         ", streamId: %s\n",
         textureId, streamId.c_str());
  VideoViewController::GetInstance()->SetupPlayStreamingCanvas(
      textureId, streamId.c_str(), static_cast<nertc::NERtcVideoScalingMode>(0),
      static_cast<nertc::NERtcVideoMirrorMode>(0), 0,
      static_cast<nertc::NERtcVideoStreamType>(0));
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetFlutterVideoMirror(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "textureId") ||
      !IsContainsValue(params, "mirror") || !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "local")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  bool mirror = params["mirror"].get<bool>();
  int64_t uid = params["uid"].get<int64_t>();
  bool local = params["local"].get<bool>();
  int stream_type = params["streamType"].get<int>();
  int mirror_mode =
      mirror ? kNERtcVideoMirrorModeEnabled : kNERtcVideoMirrorModeDisabled;
  if (local) {
    return handle->setLocalVideoMirrorMode(
        static_cast<NERtcVideoStreamType>(stream_type),
        static_cast<NERtcVideoMirrorMode>(mirror_mode));
  }
  return kNERtcErrNotSupported;
}

int64_t NERtcDesktopWrapper::HandleSetFlutterVideoScalingMode(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "textureId") ||
      !IsContainsValue(params, "scalingMode") ||
      !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "local")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  int scaling_mode = params["scalingMode"].get<int>();
  int64_t uid = params["uid"].get<int64_t>();
  bool local = params["local"].get<bool>();
  int stream_type = params["streamType"].get<int>();
  if (local) {
    return handle->setLocalRenderMode(
        static_cast<NERtcVideoScalingMode>(scaling_mode),
        static_cast<NERtcVideoStreamType>(stream_type));
  } else {
    return handle->setRemoteRenderMode(
        uid, static_cast<NERtcVideoScalingMode>(scaling_mode),
        static_cast<NERtcVideoStreamType>(stream_type));
  }
}

int64_t NERtcDesktopWrapper::HandleDisposeFlutterVideoRender(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "textureId")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  bool result =
      VideoViewController::GetInstance()->DestroyTextureRender(textureId);
  return result ? 0 : kNERtcErrFatal;
}

int64_t NERtcDesktopWrapper::HandleUploadSdkInfo(IRtcEngineEx* handle,
                                                 const json& params) {
  printf("[INFO] HandleUploadSdkInfo\n");
  handle->uploadSdkInfo();
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetMediaStatsObserver(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "register")) {
    return kNERtcErrInvalidParam;
  }
  bool register_observer = params.value("register", false);
  return handle->setStatsObserver(
      register_observer ? NERtcDesktopWrapper::ShareInstance() : nullptr);
}

int64_t NERtcDesktopWrapper::HandleSubRemoteAudioStream(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  auto uid = params["uid"].get<int64_t>();
  auto subscribe = params["subscribe"].get<bool>();
  printf("[INFO] HandleSubRemoteAudioStream: uid: %" PRId64 ", subscribe: %d\n",
         uid, subscribe);
  return handle->subscribeRemoteAudioStream(uid, subscribe);
}

int64_t NERtcDesktopWrapper::HandleSubRemoteSubAudioStream(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  auto uid = params["uid"].get<int64_t>();
  auto subscribe = params["subscribe"].get<bool>();
  printf("[INFO] HandleSubRemoteSubAudioStream: uid: %" PRId64
         ", subscribe: %d\n",
         uid, subscribe);
  return handle->subscribeRemoteSubStreamAudio(uid, subscribe);
}

int64_t NERtcDesktopWrapper::HandleSubAllRemoteAudioStream(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  auto subscribe = params["subscribe"].get<bool>();
  printf("[INFO] HandleSubAllRemoteAudioStream: subscribe: %d\n", subscribe);
  return handle->subscribeAllRemoteAudioStream(subscribe);
}

int64_t NERtcDesktopWrapper::HandleSetCameraCaptureConfig(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "captureConfig") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  NERtcCameraCaptureConfig config;
  int stream_type = 0;

  if (!JsonConvertToSetCameraCaptureConfig(params, config, stream_type)) {
    return kNERtcErrInvalidParam;
  }
  return handle->setCameraCaptureConfig(
      static_cast<NERtcVideoStreamType>(stream_type), config);
}

int64_t NERtcDesktopWrapper::HandleSetAudioSubscribeOnlyBy(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "uidArray")) {
    return kNERtcErrInvalidParam;
  }
  auto uid_array = params["uidArray"].get<std::vector<int64_t>>();
  std::vector<nertc::uid_t> uid_vec;
  for (auto uid : uid_array) {
    uid_vec.push_back(uid);
  }
  printf("[INFO] HandleSetAudioSubscribeOnlyBy: uid_array: %s\n",
         params.dump().c_str());
  return handle->setAudioSubscribeOnlyBy(uid_vec.data(),
                                         (uint32_t)uid_vec.size());
}

int64_t NERtcDesktopWrapper::HandleStartAudioDump(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "type")) {
    return kNERtcErrInvalidParam;
  }
  int type = params["type"].get<int>();  // defalut: 2
  return handle->startAudioDump(static_cast<NERtcAudioDumpType>(type));
}

int64_t NERtcDesktopWrapper::HandleStopAudioDump(IRtcEngineEx* handle,
                                                 const json& params) {
  return handle->stopAudioDump();
}

int64_t NERtcDesktopWrapper::HandleEnableAudioVolumeIndication(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "interval") || !IsContainsValue(params, "vad")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  int interval = params["interval"].get<int>();
  bool vad = params["vad"].get<bool>();
  printf(
      "[INFO] HandleEnableAudioVolumeIndication: enable: %d, interval: %d, "
      "vad: %d\n",
      enable, interval, vad);
  return handle->enableAudioVolumeIndication(enable, interval, vad);
}

int64_t NERtcDesktopWrapper::HandleAdjustRecordingSignalVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  printf("[INFO] HandleAdjustRecordingSignalVolume: volume: %d\n", volume);
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager) {
    return audio_manager->adjustRecordingSignalVolume(volume);
  }
  return kNERtcErrFatal;
}

int64_t NERtcDesktopWrapper::HandleAdjustPlaybackSignalVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  printf("[INFO] HandleAdjustPlaybackSignalVolume: volume: %d\n", volume);
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager) {
    return audio_manager->adjustPlaybackSignalVolume(volume);
  }
  return kNERtcErrFatal;
}

int64_t NERtcDesktopWrapper::HandleAdjustLoopbackRecordingSignalVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  printf("[INFO] HandleAdjustLoopbackRecordingSignalVolume: volume: %d\n",
         volume);
  return handle->adjustLoopbackRecordingSignalVolume(volume);
}

int64_t NERtcDesktopWrapper::HandleSetClientRole(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!IsContainsValue(params, "role")) {
    return kNERtcErrInvalidParam;
  }
  int role = params["role"].get<int>();
  printf("[INFO] HandleSetClientRole: role: %d\n", role);
  return handle->setClientRole(static_cast<NERtcClientRole>(role));
}

int64_t NERtcDesktopWrapper::HandleSendSEIMsg(IRtcEngineEx* handle,
                                              const json& params) {
  if (!IsContainsValue(params, "seiMsg") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  std::string seiMsg = params["seiMsg"].get<std::string>();
  int streamType = params["streamType"].get<int>();
  printf("[INFO] HandleSendSEIMsg: seiMsg: %s, streamType: %d\n",
         seiMsg.c_str(), streamType);
  return handle->sendSEIMsg(seiMsg.c_str(), (int)seiMsg.length(),
                            static_cast<NERtcVideoStreamType>(streamType));
}

int64_t NERtcDesktopWrapper::HandleSwitchChannel(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!IsContainsValue(params, "channelName")) {
    return kNERtcErrInvalidParam;
  }

  std::string token = "";
  if (IsContainsValue(params, "token")) {
    token = params["token"].get<std::string>();
  }

  std::string channelName = params["channelName"].get<std::string>();
  NERtcJoinChannelOptions channel_options;
  // 初始化 channel_options
  memset(&channel_options, 0, sizeof(channel_options));

  if (IsContainsValue(params, "channelOptions")) {
    json channel_options_json = params.at("channelOptions");
    if (IsContainsValue(channel_options_json, "customInfo")) {
      std::string custom_info =
          channel_options_json.at("customInfo").get<std::string>();
      strncpy(channel_options.custom_info, custom_info.c_str(),
              kNERtcCustomInfoLength);
      channel_options.custom_info[kNERtcCustomInfoLength - 1] =
          '\0';  // Add null terminator
    }
    if (IsContainsValue(channel_options_json, "permissionKey")) {
      channel_options.permission_key = const_cast<char*>(
          channel_options_json.at("permissionKey").get<std::string>().data());
    }
  }
  return handle->switchChannel(token.c_str(), channelName.c_str(),
                               channel_options);
}

int64_t NERtcDesktopWrapper::HandleStartAudioRecording(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "filePath") ||
      !IsContainsValue(params, "sampleRate") ||
      !IsContainsValue(params, "quality")) {
    return kNERtcErrInvalidParam;
  }
  std::string file_path = params["filePath"].get<std::string>();
  int sample_rate = params["sampleRate"].get<int>();
  int quality = params["quality"].get<int>();
  return handle->startAudioRecording(
      file_path.c_str(), sample_rate,
      static_cast<NERtcAudioRecordingQuality>(quality));
}

int64_t NERtcDesktopWrapper::HandleStartAudioRecordingEx(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "config")) {
    return kNERtcErrInvalidParam;
  }
  json config_json = params.at("config");
  if (!IsContainsValue(config_json, "filePath") ||
      !IsContainsValue(config_json, "sampleRate") ||
      !IsContainsValue(config_json, "quality") ||
      !IsContainsValue(config_json, "position") ||
      !IsContainsValue(config_json, "cycleTime")) {
    return kNERtcErrInvalidParam;
  }
  NERtcAudioRecordingConfiguration config;
  std::string file_path = config_json["filePath"].get<std::string>();
  strncpy(config.filePath, file_path.c_str(), kNERtcMaxURILength);
  config.filePath[kNERtcMaxURILength - 1] = '\0';  // Add null terminator
  config.sampleRate = config_json["sampleRate"].get<int>();
  config.quality = static_cast<NERtcAudioRecordingQuality>(
      config_json["quality"].get<int>());
  config.position = static_cast<NERtcAudioRecordingPosition>(
      config_json["position"].get<int>());
  config.cycleTime = static_cast<NERtcAudioRecordingCycleTime>(
      config_json["cycleTime"].get<int>());
  return handle->startAudioRecordingWithConfig(config);
}

int64_t NERtcDesktopWrapper::HandleStopAudioRecording(IRtcEngineEx* handle,
                                                      const json& params) {
  return handle->stopAudioRecording();
}

int64_t NERtcDesktopWrapper::HandleSetLocalMediaPriority(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "priority") ||
      !IsContainsValue(params, "isPreemptive")) {
    return kNERtcErrInvalidParam;
  }
  int priority = params["priority"].get<int>();
  bool is_preemptive = params["isPreemptive"].get<bool>();
  return handle->setLocalMediaPriority(
      static_cast<NERtcMediaPriorityType>(priority), is_preemptive);
}

int64_t NERtcDesktopWrapper::HandleEnableMediaPub(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "mediaType")) {
    return kNERtcErrInvalidParam;
  }
  int media_type = params["mediaType"].get<int>();
  bool enable = params["enable"].get<bool>();
  return handle->enableMediaPub(enable,
                                static_cast<NERtcMediaPubType>(media_type));
}

int64_t NERtcDesktopWrapper::HandleSetRemoteHighPriorityAudioStream(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "uid") || !IsContainsValue(params, "enabled") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int64_t uid = params["uid"].get<int64_t>();
  bool enable = params["enabled"].get<bool>();
  // c++ wrapper not support streamType.
  // int stream_type = params["streamType"].get<int>();
  return handle->setRemoteHighPriorityAudioStream(enable, uid);
}

int64_t NERtcDesktopWrapper::HandleSetCloudProxy(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!IsContainsValue(params, "proxyType")) {
    return kNERtcErrInvalidParam;
  }
  int proxy_type = params["proxyType"].get<int>();
  return handle->setCloudProxy(proxy_type);
}

int64_t NERtcDesktopWrapper::HandleSetStreamAlignmentProperty(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  handle->setStreamAlignmentProperty(enable);
  return 0;
}

int64_t NERtcDesktopWrapper::HandleGetNtpTimeOffset(IRtcEngineEx* handle,
                                                    const json& params) {
  return handle->getNtpTimeOffset();
}

int64_t NERtcDesktopWrapper::HandleTakeLocalSnapshot(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "path") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }

  std::string path = params["path"].get<std::string>();
  int stream_type = params["streamType"].get<int>();

  auto snapshot_callback = NERtcSnapshotCallbackWrapper::Create(path);
  int ret = handle->takeLocalSnapshot(
      static_cast<NERtcVideoStreamType>(stream_type), snapshot_callback);
  if (ret != kNERtcNoError) {
    NERtcSnapshotCallbackWrapper::Delete(snapshot_callback);
  }
  return ret;
}

int64_t NERtcDesktopWrapper::HandleTakeRemoteSnapshot(IRtcEngineEx* handle,
                                                      const json& params) {
  if (!IsContainsValue(params, "uid") || !IsContainsValue(params, "path") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int64_t uid = params["uid"].get<int64_t>();
  std::string path = params["path"].get<std::string>();
  int stream_type = params["streamType"].get<int>();

  auto snapshot_callback = NERtcSnapshotCallbackWrapper::Create(path);
  int ret = handle->takeRemoteSnapshot(
      uid, static_cast<NERtcVideoStreamType>(stream_type), snapshot_callback);
  if (ret != kNERtcNoError) {
    NERtcSnapshotCallbackWrapper::Delete(snapshot_callback);
  }
  return ret;
}

int64_t NERtcDesktopWrapper::HandleStartChannelMediaRelay(IRtcEngineEx* handle,
                                                          const json& params) {
  NERtcChannelMediaRelayConfiguration config;
  if (!JsonConvertToStartChannelMediaRelay(params, config)) {
    return kNERtcErrInvalidParam;
  }
  int ret = handle->startChannelMediaRelay(&config);
  delete[] config.src_infos;
  delete[] config.dest_infos;
  return ret;
}

int64_t NERtcDesktopWrapper::HandleUpdateChannelMediaRelay(IRtcEngineEx* handle,
                                                           const json& params) {
  NERtcChannelMediaRelayConfiguration config;
  if (!JsonConvertToStartChannelMediaRelay(params, config)) {
    return kNERtcErrInvalidParam;
  }
  int ret = handle->updateChannelMediaRelay(&config);
  delete[] config.src_infos;
  delete[] config.dest_infos;
  return ret;
}

int64_t NERtcDesktopWrapper::HandleStopChannelMediaRelay(IRtcEngineEx* handle,
                                                         const json& params) {
  return handle->stopChannelMediaRelay();
}

int64_t NERtcDesktopWrapper::HandleSetLocalPublishFallbackOption(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "option")) {
    return kNERtcErrInvalidParam;
  }
  int option = params["option"].get<int>();
  return handle->setLocalPublishFallbackOption(
      static_cast<NERtcStreamFallbackOption>(option));
}

int64_t NERtcDesktopWrapper::HandleSetRemoteSubscribeFallbackOption(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "option")) {
    return kNERtcErrInvalidParam;
  }
  int option = params["option"].get<int>();
  return handle->setRemoteSubscribeFallbackOption(
      static_cast<NERtcStreamFallbackOption>(option));
}

int64_t NERtcDesktopWrapper::HandleStartLastMileProbeTest(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "config")) {
    return kNERtcErrInvalidParam;
  }
  NERtcLastmileProbeConfig config;
  if (!JsonConvertToStartLastMileProbeTest(params, config)) {
    return kNERtcErrInvalidParam;
  }
  return handle->startLastmileProbeTest(config);
}

int64_t NERtcDesktopWrapper::HandleStopLastMileProbeTest(IRtcEngineEx* handle,
                                                         const json& params) {
  return handle->stopLastmileProbeTest();
}

int64_t NERtcDesktopWrapper::HandleAddLiveStreamTask(IRtcEngineEx* handle,
                                                     const json& params) {
  NERtcLiveStreamTaskInfo task_info;
  if (!JsonConvertToAddLiveStreamTask(params, task_info)) {
    return kNERtcErrInvalidParam;
  }
  return handle->addLiveStreamTask(task_info);
}

int64_t NERtcDesktopWrapper::HandleRemoveLiveStreamTask(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  std::string task_id = params["taskId"].get<std::string>();
  return handle->removeLiveStreamTask(task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleUpdateLiveStreamTask(IRtcEngineEx* handle,
                                                        const json& params) {
  NERtcLiveStreamTaskInfo task_info;
  if (!JsonConvertToAddLiveStreamTask(params, task_info)) {
    return kNERtcErrInvalidParam;
  }
  return handle->updateLiveStreamTask(task_info);
}

int64_t NERtcDesktopWrapper::HandleSetEarback(IRtcEngineEx* handle,
                                              const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }

  bool enable = params["enable"].get<bool>();
  int volume = params["volume"].get<int>();
  return handle->enableEarback(enable, volume);
}

int64_t NERtcDesktopWrapper::HandleSetEarbackVolume(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  return handle->setEarbackVolume(volume);
}

int64_t NERtcDesktopWrapper::HandleIsPlayoutDeviceMute(IRtcEngineEx* handle,
                                                       const json& params) {
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager == nullptr) {
    return kNERtcErrNotSupported;
  }
  bool mute = false;
  audio_manager->getPlayoutDeviceMute(&mute);
  return mute ? 1 : 0;
}

int64_t NERtcDesktopWrapper::HandleIsRecordDeviceMute(IRtcEngineEx* handle,
                                                      const json& params) {
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager == nullptr) {
    return kNERtcErrNotSupported;
  }
  bool mute = false;
  audio_manager->getRecordDeviceMute(&mute);
  return mute ? 1 : 0;
}

int64_t NERtcDesktopWrapper::HandleSetPlayoutDeviceMute(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "mute")) {
    return kNERtcErrInvalidParam;
  }
  bool mute = params["mute"].get<bool>();
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager == nullptr) {
    return kNERtcErrNotSupported;
  }
  return audio_manager->setPlayoutDeviceMute(mute);
}

int64_t NERtcDesktopWrapper::HandleSetRecordDeviceMute(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "mute")) {
    return kNERtcErrInvalidParam;
  }
  bool mute = params["mute"].get<bool>();
  nertc::IAudioDeviceManager* audio_manager = nullptr;
  handle->queryInterface(nertc::kNERtcIIDAudioDeviceManager,
                         (void**)&audio_manager);
  if (audio_manager == nullptr) {
    return kNERtcErrNotSupported;
  }
  return audio_manager->setRecordDeviceMute(mute);
}

int64_t NERtcDesktopWrapper::HandleStartAudioMixing(IRtcEngineEx* handle,
                                                    const json& params) {
  NERtcCreateAudioMixingOption option;
  if (!JsonConvertToStartAudioMixing(params, option)) {
    return kNERtcErrInvalidParam;
  }
  return handle->startAudioMixing(&option);
}

int64_t NERtcDesktopWrapper::HandleStopAudioMixing(IRtcEngineEx* handle,
                                                   const json& params) {
  return handle->stopAudioMixing();
}

int64_t NERtcDesktopWrapper::HandlePauseAudioMixing(IRtcEngineEx* handle,
                                                    const json& params) {
  return handle->pauseAudioMixing();
}

int64_t NERtcDesktopWrapper::HandleResumeAudioMixing(IRtcEngineEx* handle,
                                                     const json& params) {
  return handle->resumeAudioMixing();
}

int64_t NERtcDesktopWrapper::HandleSetAudioMixingSendVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  return handle->setAudioMixingSendVolume(volume);
}

int64_t NERtcDesktopWrapper::HandleGetAudioMixingSendVolume(
    IRtcEngineEx* handle, const json& params) {
  uint32_t volume = 0;
  int ret = handle->getAudioMixingSendVolume(&volume);
  if (ret != kNERtcNoError)
    printf("getAudioMixingSendVolume failed, ret: %d\n", ret);
  return volume;
}

int64_t NERtcDesktopWrapper::HandleSetAudioMixingPlaybackVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  int volume = params["volume"].get<int>();
  return handle->setAudioMixingPlaybackVolume(volume);
}

int64_t NERtcDesktopWrapper::HandleGetAudioMixingPlaybackVolume(
    IRtcEngineEx* handle, const json& params) {
  uint32_t volume = 0;
  int ret = handle->getAudioMixingPlaybackVolume(&volume);
  if (ret != kNERtcNoError)
    printf("getAudioMixingPlaybackVolume failed, ret: %d\n", ret);
  return volume;
}

int64_t NERtcDesktopWrapper::HandleGetAudioMixingDuration(IRtcEngineEx* handle,
                                                          const json& params) {
  uint64_t duration = 0;
  int ret = handle->getAudioMixingDuration(&duration);
  if (ret != kNERtcNoError)
    printf("getAudioMixingDuration failed, ret: %d\n", ret);
  return duration;
}

int64_t NERtcDesktopWrapper::HandleGetAudioMixingCurrentPosition(
    IRtcEngineEx* handle, const json& params) {
  uint64_t position = 0;
  int ret = handle->getAudioMixingCurrentPosition(&position);
  if (ret != kNERtcNoError)
    printf("getAudioMixingCurrentPosition failed, ret: %d\n", ret);
  return position;
}

int64_t NERtcDesktopWrapper::HandleSetAudioMixingPosition(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "position")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t position = params["position"].get<uint64_t>();
  return handle->setAudioMixingPosition(position);
}

int64_t NERtcDesktopWrapper::HandleSetAudioMixingPitch(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "pitch")) {
    return kNERtcErrInvalidParam;
  }
  int32_t pitch = params["pitch"].get<int32_t>();
  return handle->setAudioMixingPitch(pitch);
}

int64_t NERtcDesktopWrapper::HandleGetAudioMixingPitch(IRtcEngineEx* handle,
                                                       const json& params) {
  int32_t pitch = 0;
  int ret = handle->getAudioMixingPitch(&pitch);
  if (ret != kNERtcNoError)
    printf("getAudioMixingPitch failed, ret: %d\n", ret);
  return pitch;
}

int64_t NERtcDesktopWrapper::HandleReportCustomEvent(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "eventName")) {
    return kNERtcErrInvalidParam;
  }
  std::string event_name = params["eventName"].get<std::string>();
  std::string custom_identify, param_str;

  if (IsContainsValue(params, "customIdentify")) {
    custom_identify = params["customIdentify"].get<std::string>();
  }
  if (IsContainsValue(params, "param")) {
    json param = params.at("param");
    param_str = param.dump();
  }
  return handle->reportCustomEvent(event_name.c_str(), custom_identify.c_str(),
                                   param_str.c_str());
}

int64_t NERtcDesktopWrapper::HandleStartAudioEffect(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "effectId") ||
      !IsContainsValue(params, "options")) {
    return kNERtcErrInvalidParam;
  }

  int effect_id = params["effectId"].get<int>();
  NERtcCreateAudioEffectOption option;
  if (!JsonConvertToPlayEffect(params, option)) {
    return kNERtcErrInvalidParam;
  }
  return handle->playEffect(effect_id, &option);
}

int64_t NERtcDesktopWrapper::HandleStopAudioEffect(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  return handle->stopEffect(effect_id);
}

int64_t NERtcDesktopWrapper::HandleStopAllAudioEffects(IRtcEngineEx* handle,
                                                       const json& params) {
  return handle->stopAllEffects();
}

int64_t NERtcDesktopWrapper::HandlePauseAudioEffect(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  return handle->pauseEffect(effect_id);
}

int64_t NERtcDesktopWrapper::HandleResumeAudioEffect(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  return handle->resumeEffect(effect_id);
}

int64_t NERtcDesktopWrapper::HandlePauseAllAudioEffects(IRtcEngineEx* handle,
                                                        const json& params) {
  return handle->pauseAllEffects();
}

int64_t NERtcDesktopWrapper::HandleResumeAllAudioEffects(IRtcEngineEx* handle,
                                                         const json& params) {
  return handle->resumeAllEffects();
}

int64_t NERtcDesktopWrapper::HandleSetEffectSendVolume(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "effectId") ||
      !IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  uint32_t volume = params["volume"].get<uint32_t>();
  return handle->setEffectSendVolume(effect_id, volume);
}

int64_t NERtcDesktopWrapper::HandleGetEffectSendVolume(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  uint32_t volume = 0;
  int ret = handle->getEffectSendVolume(effect_id, &volume);
  if (ret != kNERtcNoError)
    printf("getEffectSendVolume failed, ret: %d\n", ret);
  return volume;
}

int64_t NERtcDesktopWrapper::HandleSetEffectPlaybackVolume(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "effectId") ||
      !IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  uint32_t volume = params["volume"].get<uint32_t>();
  return handle->setEffectPlaybackVolume(effect_id, volume);
}

int64_t NERtcDesktopWrapper::HandleGetEffectPlaybackVolume(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  uint32_t volume = 0;
  int ret = handle->getEffectPlaybackVolume(effect_id, &volume);
  if (ret != kNERtcNoError)
    printf("getEffectPlaybackVolume failed, ret: %d\n", ret);
  return volume;
}

int64_t NERtcDesktopWrapper::HandleGetEffectDuration(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t effect_id = params["effectId"].get<uint64_t>();
  uint64_t duration = 0;
  int ret = handle->getEffectDuration(effect_id, &duration);
  if (ret != kNERtcNoError) printf("getEffectDuration failed, ret: %d\n", ret);
  return (int64_t)duration;
}

int64_t NERtcDesktopWrapper::HandleGetEffectCurrentPosition(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t effect_id = params["effectId"].get<uint64_t>();
  uint64_t position = 0;
  int ret = handle->getEffectCurrentPosition(effect_id, &position);
  if (ret != kNERtcNoError) {
    printf("getEffectCurrentPosition failed, ret: %d\n", ret);
    return -1;
  }
  return (int64_t)position;
}

int64_t NERtcDesktopWrapper::HandleSetEffectPosition(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "effectId") ||
      !IsContainsValue(params, "position")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  uint64_t position = params["position"].get<uint64_t>();
  return handle->setEffectPosition(effect_id, position);
}

int64_t NERtcDesktopWrapper::HandleSetEffectPitch(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "effectId") ||
      !IsContainsValue(params, "pitch")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  int32_t pitch = params["pitch"].get<int32_t>();
  return handle->setEffectPitch(effect_id, pitch);
}

int64_t NERtcDesktopWrapper::HandleGetEffectPitch(IRtcEngineEx* handle,
                                                  const json& params) {
  if (!IsContainsValue(params, "effectId")) {
    return kNERtcErrInvalidParam;
  }
  uint32_t effect_id = params["effectId"].get<uint32_t>();
  int32_t pitch = 0;
  int ret = handle->getEffectPitch(effect_id, &pitch);
  if (ret != kNERtcNoError) {
    printf("getEffectPitch failed, ret: %d\n", ret);
    return -1;
  }
  return pitch;
}

int64_t NERtcDesktopWrapper::HandleSetExternalVideoSource(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  int stream_type = 0;
  if (IsContainsValue(params, "streamType")) {
    stream_type = params["streamType"].get<int>();
  }
  return handle->setExternalVideoSource(
      static_cast<NERtcVideoStreamType>(stream_type), enable);
}

int64_t NERtcDesktopWrapper::HandlePushVideoFrame(const json& parse_result,
                                                  const uint8_t* data,
                                                  const double* matrix) {
  if (!IsContainsValue(parse_result, "method")) {
    return kNERtcErrInvalidParam;
  }

  if (parse_result["method"].get<std::string>() == "pushExternalVideoFrame") {
    if (!IsContainsValue(parse_result, "width") ||
        !IsContainsValue(parse_result, "height") ||
        !IsContainsValue(parse_result, "format") ||
        !IsContainsValue(parse_result, "rotation") ||
        !IsContainsValue(parse_result, "timeStamp") ||
        !IsContainsValue(parse_result, "streamType")) {
      return kNERtcErrInvalidParam;
    }

    int width = parse_result["width"].get<int>();
    int height = parse_result["height"].get<int>();
    int format = parse_result["format"].get<int>();
    int rotation = parse_result["rotation"].get<int>();
    int64_t timestamp = parse_result["timeStamp"].get<int64_t>();
    int stream_type = parse_result["streamType"].get<int>();

    NERtcVideoFrame frame;
    frame.format = static_cast<NERtcVideoType>(format);
    frame.timestamp = timestamp;
    frame.width = width;
    frame.height = height;
    frame.rotation = static_cast<NERtcVideoRotation>(rotation);
    frame.buffer = (void*)data;
    return rtc_engine_->pushExternalVideoFrame(
        static_cast<NERtcVideoStreamType>(stream_type), &frame);
  } else if (parse_result["method"].get<std::string>() ==
             "pushLocalRecorderVideoFrame") {
    if (!IsContainsValue(parse_result, "width") ||
        !IsContainsValue(parse_result, "height") ||
        !IsContainsValue(parse_result, "format") ||
        !IsContainsValue(parse_result, "rotation") ||
        !IsContainsValue(parse_result, "timeStamp") ||
        !IsContainsValue(parse_result, "uid") ||
        !IsContainsValue(parse_result, "streamType") ||
        !IsContainsValue(parse_result, "streamLayer") ||
        !IsContainsValue(parse_result, "taskId")) {
      return kNERtcErrInvalidParam;
    }

    int width = parse_result["width"].get<int>();
    int height = parse_result["height"].get<int>();
    int format = parse_result["format"].get<int>();
    int rotation = parse_result["rotation"].get<int>();
    int64_t timestamp = parse_result["timeStamp"].get<int64_t>();
    int uid = parse_result["uid"].get<int>();
    int stream_type = parse_result["streamType"].get<int>();
    int stream_layer = parse_result["streamLayer"].get<int>();
    std::string task_id = parse_result["taskId"].get<std::string>();

    NERtcVideoFrame frame;
    frame.format = static_cast<NERtcVideoType>(format);
    frame.timestamp = timestamp;
    frame.width = width;
    frame.height = height;
    frame.rotation = static_cast<NERtcVideoRotation>(rotation);
    frame.buffer = (void*)data;
    return rtc_engine_->pushLocalRecorderVideoFrameForTask(
        static_cast<nertc::uid_t>(uid),
        static_cast<NERtcVideoStreamType>(stream_type), stream_layer,
        task_id.c_str(), &frame);
  }
  return kNERtcErrInvalidParam;
}

int64_t NERtcDesktopWrapper::HandlePushDataFrame(const char* params,
                                                 const uint8_t* data) {
  json parse_result = json::parse(params, nullptr, false);
  if (parse_result.is_null() || !IsContainsValue(parse_result, "dataSize"))
    return kNERtcErrInvalidParam;
  return rtc_engine_->sendData((void*)data,
                               parse_result["dataSize"].get<uint64_t>());
}

int64_t NERtcDesktopWrapper::HandlePushAudioFrame(const char* params,
                                                  const uint8_t* data) {
  json parse_result = json::parse(params, nullptr, false);
  if (parse_result.is_null() || !IsContainsValue(parse_result, "sampleRate") ||
      !IsContainsValue(parse_result, "numberOfChannels") ||
      !IsContainsValue(parse_result, "samplesPerChannel") ||
      !IsContainsValue(parse_result, "syncTimestamp") ||
      !IsContainsValue(parse_result, "streamType")) {
    return kNERtcErrInvalidParam;
  }

  int sample_rate = parse_result["sampleRate"].get<int>();
  int number_of_channels = parse_result["numberOfChannels"].get<int>();
  int samples_per_channel = parse_result["samplesPerChannel"].get<int>();
  int64_t sync_timestamp = parse_result["syncTimestamp"].get<int64_t>();
  int stream_type = parse_result["streamType"].get<int>();

  NERtcAudioFrame frame;
  frame.format.type = kNERtcAudioTypePCM16;
  frame.format.channels = number_of_channels;
  frame.format.sample_rate = sample_rate;
  frame.format.bytes_per_sample = 2;
  frame.format.samples_per_channel = samples_per_channel;
  frame.data = (void*)data;
  frame.sync_timestamp = sync_timestamp;

  if (stream_type == NERtcAudioStreamType::kNERtcAudioStreamTypeMain) {
    return rtc_engine_->pushExternalAudioFrame(&frame);
  } else {
    return rtc_engine_->pushExternalSubStreamAudioFrame(&frame);
  }
}

int64_t NERtcDesktopWrapper::HandleEnableSuperResolution(IRtcEngineEx* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  return handle->enableSuperResolution(enable);
}

int64_t NERtcDesktopWrapper::HandleEnableEncryption(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "config")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  json config_json = params.at("config");
  NERtcEncryptionConfig config;
  int mode = config_json["mode"].get<int>();
  config.mode = static_cast<NERtcEncryptionMode>(mode);
  std::string key = config_json["key"].get<std::string>();
  strncpy(config.key, key.c_str(), kNERtcEncryptByteLength);
  config.key[kNERtcEncryptByteLength - 1] = '\0';
  return handle->enableEncryption(enable, config);
}

int64_t NERtcDesktopWrapper::HandleCheckNeCastAudioDriver(IRtcEngineEx* handle,
                                                          const json& params) {
  return handle->checkNECastAudioDriver();
}

int64_t NERtcDesktopWrapper::HandleEnableLoopbackRecording(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
#ifdef _WIN32
  return handle->enableLoopbackRecording(enable, nullptr);
#else
  std::string device_name = params["deviceName"].get<std::string>();
  return handle->enableLoopbackRecording(enable, device_name.c_str());
#endif
  return 0;
}

int64_t NERtcDesktopWrapper::HandleStartBeauty(IRtcEngineEx* handle,
                                               const json& params) {
  if (!IsContainsValue(params, "filePath")) {
    return kNERtcErrInvalidParam;
  }
  std::string file_path = params["filePath"].get<std::string>();
  return handle->startBeauty(file_path.c_str());
}

int64_t NERtcDesktopWrapper::HandleStopBeauty(IRtcEngineEx* handle,
                                              const json& params) {
  handle->stopBeauty();
  return 0;
}

int64_t NERtcDesktopWrapper::HandleEnableBeauty(IRtcEngineEx* handle,
                                                const json& params) {
  if (!IsContainsValue(params, "enabled")) {
    return kNERtcErrInvalidParam;
  }
  bool enabled = params["enabled"].get<bool>();
  handle->enableBeauty(enabled);
  return 0;
}

int64_t NERtcDesktopWrapper::HandleSetBeautyEffect(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!IsContainsValue(params, "level") ||
      !IsContainsValue(params, "beautyType")) {
    return kNERtcErrInvalidParam;
  }
  int level = params["level"].get<int>();
  int beauty_type = params["beautyType"].get<int>();
  return handle->setBeautyEffect(
      static_cast<NERtcBeautyEffectType>(beauty_type), level);
}

int64_t NERtcDesktopWrapper::HandleAddBeautyFilter(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!IsContainsValue(params, "path")) {
    return kNERtcErrInvalidParam;
  }
  std::string path = params["path"].get<std::string>();
  return handle->addBeautyFilter(path.c_str());
}

int64_t NERtcDesktopWrapper::HandleRemoveBeautyFilter(IRtcEngineEx* handle,
                                                      const json& params) {
  return handle->removeBeautyFilter();
}

int64_t NERtcDesktopWrapper::HandleSetBeautyFilterLevel(IRtcEngineEx* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "level")) {
    return kNERtcErrInvalidParam;
  }
  float level = params["level"].get<float>();
  return handle->setBeautyFilterLevel(level);
}

int64_t NERtcDesktopWrapper::HandleSetLocalVoiceReverbParam(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "param")) {
    return kNERtcErrInvalidParam;
  }
  json param_json = params.at("param");
  NERtcReverbParam reverb_param;
  reverb_param.wetGain = param_json["wetGain"].get<float>();
  reverb_param.dryGain = param_json["dryGain"].get<float>();
  reverb_param.damping = param_json["damping"].get<float>();
  reverb_param.roomSize = param_json["roomSize"].get<float>();
  reverb_param.decayTime = param_json["decayTime"].get<float>();
  reverb_param.preDelay = param_json["preDelay"].get<float>();
  return handle->setLocalVoiceReverbParam(reverb_param);
}

int64_t NERtcDesktopWrapper::HandleSetLocalVoiceReverbPreset(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "preset")) {
    return kNERtcErrInvalidParam;
  }
  int preset = params["preset"].get<int>();
  return handle->setAudioEffectPreset(
      static_cast<NERtcVoiceChangerType>(preset));
}

int64_t NERtcDesktopWrapper::HandleSetVoiceBeautifierPreset(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "preset")) {
    return kNERtcErrInvalidParam;
  }
  int preset = params["preset"].get<int>();
  return handle->setVoiceBeautifierPreset(
      static_cast<NERtcVoiceBeautifierType>(preset));
}

int64_t NERtcDesktopWrapper::HandleSetLocalVoicePitch(IRtcEngineEx* handle,
                                                      const json& params) {
  if (!IsContainsValue(params, "pitch")) {
    return kNERtcErrInvalidParam;
  }
  double pitch = params["pitch"].get<double>();
  return handle->setLocalVoicePitch(pitch);
}

int64_t NERtcDesktopWrapper::HandleSetLocalVoiceEqualization(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "bandFrequency") ||
      !IsContainsValue(params, "bandGain")) {
    return kNERtcErrInvalidParam;
  }

  int band_frequency = params["bandFrequency"].get<int>();
  int band_gain = params["bandGain"].get<int>();
  return handle->setLocalVoiceEqualization(
      static_cast<NERtcVoiceEqualizationBand>(band_frequency), band_gain);
}

int64_t NERtcDesktopWrapper::HandleSetLocalVideoWaterMarkConfigs(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "type")) {
    return kNERtcErrInvalidParam;
  }

  int type = params["type"].get<int>();
  bool enable = true;
  NERtcVideoWatermarkConfig config;

  if (!IsContainsValue(params, "config")) {
    enable = false;
  } else {
    if (!JsonConvertToLocalVideoWatermarkConfigs(params, config)) {
      return kNERtcErrInvalidParam;
    }
  }

  return handle->setLocalVideoWatermarkConfigs(
      enable, static_cast<NERtcVideoStreamType>(type), config);
}

int64_t NERtcDesktopWrapper::HandleAdjustUserPlaybackSignalVolume(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "uid") || !IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t uid = params["uid"].get<uint64_t>();
  int volume = params["volume"].get<int>();
  return handle->adjustUserPlaybackSignalVolume(uid, volume);
}

int64_t NERtcDesktopWrapper::HandleSetVideoDump(IRtcEngineEx* handle,
                                                const json& params) {
  if (!IsContainsValue(params, "dumpType")) {
    return kNERtcErrInvalidParam;
  }
  int dump_type = params["dumpType"].get<int>();
  return handle->setVideoDump(static_cast<NERtcVideoDumpType>(dump_type));
}

std::string NERtcDesktopWrapper::HandleGetParameter(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "key")) {
    return std::string();
  }
  std::string key = params["key"].get<std::string>();
  std::string extra_info;
  if (IsContainsValue(params, "extraInfo")) {
    extra_info = params["extraInfo"].get<std::string>();
  }
  const char* result = handle->getParameters(key.c_str(), extra_info.c_str());
  return result ? std::string(result) : std::string();
}

int64_t NERtcDesktopWrapper::HandleSetVideoStreamLayerCount(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "layerCount")) {
    return kNERtcErrInvalidParam;
  }
  int layer_count = params["layerCount"].get<int>();
  return handle->setVideoStreamLayerCount(
      static_cast<NERtcVideoStreamLayerCount>(layer_count));
}

int64_t NERtcDesktopWrapper::HandleEnableLocalData(IRtcEngineEx* handle,
                                                   const json& params) {
  if (!IsContainsValue(params, "enabled")) {
    return kNERtcErrInvalidParam;
  }
  bool enabled = params["enabled"].get<bool>();
  return handle->enableLocalData(enabled);
}

int64_t NERtcDesktopWrapper::HandleSubscribeRemoteData(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t uid = params["uid"].get<uint64_t>();
  bool subscribe = params["subscribe"].get<bool>();
  return handle->subscribeRemoteData(uid, subscribe);
}

int64_t NERtcDesktopWrapper::HandleGetFeatureSupportedType(IRtcEngineEx* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "featureType")) {
    return kNERtcErrInvalidParam;
  }
  int type = params["featureType"].get<int>();
  NERTCFeatureSupportType support_type =
      handle->getFeatureSupportedType(static_cast<NERtcFeatureType>(type));
  return static_cast<int64_t>(support_type);
}

int64_t NERtcDesktopWrapper::HandleIsFeatureSupported(IRtcEngineEx* handle,
                                                      const json& params) {
  if (!IsContainsValue(params, "type")) {
    return kNERtcErrInvalidParam;
  }
  int type = params["type"].get<int>();
  bool supported = false;
  int ret = handle->isFeatureSupported(static_cast<NERtcFeatureType>(type),
                                       &supported);
  if (ret != kNERtcNoError) {
    return ret;
  }
  return supported ? 1 : 0;
}

int64_t NERtcDesktopWrapper::HandleSetSubscribeAudioBlocklist(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "uidList") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  json uid_array = params["uidList"];
  int stream_type = params["streamType"].get<int>();
  std::vector<nertc::uid_t> uid_list;
  for (auto& uid : uid_array) {
    uid_list.push_back(static_cast<nertc::uid_t>(uid.get<uint64_t>()));
  }
  return handle->setSubscribeAudioBlocklist(
      static_cast<NERtcAudioStreamType>(stream_type), uid_list.data(),
      uid_list.size());
}

int64_t NERtcDesktopWrapper::HandleSetSubscribeAudioAllowlist(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "uidList")) {
    return kNERtcErrInvalidParam;
  }
  json uid_array = params["uidList"];
  std::vector<nertc::uid_t> uid_list;
  for (auto& uid : uid_array) {
    uid_list.push_back(uid.get<uint64_t>());
  }
  return handle->setSubscribeAudioAllowlist(uid_list.data(), uid_list.size());
}

int ConvertNetworkType(NERtcNetworkConnectionType type) {
  switch (type) {
    case kNERtcNetworkConnectionTypeNone:
      return 10;
    case kNERtcNetworkConnectionTypeUnknown:
      return 0;
    case kNERtcNetworkConnectionType2G:
      return 5;
    case kNERtcNetworkConnectionType3G:
      return 4;
    case kNERtcNetworkConnectionType4G:
      return 3;
    case kNERtcNetworkConnectionType5G:
      return 9;
    case kNERtcNetworkConnectionTypeWiFi:
      return 2;
    case kNERtcNetworkConnectionTypeWWAN:
      return 6;
    case kNERtcNetworkConnectionTypeEthernet:
      return 1;
    default:
      return 0;
  }
}

int64_t NERtcDesktopWrapper::HandleGetNetworkType(IRtcEngineEx* handle,
                                                  const json& params) {
  NERtcNetworkConnectionType type = handle->getNetworkType();
  return static_cast<int64_t>(ConvertNetworkType(type));
}

int64_t NERtcDesktopWrapper::HandleStopPushStreaming(IRtcEngineEx* handle,
                                                     const json& params) {
  return handle->stopPushStreaming();
}

int64_t NERtcDesktopWrapper::HandleStopPlayStreaming(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "streamId")) {
    return kNERtcErrInvalidParam;
  }
  std::string stream_id = params["streamId"].get<std::string>();
  return handle->stopPlayStreaming(stream_id.c_str());
}

int64_t NERtcDesktopWrapper::HandlePausePlayStreaming(IRtcEngineEx* handle,
                                                      const json& params) {
  if (!IsContainsValue(params, "streamId")) {
    return kNERtcErrInvalidParam;
  }
  std::string stream_id = params["streamId"].get<std::string>();
  return handle->pausePlayStreaming(stream_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleResumePlayStreaming(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "streamId")) {
    return kNERtcErrInvalidParam;
  }
  std::string stream_id = params["streamId"].get<std::string>();
  return handle->resumePlayStreaming(stream_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleMuteVideoForPlayStreaming(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "streamId") ||
      !IsContainsValue(params, "mute")) {
    return kNERtcErrInvalidParam;
  }
  std::string stream_id = params["streamId"].get<std::string>();
  bool mute = params["mute"].get<bool>();
  return handle->muteVideoForPlayStreaming(stream_id.c_str(), mute);
}

int64_t NERtcDesktopWrapper::HandleMuteAudioForPlayStreaming(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "streamId") ||
      !IsContainsValue(params, "mute")) {
    return kNERtcErrInvalidParam;
  }
  std::string stream_id = params["streamId"].get<std::string>();
  bool mute = params["mute"].get<bool>();
  return handle->muteAudioForPlayStreaming(stream_id.c_str(), mute);
}

int64_t NERtcDesktopWrapper::HandleStopASRCaption(IRtcEngineEx* handle,
                                                  const json& params) {
  return handle->stopASRCaption();
}

int64_t NERtcDesktopWrapper::HandleAIManualInterrupt(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "dstUid")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t dst_uid = params["dstUid"].get<uint64_t>();
  return handle->aiManualInterrupt(dst_uid);
}

int64_t NERtcDesktopWrapper::HandleSetAINSMode(IRtcEngineEx* handle,
                                               const json& params) {
  if (!IsContainsValue(params, "mode")) {
    return kNERtcErrInvalidParam;
  }
  int mode = params["mode"].get<int>();
  return handle->setAINSMode(static_cast<NERtcAudioAINSMode>(mode));
}

int64_t NERtcDesktopWrapper::HandleSetAudioScenario(IRtcEngineEx* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "scenario")) {
    return kNERtcErrInvalidParam;
  }
  int scenario = params["scenario"].get<int>();
  return handle->setAudioScenario(
      static_cast<NERtcAudioScenarioType>(scenario));
}

int64_t NERtcDesktopWrapper::HandleSetExternalAudioSource(IRtcEngineEx* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "sampleRate") ||
      !IsContainsValue(params, "channels")) {
    return kNERtcErrInvalidParam;
  }
  bool enabled = params["enable"].get<bool>();
  int sample_rate = params["sampleRate"].get<int>();
  int channels = params["channels"].get<int>();
  return handle->setExternalAudioSource(enabled, sample_rate, channels);
}

int64_t NERtcDesktopWrapper::HandleSetExternalSubStreamAudioSource(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "enabled") ||
      !IsContainsValue(params, "sampleRate") ||
      !IsContainsValue(params, "channels")) {
    return kNERtcErrInvalidParam;
  }
  bool enabled = params["enabled"].get<bool>();
  int sample_rate = params["sampleRate"].get<int>();
  int channels = params["channels"].get<int>();
  return handle->setExternalSubStreamAudioSource(enabled, sample_rate,
                                                 channels);
}

int64_t NERtcDesktopWrapper::HandleSetAudioRecvRange(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "audioRecvRange") ||
      !IsContainsValue(params, "conversationalDistance") ||
      !IsContainsValue(params, "rollOffModel")) {
    return kNERtcErrInvalidParam;
  }
  int audible_distance = params["audioRecvRange"].get<int>();
  int conversational_distance = params["conversationalDistance"].get<int>();
  int roll_off_mode = params["rollOffModel"].get<int>();
  return handle->setAudioRecvRange(
      audible_distance, conversational_distance,
      static_cast<NERtcDistanceRolloffModel>(roll_off_mode));
}

int64_t NERtcDesktopWrapper::HandleSetRangeAudioMode(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "audioMode")) {
    return kNERtcErrInvalidParam;
  }
  int audio_mode = params["audioMode"].get<int>();
  return handle->setRangeAudioMode(
      static_cast<NERtcRangeAudioMode>(audio_mode));
}

int64_t NERtcDesktopWrapper::HandleSetRangeAudioTeamID(IRtcEngineEx* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "teamID")) {
    return kNERtcErrInvalidParam;
  }
  int32_t team_id = params["teamID"].get<int32_t>();
  return handle->setRangeAudioTeamID(team_id);
}

int64_t NERtcDesktopWrapper::HandleEnableSpatializerRoomEffects(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  return handle->enableSpatializerRoomEffects(enable);
}

int64_t NERtcDesktopWrapper::HandleSetSpatializerRenderMode(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "renderMode")) {
    return kNERtcErrInvalidParam;
  }
  int render_mode = params["renderMode"].get<int>();
  return handle->setSpatializerRenderMode(
      static_cast<NERtcSpatializerRenderMode>(render_mode));
}

int64_t NERtcDesktopWrapper::HandleEnableSpatializer(IRtcEngineEx* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "applyToTeam")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  bool apply_to_team = params["applyToTeam"].get<bool>();
  return handle->enableSpatializer(enable, apply_to_team);
}

int64_t NERtcDesktopWrapper::HandleIitSpatializer(IRtcEngineEx* handle,
                                                  const json& params) {
  return handle->initSpatializer();
}

int64_t NERtcDesktopWrapper::HandleUpdateSelfPosition(IRtcEngineEx* handle,
                                                      const json& params) {
  if (!IsContainsValue(params, "positionInfo")) {
    return kNERtcErrInvalidParam;
  }
  json position_info = params["positionInfo"];
  NERtcPositionInfo info;
  memset(&info, 0, sizeof(info));

  if (IsContainsValue(position_info, "mSpeakerPosition")) {
    json pos_array = position_info["mSpeakerPosition"];
    if (pos_array.is_array() && pos_array.size() >= 3) {
      info.speaker_position[0] = pos_array[0].get<float>();
      info.speaker_position[1] = pos_array[1].get<float>();
      info.speaker_position[2] = pos_array[2].get<float>();
    }
  }

  if (IsContainsValue(position_info, "mSpeakerQuaternion")) {
    json quat_array = position_info["mSpeakerQuaternion"];
    if (quat_array.is_array() && quat_array.size() >= 4) {
      info.speaker_quaternion[0] = quat_array[0].get<float>();
      info.speaker_quaternion[1] = quat_array[1].get<float>();
      info.speaker_quaternion[2] = quat_array[2].get<float>();
      info.speaker_quaternion[3] = quat_array[3].get<float>();
    }
  }

  if (IsContainsValue(position_info, "mHeadPosition")) {
    json pos_array = position_info["mHeadPosition"];
    if (pos_array.is_array() && pos_array.size() >= 3) {
      info.head_position[0] = pos_array[0].get<float>();
      info.head_position[1] = pos_array[1].get<float>();
      info.head_position[2] = pos_array[2].get<float>();
    }
  }

  if (IsContainsValue(position_info, "mHeadQuaternion")) {
    json quat_array = position_info["mHeadQuaternion"];
    if (quat_array.is_array() && quat_array.size() >= 4) {
      info.head_quaternion[0] = quat_array[0].get<float>();
      info.head_quaternion[1] = quat_array[1].get<float>();
      info.head_quaternion[2] = quat_array[2].get<float>();
      info.head_quaternion[3] = quat_array[3].get<float>();
    }
  }

  return handle->updateSelfPosition(info);
}

int64_t NERtcDesktopWrapper::HandleSetSpatializerRoomProperty(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "property")) {
    return kNERtcErrInvalidParam;
  }
  json property = params["property"];
  NERtcSpatializerRoomProperty room_property;
  memset(&room_property, 0, sizeof(room_property));

  if (IsContainsValue(property, "roomCapacity")) {
    room_property.room_capacity = static_cast<NERtcSpatializerRoomCapacity>(
        property["roomCapacity"].get<int>());
  }
  if (IsContainsValue(property, "material")) {
    room_property.material = static_cast<NERtcSpatializerMaterialName>(
        property["material"].get<int>());
  }
  if (IsContainsValue(property, "reflectionScalar")) {
    room_property.reflection_scalar = property["reflectionScalar"].get<float>();
  }
  if (IsContainsValue(property, "reverbGain")) {
    room_property.reverb_gain = property["reverbGain"].get<float>();
  }
  if (IsContainsValue(property, "reverbTime")) {
    room_property.reverb_time = property["reverbTime"].get<float>();
  }
  if (IsContainsValue(property, "reverbBrightness")) {
    room_property.reverb_brightness = property["reverbBrightness"].get<float>();
  }

  return handle->setSpatializerRoomProperty(room_property);
}

int64_t NERtcDesktopWrapper::HandleAddLocalRecorderStreamForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "config") ||
      !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }

  json config_json = params["config"];
  std::string task_id = params["taskId"].get<std::string>();

  NERtcLocalRecordingConfig config;
  memset(&config, 0, sizeof(config));

  if (!JsonConvertToLocalRecordingConfig(config_json, config)) {
    return kNERtcErrInvalidParam;
  }
  auto ret = handle->addLocalRecorderStreamForTask(config, task_id.c_str());
  delete[] config.watermark_list;
  delete[] config.cover_watermark_list;
  return ret;
}

int64_t NERtcDesktopWrapper::HandleRemoveLocalRecorderStreamForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  std::string task_id = params["taskId"].get<std::string>();
  return handle->removeLocalRecorderStreamForTask(task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleAddLocalRecorderStreamLayoutForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "config") || !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "streamLayer") ||
      !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }

  json config_json = params["config"];
  uint64_t uid = params["uid"].get<uint64_t>();
  int stream_type = params["streamType"].get<int>();
  int stream_layer = params["streamLayer"].get<int>();
  std::string task_id = params["taskId"].get<std::string>();

  NERtcLocalRecordingLayoutConfig config;
  memset(&config, 0, sizeof(config));

  if (!JsonConvertToLocalRecordingLayoutConfig(config_json, config)) {
    return kNERtcErrInvalidParam;
  }

  auto ret = handle->addLocalRecorderStreamLayoutForTask(
      config, uid, static_cast<NERtcVideoStreamType>(stream_type), stream_layer,
      task_id.c_str());
  delete[] config.watermark_list;
  return ret;
}

int64_t NERtcDesktopWrapper::HandleRemoveLocalRecorderStreamLayoutForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "streamLayer") ||
      !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t uid = params["uid"].get<uint64_t>();
  int stream_type = params["streamType"].get<int>();
  int stream_layer = params["streamLayer"].get<int>();
  std::string task_id = params["taskId"].get<std::string>();
  return handle->removeLocalRecorderStreamLayoutForTask(
      uid, static_cast<NERtcVideoStreamType>(stream_type), stream_layer,
      task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleUpdateLocalRecorderStreamLayoutForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "infos") || !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  json infos_json = params["infos"];
  std::string task_id = params["taskId"].get<std::string>();

  std::vector<NERtcLocalRecordingStreamInfo> infos;
  for (auto& info_json : infos_json) {
    NERtcLocalRecordingStreamInfo info;
    memset(&info, 0, sizeof(info));
    if (!JsonConvertToLocalRecordingStreamInfo(info_json, info)) {
      return kNERtcErrInvalidParam;
    }
    infos.push_back(info);
  }

  auto ret = handle->updateLocalRecorderStreamLayoutForTask(
      infos.data(), infos.size(), task_id.c_str());
  for (auto& info : infos) {
    delete[] info.layout_config.watermark_list;
  }
  return ret;
}

int64_t NERtcDesktopWrapper::HandleReplaceLocalRecorderStreamLayoutForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "infos") || !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  json infos_json = params["infos"];
  std::string task_id = params["taskId"].get<std::string>();

  std::vector<NERtcLocalRecordingStreamInfo> infos;
  for (auto& info_json : infos_json) {
    NERtcLocalRecordingStreamInfo info;
    memset(&info, 0, sizeof(info));
    if (!JsonConvertToLocalRecordingStreamInfo(info_json, info)) {
      return kNERtcErrInvalidParam;
    }
    infos.push_back(info);
  }

  auto ret = handle->replaceLocalRecorderStreamLayoutForTask(
      infos.data(), infos.size(), task_id.c_str());
  for (auto& info : infos) {
    delete[] info.layout_config.watermark_list;
  }
  return ret;
}

int64_t NERtcDesktopWrapper::HandleUpdateLocalRecorderWaterMarksForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "watermarks") ||
      !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  json watermarks_json = params["watermarks"];
  std::string task_id = params["taskId"].get<std::string>();

  std::vector<NERtcVideoWatermarkConfig> watermarks;
  for (auto& wm_json : watermarks_json) {
    NERtcVideoWatermarkConfig wm;
    memset(&wm, 0, sizeof(wm));
    if (!JsonConvertToLocalVideoWatermarkConfigsForRecording(wm_json, wm)) {
      return kNERtcErrInvalidParam;
    }
    watermarks.push_back(wm);
  }

  return handle->updateLocalRecorderWaterMarksForTask(
      watermarks.data(), (int)watermarks.size(), task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleShowLocalRecorderStreamDefaultCoverForTask(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "showEnabled") ||
      !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType") ||
      !IsContainsValue(params, "streamLayer") ||
      !IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  bool show_enabled = params["showEnabled"].get<bool>();
  uint64_t uid = params["uid"].get<uint64_t>();
  int stream_type = params["streamType"].get<int>();
  int stream_layer = params["streamLayer"].get<int>();
  std::string task_id = params["taskId"].get<std::string>();
  return handle->showLocalRecorderStreamDefaultCoverForTask(
      show_enabled, uid, static_cast<NERtcVideoStreamType>(stream_type),
      stream_layer, task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleStopLocalRecorderRemuxMp4(
    IRtcEngineEx* handle, const json& params) {
  if (!IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  std::string task_id = params["taskId"].get<std::string>();
  return handle->stopLocalRecorderRemuxMp4(task_id.c_str());
}

int64_t NERtcDesktopWrapper::HandleRemuxFlvToMp4(IRtcEngineEx* handle,
                                                 const json& params) {
  if (!IsContainsValue(params, "flvPath") ||
      !IsContainsValue(params, "mp4Path") ||
      !IsContainsValue(params, "saveOri")) {
    return kNERtcErrInvalidParam;
  }
  std::string flv_path = params["flvPath"].get<std::string>();
  std::string mp4_path = params["mp4Path"].get<std::string>();
  bool save_ori = params["saveOri"].get<bool>();
  return handle->remuxFlvToMp4(flv_path.c_str(), mp4_path.c_str(), save_ori);
}

int64_t NERtcDesktopWrapper::HandleStopRemuxFlvToMp4(IRtcEngineEx* handle,
                                                     const json& params) {
  return handle->stopRemuxFlvToMp4();
}

int64_t NERtcDesktopWrapper::HandleStartPushStreaming(IRtcEngineEx* handle,
                                                      const json& params) {
  NERtcPushStreamingConfig config;
  memset(&config, 0, sizeof(NERtcPushStreamingConfig));

  if (IsContainsValue(params, "streamingUrl")) {
    std::string streaming_url = params["streamingUrl"].get<std::string>();
    static std::string streaming_url_storage;
    streaming_url_storage = streaming_url;
    config.streaming_url = streaming_url_storage.c_str();
  }

  if (IsContainsValue(params, "streamingRoomInfo")) {
    json room_info_json = params["streamingRoomInfo"];
    if (IsContainsValue(room_info_json, "uid")) {
      config.streaming_room_info.uid = room_info_json["uid"].get<uint64_t>();
    }
    if (IsContainsValue(room_info_json, "channelName")) {
      std::string channel_name =
          room_info_json["channelName"].get<std::string>();
      static std::string channel_name_storage;
      channel_name_storage = channel_name;
      config.streaming_room_info.channel_name = channel_name_storage.c_str();
    }
    if (IsContainsValue(room_info_json, "token")) {
      std::string token = room_info_json["token"].get<std::string>();
      static std::string token_storage;
      token_storage = token;
      config.streaming_room_info.token = token_storage.c_str();
    }
  }

  return handle->startPushStreaming(config);
}

int64_t NERtcDesktopWrapper::HandleStartPlayStreaming(IRtcEngineEx* handle,
                                                      const json& params) {
  NERtcPlayStreamingConfig config;
  memset(&config, 0, sizeof(NERtcPlayStreamingConfig));

  if (IsContainsValue(params, "streamingUrl")) {
    std::string streaming_url = params["streamingUrl"].get<std::string>();
    static std::string streaming_url_storage;
    streaming_url_storage = streaming_url;
    config.streaming_url = streaming_url_storage.c_str();
  }

  if (IsContainsValue(params, "playOutDelay")) {
    config.playout_delay = params["playOutDelay"].get<uint32_t>();
  }

  if (IsContainsValue(params, "reconnectTimeout")) {
    config.reconnect_timeout = params["reconnectTimeout"].get<uint32_t>();
  }

  if (IsContainsValue(params, "muteAudio")) {
    config.mute_audio_play = params["muteAudio"].get<bool>();
  }

  if (IsContainsValue(params, "muteVideo")) {
    config.mute_video_play = params["muteVideo"].get<bool>();
  }

  if (IsContainsValue(params, "pausePullStream")) {
    config.pause_play_streaming = params["pausePullStream"].get<bool>();
  }

  std::string stream_id = "";
  if (IsContainsValue(params, "streamId")) {
    stream_id = params["streamId"].get<std::string>();
  }

  return handle->startPlayStreaming(stream_id.c_str(), &config);
}

int64_t NERtcDesktopWrapper::HandleStartASRCaption(IRtcEngineEx* handle,
                                                   const json& params) {
  NERtcASRCaptionConfig config;
  memset(&config, 0, sizeof(NERtcASRCaptionConfig));

  if (IsContainsValue(params, "srcLanguage")) {
    std::string src_language = params["srcLanguage"].get<std::string>();
    strncpy(config.src_language, src_language.c_str(),
            kNERtcMaxTokenLength - 1);
    config.src_language[kNERtcMaxTokenLength - 1] = '\0';
  }

  if (IsContainsValue(params, "srcLanguageArr")) {
    json src_language_arr = params["srcLanguageArr"];
    if (src_language_arr.is_array()) {
      config.src_languages_count = 0;
      for (size_t i = 0;
           i < src_language_arr.size() && i < kNERtcCommonMaxCount; i++) {
        std::string lang = src_language_arr[i].get<std::string>();
        strncpy(config.src_languages[i], lang.c_str(),
                kNERtcMaxTaskIDLength - 1);
        config.src_languages[i][kNERtcMaxTaskIDLength - 1] = '\0';
        config.src_languages_count++;
      }
    }
  }

  if (IsContainsValue(params, "dstLanguageArr")) {
    json dst_language_arr = params["dstLanguageArr"];
    if (dst_language_arr.is_array()) {
      config.dst_languages_count = 0;
      for (size_t i = 0;
           i < dst_language_arr.size() && i < kNERtcCommonMaxCount; i++) {
        std::string lang = dst_language_arr[i].get<std::string>();
        strncpy(config.dst_languages[i], lang.c_str(),
                kNERtcMaxTaskIDLength - 1);
        config.dst_languages[i][kNERtcMaxTaskIDLength - 1] = '\0';
        config.dst_languages_count++;
      }
    }
  }

  if (IsContainsValue(params, "needTranslateSameLanguage")) {
    config.need_translate_same_language =
        params["needTranslateSameLanguage"].get<bool>();
  }

  return handle->startASRCaption(config);
}

int64_t NERtcDesktopWrapper::HandleSetMultiPathOption(IRtcEngineEx* handle,
                                                      const json& params) {
  // Note: NERtcMultiPathOption structure definition needs to be checked in SDK
  // headers For now, implementing a basic version based on common patterns This
  // may need adjustment based on actual SDK structure definition

  // Since NERtcMultiPathOption structure was not found in the SDK headers,
  // we'll need to check the actual SDK definition. For now, returning an error
  // indicating the structure needs to be defined.
  // TODO: Add proper NERtcMultiPathOption structure conversion once SDK
  // definition is available

  return kNERtcErrNotSupported;
}
