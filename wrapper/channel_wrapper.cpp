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

using namespace nertc;
using namespace nlohmann;

NERtcScreenCaptureParameters parseCaptureParams(const json& paramsJson);
NERtcVideoDimensions parseDimensions(const json& dimJson);
NERtcRectangle parseRectangle(const json& rectJson);
NERtcThumbImageBuffer parseThumbImageBuffer(const json& thumbJson);
NERtcScreenCaptureSourceInfo parseScreenCaptureSourceInfo(
    const json& sourceJson);
json sourceInfoToJson(const NERtcScreenCaptureSourceInfo& sourceInfo);
void InitializeConsole();

std::map<std::string, RefCountImpl<IScreenCaptureSourceList>>
    NERtcChannelWrapper::screen_capture_source_list_map_;
std::mutex NERtcChannelWrapper::source_list_mutex_;

NERtcChannelWrapper::NERtcChannelWrapper(IRtcChannel* rtc_channel,
                                         DartCallback callback,
                                         Dart_Port send_port,
                                         const std::string& channel_tag)
    : rtc_channel_(rtc_channel),
      dart_callback_(callback),
      send_port_(send_port),
      channel_tag_(channel_tag) {
#ifdef _WIN32
  InitializeConsole();
#endif
  rtc_channel_->setChannelEventHandler(this);
}

NERtcChannelWrapper::~NERtcChannelWrapper() {
  printf("NERtcChannelWrapper::~NERtcChannelWrapper\n");
}

