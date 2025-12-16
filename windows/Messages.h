// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef PIGEON_MESSAGES_H_
#define PIGEON_MESSAGES_H_
#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>

#include <map>
#include <optional>
#include <string>

namespace NEFLT {

// Generated class from Pigeon.

class FlutterError {
 public:
  explicit FlutterError(const std::string &code) : code_(code) {}
  explicit FlutterError(const std::string &code, const std::string &message)
      : code_(code), message_(message) {}
  explicit FlutterError(const std::string &code, const std::string &message,
                        const flutter::EncodableValue &details)
      : code_(code), message_(message), details_(details) {}

  const std::string &code() const { return code_; }
  const std::string &message() const { return message_; }
  const flutter::EncodableValue &details() const { return details_; }

 private:
  std::string code_;
  std::string message_;
  flutter::EncodableValue details_;
};

template <class T>
class ErrorOr {
 public:
  ErrorOr(const T &rhs) : v_(rhs) {}
  ErrorOr(const T &&rhs) : v_(std::move(rhs)) {}
  ErrorOr(const FlutterError &rhs) : v_(rhs) {}
  ErrorOr(const FlutterError &&rhs) : v_(std::move(rhs)) {}

  bool has_error() const { return std::holds_alternative<FlutterError>(v_); }
  const T &value() const { return std::get<T>(v_); };
  const FlutterError &error() const { return std::get<FlutterError>(v_); };

 private:
  friend class NERtcChannelEventSink;
  friend class EngineApi;
  friend class VideoRendererApi;
  friend class NERtcDeviceEventSink;
  friend class DeviceManagerApi;
  friend class AudioMixingApi;
  friend class NERtcAudioMixingEventSink;
  friend class AudioEffectApi;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcStatsEventSink;
  friend class NERtcLiveStreamEventSink;
  ErrorOr() = default;
  T TakeValue() && { return std::get<T>(std::move(v_)); }

  std::variant<T, FlutterError> v_;
};

// 视频水印类型
enum class NERtcVideoWatermarkType {
  // 图片
  kNERtcVideoWatermarkTypeImage = 0,
  // 文字
  kNERtcVideoWatermarkTypeText = 1,
  // 时间戳
  kNERtcVideoWatermarkTypeTimeStamp = 2
};

// 摄像头额外旋转信息
enum class NERtcCaptureExtraRotation {
  // （默认）没有额外的旋转信息，直接使用系统旋转参数处理
  kNERtcCaptureExtraRotationDefault = 0,
  // 在系统旋转信息的基础上，额外顺时针旋转90度
  kNERtcCaptureExtraRotationClockWise90 = 1,
  // 在系统旋转信息的基础上，额外旋转180度
  kNERtcCaptureExtraRotation180 = 2,
  // 在系统旋转信息的基础上，额外逆时针旋转90度
  kNERtcCaptureExtraRotationAntiClockWise90 = 3
};

// onUserJoined 回调的一些可选信息
//
// Generated class from Pigeon that represents data sent in messages.
class NERtcUserJoinExtraInfo {
 public:
  // Constructs an object setting all fields.
  explicit NERtcUserJoinExtraInfo(const std::string &custom_info);

  // 自定义信息， 来源于远端用户joinChannel时填的
  // [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。
  const std::string &custom_info() const;
  void set_custom_info(std::string_view value_arg);

 private:
  static NERtcUserJoinExtraInfo FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class UserJoinedEvent;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::string custom_info_;
};

// onUserLeave 回调的一些可选信息
//
// Generated class from Pigeon that represents data sent in messages.
class NERtcUserLeaveExtraInfo {
 public:
  // Constructs an object setting all fields.
  explicit NERtcUserLeaveExtraInfo(const std::string &custom_info);

  // 自定义信息, 来源于远端用户joinChannel时填的
  // [NERtcJoinChannelOptions.customInfo]参数，默认为空字符串。
  const std::string &custom_info() const;
  void set_custom_info(std::string_view value_arg);

 private:
  static NERtcUserLeaveExtraInfo FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class UserLeaveEvent;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::string custom_info_;
};

// Generated class from Pigeon that represents data sent in messages.
class UserJoinedEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit UserJoinedEvent(int64_t uid);

  // Constructs an object setting all fields.
  explicit UserJoinedEvent(int64_t uid, const NERtcUserJoinExtraInfo *join_extra_info);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  const NERtcUserJoinExtraInfo *join_extra_info() const;
  void set_join_extra_info(const NERtcUserJoinExtraInfo *value_arg);
  void set_join_extra_info(const NERtcUserJoinExtraInfo &value_arg);

 private:
  static UserJoinedEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  std::optional<NERtcUserJoinExtraInfo> join_extra_info_;
};

// Generated class from Pigeon that represents data sent in messages.
class UserLeaveEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit UserLeaveEvent(int64_t uid, int64_t reason);

  // Constructs an object setting all fields.
  explicit UserLeaveEvent(int64_t uid, int64_t reason,
                          const NERtcUserLeaveExtraInfo *leave_extra_info);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  int64_t reason() const;
  void set_reason(int64_t value_arg);

  const NERtcUserLeaveExtraInfo *leave_extra_info() const;
  void set_leave_extra_info(const NERtcUserLeaveExtraInfo *value_arg);
  void set_leave_extra_info(const NERtcUserLeaveExtraInfo &value_arg);

 private:
  static UserLeaveEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  int64_t reason_;
  std::optional<NERtcUserLeaveExtraInfo> leave_extra_info_;
};

