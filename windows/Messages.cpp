// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#undef _HAS_EXCEPTIONS

#include "Messages.h"

#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>

#include <map>
#include <optional>
#include <string>

namespace NEFLT {
using flutter::BasicMessageChannel;
using flutter::CustomEncodableValue;
using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

// NERtcUserJoinExtraInfo

NERtcUserJoinExtraInfo::NERtcUserJoinExtraInfo(const std::string& custom_info)
    : custom_info_(custom_info) {}

const std::string& NERtcUserJoinExtraInfo::custom_info() const {
  return custom_info_;
}

void NERtcUserJoinExtraInfo::set_custom_info(std::string_view value_arg) {
  custom_info_ = value_arg;
}

EncodableList NERtcUserJoinExtraInfo::ToEncodableList() const {
  EncodableList list;
  list.reserve(1);
  list.push_back(EncodableValue(custom_info_));
  return list;
}

NERtcUserJoinExtraInfo NERtcUserJoinExtraInfo::FromEncodableList(
    const EncodableList& list) {
  NERtcUserJoinExtraInfo decoded(std::get<std::string>(list[0]));
  return decoded;
}

// NERtcUserLeaveExtraInfo

NERtcUserLeaveExtraInfo::NERtcUserLeaveExtraInfo(const std::string& custom_info)
    : custom_info_(custom_info) {}

const std::string& NERtcUserLeaveExtraInfo::custom_info() const {
  return custom_info_;
}

void NERtcUserLeaveExtraInfo::set_custom_info(std::string_view value_arg) {
  custom_info_ = value_arg;
}

EncodableList NERtcUserLeaveExtraInfo::ToEncodableList() const {
  EncodableList list;
  list.reserve(1);
  list.push_back(EncodableValue(custom_info_));
  return list;
}

NERtcUserLeaveExtraInfo NERtcUserLeaveExtraInfo::FromEncodableList(
    const EncodableList& list) {
  NERtcUserLeaveExtraInfo decoded(std::get<std::string>(list[0]));
  return decoded;
}

// UserJoinedEvent

UserJoinedEvent::UserJoinedEvent(int64_t uid) : uid_(uid) {}

UserJoinedEvent::UserJoinedEvent(int64_t uid,
                                 const NERtcUserJoinExtraInfo* join_extra_info)
    : uid_(uid),
      join_extra_info_(join_extra_info ? std::optional<NERtcUserJoinExtraInfo>(
                                             *join_extra_info)
                                       : std::nullopt) {}

int64_t UserJoinedEvent::uid() const { return uid_; }

void UserJoinedEvent::set_uid(int64_t value_arg) { uid_ = value_arg; }

const NERtcUserJoinExtraInfo* UserJoinedEvent::join_extra_info() const {
  return join_extra_info_ ? &(*join_extra_info_) : nullptr;
}

void UserJoinedEvent::set_join_extra_info(
    const NERtcUserJoinExtraInfo* value_arg) {
  join_extra_info_ = value_arg
                         ? std::optional<NERtcUserJoinExtraInfo>(*value_arg)
                         : std::nullopt;
}

void UserJoinedEvent::set_join_extra_info(
    const NERtcUserJoinExtraInfo& value_arg) {
  join_extra_info_ = value_arg;
}

EncodableList UserJoinedEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(EncodableValue(uid_));
  list.push_back(join_extra_info_
                     ? EncodableValue(join_extra_info_->ToEncodableList())
                     : EncodableValue());
  return list;
}

UserJoinedEvent UserJoinedEvent::FromEncodableList(const EncodableList& list) {
  UserJoinedEvent decoded(list[0].LongValue());
  auto& encodable_join_extra_info = list[1];
  if (!encodable_join_extra_info.IsNull()) {
    decoded.set_join_extra_info(NERtcUserJoinExtraInfo::FromEncodableList(
        std::get<EncodableList>(encodable_join_extra_info)));
  }
  return decoded;
}

// UserLeaveEvent

UserLeaveEvent::UserLeaveEvent(int64_t uid, int64_t reason)
    : uid_(uid), reason_(reason) {}

UserLeaveEvent::UserLeaveEvent(int64_t uid, int64_t reason,
                               const NERtcUserLeaveExtraInfo* leave_extra_info)
    : uid_(uid),
      reason_(reason),
      leave_extra_info_(
          leave_extra_info
              ? std::optional<NERtcUserLeaveExtraInfo>(*leave_extra_info)
              : std::nullopt) {}

int64_t UserLeaveEvent::uid() const { return uid_; }

void UserLeaveEvent::set_uid(int64_t value_arg) { uid_ = value_arg; }

int64_t UserLeaveEvent::reason() const { return reason_; }

void UserLeaveEvent::set_reason(int64_t value_arg) { reason_ = value_arg; }

const NERtcUserLeaveExtraInfo* UserLeaveEvent::leave_extra_info() const {
  return leave_extra_info_ ? &(*leave_extra_info_) : nullptr;
}

void UserLeaveEvent::set_leave_extra_info(
    const NERtcUserLeaveExtraInfo* value_arg) {
  leave_extra_info_ = value_arg
                          ? std::optional<NERtcUserLeaveExtraInfo>(*value_arg)
                          : std::nullopt;
}

void UserLeaveEvent::set_leave_extra_info(
    const NERtcUserLeaveExtraInfo& value_arg) {
  leave_extra_info_ = value_arg;
}

EncodableList UserLeaveEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(EncodableValue(uid_));
  list.push_back(EncodableValue(reason_));
  list.push_back(leave_extra_info_
                     ? EncodableValue(leave_extra_info_->ToEncodableList())
                     : EncodableValue());
  return list;
}

UserLeaveEvent UserLeaveEvent::FromEncodableList(const EncodableList& list) {
  UserLeaveEvent decoded(list[0].LongValue(), list[1].LongValue());
  auto& encodable_leave_extra_info = list[2];
  if (!encodable_leave_extra_info.IsNull()) {
    decoded.set_leave_extra_info(NERtcUserLeaveExtraInfo::FromEncodableList(
        std::get<EncodableList>(encodable_leave_extra_info)));
  }
  return decoded;
}

// UserVideoMuteEvent

UserVideoMuteEvent::UserVideoMuteEvent(int64_t uid, bool muted)
    : uid_(uid), muted_(muted) {}

UserVideoMuteEvent::UserVideoMuteEvent(int64_t uid, bool muted,
                                       const int64_t* stream_type)
    : uid_(uid),
      muted_(muted),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

int64_t UserVideoMuteEvent::uid() const { return uid_; }

void UserVideoMuteEvent::set_uid(int64_t value_arg) { uid_ = value_arg; }

bool UserVideoMuteEvent::muted() const { return muted_; }

void UserVideoMuteEvent::set_muted(bool value_arg) { muted_ = value_arg; }

const int64_t* UserVideoMuteEvent::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void UserVideoMuteEvent::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void UserVideoMuteEvent::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList UserVideoMuteEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(EncodableValue(uid_));
  list.push_back(EncodableValue(muted_));
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

UserVideoMuteEvent UserVideoMuteEvent::FromEncodableList(
    const EncodableList& list) {
  UserVideoMuteEvent decoded(list[0].LongValue(), std::get<bool>(list[1]));
  auto& encodable_stream_type = list[2];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// FirstVideoDataReceivedEvent

FirstVideoDataReceivedEvent::FirstVideoDataReceivedEvent(int64_t uid)
    : uid_(uid) {}

FirstVideoDataReceivedEvent::FirstVideoDataReceivedEvent(
    int64_t uid, const int64_t* stream_type)
    : uid_(uid),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

int64_t FirstVideoDataReceivedEvent::uid() const { return uid_; }

void FirstVideoDataReceivedEvent::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const int64_t* FirstVideoDataReceivedEvent::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void FirstVideoDataReceivedEvent::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void FirstVideoDataReceivedEvent::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList FirstVideoDataReceivedEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(EncodableValue(uid_));
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

FirstVideoDataReceivedEvent FirstVideoDataReceivedEvent::FromEncodableList(
    const EncodableList& list) {
  FirstVideoDataReceivedEvent decoded(list[0].LongValue());
  auto& encodable_stream_type = list[1];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// FirstVideoFrameDecodedEvent

FirstVideoFrameDecodedEvent::FirstVideoFrameDecodedEvent(int64_t uid,
                                                         int64_t width,
                                                         int64_t height)
    : uid_(uid), width_(width), height_(height) {}

FirstVideoFrameDecodedEvent::FirstVideoFrameDecodedEvent(
    int64_t uid, int64_t width, int64_t height, const int64_t* stream_type)
    : uid_(uid),
      width_(width),
      height_(height),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

int64_t FirstVideoFrameDecodedEvent::uid() const { return uid_; }

void FirstVideoFrameDecodedEvent::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

int64_t FirstVideoFrameDecodedEvent::width() const { return width_; }

void FirstVideoFrameDecodedEvent::set_width(int64_t value_arg) {
  width_ = value_arg;
}

int64_t FirstVideoFrameDecodedEvent::height() const { return height_; }

void FirstVideoFrameDecodedEvent::set_height(int64_t value_arg) {
  height_ = value_arg;
}

const int64_t* FirstVideoFrameDecodedEvent::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void FirstVideoFrameDecodedEvent::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void FirstVideoFrameDecodedEvent::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList FirstVideoFrameDecodedEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(EncodableValue(uid_));
  list.push_back(EncodableValue(width_));
  list.push_back(EncodableValue(height_));
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

FirstVideoFrameDecodedEvent FirstVideoFrameDecodedEvent::FromEncodableList(
    const EncodableList& list) {
  FirstVideoFrameDecodedEvent decoded(list[0].LongValue(), list[1].LongValue(),
                                      list[2].LongValue());
  auto& encodable_stream_type = list[3];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// VirtualBackgroundSourceEnabledEvent

VirtualBackgroundSourceEnabledEvent::VirtualBackgroundSourceEnabledEvent(
    bool enabled, int64_t reason)
    : enabled_(enabled), reason_(reason) {}

bool VirtualBackgroundSourceEnabledEvent::enabled() const { return enabled_; }

void VirtualBackgroundSourceEnabledEvent::set_enabled(bool value_arg) {
  enabled_ = value_arg;
}

int64_t VirtualBackgroundSourceEnabledEvent::reason() const { return reason_; }

void VirtualBackgroundSourceEnabledEvent::set_reason(int64_t value_arg) {
  reason_ = value_arg;
}

EncodableList VirtualBackgroundSourceEnabledEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(EncodableValue(enabled_));
  list.push_back(EncodableValue(reason_));
  return list;
}

VirtualBackgroundSourceEnabledEvent
VirtualBackgroundSourceEnabledEvent::FromEncodableList(
    const EncodableList& list) {
  VirtualBackgroundSourceEnabledEvent decoded(std::get<bool>(list[0]),
                                              list[1].LongValue());
  return decoded;
}

// AudioVolumeInfo

AudioVolumeInfo::AudioVolumeInfo(int64_t uid, int64_t volume,
                                 int64_t sub_stream_volume)
    : uid_(uid), volume_(volume), sub_stream_volume_(sub_stream_volume) {}

int64_t AudioVolumeInfo::uid() const { return uid_; }

void AudioVolumeInfo::set_uid(int64_t value_arg) { uid_ = value_arg; }

int64_t AudioVolumeInfo::volume() const { return volume_; }

void AudioVolumeInfo::set_volume(int64_t value_arg) { volume_ = value_arg; }

int64_t AudioVolumeInfo::sub_stream_volume() const {
  return sub_stream_volume_;
}

void AudioVolumeInfo::set_sub_stream_volume(int64_t value_arg) {
  sub_stream_volume_ = value_arg;
}

EncodableList AudioVolumeInfo::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(EncodableValue(uid_));
  list.push_back(EncodableValue(volume_));
  list.push_back(EncodableValue(sub_stream_volume_));
  return list;
}

AudioVolumeInfo AudioVolumeInfo::FromEncodableList(const EncodableList& list) {
  AudioVolumeInfo decoded(list[0].LongValue(), list[1].LongValue(),
                          list[2].LongValue());
  return decoded;
}

// RemoteAudioVolumeIndicationEvent

RemoteAudioVolumeIndicationEvent::RemoteAudioVolumeIndicationEvent(
    int64_t total_volume)
    : total_volume_(total_volume) {}

RemoteAudioVolumeIndicationEvent::RemoteAudioVolumeIndicationEvent(
    const EncodableList* volume_list, int64_t total_volume)
    : volume_list_(volume_list ? std::optional<EncodableList>(*volume_list)
                               : std::nullopt),
      total_volume_(total_volume) {}

const EncodableList* RemoteAudioVolumeIndicationEvent::volume_list() const {
  return volume_list_ ? &(*volume_list_) : nullptr;
}

void RemoteAudioVolumeIndicationEvent::set_volume_list(
    const EncodableList* value_arg) {
  volume_list_ =
      value_arg ? std::optional<EncodableList>(*value_arg) : std::nullopt;
}

void RemoteAudioVolumeIndicationEvent::set_volume_list(
    const EncodableList& value_arg) {
  volume_list_ = value_arg;
}

int64_t RemoteAudioVolumeIndicationEvent::total_volume() const {
  return total_volume_;
}

void RemoteAudioVolumeIndicationEvent::set_total_volume(int64_t value_arg) {
  total_volume_ = value_arg;
}

EncodableList RemoteAudioVolumeIndicationEvent::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(volume_list_ ? EncodableValue(*volume_list_)
                              : EncodableValue());
  list.push_back(EncodableValue(total_volume_));
  return list;
}

RemoteAudioVolumeIndicationEvent
RemoteAudioVolumeIndicationEvent::FromEncodableList(const EncodableList& list) {
  RemoteAudioVolumeIndicationEvent decoded(list[1].LongValue());
  auto& encodable_volume_list = list[0];
  if (!encodable_volume_list.IsNull()) {
    decoded.set_volume_list(std::get<EncodableList>(encodable_volume_list));
  }
  return decoded;
}

// NERtcLastmileProbeResult

NERtcLastmileProbeResult::NERtcLastmileProbeResult(
    int64_t state, int64_t rtt,
    const NERtcLastmileProbeOneWayResult& uplink_report,
    const NERtcLastmileProbeOneWayResult& downlink_report)
    : state_(state),
      rtt_(rtt),
      uplink_report_(uplink_report),
      downlink_report_(downlink_report) {}

int64_t NERtcLastmileProbeResult::state() const { return state_; }

void NERtcLastmileProbeResult::set_state(int64_t value_arg) {
  state_ = value_arg;
}

int64_t NERtcLastmileProbeResult::rtt() const { return rtt_; }

void NERtcLastmileProbeResult::set_rtt(int64_t value_arg) { rtt_ = value_arg; }

const NERtcLastmileProbeOneWayResult& NERtcLastmileProbeResult::uplink_report()
    const {
  return uplink_report_;
}

void NERtcLastmileProbeResult::set_uplink_report(
    const NERtcLastmileProbeOneWayResult& value_arg) {
  uplink_report_ = value_arg;
}

const NERtcLastmileProbeOneWayResult&
NERtcLastmileProbeResult::downlink_report() const {
  return downlink_report_;
}

void NERtcLastmileProbeResult::set_downlink_report(
    const NERtcLastmileProbeOneWayResult& value_arg) {
  downlink_report_ = value_arg;
}

EncodableList NERtcLastmileProbeResult::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(EncodableValue(state_));
  list.push_back(EncodableValue(rtt_));
  list.push_back(EncodableValue(uplink_report_.ToEncodableList()));
  list.push_back(EncodableValue(downlink_report_.ToEncodableList()));
  return list;
}

NERtcLastmileProbeResult NERtcLastmileProbeResult::FromEncodableList(
    const EncodableList& list) {
  NERtcLastmileProbeResult decoded(
      list[0].LongValue(), list[1].LongValue(),
      NERtcLastmileProbeOneWayResult::FromEncodableList(
          std::get<EncodableList>(list[2])),
      NERtcLastmileProbeOneWayResult::FromEncodableList(
          std::get<EncodableList>(list[3])));
  return decoded;
}

// NERtcLastmileProbeOneWayResult

NERtcLastmileProbeOneWayResult::NERtcLastmileProbeOneWayResult(
    int64_t packet_loss_rate, int64_t jitter, int64_t available_bandwidth)
    : packet_loss_rate_(packet_loss_rate),
      jitter_(jitter),
      available_bandwidth_(available_bandwidth) {}

int64_t NERtcLastmileProbeOneWayResult::packet_loss_rate() const {
  return packet_loss_rate_;
}

void NERtcLastmileProbeOneWayResult::set_packet_loss_rate(int64_t value_arg) {
  packet_loss_rate_ = value_arg;
}

int64_t NERtcLastmileProbeOneWayResult::jitter() const { return jitter_; }

void NERtcLastmileProbeOneWayResult::set_jitter(int64_t value_arg) {
  jitter_ = value_arg;
}

int64_t NERtcLastmileProbeOneWayResult::available_bandwidth() const {
  return available_bandwidth_;
}

void NERtcLastmileProbeOneWayResult::set_available_bandwidth(
    int64_t value_arg) {
  available_bandwidth_ = value_arg;
}

EncodableList NERtcLastmileProbeOneWayResult::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(EncodableValue(packet_loss_rate_));
  list.push_back(EncodableValue(jitter_));
  list.push_back(EncodableValue(available_bandwidth_));
  return list;
}

NERtcLastmileProbeOneWayResult
NERtcLastmileProbeOneWayResult::FromEncodableList(const EncodableList& list) {
  NERtcLastmileProbeOneWayResult decoded(
      list[0].LongValue(), list[1].LongValue(), list[2].LongValue());
  return decoded;
}

// RtcServerAddresses

RtcServerAddresses::RtcServerAddresses() {}

RtcServerAddresses::RtcServerAddresses(
    const bool* valid, const std::string* channel_server,
    const std::string* statistics_server, const std::string* room_server,
    const std::string* compat_server, const std::string* nos_lbs_server,
    const std::string* nos_upload_sever, const std::string* nos_token_server,
    const std::string* sdk_config_server, const std::string* cloud_proxy_server,
    const std::string* web_socket_proxy_server,
    const std::string* quic_proxy_server, const std::string* media_proxy_server,
    const std::string* statistics_dispatch_server,
    const std::string* statistics_backup_server, const bool* use_i_pv6)
    : valid_(valid ? std::optional<bool>(*valid) : std::nullopt),
      channel_server_(channel_server
                          ? std::optional<std::string>(*channel_server)
                          : std::nullopt),
      statistics_server_(statistics_server
                             ? std::optional<std::string>(*statistics_server)
                             : std::nullopt),
      room_server_(room_server ? std::optional<std::string>(*room_server)
                               : std::nullopt),
      compat_server_(compat_server ? std::optional<std::string>(*compat_server)
                                   : std::nullopt),
      nos_lbs_server_(nos_lbs_server
                          ? std::optional<std::string>(*nos_lbs_server)
                          : std::nullopt),
      nos_upload_sever_(nos_upload_sever
                            ? std::optional<std::string>(*nos_upload_sever)
                            : std::nullopt),
      nos_token_server_(nos_token_server
                            ? std::optional<std::string>(*nos_token_server)
                            : std::nullopt),
      sdk_config_server_(sdk_config_server
                             ? std::optional<std::string>(*sdk_config_server)
                             : std::nullopt),
      cloud_proxy_server_(cloud_proxy_server
                              ? std::optional<std::string>(*cloud_proxy_server)
                              : std::nullopt),
      web_socket_proxy_server_(
          web_socket_proxy_server
              ? std::optional<std::string>(*web_socket_proxy_server)
              : std::nullopt),
      quic_proxy_server_(quic_proxy_server
                             ? std::optional<std::string>(*quic_proxy_server)
                             : std::nullopt),
      media_proxy_server_(media_proxy_server
                              ? std::optional<std::string>(*media_proxy_server)
                              : std::nullopt),
      statistics_dispatch_server_(
          statistics_dispatch_server
              ? std::optional<std::string>(*statistics_dispatch_server)
              : std::nullopt),
      statistics_backup_server_(
          statistics_backup_server
              ? std::optional<std::string>(*statistics_backup_server)
              : std::nullopt),
      use_i_pv6_(use_i_pv6 ? std::optional<bool>(*use_i_pv6) : std::nullopt) {}

const bool* RtcServerAddresses::valid() const {
  return valid_ ? &(*valid_) : nullptr;
}