int64_t NERtcChannelWrapper::HandleMethodCall(const json& no_err_body) {
  static const std::map<std::string, ChannelMethodHandler> methodHandlers = {
      {kNERtcSubAllRemoteAudioStream,
       &NERtcChannelWrapper::HandleSubAllRemoteAudioStream},
      {kNERtcSetCameraCaptureConfig,
       &NERtcChannelWrapper::HandleSetCameraCaptureConfig},
      {kNERtcEngineSetVideoStreamLayerCount,
       &NERtcChannelWrapper::HandleSetVideoStreamLayerCount},
      {kNERtcEngineGetFeatureSupportedType,
       &NERtcChannelWrapper::HandleGetFeatureSupportedType},
      {kNERtcEngineEnableLoopbackRecording,
       &NERtcChannelWrapper::HandleEnableLoopbackRecording},
      {kNERtcAdjustLoopbackSignalVolume,
       &NERtcChannelWrapper::HandleAdjustLoopbackRecordingSignalVolume},
      {kNERtcEngineSetExternalVideoSource,
       &NERtcChannelWrapper::HandleSetExternalVideoSource},
      {kNERtcEngineAddLiveStreamTask,
       &NERtcChannelWrapper::HandleAddLiveStreamTask},
      {kNERtcEngineUpdateLiveStreamTask,
       &NERtcChannelWrapper::HandleUpdateLiveStreamTask},
      {kNERtcEngineRemoveLiveStreamTask,
       &NERtcChannelWrapper::HandleRemoveLiveStreamTask},
      {kNERtcSendSEIMsg, &NERtcChannelWrapper::HandleSendSEIMsg},
      {kNERtcEngineSetLocalMediaPriority,
       &NERtcChannelWrapper::HandleSetLocalMediaPriority},
      {kNERtcEngineStartChannelMediaRelay,
       &NERtcChannelWrapper::HandleStartChannelMediaRelay},
      {kNERtcEngineUpdateChannelMediaRelay,
       &NERtcChannelWrapper::HandleUpdateChannelMediaRelay},
      {kNERtcEngineStopChannelMediaRelay,
       &NERtcChannelWrapper::HandleStopChannelMediaRelay},
      {kNERtcEngineAdjustUserPlaybackSignalVolume,
       &NERtcChannelWrapper::HandleAdjustUserPlaybackSignalVolume},
      {kNERtcEngineSetLocalPublishFallbackOption,
       &NERtcChannelWrapper::HandleSetLocalPublishFallbackOption},
      {kNERtcEngineSetRemoteSubscribeFallbackOption,
       &NERtcChannelWrapper::HandleSetRemoteSubscribeFallbackOption},
      {kNERtcEngineEnableEncryption,
       &NERtcChannelWrapper::HandleEnableEncryption},
      {kNERtcEngineSetRemoteHighPriorityAudioStream,
       &NERtcChannelWrapper::HandleSetRemoteHighPriorityAudioStream},
      {kNERtcSetAudioSubscribeOnlyBy,
       &NERtcChannelWrapper::HandleSetAudioSubscribeOnlyBy},
      {kNERtcEnableLocalAudio, &NERtcChannelWrapper::HandleEnableLocalAudio},
      {kNERtcEngineReportCustomEvent,
       &NERtcChannelWrapper::HandleReportCustomEvent},
      {kNERtcEngineSetAudioRecvRange,
       &NERtcChannelWrapper::HandleSetAudioRecvRange},
      {kNERtcEngineUpdateSelfPosition,
       &NERtcChannelWrapper::HandleUpdateSelfPosition},
      {kNERtcEngineEnableSpatializerRoomEffects,
       &NERtcChannelWrapper::HandleEnableSpatializerRoomEffects},
      {kNERtcEngineSetSpatializerRoomProperty,
       &NERtcChannelWrapper::HandleSetSpatializerRoomProperty},
      {kNERtcEngineSetSpatializerRenderMode,
       &NERtcChannelWrapper::HandleSetSpatializerRenderMode},
      {kNERtcEngineEnableSpatializer,
       &NERtcChannelWrapper::HandleEnableSpatializer},
      {kNERtcEngineInitSpatializer, &NERtcChannelWrapper::HandleIitSpatializer},
      {kNERtcEngineSetRangeAudioMode,
       &NERtcChannelWrapper::HandleSetRangeAudioMode},
      {kNERtcEngineSetRangeAudioTeamID,
       &NERtcChannelWrapper::HandleSetRangeAudioTeamID},
      {kNERtcEngineSetSubscribeAudioBlocklist,
       &NERtcChannelWrapper::HandleSetSubscribeAudioBlocklist},
      {kNERtcEngineSetSubscribeAudioAllowlist,
       &NERtcChannelWrapper::HandleSetSubscribeAudioAllowlist},
      {kNERtcEngineEnableMediaPub, &NERtcChannelWrapper::HandleEnableMediaPub},
      {kNERtcEnableAudioVolumeIndication,
       &NERtcChannelWrapper::HandleEnableAudioVolumeIndication},
      {kNERtcEnableLocalVideo, &NERtcChannelWrapper::HandleEnableLocalVideo},
      {kNERtcEngineGetConnectionState,
       &NERtcChannelWrapper::HandleGetConnectionState},
      {kNERtcJoinChannel, &NERtcChannelWrapper::HandleJoinChannel},
      {kNERtcLeaveChannel, &NERtcChannelWrapper::HandleLeaveChannel},
      {kNERtcMuteLocalAudio, &NERtcChannelWrapper::HandleMuteLocalAudio},
      {kNERtcMuteLocalVideo, &NERtcChannelWrapper::HandleMuteLocalVideo},
      {kNERtcRelease, &NERtcChannelWrapper::HandleRelease},
      {kNERtcSetChannelProfile, &NERtcChannelWrapper::HandleSetChannelProfile},
      {kNERtcSetClientRole, &NERtcChannelWrapper::HandleSetClientRole},
      {kNERtcSetLocalVideoConfig,
       &NERtcChannelWrapper::HandleSetLocalVideoConfig},
      {kNERtcSubRemoteAudioStream,
       &NERtcChannelWrapper::HandleSubRemoteAudioStream},
      {kNERtcSubRemoteSubAudioStream,
       &NERtcChannelWrapper::HandleSubRemoteSubAudioStream},
      {kNERtcSubRemoteVideoStream,
       &NERtcChannelWrapper::HandleSubRemoteVideoStream},
      {kNERtcSubRemoteSubVideoStream,
       &NERtcChannelWrapper::HandleSubRemoteSubVideoStream},
      {kNERtcEngineTakeLocalSnapshot,
       &NERtcChannelWrapper::HandleTakeLocalSnapshot},
      {kNERtcEngineTakeRemoteSnapshot,
       &NERtcChannelWrapper::HandleTakeRemoteSnapshot},
      {kNERtcEngineSetupLocalVideoRender,
       &NERtcChannelWrapper::HandleSetupLocalVideoRender},
      {kNERtcEngineSetupRemoteVideoRender,
       &NERtcChannelWrapper::HandleSetupRemoteVideoRender},
      {kNERtcEngineReleaseCaptureSources,
       &NERtcChannelWrapper::HandleReleaseScreenCaptureSource},
      {kNERtcEngineGetCaptureCount,
       &NERtcChannelWrapper::HandleGetScreenCaptureCount},
      {kNERtcEngineStartScreenCaptureByScreenRect,
       &NERtcChannelWrapper::HandleStartScreenCaptureByScreenRect},
      {kNERtcEngineStartScreenCaptureByDisplayId,
       &NERtcChannelWrapper::HandleStartScreenCaptureByDisplayId},
      {kNERtcEngineStartScreenCaptureByWindowId,
       &NERtcChannelWrapper::HandleStartScreenCaptureByWindowId},
      {kNERtcEngineSetScreenCaptureSource,
       &NERtcChannelWrapper::HandleSetScreenCaptureSource},
      {kNERtcEngineUpdateScreenCaptureRegion,
       &NERtcChannelWrapper::HandleUpdateScreenCaptureRegion},
      {kNERtcEngineSetScreenCaptureMouseCursor,
       &NERtcChannelWrapper::HandleSetScreenCaptureMouseCursor},
      {kNERtcEngineStopScreenCapture,
       &NERtcChannelWrapper::HandleStopScreenCapture},
      {kNERtcEnginePauseScreenCapture,
       &NERtcChannelWrapper::HandlePauseScreenCapture},
      {kNERtcEngineResumeScreenCapture,
       &NERtcChannelWrapper::HandleResumeScreenCapture},
      {kNERtcEngineSetExcludeWindowList,
       &NERtcChannelWrapper::HandleSetExcludeWindowList},
      {kNERtcEngineUpdateScreenCaptureParameters,
       &NERtcChannelWrapper::HandleUpdateScreenCaptureParameters},
      {kNERtcSetMediaStatsObserver,
       &NERtcChannelWrapper::HandleSetMediaStatsObserver},
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
    return it->second(rtc_channel_, no_err_body);
  } else {
    std::cout << "[ERROR] Unknown method: " << method << std::endl;
    printf("[ERROR] Unknown method: %s\n", method.c_str());
    return kNERtcErrInvalidParam;
  }
}

