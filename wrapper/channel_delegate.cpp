// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "engine_wrapper.h"

void NERtcChannelWrapper::onError(int error_code, const char* msg) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnError;
  dart_json["error_code"] = error_code;
  dart_json["msg"] = msg;
  std::string response = dart_json.dump();
  printf("onError result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onWarning(int warn_code, const char* msg) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnWarning;
  dart_json["warn_code"] = warn_code;
  dart_json["msg"] = msg ? msg : "";
  std::string response = dart_json.dump();
  printf("onWarning result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onApiCallExecuted(const char* api_name,
                                            NERtcErrorCode error,
                                            const char* message) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnApiCallExecuted;
  dart_json["api_name"] = api_name ? api_name : "";
  dart_json["error"] = static_cast<int>(error);
  dart_json["message"] = message ? message : "";
  std::string response = dart_json.dump();
  printf("onApiCallExecuted result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onJoinChannel(channel_id_t cid, nertc::uid_t uid,
                                        NERtcErrorCode result,
                                        uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnJoinChannel;
  dart_json["cid"] = cid;
  dart_json["uid"] = uid;
  dart_json["result"] = static_cast<int>(result);
  dart_json["elapsed"] = elapsed;
  std::string response = dart_json.dump();
  printf("onJoinChannel result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onReconnectingStart(channel_id_t cid,
                                              nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnReconnectingStart;
  dart_json["cid"] = cid;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onReconnectingStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onConnectionStateChange(
    NERtcConnectionStateType state, NERtcReasonConnectionChangedType reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnConnectionStateChange;
  dart_json["state"] = static_cast<int>(state);
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onConnectionStateChange result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRejoinChannel(channel_id_t cid, nertc::uid_t uid,
                                          NERtcErrorCode result,
                                          uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRejoinChannel;
  dart_json["cid"] = cid;
  dart_json["uid"] = uid;
  dart_json["result"] = static_cast<int>(result);
  dart_json["elapsed"] = elapsed;
  std::string response = dart_json.dump();
  printf("onRejoinChannel result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLeaveChannel(NERtcErrorCode result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLeaveChannel;
  dart_json["result"] = static_cast<int>(result);
  std::string response = dart_json.dump();
  printf("onLeaveChannel result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onDisconnect(NERtcErrorCode reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnDisconnect;
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onDisconnect result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onClientRoleChanged(NERtcClientRole oldRole,
                                              NERtcClientRole newRole) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnClientRoleChanged;
  dart_json["oldRole"] = static_cast<int>(oldRole);
  dart_json["newRole"] = static_cast<int>(newRole);
  std::string response = dart_json.dump();
  printf("onClientRoleChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserJoined(nertc::uid_t uid, const char* user_name,
                                       NERtcUserJoinExtraInfo join_extra_info) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserJoined;
  dart_json["uid"] = uid;
  dart_json["user_name"] = user_name ? user_name : "";
  dart_json["join_extra_info"] = join_extra_info.custom_info;
  std::string response = dart_json.dump();
  printf("onUserJoined result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserLeft(nertc::uid_t uid,
                                     NERtcSessionLeaveReason reason,
                                     NERtcUserJoinExtraInfo leave_extra_info) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserLeave;
  dart_json["uid"] = uid;
  dart_json["reason"] = static_cast<int>(reason);
  dart_json["leave_extra_info"] = leave_extra_info.custom_info;
  std::string response = dart_json.dump();
  printf("onUserLeft result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserAudioStart(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserAudioStart;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserAudioStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserAudioStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserAudioStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserAudioStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserAudioMute(nertc::uid_t uid, bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserAudioMute;
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserAudioMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserSubStreamAudioStart(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserSubStreamAudioStart;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserSubStreamAudioStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserSubStreamAudioStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserSubStreamAudioMute(nertc::uid_t uid,
                                                   bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserSubStreamAudioMute;
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserVideoStart(nertc::uid_t uid,
                                           NERtcVideoProfileType max_profile) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserVideoStart;
  dart_json["uid"] = uid;
  dart_json["max_profile"] = static_cast<int>(max_profile);
  std::string response = dart_json.dump();
  printf("onUserVideoStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserVideoStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserVideoStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserVideoStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserVideoMute(NERtcVideoStreamType videoStreamType,
                                          nertc::uid_t uid, bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserVideoMute;
  dart_json["videoStreamType"] = static_cast<int>(videoStreamType);
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserVideoMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserSubStreamVideoStart(
    nertc::uid_t uid, NERtcVideoProfileType max_profile) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserSubVideoStreamStart;
  dart_json["uid"] = uid;
  dart_json["max_profile"] = static_cast<int>(max_profile);
  std::string response = dart_json.dump();
  printf("onUserSubStreamVideoStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUserSubStreamVideoStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUserSubVideoStreamStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamVideoStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onScreenCaptureStatus(
    NERtcScreenCaptureStatus status) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnScreenCaptureStatus;
  dart_json["status"] = static_cast<int>(status);
  std::string response = dart_json.dump();
  printf("onScreenCaptureStatus result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onScreenCaptureSourceDataUpdate(
    NERtcScreenCaptureSourceData data) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnScreenCaptureSourceDataUpdate;
  dart_json["type"] = static_cast<int>(data.type);
  dart_json["status"] = static_cast<int>(data.status);
  dart_json["action"] = static_cast<int>(data.action);
  json capture_rect;
  capture_rect["x"] = data.capture_rect.x;
  capture_rect["y"] = data.capture_rect.y;
  capture_rect["width"] = data.capture_rect.width;
  capture_rect["height"] = data.capture_rect.height;
  dart_json["capture_rect"] = capture_rect;
  dart_json["level"] = data.level;
  std::string response = dart_json.dump();
  printf("onScreenCaptureSourceDataUpdate result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onFirstAudioDataReceived(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnFirstAudioDataReceived;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onFirstAudioDataReceived result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onFirstVideoDataReceived(NERtcVideoStreamType type,
                                                   nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnFirstVideoDataReceived;
  dart_json["stream_type"] = static_cast<int>(type);
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onFirstVideoDataReceived result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRemoteVideoReceiveSizeChanged(
    nertc::uid_t uid, NERtcVideoStreamType type, uint32_t width,
    uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRemoteVideoSizeChanged;
  dart_json["uid"] = uid;
  dart_json["type"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onRemoteVideoReceiveSizeChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLocalVideoRenderSizeChanged(
    NERtcVideoStreamType type, uint32_t width, uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLocalVideoRenderSizeChanged;
  dart_json["videoType"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onLocalVideoRenderSizeChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onFirstAudioFrameDecoded(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnFirstAudioFrameDecoded;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onFirstAudioFrameDecoded result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onFirstVideoFrameDecoded(NERtcVideoStreamType type,
                                                   nertc::uid_t uid,
                                                   uint32_t width,
                                                   uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnFirstVideoFrameDecoded;
  dart_json["streamType"] = static_cast<int>(type);
  dart_json["uid"] = uid;
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onFirstVideoFrameDecoded result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onFirstVideoFrameRender(NERtcVideoStreamType type,
                                                  nertc::uid_t uid,
                                                  uint32_t width,
                                                  uint32_t height,
                                                  uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnFirstVideoFrameRender;
  dart_json["streamType"] = static_cast<int>(type);
  dart_json["uid"] = uid;
  dart_json["width"] = width;
  dart_json["height"] = height;
  dart_json["elapsedTime"] = elapsed;
  std::string response = dart_json.dump();
  printf("onFirstVideoFrameRender result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLocalAudioVolumeIndication(int volume,
                                                       bool enable_vad) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLocalAudioVolumeIndication;
  dart_json["volume"] = volume;
  dart_json["enable_vad"] = enable_vad;
  std::string response = dart_json.dump();
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRemoteAudioVolumeIndication(
    const NERtcAudioVolumeInfo* speakers, unsigned int speaker_number,
    int total_volume) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRemoteAudioVolumeIndication;
  json volume_info;
  for (unsigned int i = 0; i < speaker_number; i++) {
    json volume;
    volume["uid"] = speakers[i].uid;
    volume["volume"] = speakers[i].volume;
    volume["sub_stream_volume"] = speakers[i].sub_stream_volume;
    volume_info.push_back(volume);
  }
  dart_json["volume_info"] = volume_info;
  dart_json["total_volume"] = total_volume;
  std::string response = dart_json.dump();
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onAddLiveStreamTask(const char* task_id,
                                              const char* url, int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnAddLiveStreamTask;
  dart_json["task_id"] = task_id ? task_id : "";
  dart_json["url"] = url ? url : "";
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onAddLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onUpdateLiveStreamTask(const char* task_id,
                                                 const char* url,
                                                 int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnUpdateLiveStreamTask;
  dart_json["task_id"] = task_id ? task_id : "";
  dart_json["url"] = url ? url : "";
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onUpdateLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRemoveLiveStreamTask(const char* task_id,
                                                 int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRemoveLiveStreamTask;
  dart_json["task_id"] = task_id ? task_id : "";
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onRemoveLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLiveStreamState(const char* task_id,
                                            const char* url,
                                            NERtcLiveStreamStateCode state) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLiveStreamStateChanged;
  dart_json["task_id"] = task_id ? task_id : "";
  dart_json["url"] = url ? url : "";
  dart_json["state"] = static_cast<int>(state);
  std::string response = dart_json.dump();
  printf("onLiveStreamState result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRecvSEIMsg(nertc::uid_t uid, const char* data,
                                       uint32_t dataSize) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRecvSEIMsg;
  dart_json["uid"] = uid;
  dart_json["data"] = data ? data : "";
  dart_json["dataSize"] = dataSize;
  std::string response = dart_json.dump();
  printf("onRecvSEIMsg result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onMediaRelayStateChanged(
    NERtcChannelMediaRelayState state, const char* channel_name) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnMediaRelayStateChanged;
  dart_json["state"] = static_cast<int>(state);
  dart_json["channel_name"] = channel_name ? channel_name : "";
  std::string response = dart_json.dump();
  printf("onMediaRelayStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onMediaRelayEvent(NERtcChannelMediaRelayEvent event,
                                            const char* channel_name,
                                            NERtcErrorCode error) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnMediaRelayEvent;
  dart_json["event"] = static_cast<int>(event);
  dart_json["channel_name"] = channel_name ? channel_name : "";
  dart_json["error"] = static_cast<int>(error);
  std::string response = dart_json.dump();
  printf("onMediaRelayEvent result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLocalPublishFallbackToAudioOnly(
    bool is_fallback, NERtcVideoStreamType stream_type) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLocalPublishFallbackToAudioOnly;
  dart_json["is_fallback"] = is_fallback;
  dart_json["stream_type"] = static_cast<int>(stream_type);
  std::string response = dart_json.dump();
  printf("onLocalPublishFallbackToAudioOnly result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onRemoteSubscribeFallbackToAudioOnly(
    nertc::uid_t uid, bool is_fallback, NERtcVideoStreamType stream_type) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnRemoteSubscribeFallbackToAudioOnly;
  dart_json["uid"] = uid;
  dart_json["is_fallback"] = is_fallback;
  dart_json["stream_type"] = static_cast<int>(stream_type);
  std::string response = dart_json.dump();
  printf("onRemoteSubscribeFallbackToAudioOnly result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onMediaRightChange(bool is_audio_banned,
                                             bool is_video_banned) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnMediaRightChange;
  dart_json["is_audio_banned"] = is_audio_banned;
  dart_json["is_video_banned"] = is_video_banned;
  std::string response = dart_json.dump();
  printf("onMediaRightChange result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcChannelWrapper::onLabFeatureCallback(const char* key,
                                               const char* param) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["channel_tag"] = channel_tag_;
  dart_json["method"] = kNERtcOnLabFeatureCallback;
  dart_json["key"] = key ? key : "";
  dart_json["param"] = param ? param : "";
  std::string response = dart_json.dump();
  printf("onLabFeatureCallback result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}