// Generated class from Pigeon that represents data sent in messages.
class UserVideoMuteEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit UserVideoMuteEvent(int64_t uid, bool muted);

  // Constructs an object setting all fields.
  explicit UserVideoMuteEvent(int64_t uid, bool muted, const int64_t *stream_type);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  bool muted() const;
  void set_muted(bool value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static UserVideoMuteEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  bool muted_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class FirstVideoDataReceivedEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit FirstVideoDataReceivedEvent(int64_t uid);

  // Constructs an object setting all fields.
  explicit FirstVideoDataReceivedEvent(int64_t uid, const int64_t *stream_type);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static FirstVideoDataReceivedEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class FirstVideoFrameDecodedEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit FirstVideoFrameDecodedEvent(int64_t uid, int64_t width, int64_t height);

  // Constructs an object setting all fields.
  explicit FirstVideoFrameDecodedEvent(int64_t uid, int64_t width, int64_t height,
                                       const int64_t *stream_type);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  int64_t width() const;
  void set_width(int64_t value_arg);

  int64_t height() const;
  void set_height(int64_t value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static FirstVideoFrameDecodedEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  int64_t width_;
  int64_t height_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class VirtualBackgroundSourceEnabledEvent {
 public:
  // Constructs an object setting all fields.
  explicit VirtualBackgroundSourceEnabledEvent(bool enabled, int64_t reason);

  bool enabled() const;
  void set_enabled(bool value_arg);

  int64_t reason() const;
  void set_reason(int64_t value_arg);

 private:
  static VirtualBackgroundSourceEnabledEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  bool enabled_;
  int64_t reason_;
};

// Generated class from Pigeon that represents data sent in messages.
class AudioVolumeInfo {
 public:
  // Constructs an object setting all fields.
  explicit AudioVolumeInfo(int64_t uid, int64_t volume, int64_t sub_stream_volume);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  int64_t volume() const;
  void set_volume(int64_t value_arg);

  int64_t sub_stream_volume() const;
  void set_sub_stream_volume(int64_t value_arg);

 private:
  static AudioVolumeInfo FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t uid_;
  int64_t volume_;
  int64_t sub_stream_volume_;
};

// Generated class from Pigeon that represents data sent in messages.
class RemoteAudioVolumeIndicationEvent {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit RemoteAudioVolumeIndicationEvent(int64_t total_volume);

  // Constructs an object setting all fields.
  explicit RemoteAudioVolumeIndicationEvent(const flutter::EncodableList *volume_list,
                                            int64_t total_volume);

  const flutter::EncodableList *volume_list() const;
  void set_volume_list(const flutter::EncodableList *value_arg);
  void set_volume_list(const flutter::EncodableList &value_arg);

  int64_t total_volume() const;
  void set_total_volume(int64_t value_arg);

 private:
  static RemoteAudioVolumeIndicationEvent FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<flutter::EncodableList> volume_list_;
  int64_t total_volume_;
};

// 上下行 Last mile 网络质量探测结果
//
// Generated class from Pigeon that represents data sent in messages.
class NERtcLastmileProbeResult {
 public:
  // Constructs an object setting all fields.
  explicit NERtcLastmileProbeResult(int64_t state, int64_t rtt,
                                    const NERtcLastmileProbeOneWayResult &uplink_report,
                                    const NERtcLastmileProbeOneWayResult &downlink_report);

  // Last mile 质量探测结果的状态, 详细参数见 [NERtcLastmileProbeResultState]
  int64_t state() const;
  void set_state(int64_t value_arg);

  // 往返时延，单位为毫秒(ms)
  int64_t rtt() const;
  void set_rtt(int64_t value_arg);

  // 上行网络质量报告
  const NERtcLastmileProbeOneWayResult &uplink_report() const;
  void set_uplink_report(const NERtcLastmileProbeOneWayResult &value_arg);

  // 下行网络质量报告
  const NERtcLastmileProbeOneWayResult &downlink_report() const;
  void set_downlink_report(const NERtcLastmileProbeOneWayResult &value_arg);

 private:
  static NERtcLastmileProbeResult FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t state_;
  int64_t rtt_;
  NERtcLastmileProbeOneWayResult uplink_report_;
  NERtcLastmileProbeOneWayResult downlink_report_;
};

// 单向 Last mile 网络质量探测结果报告
//
// Generated class from Pigeon that represents data sent in messages.
class NERtcLastmileProbeOneWayResult {
 public:
  // Constructs an object setting all fields.
  explicit NERtcLastmileProbeOneWayResult(int64_t packet_loss_rate, int64_t jitter,
                                          int64_t available_bandwidth);

  // 丢包率
  int64_t packet_loss_rate() const;
  void set_packet_loss_rate(int64_t value_arg);

  // 网络抖动，单位为毫秒 (ms)
  int64_t jitter() const;
  void set_jitter(int64_t value_arg);

  // 可用网络带宽预估，单位为 bps
  int64_t available_bandwidth() const;
  void set_available_bandwidth(int64_t value_arg);

 private:
  static NERtcLastmileProbeOneWayResult FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcLastmileProbeResult;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t packet_loss_rate_;
  int64_t jitter_;
  int64_t available_bandwidth_;
};

// Generated class from Pigeon that represents data sent in messages.
class RtcServerAddresses {
 public:
  // Constructs an object setting all non-nullable fields.
  RtcServerAddresses();

  // Constructs an object setting all fields.
  explicit RtcServerAddresses(
      const bool *valid, const std::string *channel_server, const std::string *statistics_server,
      const std::string *room_server, const std::string *compat_server,
      const std::string *nos_lbs_server, const std::string *nos_upload_sever,
      const std::string *nos_token_server, const std::string *sdk_config_server,
      const std::string *cloud_proxy_server, const std::string *web_socket_proxy_server,
      const std::string *quic_proxy_server, const std::string *media_proxy_server,
      const std::string *statistics_dispatch_server, const std::string *statistics_backup_server,
      const bool *use_i_pv6);

  const bool *valid() const;
  void set_valid(const bool *value_arg);
  void set_valid(bool value_arg);

  const std::string *channel_server() const;
  void set_channel_server(const std::string_view *value_arg);
  void set_channel_server(std::string_view value_arg);

  const std::string *statistics_server() const;
  void set_statistics_server(const std::string_view *value_arg);
  void set_statistics_server(std::string_view value_arg);

  const std::string *room_server() const;
  void set_room_server(const std::string_view *value_arg);
  void set_room_server(std::string_view value_arg);

  const std::string *compat_server() const;
  void set_compat_server(const std::string_view *value_arg);
  void set_compat_server(std::string_view value_arg);

  const std::string *nos_lbs_server() const;
  void set_nos_lbs_server(const std::string_view *value_arg);
  void set_nos_lbs_server(std::string_view value_arg);

  const std::string *nos_upload_sever() const;
  void set_nos_upload_sever(const std::string_view *value_arg);
  void set_nos_upload_sever(std::string_view value_arg);

  const std::string *nos_token_server() const;
  void set_nos_token_server(const std::string_view *value_arg);
  void set_nos_token_server(std::string_view value_arg);

  const std::string *sdk_config_server() const;
  void set_sdk_config_server(const std::string_view *value_arg);
  void set_sdk_config_server(std::string_view value_arg);

  const std::string *cloud_proxy_server() const;
  void set_cloud_proxy_server(const std::string_view *value_arg);
  void set_cloud_proxy_server(std::string_view value_arg);

  const std::string *web_socket_proxy_server() const;
  void set_web_socket_proxy_server(const std::string_view *value_arg);
  void set_web_socket_proxy_server(std::string_view value_arg);

  const std::string *quic_proxy_server() const;
  void set_quic_proxy_server(const std::string_view *value_arg);
  void set_quic_proxy_server(std::string_view value_arg);

  const std::string *media_proxy_server() const;
  void set_media_proxy_server(const std::string_view *value_arg);
  void set_media_proxy_server(std::string_view value_arg);

  const std::string *statistics_dispatch_server() const;
  void set_statistics_dispatch_server(const std::string_view *value_arg);
  void set_statistics_dispatch_server(std::string_view value_arg);

  const std::string *statistics_backup_server() const;
  void set_statistics_backup_server(const std::string_view *value_arg);
  void set_statistics_backup_server(std::string_view value_arg);

  const bool *use_i_pv6() const;
  void set_use_i_pv6(const bool *value_arg);
  void set_use_i_pv6(bool value_arg);

 private:
  static RtcServerAddresses FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class CreateEngineRequest;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> valid_;
  std::optional<std::string> channel_server_;
  std::optional<std::string> statistics_server_;
  std::optional<std::string> room_server_;
  std::optional<std::string> compat_server_;
  std::optional<std::string> nos_lbs_server_;
  std::optional<std::string> nos_upload_sever_;
  std::optional<std::string> nos_token_server_;
  std::optional<std::string> sdk_config_server_;
  std::optional<std::string> cloud_proxy_server_;
  std::optional<std::string> web_socket_proxy_server_;
  std::optional<std::string> quic_proxy_server_;
  std::optional<std::string> media_proxy_server_;
  std::optional<std::string> statistics_dispatch_server_;
  std::optional<std::string> statistics_backup_server_;
  std::optional<bool> use_i_pv6_;
};

// Generated class from Pigeon that represents data sent in messages.
class CreateEngineRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  CreateEngineRequest();

  // Constructs an object setting all fields.
  explicit CreateEngineRequest(const std::string *app_key, const std::string *log_dir,
                               const RtcServerAddresses *server_addresses, const int64_t *log_level,
                               const bool *audio_auto_subscribe, const bool *video_auto_subscribe,
                               const bool *disable_first_join_user_create_channel,
                               const bool *audio_disable_override_speaker_on_receiver,
                               const bool *audio_disable_s_w_a_e_c_on_headset,
                               const bool *audio_a_i_n_s_enabled, const bool *server_record_audio,
                               const bool *server_record_video, const int64_t *server_record_mode,
                               const bool *server_record_speaker, const bool *publish_self_stream,
                               const bool *video_capture_observer_enabled,
                               const int64_t *video_encode_mode, const int64_t *video_decode_mode,
                               const int64_t *video_send_mode, const bool *video_h265_enabled,
                               const bool *mode1v1_enabled, const std::string *app_group);

  const std::string *app_key() const;
  void set_app_key(const std::string_view *value_arg);
  void set_app_key(std::string_view value_arg);

  const std::string *log_dir() const;
  void set_log_dir(const std::string_view *value_arg);
  void set_log_dir(std::string_view value_arg);

  const RtcServerAddresses *server_addresses() const;
  void set_server_addresses(const RtcServerAddresses *value_arg);
  void set_server_addresses(const RtcServerAddresses &value_arg);

  const int64_t *log_level() const;
  void set_log_level(const int64_t *value_arg);
  void set_log_level(int64_t value_arg);

  const bool *audio_auto_subscribe() const;
  void set_audio_auto_subscribe(const bool *value_arg);
  void set_audio_auto_subscribe(bool value_arg);

  const bool *video_auto_subscribe() const;
  void set_video_auto_subscribe(const bool *value_arg);
  void set_video_auto_subscribe(bool value_arg);

  const bool *disable_first_join_user_create_channel() const;
  void set_disable_first_join_user_create_channel(const bool *value_arg);
  void set_disable_first_join_user_create_channel(bool value_arg);

  const bool *audio_disable_override_speaker_on_receiver() const;
  void set_audio_disable_override_speaker_on_receiver(const bool *value_arg);
  void set_audio_disable_override_speaker_on_receiver(bool value_arg);

  const bool *audio_disable_s_w_a_e_c_on_headset() const;
  void set_audio_disable_s_w_a_e_c_on_headset(const bool *value_arg);
  void set_audio_disable_s_w_a_e_c_on_headset(bool value_arg);

  const bool *audio_a_i_n_s_enabled() const;
  void set_audio_a_i_n_s_enabled(const bool *value_arg);
  void set_audio_a_i_n_s_enabled(bool value_arg);

  const bool *server_record_audio() const;
  void set_server_record_audio(const bool *value_arg);
  void set_server_record_audio(bool value_arg);

  const bool *server_record_video() const;
  void set_server_record_video(const bool *value_arg);
  void set_server_record_video(bool value_arg);

  const int64_t *server_record_mode() const;
  void set_server_record_mode(const int64_t *value_arg);
  void set_server_record_mode(int64_t value_arg);

  const bool *server_record_speaker() const;
  void set_server_record_speaker(const bool *value_arg);
  void set_server_record_speaker(bool value_arg);

  const bool *publish_self_stream() const;
  void set_publish_self_stream(const bool *value_arg);
  void set_publish_self_stream(bool value_arg);

  const bool *video_capture_observer_enabled() const;
  void set_video_capture_observer_enabled(const bool *value_arg);
  void set_video_capture_observer_enabled(bool value_arg);

  const int64_t *video_encode_mode() const;
  void set_video_encode_mode(const int64_t *value_arg);
  void set_video_encode_mode(int64_t value_arg);

  const int64_t *video_decode_mode() const;
  void set_video_decode_mode(const int64_t *value_arg);
  void set_video_decode_mode(int64_t value_arg);

  const int64_t *video_send_mode() const;
  void set_video_send_mode(const int64_t *value_arg);
  void set_video_send_mode(int64_t value_arg);

  const bool *video_h265_enabled() const;
  void set_video_h265_enabled(const bool *value_arg);
  void set_video_h265_enabled(bool value_arg);

  const bool *mode1v1_enabled() const;
  void set_mode1v1_enabled(const bool *value_arg);
  void set_mode1v1_enabled(bool value_arg);

  const std::string *app_group() const;
  void set_app_group(const std::string_view *value_arg);
  void set_app_group(std::string_view value_arg);

 private:
  static CreateEngineRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> app_key_;
  std::optional<std::string> log_dir_;
  std::optional<RtcServerAddresses> server_addresses_;
  std::optional<int64_t> log_level_;
  std::optional<bool> audio_auto_subscribe_;
  std::optional<bool> video_auto_subscribe_;
  std::optional<bool> disable_first_join_user_create_channel_;
  std::optional<bool> audio_disable_override_speaker_on_receiver_;
  std::optional<bool> audio_disable_s_w_a_e_c_on_headset_;
  std::optional<bool> audio_a_i_n_s_enabled_;
  std::optional<bool> server_record_audio_;
  std::optional<bool> server_record_video_;
  std::optional<int64_t> server_record_mode_;
  std::optional<bool> server_record_speaker_;
  std::optional<bool> publish_self_stream_;
  std::optional<bool> video_capture_observer_enabled_;
  std::optional<int64_t> video_encode_mode_;
  std::optional<int64_t> video_decode_mode_;
  std::optional<int64_t> video_send_mode_;
  std::optional<bool> video_h265_enabled_;
  std::optional<bool> mode1v1_enabled_;
  std::optional<std::string> app_group_;
};

// Generated class from Pigeon that represents data sent in messages.
class JoinChannelOptions {
 public:
  // Constructs an object setting all non-nullable fields.
  JoinChannelOptions();

  // Constructs an object setting all fields.
  explicit JoinChannelOptions(const std::string *custom_info, const std::string *permission_key);

  const std::string *custom_info() const;
  void set_custom_info(const std::string_view *value_arg);
  void set_custom_info(std::string_view value_arg);

  const std::string *permission_key() const;
  void set_permission_key(const std::string_view *value_arg);
  void set_permission_key(std::string_view value_arg);

 private:
  static JoinChannelOptions FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class JoinChannelRequest;
  friend class SwitchChannelRequest;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> custom_info_;
  std::optional<std::string> permission_key_;
};

// Generated class from Pigeon that represents data sent in messages.
class JoinChannelRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit JoinChannelRequest(const std::string &channel_name, int64_t uid);

  // Constructs an object setting all fields.
  explicit JoinChannelRequest(const std::string *token, const std::string &channel_name,
                              int64_t uid, const JoinChannelOptions *channel_options);

  const std::string *token() const;
  void set_token(const std::string_view *value_arg);
  void set_token(std::string_view value_arg);

  const std::string &channel_name() const;
  void set_channel_name(std::string_view value_arg);

  int64_t uid() const;
  void set_uid(int64_t value_arg);

  const JoinChannelOptions *channel_options() const;
  void set_channel_options(const JoinChannelOptions *value_arg);
  void set_channel_options(const JoinChannelOptions &value_arg);

 private:
  static JoinChannelRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> token_;
  std::string channel_name_;
  int64_t uid_;
  std::optional<JoinChannelOptions> channel_options_;
};

// Generated class from Pigeon that represents data sent in messages.
class SubscribeRemoteAudioRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SubscribeRemoteAudioRequest();

  // Constructs an object setting all fields.
  explicit SubscribeRemoteAudioRequest(const int64_t *uid, const bool *subscribe);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

  const bool *subscribe() const;
  void set_subscribe(const bool *value_arg);
  void set_subscribe(bool value_arg);

 private:
  static SubscribeRemoteAudioRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> uid_;
  std::optional<bool> subscribe_;
};