std::string NERtcChannelWrapper::HandleMethodCallStr(const json& no_err_body) {
  static const std::map<std::string, ChannelMethodHandler1> methodHandlers = {
      {kNERtcChannelGetChannelName, &NERtcChannelWrapper::HandleGetChannelName},
      {kNERtcEngineGetScreenCaptureSources,
       &NERtcChannelWrapper::HandleGetScreenCaptureSource},
      {kNERtcEngineGetCaptureSourceInfo,
       &NERtcChannelWrapper::HandleGetScreenCaptureSourceInfo},
  };

  if (!IsContainsValue(no_err_body, "method")) {
    std::cout << "[ERROR] HandleMethodCallStr: method is empty!" << std::endl;
    printf("[ERROR] HandleMethodCallStr: method is empty!\n");
    return std::string();
  }

  std::string method = no_err_body["method"];
  auto it = methodHandlers.find(method);
  if (it != methodHandlers.end()) {
    std::cout << "[INFO] Calling method: " << method << std::endl;
    const_cast<json&>(no_err_body).erase("method");
    return it->second(rtc_channel_, no_err_body);
  } else {
    std::cout << "[ERROR] Unknown method: " << method << std::endl;
    printf("[ERROR] Unknown method: %s\n", method.c_str());
    return std::string();
  }
}

int64_t NERtcChannelWrapper::HandleSetupLocalVideoRender(IRtcChannel* handle,
                                                         const json& params) {
  int64_t textureId = params["textureId"].get<int64_t>();
  int stream_type = params["streamType"].get<int>();
  std::cout << "[INFO] SetupSubChannelLocalVideoRender - textureId: "
            << textureId << std::endl;
  std::cout << "[DEBUG] SetupSubChannelLocalVideoRender params: "
            << params.dump() << std::endl;

  printf("[INFO] SetupSubChannelLocalVideoRender: textureId: %" PRId64
         ", params: %s\n",
         textureId, params.dump().c_str());

  VideoViewController::GetInstance()->SetupSubChannelCanvas(
      textureId, 0, static_cast<nertc::NERtcVideoScalingMode>(0),
      static_cast<nertc::NERtcVideoMirrorMode>(0), 0,
      static_cast<nertc::NERtcVideoStreamType>(stream_type));
  return 0;
}

int64_t NERtcChannelWrapper::HandleSetupRemoteVideoRender(IRtcChannel* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "textureId") ||
      !IsContainsValue(params, "uid") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  int64_t textureId = params["textureId"].get<int64_t>();
  int64_t uid = params["uid"].get<int64_t>();
  int stream_type = params["streamType"].get<int>();
  std::cout << "[INFO] SetupSubChannelRemoteVideoRender - textureId: "
            << textureId << std::endl;
  printf("[INFO] SetupSubChannelRemoteVideoRender: textureId: %" PRId64
         ", params: %s\n",
         textureId, params.dump().c_str());
  VideoViewController::GetInstance()->SetupSubChannelCanvas(
      textureId, uid, static_cast<nertc::NERtcVideoScalingMode>(0),
      static_cast<nertc::NERtcVideoMirrorMode>(0), 0,
      static_cast<nertc::NERtcVideoStreamType>(stream_type));
  return 0;
}

int64_t NERtcChannelWrapper::SetupLocalCanvas(
    nertc::NERtcVideoCanvas* canvas, nertc::NERtcVideoStreamType stream_type) {
  if (stream_type == nertc::kNERTCVideoStreamSub) {
    rtc_channel_->setupLocalSubStreamVideoCanvas(canvas);
  } else {
    rtc_channel_->setupLocalVideoCanvas(canvas);
  }
  return kNERtcNoError;
}

int64_t NERtcChannelWrapper::SetupRemoteCanvas(
    nertc::uid_t uid, nertc::NERtcVideoCanvas* canvas,
    nertc::NERtcVideoStreamType stream_type) {
  rtc_channel_->setupRemoteVideoCanvas(uid, canvas);
  return kNERtcNoError;
}

std::string NERtcChannelWrapper::HandleGetChannelName(IRtcChannel* handle,
                                                      const json& params) {
  return handle->getChannelName();
}

int64_t NERtcChannelWrapper::HandlePushVideoFrame(const json& parse_result,
                                                  const uint8_t* data,
                                                  const double* matrix) {
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
  return rtc_channel_->pushExternalVideoFrame(
      static_cast<NERtcVideoStreamType>(stream_type), &frame);
}

int64_t NERtcChannelWrapper::HandleSubAllRemoteAudioStream(IRtcChannel* handle,
                                                           const json& params) {
  if (!IsContainsValue(params, "subscribe")) {
    return kNERtcErrInvalidParam;
  }
  auto subscribe = params["subscribe"].get<bool>();
  printf("[INFO] HandleSubAllRemoteAudioStream: subscribe: %d\n", subscribe);
  return handle->subscribeAllRemoteAudioStream(subscribe);
}