void RtcServerAddresses::set_valid(const bool* value_arg) {
  valid_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_valid(bool value_arg) { valid_ = value_arg; }

const std::string* RtcServerAddresses::channel_server() const {
  return channel_server_ ? &(*channel_server_) : nullptr;
}

void RtcServerAddresses::set_channel_server(const std::string_view* value_arg) {
  channel_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_channel_server(std::string_view value_arg) {
  channel_server_ = value_arg;
}

const std::string* RtcServerAddresses::statistics_server() const {
  return statistics_server_ ? &(*statistics_server_) : nullptr;
}

void RtcServerAddresses::set_statistics_server(
    const std::string_view* value_arg) {
  statistics_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_statistics_server(std::string_view value_arg) {
  statistics_server_ = value_arg;
}

const std::string* RtcServerAddresses::room_server() const {
  return room_server_ ? &(*room_server_) : nullptr;
}

void RtcServerAddresses::set_room_server(const std::string_view* value_arg) {
  room_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_room_server(std::string_view value_arg) {
  room_server_ = value_arg;
}

const std::string* RtcServerAddresses::compat_server() const {
  return compat_server_ ? &(*compat_server_) : nullptr;
}

void RtcServerAddresses::set_compat_server(const std::string_view* value_arg) {
  compat_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_compat_server(std::string_view value_arg) {
  compat_server_ = value_arg;
}

const std::string* RtcServerAddresses::nos_lbs_server() const {
  return nos_lbs_server_ ? &(*nos_lbs_server_) : nullptr;
}

void RtcServerAddresses::set_nos_lbs_server(const std::string_view* value_arg) {
  nos_lbs_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_nos_lbs_server(std::string_view value_arg) {
  nos_lbs_server_ = value_arg;
}

const std::string* RtcServerAddresses::nos_upload_sever() const {
  return nos_upload_sever_ ? &(*nos_upload_sever_) : nullptr;
}

void RtcServerAddresses::set_nos_upload_sever(
    const std::string_view* value_arg) {
  nos_upload_sever_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_nos_upload_sever(std::string_view value_arg) {
  nos_upload_sever_ = value_arg;
}

const std::string* RtcServerAddresses::nos_token_server() const {
  return nos_token_server_ ? &(*nos_token_server_) : nullptr;
}

void RtcServerAddresses::set_nos_token_server(
    const std::string_view* value_arg) {
  nos_token_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_nos_token_server(std::string_view value_arg) {
  nos_token_server_ = value_arg;
}

const std::string* RtcServerAddresses::sdk_config_server() const {
  return sdk_config_server_ ? &(*sdk_config_server_) : nullptr;
}

void RtcServerAddresses::set_sdk_config_server(
    const std::string_view* value_arg) {
  sdk_config_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_sdk_config_server(std::string_view value_arg) {
  sdk_config_server_ = value_arg;
}

const std::string* RtcServerAddresses::cloud_proxy_server() const {
  return cloud_proxy_server_ ? &(*cloud_proxy_server_) : nullptr;
}

void RtcServerAddresses::set_cloud_proxy_server(
    const std::string_view* value_arg) {
  cloud_proxy_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_cloud_proxy_server(std::string_view value_arg) {
  cloud_proxy_server_ = value_arg;
}

const std::string* RtcServerAddresses::web_socket_proxy_server() const {
  return web_socket_proxy_server_ ? &(*web_socket_proxy_server_) : nullptr;
}

void RtcServerAddresses::set_web_socket_proxy_server(
    const std::string_view* value_arg) {
  web_socket_proxy_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_web_socket_proxy_server(
    std::string_view value_arg) {
  web_socket_proxy_server_ = value_arg;
}

const std::string* RtcServerAddresses::quic_proxy_server() const {
  return quic_proxy_server_ ? &(*quic_proxy_server_) : nullptr;
}

void RtcServerAddresses::set_quic_proxy_server(
    const std::string_view* value_arg) {
  quic_proxy_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_quic_proxy_server(std::string_view value_arg) {
  quic_proxy_server_ = value_arg;
}

const std::string* RtcServerAddresses::media_proxy_server() const {
  return media_proxy_server_ ? &(*media_proxy_server_) : nullptr;
}

void RtcServerAddresses::set_media_proxy_server(
    const std::string_view* value_arg) {
  media_proxy_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_media_proxy_server(std::string_view value_arg) {
  media_proxy_server_ = value_arg;
}

const std::string* RtcServerAddresses::statistics_dispatch_server() const {
  return statistics_dispatch_server_ ? &(*statistics_dispatch_server_)
                                     : nullptr;
}

void RtcServerAddresses::set_statistics_dispatch_server(
    const std::string_view* value_arg) {
  statistics_dispatch_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_statistics_dispatch_server(
    std::string_view value_arg) {
  statistics_dispatch_server_ = value_arg;
}

const std::string* RtcServerAddresses::statistics_backup_server() const {
  return statistics_backup_server_ ? &(*statistics_backup_server_) : nullptr;
}

void RtcServerAddresses::set_statistics_backup_server(
    const std::string_view* value_arg) {
  statistics_backup_server_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_statistics_backup_server(
    std::string_view value_arg) {
  statistics_backup_server_ = value_arg;
}

const bool* RtcServerAddresses::use_i_pv6() const {
  return use_i_pv6_ ? &(*use_i_pv6_) : nullptr;
}

void RtcServerAddresses::set_use_i_pv6(const bool* value_arg) {
  use_i_pv6_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void RtcServerAddresses::set_use_i_pv6(bool value_arg) {
  use_i_pv6_ = value_arg;
}

EncodableList RtcServerAddresses::ToEncodableList() const {
  EncodableList list;
  list.reserve(16);
  list.push_back(valid_ ? EncodableValue(*valid_) : EncodableValue());
  list.push_back(channel_server_ ? EncodableValue(*channel_server_)
                                 : EncodableValue());
  list.push_back(statistics_server_ ? EncodableValue(*statistics_server_)
                                    : EncodableValue());
  list.push_back(room_server_ ? EncodableValue(*room_server_)
                              : EncodableValue());
  list.push_back(compat_server_ ? EncodableValue(*compat_server_)
                                : EncodableValue());
  list.push_back(nos_lbs_server_ ? EncodableValue(*nos_lbs_server_)
                                 : EncodableValue());
  list.push_back(nos_upload_sever_ ? EncodableValue(*nos_upload_sever_)
                                   : EncodableValue());
  list.push_back(nos_token_server_ ? EncodableValue(*nos_token_server_)
                                   : EncodableValue());
  list.push_back(sdk_config_server_ ? EncodableValue(*sdk_config_server_)
                                    : EncodableValue());
  list.push_back(cloud_proxy_server_ ? EncodableValue(*cloud_proxy_server_)
                                     : EncodableValue());
  list.push_back(web_socket_proxy_server_
                     ? EncodableValue(*web_socket_proxy_server_)
                     : EncodableValue());
  list.push_back(quic_proxy_server_ ? EncodableValue(*quic_proxy_server_)
                                    : EncodableValue());
  list.push_back(media_proxy_server_ ? EncodableValue(*media_proxy_server_)
                                     : EncodableValue());
  list.push_back(statistics_dispatch_server_
                     ? EncodableValue(*statistics_dispatch_server_)
                     : EncodableValue());
  list.push_back(statistics_backup_server_
                     ? EncodableValue(*statistics_backup_server_)
                     : EncodableValue());
  list.push_back(use_i_pv6_ ? EncodableValue(*use_i_pv6_) : EncodableValue());
  return list;
}

RtcServerAddresses RtcServerAddresses::FromEncodableList(
    const EncodableList& list) {
  RtcServerAddresses decoded;
  auto& encodable_valid = list[0];
  if (!encodable_valid.IsNull()) {
    decoded.set_valid(std::get<bool>(encodable_valid));
  }
  auto& encodable_channel_server = list[1];
  if (!encodable_channel_server.IsNull()) {
    decoded.set_channel_server(std::get<std::string>(encodable_channel_server));
  }
  auto& encodable_statistics_server = list[2];
  if (!encodable_statistics_server.IsNull()) {
    decoded.set_statistics_server(
        std::get<std::string>(encodable_statistics_server));
  }
  auto& encodable_room_server = list[3];
  if (!encodable_room_server.IsNull()) {
    decoded.set_room_server(std::get<std::string>(encodable_room_server));
  }
  auto& encodable_compat_server = list[4];
  if (!encodable_compat_server.IsNull()) {
    decoded.set_compat_server(std::get<std::string>(encodable_compat_server));
  }
  auto& encodable_nos_lbs_server = list[5];
  if (!encodable_nos_lbs_server.IsNull()) {
    decoded.set_nos_lbs_server(std::get<std::string>(encodable_nos_lbs_server));
  }
  auto& encodable_nos_upload_sever = list[6];
  if (!encodable_nos_upload_sever.IsNull()) {
    decoded.set_nos_upload_sever(
        std::get<std::string>(encodable_nos_upload_sever));
  }
  auto& encodable_nos_token_server = list[7];
  if (!encodable_nos_token_server.IsNull()) {
    decoded.set_nos_token_server(
        std::get<std::string>(encodable_nos_token_server));
  }
  auto& encodable_sdk_config_server = list[8];
  if (!encodable_sdk_config_server.IsNull()) {
    decoded.set_sdk_config_server(
        std::get<std::string>(encodable_sdk_config_server));
  }
  auto& encodable_cloud_proxy_server = list[9];
  if (!encodable_cloud_proxy_server.IsNull()) {
    decoded.set_cloud_proxy_server(
        std::get<std::string>(encodable_cloud_proxy_server));
  }
  auto& encodable_web_socket_proxy_server = list[10];
  if (!encodable_web_socket_proxy_server.IsNull()) {
    decoded.set_web_socket_proxy_server(
        std::get<std::string>(encodable_web_socket_proxy_server));
  }
  auto& encodable_quic_proxy_server = list[11];
  if (!encodable_quic_proxy_server.IsNull()) {
    decoded.set_quic_proxy_server(
        std::get<std::string>(encodable_quic_proxy_server));
  }
  auto& encodable_media_proxy_server = list[12];
  if (!encodable_media_proxy_server.IsNull()) {
    decoded.set_media_proxy_server(
        std::get<std::string>(encodable_media_proxy_server));
  }
  auto& encodable_statistics_dispatch_server = list[13];
  if (!encodable_statistics_dispatch_server.IsNull()) {
    decoded.set_statistics_dispatch_server(
        std::get<std::string>(encodable_statistics_dispatch_server));
  }
  auto& encodable_statistics_backup_server = list[14];
  if (!encodable_statistics_backup_server.IsNull()) {
    decoded.set_statistics_backup_server(
        std::get<std::string>(encodable_statistics_backup_server));
  }
  auto& encodable_use_i_pv6 = list[15];
  if (!encodable_use_i_pv6.IsNull()) {
    decoded.set_use_i_pv6(std::get<bool>(encodable_use_i_pv6));
  }
  return decoded;
}

// CreateEngineRequest

CreateEngineRequest::CreateEngineRequest() {}

CreateEngineRequest::CreateEngineRequest(
    const std::string* app_key, const std::string* log_dir,
    const RtcServerAddresses* server_addresses, const int64_t* log_level,
    const bool* audio_auto_subscribe, const bool* video_auto_subscribe,
    const bool* disable_first_join_user_create_channel,
    const bool* audio_disable_override_speaker_on_receiver,
    const bool* audio_disable_s_w_a_e_c_on_headset,
    const bool* audio_a_i_n_s_enabled, const bool* server_record_audio,
    const bool* server_record_video, const int64_t* server_record_mode,
    const bool* server_record_speaker, const bool* publish_self_stream,
    const bool* video_capture_observer_enabled,
    const int64_t* video_encode_mode, const int64_t* video_decode_mode,
    const int64_t* video_send_mode, const bool* video_h265_enabled,
    const bool* mode1v1_enabled, const std::string* app_group)
    : app_key_(app_key ? std::optional<std::string>(*app_key) : std::nullopt),
      log_dir_(log_dir ? std::optional<std::string>(*log_dir) : std::nullopt),
      server_addresses_(server_addresses ? std::optional<RtcServerAddresses>(
                                               *server_addresses)
                                         : std::nullopt),
      log_level_(log_level ? std::optional<int64_t>(*log_level) : std::nullopt),
      audio_auto_subscribe_(audio_auto_subscribe
                                ? std::optional<bool>(*audio_auto_subscribe)
                                : std::nullopt),
      video_auto_subscribe_(video_auto_subscribe
                                ? std::optional<bool>(*video_auto_subscribe)
                                : std::nullopt),
      disable_first_join_user_create_channel_(
          disable_first_join_user_create_channel
              ? std::optional<bool>(*disable_first_join_user_create_channel)
              : std::nullopt),
      audio_disable_override_speaker_on_receiver_(
          audio_disable_override_speaker_on_receiver
              ? std::optional<bool>(*audio_disable_override_speaker_on_receiver)
              : std::nullopt),
      audio_disable_s_w_a_e_c_on_headset_(
          audio_disable_s_w_a_e_c_on_headset
              ? std::optional<bool>(*audio_disable_s_w_a_e_c_on_headset)
              : std::nullopt),
      audio_a_i_n_s_enabled_(audio_a_i_n_s_enabled
                                 ? std::optional<bool>(*audio_a_i_n_s_enabled)
                                 : std::nullopt),
      server_record_audio_(server_record_audio
                               ? std::optional<bool>(*server_record_audio)
                               : std::nullopt),
      server_record_video_(server_record_video
                               ? std::optional<bool>(*server_record_video)
                               : std::nullopt),
      server_record_mode_(server_record_mode
                              ? std::optional<int64_t>(*server_record_mode)
                              : std::nullopt),
      server_record_speaker_(server_record_speaker
                                 ? std::optional<bool>(*server_record_speaker)
                                 : std::nullopt),
      publish_self_stream_(publish_self_stream
                               ? std::optional<bool>(*publish_self_stream)
                               : std::nullopt),
      video_capture_observer_enabled_(
          video_capture_observer_enabled
              ? std::optional<bool>(*video_capture_observer_enabled)
              : std::nullopt),
      video_encode_mode_(video_encode_mode
                             ? std::optional<int64_t>(*video_encode_mode)
                             : std::nullopt),
      video_decode_mode_(video_decode_mode
                             ? std::optional<int64_t>(*video_decode_mode)
                             : std::nullopt),
      video_send_mode_(video_send_mode
                           ? std::optional<int64_t>(*video_send_mode)
                           : std::nullopt),
      video_h265_enabled_(video_h265_enabled
                              ? std::optional<bool>(*video_h265_enabled)
                              : std::nullopt),
      mode1v1_enabled_(mode1v1_enabled ? std::optional<bool>(*mode1v1_enabled)
                                       : std::nullopt),
      app_group_(app_group ? std::optional<std::string>(*app_group)
                           : std::nullopt) {}

const std::string* CreateEngineRequest::app_key() const {
  return app_key_ ? &(*app_key_) : nullptr;
}

void CreateEngineRequest::set_app_key(const std::string_view* value_arg) {
  app_key_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_app_key(std::string_view value_arg) {
  app_key_ = value_arg;
}

const std::string* CreateEngineRequest::log_dir() const {
  return log_dir_ ? &(*log_dir_) : nullptr;
}

void CreateEngineRequest::set_log_dir(const std::string_view* value_arg) {
  log_dir_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_log_dir(std::string_view value_arg) {
  log_dir_ = value_arg;
}

const RtcServerAddresses* CreateEngineRequest::server_addresses() const {
  return server_addresses_ ? &(*server_addresses_) : nullptr;
}

void CreateEngineRequest::set_server_addresses(
    const RtcServerAddresses* value_arg) {
  server_addresses_ =
      value_arg ? std::optional<RtcServerAddresses>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_server_addresses(
    const RtcServerAddresses& value_arg) {
  server_addresses_ = value_arg;
}

const int64_t* CreateEngineRequest::log_level() const {
  return log_level_ ? &(*log_level_) : nullptr;
}

void CreateEngineRequest::set_log_level(const int64_t* value_arg) {
  log_level_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_log_level(int64_t value_arg) {
  log_level_ = value_arg;
}

const bool* CreateEngineRequest::audio_auto_subscribe() const {
  return audio_auto_subscribe_ ? &(*audio_auto_subscribe_) : nullptr;
}

void CreateEngineRequest::set_audio_auto_subscribe(const bool* value_arg) {
  audio_auto_subscribe_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_audio_auto_subscribe(bool value_arg) {
  audio_auto_subscribe_ = value_arg;
}

const bool* CreateEngineRequest::video_auto_subscribe() const {
  return video_auto_subscribe_ ? &(*video_auto_subscribe_) : nullptr;
}

void CreateEngineRequest::set_video_auto_subscribe(const bool* value_arg) {
  video_auto_subscribe_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_auto_subscribe(bool value_arg) {
  video_auto_subscribe_ = value_arg;
}

const bool* CreateEngineRequest::disable_first_join_user_create_channel()
    const {
  return disable_first_join_user_create_channel_
             ? &(*disable_first_join_user_create_channel_)
             : nullptr;
}

void CreateEngineRequest::set_disable_first_join_user_create_channel(
    const bool* value_arg) {
  disable_first_join_user_create_channel_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_disable_first_join_user_create_channel(
    bool value_arg) {
  disable_first_join_user_create_channel_ = value_arg;
}

const bool* CreateEngineRequest::audio_disable_override_speaker_on_receiver()
    const {
  return audio_disable_override_speaker_on_receiver_
             ? &(*audio_disable_override_speaker_on_receiver_)
             : nullptr;
}

void CreateEngineRequest::set_audio_disable_override_speaker_on_receiver(
    const bool* value_arg) {
  audio_disable_override_speaker_on_receiver_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_audio_disable_override_speaker_on_receiver(
    bool value_arg) {
  audio_disable_override_speaker_on_receiver_ = value_arg;
}

const bool* CreateEngineRequest::audio_disable_s_w_a_e_c_on_headset() const {
  return audio_disable_s_w_a_e_c_on_headset_
             ? &(*audio_disable_s_w_a_e_c_on_headset_)
             : nullptr;
}

void CreateEngineRequest::set_audio_disable_s_w_a_e_c_on_headset(
    const bool* value_arg) {
  audio_disable_s_w_a_e_c_on_headset_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_audio_disable_s_w_a_e_c_on_headset(
    bool value_arg) {
  audio_disable_s_w_a_e_c_on_headset_ = value_arg;
}

const bool* CreateEngineRequest::audio_a_i_n_s_enabled() const {
  return audio_a_i_n_s_enabled_ ? &(*audio_a_i_n_s_enabled_) : nullptr;
}

void CreateEngineRequest::set_audio_a_i_n_s_enabled(const bool* value_arg) {
  audio_a_i_n_s_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_audio_a_i_n_s_enabled(bool value_arg) {
  audio_a_i_n_s_enabled_ = value_arg;
}

const bool* CreateEngineRequest::server_record_audio() const {
  return server_record_audio_ ? &(*server_record_audio_) : nullptr;
}

void CreateEngineRequest::set_server_record_audio(const bool* value_arg) {
  server_record_audio_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_server_record_audio(bool value_arg) {
  server_record_audio_ = value_arg;
}

const bool* CreateEngineRequest::server_record_video() const {
  return server_record_video_ ? &(*server_record_video_) : nullptr;
}

void CreateEngineRequest::set_server_record_video(const bool* value_arg) {
  server_record_video_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_server_record_video(bool value_arg) {
  server_record_video_ = value_arg;
}

const int64_t* CreateEngineRequest::server_record_mode() const {
  return server_record_mode_ ? &(*server_record_mode_) : nullptr;
}

void CreateEngineRequest::set_server_record_mode(const int64_t* value_arg) {
  server_record_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_server_record_mode(int64_t value_arg) {
  server_record_mode_ = value_arg;
}

const bool* CreateEngineRequest::server_record_speaker() const {
  return server_record_speaker_ ? &(*server_record_speaker_) : nullptr;
}

void CreateEngineRequest::set_server_record_speaker(const bool* value_arg) {
  server_record_speaker_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_server_record_speaker(bool value_arg) {
  server_record_speaker_ = value_arg;
}

const bool* CreateEngineRequest::publish_self_stream() const {
  return publish_self_stream_ ? &(*publish_self_stream_) : nullptr;
}

void CreateEngineRequest::set_publish_self_stream(const bool* value_arg) {
  publish_self_stream_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_publish_self_stream(bool value_arg) {
  publish_self_stream_ = value_arg;
}

const bool* CreateEngineRequest::video_capture_observer_enabled() const {
  return video_capture_observer_enabled_ ? &(*video_capture_observer_enabled_)
                                         : nullptr;
}

void CreateEngineRequest::set_video_capture_observer_enabled(
    const bool* value_arg) {
  video_capture_observer_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_capture_observer_enabled(bool value_arg) {
  video_capture_observer_enabled_ = value_arg;
}

const int64_t* CreateEngineRequest::video_encode_mode() const {
  return video_encode_mode_ ? &(*video_encode_mode_) : nullptr;
}

void CreateEngineRequest::set_video_encode_mode(const int64_t* value_arg) {
  video_encode_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_encode_mode(int64_t value_arg) {
  video_encode_mode_ = value_arg;
}

const int64_t* CreateEngineRequest::video_decode_mode() const {
  return video_decode_mode_ ? &(*video_decode_mode_) : nullptr;
}

void CreateEngineRequest::set_video_decode_mode(const int64_t* value_arg) {
  video_decode_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_decode_mode(int64_t value_arg) {
  video_decode_mode_ = value_arg;
}

const int64_t* CreateEngineRequest::video_send_mode() const {
  return video_send_mode_ ? &(*video_send_mode_) : nullptr;
}

void CreateEngineRequest::set_video_send_mode(const int64_t* value_arg) {
  video_send_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_send_mode(int64_t value_arg) {
  video_send_mode_ = value_arg;
}

const bool* CreateEngineRequest::video_h265_enabled() const {
  return video_h265_enabled_ ? &(*video_h265_enabled_) : nullptr;
}

void CreateEngineRequest::set_video_h265_enabled(const bool* value_arg) {
  video_h265_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_video_h265_enabled(bool value_arg) {
  video_h265_enabled_ = value_arg;
}

const bool* CreateEngineRequest::mode1v1_enabled() const {
  return mode1v1_enabled_ ? &(*mode1v1_enabled_) : nullptr;
}

void CreateEngineRequest::set_mode1v1_enabled(const bool* value_arg) {
  mode1v1_enabled_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_mode1v1_enabled(bool value_arg) {
  mode1v1_enabled_ = value_arg;
}

const std::string* CreateEngineRequest::app_group() const {
  return app_group_ ? &(*app_group_) : nullptr;
}

void CreateEngineRequest::set_app_group(const std::string_view* value_arg) {
  app_group_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void CreateEngineRequest::set_app_group(std::string_view value_arg) {
  app_group_ = value_arg;
}

EncodableList CreateEngineRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(22);
  list.push_back(app_key_ ? EncodableValue(*app_key_) : EncodableValue());
  list.push_back(log_dir_ ? EncodableValue(*log_dir_) : EncodableValue());
  list.push_back(server_addresses_
                     ? EncodableValue(server_addresses_->ToEncodableList())
                     : EncodableValue());
  list.push_back(log_level_ ? EncodableValue(*log_level_) : EncodableValue());
  list.push_back(audio_auto_subscribe_ ? EncodableValue(*audio_auto_subscribe_)
                                       : EncodableValue());
  list.push_back(video_auto_subscribe_ ? EncodableValue(*video_auto_subscribe_)
                                       : EncodableValue());
  list.push_back(disable_first_join_user_create_channel_
                     ? EncodableValue(*disable_first_join_user_create_channel_)
                     : EncodableValue());
  list.push_back(
      audio_disable_override_speaker_on_receiver_
          ? EncodableValue(*audio_disable_override_speaker_on_receiver_)
          : EncodableValue());
  list.push_back(audio_disable_s_w_a_e_c_on_headset_
                     ? EncodableValue(*audio_disable_s_w_a_e_c_on_headset_)
                     : EncodableValue());
  list.push_back(audio_a_i_n_s_enabled_
                     ? EncodableValue(*audio_a_i_n_s_enabled_)
                     : EncodableValue());
  list.push_back(server_record_audio_ ? EncodableValue(*server_record_audio_)
                                      : EncodableValue());
  list.push_back(server_record_video_ ? EncodableValue(*server_record_video_)
                                      : EncodableValue());
  list.push_back(server_record_mode_ ? EncodableValue(*server_record_mode_)
                                     : EncodableValue());
  list.push_back(server_record_speaker_
                     ? EncodableValue(*server_record_speaker_)
                     : EncodableValue());
  list.push_back(publish_self_stream_ ? EncodableValue(*publish_self_stream_)
                                      : EncodableValue());
  list.push_back(video_capture_observer_enabled_
                     ? EncodableValue(*video_capture_observer_enabled_)
                     : EncodableValue());
  list.push_back(video_encode_mode_ ? EncodableValue(*video_encode_mode_)
                                    : EncodableValue());
  list.push_back(video_decode_mode_ ? EncodableValue(*video_decode_mode_)
                                    : EncodableValue());
  list.push_back(video_send_mode_ ? EncodableValue(*video_send_mode_)
                                  : EncodableValue());
  list.push_back(video_h265_enabled_ ? EncodableValue(*video_h265_enabled_)
                                     : EncodableValue());
  list.push_back(mode1v1_enabled_ ? EncodableValue(*mode1v1_enabled_)
                                  : EncodableValue());
  list.push_back(app_group_ ? EncodableValue(*app_group_) : EncodableValue());
  return list;
}

CreateEngineRequest CreateEngineRequest::FromEncodableList(
    const EncodableList& list) {
  CreateEngineRequest decoded;
  auto& encodable_app_key = list[0];
  if (!encodable_app_key.IsNull()) {
    decoded.set_app_key(std::get<std::string>(encodable_app_key));
  }
  auto& encodable_log_dir = list[1];
  if (!encodable_log_dir.IsNull()) {
    decoded.set_log_dir(std::get<std::string>(encodable_log_dir));
  }
  auto& encodable_server_addresses = list[2];
  if (!encodable_server_addresses.IsNull()) {
    decoded.set_server_addresses(RtcServerAddresses::FromEncodableList(
        std::get<EncodableList>(encodable_server_addresses)));
  }
  auto& encodable_log_level = list[3];
  if (!encodable_log_level.IsNull()) {
    decoded.set_log_level(encodable_log_level.LongValue());
  }
  auto& encodable_audio_auto_subscribe = list[4];
  if (!encodable_audio_auto_subscribe.IsNull()) {
    decoded.set_audio_auto_subscribe(
        std::get<bool>(encodable_audio_auto_subscribe));
  }
  auto& encodable_video_auto_subscribe = list[5];
  if (!encodable_video_auto_subscribe.IsNull()) {
    decoded.set_video_auto_subscribe(
        std::get<bool>(encodable_video_auto_subscribe));
  }
  auto& encodable_disable_first_join_user_create_channel = list[6];
  if (!encodable_disable_first_join_user_create_channel.IsNull()) {
    decoded.set_disable_first_join_user_create_channel(
        std::get<bool>(encodable_disable_first_join_user_create_channel));
  }
  auto& encodable_audio_disable_override_speaker_on_receiver = list[7];
  if (!encodable_audio_disable_override_speaker_on_receiver.IsNull()) {
    decoded.set_audio_disable_override_speaker_on_receiver(
        std::get<bool>(encodable_audio_disable_override_speaker_on_receiver));
  }
  auto& encodable_audio_disable_s_w_a_e_c_on_headset = list[8];
  if (!encodable_audio_disable_s_w_a_e_c_on_headset.IsNull()) {
    decoded.set_audio_disable_s_w_a_e_c_on_headset(
        std::get<bool>(encodable_audio_disable_s_w_a_e_c_on_headset));
  }
  auto& encodable_audio_a_i_n_s_enabled = list[9];
  if (!encodable_audio_a_i_n_s_enabled.IsNull()) {
    decoded.set_audio_a_i_n_s_enabled(
        std::get<bool>(encodable_audio_a_i_n_s_enabled));
  }
  auto& encodable_server_record_audio = list[10];
  if (!encodable_server_record_audio.IsNull()) {
    decoded.set_server_record_audio(
        std::get<bool>(encodable_server_record_audio));
  }
  auto& encodable_server_record_video = list[11];
  if (!encodable_server_record_video.IsNull()) {
    decoded.set_server_record_video(
        std::get<bool>(encodable_server_record_video));
  }
  auto& encodable_server_record_mode = list[12];
  if (!encodable_server_record_mode.IsNull()) {
    decoded.set_server_record_mode(encodable_server_record_mode.LongValue());
  }
  auto& encodable_server_record_speaker = list[13];
  if (!encodable_server_record_speaker.IsNull()) {
    decoded.set_server_record_speaker(
        std::get<bool>(encodable_server_record_speaker));
  }
  auto& encodable_publish_self_stream = list[14];
  if (!encodable_publish_self_stream.IsNull()) {
    decoded.set_publish_self_stream(
        std::get<bool>(encodable_publish_self_stream));
  }
  auto& encodable_video_capture_observer_enabled = list[15];
  if (!encodable_video_capture_observer_enabled.IsNull()) {
    decoded.set_video_capture_observer_enabled(
        std::get<bool>(encodable_video_capture_observer_enabled));
  }
  auto& encodable_video_encode_mode = list[16];
  if (!encodable_video_encode_mode.IsNull()) {
    decoded.set_video_encode_mode(encodable_video_encode_mode.LongValue());
  }
  auto& encodable_video_decode_mode = list[17];
  if (!encodable_video_decode_mode.IsNull()) {
    decoded.set_video_decode_mode(encodable_video_decode_mode.LongValue());
  }
  auto& encodable_video_send_mode = list[18];
  if (!encodable_video_send_mode.IsNull()) {
    decoded.set_video_send_mode(encodable_video_send_mode.LongValue());
  }
  auto& encodable_video_h265_enabled = list[19];
  if (!encodable_video_h265_enabled.IsNull()) {
    decoded.set_video_h265_enabled(
        std::get<bool>(encodable_video_h265_enabled));
  }
  auto& encodable_mode1v1_enabled = list[20];
  if (!encodable_mode1v1_enabled.IsNull()) {
    decoded.set_mode1v1_enabled(std::get<bool>(encodable_mode1v1_enabled));
  }
  auto& encodable_app_group = list[21];
  if (!encodable_app_group.IsNull()) {
    decoded.set_app_group(std::get<std::string>(encodable_app_group));
  }
  return decoded;
}

// JoinChannelOptions

JoinChannelOptions::JoinChannelOptions() {}

JoinChannelOptions::JoinChannelOptions(const std::string* custom_info,
                                       const std::string* permission_key)
    : custom_info_(custom_info ? std::optional<std::string>(*custom_info)
                               : std::nullopt),
      permission_key_(permission_key
                          ? std::optional<std::string>(*permission_key)
                          : std::nullopt) {}

const std::string* JoinChannelOptions::custom_info() const {
  return custom_info_ ? &(*custom_info_) : nullptr;
}

void JoinChannelOptions::set_custom_info(const std::string_view* value_arg) {
  custom_info_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void JoinChannelOptions::set_custom_info(std::string_view value_arg) {
  custom_info_ = value_arg;
}

const std::string* JoinChannelOptions::permission_key() const {
  return permission_key_ ? &(*permission_key_) : nullptr;
}

void JoinChannelOptions::set_permission_key(const std::string_view* value_arg) {
  permission_key_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void JoinChannelOptions::set_permission_key(std::string_view value_arg) {
  permission_key_ = value_arg;
}

EncodableList JoinChannelOptions::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(custom_info_ ? EncodableValue(*custom_info_)
                              : EncodableValue());
  list.push_back(permission_key_ ? EncodableValue(*permission_key_)
                                 : EncodableValue());
  return list;
}

JoinChannelOptions JoinChannelOptions::FromEncodableList(
    const EncodableList& list) {
  JoinChannelOptions decoded;
  auto& encodable_custom_info = list[0];
  if (!encodable_custom_info.IsNull()) {
    decoded.set_custom_info(std::get<std::string>(encodable_custom_info));
  }
  auto& encodable_permission_key = list[1];
  if (!encodable_permission_key.IsNull()) {
    decoded.set_permission_key(std::get<std::string>(encodable_permission_key));
  }
  return decoded;
}

// JoinChannelRequest

JoinChannelRequest::JoinChannelRequest(const std::string& channel_name,
                                       int64_t uid)
    : channel_name_(channel_name), uid_(uid) {}

JoinChannelRequest::JoinChannelRequest(
    const std::string* token, const std::string& channel_name, int64_t uid,
    const JoinChannelOptions* channel_options)
    : token_(token ? std::optional<std::string>(*token) : std::nullopt),
      channel_name_(channel_name),
      uid_(uid),
      channel_options_(channel_options
                           ? std::optional<JoinChannelOptions>(*channel_options)
                           : std::nullopt) {}

const std::string* JoinChannelRequest::token() const {
  return token_ ? &(*token_) : nullptr;
}

void JoinChannelRequest::set_token(const std::string_view* value_arg) {
  token_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void JoinChannelRequest::set_token(std::string_view value_arg) {
  token_ = value_arg;
}

const std::string& JoinChannelRequest::channel_name() const {
  return channel_name_;
}

void JoinChannelRequest::set_channel_name(std::string_view value_arg) {
  channel_name_ = value_arg;
}

int64_t JoinChannelRequest::uid() const { return uid_; }

void JoinChannelRequest::set_uid(int64_t value_arg) { uid_ = value_arg; }

const JoinChannelOptions* JoinChannelRequest::channel_options() const {
  return channel_options_ ? &(*channel_options_) : nullptr;
}

void JoinChannelRequest::set_channel_options(
    const JoinChannelOptions* value_arg) {
  channel_options_ =
      value_arg ? std::optional<JoinChannelOptions>(*value_arg) : std::nullopt;
}

void JoinChannelRequest::set_channel_options(
    const JoinChannelOptions& value_arg) {
  channel_options_ = value_arg;
}

EncodableList JoinChannelRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(token_ ? EncodableValue(*token_) : EncodableValue());
  list.push_back(EncodableValue(channel_name_));
  list.push_back(EncodableValue(uid_));
  list.push_back(channel_options_
                     ? EncodableValue(channel_options_->ToEncodableList())
                     : EncodableValue());
  return list;
}

JoinChannelRequest JoinChannelRequest::FromEncodableList(
    const EncodableList& list) {
  JoinChannelRequest decoded(std::get<std::string>(list[1]),
                             list[2].LongValue());
  auto& encodable_token = list[0];
  if (!encodable_token.IsNull()) {
    decoded.set_token(std::get<std::string>(encodable_token));
  }
  auto& encodable_channel_options = list[3];
  if (!encodable_channel_options.IsNull()) {
    decoded.set_channel_options(JoinChannelOptions::FromEncodableList(
        std::get<EncodableList>(encodable_channel_options)));
  }
  return decoded;
}

// SubscribeRemoteAudioRequest

SubscribeRemoteAudioRequest::SubscribeRemoteAudioRequest() {}

SubscribeRemoteAudioRequest::SubscribeRemoteAudioRequest(const int64_t* uid,
                                                         const bool* subscribe)
    : uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt),
      subscribe_(subscribe ? std::optional<bool>(*subscribe) : std::nullopt) {}

const int64_t* SubscribeRemoteAudioRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void SubscribeRemoteAudioRequest::set_uid(const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SubscribeRemoteAudioRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const bool* SubscribeRemoteAudioRequest::subscribe() const {
  return subscribe_ ? &(*subscribe_) : nullptr;
}

void SubscribeRemoteAudioRequest::set_subscribe(const bool* value_arg) {
  subscribe_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SubscribeRemoteAudioRequest::set_subscribe(bool value_arg) {
  subscribe_ = value_arg;
}

EncodableList SubscribeRemoteAudioRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  list.push_back(subscribe_ ? EncodableValue(*subscribe_) : EncodableValue());
  return list;
}

SubscribeRemoteAudioRequest SubscribeRemoteAudioRequest::FromEncodableList(
    const EncodableList& list) {
  SubscribeRemoteAudioRequest decoded;
  auto& encodable_uid = list[0];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  auto& encodable_subscribe = list[1];
  if (!encodable_subscribe.IsNull()) {
    decoded.set_subscribe(std::get<bool>(encodable_subscribe));
  }
  return decoded;
}

// EnableLocalVideoRequest

EnableLocalVideoRequest::EnableLocalVideoRequest() {}

EnableLocalVideoRequest::EnableLocalVideoRequest(const bool* enable,
                                                 const int64_t* stream_type)
    : enable_(enable ? std::optional<bool>(*enable) : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const bool* EnableLocalVideoRequest::enable() const {
  return enable_ ? &(*enable_) : nullptr;
}

void EnableLocalVideoRequest::set_enable(const bool* value_arg) {
  enable_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void EnableLocalVideoRequest::set_enable(bool value_arg) {
  enable_ = value_arg;
}

const int64_t* EnableLocalVideoRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void EnableLocalVideoRequest::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableLocalVideoRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList EnableLocalVideoRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(enable_ ? EncodableValue(*enable_) : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

EnableLocalVideoRequest EnableLocalVideoRequest::FromEncodableList(
    const EncodableList& list) {
  EnableLocalVideoRequest decoded;
  auto& encodable_enable = list[0];
  if (!encodable_enable.IsNull()) {
    decoded.set_enable(std::get<bool>(encodable_enable));
  }
  auto& encodable_stream_type = list[1];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// SetAudioProfileRequest

SetAudioProfileRequest::SetAudioProfileRequest() {}

SetAudioProfileRequest::SetAudioProfileRequest(const int64_t* profile,
                                               const int64_t* scenario)
    : profile_(profile ? std::optional<int64_t>(*profile) : std::nullopt),
      scenario_(scenario ? std::optional<int64_t>(*scenario) : std::nullopt) {}

const int64_t* SetAudioProfileRequest::profile() const {
  return profile_ ? &(*profile_) : nullptr;
}

void SetAudioProfileRequest::set_profile(const int64_t* value_arg) {
  profile_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetAudioProfileRequest::set_profile(int64_t value_arg) {
  profile_ = value_arg;
}

const int64_t* SetAudioProfileRequest::scenario() const {
  return scenario_ ? &(*scenario_) : nullptr;
}

void SetAudioProfileRequest::set_scenario(const int64_t* value_arg) {
  scenario_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetAudioProfileRequest::set_scenario(int64_t value_arg) {
  scenario_ = value_arg;
}

EncodableList SetAudioProfileRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(profile_ ? EncodableValue(*profile_) : EncodableValue());
  list.push_back(scenario_ ? EncodableValue(*scenario_) : EncodableValue());
  return list;
}

SetAudioProfileRequest SetAudioProfileRequest::FromEncodableList(
    const EncodableList& list) {
  SetAudioProfileRequest decoded;
  auto& encodable_profile = list[0];
  if (!encodable_profile.IsNull()) {
    decoded.set_profile(encodable_profile.LongValue());
  }
  auto& encodable_scenario = list[1];
  if (!encodable_scenario.IsNull()) {
    decoded.set_scenario(encodable_scenario.LongValue());
  }
  return decoded;
}

// SetLocalVideoConfigRequest

SetLocalVideoConfigRequest::SetLocalVideoConfigRequest() {}

SetLocalVideoConfigRequest::SetLocalVideoConfigRequest(
    const int64_t* video_profile, const int64_t* video_crop_mode,
    const bool* front_camera, const int64_t* frame_rate,
    const int64_t* min_frame_rate, const int64_t* bitrate,
    const int64_t* min_bitrate, const int64_t* degradation_prefer,
    const int64_t* width, const int64_t* height, const int64_t* camera_type,
    const int64_t* mirror_mode, const int64_t* orientation_mode,
    const int64_t* stream_type)
    : video_profile_(video_profile ? std::optional<int64_t>(*video_profile)
                                   : std::nullopt),
      video_crop_mode_(video_crop_mode
                           ? std::optional<int64_t>(*video_crop_mode)
                           : std::nullopt),
      front_camera_(front_camera ? std::optional<bool>(*front_camera)
                                 : std::nullopt),
      frame_rate_(frame_rate ? std::optional<int64_t>(*frame_rate)
                             : std::nullopt),
      min_frame_rate_(min_frame_rate ? std::optional<int64_t>(*min_frame_rate)
                                     : std::nullopt),
      bitrate_(bitrate ? std::optional<int64_t>(*bitrate) : std::nullopt),
      min_bitrate_(min_bitrate ? std::optional<int64_t>(*min_bitrate)
                               : std::nullopt),
      degradation_prefer_(degradation_prefer
                              ? std::optional<int64_t>(*degradation_prefer)
                              : std::nullopt),
      width_(width ? std::optional<int64_t>(*width) : std::nullopt),
      height_(height ? std::optional<int64_t>(*height) : std::nullopt),
      camera_type_(camera_type ? std::optional<int64_t>(*camera_type)
                               : std::nullopt),
      mirror_mode_(mirror_mode ? std::optional<int64_t>(*mirror_mode)
                               : std::nullopt),
      orientation_mode_(orientation_mode
                            ? std::optional<int64_t>(*orientation_mode)
                            : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const int64_t* SetLocalVideoConfigRequest::video_profile() const {
  return video_profile_ ? &(*video_profile_) : nullptr;
}

void SetLocalVideoConfigRequest::set_video_profile(const int64_t* value_arg) {
  video_profile_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_video_profile(int64_t value_arg) {
  video_profile_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::video_crop_mode() const {
  return video_crop_mode_ ? &(*video_crop_mode_) : nullptr;
}

void SetLocalVideoConfigRequest::set_video_crop_mode(const int64_t* value_arg) {
  video_crop_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_video_crop_mode(int64_t value_arg) {
  video_crop_mode_ = value_arg;
}

const bool* SetLocalVideoConfigRequest::front_camera() const {
  return front_camera_ ? &(*front_camera_) : nullptr;
}

void SetLocalVideoConfigRequest::set_front_camera(const bool* value_arg) {
  front_camera_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_front_camera(bool value_arg) {
  front_camera_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::frame_rate() const {
  return frame_rate_ ? &(*frame_rate_) : nullptr;
}

void SetLocalVideoConfigRequest::set_frame_rate(const int64_t* value_arg) {
  frame_rate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_frame_rate(int64_t value_arg) {
  frame_rate_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::min_frame_rate() const {
  return min_frame_rate_ ? &(*min_frame_rate_) : nullptr;
}

void SetLocalVideoConfigRequest::set_min_frame_rate(const int64_t* value_arg) {
  min_frame_rate_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_min_frame_rate(int64_t value_arg) {
  min_frame_rate_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::bitrate() const {
  return bitrate_ ? &(*bitrate_) : nullptr;
}

void SetLocalVideoConfigRequest::set_bitrate(const int64_t* value_arg) {
  bitrate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_bitrate(int64_t value_arg) {
  bitrate_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::min_bitrate() const {
  return min_bitrate_ ? &(*min_bitrate_) : nullptr;
}

void SetLocalVideoConfigRequest::set_min_bitrate(const int64_t* value_arg) {
  min_bitrate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_min_bitrate(int64_t value_arg) {
  min_bitrate_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::degradation_prefer() const {
  return degradation_prefer_ ? &(*degradation_prefer_) : nullptr;
}

void SetLocalVideoConfigRequest::set_degradation_prefer(
    const int64_t* value_arg) {
  degradation_prefer_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_degradation_prefer(int64_t value_arg) {
  degradation_prefer_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::width() const {
  return width_ ? &(*width_) : nullptr;
}

void SetLocalVideoConfigRequest::set_width(const int64_t* value_arg) {
  width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_width(int64_t value_arg) {
  width_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::height() const {
  return height_ ? &(*height_) : nullptr;
}

void SetLocalVideoConfigRequest::set_height(const int64_t* value_arg) {
  height_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_height(int64_t value_arg) {
  height_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::camera_type() const {
  return camera_type_ ? &(*camera_type_) : nullptr;
}

void SetLocalVideoConfigRequest::set_camera_type(const int64_t* value_arg) {
  camera_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_camera_type(int64_t value_arg) {
  camera_type_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::mirror_mode() const {
  return mirror_mode_ ? &(*mirror_mode_) : nullptr;
}

void SetLocalVideoConfigRequest::set_mirror_mode(const int64_t* value_arg) {
  mirror_mode_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_mirror_mode(int64_t value_arg) {
  mirror_mode_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::orientation_mode() const {
  return orientation_mode_ ? &(*orientation_mode_) : nullptr;
}

void SetLocalVideoConfigRequest::set_orientation_mode(
    const int64_t* value_arg) {
  orientation_mode_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_orientation_mode(int64_t value_arg) {
  orientation_mode_ = value_arg;
}

const int64_t* SetLocalVideoConfigRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void SetLocalVideoConfigRequest::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVideoConfigRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList SetLocalVideoConfigRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(14);
  list.push_back(video_profile_ ? EncodableValue(*video_profile_)
                                : EncodableValue());
  list.push_back(video_crop_mode_ ? EncodableValue(*video_crop_mode_)
                                  : EncodableValue());
  list.push_back(front_camera_ ? EncodableValue(*front_camera_)
                               : EncodableValue());
  list.push_back(frame_rate_ ? EncodableValue(*frame_rate_) : EncodableValue());
  list.push_back(min_frame_rate_ ? EncodableValue(*min_frame_rate_)
                                 : EncodableValue());
  list.push_back(bitrate_ ? EncodableValue(*bitrate_) : EncodableValue());
  list.push_back(min_bitrate_ ? EncodableValue(*min_bitrate_)
                              : EncodableValue());
  list.push_back(degradation_prefer_ ? EncodableValue(*degradation_prefer_)
                                     : EncodableValue());
  list.push_back(width_ ? EncodableValue(*width_) : EncodableValue());
  list.push_back(height_ ? EncodableValue(*height_) : EncodableValue());
  list.push_back(camera_type_ ? EncodableValue(*camera_type_)
                              : EncodableValue());
  list.push_back(mirror_mode_ ? EncodableValue(*mirror_mode_)
                              : EncodableValue());
  list.push_back(orientation_mode_ ? EncodableValue(*orientation_mode_)
                                   : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

SetLocalVideoConfigRequest SetLocalVideoConfigRequest::FromEncodableList(
    const EncodableList& list) {
  SetLocalVideoConfigRequest decoded;
  auto& encodable_video_profile = list[0];
  if (!encodable_video_profile.IsNull()) {
    decoded.set_video_profile(encodable_video_profile.LongValue());
  }
  auto& encodable_video_crop_mode = list[1];
  if (!encodable_video_crop_mode.IsNull()) {
    decoded.set_video_crop_mode(encodable_video_crop_mode.LongValue());
  }
  auto& encodable_front_camera = list[2];
  if (!encodable_front_camera.IsNull()) {
    decoded.set_front_camera(std::get<bool>(encodable_front_camera));
  }
  auto& encodable_frame_rate = list[3];
  if (!encodable_frame_rate.IsNull()) {
    decoded.set_frame_rate(encodable_frame_rate.LongValue());
  }
  auto& encodable_min_frame_rate = list[4];
  if (!encodable_min_frame_rate.IsNull()) {
    decoded.set_min_frame_rate(encodable_min_frame_rate.LongValue());
  }
  auto& encodable_bitrate = list[5];
  if (!encodable_bitrate.IsNull()) {
    decoded.set_bitrate(encodable_bitrate.LongValue());
  }
  auto& encodable_min_bitrate = list[6];
  if (!encodable_min_bitrate.IsNull()) {
    decoded.set_min_bitrate(encodable_min_bitrate.LongValue());
  }
  auto& encodable_degradation_prefer = list[7];
  if (!encodable_degradation_prefer.IsNull()) {
    decoded.set_degradation_prefer(encodable_degradation_prefer.LongValue());
  }
  auto& encodable_width = list[8];
  if (!encodable_width.IsNull()) {
    decoded.set_width(encodable_width.LongValue());
  }
  auto& encodable_height = list[9];
  if (!encodable_height.IsNull()) {
    decoded.set_height(encodable_height.LongValue());
  }
  auto& encodable_camera_type = list[10];
  if (!encodable_camera_type.IsNull()) {
    decoded.set_camera_type(encodable_camera_type.LongValue());
  }
  auto& encodable_mirror_mode = list[11];
  if (!encodable_mirror_mode.IsNull()) {
    decoded.set_mirror_mode(encodable_mirror_mode.LongValue());
  }
  auto& encodable_orientation_mode = list[12];
  if (!encodable_orientation_mode.IsNull()) {
    decoded.set_orientation_mode(encodable_orientation_mode.LongValue());
  }
  auto& encodable_stream_type = list[13];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// SetCameraCaptureConfigRequest

SetCameraCaptureConfigRequest::SetCameraCaptureConfigRequest() {}

SetCameraCaptureConfigRequest::SetCameraCaptureConfigRequest(
    const NERtcCaptureExtraRotation* extra_rotation,
    const int64_t* capture_width, const int64_t* capture_height,
    const int64_t* stream_type)
    : extra_rotation_(extra_rotation ? std::optional<NERtcCaptureExtraRotation>(
                                           *extra_rotation)
                                     : std::nullopt),
      capture_width_(capture_width ? std::optional<int64_t>(*capture_width)
                                   : std::nullopt),
      capture_height_(capture_height ? std::optional<int64_t>(*capture_height)
                                     : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const NERtcCaptureExtraRotation* SetCameraCaptureConfigRequest::extra_rotation()
    const {
  return extra_rotation_ ? &(*extra_rotation_) : nullptr;
}

void SetCameraCaptureConfigRequest::set_extra_rotation(
    const NERtcCaptureExtraRotation* value_arg) {
  extra_rotation_ = value_arg
                        ? std::optional<NERtcCaptureExtraRotation>(*value_arg)
                        : std::nullopt;
}

void SetCameraCaptureConfigRequest::set_extra_rotation(
    const NERtcCaptureExtraRotation& value_arg) {
  extra_rotation_ = value_arg;
}

const int64_t* SetCameraCaptureConfigRequest::capture_width() const {
  return capture_width_ ? &(*capture_width_) : nullptr;
}

void SetCameraCaptureConfigRequest::set_capture_width(
    const int64_t* value_arg) {
  capture_width_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetCameraCaptureConfigRequest::set_capture_width(int64_t value_arg) {
  capture_width_ = value_arg;
}

const int64_t* SetCameraCaptureConfigRequest::capture_height() const {
  return capture_height_ ? &(*capture_height_) : nullptr;
}

void SetCameraCaptureConfigRequest::set_capture_height(
    const int64_t* value_arg) {
  capture_height_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetCameraCaptureConfigRequest::set_capture_height(int64_t value_arg) {
  capture_height_ = value_arg;
}

const int64_t* SetCameraCaptureConfigRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void SetCameraCaptureConfigRequest::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetCameraCaptureConfigRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList SetCameraCaptureConfigRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(extra_rotation_ ? EncodableValue((int)(*extra_rotation_))
                                 : EncodableValue());
  list.push_back(capture_width_ ? EncodableValue(*capture_width_)
                                : EncodableValue());
  list.push_back(capture_height_ ? EncodableValue(*capture_height_)
                                 : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

SetCameraCaptureConfigRequest SetCameraCaptureConfigRequest::FromEncodableList(
    const EncodableList& list) {
  SetCameraCaptureConfigRequest decoded;
  auto& encodable_extra_rotation = list[0];
  if (!encodable_extra_rotation.IsNull()) {
    decoded.set_extra_rotation((NERtcCaptureExtraRotation)(std::get<int32_t>(
        encodable_extra_rotation)));
  }
  auto& encodable_capture_width = list[1];
  if (!encodable_capture_width.IsNull()) {
    decoded.set_capture_width(encodable_capture_width.LongValue());
  }
  auto& encodable_capture_height = list[2];
  if (!encodable_capture_height.IsNull()) {
    decoded.set_capture_height(encodable_capture_height.LongValue());
  }
  auto& encodable_stream_type = list[3];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// StartorStopVideoPreviewRequest

StartorStopVideoPreviewRequest::StartorStopVideoPreviewRequest() {}

StartorStopVideoPreviewRequest::StartorStopVideoPreviewRequest(
    const int64_t* stream_type)
    : stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const int64_t* StartorStopVideoPreviewRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void StartorStopVideoPreviewRequest::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartorStopVideoPreviewRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList StartorStopVideoPreviewRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(1);
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

StartorStopVideoPreviewRequest
StartorStopVideoPreviewRequest::FromEncodableList(const EncodableList& list) {
  StartorStopVideoPreviewRequest decoded;
  auto& encodable_stream_type = list[0];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// StartScreenCaptureRequest

StartScreenCaptureRequest::StartScreenCaptureRequest() {}

StartScreenCaptureRequest::StartScreenCaptureRequest(
    const int64_t* content_prefer, const int64_t* video_profile,
    const int64_t* frame_rate, const int64_t* min_frame_rate,
    const int64_t* bitrate, const int64_t* min_bitrate,
    const EncodableMap* dict)
    : content_prefer_(content_prefer ? std::optional<int64_t>(*content_prefer)
                                     : std::nullopt),
      video_profile_(video_profile ? std::optional<int64_t>(*video_profile)
                                   : std::nullopt),
      frame_rate_(frame_rate ? std::optional<int64_t>(*frame_rate)
                             : std::nullopt),
      min_frame_rate_(min_frame_rate ? std::optional<int64_t>(*min_frame_rate)
                                     : std::nullopt),
      bitrate_(bitrate ? std::optional<int64_t>(*bitrate) : std::nullopt),
      min_bitrate_(min_bitrate ? std::optional<int64_t>(*min_bitrate)
                               : std::nullopt),
      dict_(dict ? std::optional<EncodableMap>(*dict) : std::nullopt) {}

const int64_t* StartScreenCaptureRequest::content_prefer() const {
  return content_prefer_ ? &(*content_prefer_) : nullptr;
}

void StartScreenCaptureRequest::set_content_prefer(const int64_t* value_arg) {
  content_prefer_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_content_prefer(int64_t value_arg) {
  content_prefer_ = value_arg;
}

const int64_t* StartScreenCaptureRequest::video_profile() const {
  return video_profile_ ? &(*video_profile_) : nullptr;
}

void StartScreenCaptureRequest::set_video_profile(const int64_t* value_arg) {
  video_profile_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_video_profile(int64_t value_arg) {
  video_profile_ = value_arg;
}

const int64_t* StartScreenCaptureRequest::frame_rate() const {
  return frame_rate_ ? &(*frame_rate_) : nullptr;
}

void StartScreenCaptureRequest::set_frame_rate(const int64_t* value_arg) {
  frame_rate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_frame_rate(int64_t value_arg) {
  frame_rate_ = value_arg;
}

const int64_t* StartScreenCaptureRequest::min_frame_rate() const {
  return min_frame_rate_ ? &(*min_frame_rate_) : nullptr;
}

void StartScreenCaptureRequest::set_min_frame_rate(const int64_t* value_arg) {
  min_frame_rate_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_min_frame_rate(int64_t value_arg) {
  min_frame_rate_ = value_arg;
}

const int64_t* StartScreenCaptureRequest::bitrate() const {
  return bitrate_ ? &(*bitrate_) : nullptr;
}

void StartScreenCaptureRequest::set_bitrate(const int64_t* value_arg) {
  bitrate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_bitrate(int64_t value_arg) {
  bitrate_ = value_arg;
}

const int64_t* StartScreenCaptureRequest::min_bitrate() const {
  return min_bitrate_ ? &(*min_bitrate_) : nullptr;
}

void StartScreenCaptureRequest::set_min_bitrate(const int64_t* value_arg) {
  min_bitrate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_min_bitrate(int64_t value_arg) {
  min_bitrate_ = value_arg;
}

const EncodableMap* StartScreenCaptureRequest::dict() const {
  return dict_ ? &(*dict_) : nullptr;
}

void StartScreenCaptureRequest::set_dict(const EncodableMap* value_arg) {
  dict_ = value_arg ? std::optional<EncodableMap>(*value_arg) : std::nullopt;
}

void StartScreenCaptureRequest::set_dict(const EncodableMap& value_arg) {
  dict_ = value_arg;
}

EncodableList StartScreenCaptureRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(7);
  list.push_back(content_prefer_ ? EncodableValue(*content_prefer_)
                                 : EncodableValue());
  list.push_back(video_profile_ ? EncodableValue(*video_profile_)
                                : EncodableValue());
  list.push_back(frame_rate_ ? EncodableValue(*frame_rate_) : EncodableValue());
  list.push_back(min_frame_rate_ ? EncodableValue(*min_frame_rate_)
                                 : EncodableValue());
  list.push_back(bitrate_ ? EncodableValue(*bitrate_) : EncodableValue());
  list.push_back(min_bitrate_ ? EncodableValue(*min_bitrate_)
                              : EncodableValue());
  list.push_back(dict_ ? EncodableValue(*dict_) : EncodableValue());
  return list;
}

StartScreenCaptureRequest StartScreenCaptureRequest::FromEncodableList(
    const EncodableList& list) {
  StartScreenCaptureRequest decoded;
  auto& encodable_content_prefer = list[0];
  if (!encodable_content_prefer.IsNull()) {
    decoded.set_content_prefer(encodable_content_prefer.LongValue());
  }
  auto& encodable_video_profile = list[1];
  if (!encodable_video_profile.IsNull()) {
    decoded.set_video_profile(encodable_video_profile.LongValue());
  }
  auto& encodable_frame_rate = list[2];
  if (!encodable_frame_rate.IsNull()) {
    decoded.set_frame_rate(encodable_frame_rate.LongValue());
  }
  auto& encodable_min_frame_rate = list[3];
  if (!encodable_min_frame_rate.IsNull()) {
    decoded.set_min_frame_rate(encodable_min_frame_rate.LongValue());
  }
  auto& encodable_bitrate = list[4];
  if (!encodable_bitrate.IsNull()) {
    decoded.set_bitrate(encodable_bitrate.LongValue());
  }
  auto& encodable_min_bitrate = list[5];
  if (!encodable_min_bitrate.IsNull()) {
    decoded.set_min_bitrate(encodable_min_bitrate.LongValue());
  }
  auto& encodable_dict = list[6];
  if (!encodable_dict.IsNull()) {
    decoded.set_dict(std::get<EncodableMap>(encodable_dict));
  }
  return decoded;
}

// SubscribeRemoteVideoStreamRequest

SubscribeRemoteVideoStreamRequest::SubscribeRemoteVideoStreamRequest() {}

SubscribeRemoteVideoStreamRequest::SubscribeRemoteVideoStreamRequest(
    const int64_t* uid, const int64_t* stream_type, const bool* subscribe)
    : uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt),
      subscribe_(subscribe ? std::optional<bool>(*subscribe) : std::nullopt) {}

const int64_t* SubscribeRemoteVideoStreamRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void SubscribeRemoteVideoStreamRequest::set_uid(const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SubscribeRemoteVideoStreamRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const int64_t* SubscribeRemoteVideoStreamRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void SubscribeRemoteVideoStreamRequest::set_stream_type(
    const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SubscribeRemoteVideoStreamRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

const bool* SubscribeRemoteVideoStreamRequest::subscribe() const {
  return subscribe_ ? &(*subscribe_) : nullptr;
}

void SubscribeRemoteVideoStreamRequest::set_subscribe(const bool* value_arg) {
  subscribe_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SubscribeRemoteVideoStreamRequest::set_subscribe(bool value_arg) {
  subscribe_ = value_arg;
}

EncodableList SubscribeRemoteVideoStreamRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  list.push_back(subscribe_ ? EncodableValue(*subscribe_) : EncodableValue());
  return list;
}

SubscribeRemoteVideoStreamRequest
SubscribeRemoteVideoStreamRequest::FromEncodableList(
    const EncodableList& list) {
  SubscribeRemoteVideoStreamRequest decoded;
  auto& encodable_uid = list[0];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  auto& encodable_stream_type = list[1];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  auto& encodable_subscribe = list[2];
  if (!encodable_subscribe.IsNull()) {
    decoded.set_subscribe(std::get<bool>(encodable_subscribe));
  }
  return decoded;
}

// SubscribeRemoteSubStreamVideoRequest

SubscribeRemoteSubStreamVideoRequest::SubscribeRemoteSubStreamVideoRequest() {}

SubscribeRemoteSubStreamVideoRequest::SubscribeRemoteSubStreamVideoRequest(
    const int64_t* uid, const bool* subscribe)
    : uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt),
      subscribe_(subscribe ? std::optional<bool>(*subscribe) : std::nullopt) {}

const int64_t* SubscribeRemoteSubStreamVideoRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void SubscribeRemoteSubStreamVideoRequest::set_uid(const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SubscribeRemoteSubStreamVideoRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const bool* SubscribeRemoteSubStreamVideoRequest::subscribe() const {
  return subscribe_ ? &(*subscribe_) : nullptr;
}

void SubscribeRemoteSubStreamVideoRequest::set_subscribe(
    const bool* value_arg) {
  subscribe_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SubscribeRemoteSubStreamVideoRequest::set_subscribe(bool value_arg) {
  subscribe_ = value_arg;
}

EncodableList SubscribeRemoteSubStreamVideoRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  list.push_back(subscribe_ ? EncodableValue(*subscribe_) : EncodableValue());
  return list;
}

SubscribeRemoteSubStreamVideoRequest
SubscribeRemoteSubStreamVideoRequest::FromEncodableList(
    const EncodableList& list) {
  SubscribeRemoteSubStreamVideoRequest decoded;
  auto& encodable_uid = list[0];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  auto& encodable_subscribe = list[1];
  if (!encodable_subscribe.IsNull()) {
    decoded.set_subscribe(std::get<bool>(encodable_subscribe));
  }
  return decoded;
}

// EnableAudioVolumeIndicationRequest

EnableAudioVolumeIndicationRequest::EnableAudioVolumeIndicationRequest() {}

EnableAudioVolumeIndicationRequest::EnableAudioVolumeIndicationRequest(
    const bool* enable, const int64_t* interval, const bool* vad)
    : enable_(enable ? std::optional<bool>(*enable) : std::nullopt),
      interval_(interval ? std::optional<int64_t>(*interval) : std::nullopt),
      vad_(vad ? std::optional<bool>(*vad) : std::nullopt) {}

const bool* EnableAudioVolumeIndicationRequest::enable() const {
  return enable_ ? &(*enable_) : nullptr;
}

void EnableAudioVolumeIndicationRequest::set_enable(const bool* value_arg) {
  enable_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void EnableAudioVolumeIndicationRequest::set_enable(bool value_arg) {
  enable_ = value_arg;
}

const int64_t* EnableAudioVolumeIndicationRequest::interval() const {
  return interval_ ? &(*interval_) : nullptr;
}

void EnableAudioVolumeIndicationRequest::set_interval(
    const int64_t* value_arg) {
  interval_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableAudioVolumeIndicationRequest::set_interval(int64_t value_arg) {
  interval_ = value_arg;
}

const bool* EnableAudioVolumeIndicationRequest::vad() const {
  return vad_ ? &(*vad_) : nullptr;
}

void EnableAudioVolumeIndicationRequest::set_vad(const bool* value_arg) {
  vad_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void EnableAudioVolumeIndicationRequest::set_vad(bool value_arg) {
  vad_ = value_arg;
}

EncodableList EnableAudioVolumeIndicationRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(enable_ ? EncodableValue(*enable_) : EncodableValue());
  list.push_back(interval_ ? EncodableValue(*interval_) : EncodableValue());
  list.push_back(vad_ ? EncodableValue(*vad_) : EncodableValue());
  return list;
}

EnableAudioVolumeIndicationRequest
EnableAudioVolumeIndicationRequest::FromEncodableList(
    const EncodableList& list) {
  EnableAudioVolumeIndicationRequest decoded;
  auto& encodable_enable = list[0];
  if (!encodable_enable.IsNull()) {
    decoded.set_enable(std::get<bool>(encodable_enable));
  }
  auto& encodable_interval = list[1];
  if (!encodable_interval.IsNull()) {
    decoded.set_interval(encodable_interval.LongValue());
  }
  auto& encodable_vad = list[2];
  if (!encodable_vad.IsNull()) {
    decoded.set_vad(std::get<bool>(encodable_vad));
  }
  return decoded;
}

// SubscribeRemoteSubStreamAudioRequest

SubscribeRemoteSubStreamAudioRequest::SubscribeRemoteSubStreamAudioRequest() {}

SubscribeRemoteSubStreamAudioRequest::SubscribeRemoteSubStreamAudioRequest(
    const bool* subscribe, const int64_t* uid)
    : subscribe_(subscribe ? std::optional<bool>(*subscribe) : std::nullopt),
      uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt) {}

const bool* SubscribeRemoteSubStreamAudioRequest::subscribe() const {
  return subscribe_ ? &(*subscribe_) : nullptr;
}

void SubscribeRemoteSubStreamAudioRequest::set_subscribe(
    const bool* value_arg) {
  subscribe_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SubscribeRemoteSubStreamAudioRequest::set_subscribe(bool value_arg) {
  subscribe_ = value_arg;
}

const int64_t* SubscribeRemoteSubStreamAudioRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void SubscribeRemoteSubStreamAudioRequest::set_uid(const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SubscribeRemoteSubStreamAudioRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

EncodableList SubscribeRemoteSubStreamAudioRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(subscribe_ ? EncodableValue(*subscribe_) : EncodableValue());
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  return list;
}

SubscribeRemoteSubStreamAudioRequest
SubscribeRemoteSubStreamAudioRequest::FromEncodableList(
    const EncodableList& list) {
  SubscribeRemoteSubStreamAudioRequest decoded;
  auto& encodable_subscribe = list[0];
  if (!encodable_subscribe.IsNull()) {
    decoded.set_subscribe(std::get<bool>(encodable_subscribe));
  }
  auto& encodable_uid = list[1];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  return decoded;
}

// SetAudioSubscribeOnlyByRequest

SetAudioSubscribeOnlyByRequest::SetAudioSubscribeOnlyByRequest() {}

SetAudioSubscribeOnlyByRequest::SetAudioSubscribeOnlyByRequest(
    const EncodableList* uid_array)
    : uid_array_(uid_array ? std::optional<EncodableList>(*uid_array)
                           : std::nullopt) {}

const EncodableList* SetAudioSubscribeOnlyByRequest::uid_array() const {
  return uid_array_ ? &(*uid_array_) : nullptr;
}

void SetAudioSubscribeOnlyByRequest::set_uid_array(
    const EncodableList* value_arg) {
  uid_array_ =
      value_arg ? std::optional<EncodableList>(*value_arg) : std::nullopt;
}

void SetAudioSubscribeOnlyByRequest::set_uid_array(
    const EncodableList& value_arg) {
  uid_array_ = value_arg;
}

EncodableList SetAudioSubscribeOnlyByRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(1);
  list.push_back(uid_array_ ? EncodableValue(*uid_array_) : EncodableValue());
  return list;
}

SetAudioSubscribeOnlyByRequest
SetAudioSubscribeOnlyByRequest::FromEncodableList(const EncodableList& list) {
  SetAudioSubscribeOnlyByRequest decoded;
  auto& encodable_uid_array = list[0];
  if (!encodable_uid_array.IsNull()) {
    decoded.set_uid_array(std::get<EncodableList>(encodable_uid_array));
  }
  return decoded;
}

// StartAudioMixingRequest

StartAudioMixingRequest::StartAudioMixingRequest() {}

StartAudioMixingRequest::StartAudioMixingRequest(
    const std::string* path, const int64_t* loop_count,
    const bool* send_enabled, const int64_t* send_volume,
    const bool* playback_enabled, const int64_t* playback_volume,
    const int64_t* start_time_stamp, const int64_t* send_with_audio_type,
    const int64_t* progress_interval)
    : path_(path ? std::optional<std::string>(*path) : std::nullopt),
      loop_count_(loop_count ? std::optional<int64_t>(*loop_count)
                             : std::nullopt),
      send_enabled_(send_enabled ? std::optional<bool>(*send_enabled)
                                 : std::nullopt),
      send_volume_(send_volume ? std::optional<int64_t>(*send_volume)
                               : std::nullopt),
      playback_enabled_(playback_enabled
                            ? std::optional<bool>(*playback_enabled)
                            : std::nullopt),
      playback_volume_(playback_volume
                           ? std::optional<int64_t>(*playback_volume)
                           : std::nullopt),
      start_time_stamp_(start_time_stamp
                            ? std::optional<int64_t>(*start_time_stamp)
                            : std::nullopt),
      send_with_audio_type_(send_with_audio_type
                                ? std::optional<int64_t>(*send_with_audio_type)
                                : std::nullopt),
      progress_interval_(progress_interval
                             ? std::optional<int64_t>(*progress_interval)
                             : std::nullopt) {}

const std::string* StartAudioMixingRequest::path() const {
  return path_ ? &(*path_) : nullptr;
}

void StartAudioMixingRequest::set_path(const std::string_view* value_arg) {
  path_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_path(std::string_view value_arg) {
  path_ = value_arg;
}

const int64_t* StartAudioMixingRequest::loop_count() const {
  return loop_count_ ? &(*loop_count_) : nullptr;
}

void StartAudioMixingRequest::set_loop_count(const int64_t* value_arg) {
  loop_count_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_loop_count(int64_t value_arg) {
  loop_count_ = value_arg;
}

const bool* StartAudioMixingRequest::send_enabled() const {
  return send_enabled_ ? &(*send_enabled_) : nullptr;
}

void StartAudioMixingRequest::set_send_enabled(const bool* value_arg) {
  send_enabled_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_send_enabled(bool value_arg) {
  send_enabled_ = value_arg;
}

const int64_t* StartAudioMixingRequest::send_volume() const {
  return send_volume_ ? &(*send_volume_) : nullptr;
}

void StartAudioMixingRequest::set_send_volume(const int64_t* value_arg) {
  send_volume_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_send_volume(int64_t value_arg) {
  send_volume_ = value_arg;
}

const bool* StartAudioMixingRequest::playback_enabled() const {
  return playback_enabled_ ? &(*playback_enabled_) : nullptr;
}

void StartAudioMixingRequest::set_playback_enabled(const bool* value_arg) {
  playback_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_playback_enabled(bool value_arg) {
  playback_enabled_ = value_arg;
}

const int64_t* StartAudioMixingRequest::playback_volume() const {
  return playback_volume_ ? &(*playback_volume_) : nullptr;
}

void StartAudioMixingRequest::set_playback_volume(const int64_t* value_arg) {
  playback_volume_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_playback_volume(int64_t value_arg) {
  playback_volume_ = value_arg;
}

const int64_t* StartAudioMixingRequest::start_time_stamp() const {
  return start_time_stamp_ ? &(*start_time_stamp_) : nullptr;
}

void StartAudioMixingRequest::set_start_time_stamp(const int64_t* value_arg) {
  start_time_stamp_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_start_time_stamp(int64_t value_arg) {
  start_time_stamp_ = value_arg;
}

const int64_t* StartAudioMixingRequest::send_with_audio_type() const {
  return send_with_audio_type_ ? &(*send_with_audio_type_) : nullptr;
}

void StartAudioMixingRequest::set_send_with_audio_type(
    const int64_t* value_arg) {
  send_with_audio_type_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_send_with_audio_type(int64_t value_arg) {
  send_with_audio_type_ = value_arg;
}

const int64_t* StartAudioMixingRequest::progress_interval() const {
  return progress_interval_ ? &(*progress_interval_) : nullptr;
}

void StartAudioMixingRequest::set_progress_interval(const int64_t* value_arg) {
  progress_interval_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioMixingRequest::set_progress_interval(int64_t value_arg) {
  progress_interval_ = value_arg;
}

EncodableList StartAudioMixingRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(9);
  list.push_back(path_ ? EncodableValue(*path_) : EncodableValue());
  list.push_back(loop_count_ ? EncodableValue(*loop_count_) : EncodableValue());
  list.push_back(send_enabled_ ? EncodableValue(*send_enabled_)
                               : EncodableValue());
  list.push_back(send_volume_ ? EncodableValue(*send_volume_)
                              : EncodableValue());
  list.push_back(playback_enabled_ ? EncodableValue(*playback_enabled_)
                                   : EncodableValue());
  list.push_back(playback_volume_ ? EncodableValue(*playback_volume_)
                                  : EncodableValue());
  list.push_back(start_time_stamp_ ? EncodableValue(*start_time_stamp_)
                                   : EncodableValue());
  list.push_back(send_with_audio_type_ ? EncodableValue(*send_with_audio_type_)
                                       : EncodableValue());
  list.push_back(progress_interval_ ? EncodableValue(*progress_interval_)
                                    : EncodableValue());
  return list;
}

StartAudioMixingRequest StartAudioMixingRequest::FromEncodableList(
    const EncodableList& list) {
  StartAudioMixingRequest decoded;
  auto& encodable_path = list[0];
  if (!encodable_path.IsNull()) {
    decoded.set_path(std::get<std::string>(encodable_path));
  }
  auto& encodable_loop_count = list[1];
  if (!encodable_loop_count.IsNull()) {
    decoded.set_loop_count(encodable_loop_count.LongValue());
  }
  auto& encodable_send_enabled = list[2];
  if (!encodable_send_enabled.IsNull()) {
    decoded.set_send_enabled(std::get<bool>(encodable_send_enabled));
  }
  auto& encodable_send_volume = list[3];
  if (!encodable_send_volume.IsNull()) {
    decoded.set_send_volume(encodable_send_volume.LongValue());
  }
  auto& encodable_playback_enabled = list[4];
  if (!encodable_playback_enabled.IsNull()) {
    decoded.set_playback_enabled(std::get<bool>(encodable_playback_enabled));
  }
  auto& encodable_playback_volume = list[5];
  if (!encodable_playback_volume.IsNull()) {
    decoded.set_playback_volume(encodable_playback_volume.LongValue());
  }
  auto& encodable_start_time_stamp = list[6];
  if (!encodable_start_time_stamp.IsNull()) {
    decoded.set_start_time_stamp(encodable_start_time_stamp.LongValue());
  }
  auto& encodable_send_with_audio_type = list[7];
  if (!encodable_send_with_audio_type.IsNull()) {
    decoded.set_send_with_audio_type(
        encodable_send_with_audio_type.LongValue());
  }
  auto& encodable_progress_interval = list[8];
  if (!encodable_progress_interval.IsNull()) {
    decoded.set_progress_interval(encodable_progress_interval.LongValue());
  }
  return decoded;
}

// PlayEffectRequest

PlayEffectRequest::PlayEffectRequest() {}

PlayEffectRequest::PlayEffectRequest(
    const int64_t* effect_id, const std::string* path,
    const int64_t* loop_count, const bool* send_enabled,
    const int64_t* send_volume, const bool* playback_enabled,
    const int64_t* playback_volume, const int64_t* start_timestamp,
    const int64_t* send_with_audio_type, const int64_t* progress_interval)
    : effect_id_(effect_id ? std::optional<int64_t>(*effect_id) : std::nullopt),
      path_(path ? std::optional<std::string>(*path) : std::nullopt),
      loop_count_(loop_count ? std::optional<int64_t>(*loop_count)
                             : std::nullopt),
      send_enabled_(send_enabled ? std::optional<bool>(*send_enabled)
                                 : std::nullopt),
      send_volume_(send_volume ? std::optional<int64_t>(*send_volume)
                               : std::nullopt),
      playback_enabled_(playback_enabled
                            ? std::optional<bool>(*playback_enabled)
                            : std::nullopt),
      playback_volume_(playback_volume
                           ? std::optional<int64_t>(*playback_volume)
                           : std::nullopt),
      start_timestamp_(start_timestamp
                           ? std::optional<int64_t>(*start_timestamp)
                           : std::nullopt),
      send_with_audio_type_(send_with_audio_type
                                ? std::optional<int64_t>(*send_with_audio_type)
                                : std::nullopt),
      progress_interval_(progress_interval
                             ? std::optional<int64_t>(*progress_interval)
                             : std::nullopt) {}

const int64_t* PlayEffectRequest::effect_id() const {
  return effect_id_ ? &(*effect_id_) : nullptr;
}

void PlayEffectRequest::set_effect_id(const int64_t* value_arg) {
  effect_id_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_effect_id(int64_t value_arg) {
  effect_id_ = value_arg;
}

const std::string* PlayEffectRequest::path() const {
  return path_ ? &(*path_) : nullptr;
}

void PlayEffectRequest::set_path(const std::string_view* value_arg) {
  path_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_path(std::string_view value_arg) {
  path_ = value_arg;
}

const int64_t* PlayEffectRequest::loop_count() const {
  return loop_count_ ? &(*loop_count_) : nullptr;
}

void PlayEffectRequest::set_loop_count(const int64_t* value_arg) {
  loop_count_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_loop_count(int64_t value_arg) {
  loop_count_ = value_arg;
}

const bool* PlayEffectRequest::send_enabled() const {
  return send_enabled_ ? &(*send_enabled_) : nullptr;
}

void PlayEffectRequest::set_send_enabled(const bool* value_arg) {
  send_enabled_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_send_enabled(bool value_arg) {
  send_enabled_ = value_arg;
}

const int64_t* PlayEffectRequest::send_volume() const {
  return send_volume_ ? &(*send_volume_) : nullptr;
}

void PlayEffectRequest::set_send_volume(const int64_t* value_arg) {
  send_volume_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_send_volume(int64_t value_arg) {
  send_volume_ = value_arg;
}

const bool* PlayEffectRequest::playback_enabled() const {
  return playback_enabled_ ? &(*playback_enabled_) : nullptr;
}

void PlayEffectRequest::set_playback_enabled(const bool* value_arg) {
  playback_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_playback_enabled(bool value_arg) {
  playback_enabled_ = value_arg;
}

const int64_t* PlayEffectRequest::playback_volume() const {
  return playback_volume_ ? &(*playback_volume_) : nullptr;
}

void PlayEffectRequest::set_playback_volume(const int64_t* value_arg) {
  playback_volume_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_playback_volume(int64_t value_arg) {
  playback_volume_ = value_arg;
}

const int64_t* PlayEffectRequest::start_timestamp() const {
  return start_timestamp_ ? &(*start_timestamp_) : nullptr;
}

void PlayEffectRequest::set_start_timestamp(const int64_t* value_arg) {
  start_timestamp_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_start_timestamp(int64_t value_arg) {
  start_timestamp_ = value_arg;
}

const int64_t* PlayEffectRequest::send_with_audio_type() const {
  return send_with_audio_type_ ? &(*send_with_audio_type_) : nullptr;
}

void PlayEffectRequest::set_send_with_audio_type(const int64_t* value_arg) {
  send_with_audio_type_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_send_with_audio_type(int64_t value_arg) {
  send_with_audio_type_ = value_arg;
}

const int64_t* PlayEffectRequest::progress_interval() const {
  return progress_interval_ ? &(*progress_interval_) : nullptr;
}

void PlayEffectRequest::set_progress_interval(const int64_t* value_arg) {
  progress_interval_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void PlayEffectRequest::set_progress_interval(int64_t value_arg) {
  progress_interval_ = value_arg;
}

EncodableList PlayEffectRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(10);
  list.push_back(effect_id_ ? EncodableValue(*effect_id_) : EncodableValue());
  list.push_back(path_ ? EncodableValue(*path_) : EncodableValue());
  list.push_back(loop_count_ ? EncodableValue(*loop_count_) : EncodableValue());
  list.push_back(send_enabled_ ? EncodableValue(*send_enabled_)
                               : EncodableValue());
  list.push_back(send_volume_ ? EncodableValue(*send_volume_)
                              : EncodableValue());
  list.push_back(playback_enabled_ ? EncodableValue(*playback_enabled_)
                                   : EncodableValue());
  list.push_back(playback_volume_ ? EncodableValue(*playback_volume_)
                                  : EncodableValue());
  list.push_back(start_timestamp_ ? EncodableValue(*start_timestamp_)
                                  : EncodableValue());
  list.push_back(send_with_audio_type_ ? EncodableValue(*send_with_audio_type_)
                                       : EncodableValue());
  list.push_back(progress_interval_ ? EncodableValue(*progress_interval_)
                                    : EncodableValue());
  return list;
}

PlayEffectRequest PlayEffectRequest::FromEncodableList(
    const EncodableList& list) {
  PlayEffectRequest decoded;
  auto& encodable_effect_id = list[0];
  if (!encodable_effect_id.IsNull()) {
    decoded.set_effect_id(encodable_effect_id.LongValue());
  }
  auto& encodable_path = list[1];
  if (!encodable_path.IsNull()) {
    decoded.set_path(std::get<std::string>(encodable_path));
  }
  auto& encodable_loop_count = list[2];
  if (!encodable_loop_count.IsNull()) {
    decoded.set_loop_count(encodable_loop_count.LongValue());
  }
  auto& encodable_send_enabled = list[3];
  if (!encodable_send_enabled.IsNull()) {
    decoded.set_send_enabled(std::get<bool>(encodable_send_enabled));
  }
  auto& encodable_send_volume = list[4];
  if (!encodable_send_volume.IsNull()) {
    decoded.set_send_volume(encodable_send_volume.LongValue());
  }
  auto& encodable_playback_enabled = list[5];
  if (!encodable_playback_enabled.IsNull()) {
    decoded.set_playback_enabled(std::get<bool>(encodable_playback_enabled));
  }
  auto& encodable_playback_volume = list[6];
  if (!encodable_playback_volume.IsNull()) {
    decoded.set_playback_volume(encodable_playback_volume.LongValue());
  }
  auto& encodable_start_timestamp = list[7];
  if (!encodable_start_timestamp.IsNull()) {
    decoded.set_start_timestamp(encodable_start_timestamp.LongValue());
  }
  auto& encodable_send_with_audio_type = list[8];
  if (!encodable_send_with_audio_type.IsNull()) {
    decoded.set_send_with_audio_type(
        encodable_send_with_audio_type.LongValue());
  }
  auto& encodable_progress_interval = list[9];
  if (!encodable_progress_interval.IsNull()) {
    decoded.set_progress_interval(encodable_progress_interval.LongValue());
  }
  return decoded;
}

// SetCameraPositionRequest

SetCameraPositionRequest::SetCameraPositionRequest() {}

SetCameraPositionRequest::SetCameraPositionRequest(const double* x,
                                                   const double* y)
    : x_(x ? std::optional<double>(*x) : std::nullopt),
      y_(y ? std::optional<double>(*y) : std::nullopt) {}

const double* SetCameraPositionRequest::x() const {
  return x_ ? &(*x_) : nullptr;
}

void SetCameraPositionRequest::set_x(const double* value_arg) {
  x_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetCameraPositionRequest::set_x(double value_arg) { x_ = value_arg; }

const double* SetCameraPositionRequest::y() const {
  return y_ ? &(*y_) : nullptr;
}

void SetCameraPositionRequest::set_y(const double* value_arg) {
  y_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetCameraPositionRequest::set_y(double value_arg) { y_ = value_arg; }

EncodableList SetCameraPositionRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(x_ ? EncodableValue(*x_) : EncodableValue());
  list.push_back(y_ ? EncodableValue(*y_) : EncodableValue());
  return list;
}

SetCameraPositionRequest SetCameraPositionRequest::FromEncodableList(
    const EncodableList& list) {
  SetCameraPositionRequest decoded;
  auto& encodable_x = list[0];
  if (!encodable_x.IsNull()) {
    decoded.set_x(std::get<double>(encodable_x));
  }
  auto& encodable_y = list[1];
  if (!encodable_y.IsNull()) {
    decoded.set_y(std::get<double>(encodable_y));
  }
  return decoded;
}

// AddOrUpdateLiveStreamTaskRequest

AddOrUpdateLiveStreamTaskRequest::AddOrUpdateLiveStreamTaskRequest() {}

AddOrUpdateLiveStreamTaskRequest::AddOrUpdateLiveStreamTaskRequest(
    const int64_t* serial, const std::string* task_id, const std::string* url,
    const bool* server_record_enabled, const int64_t* live_mode,
    const int64_t* layout_width, const int64_t* layout_height,
    const int64_t* layout_background_color, const std::string* layout_image_url,
    const int64_t* layout_image_x, const int64_t* layout_image_y,
    const int64_t* layout_image_width, const int64_t* layout_image_height,
    const EncodableList* layout_user_transcoding_list)
    : serial_(serial ? std::optional<int64_t>(*serial) : std::nullopt),
      task_id_(task_id ? std::optional<std::string>(*task_id) : std::nullopt),
      url_(url ? std::optional<std::string>(*url) : std::nullopt),
      server_record_enabled_(server_record_enabled
                                 ? std::optional<bool>(*server_record_enabled)
                                 : std::nullopt),
      live_mode_(live_mode ? std::optional<int64_t>(*live_mode) : std::nullopt),
      layout_width_(layout_width ? std::optional<int64_t>(*layout_width)
                                 : std::nullopt),
      layout_height_(layout_height ? std::optional<int64_t>(*layout_height)
                                   : std::nullopt),
      layout_background_color_(
          layout_background_color
              ? std::optional<int64_t>(*layout_background_color)
              : std::nullopt),
      layout_image_url_(layout_image_url
                            ? std::optional<std::string>(*layout_image_url)
                            : std::nullopt),
      layout_image_x_(layout_image_x ? std::optional<int64_t>(*layout_image_x)
                                     : std::nullopt),
      layout_image_y_(layout_image_y ? std::optional<int64_t>(*layout_image_y)
                                     : std::nullopt),
      layout_image_width_(layout_image_width
                              ? std::optional<int64_t>(*layout_image_width)
                              : std::nullopt),
      layout_image_height_(layout_image_height
                               ? std::optional<int64_t>(*layout_image_height)
                               : std::nullopt),
      layout_user_transcoding_list_(
          layout_user_transcoding_list
              ? std::optional<EncodableList>(*layout_user_transcoding_list)
              : std::nullopt) {}

const int64_t* AddOrUpdateLiveStreamTaskRequest::serial() const {
  return serial_ ? &(*serial_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_serial(const int64_t* value_arg) {
  serial_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_serial(int64_t value_arg) {
  serial_ = value_arg;
}

const std::string* AddOrUpdateLiveStreamTaskRequest::task_id() const {
  return task_id_ ? &(*task_id_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_task_id(
    const std::string_view* value_arg) {
  task_id_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_task_id(std::string_view value_arg) {
  task_id_ = value_arg;
}

const std::string* AddOrUpdateLiveStreamTaskRequest::url() const {
  return url_ ? &(*url_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_url(
    const std::string_view* value_arg) {
  url_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_url(std::string_view value_arg) {
  url_ = value_arg;
}

const bool* AddOrUpdateLiveStreamTaskRequest::server_record_enabled() const {
  return server_record_enabled_ ? &(*server_record_enabled_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_server_record_enabled(
    const bool* value_arg) {
  server_record_enabled_ =
      value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_server_record_enabled(
    bool value_arg) {
  server_record_enabled_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::live_mode() const {
  return live_mode_ ? &(*live_mode_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_live_mode(const int64_t* value_arg) {
  live_mode_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_live_mode(int64_t value_arg) {
  live_mode_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_width() const {
  return layout_width_ ? &(*layout_width_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_width(
    const int64_t* value_arg) {
  layout_width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_width(int64_t value_arg) {
  layout_width_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_height() const {
  return layout_height_ ? &(*layout_height_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_height(
    const int64_t* value_arg) {
  layout_height_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_height(int64_t value_arg) {
  layout_height_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_background_color()
    const {
  return layout_background_color_ ? &(*layout_background_color_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_background_color(
    const int64_t* value_arg) {
  layout_background_color_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_background_color(
    int64_t value_arg) {
  layout_background_color_ = value_arg;
}

const std::string* AddOrUpdateLiveStreamTaskRequest::layout_image_url() const {
  return layout_image_url_ ? &(*layout_image_url_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_url(
    const std::string_view* value_arg) {
  layout_image_url_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_url(
    std::string_view value_arg) {
  layout_image_url_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_image_x() const {
  return layout_image_x_ ? &(*layout_image_x_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_x(
    const int64_t* value_arg) {
  layout_image_x_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_x(int64_t value_arg) {
  layout_image_x_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_image_y() const {
  return layout_image_y_ ? &(*layout_image_y_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_y(
    const int64_t* value_arg) {
  layout_image_y_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_y(int64_t value_arg) {
  layout_image_y_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_image_width() const {
  return layout_image_width_ ? &(*layout_image_width_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_width(
    const int64_t* value_arg) {
  layout_image_width_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_width(
    int64_t value_arg) {
  layout_image_width_ = value_arg;
}

const int64_t* AddOrUpdateLiveStreamTaskRequest::layout_image_height() const {
  return layout_image_height_ ? &(*layout_image_height_) : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_height(
    const int64_t* value_arg) {
  layout_image_height_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_image_height(
    int64_t value_arg) {
  layout_image_height_ = value_arg;
}

const EncodableList*
AddOrUpdateLiveStreamTaskRequest::layout_user_transcoding_list() const {
  return layout_user_transcoding_list_ ? &(*layout_user_transcoding_list_)
                                       : nullptr;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_user_transcoding_list(
    const EncodableList* value_arg) {
  layout_user_transcoding_list_ =
      value_arg ? std::optional<EncodableList>(*value_arg) : std::nullopt;
}

void AddOrUpdateLiveStreamTaskRequest::set_layout_user_transcoding_list(
    const EncodableList& value_arg) {
  layout_user_transcoding_list_ = value_arg;
}

EncodableList AddOrUpdateLiveStreamTaskRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(14);
  list.push_back(serial_ ? EncodableValue(*serial_) : EncodableValue());
  list.push_back(task_id_ ? EncodableValue(*task_id_) : EncodableValue());
  list.push_back(url_ ? EncodableValue(*url_) : EncodableValue());
  list.push_back(server_record_enabled_
                     ? EncodableValue(*server_record_enabled_)
                     : EncodableValue());
  list.push_back(live_mode_ ? EncodableValue(*live_mode_) : EncodableValue());
  list.push_back(layout_width_ ? EncodableValue(*layout_width_)
                               : EncodableValue());
  list.push_back(layout_height_ ? EncodableValue(*layout_height_)
                                : EncodableValue());
  list.push_back(layout_background_color_
                     ? EncodableValue(*layout_background_color_)
                     : EncodableValue());
  list.push_back(layout_image_url_ ? EncodableValue(*layout_image_url_)
                                   : EncodableValue());
  list.push_back(layout_image_x_ ? EncodableValue(*layout_image_x_)
                                 : EncodableValue());
  list.push_back(layout_image_y_ ? EncodableValue(*layout_image_y_)
                                 : EncodableValue());
  list.push_back(layout_image_width_ ? EncodableValue(*layout_image_width_)
                                     : EncodableValue());
  list.push_back(layout_image_height_ ? EncodableValue(*layout_image_height_)
                                      : EncodableValue());
  list.push_back(layout_user_transcoding_list_
                     ? EncodableValue(*layout_user_transcoding_list_)
                     : EncodableValue());
  return list;
}

AddOrUpdateLiveStreamTaskRequest
AddOrUpdateLiveStreamTaskRequest::FromEncodableList(const EncodableList& list) {
  AddOrUpdateLiveStreamTaskRequest decoded;
  auto& encodable_serial = list[0];
  if (!encodable_serial.IsNull()) {
    decoded.set_serial(encodable_serial.LongValue());
  }
  auto& encodable_task_id = list[1];
  if (!encodable_task_id.IsNull()) {
    decoded.set_task_id(std::get<std::string>(encodable_task_id));
  }
  auto& encodable_url = list[2];
  if (!encodable_url.IsNull()) {
    decoded.set_url(std::get<std::string>(encodable_url));
  }
  auto& encodable_server_record_enabled = list[3];
  if (!encodable_server_record_enabled.IsNull()) {
    decoded.set_server_record_enabled(
        std::get<bool>(encodable_server_record_enabled));
  }
  auto& encodable_live_mode = list[4];
  if (!encodable_live_mode.IsNull()) {
    decoded.set_live_mode(encodable_live_mode.LongValue());
  }
  auto& encodable_layout_width = list[5];
  if (!encodable_layout_width.IsNull()) {
    decoded.set_layout_width(encodable_layout_width.LongValue());
  }
  auto& encodable_layout_height = list[6];
  if (!encodable_layout_height.IsNull()) {
    decoded.set_layout_height(encodable_layout_height.LongValue());
  }
  auto& encodable_layout_background_color = list[7];
  if (!encodable_layout_background_color.IsNull()) {
    decoded.set_layout_background_color(
        encodable_layout_background_color.LongValue());
  }
  auto& encodable_layout_image_url = list[8];
  if (!encodable_layout_image_url.IsNull()) {
    decoded.set_layout_image_url(
        std::get<std::string>(encodable_layout_image_url));
  }
  auto& encodable_layout_image_x = list[9];
  if (!encodable_layout_image_x.IsNull()) {
    decoded.set_layout_image_x(encodable_layout_image_x.LongValue());
  }
  auto& encodable_layout_image_y = list[10];
  if (!encodable_layout_image_y.IsNull()) {
    decoded.set_layout_image_y(encodable_layout_image_y.LongValue());
  }
  auto& encodable_layout_image_width = list[11];
  if (!encodable_layout_image_width.IsNull()) {
    decoded.set_layout_image_width(encodable_layout_image_width.LongValue());
  }
  auto& encodable_layout_image_height = list[12];
  if (!encodable_layout_image_height.IsNull()) {
    decoded.set_layout_image_height(encodable_layout_image_height.LongValue());
  }
  auto& encodable_layout_user_transcoding_list = list[13];
  if (!encodable_layout_user_transcoding_list.IsNull()) {
    decoded.set_layout_user_transcoding_list(
        std::get<EncodableList>(encodable_layout_user_transcoding_list));
  }
  return decoded;
}

// DeleteLiveStreamTaskRequest

DeleteLiveStreamTaskRequest::DeleteLiveStreamTaskRequest() {}

DeleteLiveStreamTaskRequest::DeleteLiveStreamTaskRequest(
    const int64_t* serial, const std::string* task_id)
    : serial_(serial ? std::optional<int64_t>(*serial) : std::nullopt),
      task_id_(task_id ? std::optional<std::string>(*task_id) : std::nullopt) {}

const int64_t* DeleteLiveStreamTaskRequest::serial() const {
  return serial_ ? &(*serial_) : nullptr;
}

void DeleteLiveStreamTaskRequest::set_serial(const int64_t* value_arg) {
  serial_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void DeleteLiveStreamTaskRequest::set_serial(int64_t value_arg) {
  serial_ = value_arg;
}

const std::string* DeleteLiveStreamTaskRequest::task_id() const {
  return task_id_ ? &(*task_id_) : nullptr;
}

void DeleteLiveStreamTaskRequest::set_task_id(
    const std::string_view* value_arg) {
  task_id_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void DeleteLiveStreamTaskRequest::set_task_id(std::string_view value_arg) {
  task_id_ = value_arg;
}

EncodableList DeleteLiveStreamTaskRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(serial_ ? EncodableValue(*serial_) : EncodableValue());
  list.push_back(task_id_ ? EncodableValue(*task_id_) : EncodableValue());
  return list;
}

DeleteLiveStreamTaskRequest DeleteLiveStreamTaskRequest::FromEncodableList(
    const EncodableList& list) {
  DeleteLiveStreamTaskRequest decoded;
  auto& encodable_serial = list[0];
  if (!encodable_serial.IsNull()) {
    decoded.set_serial(encodable_serial.LongValue());
  }
  auto& encodable_task_id = list[1];
  if (!encodable_task_id.IsNull()) {
    decoded.set_task_id(std::get<std::string>(encodable_task_id));
  }
  return decoded;
}

// SendSEIMsgRequest

SendSEIMsgRequest::SendSEIMsgRequest() {}

SendSEIMsgRequest::SendSEIMsgRequest(const std::string* sei_msg,
                                     const int64_t* stream_type)
    : sei_msg_(sei_msg ? std::optional<std::string>(*sei_msg) : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const std::string* SendSEIMsgRequest::sei_msg() const {
  return sei_msg_ ? &(*sei_msg_) : nullptr;
}

void SendSEIMsgRequest::set_sei_msg(const std::string_view* value_arg) {
  sei_msg_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void SendSEIMsgRequest::set_sei_msg(std::string_view value_arg) {
  sei_msg_ = value_arg;
}

const int64_t* SendSEIMsgRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void SendSEIMsgRequest::set_stream_type(const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SendSEIMsgRequest::set_stream_type(int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList SendSEIMsgRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(sei_msg_ ? EncodableValue(*sei_msg_) : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

SendSEIMsgRequest SendSEIMsgRequest::FromEncodableList(
    const EncodableList& list) {
  SendSEIMsgRequest decoded;
  auto& encodable_sei_msg = list[0];
  if (!encodable_sei_msg.IsNull()) {
    decoded.set_sei_msg(std::get<std::string>(encodable_sei_msg));
  }
  auto& encodable_stream_type = list[1];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// SetLocalVoiceEqualizationRequest

SetLocalVoiceEqualizationRequest::SetLocalVoiceEqualizationRequest() {}

SetLocalVoiceEqualizationRequest::SetLocalVoiceEqualizationRequest(
    const int64_t* band_frequency, const int64_t* band_gain)
    : band_frequency_(band_frequency ? std::optional<int64_t>(*band_frequency)
                                     : std::nullopt),
      band_gain_(band_gain ? std::optional<int64_t>(*band_gain)
                           : std::nullopt) {}

const int64_t* SetLocalVoiceEqualizationRequest::band_frequency() const {
  return band_frequency_ ? &(*band_frequency_) : nullptr;
}

void SetLocalVoiceEqualizationRequest::set_band_frequency(
    const int64_t* value_arg) {
  band_frequency_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVoiceEqualizationRequest::set_band_frequency(int64_t value_arg) {
  band_frequency_ = value_arg;
}

const int64_t* SetLocalVoiceEqualizationRequest::band_gain() const {
  return band_gain_ ? &(*band_gain_) : nullptr;
}

void SetLocalVoiceEqualizationRequest::set_band_gain(const int64_t* value_arg) {
  band_gain_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalVoiceEqualizationRequest::set_band_gain(int64_t value_arg) {
  band_gain_ = value_arg;
}

EncodableList SetLocalVoiceEqualizationRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(band_frequency_ ? EncodableValue(*band_frequency_)
                                 : EncodableValue());
  list.push_back(band_gain_ ? EncodableValue(*band_gain_) : EncodableValue());
  return list;
}

SetLocalVoiceEqualizationRequest
SetLocalVoiceEqualizationRequest::FromEncodableList(const EncodableList& list) {
  SetLocalVoiceEqualizationRequest decoded;
  auto& encodable_band_frequency = list[0];
  if (!encodable_band_frequency.IsNull()) {
    decoded.set_band_frequency(encodable_band_frequency.LongValue());
  }
  auto& encodable_band_gain = list[1];
  if (!encodable_band_gain.IsNull()) {
    decoded.set_band_gain(encodable_band_gain.LongValue());
  }
  return decoded;
}

// SwitchChannelRequest

SwitchChannelRequest::SwitchChannelRequest() {}

SwitchChannelRequest::SwitchChannelRequest(
    const std::string* token, const std::string* channel_name,
    const JoinChannelOptions* channel_options)
    : token_(token ? std::optional<std::string>(*token) : std::nullopt),
      channel_name_(channel_name ? std::optional<std::string>(*channel_name)
                                 : std::nullopt),
      channel_options_(channel_options
                           ? std::optional<JoinChannelOptions>(*channel_options)
                           : std::nullopt) {}

const std::string* SwitchChannelRequest::token() const {
  return token_ ? &(*token_) : nullptr;
}

void SwitchChannelRequest::set_token(const std::string_view* value_arg) {
  token_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void SwitchChannelRequest::set_token(std::string_view value_arg) {
  token_ = value_arg;
}

const std::string* SwitchChannelRequest::channel_name() const {
  return channel_name_ ? &(*channel_name_) : nullptr;
}

void SwitchChannelRequest::set_channel_name(const std::string_view* value_arg) {
  channel_name_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void SwitchChannelRequest::set_channel_name(std::string_view value_arg) {
  channel_name_ = value_arg;
}

const JoinChannelOptions* SwitchChannelRequest::channel_options() const {
  return channel_options_ ? &(*channel_options_) : nullptr;
}

void SwitchChannelRequest::set_channel_options(
    const JoinChannelOptions* value_arg) {
  channel_options_ =
      value_arg ? std::optional<JoinChannelOptions>(*value_arg) : std::nullopt;
}

void SwitchChannelRequest::set_channel_options(
    const JoinChannelOptions& value_arg) {
  channel_options_ = value_arg;
}

EncodableList SwitchChannelRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(token_ ? EncodableValue(*token_) : EncodableValue());
  list.push_back(channel_name_ ? EncodableValue(*channel_name_)
                               : EncodableValue());
  list.push_back(channel_options_
                     ? EncodableValue(channel_options_->ToEncodableList())
                     : EncodableValue());
  return list;
}

SwitchChannelRequest SwitchChannelRequest::FromEncodableList(
    const EncodableList& list) {
  SwitchChannelRequest decoded;
  auto& encodable_token = list[0];
  if (!encodable_token.IsNull()) {
    decoded.set_token(std::get<std::string>(encodable_token));
  }
  auto& encodable_channel_name = list[1];
  if (!encodable_channel_name.IsNull()) {
    decoded.set_channel_name(std::get<std::string>(encodable_channel_name));
  }
  auto& encodable_channel_options = list[2];
  if (!encodable_channel_options.IsNull()) {
    decoded.set_channel_options(JoinChannelOptions::FromEncodableList(
        std::get<EncodableList>(encodable_channel_options)));
  }
  return decoded;
}

// StartAudioRecordingRequest

StartAudioRecordingRequest::StartAudioRecordingRequest() {}

StartAudioRecordingRequest::StartAudioRecordingRequest(
    const std::string* file_path, const int64_t* sample_rate,
    const int64_t* quality)
    : file_path_(file_path ? std::optional<std::string>(*file_path)
                           : std::nullopt),
      sample_rate_(sample_rate ? std::optional<int64_t>(*sample_rate)
                               : std::nullopt),
      quality_(quality ? std::optional<int64_t>(*quality) : std::nullopt) {}

const std::string* StartAudioRecordingRequest::file_path() const {
  return file_path_ ? &(*file_path_) : nullptr;
}

void StartAudioRecordingRequest::set_file_path(
    const std::string_view* value_arg) {
  file_path_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void StartAudioRecordingRequest::set_file_path(std::string_view value_arg) {
  file_path_ = value_arg;
}

const int64_t* StartAudioRecordingRequest::sample_rate() const {
  return sample_rate_ ? &(*sample_rate_) : nullptr;
}

void StartAudioRecordingRequest::set_sample_rate(const int64_t* value_arg) {
  sample_rate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioRecordingRequest::set_sample_rate(int64_t value_arg) {
  sample_rate_ = value_arg;
}

const int64_t* StartAudioRecordingRequest::quality() const {
  return quality_ ? &(*quality_) : nullptr;
}

void StartAudioRecordingRequest::set_quality(const int64_t* value_arg) {
  quality_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartAudioRecordingRequest::set_quality(int64_t value_arg) {
  quality_ = value_arg;
}

EncodableList StartAudioRecordingRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(file_path_ ? EncodableValue(*file_path_) : EncodableValue());
  list.push_back(sample_rate_ ? EncodableValue(*sample_rate_)
                              : EncodableValue());
  list.push_back(quality_ ? EncodableValue(*quality_) : EncodableValue());
  return list;
}

StartAudioRecordingRequest StartAudioRecordingRequest::FromEncodableList(
    const EncodableList& list) {
  StartAudioRecordingRequest decoded;
  auto& encodable_file_path = list[0];
  if (!encodable_file_path.IsNull()) {
    decoded.set_file_path(std::get<std::string>(encodable_file_path));
  }
  auto& encodable_sample_rate = list[1];
  if (!encodable_sample_rate.IsNull()) {
    decoded.set_sample_rate(encodable_sample_rate.LongValue());
  }
  auto& encodable_quality = list[2];
  if (!encodable_quality.IsNull()) {
    decoded.set_quality(encodable_quality.LongValue());
  }
  return decoded;
}

// AudioRecordingConfigurationRequest

AudioRecordingConfigurationRequest::AudioRecordingConfigurationRequest() {}

AudioRecordingConfigurationRequest::AudioRecordingConfigurationRequest(
    const std::string* file_path, const int64_t* sample_rate,
    const int64_t* quality, const int64_t* position, const int64_t* cycle_time)
    : file_path_(file_path ? std::optional<std::string>(*file_path)
                           : std::nullopt),
      sample_rate_(sample_rate ? std::optional<int64_t>(*sample_rate)
                               : std::nullopt),
      quality_(quality ? std::optional<int64_t>(*quality) : std::nullopt),
      position_(position ? std::optional<int64_t>(*position) : std::nullopt),
      cycle_time_(cycle_time ? std::optional<int64_t>(*cycle_time)
                             : std::nullopt) {}

const std::string* AudioRecordingConfigurationRequest::file_path() const {
  return file_path_ ? &(*file_path_) : nullptr;
}

void AudioRecordingConfigurationRequest::set_file_path(
    const std::string_view* value_arg) {
  file_path_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void AudioRecordingConfigurationRequest::set_file_path(
    std::string_view value_arg) {
  file_path_ = value_arg;
}

const int64_t* AudioRecordingConfigurationRequest::sample_rate() const {
  return sample_rate_ ? &(*sample_rate_) : nullptr;
}

void AudioRecordingConfigurationRequest::set_sample_rate(
    const int64_t* value_arg) {
  sample_rate_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AudioRecordingConfigurationRequest::set_sample_rate(int64_t value_arg) {
  sample_rate_ = value_arg;
}

const int64_t* AudioRecordingConfigurationRequest::quality() const {
  return quality_ ? &(*quality_) : nullptr;
}

void AudioRecordingConfigurationRequest::set_quality(const int64_t* value_arg) {
  quality_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AudioRecordingConfigurationRequest::set_quality(int64_t value_arg) {
  quality_ = value_arg;
}

const int64_t* AudioRecordingConfigurationRequest::position() const {
  return position_ ? &(*position_) : nullptr;
}

void AudioRecordingConfigurationRequest::set_position(
    const int64_t* value_arg) {
  position_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AudioRecordingConfigurationRequest::set_position(int64_t value_arg) {
  position_ = value_arg;
}

const int64_t* AudioRecordingConfigurationRequest::cycle_time() const {
  return cycle_time_ ? &(*cycle_time_) : nullptr;
}

void AudioRecordingConfigurationRequest::set_cycle_time(
    const int64_t* value_arg) {
  cycle_time_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AudioRecordingConfigurationRequest::set_cycle_time(int64_t value_arg) {
  cycle_time_ = value_arg;
}

EncodableList AudioRecordingConfigurationRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(5);
  list.push_back(file_path_ ? EncodableValue(*file_path_) : EncodableValue());
  list.push_back(sample_rate_ ? EncodableValue(*sample_rate_)
                              : EncodableValue());
  list.push_back(quality_ ? EncodableValue(*quality_) : EncodableValue());
  list.push_back(position_ ? EncodableValue(*position_) : EncodableValue());
  list.push_back(cycle_time_ ? EncodableValue(*cycle_time_) : EncodableValue());
  return list;
}

AudioRecordingConfigurationRequest
AudioRecordingConfigurationRequest::FromEncodableList(
    const EncodableList& list) {
  AudioRecordingConfigurationRequest decoded;
  auto& encodable_file_path = list[0];
  if (!encodable_file_path.IsNull()) {
    decoded.set_file_path(std::get<std::string>(encodable_file_path));
  }
  auto& encodable_sample_rate = list[1];
  if (!encodable_sample_rate.IsNull()) {
    decoded.set_sample_rate(encodable_sample_rate.LongValue());
  }
  auto& encodable_quality = list[2];
  if (!encodable_quality.IsNull()) {
    decoded.set_quality(encodable_quality.LongValue());
  }
  auto& encodable_position = list[3];
  if (!encodable_position.IsNull()) {
    decoded.set_position(encodable_position.LongValue());
  }
  auto& encodable_cycle_time = list[4];
  if (!encodable_cycle_time.IsNull()) {
    decoded.set_cycle_time(encodable_cycle_time.LongValue());
  }
  return decoded;
}

// SetLocalMediaPriorityRequest

SetLocalMediaPriorityRequest::SetLocalMediaPriorityRequest() {}

SetLocalMediaPriorityRequest::SetLocalMediaPriorityRequest(
    const int64_t* priority, const bool* is_preemptive)
    : priority_(priority ? std::optional<int64_t>(*priority) : std::nullopt),
      is_preemptive_(is_preemptive ? std::optional<bool>(*is_preemptive)
                                   : std::nullopt) {}

const int64_t* SetLocalMediaPriorityRequest::priority() const {
  return priority_ ? &(*priority_) : nullptr;
}

void SetLocalMediaPriorityRequest::set_priority(const int64_t* value_arg) {
  priority_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetLocalMediaPriorityRequest::set_priority(int64_t value_arg) {
  priority_ = value_arg;
}

const bool* SetLocalMediaPriorityRequest::is_preemptive() const {
  return is_preemptive_ ? &(*is_preemptive_) : nullptr;
}

void SetLocalMediaPriorityRequest::set_is_preemptive(const bool* value_arg) {
  is_preemptive_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SetLocalMediaPriorityRequest::set_is_preemptive(bool value_arg) {
  is_preemptive_ = value_arg;
}

EncodableList SetLocalMediaPriorityRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(priority_ ? EncodableValue(*priority_) : EncodableValue());
  list.push_back(is_preemptive_ ? EncodableValue(*is_preemptive_)
                                : EncodableValue());
  return list;
}

SetLocalMediaPriorityRequest SetLocalMediaPriorityRequest::FromEncodableList(
    const EncodableList& list) {
  SetLocalMediaPriorityRequest decoded;
  auto& encodable_priority = list[0];
  if (!encodable_priority.IsNull()) {
    decoded.set_priority(encodable_priority.LongValue());
  }
  auto& encodable_is_preemptive = list[1];
  if (!encodable_is_preemptive.IsNull()) {
    decoded.set_is_preemptive(std::get<bool>(encodable_is_preemptive));
  }
  return decoded;
}

// StartOrUpdateChannelMediaRelayRequest

StartOrUpdateChannelMediaRelayRequest::StartOrUpdateChannelMediaRelayRequest() {
}

StartOrUpdateChannelMediaRelayRequest::StartOrUpdateChannelMediaRelayRequest(
    const EncodableMap* source_media_info, const EncodableMap* dest_media_info)
    : source_media_info_(source_media_info
                             ? std::optional<EncodableMap>(*source_media_info)
                             : std::nullopt),
      dest_media_info_(dest_media_info
                           ? std::optional<EncodableMap>(*dest_media_info)
                           : std::nullopt) {}

const EncodableMap* StartOrUpdateChannelMediaRelayRequest::source_media_info()
    const {
  return source_media_info_ ? &(*source_media_info_) : nullptr;
}

void StartOrUpdateChannelMediaRelayRequest::set_source_media_info(
    const EncodableMap* value_arg) {
  source_media_info_ =
      value_arg ? std::optional<EncodableMap>(*value_arg) : std::nullopt;
}

void StartOrUpdateChannelMediaRelayRequest::set_source_media_info(
    const EncodableMap& value_arg) {
  source_media_info_ = value_arg;
}

const EncodableMap* StartOrUpdateChannelMediaRelayRequest::dest_media_info()
    const {
  return dest_media_info_ ? &(*dest_media_info_) : nullptr;
}

void StartOrUpdateChannelMediaRelayRequest::set_dest_media_info(
    const EncodableMap* value_arg) {
  dest_media_info_ =
      value_arg ? std::optional<EncodableMap>(*value_arg) : std::nullopt;
}

void StartOrUpdateChannelMediaRelayRequest::set_dest_media_info(
    const EncodableMap& value_arg) {
  dest_media_info_ = value_arg;
}

EncodableList StartOrUpdateChannelMediaRelayRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(source_media_info_ ? EncodableValue(*source_media_info_)
                                    : EncodableValue());
  list.push_back(dest_media_info_ ? EncodableValue(*dest_media_info_)
                                  : EncodableValue());
  return list;
}

StartOrUpdateChannelMediaRelayRequest
StartOrUpdateChannelMediaRelayRequest::FromEncodableList(
    const EncodableList& list) {
  StartOrUpdateChannelMediaRelayRequest decoded;
  auto& encodable_source_media_info = list[0];
  if (!encodable_source_media_info.IsNull()) {
    decoded.set_source_media_info(
        std::get<EncodableMap>(encodable_source_media_info));
  }
  auto& encodable_dest_media_info = list[1];
  if (!encodable_dest_media_info.IsNull()) {
    decoded.set_dest_media_info(
        std::get<EncodableMap>(encodable_dest_media_info));
  }
  return decoded;
}

// AdjustUserPlaybackSignalVolumeRequest

AdjustUserPlaybackSignalVolumeRequest::AdjustUserPlaybackSignalVolumeRequest() {
}

AdjustUserPlaybackSignalVolumeRequest::AdjustUserPlaybackSignalVolumeRequest(
    const int64_t* uid, const int64_t* volume)
    : uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt),
      volume_(volume ? std::optional<int64_t>(*volume) : std::nullopt) {}

const int64_t* AdjustUserPlaybackSignalVolumeRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void AdjustUserPlaybackSignalVolumeRequest::set_uid(const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AdjustUserPlaybackSignalVolumeRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const int64_t* AdjustUserPlaybackSignalVolumeRequest::volume() const {
  return volume_ ? &(*volume_) : nullptr;
}

void AdjustUserPlaybackSignalVolumeRequest::set_volume(
    const int64_t* value_arg) {
  volume_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void AdjustUserPlaybackSignalVolumeRequest::set_volume(int64_t value_arg) {
  volume_ = value_arg;
}

EncodableList AdjustUserPlaybackSignalVolumeRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  list.push_back(volume_ ? EncodableValue(*volume_) : EncodableValue());
  return list;
}

AdjustUserPlaybackSignalVolumeRequest
AdjustUserPlaybackSignalVolumeRequest::FromEncodableList(
    const EncodableList& list) {
  AdjustUserPlaybackSignalVolumeRequest decoded;
  auto& encodable_uid = list[0];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  auto& encodable_volume = list[1];
  if (!encodable_volume.IsNull()) {
    decoded.set_volume(encodable_volume.LongValue());
  }
  return decoded;
}

// EnableEncryptionRequest

EnableEncryptionRequest::EnableEncryptionRequest() {}

EnableEncryptionRequest::EnableEncryptionRequest(const std::string* key,
                                                 const int64_t* mode,
                                                 const bool* enable)
    : key_(key ? std::optional<std::string>(*key) : std::nullopt),
      mode_(mode ? std::optional<int64_t>(*mode) : std::nullopt),
      enable_(enable ? std::optional<bool>(*enable) : std::nullopt) {}

const std::string* EnableEncryptionRequest::key() const {
  return key_ ? &(*key_) : nullptr;
}

void EnableEncryptionRequest::set_key(const std::string_view* value_arg) {
  key_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void EnableEncryptionRequest::set_key(std::string_view value_arg) {
  key_ = value_arg;
}

const int64_t* EnableEncryptionRequest::mode() const {
  return mode_ ? &(*mode_) : nullptr;
}

void EnableEncryptionRequest::set_mode(const int64_t* value_arg) {
  mode_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableEncryptionRequest::set_mode(int64_t value_arg) { mode_ = value_arg; }

const bool* EnableEncryptionRequest::enable() const {
  return enable_ ? &(*enable_) : nullptr;
}

void EnableEncryptionRequest::set_enable(const bool* value_arg) {
  enable_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void EnableEncryptionRequest::set_enable(bool value_arg) {
  enable_ = value_arg;
}

EncodableList EnableEncryptionRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(key_ ? EncodableValue(*key_) : EncodableValue());
  list.push_back(mode_ ? EncodableValue(*mode_) : EncodableValue());
  list.push_back(enable_ ? EncodableValue(*enable_) : EncodableValue());
  return list;
}

EnableEncryptionRequest EnableEncryptionRequest::FromEncodableList(
    const EncodableList& list) {
  EnableEncryptionRequest decoded;
  auto& encodable_key = list[0];
  if (!encodable_key.IsNull()) {
    decoded.set_key(std::get<std::string>(encodable_key));
  }
  auto& encodable_mode = list[1];
  if (!encodable_mode.IsNull()) {
    decoded.set_mode(encodable_mode.LongValue());
  }
  auto& encodable_enable = list[2];
  if (!encodable_enable.IsNull()) {
    decoded.set_enable(std::get<bool>(encodable_enable));
  }
  return decoded;
}

// SetLocalVoiceReverbParamRequest

SetLocalVoiceReverbParamRequest::SetLocalVoiceReverbParamRequest() {}

SetLocalVoiceReverbParamRequest::SetLocalVoiceReverbParamRequest(
    const double* wet_gain, const double* dry_gain, const double* damping,
    const double* room_size, const double* decay_time, const double* pre_delay)
    : wet_gain_(wet_gain ? std::optional<double>(*wet_gain) : std::nullopt),
      dry_gain_(dry_gain ? std::optional<double>(*dry_gain) : std::nullopt),
      damping_(damping ? std::optional<double>(*damping) : std::nullopt),
      room_size_(room_size ? std::optional<double>(*room_size) : std::nullopt),
      decay_time_(decay_time ? std::optional<double>(*decay_time)
                             : std::nullopt),
      pre_delay_(pre_delay ? std::optional<double>(*pre_delay) : std::nullopt) {
}

const double* SetLocalVoiceReverbParamRequest::wet_gain() const {
  return wet_gain_ ? &(*wet_gain_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_wet_gain(const double* value_arg) {
  wet_gain_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_wet_gain(double value_arg) {
  wet_gain_ = value_arg;
}

const double* SetLocalVoiceReverbParamRequest::dry_gain() const {
  return dry_gain_ ? &(*dry_gain_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_dry_gain(const double* value_arg) {
  dry_gain_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_dry_gain(double value_arg) {
  dry_gain_ = value_arg;
}

const double* SetLocalVoiceReverbParamRequest::damping() const {
  return damping_ ? &(*damping_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_damping(const double* value_arg) {
  damping_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_damping(double value_arg) {
  damping_ = value_arg;
}

const double* SetLocalVoiceReverbParamRequest::room_size() const {
  return room_size_ ? &(*room_size_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_room_size(const double* value_arg) {
  room_size_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_room_size(double value_arg) {
  room_size_ = value_arg;
}

const double* SetLocalVoiceReverbParamRequest::decay_time() const {
  return decay_time_ ? &(*decay_time_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_decay_time(const double* value_arg) {
  decay_time_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_decay_time(double value_arg) {
  decay_time_ = value_arg;
}

const double* SetLocalVoiceReverbParamRequest::pre_delay() const {
  return pre_delay_ ? &(*pre_delay_) : nullptr;
}

void SetLocalVoiceReverbParamRequest::set_pre_delay(const double* value_arg) {
  pre_delay_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetLocalVoiceReverbParamRequest::set_pre_delay(double value_arg) {
  pre_delay_ = value_arg;
}

EncodableList SetLocalVoiceReverbParamRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(6);
  list.push_back(wet_gain_ ? EncodableValue(*wet_gain_) : EncodableValue());
  list.push_back(dry_gain_ ? EncodableValue(*dry_gain_) : EncodableValue());
  list.push_back(damping_ ? EncodableValue(*damping_) : EncodableValue());
  list.push_back(room_size_ ? EncodableValue(*room_size_) : EncodableValue());
  list.push_back(decay_time_ ? EncodableValue(*decay_time_) : EncodableValue());
  list.push_back(pre_delay_ ? EncodableValue(*pre_delay_) : EncodableValue());
  return list;
}

SetLocalVoiceReverbParamRequest
SetLocalVoiceReverbParamRequest::FromEncodableList(const EncodableList& list) {
  SetLocalVoiceReverbParamRequest decoded;
  auto& encodable_wet_gain = list[0];
  if (!encodable_wet_gain.IsNull()) {
    decoded.set_wet_gain(std::get<double>(encodable_wet_gain));
  }
  auto& encodable_dry_gain = list[1];
  if (!encodable_dry_gain.IsNull()) {
    decoded.set_dry_gain(std::get<double>(encodable_dry_gain));
  }
  auto& encodable_damping = list[2];
  if (!encodable_damping.IsNull()) {
    decoded.set_damping(std::get<double>(encodable_damping));
  }
  auto& encodable_room_size = list[3];
  if (!encodable_room_size.IsNull()) {
    decoded.set_room_size(std::get<double>(encodable_room_size));
  }
  auto& encodable_decay_time = list[4];
  if (!encodable_decay_time.IsNull()) {
    decoded.set_decay_time(std::get<double>(encodable_decay_time));
  }
  auto& encodable_pre_delay = list[5];
  if (!encodable_pre_delay.IsNull()) {
    decoded.set_pre_delay(std::get<double>(encodable_pre_delay));
  }
  return decoded;
}

// ReportCustomEventRequest

ReportCustomEventRequest::ReportCustomEventRequest() {}

ReportCustomEventRequest::ReportCustomEventRequest(
    const std::string* event_name, const std::string* custom_identify,
    const EncodableMap* param)
    : event_name_(event_name ? std::optional<std::string>(*event_name)
                             : std::nullopt),
      custom_identify_(custom_identify
                           ? std::optional<std::string>(*custom_identify)
                           : std::nullopt),
      param_(param ? std::optional<EncodableMap>(*param) : std::nullopt) {}

const std::string* ReportCustomEventRequest::event_name() const {
  return event_name_ ? &(*event_name_) : nullptr;
}

void ReportCustomEventRequest::set_event_name(
    const std::string_view* value_arg) {
  event_name_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void ReportCustomEventRequest::set_event_name(std::string_view value_arg) {
  event_name_ = value_arg;
}

const std::string* ReportCustomEventRequest::custom_identify() const {
  return custom_identify_ ? &(*custom_identify_) : nullptr;
}

void ReportCustomEventRequest::set_custom_identify(
    const std::string_view* value_arg) {
  custom_identify_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void ReportCustomEventRequest::set_custom_identify(std::string_view value_arg) {
  custom_identify_ = value_arg;
}

const EncodableMap* ReportCustomEventRequest::param() const {
  return param_ ? &(*param_) : nullptr;
}

void ReportCustomEventRequest::set_param(const EncodableMap* value_arg) {
  param_ = value_arg ? std::optional<EncodableMap>(*value_arg) : std::nullopt;
}

void ReportCustomEventRequest::set_param(const EncodableMap& value_arg) {
  param_ = value_arg;
}

EncodableList ReportCustomEventRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(event_name_ ? EncodableValue(*event_name_) : EncodableValue());
  list.push_back(custom_identify_ ? EncodableValue(*custom_identify_)
                                  : EncodableValue());
  list.push_back(param_ ? EncodableValue(*param_) : EncodableValue());
  return list;
}

ReportCustomEventRequest ReportCustomEventRequest::FromEncodableList(
    const EncodableList& list) {
  ReportCustomEventRequest decoded;
  auto& encodable_event_name = list[0];
  if (!encodable_event_name.IsNull()) {
    decoded.set_event_name(std::get<std::string>(encodable_event_name));
  }
  auto& encodable_custom_identify = list[1];
  if (!encodable_custom_identify.IsNull()) {
    decoded.set_custom_identify(
        std::get<std::string>(encodable_custom_identify));
  }
  auto& encodable_param = list[2];
  if (!encodable_param.IsNull()) {
    decoded.set_param(std::get<EncodableMap>(encodable_param));
  }
  return decoded;
}

// StartLastmileProbeTestRequest

StartLastmileProbeTestRequest::StartLastmileProbeTestRequest() {}

StartLastmileProbeTestRequest::StartLastmileProbeTestRequest(
    const bool* probe_uplink, const bool* probe_downlink,
    const int64_t* expected_uplink_bitrate,
    const int64_t* expected_downlink_bitrate)
    : probe_uplink_(probe_uplink ? std::optional<bool>(*probe_uplink)
                                 : std::nullopt),
      probe_downlink_(probe_downlink ? std::optional<bool>(*probe_downlink)
                                     : std::nullopt),
      expected_uplink_bitrate_(
          expected_uplink_bitrate
              ? std::optional<int64_t>(*expected_uplink_bitrate)
              : std::nullopt),
      expected_downlink_bitrate_(
          expected_downlink_bitrate
              ? std::optional<int64_t>(*expected_downlink_bitrate)
              : std::nullopt) {}

const bool* StartLastmileProbeTestRequest::probe_uplink() const {
  return probe_uplink_ ? &(*probe_uplink_) : nullptr;
}

void StartLastmileProbeTestRequest::set_probe_uplink(const bool* value_arg) {
  probe_uplink_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void StartLastmileProbeTestRequest::set_probe_uplink(bool value_arg) {
  probe_uplink_ = value_arg;
}

const bool* StartLastmileProbeTestRequest::probe_downlink() const {
  return probe_downlink_ ? &(*probe_downlink_) : nullptr;
}

void StartLastmileProbeTestRequest::set_probe_downlink(const bool* value_arg) {
  probe_downlink_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void StartLastmileProbeTestRequest::set_probe_downlink(bool value_arg) {
  probe_downlink_ = value_arg;
}

const int64_t* StartLastmileProbeTestRequest::expected_uplink_bitrate() const {
  return expected_uplink_bitrate_ ? &(*expected_uplink_bitrate_) : nullptr;
}

void StartLastmileProbeTestRequest::set_expected_uplink_bitrate(
    const int64_t* value_arg) {
  expected_uplink_bitrate_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartLastmileProbeTestRequest::set_expected_uplink_bitrate(
    int64_t value_arg) {
  expected_uplink_bitrate_ = value_arg;
}

const int64_t* StartLastmileProbeTestRequest::expected_downlink_bitrate()
    const {
  return expected_downlink_bitrate_ ? &(*expected_downlink_bitrate_) : nullptr;
}

void StartLastmileProbeTestRequest::set_expected_downlink_bitrate(
    const int64_t* value_arg) {
  expected_downlink_bitrate_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void StartLastmileProbeTestRequest::set_expected_downlink_bitrate(
    int64_t value_arg) {
  expected_downlink_bitrate_ = value_arg;
}

EncodableList StartLastmileProbeTestRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(probe_uplink_ ? EncodableValue(*probe_uplink_)
                               : EncodableValue());
  list.push_back(probe_downlink_ ? EncodableValue(*probe_downlink_)
                                 : EncodableValue());
  list.push_back(expected_uplink_bitrate_
                     ? EncodableValue(*expected_uplink_bitrate_)
                     : EncodableValue());
  list.push_back(expected_downlink_bitrate_
                     ? EncodableValue(*expected_downlink_bitrate_)
                     : EncodableValue());
  return list;
}

StartLastmileProbeTestRequest StartLastmileProbeTestRequest::FromEncodableList(
    const EncodableList& list) {
  StartLastmileProbeTestRequest decoded;
  auto& encodable_probe_uplink = list[0];
  if (!encodable_probe_uplink.IsNull()) {
    decoded.set_probe_uplink(std::get<bool>(encodable_probe_uplink));
  }
  auto& encodable_probe_downlink = list[1];
  if (!encodable_probe_downlink.IsNull()) {
    decoded.set_probe_downlink(std::get<bool>(encodable_probe_downlink));
  }
  auto& encodable_expected_uplink_bitrate = list[2];
  if (!encodable_expected_uplink_bitrate.IsNull()) {
    decoded.set_expected_uplink_bitrate(
        encodable_expected_uplink_bitrate.LongValue());
  }
  auto& encodable_expected_downlink_bitrate = list[3];
  if (!encodable_expected_downlink_bitrate.IsNull()) {
    decoded.set_expected_downlink_bitrate(
        encodable_expected_downlink_bitrate.LongValue());
  }
  return decoded;
}

// CGPoint

CGPoint::CGPoint(double x, double y) : x_(x), y_(y) {}

double CGPoint::x() const { return x_; }

void CGPoint::set_x(double value_arg) { x_ = value_arg; }

double CGPoint::y() const { return y_; }

void CGPoint::set_y(double value_arg) { y_ = value_arg; }

EncodableList CGPoint::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(EncodableValue(x_));
  list.push_back(EncodableValue(y_));
  return list;
}

CGPoint CGPoint::FromEncodableList(const EncodableList& list) {
  CGPoint decoded(std::get<double>(list[0]), std::get<double>(list[1]));
  return decoded;
}

// SetVideoCorrectionConfigRequest

SetVideoCorrectionConfigRequest::SetVideoCorrectionConfigRequest() {}

SetVideoCorrectionConfigRequest::SetVideoCorrectionConfigRequest(
    const CGPoint* top_left, const CGPoint* top_right,
    const CGPoint* bottom_left, const CGPoint* bottom_right,
    const double* canvas_width, const double* canvas_height,
    const bool* enable_mirror)
    : top_left_(top_left ? std::optional<CGPoint>(*top_left) : std::nullopt),
      top_right_(top_right ? std::optional<CGPoint>(*top_right) : std::nullopt),
      bottom_left_(bottom_left ? std::optional<CGPoint>(*bottom_left)
                               : std::nullopt),
      bottom_right_(bottom_right ? std::optional<CGPoint>(*bottom_right)
                                 : std::nullopt),
      canvas_width_(canvas_width ? std::optional<double>(*canvas_width)
                                 : std::nullopt),
      canvas_height_(canvas_height ? std::optional<double>(*canvas_height)
                                   : std::nullopt),
      enable_mirror_(enable_mirror ? std::optional<bool>(*enable_mirror)
                                   : std::nullopt) {}

const CGPoint* SetVideoCorrectionConfigRequest::top_left() const {
  return top_left_ ? &(*top_left_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_top_left(const CGPoint* value_arg) {
  top_left_ = value_arg ? std::optional<CGPoint>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_top_left(const CGPoint& value_arg) {
  top_left_ = value_arg;
}

const CGPoint* SetVideoCorrectionConfigRequest::top_right() const {
  return top_right_ ? &(*top_right_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_top_right(const CGPoint* value_arg) {
  top_right_ = value_arg ? std::optional<CGPoint>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_top_right(const CGPoint& value_arg) {
  top_right_ = value_arg;
}

const CGPoint* SetVideoCorrectionConfigRequest::bottom_left() const {
  return bottom_left_ ? &(*bottom_left_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_bottom_left(
    const CGPoint* value_arg) {
  bottom_left_ = value_arg ? std::optional<CGPoint>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_bottom_left(
    const CGPoint& value_arg) {
  bottom_left_ = value_arg;
}

const CGPoint* SetVideoCorrectionConfigRequest::bottom_right() const {
  return bottom_right_ ? &(*bottom_right_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_bottom_right(
    const CGPoint* value_arg) {
  bottom_right_ = value_arg ? std::optional<CGPoint>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_bottom_right(
    const CGPoint& value_arg) {
  bottom_right_ = value_arg;
}

const double* SetVideoCorrectionConfigRequest::canvas_width() const {
  return canvas_width_ ? &(*canvas_width_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_canvas_width(
    const double* value_arg) {
  canvas_width_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_canvas_width(double value_arg) {
  canvas_width_ = value_arg;
}

const double* SetVideoCorrectionConfigRequest::canvas_height() const {
  return canvas_height_ ? &(*canvas_height_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_canvas_height(
    const double* value_arg) {
  canvas_height_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_canvas_height(double value_arg) {
  canvas_height_ = value_arg;
}

const bool* SetVideoCorrectionConfigRequest::enable_mirror() const {
  return enable_mirror_ ? &(*enable_mirror_) : nullptr;
}

void SetVideoCorrectionConfigRequest::set_enable_mirror(const bool* value_arg) {
  enable_mirror_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SetVideoCorrectionConfigRequest::set_enable_mirror(bool value_arg) {
  enable_mirror_ = value_arg;
}

EncodableList SetVideoCorrectionConfigRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(7);
  list.push_back(top_left_ ? EncodableValue(top_left_->ToEncodableList())
                           : EncodableValue());
  list.push_back(top_right_ ? EncodableValue(top_right_->ToEncodableList())
                            : EncodableValue());
  list.push_back(bottom_left_ ? EncodableValue(bottom_left_->ToEncodableList())
                              : EncodableValue());
  list.push_back(bottom_right_
                     ? EncodableValue(bottom_right_->ToEncodableList())
                     : EncodableValue());
  list.push_back(canvas_width_ ? EncodableValue(*canvas_width_)
                               : EncodableValue());
  list.push_back(canvas_height_ ? EncodableValue(*canvas_height_)
                                : EncodableValue());
  list.push_back(enable_mirror_ ? EncodableValue(*enable_mirror_)
                                : EncodableValue());
  return list;
}

SetVideoCorrectionConfigRequest
SetVideoCorrectionConfigRequest::FromEncodableList(const EncodableList& list) {
  SetVideoCorrectionConfigRequest decoded;
  auto& encodable_top_left = list[0];
  if (!encodable_top_left.IsNull()) {
    decoded.set_top_left(CGPoint::FromEncodableList(
        std::get<EncodableList>(encodable_top_left)));
  }
  auto& encodable_top_right = list[1];
  if (!encodable_top_right.IsNull()) {
    decoded.set_top_right(CGPoint::FromEncodableList(
        std::get<EncodableList>(encodable_top_right)));
  }
  auto& encodable_bottom_left = list[2];
  if (!encodable_bottom_left.IsNull()) {
    decoded.set_bottom_left(CGPoint::FromEncodableList(
        std::get<EncodableList>(encodable_bottom_left)));
  }
  auto& encodable_bottom_right = list[3];
  if (!encodable_bottom_right.IsNull()) {
    decoded.set_bottom_right(CGPoint::FromEncodableList(
        std::get<EncodableList>(encodable_bottom_right)));
  }
  auto& encodable_canvas_width = list[4];
  if (!encodable_canvas_width.IsNull()) {
    decoded.set_canvas_width(std::get<double>(encodable_canvas_width));
  }
  auto& encodable_canvas_height = list[5];
  if (!encodable_canvas_height.IsNull()) {
    decoded.set_canvas_height(std::get<double>(encodable_canvas_height));
  }
  auto& encodable_enable_mirror = list[6];
  if (!encodable_enable_mirror.IsNull()) {
    decoded.set_enable_mirror(std::get<bool>(encodable_enable_mirror));
  }
  return decoded;
}

// EnableVirtualBackgroundRequest

EnableVirtualBackgroundRequest::EnableVirtualBackgroundRequest() {}

EnableVirtualBackgroundRequest::EnableVirtualBackgroundRequest(
    const bool* enabled, const int64_t* background_source_type,
    const int64_t* color, const std::string* source, const int64_t* blur_degree)
    : enabled_(enabled ? std::optional<bool>(*enabled) : std::nullopt),
      background_source_type_(
          background_source_type
              ? std::optional<int64_t>(*background_source_type)
              : std::nullopt),
      color_(color ? std::optional<int64_t>(*color) : std::nullopt),
      source_(source ? std::optional<std::string>(*source) : std::nullopt),
      blur_degree_(blur_degree ? std::optional<int64_t>(*blur_degree)
                               : std::nullopt) {}

const bool* EnableVirtualBackgroundRequest::enabled() const {
  return enabled_ ? &(*enabled_) : nullptr;
}

void EnableVirtualBackgroundRequest::set_enabled(const bool* value_arg) {
  enabled_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void EnableVirtualBackgroundRequest::set_enabled(bool value_arg) {
  enabled_ = value_arg;
}

const int64_t* EnableVirtualBackgroundRequest::background_source_type() const {
  return background_source_type_ ? &(*background_source_type_) : nullptr;
}

void EnableVirtualBackgroundRequest::set_background_source_type(
    const int64_t* value_arg) {
  background_source_type_ =
      value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableVirtualBackgroundRequest::set_background_source_type(
    int64_t value_arg) {
  background_source_type_ = value_arg;
}

const int64_t* EnableVirtualBackgroundRequest::color() const {
  return color_ ? &(*color_) : nullptr;
}

void EnableVirtualBackgroundRequest::set_color(const int64_t* value_arg) {
  color_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableVirtualBackgroundRequest::set_color(int64_t value_arg) {
  color_ = value_arg;
}

const std::string* EnableVirtualBackgroundRequest::source() const {
  return source_ ? &(*source_) : nullptr;
}

void EnableVirtualBackgroundRequest::set_source(
    const std::string_view* value_arg) {
  source_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void EnableVirtualBackgroundRequest::set_source(std::string_view value_arg) {
  source_ = value_arg;
}

const int64_t* EnableVirtualBackgroundRequest::blur_degree() const {
  return blur_degree_ ? &(*blur_degree_) : nullptr;
}

void EnableVirtualBackgroundRequest::set_blur_degree(const int64_t* value_arg) {
  blur_degree_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void EnableVirtualBackgroundRequest::set_blur_degree(int64_t value_arg) {
  blur_degree_ = value_arg;
}

EncodableList EnableVirtualBackgroundRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(5);
  list.push_back(enabled_ ? EncodableValue(*enabled_) : EncodableValue());
  list.push_back(background_source_type_
                     ? EncodableValue(*background_source_type_)
                     : EncodableValue());
  list.push_back(color_ ? EncodableValue(*color_) : EncodableValue());
  list.push_back(source_ ? EncodableValue(*source_) : EncodableValue());
  list.push_back(blur_degree_ ? EncodableValue(*blur_degree_)
                              : EncodableValue());
  return list;
}

EnableVirtualBackgroundRequest
EnableVirtualBackgroundRequest::FromEncodableList(const EncodableList& list) {
  EnableVirtualBackgroundRequest decoded;
  auto& encodable_enabled = list[0];
  if (!encodable_enabled.IsNull()) {
    decoded.set_enabled(std::get<bool>(encodable_enabled));
  }
  auto& encodable_background_source_type = list[1];
  if (!encodable_background_source_type.IsNull()) {
    decoded.set_background_source_type(
        encodable_background_source_type.LongValue());
  }
  auto& encodable_color = list[2];
  if (!encodable_color.IsNull()) {
    decoded.set_color(encodable_color.LongValue());
  }
  auto& encodable_source = list[3];
  if (!encodable_source.IsNull()) {
    decoded.set_source(std::get<std::string>(encodable_source));
  }
  auto& encodable_blur_degree = list[4];
  if (!encodable_blur_degree.IsNull()) {
    decoded.set_blur_degree(encodable_blur_degree.LongValue());
  }
  return decoded;
}

// SetRemoteHighPriorityAudioStreamRequest

SetRemoteHighPriorityAudioStreamRequest::
    SetRemoteHighPriorityAudioStreamRequest() {}

SetRemoteHighPriorityAudioStreamRequest::
    SetRemoteHighPriorityAudioStreamRequest(const bool* enabled,
                                            const int64_t* uid,
                                            const int64_t* stream_type)
    : enabled_(enabled ? std::optional<bool>(*enabled) : std::nullopt),
      uid_(uid ? std::optional<int64_t>(*uid) : std::nullopt),
      stream_type_(stream_type ? std::optional<int64_t>(*stream_type)
                               : std::nullopt) {}

const bool* SetRemoteHighPriorityAudioStreamRequest::enabled() const {
  return enabled_ ? &(*enabled_) : nullptr;
}

void SetRemoteHighPriorityAudioStreamRequest::set_enabled(
    const bool* value_arg) {
  enabled_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void SetRemoteHighPriorityAudioStreamRequest::set_enabled(bool value_arg) {
  enabled_ = value_arg;
}

const int64_t* SetRemoteHighPriorityAudioStreamRequest::uid() const {
  return uid_ ? &(*uid_) : nullptr;
}

void SetRemoteHighPriorityAudioStreamRequest::set_uid(
    const int64_t* value_arg) {
  uid_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetRemoteHighPriorityAudioStreamRequest::set_uid(int64_t value_arg) {
  uid_ = value_arg;
}

const int64_t* SetRemoteHighPriorityAudioStreamRequest::stream_type() const {
  return stream_type_ ? &(*stream_type_) : nullptr;
}

void SetRemoteHighPriorityAudioStreamRequest::set_stream_type(
    const int64_t* value_arg) {
  stream_type_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void SetRemoteHighPriorityAudioStreamRequest::set_stream_type(
    int64_t value_arg) {
  stream_type_ = value_arg;
}

EncodableList SetRemoteHighPriorityAudioStreamRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(3);
  list.push_back(enabled_ ? EncodableValue(*enabled_) : EncodableValue());
  list.push_back(uid_ ? EncodableValue(*uid_) : EncodableValue());
  list.push_back(stream_type_ ? EncodableValue(*stream_type_)
                              : EncodableValue());
  return list;
}

SetRemoteHighPriorityAudioStreamRequest
SetRemoteHighPriorityAudioStreamRequest::FromEncodableList(
    const EncodableList& list) {
  SetRemoteHighPriorityAudioStreamRequest decoded;
  auto& encodable_enabled = list[0];
  if (!encodable_enabled.IsNull()) {
    decoded.set_enabled(std::get<bool>(encodable_enabled));
  }
  auto& encodable_uid = list[1];
  if (!encodable_uid.IsNull()) {
    decoded.set_uid(encodable_uid.LongValue());
  }
  auto& encodable_stream_type = list[2];
  if (!encodable_stream_type.IsNull()) {
    decoded.set_stream_type(encodable_stream_type.LongValue());
  }
  return decoded;
}

// VideoWatermarkImageConfig

VideoWatermarkImageConfig::VideoWatermarkImageConfig() {}

VideoWatermarkImageConfig::VideoWatermarkImageConfig(
    const double* wm_alpha, const int64_t* wm_width, const int64_t* wm_height,
    const int64_t* offset_x, const int64_t* offset_y,
    const EncodableList* image_paths, const int64_t* fps, const bool* loop)
    : wm_alpha_(wm_alpha ? std::optional<double>(*wm_alpha) : std::nullopt),
      wm_width_(wm_width ? std::optional<int64_t>(*wm_width) : std::nullopt),
      wm_height_(wm_height ? std::optional<int64_t>(*wm_height) : std::nullopt),
      offset_x_(offset_x ? std::optional<int64_t>(*offset_x) : std::nullopt),
      offset_y_(offset_y ? std::optional<int64_t>(*offset_y) : std::nullopt),
      image_paths_(image_paths ? std::optional<EncodableList>(*image_paths)
                               : std::nullopt),
      fps_(fps ? std::optional<int64_t>(*fps) : std::nullopt),
      loop_(loop ? std::optional<bool>(*loop) : std::nullopt) {}

const double* VideoWatermarkImageConfig::wm_alpha() const {
  return wm_alpha_ ? &(*wm_alpha_) : nullptr;
}

void VideoWatermarkImageConfig::set_wm_alpha(const double* value_arg) {
  wm_alpha_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_wm_alpha(double value_arg) {
  wm_alpha_ = value_arg;
}

const int64_t* VideoWatermarkImageConfig::wm_width() const {
  return wm_width_ ? &(*wm_width_) : nullptr;
}

void VideoWatermarkImageConfig::set_wm_width(const int64_t* value_arg) {
  wm_width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_wm_width(int64_t value_arg) {
  wm_width_ = value_arg;
}

const int64_t* VideoWatermarkImageConfig::wm_height() const {
  return wm_height_ ? &(*wm_height_) : nullptr;
}

void VideoWatermarkImageConfig::set_wm_height(const int64_t* value_arg) {
  wm_height_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_wm_height(int64_t value_arg) {
  wm_height_ = value_arg;
}

const int64_t* VideoWatermarkImageConfig::offset_x() const {
  return offset_x_ ? &(*offset_x_) : nullptr;
}

void VideoWatermarkImageConfig::set_offset_x(const int64_t* value_arg) {
  offset_x_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_offset_x(int64_t value_arg) {
  offset_x_ = value_arg;
}

const int64_t* VideoWatermarkImageConfig::offset_y() const {
  return offset_y_ ? &(*offset_y_) : nullptr;
}

void VideoWatermarkImageConfig::set_offset_y(const int64_t* value_arg) {
  offset_y_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_offset_y(int64_t value_arg) {
  offset_y_ = value_arg;
}

const EncodableList* VideoWatermarkImageConfig::image_paths() const {
  return image_paths_ ? &(*image_paths_) : nullptr;
}

void VideoWatermarkImageConfig::set_image_paths(
    const EncodableList* value_arg) {
  image_paths_ =
      value_arg ? std::optional<EncodableList>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_image_paths(
    const EncodableList& value_arg) {
  image_paths_ = value_arg;
}

const int64_t* VideoWatermarkImageConfig::fps() const {
  return fps_ ? &(*fps_) : nullptr;
}

void VideoWatermarkImageConfig::set_fps(const int64_t* value_arg) {
  fps_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_fps(int64_t value_arg) { fps_ = value_arg; }

const bool* VideoWatermarkImageConfig::loop() const {
  return loop_ ? &(*loop_) : nullptr;
}

void VideoWatermarkImageConfig::set_loop(const bool* value_arg) {
  loop_ = value_arg ? std::optional<bool>(*value_arg) : std::nullopt;
}

void VideoWatermarkImageConfig::set_loop(bool value_arg) { loop_ = value_arg; }

EncodableList VideoWatermarkImageConfig::ToEncodableList() const {
  EncodableList list;
  list.reserve(8);
  list.push_back(wm_alpha_ ? EncodableValue(*wm_alpha_) : EncodableValue());
  list.push_back(wm_width_ ? EncodableValue(*wm_width_) : EncodableValue());
  list.push_back(wm_height_ ? EncodableValue(*wm_height_) : EncodableValue());
  list.push_back(offset_x_ ? EncodableValue(*offset_x_) : EncodableValue());
  list.push_back(offset_y_ ? EncodableValue(*offset_y_) : EncodableValue());
  list.push_back(image_paths_ ? EncodableValue(*image_paths_)
                              : EncodableValue());
  list.push_back(fps_ ? EncodableValue(*fps_) : EncodableValue());
  list.push_back(loop_ ? EncodableValue(*loop_) : EncodableValue());
  return list;
}

VideoWatermarkImageConfig VideoWatermarkImageConfig::FromEncodableList(
    const EncodableList& list) {
  VideoWatermarkImageConfig decoded;
  auto& encodable_wm_alpha = list[0];
  if (!encodable_wm_alpha.IsNull()) {
    decoded.set_wm_alpha(std::get<double>(encodable_wm_alpha));
  }
  auto& encodable_wm_width = list[1];
  if (!encodable_wm_width.IsNull()) {
    decoded.set_wm_width(encodable_wm_width.LongValue());
  }
  auto& encodable_wm_height = list[2];
  if (!encodable_wm_height.IsNull()) {
    decoded.set_wm_height(encodable_wm_height.LongValue());
  }
  auto& encodable_offset_x = list[3];
  if (!encodable_offset_x.IsNull()) {
    decoded.set_offset_x(encodable_offset_x.LongValue());
  }
  auto& encodable_offset_y = list[4];
  if (!encodable_offset_y.IsNull()) {
    decoded.set_offset_y(encodable_offset_y.LongValue());
  }
  auto& encodable_image_paths = list[5];
  if (!encodable_image_paths.IsNull()) {
    decoded.set_image_paths(std::get<EncodableList>(encodable_image_paths));
  }
  auto& encodable_fps = list[6];
  if (!encodable_fps.IsNull()) {
    decoded.set_fps(encodable_fps.LongValue());
  }
  auto& encodable_loop = list[7];
  if (!encodable_loop.IsNull()) {
    decoded.set_loop(std::get<bool>(encodable_loop));
  }
  return decoded;
}

// VideoWatermarkTextConfig

VideoWatermarkTextConfig::VideoWatermarkTextConfig() {}

VideoWatermarkTextConfig::VideoWatermarkTextConfig(
    const double* wm_alpha, const int64_t* wm_width, const int64_t* wm_height,
    const int64_t* offset_x, const int64_t* offset_y, const int64_t* wm_color,
    const int64_t* font_size, const int64_t* font_color,
    const std::string* font_name_or_path, const std::string* content)
    : wm_alpha_(wm_alpha ? std::optional<double>(*wm_alpha) : std::nullopt),
      wm_width_(wm_width ? std::optional<int64_t>(*wm_width) : std::nullopt),
      wm_height_(wm_height ? std::optional<int64_t>(*wm_height) : std::nullopt),
      offset_x_(offset_x ? std::optional<int64_t>(*offset_x) : std::nullopt),
      offset_y_(offset_y ? std::optional<int64_t>(*offset_y) : std::nullopt),
      wm_color_(wm_color ? std::optional<int64_t>(*wm_color) : std::nullopt),
      font_size_(font_size ? std::optional<int64_t>(*font_size) : std::nullopt),
      font_color_(font_color ? std::optional<int64_t>(*font_color)
                             : std::nullopt),
      font_name_or_path_(font_name_or_path
                             ? std::optional<std::string>(*font_name_or_path)
                             : std::nullopt),
      content_(content ? std::optional<std::string>(*content) : std::nullopt) {}

const double* VideoWatermarkTextConfig::wm_alpha() const {
  return wm_alpha_ ? &(*wm_alpha_) : nullptr;
}

void VideoWatermarkTextConfig::set_wm_alpha(const double* value_arg) {
  wm_alpha_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_wm_alpha(double value_arg) {
  wm_alpha_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::wm_width() const {
  return wm_width_ ? &(*wm_width_) : nullptr;
}

void VideoWatermarkTextConfig::set_wm_width(const int64_t* value_arg) {
  wm_width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_wm_width(int64_t value_arg) {
  wm_width_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::wm_height() const {
  return wm_height_ ? &(*wm_height_) : nullptr;
}

void VideoWatermarkTextConfig::set_wm_height(const int64_t* value_arg) {
  wm_height_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_wm_height(int64_t value_arg) {
  wm_height_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::offset_x() const {
  return offset_x_ ? &(*offset_x_) : nullptr;
}

void VideoWatermarkTextConfig::set_offset_x(const int64_t* value_arg) {
  offset_x_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_offset_x(int64_t value_arg) {
  offset_x_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::offset_y() const {
  return offset_y_ ? &(*offset_y_) : nullptr;
}

void VideoWatermarkTextConfig::set_offset_y(const int64_t* value_arg) {
  offset_y_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_offset_y(int64_t value_arg) {
  offset_y_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::wm_color() const {
  return wm_color_ ? &(*wm_color_) : nullptr;
}

void VideoWatermarkTextConfig::set_wm_color(const int64_t* value_arg) {
  wm_color_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_wm_color(int64_t value_arg) {
  wm_color_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::font_size() const {
  return font_size_ ? &(*font_size_) : nullptr;
}

void VideoWatermarkTextConfig::set_font_size(const int64_t* value_arg) {
  font_size_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_font_size(int64_t value_arg) {
  font_size_ = value_arg;
}

const int64_t* VideoWatermarkTextConfig::font_color() const {
  return font_color_ ? &(*font_color_) : nullptr;
}

void VideoWatermarkTextConfig::set_font_color(const int64_t* value_arg) {
  font_color_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_font_color(int64_t value_arg) {
  font_color_ = value_arg;
}

const std::string* VideoWatermarkTextConfig::font_name_or_path() const {
  return font_name_or_path_ ? &(*font_name_or_path_) : nullptr;
}

void VideoWatermarkTextConfig::set_font_name_or_path(
    const std::string_view* value_arg) {
  font_name_or_path_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_font_name_or_path(
    std::string_view value_arg) {
  font_name_or_path_ = value_arg;
}

const std::string* VideoWatermarkTextConfig::content() const {
  return content_ ? &(*content_) : nullptr;
}

void VideoWatermarkTextConfig::set_content(const std::string_view* value_arg) {
  content_ = value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void VideoWatermarkTextConfig::set_content(std::string_view value_arg) {
  content_ = value_arg;
}

EncodableList VideoWatermarkTextConfig::ToEncodableList() const {
  EncodableList list;
  list.reserve(10);
  list.push_back(wm_alpha_ ? EncodableValue(*wm_alpha_) : EncodableValue());
  list.push_back(wm_width_ ? EncodableValue(*wm_width_) : EncodableValue());
  list.push_back(wm_height_ ? EncodableValue(*wm_height_) : EncodableValue());
  list.push_back(offset_x_ ? EncodableValue(*offset_x_) : EncodableValue());
  list.push_back(offset_y_ ? EncodableValue(*offset_y_) : EncodableValue());
  list.push_back(wm_color_ ? EncodableValue(*wm_color_) : EncodableValue());
  list.push_back(font_size_ ? EncodableValue(*font_size_) : EncodableValue());
  list.push_back(font_color_ ? EncodableValue(*font_color_) : EncodableValue());
  list.push_back(font_name_or_path_ ? EncodableValue(*font_name_or_path_)
                                    : EncodableValue());
  list.push_back(content_ ? EncodableValue(*content_) : EncodableValue());
  return list;
}

VideoWatermarkTextConfig VideoWatermarkTextConfig::FromEncodableList(
    const EncodableList& list) {
  VideoWatermarkTextConfig decoded;
  auto& encodable_wm_alpha = list[0];
  if (!encodable_wm_alpha.IsNull()) {
    decoded.set_wm_alpha(std::get<double>(encodable_wm_alpha));
  }
  auto& encodable_wm_width = list[1];
  if (!encodable_wm_width.IsNull()) {
    decoded.set_wm_width(encodable_wm_width.LongValue());
  }
  auto& encodable_wm_height = list[2];
  if (!encodable_wm_height.IsNull()) {
    decoded.set_wm_height(encodable_wm_height.LongValue());
  }
  auto& encodable_offset_x = list[3];
  if (!encodable_offset_x.IsNull()) {
    decoded.set_offset_x(encodable_offset_x.LongValue());
  }
  auto& encodable_offset_y = list[4];
  if (!encodable_offset_y.IsNull()) {
    decoded.set_offset_y(encodable_offset_y.LongValue());
  }
  auto& encodable_wm_color = list[5];
  if (!encodable_wm_color.IsNull()) {
    decoded.set_wm_color(encodable_wm_color.LongValue());
  }
  auto& encodable_font_size = list[6];
  if (!encodable_font_size.IsNull()) {
    decoded.set_font_size(encodable_font_size.LongValue());
  }
  auto& encodable_font_color = list[7];
  if (!encodable_font_color.IsNull()) {
    decoded.set_font_color(encodable_font_color.LongValue());
  }
  auto& encodable_font_name_or_path = list[8];
  if (!encodable_font_name_or_path.IsNull()) {
    decoded.set_font_name_or_path(
        std::get<std::string>(encodable_font_name_or_path));
  }
  auto& encodable_content = list[9];
  if (!encodable_content.IsNull()) {
    decoded.set_content(std::get<std::string>(encodable_content));
  }
  return decoded;
}

// VideoWatermarkTimestampConfig

VideoWatermarkTimestampConfig::VideoWatermarkTimestampConfig() {}

VideoWatermarkTimestampConfig::VideoWatermarkTimestampConfig(
    const double* wm_alpha, const int64_t* wm_width, const int64_t* wm_height,
    const int64_t* offset_x, const int64_t* offset_y, const int64_t* wm_color,
    const int64_t* font_size, const int64_t* font_color,
    const std::string* font_name_or_path)
    : wm_alpha_(wm_alpha ? std::optional<double>(*wm_alpha) : std::nullopt),
      wm_width_(wm_width ? std::optional<int64_t>(*wm_width) : std::nullopt),
      wm_height_(wm_height ? std::optional<int64_t>(*wm_height) : std::nullopt),
      offset_x_(offset_x ? std::optional<int64_t>(*offset_x) : std::nullopt),
      offset_y_(offset_y ? std::optional<int64_t>(*offset_y) : std::nullopt),
      wm_color_(wm_color ? std::optional<int64_t>(*wm_color) : std::nullopt),
      font_size_(font_size ? std::optional<int64_t>(*font_size) : std::nullopt),
      font_color_(font_color ? std::optional<int64_t>(*font_color)
                             : std::nullopt),
      font_name_or_path_(font_name_or_path
                             ? std::optional<std::string>(*font_name_or_path)
                             : std::nullopt) {}

const double* VideoWatermarkTimestampConfig::wm_alpha() const {
  return wm_alpha_ ? &(*wm_alpha_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_wm_alpha(const double* value_arg) {
  wm_alpha_ = value_arg ? std::optional<double>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_wm_alpha(double value_arg) {
  wm_alpha_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::wm_width() const {
  return wm_width_ ? &(*wm_width_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_wm_width(const int64_t* value_arg) {
  wm_width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_wm_width(int64_t value_arg) {
  wm_width_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::wm_height() const {
  return wm_height_ ? &(*wm_height_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_wm_height(const int64_t* value_arg) {
  wm_height_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_wm_height(int64_t value_arg) {
  wm_height_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::offset_x() const {
  return offset_x_ ? &(*offset_x_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_offset_x(const int64_t* value_arg) {
  offset_x_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_offset_x(int64_t value_arg) {
  offset_x_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::offset_y() const {
  return offset_y_ ? &(*offset_y_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_offset_y(const int64_t* value_arg) {
  offset_y_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_offset_y(int64_t value_arg) {
  offset_y_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::wm_color() const {
  return wm_color_ ? &(*wm_color_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_wm_color(const int64_t* value_arg) {
  wm_color_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_wm_color(int64_t value_arg) {
  wm_color_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::font_size() const {
  return font_size_ ? &(*font_size_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_font_size(const int64_t* value_arg) {
  font_size_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_font_size(int64_t value_arg) {
  font_size_ = value_arg;
}

const int64_t* VideoWatermarkTimestampConfig::font_color() const {
  return font_color_ ? &(*font_color_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_font_color(const int64_t* value_arg) {
  font_color_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_font_color(int64_t value_arg) {
  font_color_ = value_arg;
}

const std::string* VideoWatermarkTimestampConfig::font_name_or_path() const {
  return font_name_or_path_ ? &(*font_name_or_path_) : nullptr;
}

void VideoWatermarkTimestampConfig::set_font_name_or_path(
    const std::string_view* value_arg) {
  font_name_or_path_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void VideoWatermarkTimestampConfig::set_font_name_or_path(
    std::string_view value_arg) {
  font_name_or_path_ = value_arg;
}

EncodableList VideoWatermarkTimestampConfig::ToEncodableList() const {
  EncodableList list;
  list.reserve(9);
  list.push_back(wm_alpha_ ? EncodableValue(*wm_alpha_) : EncodableValue());
  list.push_back(wm_width_ ? EncodableValue(*wm_width_) : EncodableValue());
  list.push_back(wm_height_ ? EncodableValue(*wm_height_) : EncodableValue());
  list.push_back(offset_x_ ? EncodableValue(*offset_x_) : EncodableValue());
  list.push_back(offset_y_ ? EncodableValue(*offset_y_) : EncodableValue());
  list.push_back(wm_color_ ? EncodableValue(*wm_color_) : EncodableValue());
  list.push_back(font_size_ ? EncodableValue(*font_size_) : EncodableValue());
  list.push_back(font_color_ ? EncodableValue(*font_color_) : EncodableValue());
  list.push_back(font_name_or_path_ ? EncodableValue(*font_name_or_path_)
                                    : EncodableValue());
  return list;
}

VideoWatermarkTimestampConfig VideoWatermarkTimestampConfig::FromEncodableList(
    const EncodableList& list) {
  VideoWatermarkTimestampConfig decoded;
  auto& encodable_wm_alpha = list[0];
  if (!encodable_wm_alpha.IsNull()) {
    decoded.set_wm_alpha(std::get<double>(encodable_wm_alpha));
  }
  auto& encodable_wm_width = list[1];
  if (!encodable_wm_width.IsNull()) {
    decoded.set_wm_width(encodable_wm_width.LongValue());
  }
  auto& encodable_wm_height = list[2];
  if (!encodable_wm_height.IsNull()) {
    decoded.set_wm_height(encodable_wm_height.LongValue());
  }
  auto& encodable_offset_x = list[3];
  if (!encodable_offset_x.IsNull()) {
    decoded.set_offset_x(encodable_offset_x.LongValue());
  }
  auto& encodable_offset_y = list[4];
  if (!encodable_offset_y.IsNull()) {
    decoded.set_offset_y(encodable_offset_y.LongValue());
  }
  auto& encodable_wm_color = list[5];
  if (!encodable_wm_color.IsNull()) {
    decoded.set_wm_color(encodable_wm_color.LongValue());
  }
  auto& encodable_font_size = list[6];
  if (!encodable_font_size.IsNull()) {
    decoded.set_font_size(encodable_font_size.LongValue());
  }
  auto& encodable_font_color = list[7];
  if (!encodable_font_color.IsNull()) {
    decoded.set_font_color(encodable_font_color.LongValue());
  }
  auto& encodable_font_name_or_path = list[8];
  if (!encodable_font_name_or_path.IsNull()) {
    decoded.set_font_name_or_path(
        std::get<std::string>(encodable_font_name_or_path));
  }
  return decoded;
}

// VideoWatermarkConfig

VideoWatermarkConfig::VideoWatermarkConfig(
    const NERtcVideoWatermarkType& watermark_type)
    : watermark_type_(watermark_type) {}

VideoWatermarkConfig::VideoWatermarkConfig(
    const NERtcVideoWatermarkType& watermark_type,
    const VideoWatermarkImageConfig* image_watermark,
    const VideoWatermarkTextConfig* text_watermark,
    const VideoWatermarkTimestampConfig* timestamp_watermark)
    : watermark_type_(watermark_type),
      image_watermark_(
          image_watermark
              ? std::optional<VideoWatermarkImageConfig>(*image_watermark)
              : std::nullopt),
      text_watermark_(text_watermark ? std::optional<VideoWatermarkTextConfig>(
                                           *text_watermark)
                                     : std::nullopt),
      timestamp_watermark_(timestamp_watermark
                               ? std::optional<VideoWatermarkTimestampConfig>(
                                     *timestamp_watermark)
                               : std::nullopt) {}

const NERtcVideoWatermarkType& VideoWatermarkConfig::watermark_type() const {
  return watermark_type_;
}

void VideoWatermarkConfig::set_watermark_type(
    const NERtcVideoWatermarkType& value_arg) {
  watermark_type_ = value_arg;
}

const VideoWatermarkImageConfig* VideoWatermarkConfig::image_watermark() const {
  return image_watermark_ ? &(*image_watermark_) : nullptr;
}

void VideoWatermarkConfig::set_image_watermark(
    const VideoWatermarkImageConfig* value_arg) {
  image_watermark_ = value_arg
                         ? std::optional<VideoWatermarkImageConfig>(*value_arg)
                         : std::nullopt;
}

void VideoWatermarkConfig::set_image_watermark(
    const VideoWatermarkImageConfig& value_arg) {
  image_watermark_ = value_arg;
}

const VideoWatermarkTextConfig* VideoWatermarkConfig::text_watermark() const {
  return text_watermark_ ? &(*text_watermark_) : nullptr;
}

void VideoWatermarkConfig::set_text_watermark(
    const VideoWatermarkTextConfig* value_arg) {
  text_watermark_ = value_arg
                        ? std::optional<VideoWatermarkTextConfig>(*value_arg)
                        : std::nullopt;
}

void VideoWatermarkConfig::set_text_watermark(
    const VideoWatermarkTextConfig& value_arg) {
  text_watermark_ = value_arg;
}

const VideoWatermarkTimestampConfig* VideoWatermarkConfig::timestamp_watermark()
    const {
  return timestamp_watermark_ ? &(*timestamp_watermark_) : nullptr;
}

void VideoWatermarkConfig::set_timestamp_watermark(
    const VideoWatermarkTimestampConfig* value_arg) {
  timestamp_watermark_ =
      value_arg ? std::optional<VideoWatermarkTimestampConfig>(*value_arg)
                : std::nullopt;
}

void VideoWatermarkConfig::set_timestamp_watermark(
    const VideoWatermarkTimestampConfig& value_arg) {
  timestamp_watermark_ = value_arg;
}

EncodableList VideoWatermarkConfig::ToEncodableList() const {
  EncodableList list;
  list.reserve(4);
  list.push_back(EncodableValue((int)watermark_type_));
  list.push_back(image_watermark_
                     ? EncodableValue(image_watermark_->ToEncodableList())
                     : EncodableValue());
  list.push_back(text_watermark_
                     ? EncodableValue(text_watermark_->ToEncodableList())
                     : EncodableValue());
  list.push_back(timestamp_watermark_
                     ? EncodableValue(timestamp_watermark_->ToEncodableList())
                     : EncodableValue());
  return list;
}

VideoWatermarkConfig VideoWatermarkConfig::FromEncodableList(
    const EncodableList& list) {
  VideoWatermarkConfig decoded(
      (NERtcVideoWatermarkType)(std::get<int32_t>(list[0])));
  auto& encodable_image_watermark = list[1];
  if (!encodable_image_watermark.IsNull()) {
    decoded.set_image_watermark(VideoWatermarkImageConfig::FromEncodableList(
        std::get<EncodableList>(encodable_image_watermark)));
  }
  auto& encodable_text_watermark = list[2];
  if (!encodable_text_watermark.IsNull()) {
    decoded.set_text_watermark(VideoWatermarkTextConfig::FromEncodableList(
        std::get<EncodableList>(encodable_text_watermark)));
  }
  auto& encodable_timestamp_watermark = list[3];
  if (!encodable_timestamp_watermark.IsNull()) {
    decoded.set_timestamp_watermark(
        VideoWatermarkTimestampConfig::FromEncodableList(
            std::get<EncodableList>(encodable_timestamp_watermark)));
  }
  return decoded;
}

// SetLocalVideoWatermarkConfigsRequest

SetLocalVideoWatermarkConfigsRequest::SetLocalVideoWatermarkConfigsRequest(
    int64_t type)
    : type_(type) {}

SetLocalVideoWatermarkConfigsRequest::SetLocalVideoWatermarkConfigsRequest(
    int64_t type, const VideoWatermarkConfig* config)
    : type_(type),
      config_(config ? std::optional<VideoWatermarkConfig>(*config)
                     : std::nullopt) {}

int64_t SetLocalVideoWatermarkConfigsRequest::type() const { return type_; }

void SetLocalVideoWatermarkConfigsRequest::set_type(int64_t value_arg) {
  type_ = value_arg;
}

const VideoWatermarkConfig* SetLocalVideoWatermarkConfigsRequest::config()
    const {
  return config_ ? &(*config_) : nullptr;
}

void SetLocalVideoWatermarkConfigsRequest::set_config(
    const VideoWatermarkConfig* value_arg) {
  config_ = value_arg ? std::optional<VideoWatermarkConfig>(*value_arg)
                      : std::nullopt;
}

void SetLocalVideoWatermarkConfigsRequest::set_config(
    const VideoWatermarkConfig& value_arg) {
  config_ = value_arg;
}

EncodableList SetLocalVideoWatermarkConfigsRequest::ToEncodableList() const {
  EncodableList list;
  list.reserve(2);
  list.push_back(EncodableValue(type_));
  list.push_back(config_ ? EncodableValue(config_->ToEncodableList())
                         : EncodableValue());
  return list;
}

SetLocalVideoWatermarkConfigsRequest
SetLocalVideoWatermarkConfigsRequest::FromEncodableList(
    const EncodableList& list) {
  SetLocalVideoWatermarkConfigsRequest decoded(list[0].LongValue());
  auto& encodable_config = list[1];
  if (!encodable_config.IsNull()) {
    decoded.set_config(VideoWatermarkConfig::FromEncodableList(
        std::get<EncodableList>(encodable_config)));
  }
  return decoded;
}

// NERtcVersion

NERtcVersion::NERtcVersion() {}

NERtcVersion::NERtcVersion(
    const std::string* version_name, const int64_t* version_code,
    const std::string* build_type, const std::string* build_date,
    const std::string* build_revision, const std::string* build_host,
    const std::string* server_env, const std::string* build_branch,
    const std::string* engine_revision)
    : version_name_(version_name ? std::optional<std::string>(*version_name)
                                 : std::nullopt),
      version_code_(version_code ? std::optional<int64_t>(*version_code)
                                 : std::nullopt),
      build_type_(build_type ? std::optional<std::string>(*build_type)
                             : std::nullopt),
      build_date_(build_date ? std::optional<std::string>(*build_date)
                             : std::nullopt),
      build_revision_(build_revision
                          ? std::optional<std::string>(*build_revision)
                          : std::nullopt),
      build_host_(build_host ? std::optional<std::string>(*build_host)
                             : std::nullopt),
      server_env_(server_env ? std::optional<std::string>(*server_env)
                             : std::nullopt),
      build_branch_(build_branch ? std::optional<std::string>(*build_branch)
                                 : std::nullopt),
      engine_revision_(engine_revision
                           ? std::optional<std::string>(*engine_revision)
                           : std::nullopt) {}

const std::string* NERtcVersion::version_name() const {
  return version_name_ ? &(*version_name_) : nullptr;
}

void NERtcVersion::set_version_name(const std::string_view* value_arg) {
  version_name_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_version_name(std::string_view value_arg) {
  version_name_ = value_arg;
}

const int64_t* NERtcVersion::version_code() const {
  return version_code_ ? &(*version_code_) : nullptr;
}

void NERtcVersion::set_version_code(const int64_t* value_arg) {
  version_code_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_version_code(int64_t value_arg) {
  version_code_ = value_arg;
}

const std::string* NERtcVersion::build_type() const {
  return build_type_ ? &(*build_type_) : nullptr;
}

void NERtcVersion::set_build_type(const std::string_view* value_arg) {
  build_type_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_build_type(std::string_view value_arg) {
  build_type_ = value_arg;
}

const std::string* NERtcVersion::build_date() const {
  return build_date_ ? &(*build_date_) : nullptr;
}

void NERtcVersion::set_build_date(const std::string_view* value_arg) {
  build_date_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_build_date(std::string_view value_arg) {
  build_date_ = value_arg;
}

const std::string* NERtcVersion::build_revision() const {
  return build_revision_ ? &(*build_revision_) : nullptr;
}

void NERtcVersion::set_build_revision(const std::string_view* value_arg) {
  build_revision_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_build_revision(std::string_view value_arg) {
  build_revision_ = value_arg;
}

const std::string* NERtcVersion::build_host() const {
  return build_host_ ? &(*build_host_) : nullptr;
}

void NERtcVersion::set_build_host(const std::string_view* value_arg) {
  build_host_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_build_host(std::string_view value_arg) {
  build_host_ = value_arg;
}

const std::string* NERtcVersion::server_env() const {
  return server_env_ ? &(*server_env_) : nullptr;
}

void NERtcVersion::set_server_env(const std::string_view* value_arg) {
  server_env_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_server_env(std::string_view value_arg) {
  server_env_ = value_arg;
}

const std::string* NERtcVersion::build_branch() const {
  return build_branch_ ? &(*build_branch_) : nullptr;
}

void NERtcVersion::set_build_branch(const std::string_view* value_arg) {
  build_branch_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_build_branch(std::string_view value_arg) {
  build_branch_ = value_arg;
}

const std::string* NERtcVersion::engine_revision() const {
  return engine_revision_ ? &(*engine_revision_) : nullptr;
}

void NERtcVersion::set_engine_revision(const std::string_view* value_arg) {
  engine_revision_ =
      value_arg ? std::optional<std::string>(*value_arg) : std::nullopt;
}

void NERtcVersion::set_engine_revision(std::string_view value_arg) {
  engine_revision_ = value_arg;
}

EncodableList NERtcVersion::ToEncodableList() const {
  EncodableList list;
  list.reserve(9);
  list.push_back(version_name_ ? EncodableValue(*version_name_)
                               : EncodableValue());
  list.push_back(version_code_ ? EncodableValue(*version_code_)
                               : EncodableValue());
  list.push_back(build_type_ ? EncodableValue(*build_type_) : EncodableValue());
  list.push_back(build_date_ ? EncodableValue(*build_date_) : EncodableValue());
  list.push_back(build_revision_ ? EncodableValue(*build_revision_)
                                 : EncodableValue());
  list.push_back(build_host_ ? EncodableValue(*build_host_) : EncodableValue());
  list.push_back(server_env_ ? EncodableValue(*server_env_) : EncodableValue());
  list.push_back(build_branch_ ? EncodableValue(*build_branch_)
                               : EncodableValue());
  list.push_back(engine_revision_ ? EncodableValue(*engine_revision_)
                                  : EncodableValue());
  return list;
}

NERtcVersion NERtcVersion::FromEncodableList(const EncodableList& list) {
  NERtcVersion decoded;
  auto& encodable_version_name = list[0];
  if (!encodable_version_name.IsNull()) {
    decoded.set_version_name(std::get<std::string>(encodable_version_name));
  }
  auto& encodable_version_code = list[1];
  if (!encodable_version_code.IsNull()) {
    decoded.set_version_code(encodable_version_code.LongValue());
  }
  auto& encodable_build_type = list[2];
  if (!encodable_build_type.IsNull()) {
    decoded.set_build_type(std::get<std::string>(encodable_build_type));
  }
  auto& encodable_build_date = list[3];
  if (!encodable_build_date.IsNull()) {
    decoded.set_build_date(std::get<std::string>(encodable_build_date));
  }
  auto& encodable_build_revision = list[4];
  if (!encodable_build_revision.IsNull()) {
    decoded.set_build_revision(std::get<std::string>(encodable_build_revision));
  }
  auto& encodable_build_host = list[5];
  if (!encodable_build_host.IsNull()) {
    decoded.set_build_host(std::get<std::string>(encodable_build_host));
  }
  auto& encodable_server_env = list[6];
  if (!encodable_server_env.IsNull()) {
    decoded.set_server_env(std::get<std::string>(encodable_server_env));
  }
  auto& encodable_build_branch = list[7];
  if (!encodable_build_branch.IsNull()) {
    decoded.set_build_branch(std::get<std::string>(encodable_build_branch));
  }
  auto& encodable_engine_revision = list[8];
  if (!encodable_engine_revision.IsNull()) {
    decoded.set_engine_revision(
        std::get<std::string>(encodable_engine_revision));
  }
  return decoded;
}

// VideoFrame

VideoFrame::VideoFrame() {}

VideoFrame::VideoFrame(const int64_t* width, const int64_t* height,
                       const int64_t* rotation, const int64_t* format,
                       const int64_t* time_stamp,
                       const std::vector<uint8_t>* data,
                       const int64_t* stride_y, const int64_t* stride_u,
                       const int64_t* stride_v, const int64_t* texture_id,
                       const EncodableList* transform_matrix)
    : width_(width ? std::optional<int64_t>(*width) : std::nullopt),
      height_(height ? std::optional<int64_t>(*height) : std::nullopt),
      rotation_(rotation ? std::optional<int64_t>(*rotation) : std::nullopt),
      format_(format ? std::optional<int64_t>(*format) : std::nullopt),
      time_stamp_(time_stamp ? std::optional<int64_t>(*time_stamp)
                             : std::nullopt),
      data_(data ? std::optional<std::vector<uint8_t>>(*data) : std::nullopt),
      stride_y_(stride_y ? std::optional<int64_t>(*stride_y) : std::nullopt),
      stride_u_(stride_u ? std::optional<int64_t>(*stride_u) : std::nullopt),
      stride_v_(stride_v ? std::optional<int64_t>(*stride_v) : std::nullopt),
      texture_id_(texture_id ? std::optional<int64_t>(*texture_id)
                             : std::nullopt),
      transform_matrix_(transform_matrix
                            ? std::optional<EncodableList>(*transform_matrix)
                            : std::nullopt) {}

const int64_t* VideoFrame::width() const {
  return width_ ? &(*width_) : nullptr;
}

void VideoFrame::set_width(const int64_t* value_arg) {
  width_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_width(int64_t value_arg) { width_ = value_arg; }

const int64_t* VideoFrame::height() const {
  return height_ ? &(*height_) : nullptr;
}

void VideoFrame::set_height(const int64_t* value_arg) {
  height_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_height(int64_t value_arg) { height_ = value_arg; }

const int64_t* VideoFrame::rotation() const {
  return rotation_ ? &(*rotation_) : nullptr;
}

void VideoFrame::set_rotation(const int64_t* value_arg) {
  rotation_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_rotation(int64_t value_arg) { rotation_ = value_arg; }

const int64_t* VideoFrame::format() const {
  return format_ ? &(*format_) : nullptr;
}

void VideoFrame::set_format(const int64_t* value_arg) {
  format_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_format(int64_t value_arg) { format_ = value_arg; }

const int64_t* VideoFrame::time_stamp() const {
  return time_stamp_ ? &(*time_stamp_) : nullptr;
}

void VideoFrame::set_time_stamp(const int64_t* value_arg) {
  time_stamp_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_time_stamp(int64_t value_arg) { time_stamp_ = value_arg; }

const std::vector<uint8_t>* VideoFrame::data() const {
  return data_ ? &(*data_) : nullptr;
}

void VideoFrame::set_data(const std::vector<uint8_t>* value_arg) {
  data_ = value_arg ? std::optional<std::vector<uint8_t>>(*value_arg)
                    : std::nullopt;
}

void VideoFrame::set_data(const std::vector<uint8_t>& value_arg) {
  data_ = value_arg;
}

const int64_t* VideoFrame::stride_y() const {
  return stride_y_ ? &(*stride_y_) : nullptr;
}

void VideoFrame::set_stride_y(const int64_t* value_arg) {
  stride_y_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_stride_y(int64_t value_arg) { stride_y_ = value_arg; }

const int64_t* VideoFrame::stride_u() const {
  return stride_u_ ? &(*stride_u_) : nullptr;
}

void VideoFrame::set_stride_u(const int64_t* value_arg) {
  stride_u_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_stride_u(int64_t value_arg) { stride_u_ = value_arg; }

const int64_t* VideoFrame::stride_v() const {
  return stride_v_ ? &(*stride_v_) : nullptr;
}

void VideoFrame::set_stride_v(const int64_t* value_arg) {
  stride_v_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_stride_v(int64_t value_arg) { stride_v_ = value_arg; }

const int64_t* VideoFrame::texture_id() const {
  return texture_id_ ? &(*texture_id_) : nullptr;
}

void VideoFrame::set_texture_id(const int64_t* value_arg) {
  texture_id_ = value_arg ? std::optional<int64_t>(*value_arg) : std::nullopt;
}

void VideoFrame::set_texture_id(int64_t value_arg) { texture_id_ = value_arg; }

const EncodableList* VideoFrame::transform_matrix() const {
  return transform_matrix_ ? &(*transform_matrix_) : nullptr;
}

void VideoFrame::set_transform_matrix(const EncodableList* value_arg) {
  transform_matrix_ =
      value_arg ? std::optional<EncodableList>(*value_arg) : std::nullopt;
}

void VideoFrame::set_transform_matrix(const EncodableList& value_arg) {
  transform_matrix_ = value_arg;
}

EncodableList VideoFrame::ToEncodableList() const {
  EncodableList list;
  list.reserve(11);
  list.push_back(width_ ? EncodableValue(*width_) : EncodableValue());
  list.push_back(height_ ? EncodableValue(*height_) : EncodableValue());
  list.push_back(rotation_ ? EncodableValue(*rotation_) : EncodableValue());
  list.push_back(format_ ? EncodableValue(*format_) : EncodableValue());
  list.push_back(time_stamp_ ? EncodableValue(*time_stamp_) : EncodableValue());
  list.push_back(data_ ? EncodableValue(*data_) : EncodableValue());
  list.push_back(stride_y_ ? EncodableValue(*stride_y_) : EncodableValue());
  list.push_back(stride_u_ ? EncodableValue(*stride_u_) : EncodableValue());
  list.push_back(stride_v_ ? EncodableValue(*stride_v_) : EncodableValue());
  list.push_back(texture_id_ ? EncodableValue(*texture_id_) : EncodableValue());
  list.push_back(transform_matrix_ ? EncodableValue(*transform_matrix_)
                                   : EncodableValue());
  return list;
}

VideoFrame VideoFrame::FromEncodableList(const EncodableList& list) {
  VideoFrame decoded;
  auto& encodable_width = list[0];
  if (!encodable_width.IsNull()) {
    decoded.set_width(encodable_width.LongValue());
  }
  auto& encodable_height = list[1];
  if (!encodable_height.IsNull()) {
    decoded.set_height(encodable_height.LongValue());
  }
  auto& encodable_rotation = list[2];
  if (!encodable_rotation.IsNull()) {
    decoded.set_rotation(encodable_rotation.LongValue());
  }
  auto& encodable_format = list[3];
  if (!encodable_format.IsNull()) {
    decoded.set_format(encodable_format.LongValue());
  }
  auto& encodable_time_stamp = list[4];
  if (!encodable_time_stamp.IsNull()) {
    decoded.set_time_stamp(encodable_time_stamp.LongValue());
  }
  auto& encodable_data = list[5];
  if (!encodable_data.IsNull()) {
    decoded.set_data(std::get<std::vector<uint8_t>>(encodable_data));
  }
  auto& encodable_stride_y = list[6];
  if (!encodable_stride_y.IsNull()) {
    decoded.set_stride_y(encodable_stride_y.LongValue());
  }
  auto& encodable_stride_u = list[7];
  if (!encodable_stride_u.IsNull()) {
    decoded.set_stride_u(encodable_stride_u.LongValue());
  }
  auto& encodable_stride_v = list[8];
  if (!encodable_stride_v.IsNull()) {
    decoded.set_stride_v(encodable_stride_v.LongValue());
  }
  auto& encodable_texture_id = list[9];
  if (!encodable_texture_id.IsNull()) {
    decoded.set_texture_id(encodable_texture_id.LongValue());
  }
  auto& encodable_transform_matrix = list[10];
  if (!encodable_transform_matrix.IsNull()) {
    decoded.set_transform_matrix(
        std::get<EncodableList>(encodable_transform_matrix));
  }
  return decoded;
}

NERtcChannelEventSinkCodecSerializer::NERtcChannelEventSinkCodecSerializer() {}

EncodableValue NERtcChannelEventSinkCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(AudioVolumeInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 129:
      return CustomEncodableValue(
          FirstVideoDataReceivedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 130:
      return CustomEncodableValue(
          FirstVideoFrameDecodedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 131:
      return CustomEncodableValue(
          NERtcLastmileProbeOneWayResult::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 132:
      return CustomEncodableValue(NERtcLastmileProbeResult::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 133:
      return CustomEncodableValue(NERtcUserJoinExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 134:
      return CustomEncodableValue(NERtcUserLeaveExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 135:
      return CustomEncodableValue(
          RemoteAudioVolumeIndicationEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 136:
      return CustomEncodableValue(UserJoinedEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 137:
      return CustomEncodableValue(UserLeaveEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 138:
      return CustomEncodableValue(UserVideoMuteEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 139:
      return CustomEncodableValue(
          VirtualBackgroundSourceEnabledEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void NERtcChannelEventSinkCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(AudioVolumeInfo)) {
      stream->WriteByte(128);
      WriteValue(
          EncodableValue(
              std::any_cast<AudioVolumeInfo>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoDataReceivedEvent)) {
      stream->WriteByte(129);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoDataReceivedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoFrameDecodedEvent)) {
      stream->WriteByte(130);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoFrameDecodedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeOneWayResult)) {
      stream->WriteByte(131);
      WriteValue(EncodableValue(std::any_cast<NERtcLastmileProbeOneWayResult>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeResult)) {
      stream->WriteByte(132);
      WriteValue(
          EncodableValue(std::any_cast<NERtcLastmileProbeResult>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserJoinExtraInfo)) {
      stream->WriteByte(133);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserJoinExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserLeaveExtraInfo)) {
      stream->WriteByte(134);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserLeaveExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(RemoteAudioVolumeIndicationEvent)) {
      stream->WriteByte(135);
      WriteValue(EncodableValue(std::any_cast<RemoteAudioVolumeIndicationEvent>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(UserJoinedEvent)) {
      stream->WriteByte(136);
      WriteValue(
          EncodableValue(
              std::any_cast<UserJoinedEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserLeaveEvent)) {
      stream->WriteByte(137);
      WriteValue(
          EncodableValue(
              std::any_cast<UserLeaveEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserVideoMuteEvent)) {
      stream->WriteByte(138);
      WriteValue(EncodableValue(std::any_cast<UserVideoMuteEvent>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(VirtualBackgroundSourceEnabledEvent)) {
      stream->WriteByte(139);
      WriteValue(
          EncodableValue(
              std::any_cast<VirtualBackgroundSourceEnabledEvent>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcChannelEventSink::NERtcChannelEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcChannelEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &NERtcChannelEventSinkCodecSerializer::GetInstance());
}

void NERtcChannelEventSink::OnJoinChannel(
    int64_t result_arg, int64_t channel_id_arg, int64_t elapsed_arg,
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onJoinChannel", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(result_arg),
      EncodableValue(channel_id_arg),
      EncodableValue(elapsed_arg),
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLeaveChannel(
    int64_t result_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLeaveChannel", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(result_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserJoined(
    const UserJoinedEvent& event_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserJoined", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserLeave(
    const UserLeaveEvent& event_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_, "dev.flutter.pigeon.NERtcChannelEventSink.onUserLeave",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserAudioStart(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserAudioStart", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserSubStreamAudioStart(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserSubStreamAudioStart",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserAudioStop(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserAudioStop", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserSubStreamAudioStop(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserSubStreamAudioStop",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserVideoStart(
    int64_t uid_arg, int64_t max_profile_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserVideoStart", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
      EncodableValue(max_profile_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserVideoStop(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserVideoStop", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnDisconnect(
    int64_t reason_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onDisconnect", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(reason_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserAudioMute(
    int64_t uid_arg, bool muted_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserAudioMute", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
      EncodableValue(muted_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserVideoMute(
    const UserVideoMuteEvent& event_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserVideoMute", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserSubStreamAudioMute(
    int64_t uid_arg, bool muted_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserSubStreamAudioMute",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
      EncodableValue(muted_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnFirstAudioDataReceived(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onFirstAudioDataReceived",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnFirstVideoDataReceived(
    const FirstVideoDataReceivedEvent& event_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onFirstVideoDataReceived",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnFirstAudioFrameDecoded(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onFirstAudioFrameDecoded",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnFirstVideoFrameDecoded(
    const FirstVideoFrameDecodedEvent& event_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onFirstVideoFrameDecoded",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnVirtualBackgroundSourceEnabled(
    const VirtualBackgroundSourceEnabledEvent& event_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink."
      "onVirtualBackgroundSourceEnabled",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnConnectionTypeChanged(
    int64_t new_connection_type_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onConnectionTypeChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(new_connection_type_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnReconnectingStart(
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onReconnectingStart",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue();
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnReJoinChannel(
    int64_t result_arg, int64_t channel_id_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onReJoinChannel", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(result_arg),
      EncodableValue(channel_id_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnConnectionStateChanged(
    int64_t state_arg, int64_t reason_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onConnectionStateChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(state_arg),
      EncodableValue(reason_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLocalAudioVolumeIndication(
    int64_t volume_arg, bool vad_flag_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLocalAudioVolumeIndication",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(volume_arg),
      EncodableValue(vad_flag_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnRemoteAudioVolumeIndication(
    const RemoteAudioVolumeIndicationEvent& event_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onRemoteAudioVolumeIndication",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(event_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLiveStreamState(
    const std::string& task_id_arg, const std::string& push_url_arg,
    int64_t live_state_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLiveStreamState",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(task_id_arg),
      EncodableValue(push_url_arg),
      EncodableValue(live_state_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnClientRoleChange(
    int64_t old_role_arg, int64_t new_role_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onClientRoleChange",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(old_role_arg),
      EncodableValue(new_role_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnError(
    int64_t code_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_, "dev.flutter.pigeon.NERtcChannelEventSink.onError",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(code_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnWarning(
    int64_t code_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_, "dev.flutter.pigeon.NERtcChannelEventSink.onWarning",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(code_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserSubStreamVideoStart(
    int64_t uid_arg, int64_t max_profile_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserSubStreamVideoStart",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
      EncodableValue(max_profile_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUserSubStreamVideoStop(
    int64_t uid_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUserSubStreamVideoStop",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnAudioHasHowling(
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onAudioHasHowling",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue();
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnRecvSEIMsg(
    int64_t user_i_d_arg, const std::string& sei_msg_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onRecvSEIMsg", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(user_i_d_arg),
      EncodableValue(sei_msg_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnAudioRecording(
    int64_t code_arg, const std::string& file_path_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onAudioRecording", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(code_arg),
      EncodableValue(file_path_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnMediaRightChange(
    bool is_audio_banned_by_server_arg, bool is_video_banned_by_server_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onMediaRightChange",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(is_audio_banned_by_server_arg),
      EncodableValue(is_video_banned_by_server_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnMediaRelayStatesChange(
    int64_t state_arg, const std::string& channel_name_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onMediaRelayStatesChange",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(state_arg),
      EncodableValue(channel_name_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnMediaRelayReceiveEvent(
    int64_t event_arg, int64_t code_arg, const std::string& channel_name_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onMediaRelayReceiveEvent",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(event_arg),
      EncodableValue(code_arg),
      EncodableValue(channel_name_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLocalPublishFallbackToAudioOnly(
    bool is_fallback_arg, int64_t stream_type_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink."
      "onLocalPublishFallbackToAudioOnly",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(is_fallback_arg),
      EncodableValue(stream_type_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnRemoteSubscribeFallbackToAudioOnly(
    int64_t uid_arg, bool is_fallback_arg, int64_t stream_type_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink."
      "onRemoteSubscribeFallbackToAudioOnly",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(uid_arg),
      EncodableValue(is_fallback_arg),
      EncodableValue(stream_type_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLocalVideoWatermarkState(
    int64_t video_stream_type_arg, int64_t state_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLocalVideoWatermarkState",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(video_stream_type_arg),
      EncodableValue(state_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLastmileQuality(
    int64_t quality_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLastmileQuality",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(quality_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnLastmileProbeResult(
    const NERtcLastmileProbeResult& result_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onLastmileProbeResult",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(result_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnTakeSnapshotResult(
    int64_t code_arg, const std::string& path_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onTakeSnapshotResult",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(code_arg),
      EncodableValue(path_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnPermissionKeyWillExpire(
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onPermissionKeyWillExpire",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue();
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcChannelEventSink::OnUpdatePermissionKey(
    const std::string& key_arg, int64_t error_arg, int64_t timeout_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcChannelEventSink.onUpdatePermissionKey",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(key_arg),
      EncodableValue(error_arg),
      EncodableValue(timeout_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

EngineApiCodecSerializer::EngineApiCodecSerializer() {}

EncodableValue EngineApiCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(
          AddOrUpdateLiveStreamTaskRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 129:
      return CustomEncodableValue(
          AdjustUserPlaybackSignalVolumeRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 130:
      return CustomEncodableValue(
          AudioRecordingConfigurationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 131:
      return CustomEncodableValue(AudioVolumeInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 132:
      return CustomEncodableValue(CGPoint::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 133:
      return CustomEncodableValue(CreateEngineRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 134:
      return CustomEncodableValue(
          DeleteLiveStreamTaskRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 135:
      return CustomEncodableValue(
          EnableAudioVolumeIndicationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 136:
      return CustomEncodableValue(EnableEncryptionRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 137:
      return CustomEncodableValue(EnableLocalVideoRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 138:
      return CustomEncodableValue(
          EnableVirtualBackgroundRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 139:
      return CustomEncodableValue(
          FirstVideoDataReceivedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 140:
      return CustomEncodableValue(
          FirstVideoFrameDecodedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 141:
      return CustomEncodableValue(JoinChannelOptions::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 142:
      return CustomEncodableValue(JoinChannelRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 143:
      return CustomEncodableValue(
          NERtcLastmileProbeOneWayResult::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 144:
      return CustomEncodableValue(NERtcLastmileProbeResult::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 145:
      return CustomEncodableValue(NERtcUserJoinExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 146:
      return CustomEncodableValue(NERtcUserLeaveExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 147:
      return CustomEncodableValue(NERtcVersion::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 148:
      return CustomEncodableValue(PlayEffectRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 149:
      return CustomEncodableValue(
          RemoteAudioVolumeIndicationEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 150:
      return CustomEncodableValue(ReportCustomEventRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 151:
      return CustomEncodableValue(RtcServerAddresses::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 152:
      return CustomEncodableValue(SendSEIMsgRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 153:
      return CustomEncodableValue(SetAudioProfileRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 154:
      return CustomEncodableValue(
          SetAudioSubscribeOnlyByRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 155:
      return CustomEncodableValue(
          SetCameraCaptureConfigRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 156:
      return CustomEncodableValue(SetCameraPositionRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 157:
      return CustomEncodableValue(
          SetLocalMediaPriorityRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 158:
      return CustomEncodableValue(SetLocalVideoConfigRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 159:
      return CustomEncodableValue(
          SetLocalVideoWatermarkConfigsRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 160:
      return CustomEncodableValue(
          SetLocalVoiceEqualizationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 161:
      return CustomEncodableValue(
          SetLocalVoiceReverbParamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 162:
      return CustomEncodableValue(
          SetRemoteHighPriorityAudioStreamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 163:
      return CustomEncodableValue(
          SetVideoCorrectionConfigRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 164:
      return CustomEncodableValue(StartAudioMixingRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 165:
      return CustomEncodableValue(StartAudioRecordingRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 166:
      return CustomEncodableValue(
          StartLastmileProbeTestRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 167:
      return CustomEncodableValue(
          StartOrUpdateChannelMediaRelayRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 168:
      return CustomEncodableValue(StartScreenCaptureRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 169:
      return CustomEncodableValue(
          StartorStopVideoPreviewRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 170:
      return CustomEncodableValue(
          SubscribeRemoteAudioRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 171:
      return CustomEncodableValue(
          SubscribeRemoteSubStreamAudioRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 172:
      return CustomEncodableValue(
          SubscribeRemoteSubStreamVideoRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 173:
      return CustomEncodableValue(
          SubscribeRemoteVideoStreamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 174:
      return CustomEncodableValue(SwitchChannelRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 175:
      return CustomEncodableValue(UserJoinedEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 176:
      return CustomEncodableValue(UserLeaveEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 177:
      return CustomEncodableValue(UserVideoMuteEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 178:
      return CustomEncodableValue(VideoFrame::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 179:
      return CustomEncodableValue(VideoWatermarkConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 180:
      return CustomEncodableValue(VideoWatermarkImageConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 181:
      return CustomEncodableValue(VideoWatermarkTextConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 182:
      return CustomEncodableValue(
          VideoWatermarkTimestampConfig::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 183:
      return CustomEncodableValue(
          VirtualBackgroundSourceEnabledEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void EngineApiCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(AddOrUpdateLiveStreamTaskRequest)) {
      stream->WriteByte(128);
      WriteValue(EncodableValue(std::any_cast<AddOrUpdateLiveStreamTaskRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(AdjustUserPlaybackSignalVolumeRequest)) {
      stream->WriteByte(129);
      WriteValue(
          EncodableValue(std::any_cast<AdjustUserPlaybackSignalVolumeRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(AudioRecordingConfigurationRequest)) {
      stream->WriteByte(130);
      WriteValue(
          EncodableValue(
              std::any_cast<AudioRecordingConfigurationRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(AudioVolumeInfo)) {
      stream->WriteByte(131);
      WriteValue(
          EncodableValue(
              std::any_cast<AudioVolumeInfo>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(CGPoint)) {
      stream->WriteByte(132);
      WriteValue(EncodableValue(
                     std::any_cast<CGPoint>(*custom_value).ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(CreateEngineRequest)) {
      stream->WriteByte(133);
      WriteValue(
          EncodableValue(std::any_cast<CreateEngineRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(DeleteLiveStreamTaskRequest)) {
      stream->WriteByte(134);
      WriteValue(EncodableValue(
                     std::any_cast<DeleteLiveStreamTaskRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(EnableAudioVolumeIndicationRequest)) {
      stream->WriteByte(135);
      WriteValue(
          EncodableValue(
              std::any_cast<EnableAudioVolumeIndicationRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableEncryptionRequest)) {
      stream->WriteByte(136);
      WriteValue(
          EncodableValue(std::any_cast<EnableEncryptionRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableLocalVideoRequest)) {
      stream->WriteByte(137);
      WriteValue(
          EncodableValue(std::any_cast<EnableLocalVideoRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableVirtualBackgroundRequest)) {
      stream->WriteByte(138);
      WriteValue(EncodableValue(std::any_cast<EnableVirtualBackgroundRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoDataReceivedEvent)) {
      stream->WriteByte(139);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoDataReceivedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoFrameDecodedEvent)) {
      stream->WriteByte(140);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoFrameDecodedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(JoinChannelOptions)) {
      stream->WriteByte(141);
      WriteValue(EncodableValue(std::any_cast<JoinChannelOptions>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(JoinChannelRequest)) {
      stream->WriteByte(142);
      WriteValue(EncodableValue(std::any_cast<JoinChannelRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeOneWayResult)) {
      stream->WriteByte(143);
      WriteValue(EncodableValue(std::any_cast<NERtcLastmileProbeOneWayResult>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeResult)) {
      stream->WriteByte(144);
      WriteValue(
          EncodableValue(std::any_cast<NERtcLastmileProbeResult>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserJoinExtraInfo)) {
      stream->WriteByte(145);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserJoinExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserLeaveExtraInfo)) {
      stream->WriteByte(146);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserLeaveExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcVersion)) {
      stream->WriteByte(147);
      WriteValue(
          EncodableValue(
              std::any_cast<NERtcVersion>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(PlayEffectRequest)) {
      stream->WriteByte(148);
      WriteValue(EncodableValue(std::any_cast<PlayEffectRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(RemoteAudioVolumeIndicationEvent)) {
      stream->WriteByte(149);
      WriteValue(EncodableValue(std::any_cast<RemoteAudioVolumeIndicationEvent>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(ReportCustomEventRequest)) {
      stream->WriteByte(150);
      WriteValue(
          EncodableValue(std::any_cast<ReportCustomEventRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(RtcServerAddresses)) {
      stream->WriteByte(151);
      WriteValue(EncodableValue(std::any_cast<RtcServerAddresses>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SendSEIMsgRequest)) {
      stream->WriteByte(152);
      WriteValue(EncodableValue(std::any_cast<SendSEIMsgRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetAudioProfileRequest)) {
      stream->WriteByte(153);
      WriteValue(
          EncodableValue(std::any_cast<SetAudioProfileRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetAudioSubscribeOnlyByRequest)) {
      stream->WriteByte(154);
      WriteValue(EncodableValue(std::any_cast<SetAudioSubscribeOnlyByRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetCameraCaptureConfigRequest)) {
      stream->WriteByte(155);
      WriteValue(EncodableValue(
                     std::any_cast<SetCameraCaptureConfigRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetCameraPositionRequest)) {
      stream->WriteByte(156);
      WriteValue(
          EncodableValue(std::any_cast<SetCameraPositionRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalMediaPriorityRequest)) {
      stream->WriteByte(157);
      WriteValue(EncodableValue(
                     std::any_cast<SetLocalMediaPriorityRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVideoConfigRequest)) {
      stream->WriteByte(158);
      WriteValue(EncodableValue(
                     std::any_cast<SetLocalVideoConfigRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVideoWatermarkConfigsRequest)) {
      stream->WriteByte(159);
      WriteValue(
          EncodableValue(
              std::any_cast<SetLocalVideoWatermarkConfigsRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVoiceEqualizationRequest)) {
      stream->WriteByte(160);
      WriteValue(EncodableValue(std::any_cast<SetLocalVoiceEqualizationRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVoiceReverbParamRequest)) {
      stream->WriteByte(161);
      WriteValue(EncodableValue(std::any_cast<SetLocalVoiceReverbParamRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() ==
        typeid(SetRemoteHighPriorityAudioStreamRequest)) {
      stream->WriteByte(162);
      WriteValue(
          EncodableValue(std::any_cast<SetRemoteHighPriorityAudioStreamRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetVideoCorrectionConfigRequest)) {
      stream->WriteByte(163);
      WriteValue(EncodableValue(std::any_cast<SetVideoCorrectionConfigRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartAudioMixingRequest)) {
      stream->WriteByte(164);
      WriteValue(
          EncodableValue(std::any_cast<StartAudioMixingRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartAudioRecordingRequest)) {
      stream->WriteByte(165);
      WriteValue(EncodableValue(
                     std::any_cast<StartAudioRecordingRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartLastmileProbeTestRequest)) {
      stream->WriteByte(166);
      WriteValue(EncodableValue(
                     std::any_cast<StartLastmileProbeTestRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartOrUpdateChannelMediaRelayRequest)) {
      stream->WriteByte(167);
      WriteValue(
          EncodableValue(std::any_cast<StartOrUpdateChannelMediaRelayRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartScreenCaptureRequest)) {
      stream->WriteByte(168);
      WriteValue(
          EncodableValue(std::any_cast<StartScreenCaptureRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartorStopVideoPreviewRequest)) {
      stream->WriteByte(169);
      WriteValue(EncodableValue(std::any_cast<StartorStopVideoPreviewRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteAudioRequest)) {
      stream->WriteByte(170);
      WriteValue(EncodableValue(
                     std::any_cast<SubscribeRemoteAudioRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteSubStreamAudioRequest)) {
      stream->WriteByte(171);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteSubStreamAudioRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteSubStreamVideoRequest)) {
      stream->WriteByte(172);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteSubStreamVideoRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteVideoStreamRequest)) {
      stream->WriteByte(173);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteVideoStreamRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SwitchChannelRequest)) {
      stream->WriteByte(174);
      WriteValue(
          EncodableValue(std::any_cast<SwitchChannelRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserJoinedEvent)) {
      stream->WriteByte(175);
      WriteValue(
          EncodableValue(
              std::any_cast<UserJoinedEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserLeaveEvent)) {
      stream->WriteByte(176);
      WriteValue(
          EncodableValue(
              std::any_cast<UserLeaveEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserVideoMuteEvent)) {
      stream->WriteByte(177);
      WriteValue(EncodableValue(std::any_cast<UserVideoMuteEvent>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(VideoFrame)) {
      stream->WriteByte(178);
      WriteValue(
          EncodableValue(
              std::any_cast<VideoFrame>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkConfig)) {
      stream->WriteByte(179);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkImageConfig)) {
      stream->WriteByte(180);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkImageConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkTextConfig)) {
      stream->WriteByte(181);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkTextConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkTimestampConfig)) {
      stream->WriteByte(182);
      WriteValue(EncodableValue(
                     std::any_cast<VideoWatermarkTimestampConfig>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(VirtualBackgroundSourceEnabledEvent)) {
      stream->WriteByte(183);
      WriteValue(
          EncodableValue(
              std::any_cast<VirtualBackgroundSourceEnabledEvent>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

/// The codec used by EngineApi.
const flutter::StandardMessageCodec& EngineApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &EngineApiCodecSerializer::GetInstance());
}

// Sets up an instance of `EngineApi` to handle messages through the
// `binary_messenger`.
void EngineApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                      EngineApi* api) {
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.create", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const CreateEngineRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->Create(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.version", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<NERtcVersion> output = api->Version();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(
                  CustomEncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.checkPermission",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<std::optional<EncodableList>> output =
                  api->CheckPermission();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              auto output_optional = std::move(output).TakeValue();
              if (output_optional) {
                wrapped.push_back(
                    EncodableValue(std::move(output_optional).value()));
              } else {
                wrapped.push_back(EncodableValue());
              }
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setParameters",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_params_arg = args.at(0);
              if (encodable_params_arg.IsNull()) {
                reply(WrapError("params_arg unexpectedly null."));
                return;
              }
              const auto& params_arg =
                  std::get<EncodableMap>(encodable_params_arg);
              ErrorOr<int64_t> output = api->SetParameters(params_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.release", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              api->Release([reply](ErrorOr<int64_t>&& output) {
                if (output.has_error()) {
                  reply(WrapError(output.error()));
                  return;
                }
                EncodableList wrapped;
                wrapped.push_back(
                    EncodableValue(std::move(output).TakeValue()));
                reply(EncodableValue(std::move(wrapped)));
              });
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setStatsEventCallback",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->SetStatsEventCallback();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.clearStatsEventCallback", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->ClearStatsEventCallback();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setChannelProfile",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_channel_profile_arg = args.at(0);
              if (encodable_channel_profile_arg.IsNull()) {
                reply(WrapError("channel_profile_arg unexpectedly null."));
                return;
              }
              const int64_t channel_profile_arg =
                  encodable_channel_profile_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetChannelProfile(channel_profile_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.joinChannel",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const JoinChannelRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->JoinChannel(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.leaveChannel",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->LeaveChannel();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.updatePermissionKey",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_key_arg = args.at(0);
              if (encodable_key_arg.IsNull()) {
                reply(WrapError("key_arg unexpectedly null."));
                return;
              }
              const auto& key_arg = std::get<std::string>(encodable_key_arg);
              ErrorOr<int64_t> output = api->UpdatePermissionKey(key_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableLocalAudio",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output = api->EnableLocalAudio(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.subscribeRemoteAudio",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SubscribeRemoteAudioRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SubscribeRemoteAudio(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.subscribeAllRemoteAudio", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_subscribe_arg = args.at(0);
              if (encodable_subscribe_arg.IsNull()) {
                reply(WrapError("subscribe_arg unexpectedly null."));
                return;
              }
              const auto& subscribe_arg =
                  std::get<bool>(encodable_subscribe_arg);
              ErrorOr<int64_t> output =
                  api->SubscribeAllRemoteAudio(subscribe_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setAudioProfile",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetAudioProfileRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SetAudioProfile(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableDualStreamMode",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output = api->EnableDualStreamMode(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setLocalVideoConfig",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetLocalVideoConfigRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SetLocalVideoConfig(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setCameraCaptureConfig",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetCameraCaptureConfigRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetCameraCaptureConfig(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startVideoPreview",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartorStopVideoPreviewRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->StartVideoPreview(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopVideoPreview",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartorStopVideoPreviewRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->StopVideoPreview(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableLocalVideo",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const EnableLocalVideoRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->EnableLocalVideo(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.enableLocalSubStreamAudio", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output =
                  api->EnableLocalSubStreamAudio(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.subscribeRemoteSubStreamAudio",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SubscribeRemoteSubStreamAudioRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SubscribeRemoteSubStreamAudio(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.muteLocalSubStreamAudio", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_muted_arg = args.at(0);
              if (encodable_muted_arg.IsNull()) {
                reply(WrapError("muted_arg unexpectedly null."));
                return;
              }
              const auto& muted_arg = std::get<bool>(encodable_muted_arg);
              ErrorOr<int64_t> output = api->MuteLocalSubStreamAudio(muted_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setAudioSubscribeOnlyBy", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetAudioSubscribeOnlyByRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetAudioSubscribeOnlyBy(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startScreenCapture",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartScreenCaptureRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              api->StartScreenCapture(
                  request_arg, [reply](ErrorOr<int64_t>&& output) {
                    if (output.has_error()) {
                      reply(WrapError(output.error()));
                      return;
                    }
                    EncodableList wrapped;
                    wrapped.push_back(
                        EncodableValue(std::move(output).TakeValue()));
                    reply(EncodableValue(std::move(wrapped)));
                  });
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopScreenCapture",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopScreenCapture();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.enableLoopbackRecording", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output =
                  api->EnableLoopbackRecording(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.subscribeRemoteVideoStream", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SubscribeRemoteVideoStreamRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SubscribeRemoteVideoStream(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.subscribeRemoteSubStreamVideo",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SubscribeRemoteSubStreamVideoRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SubscribeRemoteSubStreamVideo(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.muteLocalAudioStream",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_mute_arg = args.at(0);
              if (encodable_mute_arg.IsNull()) {
                reply(WrapError("mute_arg unexpectedly null."));
                return;
              }
              const auto& mute_arg = std::get<bool>(encodable_mute_arg);
              ErrorOr<int64_t> output = api->MuteLocalAudioStream(mute_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.muteLocalVideoStream",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_mute_arg = args.at(0);
              if (encodable_mute_arg.IsNull()) {
                reply(WrapError("mute_arg unexpectedly null."));
                return;
              }
              const auto& mute_arg = std::get<bool>(encodable_mute_arg);
              const auto& encodable_stream_type_arg = args.at(1);
              if (encodable_stream_type_arg.IsNull()) {
                reply(WrapError("stream_type_arg unexpectedly null."));
                return;
              }
              const int64_t stream_type_arg =
                  encodable_stream_type_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->MuteLocalVideoStream(mute_arg, stream_type_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startAudioDump",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StartAudioDump();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startAudioDumpWithType",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_dump_type_arg = args.at(0);
              if (encodable_dump_type_arg.IsNull()) {
                reply(WrapError("dump_type_arg unexpectedly null."));
                return;
              }
              const int64_t dump_type_arg = encodable_dump_type_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->StartAudioDumpWithType(dump_type_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopAudioDump",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopAudioDump();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.enableAudioVolumeIndication",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const EnableAudioVolumeIndicationRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->EnableAudioVolumeIndication(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.adjustRecordingSignalVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->AdjustRecordingSignalVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.adjustPlaybackSignalVolume", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->AdjustPlaybackSignalVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.adjustLoopBackRecordingSignalVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->AdjustLoopBackRecordingSignalVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.addLiveStreamTask",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const AddOrUpdateLiveStreamTaskRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->AddLiveStreamTask(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.updateLiveStreamTask",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const AddOrUpdateLiveStreamTaskRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->UpdateLiveStreamTask(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.removeLiveStreamTask",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const DeleteLiveStreamTaskRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->RemoveLiveStreamTask(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setClientRole",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_role_arg = args.at(0);
              if (encodable_role_arg.IsNull()) {
                reply(WrapError("role_arg unexpectedly null."));
                return;
              }
              const int64_t role_arg = encodable_role_arg.LongValue();
              ErrorOr<int64_t> output = api->SetClientRole(role_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.getConnectionState",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetConnectionState();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.uploadSdkInfo",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->UploadSdkInfo();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.sendSEIMsg",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg = std::any_cast<const SendSEIMsgRequest&>(
                  std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SendSEIMsg(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setLocalVoiceReverbParam", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetLocalVoiceReverbParamRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetLocalVoiceReverbParam(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setAudioEffectPreset",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_preset_arg = args.at(0);
              if (encodable_preset_arg.IsNull()) {
                reply(WrapError("preset_arg unexpectedly null."));
                return;
              }
              const int64_t preset_arg = encodable_preset_arg.LongValue();
              ErrorOr<int64_t> output = api->SetAudioEffectPreset(preset_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setVoiceBeautifierPreset", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_preset_arg = args.at(0);
              if (encodable_preset_arg.IsNull()) {
                reply(WrapError("preset_arg unexpectedly null."));
                return;
              }
              const int64_t preset_arg = encodable_preset_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetVoiceBeautifierPreset(preset_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setLocalVoicePitch",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_pitch_arg = args.at(0);
              if (encodable_pitch_arg.IsNull()) {
                reply(WrapError("pitch_arg unexpectedly null."));
                return;
              }
              const auto& pitch_arg = std::get<double>(encodable_pitch_arg);
              ErrorOr<int64_t> output = api->SetLocalVoicePitch(pitch_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setLocalVoiceEqualization", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetLocalVoiceEqualizationRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetLocalVoiceEqualization(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.switchChannel",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SwitchChannelRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SwitchChannel(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startAudioRecording",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartAudioRecordingRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->StartAudioRecording(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.startAudioRecordingWithConfig",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const AudioRecordingConfigurationRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->StartAudioRecordingWithConfig(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopAudioRecording",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopAudioRecording();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setLocalMediaPriority",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetLocalMediaPriorityRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->SetLocalMediaPriority(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableMediaPub",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_media_type_arg = args.at(0);
              if (encodable_media_type_arg.IsNull()) {
                reply(WrapError("media_type_arg unexpectedly null."));
                return;
              }
              const int64_t media_type_arg =
                  encodable_media_type_arg.LongValue();
              const auto& encodable_enable_arg = args.at(1);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output =
                  api->EnableMediaPub(media_type_arg, enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startChannelMediaRelay",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartOrUpdateChannelMediaRelayRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->StartChannelMediaRelay(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.updateChannelMediaRelay", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartOrUpdateChannelMediaRelayRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->UpdateChannelMediaRelay(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopChannelMediaRelay",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopChannelMediaRelay();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.adjustUserPlaybackSignalVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const AdjustUserPlaybackSignalVolumeRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->AdjustUserPlaybackSignalVolume(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setLocalPublishFallbackOption",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_option_arg = args.at(0);
              if (encodable_option_arg.IsNull()) {
                reply(WrapError("option_arg unexpectedly null."));
                return;
              }
              const int64_t option_arg = encodable_option_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetLocalPublishFallbackOption(option_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setRemoteSubscribeFallbackOption",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_option_arg = args.at(0);
              if (encodable_option_arg.IsNull()) {
                reply(WrapError("option_arg unexpectedly null."));
                return;
              }
              const int64_t option_arg = encodable_option_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetRemoteSubscribeFallbackOption(option_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableSuperResolution",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output = api->EnableSuperResolution(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableEncryption",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const EnableEncryptionRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->EnableEncryption(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setAudioSessionOperationRestriction",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_option_arg = args.at(0);
              if (encodable_option_arg.IsNull()) {
                reply(WrapError("option_arg unexpectedly null."));
                return;
              }
              const int64_t option_arg = encodable_option_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetAudioSessionOperationRestriction(option_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableVideoCorrection",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output = api->EnableVideoCorrection(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.reportCustomEvent",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const ReportCustomEventRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->ReportCustomEvent(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.getEffectDuration",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->GetEffectDuration(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startLastmileProbeTest",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartLastmileProbeTestRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->StartLastmileProbeTest(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopLastmileProbeTest",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopLastmileProbeTest();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setVideoCorrectionConfig", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetVideoCorrectionConfigRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetVideoCorrectionConfig(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.enableVirtualBackground", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const EnableVirtualBackgroundRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->EnableVirtualBackground(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setRemoteHighPriorityAudioStream",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetRemoteHighPriorityAudioStreamRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetRemoteHighPriorityAudioStream(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setCloudProxy",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_proxy_type_arg = args.at(0);
              if (encodable_proxy_type_arg.IsNull()) {
                reply(WrapError("proxy_type_arg unexpectedly null."));
                return;
              }
              const int64_t proxy_type_arg =
                  encodable_proxy_type_arg.LongValue();
              ErrorOr<int64_t> output = api->SetCloudProxy(proxy_type_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.startBeauty",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StartBeauty();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.stopBeauty",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              std::optional<FlutterError> output = api->StopBeauty();
              if (output.has_value()) {
                reply(WrapError(output.value()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue());
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.enableBeauty",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enabled_arg = args.at(0);
              if (encodable_enabled_arg.IsNull()) {
                reply(WrapError("enabled_arg unexpectedly null."));
                return;
              }
              const auto& enabled_arg = std::get<bool>(encodable_enabled_arg);
              ErrorOr<int64_t> output = api->EnableBeauty(enabled_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setBeautyEffect",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_level_arg = args.at(0);
              if (encodable_level_arg.IsNull()) {
                reply(WrapError("level_arg unexpectedly null."));
                return;
              }
              const auto& level_arg = std::get<double>(encodable_level_arg);
              const auto& encodable_beauty_type_arg = args.at(1);
              if (encodable_beauty_type_arg.IsNull()) {
                reply(WrapError("beauty_type_arg unexpectedly null."));
                return;
              }
              const int64_t beauty_type_arg =
                  encodable_beauty_type_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetBeautyEffect(level_arg, beauty_type_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.addBeautyFilter",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_path_arg = args.at(0);
              if (encodable_path_arg.IsNull()) {
                reply(WrapError("path_arg unexpectedly null."));
                return;
              }
              const auto& path_arg = std::get<std::string>(encodable_path_arg);
              const auto& encodable_name_arg = args.at(1);
              if (encodable_name_arg.IsNull()) {
                reply(WrapError("name_arg unexpectedly null."));
                return;
              }
              const auto& name_arg = std::get<std::string>(encodable_name_arg);
              ErrorOr<int64_t> output =
                  api->AddBeautyFilter(path_arg, name_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.removeBeautyFilter",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              std::optional<FlutterError> output = api->RemoveBeautyFilter();
              if (output.has_value()) {
                reply(WrapError(output.value()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue());
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setBeautyFilterLevel",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_level_arg = args.at(0);
              if (encodable_level_arg.IsNull()) {
                reply(WrapError("level_arg unexpectedly null."));
                return;
              }
              const auto& level_arg = std::get<double>(encodable_level_arg);
              ErrorOr<int64_t> output = api->SetBeautyFilterLevel(level_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setLocalVideoWatermarkConfigs",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetLocalVideoWatermarkConfigsRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetLocalVideoWatermarkConfigs(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.EngineApi.setStreamAlignmentProperty", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output =
                  api->SetStreamAlignmentProperty(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.getNtpTimeOffset",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetNtpTimeOffset();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.takeLocalSnapshot",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_stream_type_arg = args.at(0);
              if (encodable_stream_type_arg.IsNull()) {
                reply(WrapError("stream_type_arg unexpectedly null."));
                return;
              }
              const int64_t stream_type_arg =
                  encodable_stream_type_arg.LongValue();
              const auto& encodable_path_arg = args.at(1);
              if (encodable_path_arg.IsNull()) {
                reply(WrapError("path_arg unexpectedly null."));
                return;
              }
              const auto& path_arg = std::get<std::string>(encodable_path_arg);
              ErrorOr<int64_t> output =
                  api->TakeLocalSnapshot(stream_type_arg, path_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.takeRemoteSnapshot",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_uid_arg = args.at(0);
              if (encodable_uid_arg.IsNull()) {
                reply(WrapError("uid_arg unexpectedly null."));
                return;
              }
              const int64_t uid_arg = encodable_uid_arg.LongValue();
              const auto& encodable_stream_type_arg = args.at(1);
              if (encodable_stream_type_arg.IsNull()) {
                reply(WrapError("stream_type_arg unexpectedly null."));
                return;
              }
              const int64_t stream_type_arg =
                  encodable_stream_type_arg.LongValue();
              const auto& encodable_path_arg = args.at(2);
              if (encodable_path_arg.IsNull()) {
                reply(WrapError("path_arg unexpectedly null."));
                return;
              }
              const auto& path_arg = std::get<std::string>(encodable_path_arg);
              ErrorOr<int64_t> output =
                  api->TakeRemoteSnapshot(uid_arg, stream_type_arg, path_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.setExternalVideoSource",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_stream_type_arg = args.at(0);
              if (encodable_stream_type_arg.IsNull()) {
                reply(WrapError("stream_type_arg unexpectedly null."));
                return;
              }
              const int64_t stream_type_arg =
                  encodable_stream_type_arg.LongValue();
              const auto& encodable_enable_arg = args.at(1);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output =
                  api->SetExternalVideoSource(stream_type_arg, enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.EngineApi.pushExternalVideoFrame",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_stream_type_arg = args.at(0);
              if (encodable_stream_type_arg.IsNull()) {
                reply(WrapError("stream_type_arg unexpectedly null."));
                return;
              }
              const int64_t stream_type_arg =
                  encodable_stream_type_arg.LongValue();
              const auto& encodable_frame_arg = args.at(1);
              if (encodable_frame_arg.IsNull()) {
                reply(WrapError("frame_arg unexpectedly null."));
                return;
              }
              const auto& frame_arg = std::any_cast<const VideoFrame&>(
                  std::get<CustomEncodableValue>(encodable_frame_arg));
              ErrorOr<int64_t> output =
                  api->PushExternalVideoFrame(stream_type_arg, frame_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

EncodableValue EngineApi::WrapError(std::string_view error_message) {
  return EncodableValue(
      EncodableList{EncodableValue(std::string(error_message)),
                    EncodableValue("Error"), EncodableValue()});
}

EncodableValue EngineApi::WrapError(const FlutterError& error) {
  return EncodableValue(EncodableList{EncodableValue(error.code()),
                                      EncodableValue(error.message()),
                                      error.details()});
}

/// The codec used by VideoRendererApi.
const flutter::StandardMessageCodec& VideoRendererApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &flutter::StandardCodecSerializer::GetInstance());
}

// Sets up an instance of `VideoRendererApi` to handle messages through the
// `binary_messenger`.
void VideoRendererApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                             VideoRendererApi* api) {
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.createVideoRenderer", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->CreateVideoRenderer();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.VideoRendererApi.setMirror",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_texture_id_arg = args.at(0);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              const auto& encodable_mirror_arg = args.at(1);
              if (encodable_mirror_arg.IsNull()) {
                reply(WrapError("mirror_arg unexpectedly null."));
                return;
              }
              const auto& mirror_arg = std::get<bool>(encodable_mirror_arg);
              ErrorOr<int64_t> output =
                  api->SetMirror(texture_id_arg, mirror_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.setupLocalVideoRenderer",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_texture_id_arg = args.at(0);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetupLocalVideoRenderer(texture_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.setupRemoteVideoRenderer",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_uid_arg = args.at(0);
              if (encodable_uid_arg.IsNull()) {
                reply(WrapError("uid_arg unexpectedly null."));
                return;
              }
              const int64_t uid_arg = encodable_uid_arg.LongValue();
              const auto& encodable_texture_id_arg = args.at(1);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetupRemoteVideoRenderer(uid_arg, texture_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.setupLocalSubStreamVideoRenderer",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_texture_id_arg = args.at(0);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetupLocalSubStreamVideoRenderer(texture_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.setupRemoteSubStreamVideoRenderer",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_uid_arg = args.at(0);
              if (encodable_uid_arg.IsNull()) {
                reply(WrapError("uid_arg unexpectedly null."));
                return;
              }
              const int64_t uid_arg = encodable_uid_arg.LongValue();
              const auto& encodable_texture_id_arg = args.at(1);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              ErrorOr<int64_t> output = api->SetupRemoteSubStreamVideoRenderer(
                  uid_arg, texture_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.VideoRendererApi.disposeVideoRenderer",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_texture_id_arg = args.at(0);
              if (encodable_texture_id_arg.IsNull()) {
                reply(WrapError("texture_id_arg unexpectedly null."));
                return;
              }
              const int64_t texture_id_arg =
                  encodable_texture_id_arg.LongValue();
              std::optional<FlutterError> output =
                  api->DisposeVideoRenderer(texture_id_arg);
              if (output.has_value()) {
                reply(WrapError(output.value()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue());
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

EncodableValue VideoRendererApi::WrapError(std::string_view error_message) {
  return EncodableValue(
      EncodableList{EncodableValue(std::string(error_message)),
                    EncodableValue("Error"), EncodableValue()});
}

EncodableValue VideoRendererApi::WrapError(const FlutterError& error) {
  return EncodableValue(EncodableList{EncodableValue(error.code()),
                                      EncodableValue(error.message()),
                                      error.details()});
}

NERtcDeviceEventSinkCodecSerializer::NERtcDeviceEventSinkCodecSerializer() {}

EncodableValue NERtcDeviceEventSinkCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(CGPoint::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void NERtcDeviceEventSinkCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(CGPoint)) {
      stream->WriteByte(128);
      WriteValue(EncodableValue(
                     std::any_cast<CGPoint>(*custom_value).ToEncodableList()),
                 stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcDeviceEventSink::NERtcDeviceEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcDeviceEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &NERtcDeviceEventSinkCodecSerializer::GetInstance());
}

void NERtcDeviceEventSink::OnAudioDeviceChanged(
    int64_t selected_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcDeviceEventSink.onAudioDeviceChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(selected_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcDeviceEventSink::OnAudioDeviceStateChange(
    int64_t device_type_arg, int64_t device_state_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcDeviceEventSink.onAudioDeviceStateChange",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(device_type_arg),
      EncodableValue(device_state_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcDeviceEventSink::OnVideoDeviceStateChange(
    int64_t device_type_arg, int64_t device_state_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcDeviceEventSink.onVideoDeviceStateChange",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(device_type_arg),
      EncodableValue(device_state_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcDeviceEventSink::OnCameraFocusChanged(
    const CGPoint& focus_point_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcDeviceEventSink.onCameraFocusChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(focus_point_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcDeviceEventSink::OnCameraExposureChanged(
    const CGPoint& exposure_point_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcDeviceEventSink.onCameraExposureChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      CustomEncodableValue(exposure_point_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

DeviceManagerApiCodecSerializer::DeviceManagerApiCodecSerializer() {}

EncodableValue DeviceManagerApiCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(SetCameraPositionRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void DeviceManagerApiCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(SetCameraPositionRequest)) {
      stream->WriteByte(128);
      WriteValue(
          EncodableValue(std::any_cast<SetCameraPositionRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

/// The codec used by DeviceManagerApi.
const flutter::StandardMessageCodec& DeviceManagerApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &DeviceManagerApiCodecSerializer::GetInstance());
}

// Sets up an instance of `DeviceManagerApi` to handle messages through the
// `binary_messenger`.
void DeviceManagerApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                             DeviceManagerApi* api) {
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isSpeakerphoneOn", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsSpeakerphoneOn();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isCameraZoomSupported",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsCameraZoomSupported();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isCameraTorchSupported",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsCameraTorchSupported();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isCameraFocusSupported",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsCameraFocusSupported();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isCameraExposurePositionSupported",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsCameraExposurePositionSupported();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setSpeakerphoneOn", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enable_arg = args.at(0);
              if (encodable_enable_arg.IsNull()) {
                reply(WrapError("enable_arg unexpectedly null."));
                return;
              }
              const auto& enable_arg = std::get<bool>(encodable_enable_arg);
              ErrorOr<int64_t> output = api->SetSpeakerphoneOn(enable_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.DeviceManagerApi.switchCamera",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->SwitchCamera();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setCameraZoomFactor", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_factor_arg = args.at(0);
              if (encodable_factor_arg.IsNull()) {
                reply(WrapError("factor_arg unexpectedly null."));
                return;
              }
              const auto& factor_arg = std::get<double>(encodable_factor_arg);
              ErrorOr<int64_t> output = api->SetCameraZoomFactor(factor_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.getCameraMaxZoom", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<double> output = api->GetCameraMaxZoom();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setCameraTorchOn", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_on_arg = args.at(0);
              if (encodable_on_arg.IsNull()) {
                reply(WrapError("on_arg unexpectedly null."));
                return;
              }
              const auto& on_arg = std::get<bool>(encodable_on_arg);
              ErrorOr<int64_t> output = api->SetCameraTorchOn(on_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setCameraFocusPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetCameraPositionRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetCameraFocusPosition(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setCameraExposurePosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const SetCameraPositionRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output =
                  api->SetCameraExposurePosition(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setPlayoutDeviceMute",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_mute_arg = args.at(0);
              if (encodable_mute_arg.IsNull()) {
                reply(WrapError("mute_arg unexpectedly null."));
                return;
              }
              const auto& mute_arg = std::get<bool>(encodable_mute_arg);
              ErrorOr<int64_t> output = api->SetPlayoutDeviceMute(mute_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isPlayoutDeviceMute", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsPlayoutDeviceMute();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setRecordDeviceMute", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_mute_arg = args.at(0);
              if (encodable_mute_arg.IsNull()) {
                reply(WrapError("mute_arg unexpectedly null."));
                return;
              }
              const auto& mute_arg = std::get<bool>(encodable_mute_arg);
              ErrorOr<int64_t> output = api->SetRecordDeviceMute(mute_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.isRecordDeviceMute", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<bool> output = api->IsRecordDeviceMute();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.DeviceManagerApi.enableEarback",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_enabled_arg = args.at(0);
              if (encodable_enabled_arg.IsNull()) {
                reply(WrapError("enabled_arg unexpectedly null."));
                return;
              }
              const auto& enabled_arg = std::get<bool>(encodable_enabled_arg);
              const auto& encodable_volume_arg = args.at(1);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->EnableEarback(enabled_arg, volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setEarbackVolume", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output = api->SetEarbackVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.setAudioFocusMode", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_focus_mode_arg = args.at(0);
              if (encodable_focus_mode_arg.IsNull()) {
                reply(WrapError("focus_mode_arg unexpectedly null."));
                return;
              }
              const int64_t focus_mode_arg =
                  encodable_focus_mode_arg.LongValue();
              ErrorOr<int64_t> output = api->SetAudioFocusMode(focus_mode_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.getCurrentCamera", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetCurrentCamera();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.switchCameraWithPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_position_arg = args.at(0);
              if (encodable_position_arg.IsNull()) {
                reply(WrapError("position_arg unexpectedly null."));
                return;
              }
              const int64_t position_arg = encodable_position_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SwitchCameraWithPosition(position_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.DeviceManagerApi.getCameraCurrentZoom",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetCameraCurrentZoom();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

EncodableValue DeviceManagerApi::WrapError(std::string_view error_message) {
  return EncodableValue(
      EncodableList{EncodableValue(std::string(error_message)),
                    EncodableValue("Error"), EncodableValue()});
}

EncodableValue DeviceManagerApi::WrapError(const FlutterError& error) {
  return EncodableValue(EncodableList{EncodableValue(error.code()),
                                      EncodableValue(error.message()),
                                      error.details()});
}

AudioMixingApiCodecSerializer::AudioMixingApiCodecSerializer() {}

EncodableValue AudioMixingApiCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(StartAudioMixingRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void AudioMixingApiCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(StartAudioMixingRequest)) {
      stream->WriteByte(128);
      WriteValue(
          EncodableValue(std::any_cast<StartAudioMixingRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

/// The codec used by AudioMixingApi.
const flutter::StandardMessageCodec& AudioMixingApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &AudioMixingApiCodecSerializer::GetInstance());
}

// Sets up an instance of `AudioMixingApi` to handle messages through the
// `binary_messenger`.
void AudioMixingApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                           AudioMixingApi* api) {
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioMixingApi.startAudioMixing",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg =
                  std::any_cast<const StartAudioMixingRequest&>(
                      std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->StartAudioMixing(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioMixingApi.stopAudioMixing",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopAudioMixing();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioMixingApi.pauseAudioMixing",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->PauseAudioMixing();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioMixingApi.resumeAudioMixing",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->ResumeAudioMixing();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.setAudioMixingSendVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetAudioMixingSendVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.getAudioMixingSendVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetAudioMixingSendVolume();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.setAudioMixingPlaybackVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_volume_arg = args.at(0);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetAudioMixingPlaybackVolume(volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.getAudioMixingPlaybackVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetAudioMixingPlaybackVolume();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.getAudioMixingDuration",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetAudioMixingDuration();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.getAudioMixingCurrentPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetAudioMixingCurrentPosition();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.setAudioMixingPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_position_arg = args.at(0);
              if (encodable_position_arg.IsNull()) {
                reply(WrapError("position_arg unexpectedly null."));
                return;
              }
              const int64_t position_arg = encodable_position_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetAudioMixingPosition(position_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.setAudioMixingPitch", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_pitch_arg = args.at(0);
              if (encodable_pitch_arg.IsNull()) {
                reply(WrapError("pitch_arg unexpectedly null."));
                return;
              }
              const int64_t pitch_arg = encodable_pitch_arg.LongValue();
              ErrorOr<int64_t> output = api->SetAudioMixingPitch(pitch_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioMixingApi.getAudioMixingPitch", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->GetAudioMixingPitch();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

EncodableValue AudioMixingApi::WrapError(std::string_view error_message) {
  return EncodableValue(
      EncodableList{EncodableValue(std::string(error_message)),
                    EncodableValue("Error"), EncodableValue()});
}

EncodableValue AudioMixingApi::WrapError(const FlutterError& error) {
  return EncodableValue(EncodableList{EncodableValue(error.code()),
                                      EncodableValue(error.message()),
                                      error.details()});
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcAudioMixingEventSink::NERtcAudioMixingEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcAudioMixingEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &flutter::StandardCodecSerializer::GetInstance());
}

void NERtcAudioMixingEventSink::OnAudioMixingStateChanged(
    int64_t reason_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcAudioMixingEventSink.onAudioMixingStateChanged",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(reason_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcAudioMixingEventSink::OnAudioMixingTimestampUpdate(
    int64_t timestamp_ms_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcAudioMixingEventSink."
      "onAudioMixingTimestampUpdate",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(timestamp_ms_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

AudioEffectApiCodecSerializer::AudioEffectApiCodecSerializer() {}

EncodableValue AudioEffectApiCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(PlayEffectRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void AudioEffectApiCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(PlayEffectRequest)) {
      stream->WriteByte(128);
      WriteValue(EncodableValue(std::any_cast<PlayEffectRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

/// The codec used by AudioEffectApi.
const flutter::StandardMessageCodec& AudioEffectApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &AudioEffectApiCodecSerializer::GetInstance());
}

// Sets up an instance of `AudioEffectApi` to handle messages through the
// `binary_messenger`.
void AudioEffectApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                           AudioEffectApi* api) {
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.playEffect",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_request_arg = args.at(0);
              if (encodable_request_arg.IsNull()) {
                reply(WrapError("request_arg unexpectedly null."));
                return;
              }
              const auto& request_arg = std::any_cast<const PlayEffectRequest&>(
                  std::get<CustomEncodableValue>(encodable_request_arg));
              ErrorOr<int64_t> output = api->PlayEffect(request_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.stopEffect",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->StopEffect(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.stopAllEffects",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->StopAllEffects();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.pauseEffect",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->PauseEffect(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.resumeEffect",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->ResumeEffect(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.pauseAllEffects",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->PauseAllEffects();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.resumeAllEffects",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              ErrorOr<int64_t> output = api->ResumeAllEffects();
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioEffectApi.setEffectSendVolume", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              const auto& encodable_volume_arg = args.at(1);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetEffectSendVolume(effect_id_arg, volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioEffectApi.getEffectSendVolume", &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->GetEffectSendVolume(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioEffectApi.setEffectPlaybackVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              const auto& encodable_volume_arg = args.at(1);
              if (encodable_volume_arg.IsNull()) {
                reply(WrapError("volume_arg unexpectedly null."));
                return;
              }
              const int64_t volume_arg = encodable_volume_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetEffectPlaybackVolume(effect_id_arg, volume_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioEffectApi.getEffectPlaybackVolume",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->GetEffectPlaybackVolume(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.getEffectDuration",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->GetEffectDuration(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger,
        "dev.flutter.pigeon.AudioEffectApi.getEffectCurrentPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->GetEffectCurrentPosition(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.setEffectPitch",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              const auto& encodable_pitch_arg = args.at(1);
              if (encodable_pitch_arg.IsNull()) {
                reply(WrapError("pitch_arg unexpectedly null."));
                return;
              }
              const int64_t pitch_arg = encodable_pitch_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetEffectPitch(effect_id_arg, pitch_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.getEffectPitch",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              ErrorOr<int64_t> output = api->GetEffectPitch(effect_id_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel = std::make_unique<BasicMessageChannel<>>(
        binary_messenger, "dev.flutter.pigeon.AudioEffectApi.setEffectPosition",
        &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const EncodableValue& message,
                const flutter::MessageReply<EncodableValue>& reply) {
            try {
              const auto& args = std::get<EncodableList>(message);
              const auto& encodable_effect_id_arg = args.at(0);
              if (encodable_effect_id_arg.IsNull()) {
                reply(WrapError("effect_id_arg unexpectedly null."));
                return;
              }
              const int64_t effect_id_arg = encodable_effect_id_arg.LongValue();
              const auto& encodable_position_arg = args.at(1);
              if (encodable_position_arg.IsNull()) {
                reply(WrapError("position_arg unexpectedly null."));
                return;
              }
              const int64_t position_arg = encodable_position_arg.LongValue();
              ErrorOr<int64_t> output =
                  api->SetEffectPosition(effect_id_arg, position_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              EncodableList wrapped;
              wrapped.push_back(EncodableValue(std::move(output).TakeValue()));
              reply(EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

EncodableValue AudioEffectApi::WrapError(std::string_view error_message) {
  return EncodableValue(
      EncodableList{EncodableValue(std::string(error_message)),
                    EncodableValue("Error"), EncodableValue()});
}

EncodableValue AudioEffectApi::WrapError(const FlutterError& error) {
  return EncodableValue(EncodableList{EncodableValue(error.code()),
                                      EncodableValue(error.message()),
                                      error.details()});
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcAudioEffectEventSink::NERtcAudioEffectEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcAudioEffectEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &flutter::StandardCodecSerializer::GetInstance());
}

void NERtcAudioEffectEventSink::OnAudioEffectFinished(
    int64_t effect_id_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcAudioEffectEventSink.onAudioEffectFinished",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(effect_id_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcAudioEffectEventSink::OnAudioEffectTimestampUpdate(
    int64_t id_arg, int64_t timestamp_ms_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcAudioEffectEventSink."
      "onAudioEffectTimestampUpdate",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(id_arg),
      EncodableValue(timestamp_ms_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

NERtcStatsEventSinkCodecSerializer::NERtcStatsEventSinkCodecSerializer() {}

EncodableValue NERtcStatsEventSinkCodecSerializer::ReadValueOfType(
    uint8_t type, flutter::ByteStreamReader* stream) const {
  switch (type) {
    case 128:
      return CustomEncodableValue(
          AddOrUpdateLiveStreamTaskRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 129:
      return CustomEncodableValue(
          AdjustUserPlaybackSignalVolumeRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 130:
      return CustomEncodableValue(
          AudioRecordingConfigurationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 131:
      return CustomEncodableValue(AudioVolumeInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 132:
      return CustomEncodableValue(CGPoint::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 133:
      return CustomEncodableValue(CreateEngineRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 134:
      return CustomEncodableValue(
          DeleteLiveStreamTaskRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 135:
      return CustomEncodableValue(
          EnableAudioVolumeIndicationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 136:
      return CustomEncodableValue(EnableEncryptionRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 137:
      return CustomEncodableValue(EnableLocalVideoRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 138:
      return CustomEncodableValue(
          EnableVirtualBackgroundRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 139:
      return CustomEncodableValue(
          FirstVideoDataReceivedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 140:
      return CustomEncodableValue(
          FirstVideoFrameDecodedEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 141:
      return CustomEncodableValue(JoinChannelOptions::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 142:
      return CustomEncodableValue(JoinChannelRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 143:
      return CustomEncodableValue(
          NERtcLastmileProbeOneWayResult::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 144:
      return CustomEncodableValue(NERtcLastmileProbeResult::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 145:
      return CustomEncodableValue(NERtcUserJoinExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 146:
      return CustomEncodableValue(NERtcUserLeaveExtraInfo::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 147:
      return CustomEncodableValue(NERtcVersion::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 148:
      return CustomEncodableValue(PlayEffectRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 149:
      return CustomEncodableValue(
          RemoteAudioVolumeIndicationEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 150:
      return CustomEncodableValue(ReportCustomEventRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 151:
      return CustomEncodableValue(RtcServerAddresses::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 152:
      return CustomEncodableValue(SendSEIMsgRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 153:
      return CustomEncodableValue(SetAudioProfileRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 154:
      return CustomEncodableValue(
          SetAudioSubscribeOnlyByRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 155:
      return CustomEncodableValue(
          SetCameraCaptureConfigRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 156:
      return CustomEncodableValue(SetCameraPositionRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 157:
      return CustomEncodableValue(
          SetLocalMediaPriorityRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 158:
      return CustomEncodableValue(SetLocalVideoConfigRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 159:
      return CustomEncodableValue(
          SetLocalVideoWatermarkConfigsRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 160:
      return CustomEncodableValue(
          SetLocalVoiceEqualizationRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 161:
      return CustomEncodableValue(
          SetLocalVoiceReverbParamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 162:
      return CustomEncodableValue(
          SetRemoteHighPriorityAudioStreamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 163:
      return CustomEncodableValue(
          SetVideoCorrectionConfigRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 164:
      return CustomEncodableValue(StartAudioMixingRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 165:
      return CustomEncodableValue(StartAudioRecordingRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 166:
      return CustomEncodableValue(
          StartLastmileProbeTestRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 167:
      return CustomEncodableValue(
          StartOrUpdateChannelMediaRelayRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 168:
      return CustomEncodableValue(StartScreenCaptureRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 169:
      return CustomEncodableValue(
          StartorStopVideoPreviewRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 170:
      return CustomEncodableValue(
          SubscribeRemoteAudioRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 171:
      return CustomEncodableValue(
          SubscribeRemoteSubStreamAudioRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 172:
      return CustomEncodableValue(
          SubscribeRemoteSubStreamVideoRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 173:
      return CustomEncodableValue(
          SubscribeRemoteVideoStreamRequest::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 174:
      return CustomEncodableValue(SwitchChannelRequest::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 175:
      return CustomEncodableValue(UserJoinedEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 176:
      return CustomEncodableValue(UserLeaveEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 177:
      return CustomEncodableValue(UserVideoMuteEvent::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 178:
      return CustomEncodableValue(VideoFrame::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 179:
      return CustomEncodableValue(VideoWatermarkConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 180:
      return CustomEncodableValue(VideoWatermarkImageConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 181:
      return CustomEncodableValue(VideoWatermarkTextConfig::FromEncodableList(
          std::get<EncodableList>(ReadValue(stream))));
    case 182:
      return CustomEncodableValue(
          VideoWatermarkTimestampConfig::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    case 183:
      return CustomEncodableValue(
          VirtualBackgroundSourceEnabledEvent::FromEncodableList(
              std::get<EncodableList>(ReadValue(stream))));
    default:
      return flutter::StandardCodecSerializer::ReadValueOfType(type, stream);
  }
}

void NERtcStatsEventSinkCodecSerializer::WriteValue(
    const EncodableValue& value, flutter::ByteStreamWriter* stream) const {
  if (const CustomEncodableValue* custom_value =
          std::get_if<CustomEncodableValue>(&value)) {
    if (custom_value->type() == typeid(AddOrUpdateLiveStreamTaskRequest)) {
      stream->WriteByte(128);
      WriteValue(EncodableValue(std::any_cast<AddOrUpdateLiveStreamTaskRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(AdjustUserPlaybackSignalVolumeRequest)) {
      stream->WriteByte(129);
      WriteValue(
          EncodableValue(std::any_cast<AdjustUserPlaybackSignalVolumeRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(AudioRecordingConfigurationRequest)) {
      stream->WriteByte(130);
      WriteValue(
          EncodableValue(
              std::any_cast<AudioRecordingConfigurationRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(AudioVolumeInfo)) {
      stream->WriteByte(131);
      WriteValue(
          EncodableValue(
              std::any_cast<AudioVolumeInfo>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(CGPoint)) {
      stream->WriteByte(132);
      WriteValue(EncodableValue(
                     std::any_cast<CGPoint>(*custom_value).ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(CreateEngineRequest)) {
      stream->WriteByte(133);
      WriteValue(
          EncodableValue(std::any_cast<CreateEngineRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(DeleteLiveStreamTaskRequest)) {
      stream->WriteByte(134);
      WriteValue(EncodableValue(
                     std::any_cast<DeleteLiveStreamTaskRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(EnableAudioVolumeIndicationRequest)) {
      stream->WriteByte(135);
      WriteValue(
          EncodableValue(
              std::any_cast<EnableAudioVolumeIndicationRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableEncryptionRequest)) {
      stream->WriteByte(136);
      WriteValue(
          EncodableValue(std::any_cast<EnableEncryptionRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableLocalVideoRequest)) {
      stream->WriteByte(137);
      WriteValue(
          EncodableValue(std::any_cast<EnableLocalVideoRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(EnableVirtualBackgroundRequest)) {
      stream->WriteByte(138);
      WriteValue(EncodableValue(std::any_cast<EnableVirtualBackgroundRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoDataReceivedEvent)) {
      stream->WriteByte(139);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoDataReceivedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(FirstVideoFrameDecodedEvent)) {
      stream->WriteByte(140);
      WriteValue(EncodableValue(
                     std::any_cast<FirstVideoFrameDecodedEvent>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(JoinChannelOptions)) {
      stream->WriteByte(141);
      WriteValue(EncodableValue(std::any_cast<JoinChannelOptions>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(JoinChannelRequest)) {
      stream->WriteByte(142);
      WriteValue(EncodableValue(std::any_cast<JoinChannelRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeOneWayResult)) {
      stream->WriteByte(143);
      WriteValue(EncodableValue(std::any_cast<NERtcLastmileProbeOneWayResult>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcLastmileProbeResult)) {
      stream->WriteByte(144);
      WriteValue(
          EncodableValue(std::any_cast<NERtcLastmileProbeResult>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserJoinExtraInfo)) {
      stream->WriteByte(145);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserJoinExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcUserLeaveExtraInfo)) {
      stream->WriteByte(146);
      WriteValue(
          EncodableValue(std::any_cast<NERtcUserLeaveExtraInfo>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(NERtcVersion)) {
      stream->WriteByte(147);
      WriteValue(
          EncodableValue(
              std::any_cast<NERtcVersion>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(PlayEffectRequest)) {
      stream->WriteByte(148);
      WriteValue(EncodableValue(std::any_cast<PlayEffectRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(RemoteAudioVolumeIndicationEvent)) {
      stream->WriteByte(149);
      WriteValue(EncodableValue(std::any_cast<RemoteAudioVolumeIndicationEvent>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(ReportCustomEventRequest)) {
      stream->WriteByte(150);
      WriteValue(
          EncodableValue(std::any_cast<ReportCustomEventRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(RtcServerAddresses)) {
      stream->WriteByte(151);
      WriteValue(EncodableValue(std::any_cast<RtcServerAddresses>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SendSEIMsgRequest)) {
      stream->WriteByte(152);
      WriteValue(EncodableValue(std::any_cast<SendSEIMsgRequest>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetAudioProfileRequest)) {
      stream->WriteByte(153);
      WriteValue(
          EncodableValue(std::any_cast<SetAudioProfileRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetAudioSubscribeOnlyByRequest)) {
      stream->WriteByte(154);
      WriteValue(EncodableValue(std::any_cast<SetAudioSubscribeOnlyByRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetCameraCaptureConfigRequest)) {
      stream->WriteByte(155);
      WriteValue(EncodableValue(
                     std::any_cast<SetCameraCaptureConfigRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetCameraPositionRequest)) {
      stream->WriteByte(156);
      WriteValue(
          EncodableValue(std::any_cast<SetCameraPositionRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalMediaPriorityRequest)) {
      stream->WriteByte(157);
      WriteValue(EncodableValue(
                     std::any_cast<SetLocalMediaPriorityRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVideoConfigRequest)) {
      stream->WriteByte(158);
      WriteValue(EncodableValue(
                     std::any_cast<SetLocalVideoConfigRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVideoWatermarkConfigsRequest)) {
      stream->WriteByte(159);
      WriteValue(
          EncodableValue(
              std::any_cast<SetLocalVideoWatermarkConfigsRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVoiceEqualizationRequest)) {
      stream->WriteByte(160);
      WriteValue(EncodableValue(std::any_cast<SetLocalVoiceEqualizationRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SetLocalVoiceReverbParamRequest)) {
      stream->WriteByte(161);
      WriteValue(EncodableValue(std::any_cast<SetLocalVoiceReverbParamRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() ==
        typeid(SetRemoteHighPriorityAudioStreamRequest)) {
      stream->WriteByte(162);
      WriteValue(
          EncodableValue(std::any_cast<SetRemoteHighPriorityAudioStreamRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SetVideoCorrectionConfigRequest)) {
      stream->WriteByte(163);
      WriteValue(EncodableValue(std::any_cast<SetVideoCorrectionConfigRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartAudioMixingRequest)) {
      stream->WriteByte(164);
      WriteValue(
          EncodableValue(std::any_cast<StartAudioMixingRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartAudioRecordingRequest)) {
      stream->WriteByte(165);
      WriteValue(EncodableValue(
                     std::any_cast<StartAudioRecordingRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartLastmileProbeTestRequest)) {
      stream->WriteByte(166);
      WriteValue(EncodableValue(
                     std::any_cast<StartLastmileProbeTestRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(StartOrUpdateChannelMediaRelayRequest)) {
      stream->WriteByte(167);
      WriteValue(
          EncodableValue(std::any_cast<StartOrUpdateChannelMediaRelayRequest>(
                             *custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartScreenCaptureRequest)) {
      stream->WriteByte(168);
      WriteValue(
          EncodableValue(std::any_cast<StartScreenCaptureRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(StartorStopVideoPreviewRequest)) {
      stream->WriteByte(169);
      WriteValue(EncodableValue(std::any_cast<StartorStopVideoPreviewRequest>(
                                    *custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteAudioRequest)) {
      stream->WriteByte(170);
      WriteValue(EncodableValue(
                     std::any_cast<SubscribeRemoteAudioRequest>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteSubStreamAudioRequest)) {
      stream->WriteByte(171);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteSubStreamAudioRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteSubStreamVideoRequest)) {
      stream->WriteByte(172);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteSubStreamVideoRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SubscribeRemoteVideoStreamRequest)) {
      stream->WriteByte(173);
      WriteValue(
          EncodableValue(
              std::any_cast<SubscribeRemoteVideoStreamRequest>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(SwitchChannelRequest)) {
      stream->WriteByte(174);
      WriteValue(
          EncodableValue(std::any_cast<SwitchChannelRequest>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserJoinedEvent)) {
      stream->WriteByte(175);
      WriteValue(
          EncodableValue(
              std::any_cast<UserJoinedEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserLeaveEvent)) {
      stream->WriteByte(176);
      WriteValue(
          EncodableValue(
              std::any_cast<UserLeaveEvent>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(UserVideoMuteEvent)) {
      stream->WriteByte(177);
      WriteValue(EncodableValue(std::any_cast<UserVideoMuteEvent>(*custom_value)
                                    .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(VideoFrame)) {
      stream->WriteByte(178);
      WriteValue(
          EncodableValue(
              std::any_cast<VideoFrame>(*custom_value).ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkConfig)) {
      stream->WriteByte(179);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkImageConfig)) {
      stream->WriteByte(180);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkImageConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkTextConfig)) {
      stream->WriteByte(181);
      WriteValue(
          EncodableValue(std::any_cast<VideoWatermarkTextConfig>(*custom_value)
                             .ToEncodableList()),
          stream);
      return;
    }
    if (custom_value->type() == typeid(VideoWatermarkTimestampConfig)) {
      stream->WriteByte(182);
      WriteValue(EncodableValue(
                     std::any_cast<VideoWatermarkTimestampConfig>(*custom_value)
                         .ToEncodableList()),
                 stream);
      return;
    }
    if (custom_value->type() == typeid(VirtualBackgroundSourceEnabledEvent)) {
      stream->WriteByte(183);
      WriteValue(
          EncodableValue(
              std::any_cast<VirtualBackgroundSourceEnabledEvent>(*custom_value)
                  .ToEncodableList()),
          stream);
      return;
    }
  }
  flutter::StandardCodecSerializer::WriteValue(value, stream);
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcStatsEventSink::NERtcStatsEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcStatsEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &NERtcStatsEventSinkCodecSerializer::GetInstance());
}

void NERtcStatsEventSink::OnRtcStats(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_, "dev.flutter.pigeon.NERtcStatsEventSink.onRtcStats",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcStatsEventSink::OnLocalAudioStats(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcStatsEventSink.onLocalAudioStats", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcStatsEventSink::OnRemoteAudioStats(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcStatsEventSink.onRemoteAudioStats", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcStatsEventSink::OnLocalVideoStats(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcStatsEventSink.onLocalVideoStats", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcStatsEventSink::OnRemoteVideoStats(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcStatsEventSink.onRemoteVideoStats", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcStatsEventSink::OnNetworkQuality(
    const EncodableMap& arguments_arg, std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcStatsEventSink.onNetworkQuality", &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(arguments_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

// Generated class from Pigeon that represents Flutter messages that can be
// called from C++.
NERtcLiveStreamEventSink::NERtcLiveStreamEventSink(
    flutter::BinaryMessenger* binary_messenger)
    : binary_messenger_(binary_messenger) {}

const flutter::StandardMessageCodec& NERtcLiveStreamEventSink::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &flutter::StandardCodecSerializer::GetInstance());
}

void NERtcLiveStreamEventSink::OnUpdateLiveStreamTask(
    const std::string& task_id_arg, int64_t err_code_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcLiveStreamEventSink.onUpdateLiveStreamTask",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(task_id_arg),
      EncodableValue(err_code_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcLiveStreamEventSink::OnAddLiveStreamTask(
    const std::string& task_id_arg, int64_t err_code_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcLiveStreamEventSink.onAddLiveStreamTask",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(task_id_arg),
      EncodableValue(err_code_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

void NERtcLiveStreamEventSink::OnDeleteLiveStreamTask(
    const std::string& task_id_arg, int64_t err_code_arg,
    std::function<void(void)>&& on_success,
    std::function<void(const FlutterError&)>&& on_error) {
  auto channel = std::make_unique<BasicMessageChannel<>>(
      binary_messenger_,
      "dev.flutter.pigeon.NERtcLiveStreamEventSink.onDeleteLiveStreamTask",
      &GetCodec());
  EncodableValue encoded_api_arguments = EncodableValue(EncodableList{
      EncodableValue(task_id_arg),
      EncodableValue(err_code_arg),
  });
  channel->Send(
      encoded_api_arguments,
      [on_success = std::move(on_success), on_error = std::move(on_error)](
          const uint8_t* reply, size_t reply_size) { on_success(); });
}

}  // namespace NEFLT
