// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include <inttypes.h>  // 顶部添加
#include <cstring>
#include <cstdlib>
#include "engine_wrapper.h"

extern int ConvertNetworkType(nertc::NERtcNetworkConnectionType type);

void NERtcDesktopWrapper::onJoinChannel(channel_id_t cid, nertc::uid_t uid,
                                        NERtcErrorCode result,
                                        uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;

  json dart_json;
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

void NERtcDesktopWrapper::onError(int error_code, const char* msg) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnError;
  dart_json["error_code"] = error_code;
  dart_json["msg"] = msg;
  std::string response = dart_json.dump();
  printf("onError result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onWarning(int warn_code, const char* msg) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnWarning;
  dart_json["warn_code"] = warn_code;
  dart_json["msg"] = msg;
  std::string response = dart_json.dump();
  printf("onWarning result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onApiCallExecuted(const char* api_name,
                                            NERtcErrorCode error,
                                            const char* message) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnApiCallExecuted;
  dart_json["api_name"] = api_name;
  dart_json["error"] = static_cast<int>(error);
  dart_json["message"] = message;
  std::string response = dart_json.dump();
  printf("onApiCallExecuted result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onReleasedHwResources(NERtcErrorCode result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnReleasedHwResources;
  dart_json["result"] = static_cast<int>(result);
  std::string response = dart_json.dump();
  printf("onReleasedHwResources result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onReconnectingStart(channel_id_t cid,
                                              nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnReconnectingStart;
  dart_json["cid"] = cid;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onReconnectingStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onConnectionStateChange(
    NERtcConnectionStateType state, NERtcReasonConnectionChangedType reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnConnectionStateChange;
  dart_json["state"] = static_cast<int>(state);
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onConnectionStateChange result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRejoinChannel(channel_id_t cid, nertc::uid_t uid,
                                          NERtcErrorCode result,
                                          uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
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

void NERtcDesktopWrapper::onLeaveChannel(NERtcErrorCode result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLeaveChannel;
  dart_json["result"] = static_cast<int>(result);
  std::string response = dart_json.dump();
  printf("onLeaveChannel result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onDisconnect(NERtcErrorCode reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnDisconnect;
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onDisconnect result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onClientRoleChanged(NERtcClientRole oldRole,
                                              NERtcClientRole newRole) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnClientRoleChanged;
  dart_json["oldRole"] = static_cast<int>(oldRole);
  dart_json["newRole"] = static_cast<int>(newRole);
  std::string response = dart_json.dump();
  printf("onClientRoleChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserJoined(nertc::uid_t uid, const char* user_name,
                                       NERtcUserJoinExtraInfo join_extra_info) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserJoined;
  dart_json["uid"] = uid;
  dart_json["user_name"] = user_name;
  dart_json["join_extra_info"] = join_extra_info.custom_info;
  std::string response = dart_json.dump();
  printf("onUserJoined result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserLeft(nertc::uid_t uid,
                                     NERtcSessionLeaveReason reason,
                                     NERtcUserJoinExtraInfo leave_extra_info) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserLeave;
  dart_json["uid"] = uid;
  dart_json["reason"] = static_cast<int>(reason);
  dart_json["leave_extra_info"] = leave_extra_info.custom_info;
  std::string response = dart_json.dump();
  printf("onUserLeft result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserAudioStart(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserAudioStart;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserAudioStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserAudioStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserAudioStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserAudioStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserVideoStart(nertc::uid_t uid,
                                           NERtcVideoProfileType max_profile) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserVideoStart;
  dart_json["uid"] = uid;
  dart_json["max_profile"] = static_cast<int>(max_profile);
  std::string response = dart_json.dump();
  printf("onUserVideoStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserVideoStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserVideoStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserVideoStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserSubStreamAudioStart(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserSubStreamAudioStart;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserSubStreamAudioStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserSubStreamAudioStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserAudioMute(nertc::uid_t uid, bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserAudioMute;
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserAudioMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserVideoMute(NERtcVideoStreamType videoStreamType,
                                          nertc::uid_t uid, bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserVideoMute;
  dart_json["streamType"] = static_cast<int>(videoStreamType);
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserVideoMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserSubStreamAudioMute(nertc::uid_t uid,
                                                   bool mute) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserSubStreamAudioMute;
  dart_json["uid"] = uid;
  dart_json["mute"] = mute;
  std::string response = dart_json.dump();
  printf("onUserSubStreamAudioMute result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onFirstAudioDataReceived(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnFirstAudioDataReceived;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onFirstAudioDataReceived result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onFirstVideoDataReceived(NERtcVideoStreamType type,
                                                   nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnFirstVideoDataReceived;
  dart_json["uid"] = uid;
  dart_json["type"] = static_cast<int>(type);
  std::string response = dart_json.dump();
  printf("onFirstVideoDataReceived result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onFirstAudioFrameDecoded(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnFirstAudioFrameDecoded;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onFirstAudioFrameDecoded result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onFirstVideoFrameDecoded(NERtcVideoStreamType type,
                                                   nertc::uid_t uid,
                                                   uint32_t width,
                                                   uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnFirstVideoFrameDecoded;
  dart_json["uid"] = uid;
  dart_json["streamType"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onFirstVideoFrameDecoded result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onVirtualBackgroundSourceEnabled(
    bool enabled, NERtcVirtualBackgroundSourceStateReason reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnVirtualBackgroundSourceEnabled;
  dart_json["enabled"] = enabled;
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onVirtualBackgroundSourceEnabled result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onNetworkConnectionTypeChanged(
    NERtcNetworkConnectionType newConnectionType) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnNetworkConnectionTypeChanged;
  dart_json["newConnectionType"] =
      static_cast<int>(ConvertNetworkType(newConnectionType));
  std::string response = dart_json.dump();
  printf("onNetworkConnectionTypeChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalAudioVolumeIndication(int volume,
                                                       bool enable_vad) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalAudioVolumeIndication;
  dart_json["volume"] = volume;
  dart_json["enable_vad"] = enable_vad;
  std::string response = dart_json.dump();
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoteAudioVolumeIndication(
    const NERtcAudioVolumeInfo* speakers, unsigned int speaker_number,
    int total_volume) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
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

void NERtcDesktopWrapper::onAudioHowling(bool howling) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioHasHowling;
  dart_json["howling"] = howling;
  std::string response = dart_json.dump();
  printf("onAudioHowling result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLastmileQuality(NERtcNetworkQualityType quality) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcEngineOnLastmileQuality;
  dart_json["quality"] = static_cast<int>(quality);
  std::string response = dart_json.dump();
  printf("onLastmileQuality result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLastmileProbeResult(
    const NERtcLastmileProbeResult& result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcEngineOnLastmileProbeResult;
  dart_json["rtt"] = result.rtt;
  dart_json["state"] = static_cast<int>(result.state);

  json up_link_result;
  up_link_result["jitter"] = result.uplink_report.jitter;
  up_link_result["packet_loss_rate"] = result.uplink_report.packet_loss_rate;
  up_link_result["available_band_width"] =
      result.uplink_report.available_band_width;
  dart_json["uplink_report"] = up_link_result;

  json down_link_result;
  down_link_result["jitter"] = result.downlink_report.jitter;
  down_link_result["packet_loss_rate"] =
      result.downlink_report.packet_loss_rate;
  down_link_result["available_band_width"] =
      result.downlink_report.available_band_width;
  dart_json["downlink_report"] = down_link_result;

  std::string response = dart_json.dump();
  printf("onLastmileProbeResult result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAddLiveStreamTask(const char* task_id,
                                              const char* url, int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAddLiveStreamTask;
  dart_json["task_id"] = task_id;
  dart_json["url"] = url;
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onAddLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUpdateLiveStreamTask(const char* task_id,
                                                 const char* url,
                                                 int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUpdateLiveStreamTask;
  dart_json["task_id"] = task_id;
  dart_json["url"] = url;
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onUpdateLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoveLiveStreamTask(const char* task_id,
                                                 int error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnRemoveLiveStreamTask;
  dart_json["task_id"] = task_id;
  dart_json["error_code"] = error_code;
  std::string response = dart_json.dump();
  printf("onRemoveLiveStreamTask result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLiveStreamState(const char* task_id,
                                            const char* url,
                                            NERtcLiveStreamStateCode state) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLiveStreamStateChanged;
  dart_json["task_id"] = task_id;
  dart_json["url"] = url;
  dart_json["state"] = static_cast<int>(state);
  std::string response = dart_json.dump();
  printf("onLiveStreamState result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRecvSEIMsg(nertc::uid_t uid, const char* data,
                                       uint32_t dataSize) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnRecvSEIMsg;
  dart_json["uid"] = uid;
  dart_json["data"] = data;
  dart_json["dataSize"] = dataSize;
  std::string response = dart_json.dump();
  printf("onRecvSEIMsg result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioRecording(NERtcAudioRecordingCode code,
                                           const char* file_path) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioRecording;
  dart_json["code"] = static_cast<int>(code);
  dart_json["file_path"] = file_path;
  std::string response = dart_json.dump();
  printf("onAudioRecording result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onMediaRightChange(bool is_audio_banned,
                                             bool is_video_banned) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnMediaRightChange;
  dart_json["is_audio_banned"] = is_audio_banned;
  dart_json["is_video_banned"] = is_video_banned;
  std::string response = dart_json.dump();
  printf("onMediaRightChange result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onMediaRelayStateChanged(
    NERtcChannelMediaRelayState state, const char* channel_name) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnMediaRelayStateChanged;
  dart_json["state"] = static_cast<int>(state);
  dart_json["channel_name"] = channel_name;
  std::string response = dart_json.dump();
  printf("onMediaRelayStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onMediaRelayEvent(NERtcChannelMediaRelayEvent event,
                                            const char* channel_name,
                                            NERtcErrorCode error) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnMediaRelayEvent;
  dart_json["event"] = static_cast<int>(event);
  dart_json["channel_name"] = channel_name;
  dart_json["error"] = static_cast<int>(error);
  std::string response = dart_json.dump();
  printf("onMediaRelayEvent result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalPublishFallbackToAudioOnly(
    bool is_fallback, NERtcVideoStreamType stream_type) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalPublishFallbackToAudioOnly;
  dart_json["is_fallback"] = is_fallback;
  dart_json["stream_type"] = static_cast<int>(stream_type);
  std::string response = dart_json.dump();
  printf("onLocalPublishFallbackToAudioOnly result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoteSubscribeFallbackToAudioOnly(
    nertc::uid_t uid, bool is_fallback, NERtcVideoStreamType stream_type) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnRemoteSubscribeFallbackToAudioOnly;
  dart_json["uid"] = uid;
  dart_json["is_fallback"] = is_fallback;
  dart_json["stream_type"] = static_cast<int>(stream_type);
  std::string response = dart_json.dump();
  printf("onRemoteSubscribeFallbackToAudioOnly result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioMixingStateChanged(
    NERtcAudioMixingState state, NERtcAudioMixingErrorCode error_code) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioMixingStateChanged;
  dart_json["state"] = static_cast<int>(state);
  dart_json["error_code"] = static_cast<int>(error_code);
  std::string response = dart_json.dump();
  printf("onAudioMixingStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioMixingTimestampUpdate(uint64_t timestamp_ms) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioMixingTimestampUpdate;
  dart_json["timestamp_ms"] = timestamp_ms;
  std::string response = dart_json.dump();
  printf("onAudioMixingTimestampUpdate result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioEffectFinished(uint32_t effect_id) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioEffectFinished;
  dart_json["effect_id"] = effect_id;
  std::string response = dart_json.dump();
  printf("onAudioEffectFinished result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioEffectTimestampUpdate(uint32_t effect_id,
                                                       uint64_t timestamp_ms) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioEffectTimestampUpdate;
  dart_json["effect_id"] = effect_id;
  dart_json["timestamp_ms"] = timestamp_ms;
  std::string response = dart_json.dump();
  printf("onAudioEffectTimestampUpdate result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalVideoWatermarkState(
    NERtcVideoStreamType videoStreamType, NERtcLocalVideoWatermarkState state) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalVideoWatermarkState;
  dart_json["videoStreamType"] = static_cast<int>(videoStreamType);
  dart_json["state"] = static_cast<int>(state);
  std::string response = dart_json.dump();
  printf("onLocalVideoWatermarkState result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserSubStreamVideoStart(
    nertc::uid_t uid, NERtcVideoProfileType max_profile) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserSubVideoStreamStart;
  dart_json["uid"] = uid;
  dart_json["max_profile"] = static_cast<int>(max_profile);
  std::string response = dart_json.dump();
  printf("onUserSubStreamVideoStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserSubStreamVideoStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserSubVideoStreamStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserSubStreamVideoStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAsrCaptionStateChanged(NERtcAsrCaptionState state,
                                                   int code,
                                                   const char* message) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAsrCaptionStateChanged;
  dart_json["asrState"] = static_cast<int>(state);
  dart_json["code"] = code;
  dart_json["message"] = message ? message : "";
  std::string response = dart_json.dump();
  printf("onAsrCaptionStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAsrCaptionResult(
    const NERtcAsrCaptionResult* results, unsigned int result_count) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAsrCaptionResult;
  json result_array;
  for (unsigned int i = 0; i < result_count; i++) {
    json result_item;
    result_item["user_id"] = results[i].user_id;
    result_item["is_local_user"] = results[i].is_local_user;
    result_item["timestamp"] = results[i].timestamp;
    result_item["content"] = results[i].content;
    result_item["language"] = results[i].language;
    result_item["have_translation"] = results[i].have_translation;
    result_item["translation_language"] = results[i].translation_language;
    result_item["is_final"] = results[i].is_final;
    result_array.push_back(result_item);
  }
  dart_json["result"] = result_array;
  dart_json["resultCount"] = result_count;
  std::string response = dart_json.dump();
  printf("onAsrCaptionResult result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPlayStreamingStateChange(const char* stream_id,
                                                     NERtcPlayStreamState state,
                                                     NERtcErrorCode error) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPlayStreamingStateChange;
  dart_json["streamId"] = stream_id ? stream_id : "";
  dart_json["state"] = static_cast<int>(state);
  dart_json["reason"] = static_cast<int>(error);
  std::string response = dart_json.dump();
  printf("onPlayStreamingStateChange result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPlayStreamingReceiveSeiMessage(
    const char* stream_id, const char* message) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPlayStreamingReceiveSeiMessage;
  dart_json["streamId"] = stream_id ? stream_id : "";
  dart_json["message"] = message ? message : "";
  std::string response = dart_json.dump();
  printf("onPlayStreamingReceiveSeiMessage result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPlayStreamingFirstAudioFramePlayed(
    const char* stream_id, int64_t time_ms) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPlayStreamingFirstAudioFramePlayed;
  dart_json["streamId"] = stream_id ? stream_id : "";
  dart_json["timeMs"] = time_ms;
  std::string response = dart_json.dump();
  printf("onPlayStreamingFirstAudioFramePlayed result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPlayStreamingFirstVideoFrameRender(
    const char* stream_id, int64_t time_ms, uint32_t width, uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPlayStreamingFirstVideoFrameRender;
  dart_json["streamId"] = stream_id ? stream_id : "";
  dart_json["timeMs"] = time_ms;
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onPlayStreamingFirstVideoFrameRender result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onFirstVideoFrameRender(NERtcVideoStreamType type,
                                                  nertc::uid_t uid,
                                                  uint32_t width,
                                                  uint32_t height,
                                                  uint64_t elapsed) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnFirstVideoFrameRender;
  dart_json["userID"] = uid;
  dart_json["streamType"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  dart_json["elapsedTime"] = elapsed;
  std::string response = dart_json.dump();
  printf("onFirstVideoFrameRender result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalVideoRenderSizeChanged(
    NERtcVideoStreamType type, uint32_t width, uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalVideoRenderSizeChanged;
  dart_json["videoType"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  printf("onLocalVideoRenderSizeChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserVideoProfileUpdate(
    nertc::uid_t uid, NERtcVideoProfileType max_profile) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserVideoProfileUpdate;
  dart_json["uid"] = uid;
  dart_json["maxProfile"] = static_cast<int>(max_profile);
  std::string response = dart_json.dump();
  printf("onUserVideoProfileUpdate result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAudioDeviceStateChanged(
    const char device_id[kNERtcMaxDeviceIDLength],
    NERtcAudioDeviceType device_type, NERtcAudioDeviceState device_state) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAudioDeviceStateChange;
  dart_json["deviceType"] = static_cast<int>(device_type);
  dart_json["deviceState"] = static_cast<int>(device_state);
  std::string response = dart_json.dump();
  printf("onAudioDeviceStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onVideoDeviceStateChanged(
    const char device_id[kNERtcMaxDeviceIDLength],
    NERtcVideoDeviceType device_type, NERtcVideoDeviceState device_state) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnVideoDeviceStageChange;
  dart_json["deviceType"] = static_cast<int>(device_type);
  dart_json["deviceState"] = static_cast<int>(device_state);
  std::string response = dart_json.dump();
  printf("onVideoDeviceStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserDataStart(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserDataStart;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserDataStart result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserDataStop(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserDataStop;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserDataStop result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserDataReceiveMessage(nertc::uid_t uid,
                                                   void* pData, uint64_t size) {
  Dart_CObject** elements = (Dart_CObject**)malloc(sizeof(Dart_CObject*) * 2);

  Dart_CObject dart_str_object;
  dart_str_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserDataReceiveMessage;
  dart_json["uid"] = uid;
  dart_json["size"] = size;
  std::string response = dart_json.dump();
  dart_str_object.value.as_string = const_cast<char*>(response.c_str());
  elements[0] = &dart_str_object;

  Dart_CObject dart_data_object;
  dart_data_object.type = Dart_CObject_kTypedData;
  dart_data_object.value.as_typed_data.type = Dart_TypedData_kUint8;
  dart_data_object.value.as_typed_data.length = size;
  dart_data_object.value.as_typed_data.values = (uint8_t*)pData;
  elements[1] = &dart_data_object;

  Dart_CObject dart_array_object;
  dart_array_object.type = Dart_CObject_kArray;
  dart_array_object.value.as_array.length = 2;
  dart_array_object.value.as_array.values = elements;

  Dart_PostCObject_DL(send_port_, &dart_array_object);
  free(elements);
}

void NERtcDesktopWrapper::onUserDataStateChanged(nertc::uid_t uid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserDataStateChanged;
  dart_json["uid"] = uid;
  std::string response = dart_json.dump();
  printf("onUserDataStateChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onUserDataBufferedAmountChanged(
    nertc::uid_t uid, uint64_t previousAmount) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnUserDataBufferedAmountChanged;
  dart_json["uid"] = uid;
  dart_json["previousAmount"] = previousAmount;
  std::string response = dart_json.dump();
  printf("onUserDataBufferedAmountChanged result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLabFeatureCallback(const char* key,
                                               const char* param) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLabFeatureCallback;
  dart_json["key"] = key ? key : "";
  dart_json["param"] = param ? param : "";
  std::string response = dart_json.dump();
  printf("onLabFeatureCallback result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onAiData(const char* type, const char* data) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnAiData;
  dart_json["type"] = type ? type : "";
  dart_json["data"] = data ? data : "";
  std::string response = dart_json.dump();
  printf("onAiData result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onStartPushStreaming(NERtcErrorCode result,
                                               channel_id_t cid) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnStartPushStreaming;
  dart_json["result"] = static_cast<int>(result);
  dart_json["channelId"] = cid;
  std::string response = dart_json.dump();
  printf("onStartPushStreaming result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onStopPushStreaming(NERtcErrorCode result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnStopPushStreaming;
  dart_json["result"] = static_cast<int>(result);
  std::string response = dart_json.dump();
  printf("onStopPushStreaming result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPushStreamingChangeToReconnecting(
    NERtcErrorCode reason) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPushStreamingReconnecting;
  dart_json["reason"] = static_cast<int>(reason);
  std::string response = dart_json.dump();
  printf("onPushStreamingChangeToReconnecting result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onPushStreamingReconnectedSuccess() {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnPushStreamingReconnectedSuccess;
  std::string response = dart_json.dump();
  printf("onPushStreamingReconnectedSuccess result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onScreenCaptureStatus(
    NERtcScreenCaptureStatus status) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnScreenCaptureStatus;
  dart_json["status"] = static_cast<int>(status);
  std::string response = dart_json.dump();
  printf("onScreenCaptureStatus result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onScreenCaptureSourceDataUpdate(
    NERtcScreenCaptureSourceData data) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
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

void NERtcDesktopWrapper::onLocalRecorderStatus(NERtcLocalRecorderStatus status,
                                                const char* task_id) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalRecorderStatus;
  dart_json["status"] = static_cast<int>(status);
  dart_json["task_id"] = task_id ? task_id : "";
  std::string response = dart_json.dump();
  printf("onLocalRecorderStatus result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onLocalRecorderError(NERtcLocalRecorderError error,
                                               const char* task_id) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnLocalRecorderError;
  dart_json["error"] = static_cast<int>(error);
  dart_json["task_id"] = task_id ? task_id : "";
  std::string response = dart_json.dump();
  printf("onLocalRecorderError result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onCheckNECastAudioDriverResult(
    NERtcInstallCastAudioDriverResult result) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnCheckNECastAudioDriverResult;
  dart_json["result"] = static_cast<int>(result);
  std::string response = dart_json.dump();
  printf("onCheckNECastAudioDriverResult result: %s\n", response.c_str());
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}

void NERtcDesktopWrapper::onRemoteVideoReceiveSizeChanged(
    nertc::uid_t uid, NERtcVideoStreamType type, uint32_t width,
    uint32_t height) {
  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kString;
  json dart_json;
  dart_json["method"] = kNERtcOnRemoteVideoSizeChanged;
  dart_json["uid"] = uid;
  dart_json["streamType"] = static_cast<int>(type);
  dart_json["width"] = width;
  dart_json["height"] = height;
  std::string response = dart_json.dump();
  dart_object.value.as_string = const_cast<char*>(response.c_str());
  Dart_PostCObject_DL(send_port_, &dart_object);
}