// Generated class from Pigeon that represents data sent in messages.
class EnableLocalVideoRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  EnableLocalVideoRequest();

  // Constructs an object setting all fields.
  explicit EnableLocalVideoRequest(const bool *enable, const int64_t *stream_type);

  const bool *enable() const;
  void set_enable(const bool *value_arg);
  void set_enable(bool value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static EnableLocalVideoRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> enable_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetAudioProfileRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetAudioProfileRequest();

  // Constructs an object setting all fields.
  explicit SetAudioProfileRequest(const int64_t *profile, const int64_t *scenario);

  const int64_t *profile() const;
  void set_profile(const int64_t *value_arg);
  void set_profile(int64_t value_arg);

  const int64_t *scenario() const;
  void set_scenario(const int64_t *value_arg);
  void set_scenario(int64_t value_arg);

 private:
  static SetAudioProfileRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> profile_;
  std::optional<int64_t> scenario_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetLocalVideoConfigRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetLocalVideoConfigRequest();

  // Constructs an object setting all fields.
  explicit SetLocalVideoConfigRequest(const int64_t *video_profile, const int64_t *video_crop_mode,
                                      const bool *front_camera, const int64_t *frame_rate,
                                      const int64_t *min_frame_rate, const int64_t *bitrate,
                                      const int64_t *min_bitrate, const int64_t *degradation_prefer,
                                      const int64_t *width, const int64_t *height,
                                      const int64_t *camera_type, const int64_t *mirror_mode,
                                      const int64_t *orientation_mode, const int64_t *stream_type);

  const int64_t *video_profile() const;
  void set_video_profile(const int64_t *value_arg);
  void set_video_profile(int64_t value_arg);

  const int64_t *video_crop_mode() const;
  void set_video_crop_mode(const int64_t *value_arg);
  void set_video_crop_mode(int64_t value_arg);

  const bool *front_camera() const;
  void set_front_camera(const bool *value_arg);
  void set_front_camera(bool value_arg);

  const int64_t *frame_rate() const;
  void set_frame_rate(const int64_t *value_arg);
  void set_frame_rate(int64_t value_arg);

  const int64_t *min_frame_rate() const;
  void set_min_frame_rate(const int64_t *value_arg);
  void set_min_frame_rate(int64_t value_arg);

  const int64_t *bitrate() const;
  void set_bitrate(const int64_t *value_arg);
  void set_bitrate(int64_t value_arg);

  const int64_t *min_bitrate() const;
  void set_min_bitrate(const int64_t *value_arg);
  void set_min_bitrate(int64_t value_arg);

  const int64_t *degradation_prefer() const;
  void set_degradation_prefer(const int64_t *value_arg);
  void set_degradation_prefer(int64_t value_arg);

  const int64_t *width() const;
  void set_width(const int64_t *value_arg);
  void set_width(int64_t value_arg);

  const int64_t *height() const;
  void set_height(const int64_t *value_arg);
  void set_height(int64_t value_arg);

  const int64_t *camera_type() const;
  void set_camera_type(const int64_t *value_arg);
  void set_camera_type(int64_t value_arg);

  const int64_t *mirror_mode() const;
  void set_mirror_mode(const int64_t *value_arg);
  void set_mirror_mode(int64_t value_arg);

  const int64_t *orientation_mode() const;
  void set_orientation_mode(const int64_t *value_arg);
  void set_orientation_mode(int64_t value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static SetLocalVideoConfigRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> video_profile_;
  std::optional<int64_t> video_crop_mode_;
  std::optional<bool> front_camera_;
  std::optional<int64_t> frame_rate_;
  std::optional<int64_t> min_frame_rate_;
  std::optional<int64_t> bitrate_;
  std::optional<int64_t> min_bitrate_;
  std::optional<int64_t> degradation_prefer_;
  std::optional<int64_t> width_;
  std::optional<int64_t> height_;
  std::optional<int64_t> camera_type_;
  std::optional<int64_t> mirror_mode_;
  std::optional<int64_t> orientation_mode_;
  std::optional<int64_t> stream_type_;
};

// 摄像头采集配置
//
// Generated class from Pigeon that represents data sent in messages.
class SetCameraCaptureConfigRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetCameraCaptureConfigRequest();

  // Constructs an object setting all fields.
  explicit SetCameraCaptureConfigRequest(const NERtcCaptureExtraRotation *extra_rotation,
                                         const int64_t *capture_width,
                                         const int64_t *capture_height, const int64_t *stream_type);

  // 设置摄像头的额外旋转信息
  const NERtcCaptureExtraRotation *extra_rotation() const;
  void set_extra_rotation(const NERtcCaptureExtraRotation *value_arg);
  void set_extra_rotation(const NERtcCaptureExtraRotation &value_arg);

  // 本地采集的视频宽度，单位为 px。
  //
  // 视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
  //
  // captureWidth 表示视频帧在横轴上的像素，即自定义宽。
  const int64_t *capture_width() const;
  void set_capture_width(const int64_t *value_arg);
  void set_capture_width(int64_t value_arg);

  // 本地采集的视频宽度，单位为 px。
  //
  // 视频编码分辨率以宽 x 高表示，用于设置视频编码分辨率，以衡量编码质量。
  //
  // captureHeight 表示视频帧在横轴上的像素，即自定义高。
  const int64_t *capture_height() const;
  void set_capture_height(const int64_t *value_arg);
  void set_capture_height(int64_t value_arg);

  // 视频流类型
  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static SetCameraCaptureConfigRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<NERtcCaptureExtraRotation> extra_rotation_;
  std::optional<int64_t> capture_width_;
  std::optional<int64_t> capture_height_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartorStopVideoPreviewRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartorStopVideoPreviewRequest();

  // Constructs an object setting all fields.
  explicit StartorStopVideoPreviewRequest(const int64_t *stream_type);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static StartorStopVideoPreviewRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartScreenCaptureRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartScreenCaptureRequest();

  // Constructs an object setting all fields.
  explicit StartScreenCaptureRequest(const int64_t *content_prefer, const int64_t *video_profile,
                                     const int64_t *frame_rate, const int64_t *min_frame_rate,
                                     const int64_t *bitrate, const int64_t *min_bitrate,
                                     const flutter::EncodableMap *dict);

  const int64_t *content_prefer() const;
  void set_content_prefer(const int64_t *value_arg);
  void set_content_prefer(int64_t value_arg);

  const int64_t *video_profile() const;
  void set_video_profile(const int64_t *value_arg);
  void set_video_profile(int64_t value_arg);

  const int64_t *frame_rate() const;
  void set_frame_rate(const int64_t *value_arg);
  void set_frame_rate(int64_t value_arg);

  const int64_t *min_frame_rate() const;
  void set_min_frame_rate(const int64_t *value_arg);
  void set_min_frame_rate(int64_t value_arg);

  const int64_t *bitrate() const;
  void set_bitrate(const int64_t *value_arg);
  void set_bitrate(int64_t value_arg);

  const int64_t *min_bitrate() const;
  void set_min_bitrate(const int64_t *value_arg);
  void set_min_bitrate(int64_t value_arg);

  const flutter::EncodableMap *dict() const;
  void set_dict(const flutter::EncodableMap *value_arg);
  void set_dict(const flutter::EncodableMap &value_arg);

 private:
  static StartScreenCaptureRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> content_prefer_;
  std::optional<int64_t> video_profile_;
  std::optional<int64_t> frame_rate_;
  std::optional<int64_t> min_frame_rate_;
  std::optional<int64_t> bitrate_;
  std::optional<int64_t> min_bitrate_;
  std::optional<flutter::EncodableMap> dict_;
};

// Generated class from Pigeon that represents data sent in messages.
class SubscribeRemoteVideoStreamRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SubscribeRemoteVideoStreamRequest();

  // Constructs an object setting all fields.
  explicit SubscribeRemoteVideoStreamRequest(const int64_t *uid, const int64_t *stream_type,
                                             const bool *subscribe);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

  const bool *subscribe() const;
  void set_subscribe(const bool *value_arg);
  void set_subscribe(bool value_arg);

 private:
  static SubscribeRemoteVideoStreamRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> uid_;
  std::optional<int64_t> stream_type_;
  std::optional<bool> subscribe_;
};

// Generated class from Pigeon that represents data sent in messages.
class SubscribeRemoteSubStreamVideoRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SubscribeRemoteSubStreamVideoRequest();

  // Constructs an object setting all fields.
  explicit SubscribeRemoteSubStreamVideoRequest(const int64_t *uid, const bool *subscribe);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

  const bool *subscribe() const;
  void set_subscribe(const bool *value_arg);
  void set_subscribe(bool value_arg);

 private:
  static SubscribeRemoteSubStreamVideoRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> uid_;
  std::optional<bool> subscribe_;
};

// Generated class from Pigeon that represents data sent in messages.
class EnableAudioVolumeIndicationRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  EnableAudioVolumeIndicationRequest();

  // Constructs an object setting all fields.
  explicit EnableAudioVolumeIndicationRequest(const bool *enable, const int64_t *interval,
                                              const bool *vad);

  const bool *enable() const;
  void set_enable(const bool *value_arg);
  void set_enable(bool value_arg);

  const int64_t *interval() const;
  void set_interval(const int64_t *value_arg);
  void set_interval(int64_t value_arg);

  const bool *vad() const;
  void set_vad(const bool *value_arg);
  void set_vad(bool value_arg);

 private:
  static EnableAudioVolumeIndicationRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> enable_;
  std::optional<int64_t> interval_;
  std::optional<bool> vad_;
};

// Generated class from Pigeon that represents data sent in messages.
class SubscribeRemoteSubStreamAudioRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SubscribeRemoteSubStreamAudioRequest();

  // Constructs an object setting all fields.
  explicit SubscribeRemoteSubStreamAudioRequest(const bool *subscribe, const int64_t *uid);

  const bool *subscribe() const;
  void set_subscribe(const bool *value_arg);
  void set_subscribe(bool value_arg);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

 private:
  static SubscribeRemoteSubStreamAudioRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> subscribe_;
  std::optional<int64_t> uid_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetAudioSubscribeOnlyByRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetAudioSubscribeOnlyByRequest();

  // Constructs an object setting all fields.
  explicit SetAudioSubscribeOnlyByRequest(const flutter::EncodableList *uid_array);

  const flutter::EncodableList *uid_array() const;
  void set_uid_array(const flutter::EncodableList *value_arg);
  void set_uid_array(const flutter::EncodableList &value_arg);

 private:
  static SetAudioSubscribeOnlyByRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<flutter::EncodableList> uid_array_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartAudioMixingRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartAudioMixingRequest();

  // Constructs an object setting all fields.
  explicit StartAudioMixingRequest(const std::string *path, const int64_t *loop_count,
                                   const bool *send_enabled, const int64_t *send_volume,
                                   const bool *playback_enabled, const int64_t *playback_volume,
                                   const int64_t *start_time_stamp,
                                   const int64_t *send_with_audio_type,
                                   const int64_t *progress_interval);

  const std::string *path() const;
  void set_path(const std::string_view *value_arg);
  void set_path(std::string_view value_arg);

  const int64_t *loop_count() const;
  void set_loop_count(const int64_t *value_arg);
  void set_loop_count(int64_t value_arg);

  const bool *send_enabled() const;
  void set_send_enabled(const bool *value_arg);
  void set_send_enabled(bool value_arg);

  const int64_t *send_volume() const;
  void set_send_volume(const int64_t *value_arg);
  void set_send_volume(int64_t value_arg);

  const bool *playback_enabled() const;
  void set_playback_enabled(const bool *value_arg);
  void set_playback_enabled(bool value_arg);

  const int64_t *playback_volume() const;
  void set_playback_volume(const int64_t *value_arg);
  void set_playback_volume(int64_t value_arg);

  const int64_t *start_time_stamp() const;
  void set_start_time_stamp(const int64_t *value_arg);
  void set_start_time_stamp(int64_t value_arg);

  const int64_t *send_with_audio_type() const;
  void set_send_with_audio_type(const int64_t *value_arg);
  void set_send_with_audio_type(int64_t value_arg);

  const int64_t *progress_interval() const;
  void set_progress_interval(const int64_t *value_arg);
  void set_progress_interval(int64_t value_arg);

 private:
  static StartAudioMixingRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> path_;
  std::optional<int64_t> loop_count_;
  std::optional<bool> send_enabled_;
  std::optional<int64_t> send_volume_;
  std::optional<bool> playback_enabled_;
  std::optional<int64_t> playback_volume_;
  std::optional<int64_t> start_time_stamp_;
  std::optional<int64_t> send_with_audio_type_;
  std::optional<int64_t> progress_interval_;
};

// Generated class from Pigeon that represents data sent in messages.
class PlayEffectRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  PlayEffectRequest();

  // Constructs an object setting all fields.
  explicit PlayEffectRequest(const int64_t *effect_id, const std::string *path,
                             const int64_t *loop_count, const bool *send_enabled,
                             const int64_t *send_volume, const bool *playback_enabled,
                             const int64_t *playback_volume, const int64_t *start_timestamp,
                             const int64_t *send_with_audio_type, const int64_t *progress_interval);

  const int64_t *effect_id() const;
  void set_effect_id(const int64_t *value_arg);
  void set_effect_id(int64_t value_arg);

  const std::string *path() const;
  void set_path(const std::string_view *value_arg);
  void set_path(std::string_view value_arg);

  const int64_t *loop_count() const;
  void set_loop_count(const int64_t *value_arg);
  void set_loop_count(int64_t value_arg);

  const bool *send_enabled() const;
  void set_send_enabled(const bool *value_arg);
  void set_send_enabled(bool value_arg);

  const int64_t *send_volume() const;
  void set_send_volume(const int64_t *value_arg);
  void set_send_volume(int64_t value_arg);

  const bool *playback_enabled() const;
  void set_playback_enabled(const bool *value_arg);
  void set_playback_enabled(bool value_arg);

  const int64_t *playback_volume() const;
  void set_playback_volume(const int64_t *value_arg);
  void set_playback_volume(int64_t value_arg);

  const int64_t *start_timestamp() const;
  void set_start_timestamp(const int64_t *value_arg);
  void set_start_timestamp(int64_t value_arg);

  const int64_t *send_with_audio_type() const;
  void set_send_with_audio_type(const int64_t *value_arg);
  void set_send_with_audio_type(int64_t value_arg);

  const int64_t *progress_interval() const;
  void set_progress_interval(const int64_t *value_arg);
  void set_progress_interval(int64_t value_arg);

 private:
  static PlayEffectRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> effect_id_;
  std::optional<std::string> path_;
  std::optional<int64_t> loop_count_;
  std::optional<bool> send_enabled_;
  std::optional<int64_t> send_volume_;
  std::optional<bool> playback_enabled_;
  std::optional<int64_t> playback_volume_;
  std::optional<int64_t> start_timestamp_;
  std::optional<int64_t> send_with_audio_type_;
  std::optional<int64_t> progress_interval_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetCameraPositionRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetCameraPositionRequest();

  // Constructs an object setting all fields.
  explicit SetCameraPositionRequest(const double *x, const double *y);

  const double *x() const;
  void set_x(const double *value_arg);
  void set_x(double value_arg);

  const double *y() const;
  void set_y(const double *value_arg);
  void set_y(double value_arg);

 private:
  static SetCameraPositionRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<double> x_;
  std::optional<double> y_;
};