int64_t NERtcChannelWrapper::HandleSetCameraCaptureConfig(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSetVideoStreamLayerCount(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "layerCount")) {
    return kNERtcErrInvalidParam;
  }
  int layer_count = params["layerCount"].get<int>();
  return handle->setVideoStreamLayerCount(
      static_cast<NERtcVideoStreamLayerCount>(layer_count));
}

int64_t NERtcChannelWrapper::HandleGetFeatureSupportedType(IRtcChannel* handle,
                                                           const json& params) {
  return kNERtcErrNotSupported;
}

int64_t NERtcChannelWrapper::HandleEnableLoopbackRecording(IRtcChannel* handle,
                                                           const json& params) {
  return kNERtcErrNotSupported;
}

int64_t NERtcChannelWrapper::HandleAdjustLoopbackRecordingSignalVolume(
    IRtcChannel* handle, const json& params) {
  return kNERtcErrNotSupported;
}

int64_t NERtcChannelWrapper::HandleSetExternalVideoSource(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleAddLiveStreamTask(IRtcChannel* handle,
                                                     const json& params) {
  NERtcLiveStreamTaskInfo task_info;
  if (!JsonConvertToAddLiveStreamTask(params, task_info)) {
    return kNERtcErrInvalidParam;
  }
  return handle->addLiveStreamTask(task_info);
}

int64_t NERtcChannelWrapper::HandleUpdateLiveStreamTask(IRtcChannel* handle,
                                                        const json& params) {
  NERtcLiveStreamTaskInfo task_info;
  if (!JsonConvertToAddLiveStreamTask(params, task_info)) {
    return kNERtcErrInvalidParam;
  }
  return handle->updateLiveStreamTask(task_info);
}

int64_t NERtcChannelWrapper::HandleRemoveLiveStreamTask(IRtcChannel* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "taskId")) {
    return kNERtcErrInvalidParam;
  }
  std::string task_id = params["taskId"].get<std::string>();
  return handle->removeLiveStreamTask(task_id.c_str());
}

int64_t NERtcChannelWrapper::HandleSendSEIMsg(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSetLocalMediaPriority(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleStartChannelMediaRelay(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleUpdateChannelMediaRelay(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleStopChannelMediaRelay(IRtcChannel* handle,
                                                         const json& params) {
  return handle->stopChannelMediaRelay();
}

int64_t NERtcChannelWrapper::HandleAdjustUserPlaybackSignalVolume(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "uid") || !IsContainsValue(params, "volume")) {
    return kNERtcErrInvalidParam;
  }
  uint64_t uid = params["uid"].get<uint64_t>();
  int volume = params["volume"].get<int>();
  return handle->adjustUserPlaybackSignalVolume(uid, volume);
}

int64_t NERtcChannelWrapper::HandleSetLocalPublishFallbackOption(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "option")) {
    return kNERtcErrInvalidParam;
  }
  int option = params["option"].get<int>();
  return handle->setLocalPublishFallbackOption(
      static_cast<NERtcStreamFallbackOption>(option));
}

int64_t NERtcChannelWrapper::HandleSetRemoteSubscribeFallbackOption(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "option")) {
    return kNERtcErrInvalidParam;
  }
  int option = params["option"].get<int>();
  return handle->setRemoteSubscribeFallbackOption(
      static_cast<NERtcStreamFallbackOption>(option));
}

int64_t NERtcChannelWrapper::HandleEnableEncryption(IRtcChannel* handle,
                                                    const json& params) {
  return kNERtcErrNotSupported;
}

int64_t NERtcChannelWrapper::HandleSetRemoteHighPriorityAudioStream(
    IRtcChannel* handle, const json& params) {
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

int64_t NERtcChannelWrapper::HandleSetAudioSubscribeOnlyBy(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleEnableLocalAudio(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleReportCustomEvent(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSetAudioRecvRange(IRtcChannel* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "audibleDistance") ||
      !IsContainsValue(params, "conversationalDistance") ||
      !IsContainsValue(params, "rollOffMode")) {
    return kNERtcErrInvalidParam;
  }
  int audible_distance = params["audibleDistance"].get<int>();
  int conversational_distance = params["conversationalDistance"].get<int>();
  int roll_off_mode = params["rollOffMode"].get<int>();
  return handle->setAudioRecvRange(
      audible_distance, conversational_distance,
      static_cast<NERtcDistanceRolloffModel>(roll_off_mode));
}

int64_t NERtcChannelWrapper::HandleUpdateSelfPosition(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleEnableSpatializerRoomEffects(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "enable")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  return handle->enableSpatializerRoomEffects(enable);
}

int64_t NERtcChannelWrapper::HandleSetSpatializerRoomProperty(
    IRtcChannel* handle, const json& params) {
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

int64_t NERtcChannelWrapper::HandleSetSpatializerRenderMode(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "renderMode")) {
    return kNERtcErrInvalidParam;
  }
  int render_mode = params["renderMode"].get<int>();
  return handle->setSpatializerRenderMode(
      static_cast<NERtcSpatializerRenderMode>(render_mode));
}

int64_t NERtcChannelWrapper::HandleEnableSpatializer(IRtcChannel* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "applyToTeam")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params["enable"].get<bool>();
  bool apply_to_team = params["applyToTeam"].get<bool>();
  return handle->enableSpatializer(enable, apply_to_team);
}

int64_t NERtcChannelWrapper::HandleIitSpatializer(IRtcChannel* handle,
                                                  const json& params) {
  return handle->initSpatializer();
}

int64_t NERtcChannelWrapper::HandleSetRangeAudioMode(IRtcChannel* handle,
                                                     const json& params) {
  if (!IsContainsValue(params, "audioMode")) {
    return kNERtcErrInvalidParam;
  }
  int audio_mode = params["audioMode"].get<int>();
  return handle->setRangeAudioMode(
      static_cast<NERtcRangeAudioMode>(audio_mode));
}

int64_t NERtcChannelWrapper::HandleSetRangeAudioTeamID(IRtcChannel* handle,
                                                       const json& params) {
  if (!IsContainsValue(params, "teamID")) {
    return kNERtcErrInvalidParam;
  }
  int32_t team_id = params["teamID"].get<int32_t>();
  return handle->setRangeAudioTeamID(team_id);
}

int64_t NERtcChannelWrapper::HandleSetSubscribeAudioBlocklist(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "uidArray") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  json uid_array = params["uidArray"];
  int stream_type = params["streamType"].get<int>();
  std::vector<nertc::uid_t> uid_list;
  for (auto& uid : uid_array) {
    uid_list.push_back(static_cast<nertc::uid_t>(uid.get<uint64_t>()));
  }
  return handle->setSubscribeAudioBlocklist(
      static_cast<NERtcAudioStreamType>(stream_type), uid_list.data(),
      uid_list.size());
}

int64_t NERtcChannelWrapper::HandleSetSubscribeAudioAllowlist(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "uidArray")) {
    return kNERtcErrInvalidParam;
  }
  json uid_array = params["uidArray"];
  std::vector<nertc::uid_t> uid_list;
  for (auto& uid : uid_array) {
    uid_list.push_back(uid.get<uint64_t>());
  }
  return handle->setSubscribeAudioAllowlist(uid_list.data(), uid_list.size());
}