// Generated class from Pigeon that represents data sent in messages.
class AddOrUpdateLiveStreamTaskRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  AddOrUpdateLiveStreamTaskRequest();

  // Constructs an object setting all fields.
  explicit AddOrUpdateLiveStreamTaskRequest(
      const int64_t *serial, const std::string *task_id, const std::string *url,
      const bool *server_record_enabled, const int64_t *live_mode, const int64_t *layout_width,
      const int64_t *layout_height, const int64_t *layout_background_color,
      const std::string *layout_image_url, const int64_t *layout_image_x,
      const int64_t *layout_image_y, const int64_t *layout_image_width,
      const int64_t *layout_image_height,
      const flutter::EncodableList *layout_user_transcoding_list);

  const int64_t *serial() const;
  void set_serial(const int64_t *value_arg);
  void set_serial(int64_t value_arg);

  const std::string *task_id() const;
  void set_task_id(const std::string_view *value_arg);
  void set_task_id(std::string_view value_arg);

  const std::string *url() const;
  void set_url(const std::string_view *value_arg);
  void set_url(std::string_view value_arg);

  const bool *server_record_enabled() const;
  void set_server_record_enabled(const bool *value_arg);
  void set_server_record_enabled(bool value_arg);

  const int64_t *live_mode() const;
  void set_live_mode(const int64_t *value_arg);
  void set_live_mode(int64_t value_arg);

  const int64_t *layout_width() const;
  void set_layout_width(const int64_t *value_arg);
  void set_layout_width(int64_t value_arg);

  const int64_t *layout_height() const;
  void set_layout_height(const int64_t *value_arg);
  void set_layout_height(int64_t value_arg);

  const int64_t *layout_background_color() const;
  void set_layout_background_color(const int64_t *value_arg);
  void set_layout_background_color(int64_t value_arg);

  const std::string *layout_image_url() const;
  void set_layout_image_url(const std::string_view *value_arg);
  void set_layout_image_url(std::string_view value_arg);

  const int64_t *layout_image_x() const;
  void set_layout_image_x(const int64_t *value_arg);
  void set_layout_image_x(int64_t value_arg);

  const int64_t *layout_image_y() const;
  void set_layout_image_y(const int64_t *value_arg);
  void set_layout_image_y(int64_t value_arg);

  const int64_t *layout_image_width() const;
  void set_layout_image_width(const int64_t *value_arg);
  void set_layout_image_width(int64_t value_arg);

  const int64_t *layout_image_height() const;
  void set_layout_image_height(const int64_t *value_arg);
  void set_layout_image_height(int64_t value_arg);

  const flutter::EncodableList *layout_user_transcoding_list() const;
  void set_layout_user_transcoding_list(const flutter::EncodableList *value_arg);
  void set_layout_user_transcoding_list(const flutter::EncodableList &value_arg);

 private:
  static AddOrUpdateLiveStreamTaskRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> serial_;
  std::optional<std::string> task_id_;
  std::optional<std::string> url_;
  std::optional<bool> server_record_enabled_;
  std::optional<int64_t> live_mode_;
  std::optional<int64_t> layout_width_;
  std::optional<int64_t> layout_height_;
  std::optional<int64_t> layout_background_color_;
  std::optional<std::string> layout_image_url_;
  std::optional<int64_t> layout_image_x_;
  std::optional<int64_t> layout_image_y_;
  std::optional<int64_t> layout_image_width_;
  std::optional<int64_t> layout_image_height_;
  std::optional<flutter::EncodableList> layout_user_transcoding_list_;
};

// Generated class from Pigeon that represents data sent in messages.
class DeleteLiveStreamTaskRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  DeleteLiveStreamTaskRequest();

  // Constructs an object setting all fields.
  explicit DeleteLiveStreamTaskRequest(const int64_t *serial, const std::string *task_id);

  const int64_t *serial() const;
  void set_serial(const int64_t *value_arg);
  void set_serial(int64_t value_arg);

  const std::string *task_id() const;
  void set_task_id(const std::string_view *value_arg);
  void set_task_id(std::string_view value_arg);

 private:
  static DeleteLiveStreamTaskRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> serial_;
  std::optional<std::string> task_id_;
};

// Generated class from Pigeon that represents data sent in messages.
class SendSEIMsgRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SendSEIMsgRequest();

  // Constructs an object setting all fields.
  explicit SendSEIMsgRequest(const std::string *sei_msg, const int64_t *stream_type);

  const std::string *sei_msg() const;
  void set_sei_msg(const std::string_view *value_arg);
  void set_sei_msg(std::string_view value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static SendSEIMsgRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> sei_msg_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetLocalVoiceEqualizationRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetLocalVoiceEqualizationRequest();

  // Constructs an object setting all fields.
  explicit SetLocalVoiceEqualizationRequest(const int64_t *band_frequency,
                                            const int64_t *band_gain);

  const int64_t *band_frequency() const;
  void set_band_frequency(const int64_t *value_arg);
  void set_band_frequency(int64_t value_arg);

  const int64_t *band_gain() const;
  void set_band_gain(const int64_t *value_arg);
  void set_band_gain(int64_t value_arg);

 private:
  static SetLocalVoiceEqualizationRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> band_frequency_;
  std::optional<int64_t> band_gain_;
};

// Generated class from Pigeon that represents data sent in messages.
class SwitchChannelRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SwitchChannelRequest();

  // Constructs an object setting all fields.
  explicit SwitchChannelRequest(const std::string *token, const std::string *channel_name,
                                const JoinChannelOptions *channel_options);

  const std::string *token() const;
  void set_token(const std::string_view *value_arg);
  void set_token(std::string_view value_arg);

  const std::string *channel_name() const;
  void set_channel_name(const std::string_view *value_arg);
  void set_channel_name(std::string_view value_arg);

  const JoinChannelOptions *channel_options() const;
  void set_channel_options(const JoinChannelOptions *value_arg);
  void set_channel_options(const JoinChannelOptions &value_arg);

 private:
  static SwitchChannelRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> token_;
  std::optional<std::string> channel_name_;
  std::optional<JoinChannelOptions> channel_options_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartAudioRecordingRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartAudioRecordingRequest();

  // Constructs an object setting all fields.
  explicit StartAudioRecordingRequest(const std::string *file_path, const int64_t *sample_rate,
                                      const int64_t *quality);

  const std::string *file_path() const;
  void set_file_path(const std::string_view *value_arg);
  void set_file_path(std::string_view value_arg);

  const int64_t *sample_rate() const;
  void set_sample_rate(const int64_t *value_arg);
  void set_sample_rate(int64_t value_arg);

  const int64_t *quality() const;
  void set_quality(const int64_t *value_arg);
  void set_quality(int64_t value_arg);

 private:
  static StartAudioRecordingRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> file_path_;
  std::optional<int64_t> sample_rate_;
  std::optional<int64_t> quality_;
};

// Generated class from Pigeon that represents data sent in messages.
class AudioRecordingConfigurationRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  AudioRecordingConfigurationRequest();

  // Constructs an object setting all fields.
  explicit AudioRecordingConfigurationRequest(const std::string *file_path,
                                              const int64_t *sample_rate, const int64_t *quality,
                                              const int64_t *position, const int64_t *cycle_time);

  const std::string *file_path() const;
  void set_file_path(const std::string_view *value_arg);
  void set_file_path(std::string_view value_arg);

  const int64_t *sample_rate() const;
  void set_sample_rate(const int64_t *value_arg);
  void set_sample_rate(int64_t value_arg);

  const int64_t *quality() const;
  void set_quality(const int64_t *value_arg);
  void set_quality(int64_t value_arg);

  const int64_t *position() const;
  void set_position(const int64_t *value_arg);
  void set_position(int64_t value_arg);

  const int64_t *cycle_time() const;
  void set_cycle_time(const int64_t *value_arg);
  void set_cycle_time(int64_t value_arg);

 private:
  static AudioRecordingConfigurationRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> file_path_;
  std::optional<int64_t> sample_rate_;
  std::optional<int64_t> quality_;
  std::optional<int64_t> position_;
  std::optional<int64_t> cycle_time_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetLocalMediaPriorityRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetLocalMediaPriorityRequest();

  // Constructs an object setting all fields.
  explicit SetLocalMediaPriorityRequest(const int64_t *priority, const bool *is_preemptive);

  const int64_t *priority() const;
  void set_priority(const int64_t *value_arg);
  void set_priority(int64_t value_arg);

  const bool *is_preemptive() const;
  void set_is_preemptive(const bool *value_arg);
  void set_is_preemptive(bool value_arg);

 private:
  static SetLocalMediaPriorityRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> priority_;
  std::optional<bool> is_preemptive_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartOrUpdateChannelMediaRelayRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartOrUpdateChannelMediaRelayRequest();

  // Constructs an object setting all fields.
  explicit StartOrUpdateChannelMediaRelayRequest(const flutter::EncodableMap *source_media_info,
                                                 const flutter::EncodableMap *dest_media_info);

  const flutter::EncodableMap *source_media_info() const;
  void set_source_media_info(const flutter::EncodableMap *value_arg);
  void set_source_media_info(const flutter::EncodableMap &value_arg);

  const flutter::EncodableMap *dest_media_info() const;
  void set_dest_media_info(const flutter::EncodableMap *value_arg);
  void set_dest_media_info(const flutter::EncodableMap &value_arg);

 private:
  static StartOrUpdateChannelMediaRelayRequest FromEncodableList(
      const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<flutter::EncodableMap> source_media_info_;
  std::optional<flutter::EncodableMap> dest_media_info_;
};

// Generated class from Pigeon that represents data sent in messages.
class AdjustUserPlaybackSignalVolumeRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  AdjustUserPlaybackSignalVolumeRequest();

  // Constructs an object setting all fields.
  explicit AdjustUserPlaybackSignalVolumeRequest(const int64_t *uid, const int64_t *volume);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

  const int64_t *volume() const;
  void set_volume(const int64_t *value_arg);
  void set_volume(int64_t value_arg);

 private:
  static AdjustUserPlaybackSignalVolumeRequest FromEncodableList(
      const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> uid_;
  std::optional<int64_t> volume_;
};

// Generated class from Pigeon that represents data sent in messages.
class EnableEncryptionRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  EnableEncryptionRequest();

  // Constructs an object setting all fields.
  explicit EnableEncryptionRequest(const std::string *key, const int64_t *mode, const bool *enable);

  const std::string *key() const;
  void set_key(const std::string_view *value_arg);
  void set_key(std::string_view value_arg);

  const int64_t *mode() const;
  void set_mode(const int64_t *value_arg);
  void set_mode(int64_t value_arg);

  const bool *enable() const;
  void set_enable(const bool *value_arg);
  void set_enable(bool value_arg);

 private:
  static EnableEncryptionRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> key_;
  std::optional<int64_t> mode_;
  std::optional<bool> enable_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetLocalVoiceReverbParamRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetLocalVoiceReverbParamRequest();

  // Constructs an object setting all fields.
  explicit SetLocalVoiceReverbParamRequest(const double *wet_gain, const double *dry_gain,
                                           const double *damping, const double *room_size,
                                           const double *decay_time, const double *pre_delay);

  const double *wet_gain() const;
  void set_wet_gain(const double *value_arg);
  void set_wet_gain(double value_arg);

  const double *dry_gain() const;
  void set_dry_gain(const double *value_arg);
  void set_dry_gain(double value_arg);

  const double *damping() const;
  void set_damping(const double *value_arg);
  void set_damping(double value_arg);

  const double *room_size() const;
  void set_room_size(const double *value_arg);
  void set_room_size(double value_arg);

  const double *decay_time() const;
  void set_decay_time(const double *value_arg);
  void set_decay_time(double value_arg);

  const double *pre_delay() const;
  void set_pre_delay(const double *value_arg);
  void set_pre_delay(double value_arg);

 private:
  static SetLocalVoiceReverbParamRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<double> wet_gain_;
  std::optional<double> dry_gain_;
  std::optional<double> damping_;
  std::optional<double> room_size_;
  std::optional<double> decay_time_;
  std::optional<double> pre_delay_;
};

// Generated class from Pigeon that represents data sent in messages.
class ReportCustomEventRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  ReportCustomEventRequest();

  // Constructs an object setting all fields.
  explicit ReportCustomEventRequest(const std::string *event_name,
                                    const std::string *custom_identify,
                                    const flutter::EncodableMap *param);

  const std::string *event_name() const;
  void set_event_name(const std::string_view *value_arg);
  void set_event_name(std::string_view value_arg);

  const std::string *custom_identify() const;
  void set_custom_identify(const std::string_view *value_arg);
  void set_custom_identify(std::string_view value_arg);

  const flutter::EncodableMap *param() const;
  void set_param(const flutter::EncodableMap *value_arg);
  void set_param(const flutter::EncodableMap &value_arg);

 private:
  static ReportCustomEventRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> event_name_;
  std::optional<std::string> custom_identify_;
  std::optional<flutter::EncodableMap> param_;
};