int64_t NERtcChannelWrapper::HandleEnableMediaPub(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleEnableAudioVolumeIndication(
    IRtcChannel* handle, const json& params) {
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

int64_t NERtcChannelWrapper::HandleEnableLocalVideo(IRtcChannel* handle,
                                                    const json& params) {
  if (!IsContainsValue(params, "enable") ||
      !IsContainsValue(params, "streamType")) {
    return kNERtcErrInvalidParam;
  }
  bool enable = params.value("enable", false);
  int stream_type = params.value("streamType", 0);
  auto result = handle->enableLocalVideo(
      static_cast<NERtcVideoStreamType>(stream_type), enable);
  return result;
}

int64_t NERtcChannelWrapper::HandleGetConnectionState(IRtcChannel* handle,
                                                      const json& params) {
  return handle->getConnectionState();
}

int64_t NERtcChannelWrapper::HandleJoinChannel(IRtcChannel* handle,
                                               const json& params) {
  if (!IsContainsValue(params, "token")) {
    return kNERtcErrInvalidParam;
  }
  std::string token = params["token"].get<std::string>();
  return handle->joinChannel(token.c_str());
}

int64_t NERtcChannelWrapper::HandleLeaveChannel(IRtcChannel* handle,
                                                const json& params) {
  return handle->leaveChannel();
}

int64_t NERtcChannelWrapper::HandleMuteLocalAudio(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleMuteLocalVideo(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleRelease(IRtcChannel* handle,
                                           const json& params) {
  if (!IsContainsValue(params, "channelTag")) {
    return kNERtcErrInvalidParam;
  }

  handle->setChannelEventHandler(nullptr);
  handle->release();
  std::string channel_tag = params["channelTag"].get<std::string>();
  NERtcDesktopWrapper::ShareInstance()->RemoveChannelWrapper(channel_tag);
  return kNERtcNoError;
}

int64_t NERtcChannelWrapper::HandleSetChannelProfile(IRtcChannel* handle,
                                                     const json& params) {
  return kNERtcErrNotSupported;
}

int64_t NERtcChannelWrapper::HandleSetClientRole(IRtcChannel* handle,
                                                 const json& params) {
  if (!IsContainsValue(params, "role")) {
    return kNERtcErrInvalidParam;
  }
  int role = params["role"].get<int>();
  printf("[INFO] HandleSetClientRole: role: %d\n", role);
  return handle->setClientRole(static_cast<NERtcClientRole>(role));
}

int64_t NERtcChannelWrapper::HandleSetLocalVideoConfig(IRtcChannel* handle,
                                                       const json& params) {
  int stream_type = 0;
  NERtcVideoConfig config;
  if (!JsonConvertToSetLocalVideoConfig(params, stream_type, config)) {
    return kNERtcErrInvalidParam;
  }
  return handle->setVideoConfig(static_cast<NERtcVideoStreamType>(stream_type),
                                config);
}

int64_t NERtcChannelWrapper::HandleSubRemoteAudioStream(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSubRemoteSubAudioStream(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSubRemoteVideoStream(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleSubRemoteSubVideoStream(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleTakeLocalSnapshot(IRtcChannel* handle,
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

int64_t NERtcChannelWrapper::HandleTakeRemoteSnapshot(IRtcChannel* handle,
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

std::string NERtcChannelWrapper::HandleGetScreenCaptureSource(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "thumbSize_width") ||
      !IsContainsValue(params, "thumbSize_height") ||
      !IsContainsValue(params, "iconSize_width") ||
      !IsContainsValue(params, "iconSize_height") ||
      !IsContainsValue(params, "includeScreen")) {
    json result;
    result["code"] = -1;
    result["error"] = "Invalid parameters";
    result["key"] = "";
    return result.dump();
  }

  int thumbSize_width = params["thumbSize_width"].get<int>();
  int thumbSize_height = params["thumbSize_height"].get<int>();
  int iconSize_width = params["iconSize_width"].get<int>();
  int iconSize_height = params["iconSize_height"].get<int>();
  bool includeScreen = params["includeScreen"].get<bool>();

  std::string key = "tw" + std::to_string(thumbSize_width) + "th" +
                    std::to_string(thumbSize_height) + "iw" +
                    std::to_string(iconSize_width) + "ih" +
                    std::to_string(iconSize_height) + "is" +
                    std::to_string(includeScreen);

  // 添加线程安全保护
  std::lock_guard<std::mutex> lock(source_list_mutex_);

  auto it = screen_capture_source_list_map_.find(key);
  if (it != screen_capture_source_list_map_.end()) {
    it->second.AddRef();

    // 返回已存在的源信息 JSON
    json result;
    result["code"] = 0;
    result["error"] = "";
    result["key"] = key;
    return result.dump();
  }

  // 获取屏幕捕获源
  auto screen_ptr = handle->getScreenCaptureSources(
      NERtcSize(thumbSize_width, thumbSize_height),
      NERtcSize(iconSize_width, iconSize_height), includeScreen);

  if (!screen_ptr) {
    // 返回获取失败的 JSON
    json result;
    result["code"] = -1;
    result["error"] = "Failed to get screen capture sources";
    result["key"] = "";
    return result.dump();
  }

  try {
    // 使用引用捕获避免 key 的拷贝，但需要确保生命周期
    auto death_recipient = [key](IScreenCaptureSourceList* ptr) {
      std::lock_guard<std::mutex> lock(source_list_mutex_);
      if (ptr) {
        ptr->release();
      }
      screen_capture_source_list_map_.erase(key);
    };

    // 直接构造 RefCountImpl 并设置
    screen_capture_source_list_map_.emplace(
        key, RefCountImpl<IScreenCaptureSourceList>());
    screen_capture_source_list_map_[key].SetOnRelease(screen_ptr,
                                                      death_recipient);

    // 返回成功的 JSON 结果
    json result;
    result["code"] = 0;
    result["error"] = "";
    result["key"] = key;
    return result.dump();

  } catch (...) {
    // 异常安全：确保释放资源
    if (screen_ptr) {
      screen_ptr->release();
    }
    screen_capture_source_list_map_.erase(key);

    // 返回异常错误的 JSON
    json result;
    result["code"] = -1;
    result["error"] =
        "Exception occurred while processing screen capture sources";
    result["key"] = "";
    return result.dump();
  }
}

int64_t NERtcChannelWrapper::HandleReleaseScreenCaptureSource(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "key")) {
    return kNERtcErrInvalidParam;
  }
  std::string key = params["key"].get<std::string>();
  if (screen_capture_source_list_map_.find(key) ==
      screen_capture_source_list_map_.end()) {
    return kNERtcErrInvalidParam;
  }
  screen_capture_source_list_map_[key].DecRef();
  return kNERtcNoError;
}

int64_t NERtcChannelWrapper::HandleGetScreenCaptureCount(IRtcChannel* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "key")) {
    return kNERtcErrInvalidParam;
  }

  std::string key = params["key"].get<std::string>();
  if (screen_capture_source_list_map_.find(key) ==
      screen_capture_source_list_map_.end()) {
    return kNERtcErrInvalidParam;
  }

  auto it = screen_capture_source_list_map_.find(key);
  if (it != screen_capture_source_list_map_.end()) {
    // 获取实际的源列表指针来计算数量
    auto& refCount = it->second;
    if (refCount.get()) {
      return refCount.get()->getCount();
    }
  }

  return kNERtcErrInvalidParam;
}

// 修改后的 HandleGetScreenCaptureSourceInfo 方法
std::string NERtcChannelWrapper::HandleGetScreenCaptureSourceInfo(
    IRtcChannel* handle, const json& params) {
  // 参数验证
  if (!IsContainsValue(params, "key") || !IsContainsValue(params, "index")) {
    json result;
    result["code"] = -1;
    result["error"] = "Missing required parameters: key or index";
    result["info"] = nullptr;
    return result.dump();
  }

  try {
    std::string key = params["key"].get<std::string>();
    int index = params["index"].get<int>();

    // 检查 key 是否存在
    if (screen_capture_source_list_map_.find(key) ==
        screen_capture_source_list_map_.end()) {
      json result;
      result["code"] = -1;
      result["error"] = "Screen capture source list not found for key: " + key;
      result["info"] = nullptr;
      return result.dump();
    }

    auto it = screen_capture_source_list_map_.find(key);
    if (it != screen_capture_source_list_map_.end()) {
      auto& refCount = it->second;
      if (refCount.get()) {
        // 检查索引是否有效
        unsigned int count = refCount.get()->getCount();
        if (index < 0 || static_cast<unsigned int>(index) >= count) {
          json result;
          result["code"] = -1;
          result["error"] =
              "Index out of range. Index: " + std::to_string(index) +
              ", Count: " + std::to_string(count);
          result["info"] = nullptr;
          return result.dump();
        }

        // 获取指定索引的源信息
        try {
          NERtcScreenCaptureSourceInfo sourceInfo =
              refCount.get()->getSourceInfo(static_cast<unsigned int>(index));

          // 将 sourceInfo 转换为 JSON
          json sourceInfoJson = sourceInfoToJson(sourceInfo);

          // 返回成功结果
          json result;
          result["code"] = 0;
          result["error"] = "";
          result["info"] = sourceInfoJson;
          return result.dump();

        } catch (const std::exception& e) {
          json result;
          result["code"] = -1;
          result["error"] =
              "Failed to get source info: " + std::string(e.what());
          result["info"] = nullptr;
          return result.dump();
        } catch (...) {
          json result;
          result["code"] = -1;
          result["error"] = "Unknown error occurred while getting source info";
          result["info"] = nullptr;
          return result.dump();
        }
      } else {
        json result;
        result["code"] = -1;
        result["error"] = "Screen capture source list is null";
        result["info"] = nullptr;
        return result.dump();
      }
    }

    // 这个分支理论上不会执行到，但保险起见
    json result;
    result["code"] = -1;
    result["error"] =
        "Unexpected error: source list found but iteration failed";
    result["info"] = nullptr;
    return result.dump();

  } catch (const std::exception& e) {
    json result;
    result["code"] = -1;
    result["error"] = "Parameter parsing error: " + std::string(e.what());
    result["info"] = nullptr;
    return result.dump();
  } catch (...) {
    json result;
    result["code"] = -1;
    result["error"] = "Unknown parameter parsing error";
    result["info"] = nullptr;
    return result.dump();
  }
}

int64_t NERtcChannelWrapper::HandleStartScreenCaptureByScreenRect(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "screenRect") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  // 解析 screenRect, regionRect, captureParams 参数
  NERtcRectangle screenRect = parseRectangle(params["screenRect"]);
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByScreenRect(screenRect, regionRect,
                                                captureParams);
}

int64_t NERtcChannelWrapper::HandleStartScreenCaptureByDisplayId(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "displayId") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  int displayId = params["displayId"].get<int>();
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByDisplayId(
      reinterpret_cast<source_id_t>(displayId), regionRect, captureParams);
}

int64_t NERtcChannelWrapper::HandleStartScreenCaptureByWindowId(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "windowId") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  int64_t windowId = params["windowId"].get<int64_t>();
  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);

  return handle->startScreenCaptureByWindowId(
      reinterpret_cast<source_id_t>(windowId), regionRect, captureParams);
}