// Generated class from Pigeon that represents data sent in messages.
class StartLastmileProbeTestRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  StartLastmileProbeTestRequest();

  // Constructs an object setting all fields.
  explicit StartLastmileProbeTestRequest(const bool *probe_uplink, const bool *probe_downlink,
                                         const int64_t *expected_uplink_bitrate,
                                         const int64_t *expected_downlink_bitrate);

  const bool *probe_uplink() const;
  void set_probe_uplink(const bool *value_arg);
  void set_probe_uplink(bool value_arg);

  const bool *probe_downlink() const;
  void set_probe_downlink(const bool *value_arg);
  void set_probe_downlink(bool value_arg);

  const int64_t *expected_uplink_bitrate() const;
  void set_expected_uplink_bitrate(const int64_t *value_arg);
  void set_expected_uplink_bitrate(int64_t value_arg);

  const int64_t *expected_downlink_bitrate() const;
  void set_expected_downlink_bitrate(const int64_t *value_arg);
  void set_expected_downlink_bitrate(int64_t value_arg);

 private:
  static StartLastmileProbeTestRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> probe_uplink_;
  std::optional<bool> probe_downlink_;
  std::optional<int64_t> expected_uplink_bitrate_;
  std::optional<int64_t> expected_downlink_bitrate_;
};

// 顶点坐标
//
// Generated class from Pigeon that represents data sent in messages.
class CGPoint {
 public:
  // Constructs an object setting all fields.
  explicit CGPoint(double x, double y);

  // x 的 取值范围是 &#91; 0-1 &#93;
  double x() const;
  void set_x(double value_arg);

  // y 的 取值范围是 &#91; 0-1 &#93;
  double y() const;
  void set_y(double value_arg);

 private:
  static CGPoint FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class SetVideoCorrectionConfigRequest;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  double x_;
  double y_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetVideoCorrectionConfigRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetVideoCorrectionConfigRequest();

  // Constructs an object setting all fields.
  explicit SetVideoCorrectionConfigRequest(const CGPoint *top_left, const CGPoint *top_right,
                                           const CGPoint *bottom_left, const CGPoint *bottom_right,
                                           const double *canvas_width, const double *canvas_height,
                                           const bool *enable_mirror);

  const CGPoint *top_left() const;
  void set_top_left(const CGPoint *value_arg);
  void set_top_left(const CGPoint &value_arg);

  const CGPoint *top_right() const;
  void set_top_right(const CGPoint *value_arg);
  void set_top_right(const CGPoint &value_arg);

  const CGPoint *bottom_left() const;
  void set_bottom_left(const CGPoint *value_arg);
  void set_bottom_left(const CGPoint &value_arg);

  const CGPoint *bottom_right() const;
  void set_bottom_right(const CGPoint *value_arg);
  void set_bottom_right(const CGPoint &value_arg);

  const double *canvas_width() const;
  void set_canvas_width(const double *value_arg);
  void set_canvas_width(double value_arg);

  const double *canvas_height() const;
  void set_canvas_height(const double *value_arg);
  void set_canvas_height(double value_arg);

  const bool *enable_mirror() const;
  void set_enable_mirror(const bool *value_arg);
  void set_enable_mirror(bool value_arg);

 private:
  static SetVideoCorrectionConfigRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<CGPoint> top_left_;
  std::optional<CGPoint> top_right_;
  std::optional<CGPoint> bottom_left_;
  std::optional<CGPoint> bottom_right_;
  std::optional<double> canvas_width_;
  std::optional<double> canvas_height_;
  std::optional<bool> enable_mirror_;
};

// Generated class from Pigeon that represents data sent in messages.
class EnableVirtualBackgroundRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  EnableVirtualBackgroundRequest();

  // Constructs an object setting all fields.
  explicit EnableVirtualBackgroundRequest(const bool *enabled,
                                          const int64_t *background_source_type,
                                          const int64_t *color, const std::string *source,
                                          const int64_t *blur_degree);

  const bool *enabled() const;
  void set_enabled(const bool *value_arg);
  void set_enabled(bool value_arg);

  const int64_t *background_source_type() const;
  void set_background_source_type(const int64_t *value_arg);
  void set_background_source_type(int64_t value_arg);

  const int64_t *color() const;
  void set_color(const int64_t *value_arg);
  void set_color(int64_t value_arg);

  const std::string *source() const;
  void set_source(const std::string_view *value_arg);
  void set_source(std::string_view value_arg);

  const int64_t *blur_degree() const;
  void set_blur_degree(const int64_t *value_arg);
  void set_blur_degree(int64_t value_arg);

 private:
  static EnableVirtualBackgroundRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> enabled_;
  std::optional<int64_t> background_source_type_;
  std::optional<int64_t> color_;
  std::optional<std::string> source_;
  std::optional<int64_t> blur_degree_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetRemoteHighPriorityAudioStreamRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  SetRemoteHighPriorityAudioStreamRequest();

  // Constructs an object setting all fields.
  explicit SetRemoteHighPriorityAudioStreamRequest(const bool *enabled, const int64_t *uid,
                                                   const int64_t *stream_type);

  const bool *enabled() const;
  void set_enabled(const bool *value_arg);
  void set_enabled(bool value_arg);

  const int64_t *uid() const;
  void set_uid(const int64_t *value_arg);
  void set_uid(int64_t value_arg);

  const int64_t *stream_type() const;
  void set_stream_type(const int64_t *value_arg);
  void set_stream_type(int64_t value_arg);

 private:
  static SetRemoteHighPriorityAudioStreamRequest FromEncodableList(
      const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<bool> enabled_;
  std::optional<int64_t> uid_;
  std::optional<int64_t> stream_type_;
};

// Generated class from Pigeon that represents data sent in messages.
class VideoWatermarkImageConfig {
 public:
  // Constructs an object setting all non-nullable fields.
  VideoWatermarkImageConfig();

  // Constructs an object setting all fields.
  explicit VideoWatermarkImageConfig(const double *wm_alpha, const int64_t *wm_width,
                                     const int64_t *wm_height, const int64_t *offset_x,
                                     const int64_t *offset_y,
                                     const flutter::EncodableList *image_paths, const int64_t *fps,
                                     const bool *loop);

  const double *wm_alpha() const;
  void set_wm_alpha(const double *value_arg);
  void set_wm_alpha(double value_arg);

  const int64_t *wm_width() const;
  void set_wm_width(const int64_t *value_arg);
  void set_wm_width(int64_t value_arg);

  const int64_t *wm_height() const;
  void set_wm_height(const int64_t *value_arg);
  void set_wm_height(int64_t value_arg);

  const int64_t *offset_x() const;
  void set_offset_x(const int64_t *value_arg);
  void set_offset_x(int64_t value_arg);

  const int64_t *offset_y() const;
  void set_offset_y(const int64_t *value_arg);
  void set_offset_y(int64_t value_arg);

  const flutter::EncodableList *image_paths() const;
  void set_image_paths(const flutter::EncodableList *value_arg);
  void set_image_paths(const flutter::EncodableList &value_arg);

  const int64_t *fps() const;
  void set_fps(const int64_t *value_arg);
  void set_fps(int64_t value_arg);

  const bool *loop() const;
  void set_loop(const bool *value_arg);
  void set_loop(bool value_arg);

 private:
  static VideoWatermarkImageConfig FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class VideoWatermarkConfig;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<double> wm_alpha_;
  std::optional<int64_t> wm_width_;
  std::optional<int64_t> wm_height_;
  std::optional<int64_t> offset_x_;
  std::optional<int64_t> offset_y_;
  std::optional<flutter::EncodableList> image_paths_;
  std::optional<int64_t> fps_;
  std::optional<bool> loop_;
};

// Generated class from Pigeon that represents data sent in messages.
class VideoWatermarkTextConfig {
 public:
  // Constructs an object setting all non-nullable fields.
  VideoWatermarkTextConfig();

  // Constructs an object setting all fields.
  explicit VideoWatermarkTextConfig(const double *wm_alpha, const int64_t *wm_width,
                                    const int64_t *wm_height, const int64_t *offset_x,
                                    const int64_t *offset_y, const int64_t *wm_color,
                                    const int64_t *font_size, const int64_t *font_color,
                                    const std::string *font_name_or_path,
                                    const std::string *content);

  const double *wm_alpha() const;
  void set_wm_alpha(const double *value_arg);
  void set_wm_alpha(double value_arg);

  const int64_t *wm_width() const;
  void set_wm_width(const int64_t *value_arg);
  void set_wm_width(int64_t value_arg);

  const int64_t *wm_height() const;
  void set_wm_height(const int64_t *value_arg);
  void set_wm_height(int64_t value_arg);

  const int64_t *offset_x() const;
  void set_offset_x(const int64_t *value_arg);
  void set_offset_x(int64_t value_arg);

  const int64_t *offset_y() const;
  void set_offset_y(const int64_t *value_arg);
  void set_offset_y(int64_t value_arg);

  const int64_t *wm_color() const;
  void set_wm_color(const int64_t *value_arg);
  void set_wm_color(int64_t value_arg);

  const int64_t *font_size() const;
  void set_font_size(const int64_t *value_arg);
  void set_font_size(int64_t value_arg);

  const int64_t *font_color() const;
  void set_font_color(const int64_t *value_arg);
  void set_font_color(int64_t value_arg);

  const std::string *font_name_or_path() const;
  void set_font_name_or_path(const std::string_view *value_arg);
  void set_font_name_or_path(std::string_view value_arg);

  const std::string *content() const;
  void set_content(const std::string_view *value_arg);
  void set_content(std::string_view value_arg);

 private:
  static VideoWatermarkTextConfig FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class VideoWatermarkConfig;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<double> wm_alpha_;
  std::optional<int64_t> wm_width_;
  std::optional<int64_t> wm_height_;
  std::optional<int64_t> offset_x_;
  std::optional<int64_t> offset_y_;
  std::optional<int64_t> wm_color_;
  std::optional<int64_t> font_size_;
  std::optional<int64_t> font_color_;
  std::optional<std::string> font_name_or_path_;
  std::optional<std::string> content_;
};

// Generated class from Pigeon that represents data sent in messages.
class VideoWatermarkTimestampConfig {
 public:
  // Constructs an object setting all non-nullable fields.
  VideoWatermarkTimestampConfig();

  // Constructs an object setting all fields.
  explicit VideoWatermarkTimestampConfig(const double *wm_alpha, const int64_t *wm_width,
                                         const int64_t *wm_height, const int64_t *offset_x,
                                         const int64_t *offset_y, const int64_t *wm_color,
                                         const int64_t *font_size, const int64_t *font_color,
                                         const std::string *font_name_or_path);

  const double *wm_alpha() const;
  void set_wm_alpha(const double *value_arg);
  void set_wm_alpha(double value_arg);

  const int64_t *wm_width() const;
  void set_wm_width(const int64_t *value_arg);
  void set_wm_width(int64_t value_arg);

  const int64_t *wm_height() const;
  void set_wm_height(const int64_t *value_arg);
  void set_wm_height(int64_t value_arg);

  const int64_t *offset_x() const;
  void set_offset_x(const int64_t *value_arg);
  void set_offset_x(int64_t value_arg);

  const int64_t *offset_y() const;
  void set_offset_y(const int64_t *value_arg);
  void set_offset_y(int64_t value_arg);

  const int64_t *wm_color() const;
  void set_wm_color(const int64_t *value_arg);
  void set_wm_color(int64_t value_arg);

  const int64_t *font_size() const;
  void set_font_size(const int64_t *value_arg);
  void set_font_size(int64_t value_arg);

  const int64_t *font_color() const;
  void set_font_color(const int64_t *value_arg);
  void set_font_color(int64_t value_arg);

  const std::string *font_name_or_path() const;
  void set_font_name_or_path(const std::string_view *value_arg);
  void set_font_name_or_path(std::string_view value_arg);

 private:
  static VideoWatermarkTimestampConfig FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class VideoWatermarkConfig;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<double> wm_alpha_;
  std::optional<int64_t> wm_width_;
  std::optional<int64_t> wm_height_;
  std::optional<int64_t> offset_x_;
  std::optional<int64_t> offset_y_;
  std::optional<int64_t> wm_color_;
  std::optional<int64_t> font_size_;
  std::optional<int64_t> font_color_;
  std::optional<std::string> font_name_or_path_;
};