// // 解析 NERtcThumbImageBuffer
// static NERtcThumbImageBuffer parseThumbImageBuffer(const json& thumbJson) {
//   NERtcThumbImageBuffer thumb = {};

//   if (thumbJson.contains("buffer") && thumbJson["buffer"].is_array()) {
//     auto bufferArray = thumbJson["buffer"].get<std::vector<int>>();
//     if (!bufferArray.empty()) {
//       // 为缓冲区分配内存（注意：这里需要管理内存生命周期）
//       static std::vector<uint8_t> staticBuffer;
//       staticBuffer.clear();
//       staticBuffer.reserve(bufferArray.size());
//       for (int val : bufferArray) {
//         staticBuffer.push_back(static_cast<uint8_t>(val));
//       }
//       thumb.buffer = reinterpret_cast<const char*>(staticBuffer.data());
//     }
//   }

//   if (thumbJson.contains("length")) {
//     thumb.length = thumbJson["length"].get<unsigned int>();
//   }

//   if (thumbJson.contains("width")) {
//     thumb.width = thumbJson["width"].get<unsigned int>();
//   }

//   if (thumbJson.contains("height")) {
//     thumb.height = thumbJson["height"].get<unsigned int>();
//   }

//   return thumb;
// }

// // 解析 NERtcScreenCaptureSourceInfo
// static NERtcScreenCaptureSourceInfo parseScreenCaptureSourceInfo(
//     const json& sourceJson) {
//   NERtcScreenCaptureSourceInfo source = {};

//   // 解析 type
//   if (sourceJson.contains("type")) {
//     int typeValue = sourceJson["type"].get<int>();
//     source.type = static_cast<NERtcScreenCaptureSourceType>(typeValue);
//   }