// 视频水印设置，目前支持三种类型的水印，但只能其中选择一种水印生效
//
// Generated class from Pigeon that represents data sent in messages.
class VideoWatermarkConfig {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit VideoWatermarkConfig(const NERtcVideoWatermarkType &watermark_type);

  // Constructs an object setting all fields.
  explicit VideoWatermarkConfig(const NERtcVideoWatermarkType &watermark_type,
                                const VideoWatermarkImageConfig *image_watermark,
                                const VideoWatermarkTextConfig *text_watermark,
                                const VideoWatermarkTimestampConfig *timestamp_watermark);

  const NERtcVideoWatermarkType &watermark_type() const;
  void set_watermark_type(const NERtcVideoWatermarkType &value_arg);

  const VideoWatermarkImageConfig *image_watermark() const;
  void set_image_watermark(const VideoWatermarkImageConfig *value_arg);
  void set_image_watermark(const VideoWatermarkImageConfig &value_arg);

  const VideoWatermarkTextConfig *text_watermark() const;
  void set_text_watermark(const VideoWatermarkTextConfig *value_arg);
  void set_text_watermark(const VideoWatermarkTextConfig &value_arg);

  const VideoWatermarkTimestampConfig *timestamp_watermark() const;
  void set_timestamp_watermark(const VideoWatermarkTimestampConfig *value_arg);
  void set_timestamp_watermark(const VideoWatermarkTimestampConfig &value_arg);

 private:
  static VideoWatermarkConfig FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class SetLocalVideoWatermarkConfigsRequest;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  NERtcVideoWatermarkType watermark_type_;
  std::optional<VideoWatermarkImageConfig> image_watermark_;
  std::optional<VideoWatermarkTextConfig> text_watermark_;
  std::optional<VideoWatermarkTimestampConfig> timestamp_watermark_;
};

// Generated class from Pigeon that represents data sent in messages.
class SetLocalVideoWatermarkConfigsRequest {
 public:
  // Constructs an object setting all non-nullable fields.
  explicit SetLocalVideoWatermarkConfigsRequest(int64_t type);

  // Constructs an object setting all fields.
  explicit SetLocalVideoWatermarkConfigsRequest(int64_t type, const VideoWatermarkConfig *config);

  int64_t type() const;
  void set_type(int64_t value_arg);

  const VideoWatermarkConfig *config() const;
  void set_config(const VideoWatermarkConfig *value_arg);
  void set_config(const VideoWatermarkConfig &value_arg);

 private:
  static SetLocalVideoWatermarkConfigsRequest FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  int64_t type_;
  std::optional<VideoWatermarkConfig> config_;
};

// NERtc 版本信息
//
// Generated class from Pigeon that represents data sent in messages.
class NERtcVersion {
 public:
  // Constructs an object setting all non-nullable fields.
  NERtcVersion();

  // Constructs an object setting all fields.
  explicit NERtcVersion(const std::string *version_name, const int64_t *version_code,
                        const std::string *build_type, const std::string *build_date,
                        const std::string *build_revision, const std::string *build_host,
                        const std::string *server_env, const std::string *build_branch,
                        const std::string *engine_revision);

  const std::string *version_name() const;
  void set_version_name(const std::string_view *value_arg);
  void set_version_name(std::string_view value_arg);

  const int64_t *version_code() const;
  void set_version_code(const int64_t *value_arg);
  void set_version_code(int64_t value_arg);

  const std::string *build_type() const;
  void set_build_type(const std::string_view *value_arg);
  void set_build_type(std::string_view value_arg);

  const std::string *build_date() const;
  void set_build_date(const std::string_view *value_arg);
  void set_build_date(std::string_view value_arg);

  const std::string *build_revision() const;
  void set_build_revision(const std::string_view *value_arg);
  void set_build_revision(std::string_view value_arg);

  const std::string *build_host() const;
  void set_build_host(const std::string_view *value_arg);
  void set_build_host(std::string_view value_arg);

  const std::string *server_env() const;
  void set_server_env(const std::string_view *value_arg);
  void set_server_env(std::string_view value_arg);

  const std::string *build_branch() const;
  void set_build_branch(const std::string_view *value_arg);
  void set_build_branch(std::string_view value_arg);

  const std::string *engine_revision() const;
  void set_engine_revision(const std::string_view *value_arg);
  void set_engine_revision(std::string_view value_arg);

 private:
  static NERtcVersion FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<std::string> version_name_;
  std::optional<int64_t> version_code_;
  std::optional<std::string> build_type_;
  std::optional<std::string> build_date_;
  std::optional<std::string> build_revision_;
  std::optional<std::string> build_host_;
  std::optional<std::string> server_env_;
  std::optional<std::string> build_branch_;
  std::optional<std::string> engine_revision_;
};

// Generated class from Pigeon that represents data sent in messages.
class VideoFrame {
 public:
  // Constructs an object setting all non-nullable fields.
  VideoFrame();

  // Constructs an object setting all fields.
  explicit VideoFrame(const int64_t *width, const int64_t *height, const int64_t *rotation,
                      const int64_t *format, const int64_t *time_stamp,
                      const std::vector<uint8_t> *data, const int64_t *stride_y,
                      const int64_t *stride_u, const int64_t *stride_v, const int64_t *texture_id,
                      const flutter::EncodableList *transform_matrix);

  const int64_t *width() const;
  void set_width(const int64_t *value_arg);
  void set_width(int64_t value_arg);

  const int64_t *height() const;
  void set_height(const int64_t *value_arg);
  void set_height(int64_t value_arg);

  const int64_t *rotation() const;
  void set_rotation(const int64_t *value_arg);
  void set_rotation(int64_t value_arg);

  const int64_t *format() const;
  void set_format(const int64_t *value_arg);
  void set_format(int64_t value_arg);

  const int64_t *time_stamp() const;
  void set_time_stamp(const int64_t *value_arg);
  void set_time_stamp(int64_t value_arg);

  const std::vector<uint8_t> *data() const;
  void set_data(const std::vector<uint8_t> *value_arg);
  void set_data(const std::vector<uint8_t> &value_arg);

  const int64_t *stride_y() const;
  void set_stride_y(const int64_t *value_arg);
  void set_stride_y(int64_t value_arg);

  const int64_t *stride_u() const;
  void set_stride_u(const int64_t *value_arg);
  void set_stride_u(int64_t value_arg);

  const int64_t *stride_v() const;
  void set_stride_v(const int64_t *value_arg);
  void set_stride_v(int64_t value_arg);

  const int64_t *texture_id() const;
  void set_texture_id(const int64_t *value_arg);
  void set_texture_id(int64_t value_arg);

  const flutter::EncodableList *transform_matrix() const;
  void set_transform_matrix(const flutter::EncodableList *value_arg);
  void set_transform_matrix(const flutter::EncodableList &value_arg);

 private:
  static VideoFrame FromEncodableList(const flutter::EncodableList &list);
  flutter::EncodableList ToEncodableList() const;
  friend class NERtcChannelEventSink;
  friend class NERtcChannelEventSinkCodecSerializer;
  friend class EngineApi;
  friend class EngineApiCodecSerializer;
  friend class VideoRendererApi;
  friend class VideoRendererApiCodecSerializer;
  friend class NERtcDeviceEventSink;
  friend class NERtcDeviceEventSinkCodecSerializer;
  friend class DeviceManagerApi;
  friend class DeviceManagerApiCodecSerializer;
  friend class AudioMixingApi;
  friend class AudioMixingApiCodecSerializer;
  friend class NERtcAudioMixingEventSink;
  friend class NERtcAudioMixingEventSinkCodecSerializer;
  friend class AudioEffectApi;
  friend class AudioEffectApiCodecSerializer;
  friend class NERtcAudioEffectEventSink;
  friend class NERtcAudioEffectEventSinkCodecSerializer;
  friend class NERtcStatsEventSink;
  friend class NERtcStatsEventSinkCodecSerializer;
  friend class NERtcLiveStreamEventSink;
  friend class NERtcLiveStreamEventSinkCodecSerializer;
  std::optional<int64_t> width_;
  std::optional<int64_t> height_;
  std::optional<int64_t> rotation_;
  std::optional<int64_t> format_;
  std::optional<int64_t> time_stamp_;
  std::optional<std::vector<uint8_t>> data_;
  std::optional<int64_t> stride_y_;
  std::optional<int64_t> stride_u_;
  std::optional<int64_t> stride_v_;
  std::optional<int64_t> texture_id_;
  std::optional<flutter::EncodableList> transform_matrix_;
};

class NERtcChannelEventSinkCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  NERtcChannelEventSinkCodecSerializer();
  inline static NERtcChannelEventSinkCodecSerializer &GetInstance() {
    static NERtcChannelEventSinkCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcChannelEventSink {
 public:
  NERtcChannelEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnJoinChannel(int64_t result, int64_t channel_id, int64_t elapsed, int64_t uid,
                     std::function<void(void)> &&on_success,
                     std::function<void(const FlutterError &)> &&on_error);
  void OnLeaveChannel(int64_t result, std::function<void(void)> &&on_success,
                      std::function<void(const FlutterError &)> &&on_error);
  void OnUserJoined(const UserJoinedEvent &event, std::function<void(void)> &&on_success,
                    std::function<void(const FlutterError &)> &&on_error);
  void OnUserLeave(const UserLeaveEvent &event, std::function<void(void)> &&on_success,
                   std::function<void(const FlutterError &)> &&on_error);
  void OnUserAudioStart(int64_t uid, std::function<void(void)> &&on_success,
                        std::function<void(const FlutterError &)> &&on_error);
  void OnUserSubStreamAudioStart(int64_t uid, std::function<void(void)> &&on_success,
                                 std::function<void(const FlutterError &)> &&on_error);
  void OnUserAudioStop(int64_t uid, std::function<void(void)> &&on_success,
                       std::function<void(const FlutterError &)> &&on_error);
  void OnUserSubStreamAudioStop(int64_t uid, std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnUserVideoStart(int64_t uid, int64_t max_profile, std::function<void(void)> &&on_success,
                        std::function<void(const FlutterError &)> &&on_error);
  void OnUserVideoStop(int64_t uid, std::function<void(void)> &&on_success,
                       std::function<void(const FlutterError &)> &&on_error);
  void OnDisconnect(int64_t reason, std::function<void(void)> &&on_success,
                    std::function<void(const FlutterError &)> &&on_error);
  void OnUserAudioMute(int64_t uid, bool muted, std::function<void(void)> &&on_success,
                       std::function<void(const FlutterError &)> &&on_error);
  void OnUserVideoMute(const UserVideoMuteEvent &event, std::function<void(void)> &&on_success,
                       std::function<void(const FlutterError &)> &&on_error);
  void OnUserSubStreamAudioMute(int64_t uid, bool muted, std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnFirstAudioDataReceived(int64_t uid, std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnFirstVideoDataReceived(const FirstVideoDataReceivedEvent &event,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnFirstAudioFrameDecoded(int64_t uid, std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnFirstVideoFrameDecoded(const FirstVideoFrameDecodedEvent &event,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnVirtualBackgroundSourceEnabled(const VirtualBackgroundSourceEnabledEvent &event,
                                        std::function<void(void)> &&on_success,
                                        std::function<void(const FlutterError &)> &&on_error);
  void OnConnectionTypeChanged(int64_t new_connection_type, std::function<void(void)> &&on_success,
                               std::function<void(const FlutterError &)> &&on_error);
  void OnReconnectingStart(std::function<void(void)> &&on_success,
                           std::function<void(const FlutterError &)> &&on_error);
  void OnReJoinChannel(int64_t result, int64_t channel_id, std::function<void(void)> &&on_success,
                       std::function<void(const FlutterError &)> &&on_error);
  void OnConnectionStateChanged(int64_t state, int64_t reason,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnLocalAudioVolumeIndication(int64_t volume, bool vad_flag,
                                    std::function<void(void)> &&on_success,
                                    std::function<void(const FlutterError &)> &&on_error);
  void OnRemoteAudioVolumeIndication(const RemoteAudioVolumeIndicationEvent &event,
                                     std::function<void(void)> &&on_success,
                                     std::function<void(const FlutterError &)> &&on_error);
  void OnLiveStreamState(const std::string &task_id, const std::string &push_url,
                         int64_t live_state, std::function<void(void)> &&on_success,
                         std::function<void(const FlutterError &)> &&on_error);
  void OnClientRoleChange(int64_t old_role, int64_t new_role,
                          std::function<void(void)> &&on_success,
                          std::function<void(const FlutterError &)> &&on_error);
  void OnError(int64_t code, std::function<void(void)> &&on_success,
               std::function<void(const FlutterError &)> &&on_error);
  void OnWarning(int64_t code, std::function<void(void)> &&on_success,
                 std::function<void(const FlutterError &)> &&on_error);
  void OnUserSubStreamVideoStart(int64_t uid, int64_t max_profile,
                                 std::function<void(void)> &&on_success,
                                 std::function<void(const FlutterError &)> &&on_error);
  void OnUserSubStreamVideoStop(int64_t uid, std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnAudioHasHowling(std::function<void(void)> &&on_success,
                         std::function<void(const FlutterError &)> &&on_error);
  void OnRecvSEIMsg(int64_t user_i_d, const std::string &sei_msg,
                    std::function<void(void)> &&on_success,
                    std::function<void(const FlutterError &)> &&on_error);
  void OnAudioRecording(int64_t code, const std::string &file_path,
                        std::function<void(void)> &&on_success,
                        std::function<void(const FlutterError &)> &&on_error);
  void OnMediaRightChange(bool is_audio_banned_by_server, bool is_video_banned_by_server,
                          std::function<void(void)> &&on_success,
                          std::function<void(const FlutterError &)> &&on_error);
  void OnMediaRelayStatesChange(int64_t state, const std::string &channel_name,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnMediaRelayReceiveEvent(int64_t event, int64_t code, const std::string &channel_name,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnLocalPublishFallbackToAudioOnly(bool is_fallback, int64_t stream_type,
                                         std::function<void(void)> &&on_success,
                                         std::function<void(const FlutterError &)> &&on_error);
  void OnRemoteSubscribeFallbackToAudioOnly(int64_t uid, bool is_fallback, int64_t stream_type,
                                            std::function<void(void)> &&on_success,
                                            std::function<void(const FlutterError &)> &&on_error);
  void OnLocalVideoWatermarkState(int64_t video_stream_type, int64_t state,
                                  std::function<void(void)> &&on_success,
                                  std::function<void(const FlutterError &)> &&on_error);
  void OnLastmileQuality(int64_t quality, std::function<void(void)> &&on_success,
                         std::function<void(const FlutterError &)> &&on_error);
  void OnLastmileProbeResult(const NERtcLastmileProbeResult &result,
                             std::function<void(void)> &&on_success,
                             std::function<void(const FlutterError &)> &&on_error);
  void OnTakeSnapshotResult(int64_t code, const std::string &path,
                            std::function<void(void)> &&on_success,
                            std::function<void(const FlutterError &)> &&on_error);
  void OnPermissionKeyWillExpire(std::function<void(void)> &&on_success,
                                 std::function<void(const FlutterError &)> &&on_error);
  void OnUpdatePermissionKey(const std::string &key, int64_t error, int64_t timeout,
                             std::function<void(void)> &&on_success,
                             std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

class EngineApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  EngineApiCodecSerializer();
  inline static EngineApiCodecSerializer &GetInstance() {
    static EngineApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class EngineApi {
 public:
  EngineApi(const EngineApi &) = delete;
  EngineApi &operator=(const EngineApi &) = delete;
  virtual ~EngineApi() {}
  virtual ErrorOr<int64_t> Create(const CreateEngineRequest &request) = 0;
  virtual ErrorOr<NERtcVersion> Version() = 0;
  virtual ErrorOr<std::optional<flutter::EncodableList>> CheckPermission() = 0;
  virtual ErrorOr<int64_t> SetParameters(const flutter::EncodableMap &params) = 0;
  virtual void Release(std::function<void(ErrorOr<int64_t> reply)> result) = 0;
  virtual ErrorOr<int64_t> SetStatsEventCallback() = 0;
  virtual ErrorOr<int64_t> ClearStatsEventCallback() = 0;
  virtual ErrorOr<int64_t> SetChannelProfile(int64_t channel_profile) = 0;
  virtual ErrorOr<int64_t> JoinChannel(const JoinChannelRequest &request) = 0;
  virtual ErrorOr<int64_t> LeaveChannel() = 0;
  virtual ErrorOr<int64_t> UpdatePermissionKey(const std::string &key) = 0;
  virtual ErrorOr<int64_t> EnableLocalAudio(bool enable) = 0;
  virtual ErrorOr<int64_t> SubscribeRemoteAudio(const SubscribeRemoteAudioRequest &request) = 0;
  virtual ErrorOr<int64_t> SubscribeAllRemoteAudio(bool subscribe) = 0;
  virtual ErrorOr<int64_t> SetAudioProfile(const SetAudioProfileRequest &request) = 0;
  virtual ErrorOr<int64_t> EnableDualStreamMode(bool enable) = 0;
  virtual ErrorOr<int64_t> SetLocalVideoConfig(const SetLocalVideoConfigRequest &request) = 0;
  virtual ErrorOr<int64_t> SetCameraCaptureConfig(const SetCameraCaptureConfigRequest &request) = 0;
  virtual ErrorOr<int64_t> StartVideoPreview(const StartorStopVideoPreviewRequest &request) = 0;
  virtual ErrorOr<int64_t> StopVideoPreview(const StartorStopVideoPreviewRequest &request) = 0;
  virtual ErrorOr<int64_t> EnableLocalVideo(const EnableLocalVideoRequest &request) = 0;
  virtual ErrorOr<int64_t> EnableLocalSubStreamAudio(bool enable) = 0;
  virtual ErrorOr<int64_t> SubscribeRemoteSubStreamAudio(
      const SubscribeRemoteSubStreamAudioRequest &request) = 0;
  virtual ErrorOr<int64_t> MuteLocalSubStreamAudio(bool muted) = 0;
  virtual ErrorOr<int64_t> SetAudioSubscribeOnlyBy(
      const SetAudioSubscribeOnlyByRequest &request) = 0;
  virtual void StartScreenCapture(const StartScreenCaptureRequest &request,
                                  std::function<void(ErrorOr<int64_t> reply)> result) = 0;
  virtual ErrorOr<int64_t> StopScreenCapture() = 0;
  virtual ErrorOr<int64_t> EnableLoopbackRecording(bool enable) = 0;
  virtual ErrorOr<int64_t> SubscribeRemoteVideoStream(
      const SubscribeRemoteVideoStreamRequest &request) = 0;
  virtual ErrorOr<int64_t> SubscribeRemoteSubStreamVideo(
      const SubscribeRemoteSubStreamVideoRequest &request) = 0;
  virtual ErrorOr<int64_t> MuteLocalAudioStream(bool mute) = 0;
  virtual ErrorOr<int64_t> MuteLocalVideoStream(bool mute, int64_t stream_type) = 0;
  virtual ErrorOr<int64_t> StartAudioDump() = 0;
  virtual ErrorOr<int64_t> StartAudioDumpWithType(int64_t dump_type) = 0;
  virtual ErrorOr<int64_t> StopAudioDump() = 0;
  virtual ErrorOr<int64_t> EnableAudioVolumeIndication(
      const EnableAudioVolumeIndicationRequest &request) = 0;
  virtual ErrorOr<int64_t> AdjustRecordingSignalVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> AdjustPlaybackSignalVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> AdjustLoopBackRecordingSignalVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> AddLiveStreamTask(const AddOrUpdateLiveStreamTaskRequest &request) = 0;
  virtual ErrorOr<int64_t> UpdateLiveStreamTask(
      const AddOrUpdateLiveStreamTaskRequest &request) = 0;
  virtual ErrorOr<int64_t> RemoveLiveStreamTask(const DeleteLiveStreamTaskRequest &request) = 0;
  virtual ErrorOr<int64_t> SetClientRole(int64_t role) = 0;
  virtual ErrorOr<int64_t> GetConnectionState() = 0;
  virtual ErrorOr<int64_t> UploadSdkInfo() = 0;
  virtual ErrorOr<int64_t> SendSEIMsg(const SendSEIMsgRequest &request) = 0;
  virtual ErrorOr<int64_t> SetLocalVoiceReverbParam(
      const SetLocalVoiceReverbParamRequest &request) = 0;
  virtual ErrorOr<int64_t> SetAudioEffectPreset(int64_t preset) = 0;
  virtual ErrorOr<int64_t> SetVoiceBeautifierPreset(int64_t preset) = 0;
  virtual ErrorOr<int64_t> SetLocalVoicePitch(double pitch) = 0;
  virtual ErrorOr<int64_t> SetLocalVoiceEqualization(
      const SetLocalVoiceEqualizationRequest &request) = 0;
  virtual ErrorOr<int64_t> SwitchChannel(const SwitchChannelRequest &request) = 0;
  virtual ErrorOr<int64_t> StartAudioRecording(const StartAudioRecordingRequest &request) = 0;
  virtual ErrorOr<int64_t> StartAudioRecordingWithConfig(
      const AudioRecordingConfigurationRequest &request) = 0;
  virtual ErrorOr<int64_t> StopAudioRecording() = 0;
  virtual ErrorOr<int64_t> SetLocalMediaPriority(const SetLocalMediaPriorityRequest &request) = 0;
  virtual ErrorOr<int64_t> EnableMediaPub(int64_t media_type, bool enable) = 0;
  virtual ErrorOr<int64_t> StartChannelMediaRelay(
      const StartOrUpdateChannelMediaRelayRequest &request) = 0;
  virtual ErrorOr<int64_t> UpdateChannelMediaRelay(
      const StartOrUpdateChannelMediaRelayRequest &request) = 0;
  virtual ErrorOr<int64_t> StopChannelMediaRelay() = 0;
  virtual ErrorOr<int64_t> AdjustUserPlaybackSignalVolume(
      const AdjustUserPlaybackSignalVolumeRequest &request) = 0;
  virtual ErrorOr<int64_t> SetLocalPublishFallbackOption(int64_t option) = 0;
  virtual ErrorOr<int64_t> SetRemoteSubscribeFallbackOption(int64_t option) = 0;
  virtual ErrorOr<int64_t> EnableSuperResolution(bool enable) = 0;
  virtual ErrorOr<int64_t> EnableEncryption(const EnableEncryptionRequest &request) = 0;
  virtual ErrorOr<int64_t> SetAudioSessionOperationRestriction(int64_t option) = 0;
  virtual ErrorOr<int64_t> EnableVideoCorrection(bool enable) = 0;
  virtual ErrorOr<int64_t> ReportCustomEvent(const ReportCustomEventRequest &request) = 0;
  virtual ErrorOr<int64_t> GetEffectDuration(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> StartLastmileProbeTest(const StartLastmileProbeTestRequest &request) = 0;
  virtual ErrorOr<int64_t> StopLastmileProbeTest() = 0;
  virtual ErrorOr<int64_t> SetVideoCorrectionConfig(
      const SetVideoCorrectionConfigRequest &request) = 0;
  virtual ErrorOr<int64_t> EnableVirtualBackground(
      const EnableVirtualBackgroundRequest &request) = 0;
  virtual ErrorOr<int64_t> SetRemoteHighPriorityAudioStream(
      const SetRemoteHighPriorityAudioStreamRequest &request) = 0;
  virtual ErrorOr<int64_t> SetCloudProxy(int64_t proxy_type) = 0;
  virtual ErrorOr<int64_t> StartBeauty() = 0;
  virtual std::optional<FlutterError> StopBeauty() = 0;
  virtual ErrorOr<int64_t> EnableBeauty(bool enabled) = 0;
  virtual ErrorOr<int64_t> SetBeautyEffect(double level, int64_t beauty_type) = 0;
  virtual ErrorOr<int64_t> AddBeautyFilter(const std::string &path, const std::string &name) = 0;
  virtual std::optional<FlutterError> RemoveBeautyFilter() = 0;
  virtual ErrorOr<int64_t> SetBeautyFilterLevel(double level) = 0;
  virtual ErrorOr<int64_t> SetLocalVideoWatermarkConfigs(
      const SetLocalVideoWatermarkConfigsRequest &request) = 0;
  virtual ErrorOr<int64_t> SetStreamAlignmentProperty(bool enable) = 0;
  virtual ErrorOr<int64_t> GetNtpTimeOffset() = 0;
  virtual ErrorOr<int64_t> TakeLocalSnapshot(int64_t stream_type, const std::string &path) = 0;
  virtual ErrorOr<int64_t> TakeRemoteSnapshot(int64_t uid, int64_t stream_type,
                                              const std::string &path) = 0;
  virtual ErrorOr<int64_t> SetExternalVideoSource(int64_t stream_type, bool enable) = 0;
  virtual ErrorOr<int64_t> PushExternalVideoFrame(int64_t stream_type, const VideoFrame &frame) = 0;

  // The codec used by EngineApi.
  static const flutter::StandardMessageCodec &GetCodec();
  // Sets up an instance of `EngineApi` to handle messages through the `binary_messenger`.
  static void SetUp(flutter::BinaryMessenger *binary_messenger, EngineApi *api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError &error);

 protected:
  EngineApi() = default;
};
// Generated interface from Pigeon that represents a handler of messages from Flutter.
class VideoRendererApi {
 public:
  VideoRendererApi(const VideoRendererApi &) = delete;
  VideoRendererApi &operator=(const VideoRendererApi &) = delete;
  virtual ~VideoRendererApi() {}
  virtual ErrorOr<int64_t> CreateVideoRenderer() = 0;
  virtual ErrorOr<int64_t> SetMirror(int64_t texture_id, bool mirror) = 0;
  virtual ErrorOr<int64_t> SetupLocalVideoRenderer(int64_t texture_id) = 0;
  virtual ErrorOr<int64_t> SetupRemoteVideoRenderer(int64_t uid, int64_t texture_id) = 0;
  virtual ErrorOr<int64_t> SetupLocalSubStreamVideoRenderer(int64_t texture_id) = 0;
  virtual ErrorOr<int64_t> SetupRemoteSubStreamVideoRenderer(int64_t uid, int64_t texture_id) = 0;
  virtual std::optional<FlutterError> DisposeVideoRenderer(int64_t texture_id) = 0;

  // The codec used by VideoRendererApi.
  static const flutter::StandardMessageCodec &GetCodec();
  // Sets up an instance of `VideoRendererApi` to handle messages through the `binary_messenger`.
  static void SetUp(flutter::BinaryMessenger *binary_messenger, VideoRendererApi *api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError &error);

 protected:
  VideoRendererApi() = default;
};
class NERtcDeviceEventSinkCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  NERtcDeviceEventSinkCodecSerializer();
  inline static NERtcDeviceEventSinkCodecSerializer &GetInstance() {
    static NERtcDeviceEventSinkCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcDeviceEventSink {
 public:
  NERtcDeviceEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnAudioDeviceChanged(int64_t selected, std::function<void(void)> &&on_success,
                            std::function<void(const FlutterError &)> &&on_error);
  void OnAudioDeviceStateChange(int64_t device_type, int64_t device_state,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnVideoDeviceStateChange(int64_t device_type, int64_t device_state,
                                std::function<void(void)> &&on_success,
                                std::function<void(const FlutterError &)> &&on_error);
  void OnCameraFocusChanged(const CGPoint &focus_point, std::function<void(void)> &&on_success,
                            std::function<void(const FlutterError &)> &&on_error);
  void OnCameraExposureChanged(const CGPoint &exposure_point,
                               std::function<void(void)> &&on_success,
                               std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

class DeviceManagerApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  DeviceManagerApiCodecSerializer();
  inline static DeviceManagerApiCodecSerializer &GetInstance() {
    static DeviceManagerApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class DeviceManagerApi {
 public:
  DeviceManagerApi(const DeviceManagerApi &) = delete;
  DeviceManagerApi &operator=(const DeviceManagerApi &) = delete;
  virtual ~DeviceManagerApi() {}
  virtual ErrorOr<bool> IsSpeakerphoneOn() = 0;
  virtual ErrorOr<bool> IsCameraZoomSupported() = 0;
  virtual ErrorOr<bool> IsCameraTorchSupported() = 0;
  virtual ErrorOr<bool> IsCameraFocusSupported() = 0;
  virtual ErrorOr<bool> IsCameraExposurePositionSupported() = 0;
  virtual ErrorOr<int64_t> SetSpeakerphoneOn(bool enable) = 0;
  virtual ErrorOr<int64_t> SwitchCamera() = 0;
  virtual ErrorOr<int64_t> SetCameraZoomFactor(double factor) = 0;
  virtual ErrorOr<double> GetCameraMaxZoom() = 0;
  virtual ErrorOr<int64_t> SetCameraTorchOn(bool on) = 0;
  virtual ErrorOr<int64_t> SetCameraFocusPosition(const SetCameraPositionRequest &request) = 0;
  virtual ErrorOr<int64_t> SetCameraExposurePosition(const SetCameraPositionRequest &request) = 0;
  virtual ErrorOr<int64_t> SetPlayoutDeviceMute(bool mute) = 0;
  virtual ErrorOr<bool> IsPlayoutDeviceMute() = 0;
  virtual ErrorOr<int64_t> SetRecordDeviceMute(bool mute) = 0;
  virtual ErrorOr<bool> IsRecordDeviceMute() = 0;
  virtual ErrorOr<int64_t> EnableEarback(bool enabled, int64_t volume) = 0;
  virtual ErrorOr<int64_t> SetEarbackVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> SetAudioFocusMode(int64_t focus_mode) = 0;
  virtual ErrorOr<int64_t> GetCurrentCamera() = 0;
  virtual ErrorOr<int64_t> SwitchCameraWithPosition(int64_t position) = 0;
  virtual ErrorOr<int64_t> GetCameraCurrentZoom() = 0;

  // The codec used by DeviceManagerApi.
  static const flutter::StandardMessageCodec &GetCodec();
  // Sets up an instance of `DeviceManagerApi` to handle messages through the `binary_messenger`.
  static void SetUp(flutter::BinaryMessenger *binary_messenger, DeviceManagerApi *api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError &error);

 protected:
  DeviceManagerApi() = default;
};
class AudioMixingApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  AudioMixingApiCodecSerializer();
  inline static AudioMixingApiCodecSerializer &GetInstance() {
    static AudioMixingApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class AudioMixingApi {
 public:
  AudioMixingApi(const AudioMixingApi &) = delete;
  AudioMixingApi &operator=(const AudioMixingApi &) = delete;
  virtual ~AudioMixingApi() {}
  virtual ErrorOr<int64_t> StartAudioMixing(const StartAudioMixingRequest &request) = 0;
  virtual ErrorOr<int64_t> StopAudioMixing() = 0;
  virtual ErrorOr<int64_t> PauseAudioMixing() = 0;
  virtual ErrorOr<int64_t> ResumeAudioMixing() = 0;
  virtual ErrorOr<int64_t> SetAudioMixingSendVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> GetAudioMixingSendVolume() = 0;
  virtual ErrorOr<int64_t> SetAudioMixingPlaybackVolume(int64_t volume) = 0;
  virtual ErrorOr<int64_t> GetAudioMixingPlaybackVolume() = 0;
  virtual ErrorOr<int64_t> GetAudioMixingDuration() = 0;
  virtual ErrorOr<int64_t> GetAudioMixingCurrentPosition() = 0;
  virtual ErrorOr<int64_t> SetAudioMixingPosition(int64_t position) = 0;
  virtual ErrorOr<int64_t> SetAudioMixingPitch(int64_t pitch) = 0;
  virtual ErrorOr<int64_t> GetAudioMixingPitch() = 0;

  // The codec used by AudioMixingApi.
  static const flutter::StandardMessageCodec &GetCodec();
  // Sets up an instance of `AudioMixingApi` to handle messages through the `binary_messenger`.
  static void SetUp(flutter::BinaryMessenger *binary_messenger, AudioMixingApi *api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError &error);

 protected:
  AudioMixingApi() = default;
};
// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcAudioMixingEventSink {
 public:
  NERtcAudioMixingEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnAudioMixingStateChanged(int64_t reason, std::function<void(void)> &&on_success,
                                 std::function<void(const FlutterError &)> &&on_error);
  void OnAudioMixingTimestampUpdate(int64_t timestamp_ms, std::function<void(void)> &&on_success,
                                    std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

class AudioEffectApiCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  AudioEffectApiCodecSerializer();
  inline static AudioEffectApiCodecSerializer &GetInstance() {
    static AudioEffectApiCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated interface from Pigeon that represents a handler of messages from Flutter.
class AudioEffectApi {
 public:
  AudioEffectApi(const AudioEffectApi &) = delete;
  AudioEffectApi &operator=(const AudioEffectApi &) = delete;
  virtual ~AudioEffectApi() {}
  virtual ErrorOr<int64_t> PlayEffect(const PlayEffectRequest &request) = 0;
  virtual ErrorOr<int64_t> StopEffect(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> StopAllEffects() = 0;
  virtual ErrorOr<int64_t> PauseEffect(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> ResumeEffect(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> PauseAllEffects() = 0;
  virtual ErrorOr<int64_t> ResumeAllEffects() = 0;
  virtual ErrorOr<int64_t> SetEffectSendVolume(int64_t effect_id, int64_t volume) = 0;
  virtual ErrorOr<int64_t> GetEffectSendVolume(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> SetEffectPlaybackVolume(int64_t effect_id, int64_t volume) = 0;
  virtual ErrorOr<int64_t> GetEffectPlaybackVolume(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> GetEffectDuration(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> GetEffectCurrentPosition(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> SetEffectPitch(int64_t effect_id, int64_t pitch) = 0;
  virtual ErrorOr<int64_t> GetEffectPitch(int64_t effect_id) = 0;
  virtual ErrorOr<int64_t> SetEffectPosition(int64_t effect_id, int64_t position) = 0;

  // The codec used by AudioEffectApi.
  static const flutter::StandardMessageCodec &GetCodec();
  // Sets up an instance of `AudioEffectApi` to handle messages through the `binary_messenger`.
  static void SetUp(flutter::BinaryMessenger *binary_messenger, AudioEffectApi *api);
  static flutter::EncodableValue WrapError(std::string_view error_message);
  static flutter::EncodableValue WrapError(const FlutterError &error);

 protected:
  AudioEffectApi() = default;
};
// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcAudioEffectEventSink {
 public:
  NERtcAudioEffectEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnAudioEffectFinished(int64_t effect_id, std::function<void(void)> &&on_success,
                             std::function<void(const FlutterError &)> &&on_error);
  void OnAudioEffectTimestampUpdate(int64_t id, int64_t timestamp_ms,
                                    std::function<void(void)> &&on_success,
                                    std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

class NERtcStatsEventSinkCodecSerializer : public flutter::StandardCodecSerializer {
 public:
  NERtcStatsEventSinkCodecSerializer();
  inline static NERtcStatsEventSinkCodecSerializer &GetInstance() {
    static NERtcStatsEventSinkCodecSerializer sInstance;
    return sInstance;
  }

  void WriteValue(const flutter::EncodableValue &value,
                  flutter::ByteStreamWriter *stream) const override;

 protected:
  flutter::EncodableValue ReadValueOfType(uint8_t type,
                                          flutter::ByteStreamReader *stream) const override;
};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcStatsEventSink {
 public:
  NERtcStatsEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnRtcStats(const flutter::EncodableMap &arguments, std::function<void(void)> &&on_success,
                  std::function<void(const FlutterError &)> &&on_error);
  void OnLocalAudioStats(const flutter::EncodableMap &arguments,
                         std::function<void(void)> &&on_success,
                         std::function<void(const FlutterError &)> &&on_error);
  void OnRemoteAudioStats(const flutter::EncodableMap &arguments,
                          std::function<void(void)> &&on_success,
                          std::function<void(const FlutterError &)> &&on_error);
  void OnLocalVideoStats(const flutter::EncodableMap &arguments,
                         std::function<void(void)> &&on_success,
                         std::function<void(const FlutterError &)> &&on_error);
  void OnRemoteVideoStats(const flutter::EncodableMap &arguments,
                          std::function<void(void)> &&on_success,
                          std::function<void(const FlutterError &)> &&on_error);
  void OnNetworkQuality(const flutter::EncodableMap &arguments,
                        std::function<void(void)> &&on_success,
                        std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

// Generated class from Pigeon that represents Flutter messages that can be called from C++.
class NERtcLiveStreamEventSink {
 public:
  NERtcLiveStreamEventSink(flutter::BinaryMessenger *binary_messenger);
  static const flutter::StandardMessageCodec &GetCodec();
  void OnUpdateLiveStreamTask(const std::string &task_id, int64_t err_code,
                              std::function<void(void)> &&on_success,
                              std::function<void(const FlutterError &)> &&on_error);
  void OnAddLiveStreamTask(const std::string &task_id, int64_t err_code,
                           std::function<void(void)> &&on_success,
                           std::function<void(const FlutterError &)> &&on_error);
  void OnDeleteLiveStreamTask(const std::string &task_id, int64_t err_code,
                              std::function<void(void)> &&on_success,
                              std::function<void(const FlutterError &)> &&on_error);

 private:
  flutter::BinaryMessenger *binary_messenger_;
};

}  // namespace NEFLT
#endif  // PIGEON_MESSAGES_H_