//   // 解析 sourceId
//   if (sourceJson.contains("sourceId")) {
//     int64_t sourceId = sourceJson["sourceId"].get<int64_t>();
//     source.source_id = reinterpret_cast<source_id_t>(sourceId);
//   }

//   // 解析 sourceName
//   if (sourceJson.contains("sourceName")) {
//     static std::string sourceNameStr =
//         sourceJson["sourceName"].get<std::string>();
//     source.source_name = sourceNameStr.c_str();
//   }

//   // 解析 thumbImage
//   if (sourceJson.contains("thumbImage")) {
//     source.thumb_image = parseThumbImageBuffer(sourceJson["thumbImage"]);
//   }

//   // 解析 iconImage
//   if (sourceJson.contains("iconImage")) {
//     source.icon_image = parseThumbImageBuffer(sourceJson["iconImage"]);
//   }

//   // 解析 processPath
//   if (sourceJson.contains("processPath")) {
//     static std::string processPathStr =
//         sourceJson["processPath"].get<std::string>();
//     source.process_path = processPathStr.c_str();
//   }

//   // 解析 sourceTitle
//   if (sourceJson.contains("sourceTitle")) {
//     static std::string sourceTitleStr =
//         sourceJson["sourceTitle"].get<std::string>();
//     source.source_title = sourceTitleStr.c_str();
//   }

//   // 解析 primaryMonitor
//   if (sourceJson.contains("primaryMonitor")) {
//     source.primaryMonitor = sourceJson["primaryMonitor"].get<bool>();
//   }

//   return source;
// }

int64_t NERtcChannelWrapper::HandleSetScreenCaptureSource(IRtcChannel* handle,
                                                          const json& params) {
  if (!IsContainsValue(params, "source") ||
      !IsContainsValue(params, "regionRect") ||
      !IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  try {
    // 解析 source 参数
    NERtcScreenCaptureSourceInfo source =
        parseScreenCaptureSourceInfo(params["source"]);

    // 解析 regionRect 参数
    NERtcRectangle regionRect = parseRectangle(params["regionRect"]);

    // 解析 captureParams 参数
    NERtcScreenCaptureParameters captureParams =
        parseCaptureParams(params["captureParams"]);

    // 调用 NERTC 引擎接口
    return handle->setScreenCaptureSource(source, regionRect, captureParams);

  } catch (const std::exception& e) {
    // 处理 JSON 解析异常
    return kNERtcErrInvalidParam;
  }
}

int64_t NERtcChannelWrapper::HandleUpdateScreenCaptureRegion(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "regionRect")) {
    return kNERtcErrInvalidParam;
  }

  NERtcRectangle regionRect = parseRectangle(params["regionRect"]);
  return handle->updateScreenCaptureRegion(regionRect);
}

int64_t NERtcChannelWrapper::HandleSetScreenCaptureMouseCursor(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "captureCursor")) {
    return kNERtcErrInvalidParam;
  }

  bool captureCursor = params["captureCursor"].get<bool>();
  return handle->setScreenCaptureMouseCursor(captureCursor);
}

int64_t NERtcChannelWrapper::HandleStopScreenCapture(IRtcChannel* handle,
                                                     const json& params) {
  return handle->stopScreenCapture();
}

int64_t NERtcChannelWrapper::HandlePauseScreenCapture(IRtcChannel* handle,
                                                      const json& params) {
  return handle->pauseScreenCapture();
}

int64_t NERtcChannelWrapper::HandleResumeScreenCapture(IRtcChannel* handle,
                                                       const json& params) {
  return handle->resumeScreenCapture();
}

int64_t NERtcChannelWrapper::HandleSetExcludeWindowList(IRtcChannel* handle,
                                                        const json& params) {
  if (!IsContainsValue(params, "excludeWindowList")) {
    return kNERtcErrInvalidParam;
  }

  auto excludeWindowList =
      params["excludeWindowList"].get<std::vector<int64_t>>();

  // 转换为 NERTC 需要的格式
  static std::vector<source_id_t> windowIds;
  windowIds.clear();
  for (int64_t windowId : excludeWindowList) {
    windowIds.push_back(reinterpret_cast<source_id_t>(windowId));
  }

  return handle->setExcludeWindowList(windowIds.data(),
                                      static_cast<int>(windowIds.size()));
}

int64_t NERtcChannelWrapper::HandleUpdateScreenCaptureParameters(
    IRtcChannel* handle, const json& params) {
  if (!IsContainsValue(params, "captureParams")) {
    return kNERtcErrInvalidParam;
  }

  NERtcScreenCaptureParameters captureParams =
      parseCaptureParams(params["captureParams"]);
  return handle->updateScreenCaptureParameters(captureParams);
}

int64_t NERtcChannelWrapper::HandleSetMediaStatsObserver(IRtcChannel* handle,
                                                         const json& params) {
  if (!IsContainsValue(params, "register")) {
    return kNERtcErrInvalidParam;
  }

  bool register_observer = params.value("register", false);
  std::string channel_tag = params["channelTag"].get<std::string>();

  auto channel =
      NERtcDesktopWrapper::ShareInstance()->GetChannelWrapper(channel_tag);
  return handle->setStatsObserver(register_observer ? channel.get() : nullptr);
}
