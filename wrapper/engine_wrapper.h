// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef _NERTC_WRAPPER_H_
#define _NERTC_WRAPPER_H_

#if _WIN32
#include <nertc_engine_ex.h>
#include <nertc_engine_event_handler_ex.h>
#include <nertc_engine_defines.h>
#include <nertc_video_device_manager.h>
#include <nertc_audio_device_manager.h>
#include <nertc_engine_media_stats_observer.h>
#include <nertc_channel.h>
#include <nertc_channel_event_handler.h>
#else
#include <nertc_sdk_Mac/nertc_engine.h>
#include <nertc_sdk_Mac/nertc_engine_ex.h>
#include <nertc_sdk_Mac/nertc_engine_event_handler_ex.h>
#include <nertc_sdk_Mac/nertc_engine_defines.h>
#include <nertc_sdk_Mac/nertc_video_device_manager.h>
#include <nertc_sdk_Mac/nertc_audio_device_manager.h>
#include <nertc_sdk_Mac/nertc_engine_media_stats_observer.h>
#include <nertc_sdk_Mac/nertc_channel.h>
#include <nertc_sdk_Mac/nertc_channel_event_handler.h>
#endif
#include "logic/convert.h"
#include "nertc_define.h"
#include <iostream>
#include "dart/dart_api_dl.h"
#include <set>
#include <mutex>
#include <map>

using namespace nertc;
using namespace nlohmann;

template <typename T>
class RefCountImpl {
 public:
  RefCountImpl() : ptr_(nullptr), ref_count_(0) {}
  ~RefCountImpl() {
    // 不要在这里直接 delete/release ptr_
    // 只在 death_recipient 里释放
  }

  void SetOnRelease(T* ptr, std::function<void(T*)> death_recipient) {
    ptr_ = ptr;
    death_recipient_ = death_recipient;
    ref_count_ = 1;
  }

  void AddRef() { ++ref_count_; }

  void DecRef() {
    if (--ref_count_ == 0 && ptr_ && death_recipient_) {
      death_recipient_(ptr_);
      ptr_ = nullptr;
    }
  }

  // 添加获取指针的方法
  T* GetPtr() const { return ptr_; }

  // 添加 get() 方法作为别名（兼容现有代码）
  T* get() const { return ptr_; }

  // 添加检查指针是否有效的方法
  bool IsValid() const { return ptr_ != nullptr; }

 private:
  T* ptr_;
  int ref_count_;
  std::function<void(T*)> death_recipient_;
};

using namespace nertc;
using namespace nlohmann;
typedef void (*DartCallback)(const char* message);
using MethodHandler = std::function<int64_t(IRtcEngineEx*, const json&)>;
using MethodHandler1 = std::function<std::string(IRtcEngineEx*, const json&)>;
using ChannelMethodHandler = std::function<int64_t(IRtcChannel*, const json&)>;
using ChannelMethodHandler1 =
    std::function<std::string(IRtcChannel*, const json&)>;

class NERtcChannelWrapper : public IRtcChannelEventHandler,
                            public IRtcMediaStatsObserver {
 public:
  explicit NERtcChannelWrapper(IRtcChannel* rtc_channel, DartCallback callback,
                               Dart_Port send_port,
                               const std::string& channel_tag);
  ~NERtcChannelWrapper();
  int64_t HandleMethodCall(const json& no_err_body);
  std::string HandleMethodCallStr(const json& no_err_body);
  int64_t HandlePushVideoFrame(const json& no_err_body, const uint8_t* data,
                               const double* matrix);
  int64_t SetupLocalCanvas(nertc::NERtcVideoCanvas* canvas,
                           nertc::NERtcVideoStreamType stream_type);
  int64_t SetupRemoteCanvas(nertc::uid_t uid, nertc::NERtcVideoCanvas* canvas,
                            nertc::NERtcVideoStreamType stream_type);

 public:
  static std::string HandleGetChannelName(IRtcChannel* handle,
                                          const json& params);
  static int64_t HandleSubAllRemoteAudioStream(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleSetCameraCaptureConfig(IRtcChannel* handle,
                                              const json& params);
  static int64_t HandleSetVideoStreamLayerCount(IRtcChannel* handle,
                                                const json& params);
  static int64_t HandleGetFeatureSupportedType(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleEnableLoopbackRecording(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleAdjustLoopbackRecordingSignalVolume(IRtcChannel* handle,
                                                           const json& params);
  static int64_t HandleSetExternalVideoSource(IRtcChannel* handle,
                                              const json& params);
  static int64_t HandleAddLiveStreamTask(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleUpdateLiveStreamTask(IRtcChannel* handle,
                                            const json& params);
  static int64_t HandleRemoveLiveStreamTask(IRtcChannel* handle,
                                            const json& params);
  static int64_t HandleSendSEIMsg(IRtcChannel* handle, const json& params);
  static int64_t HandleSetLocalMediaPriority(IRtcChannel* handle,
                                             const json& params);
  static int64_t HandleStartChannelMediaRelay(IRtcChannel* handle,
                                              const json& params);
  static int64_t HandleUpdateChannelMediaRelay(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleStopChannelMediaRelay(IRtcChannel* handle,
                                             const json& params);
  static int64_t HandleAdjustUserPlaybackSignalVolume(IRtcChannel* handle,
                                                      const json& params);
  static int64_t HandleSetLocalPublishFallbackOption(IRtcChannel* handle,
                                                     const json& params);
  static int64_t HandleSetRemoteSubscribeFallbackOption(IRtcChannel* handle,
                                                        const json& params);
  static int64_t HandleEnableEncryption(IRtcChannel* handle,
                                        const json& params);
  static int64_t HandleSetRemoteHighPriorityAudioStream(IRtcChannel* handle,
                                                        const json& params);
  static int64_t HandleSetAudioSubscribeOnlyBy(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleEnableLocalAudio(IRtcChannel* handle,
                                        const json& params);
  static int64_t HandleReportCustomEvent(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleSetAudioRecvRange(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleUpdateSelfPosition(IRtcChannel* handle,
                                          const json& params);
  static int64_t HandleEnableSpatializerRoomEffects(IRtcChannel* handle,
                                                    const json& params);
  static int64_t HandleSetSpatializerRoomProperty(IRtcChannel* handle,
                                                  const json& params);
  static int64_t HandleSetSpatializerRenderMode(IRtcChannel* handle,
                                                const json& params);
  static int64_t HandleEnableSpatializer(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleIitSpatializer(IRtcChannel* handle, const json& params);
  static int64_t HandleSetRangeAudioMode(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleSetRangeAudioTeamID(IRtcChannel* handle,
                                           const json& params);
  static int64_t HandleSetSubscribeAudioBlocklist(IRtcChannel* handle,
                                                  const json& params);
  static int64_t HandleSetSubscribeAudioAllowlist(IRtcChannel* handle,
                                                  const json& params);
  static int64_t HandleSetMediaStatsObserver(IRtcChannel* handle,
                                             const json& params);

  // 上一期接口
  static int64_t HandleEnableMediaPub(IRtcChannel* handle, const json& params);
  static int64_t HandleEnableAudioVolumeIndication(IRtcChannel* handle,
                                                   const json& params);
  static int64_t HandleEnableLocalVideo(IRtcChannel* handle,
                                        const json& params);
  static int64_t HandleGetConnectionState(IRtcChannel* handle,
                                          const json& params);
  static int64_t HandleJoinChannel(IRtcChannel* handle, const json& params);
  static int64_t HandleLeaveChannel(IRtcChannel* handle, const json& params);
  static int64_t HandleMuteLocalAudio(IRtcChannel* handle, const json& params);
  static int64_t HandleMuteLocalVideo(IRtcChannel* handle, const json& params);
  static int64_t HandleRelease(IRtcChannel* handle, const json& params);
  static int64_t HandleSetChannelProfile(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleSetClientRole(IRtcChannel* handle, const json& params);
  static int64_t HandleSetLocalVideoConfig(IRtcChannel* handle,
                                           const json& params);
  static int64_t HandleSubRemoteAudioStream(IRtcChannel* handle,
                                            const json& params);
  static int64_t HandleSubRemoteSubAudioStream(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleSubRemoteVideoStream(IRtcChannel* handle,
                                            const json& params);
  static int64_t HandleSubRemoteSubVideoStream(IRtcChannel* handle,
                                               const json& params);
  static int64_t HandleTakeLocalSnapshot(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandleTakeRemoteSnapshot(IRtcChannel* handle,
                                          const json& params);
  static int64_t HandleSetupLocalVideoRender(IRtcChannel* handle,
                                             const json& params);
  static int64_t HandleSetupRemoteVideoRender(IRtcChannel* handle,
                                              const json& params);

  // screen capture.
  static std::string HandleGetScreenCaptureSource(IRtcChannel* handle,
                                                  const json& params);
  static int64_t HandleReleaseScreenCaptureSource(IRtcChannel* handle,
                                                  const json& params);
  static int64_t HandleGetScreenCaptureCount(IRtcChannel* handle,
                                             const json& params);
  static std::string HandleGetScreenCaptureSourceInfo(IRtcChannel* handle,
                                                      const json& params);
  static int64_t HandleStartScreenCaptureByScreenRect(IRtcChannel* handle,
                                                      const json& params);
  static int64_t HandleStartScreenCaptureByDisplayId(IRtcChannel* handle,
                                                     const json& params);
  static int64_t HandleStartScreenCaptureByWindowId(IRtcChannel* handle,
                                                    const json& params);
  static int64_t HandleSetScreenCaptureSource(IRtcChannel* handle,
                                              const json& params);
  static int64_t HandleUpdateScreenCaptureRegion(IRtcChannel* handle,
                                                 const json& params);
  static int64_t HandleSetScreenCaptureMouseCursor(IRtcChannel* handle,
                                                   const json& params);
  static int64_t HandleStopScreenCapture(IRtcChannel* handle,
                                         const json& params);
  static int64_t HandlePauseScreenCapture(IRtcChannel* handle,
                                          const json& params);
  static int64_t HandleResumeScreenCapture(IRtcChannel* handle,
                                           const json& params);
  static int64_t HandleSetExcludeWindowList(IRtcChannel* handle,
                                            const json& params);
  static int64_t HandleUpdateScreenCaptureParameters(IRtcChannel* handle,
                                                     const json& params);

  // channel event handler.
 private:
  void onError(int error_code, const char* msg) override;
  void onWarning(int warn_code, const char* msg) override;
  void onApiCallExecuted(const char* api_name, NERtcErrorCode error,
                         const char* message) override;
  void onJoinChannel(channel_id_t cid, nertc::uid_t uid, NERtcErrorCode result,
                     uint64_t elapsed) override;
  void onReconnectingStart(channel_id_t cid, nertc::uid_t uid) override;
  void onConnectionStateChange(
      NERtcConnectionStateType state,
      NERtcReasonConnectionChangedType reason) override;
  void onRejoinChannel(channel_id_t cid, nertc::uid_t uid,
                       NERtcErrorCode result, uint64_t elapsed) override;
  void onLeaveChannel(NERtcErrorCode result) override;
  void onDisconnect(NERtcErrorCode reason) override;
  void onClientRoleChanged(NERtcClientRole oldRole,
                           NERtcClientRole newRole) override;
  void onUserJoined(nertc::uid_t uid, const char* user_name,
                    NERtcUserJoinExtraInfo join_extra_info) override;
  void onUserLeft(nertc::uid_t uid, NERtcSessionLeaveReason reason,
                  NERtcUserJoinExtraInfo leave_extra_info) override;
  void onUserAudioStart(nertc::uid_t uid) override;
  void onUserAudioStop(nertc::uid_t uid) override;
  void onUserAudioMute(nertc::uid_t uid, bool mute) override;
  void onUserSubStreamAudioStart(nertc::uid_t uid) override;
  void onUserSubStreamAudioStop(nertc::uid_t uid) override;
  void onUserSubStreamAudioMute(nertc::uid_t uid, bool mute) override;
  void onUserVideoStart(nertc::uid_t uid,
                        NERtcVideoProfileType max_profile) override;
  void onUserVideoStop(nertc::uid_t uid) override;
  void onUserVideoMute(NERtcVideoStreamType videoStreamType, nertc::uid_t uid,
                       bool mute) override;
  void onUserSubStreamVideoStart(nertc::uid_t uid,
                                 NERtcVideoProfileType max_profile) override;
  void onUserSubStreamVideoStop(nertc::uid_t uid) override;
  void onScreenCaptureStatus(NERtcScreenCaptureStatus status) override;
  void onScreenCaptureSourceDataUpdate(
      NERtcScreenCaptureSourceData data) override;
  void onFirstAudioDataReceived(nertc::uid_t uid) override;
  void onFirstVideoDataReceived(NERtcVideoStreamType type,
                                nertc::uid_t uid) override;
  void onRemoteVideoReceiveSizeChanged(nertc::uid_t uid,
                                       NERtcVideoStreamType type,
                                       uint32_t width,
                                       uint32_t height) override;
  void onLocalVideoRenderSizeChanged(NERtcVideoStreamType type, uint32_t width,
                                     uint32_t height) override;
  void onFirstAudioFrameDecoded(nertc::uid_t uid) override;
  void onFirstVideoFrameDecoded(NERtcVideoStreamType type, nertc::uid_t uid,
                                uint32_t width, uint32_t height) override;
  void onFirstVideoFrameRender(NERtcVideoStreamType type, nertc::uid_t uid,
                               uint32_t width, uint32_t height,
                               uint64_t elapsed) override;
  void onLocalAudioVolumeIndication(int volume, bool enable_vad) override;
  void onRemoteAudioVolumeIndication(const NERtcAudioVolumeInfo* speakers,
                                     unsigned int speaker_number,
                                     int total_volume) override;
  void onAddLiveStreamTask(const char* task_id, const char* url,
                           int error_code) override;
  void onUpdateLiveStreamTask(const char* task_id, const char* url,
                              int error_code) override;
  void onRemoveLiveStreamTask(const char* task_id, int error_code) override;
  void onLiveStreamState(const char* task_id, const char* url,
                         NERtcLiveStreamStateCode state) override;
  void onRecvSEIMsg(nertc::uid_t uid, const char* data,
                    uint32_t dataSize) override;
  void onMediaRelayStateChanged(NERtcChannelMediaRelayState state,
                                const char* channel_name) override;
  void onMediaRelayEvent(NERtcChannelMediaRelayEvent event,
                         const char* channel_name,
                         NERtcErrorCode error) override;
  void onLocalPublishFallbackToAudioOnly(bool is_fallback,
                                         NERtcVideoStreamType stream_type);
  void onRemoteSubscribeFallbackToAudioOnly(
      nertc::uid_t uid, bool is_fallback,
      NERtcVideoStreamType stream_type) override;
  void onMediaRightChange(bool is_audio_banned, bool is_video_banned) override;
  void onLabFeatureCallback(const char* key, const char* param) override;

  // media stats observer.
 private:
  void onRtcStats(const NERtcStats& stats) override;
  void onLocalAudioStats(const NERtcAudioSendStats& stats) override;
  void onRemoteAudioStats(const NERtcAudioRecvStats* stats,
                          unsigned int user_count) override;
  void onLocalVideoStats(const NERtcVideoSendStats& stats) override;
  void onRemoteVideoStats(const NERtcVideoRecvStats* stats,
                          unsigned int user_count) override;
  void onNetworkQuality(const NERtcNetworkQualityInfo* infos,
                        unsigned int user_count) override;

 private:
  IRtcChannel* rtc_channel_ = nullptr;
  DartCallback dart_callback_;
  Dart_Port send_port_;
  std::string channel_tag_;

  static std::map<std::string, RefCountImpl<IScreenCaptureSourceList>>
      screen_capture_source_list_map_;
  static std::mutex source_list_mutex_;
};

class NERtcDesktopWrapper : public IRtcEngineEventHandlerEx,
                            public IRtcMediaStatsObserver {
 public:
  static NERtcDesktopWrapper* ShareInstance();
  static void DestroyInstance();
  void RegisterDartCallback(DartCallback callback);
  void RegisterDartSendPort(Dart_Port send_port);
  Dart_Port GetDartSendPort() const { return send_port_; }
  int64_t HandleMethodCall(const json& no_err_body);
  std::string HandleMethodCallStr(const json& no_err_body);
  int64_t HandlePushVideoFrame(const json& no_err_body, const uint8_t* data,
                               const double* matrix);
  int64_t HandlePushDataFrame(const char* params, const uint8_t* data);
  int64_t HandlePushAudioFrame(const char* params, const uint8_t* data);
  std::shared_ptr<NERtcChannelWrapper> GetChannelWrapper(
      const std::string& channelTag);
  void RemoveChannelWrapper(const std::string& channelTag);
  void ClearChannelWrapper();

 private:
  NERtcDesktopWrapper();
  ~NERtcDesktopWrapper();
  static int64_t HandleEngineInitial(IRtcEngineEx* handle, const json& params);
  static std::string HandleEngineVersion(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleEngineCreateChannel(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleSetParameters(IRtcEngineEx* handle, const json& params);
  static int64_t HandleJoinChannel(IRtcEngineEx* handle, const json& params);
  static int64_t HandleEnableLocalAudio(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleEnableLocalVideo(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleMuteLocalAudio(IRtcEngineEx* handle, const json& params);
  static int64_t HandleMuteLocalVideo(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStartPreview(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopPreview(IRtcEngineEx* handle, const json& params);
  static int64_t HandleEnableDualStreamMode(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleSetLocalVideoConfig(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleSetAudioProfile(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleSetChannelProfile(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSubRemoteAudioStream(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleSubRemoteSubAudioStream(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleSubAllRemoteAudioStream(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleSubRemoteVideoStream(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleSubRemoteSubVideoStream(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleEnableVirtualBackground(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleLeaveChannel(IRtcEngineEx* handle, const json& params);
  static int64_t HandleUploadSdkInfo(IRtcEngineEx* handle, const json& params);
  static int64_t HandleGetConnectionState(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetMediaStatsObserver(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleSetCameraCaptureConfig(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleSetAudioSubscribeOnlyBy(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleStartAudioDump(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopAudioDump(IRtcEngineEx* handle, const json& params);
  static int64_t HandleEnableAudioVolumeIndication(IRtcEngineEx* handle,
                                                   const json& params);
  static int64_t HandleAdjustRecordingSignalVolume(IRtcEngineEx* handle,
                                                   const json& params);
  static int64_t HandleAdjustPlaybackSignalVolume(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleAdjustLoopbackRecordingSignalVolume(IRtcEngineEx* handle,
                                                           const json& params);
  static int64_t HandleSetClientRole(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSendSEIMsg(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSwitchChannel(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStartAudioRecording(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleStartAudioRecordingEx(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleStopAudioRecording(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetLocalMediaPriority(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleEnableMediaPub(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSetRemoteHighPriorityAudioStream(IRtcEngineEx* handle,
                                                        const json& params);
  static int64_t HandleSetCloudProxy(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSetStreamAlignmentProperty(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleGetNtpTimeOffset(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleTakeLocalSnapshot(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleTakeRemoteSnapshot(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetLocalPublishFallbackOption(IRtcEngineEx* handle,
                                                     const json& params);
  static int64_t HandleSetRemoteSubscribeFallbackOption(IRtcEngineEx* handle,
                                                        const json& params);
  static int64_t HandleStartLastMileProbeTest(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleStopLastMileProbeTest(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleReportCustomEvent(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetExternalVideoSource(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleRelease(IRtcEngineEx* handle, const json& params);
  static int64_t HandleEnableSuperResolution(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleEnableEncryption(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleEnableLoopbackRecording(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleCheckNeCastAudioDriver(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleSetLocalVideoWaterMarkConfigs(IRtcEngineEx* handle,
                                                     const json& params);
  static int64_t HandleAdjustUserPlaybackSignalVolume(IRtcEngineEx* handle,
                                                      const json& params);

  // screen capture.
  static std::string HandleGetScreenCaptureSource(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleReleaseScreenCaptureSource(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleGetScreenCaptureCount(IRtcEngineEx* handle,
                                             const json& params);
  static std::string HandleGetScreenCaptureSourceInfo(IRtcEngineEx* handle,
                                                      const json& params);
  static int64_t HandleStartScreenCaptureByScreenRect(IRtcEngineEx* handle,
                                                      const json& params);
  static int64_t HandleStartScreenCaptureByDisplayId(IRtcEngineEx* handle,
                                                     const json& params);
  static int64_t HandleStartScreenCaptureByWindowId(IRtcEngineEx* handle,
                                                    const json& params);
  static int64_t HandleSetScreenCaptureSource(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleUpdateScreenCaptureRegion(IRtcEngineEx* handle,
                                                 const json& params);
  static int64_t HandleSetScreenCaptureMouseCursor(IRtcEngineEx* handle,
                                                   const json& params);
  static int64_t HandleStopScreenCapture(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandlePauseScreenCapture(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleResumeScreenCapture(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleSetExcludeWindowList(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleUpdateScreenCaptureParameters(IRtcEngineEx* handle,
                                                     const json& params);

  // nertc beauty.
  static int64_t HandleStartBeauty(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopBeauty(IRtcEngineEx* handle, const json& params);
  static int64_t HandleEnableBeauty(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSetBeautyEffect(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleAddBeautyFilter(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleRemoveBeautyFilter(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetBeautyFilterLevel(IRtcEngineEx* handle,
                                            const json& params);

  // add live stream task.
  static int64_t HandleAddLiveStreamTask(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleRemoveLiveStreamTask(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleUpdateLiveStreamTask(IRtcEngineEx* handle,
                                            const json& params);

  // device controller.
  static int64_t HandleEnumerateCaptureDevices(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleEnumerateAudioDevices(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleGetDeviceCount(IRtcEngineEx* handle, const json& params);
  static int64_t HandleReleaseDevice(IRtcEngineEx* handle, const json& params);
  static std::string HandleGetDevice(IRtcEngineEx* handle, const json& params);
  static std::string HandleGetDeviceInfo(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetDevice(IRtcEngineEx* handle, const json& params);
  static std::string HandleQueryDevice(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleSetEarback(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSetEarbackVolume(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleIsPlayoutDeviceMute(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleIsRecordDeviceMute(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetPlayoutDeviceMute(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleSetRecordDeviceMute(IRtcEngineEx* handle,
                                           const json& params);

  // video render.
  static int64_t HandleCreateFlutterVideoRender(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleSetupLocalVideoRender(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleSetupRemoteVideoRender(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleSetupPlayingVideoRender(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleSetFlutterVideoMirror(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleSetFlutterVideoScalingMode(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleDisposeFlutterVideoRender(IRtcEngineEx* handle,
                                                 const json& params);

  // media relay.
  static int64_t HandleStartChannelMediaRelay(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleUpdateChannelMediaRelay(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleStopChannelMediaRelay(IRtcEngineEx* handle,
                                             const json& params);

  // audio mixing.
  static int64_t HandleStartAudioMixing(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleStopAudioMixing(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandlePauseAudioMixing(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleResumeAudioMixing(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetAudioMixingSendVolume(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleGetAudioMixingSendVolume(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleSetAudioMixingPlaybackVolume(IRtcEngineEx* handle,
                                                    const json& params);
  static int64_t HandleGetAudioMixingPlaybackVolume(IRtcEngineEx* handle,
                                                    const json& params);
  static int64_t HandleGetAudioMixingDuration(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleGetAudioMixingCurrentPosition(IRtcEngineEx* handle,
                                                     const json& params);
  static int64_t HandleSetAudioMixingPosition(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleSetAudioMixingPitch(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleGetAudioMixingPitch(IRtcEngineEx* handle,
                                           const json& params);

  // audio effect.
  static int64_t HandleStartAudioEffect(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleStopAudioEffect(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleStopAllAudioEffects(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandlePauseAudioEffect(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleResumeAudioEffect(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandlePauseAllAudioEffects(IRtcEngineEx* handle,
                                            const json& params);
  static int64_t HandleResumeAllAudioEffects(IRtcEngineEx* handle,
                                             const json& params);
  static int64_t HandleSetEffectSendVolume(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleGetEffectSendVolume(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleSetEffectPlaybackVolume(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleGetEffectPlaybackVolume(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleGetEffectDuration(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleGetEffectCurrentPosition(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleSetEffectPosition(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetEffectPitch(IRtcEngineEx* handle, const json& params);
  static int64_t HandleGetEffectPitch(IRtcEngineEx* handle, const json& params);

  // audio reverb && preset.
  static int64_t HandleSetLocalVoiceReverbParam(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleSetLocalVoiceReverbPreset(IRtcEngineEx* handle,
                                                 const json& params);
  static int64_t HandleSetVoiceBeautifierPreset(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleSetLocalVoicePitch(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetLocalVoiceEqualization(IRtcEngineEx* handle,
                                                 const json& params);

  static int64_t HandleSetVideoDump(IRtcEngineEx* handle, const json& params);
  static std::string HandleGetParameter(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleSetVideoStreamLayerCount(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleEnableLocalData(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleSubscribeRemoteData(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleGetFeatureSupportedType(IRtcEngineEx* handle,
                                               const json& params);
  static int64_t HandleIsFeatureSupported(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetSubscribeAudioBlocklist(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleSetSubscribeAudioAllowlist(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleGetNetworkType(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopPushStreaming(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleStopPlayStreaming(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandlePausePlayStreaming(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleResumePlayStreaming(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleMuteVideoForPlayStreaming(IRtcEngineEx* handle,
                                                 const json& params);
  static int64_t HandleMuteAudioForPlayStreaming(IRtcEngineEx* handle,
                                                 const json& params);
  static int64_t HandleStopASRCaption(IRtcEngineEx* handle, const json& params);
  static int64_t HandleAIManualInterrupt(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetAINSMode(IRtcEngineEx* handle, const json& params);
  static int64_t HandleSetAudioScenario(IRtcEngineEx* handle,
                                        const json& params);
  static int64_t HandleSetExternalAudioSource(IRtcEngineEx* handle,
                                              const json& params);
  static int64_t HandleSetExternalSubStreamAudioSource(IRtcEngineEx* handle,
                                                       const json& params);
  static int64_t HandleSetAudioRecvRange(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetRangeAudioMode(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleSetRangeAudioTeamID(IRtcEngineEx* handle,
                                           const json& params);
  static int64_t HandleEnableSpatializerRoomEffects(IRtcEngineEx* handle,
                                                    const json& params);
  static int64_t HandleSetSpatializerRenderMode(IRtcEngineEx* handle,
                                                const json& params);
  static int64_t HandleEnableSpatializer(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleIitSpatializer(IRtcEngineEx* handle, const json& params);
  static int64_t HandleUpdateSelfPosition(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleSetSpatializerRoomProperty(IRtcEngineEx* handle,
                                                  const json& params);
  static int64_t HandleAddLocalRecorderStreamForTask(IRtcEngineEx* handle,
                                                     const json& params);
  static int64_t HandleRemoveLocalRecorderStreamForTask(IRtcEngineEx* handle,
                                                        const json& params);
  static int64_t HandleAddLocalRecorderStreamLayoutForTask(IRtcEngineEx* handle,
                                                           const json& params);
  static int64_t HandleRemoveLocalRecorderStreamLayoutForTask(
      IRtcEngineEx* handle, const json& params);
  static int64_t HandleUpdateLocalRecorderStreamLayoutForTask(
      IRtcEngineEx* handle, const json& params);
  static int64_t HandleReplaceLocalRecorderStreamLayoutForTask(
      IRtcEngineEx* handle, const json& params);
  static int64_t HandleUpdateLocalRecorderWaterMarksForTask(
      IRtcEngineEx* handle, const json& params);
  static int64_t HandleShowLocalRecorderStreamDefaultCoverForTask(
      IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopLocalRecorderRemuxMp4(IRtcEngineEx* handle,
                                                 const json& params);
  static int64_t HandleRemuxFlvToMp4(IRtcEngineEx* handle, const json& params);
  static int64_t HandleStopRemuxFlvToMp4(IRtcEngineEx* handle,
                                         const json& params);
  static int64_t HandleStartPushStreaming(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleStartPlayStreaming(IRtcEngineEx* handle,
                                          const json& params);
  static int64_t HandleStartASRCaption(IRtcEngineEx* handle,
                                       const json& params);
  static int64_t HandleSetMultiPathOption(IRtcEngineEx* handle,
                                          const json& params);

  // channel event handler.
 private:
  void onJoinChannel(channel_id_t cid, nertc::uid_t uid, NERtcErrorCode result,
                     uint64_t elapsed) override;
  void onError(int error_code, const char* msg) override;
  void onWarning(int warn_code, const char* msg) override;
  void onApiCallExecuted(const char* api_name, NERtcErrorCode error,
                         const char* message) override;
  void onReleasedHwResources(NERtcErrorCode result) override;
  void onReconnectingStart(channel_id_t cid, nertc::uid_t uid) override;
  void onConnectionStateChange(
      NERtcConnectionStateType state,
      NERtcReasonConnectionChangedType reason) override;
  void onRejoinChannel(channel_id_t cid, nertc::uid_t uid,
                       NERtcErrorCode result, uint64_t elapsed) override;
  void onLeaveChannel(NERtcErrorCode result) override;
  void onDisconnect(NERtcErrorCode reason) override;
  void onClientRoleChanged(NERtcClientRole oldRole,
                           NERtcClientRole newRole) override;
  void onUserJoined(nertc::uid_t uid, const char* user_name,
                    NERtcUserJoinExtraInfo join_extra_info) override;
  void onUserLeft(nertc::uid_t uid, NERtcSessionLeaveReason reason,
                  NERtcUserJoinExtraInfo leave_extra_info) override;
  void onUserAudioStart(nertc::uid_t uid) override;
  void onUserAudioStop(nertc::uid_t uid) override;
  void onUserVideoStart(nertc::uid_t uid,
                        NERtcVideoProfileType max_profile) override;
  void onUserVideoStop(nertc::uid_t uid) override;
  void onUserSubStreamAudioStart(nertc::uid_t uid) override;
  void onUserSubStreamAudioStop(nertc::uid_t uid) override;
  void onUserAudioMute(nertc::uid_t uid, bool mute) override;
  void onUserVideoMute(NERtcVideoStreamType videoStreamType, nertc::uid_t uid,
                       bool mute) override;
  void onUserSubStreamAudioMute(nertc::uid_t uid, bool mute) override;
  void onFirstAudioDataReceived(nertc::uid_t uid) override;
  void onFirstVideoDataReceived(NERtcVideoStreamType type,
                                nertc::uid_t uid) override;
  void onFirstAudioFrameDecoded(nertc::uid_t uid) override;
  void onFirstVideoFrameDecoded(NERtcVideoStreamType type, nertc::uid_t uid,
                                uint32_t width, uint32_t height) override;
  void onVirtualBackgroundSourceEnabled(
      bool enabled, NERtcVirtualBackgroundSourceStateReason reason) override;
  void onNetworkConnectionTypeChanged(
      NERtcNetworkConnectionType newConnectionType) override;
  void onLocalAudioVolumeIndication(int volume, bool enable_vad) override;
  void onRemoteAudioVolumeIndication(const NERtcAudioVolumeInfo* speakers,
                                     unsigned int speaker_number,
                                     int total_volume) override;
  void onAudioHowling(bool howling) override;
  void onLastmileQuality(NERtcNetworkQualityType quality) override;
  void onLastmileProbeResult(const NERtcLastmileProbeResult& result) override;
  void onAddLiveStreamTask(const char* task_id, const char* url,
                           int error_code) override;
  void onUpdateLiveStreamTask(const char* task_id, const char* url,
                              int error_code) override;
  void onRemoveLiveStreamTask(const char* task_id, int error_code) override;
  void onLiveStreamState(const char* task_id, const char* url,
                         NERtcLiveStreamStateCode state) override;
  void onRecvSEIMsg(nertc::uid_t uid, const char* data,
                    uint32_t dataSize) override;
  void onAudioRecording(NERtcAudioRecordingCode code,
                        const char* file_path) override;
  void onMediaRightChange(bool is_audio_banned, bool is_video_banned) override;
  void onMediaRelayStateChanged(NERtcChannelMediaRelayState state,
                                const char* channel_name) override;
  void onMediaRelayEvent(NERtcChannelMediaRelayEvent event,
                         const char* channel_name,
                         NERtcErrorCode error) override;
  void onLocalPublishFallbackToAudioOnly(
      bool is_fallback, NERtcVideoStreamType stream_type) override;
  void onRemoteSubscribeFallbackToAudioOnly(
      nertc::uid_t uid, bool is_fallback,
      NERtcVideoStreamType stream_type) override;
  void onLocalVideoWatermarkState(NERtcVideoStreamType videoStreamType,
                                  NERtcLocalVideoWatermarkState state) override;
  void onUserSubStreamVideoStart(nertc::uid_t uid,
                                 NERtcVideoProfileType max_profile) override;
  void onUserSubStreamVideoStop(nertc::uid_t uid) override;

  void onAsrCaptionStateChanged(NERtcAsrCaptionState state, int code,
                                const char* message) override;
  void onAsrCaptionResult(const NERtcAsrCaptionResult* results,
                          unsigned int result_count) override;
  void onPlayStreamingStateChange(const char* stream_id,
                                  NERtcPlayStreamState state,
                                  NERtcErrorCode error) override;
  void onPlayStreamingReceiveSeiMessage(const char* stream_id,
                                        const char* message) override;
  void onPlayStreamingFirstAudioFramePlayed(const char* stream_id,
                                            int64_t time_ms) override;
  void onPlayStreamingFirstVideoFrameRender(const char* stream_id,
                                            int64_t time_ms, uint32_t width,
                                            uint32_t height) override;
  void onFirstVideoFrameRender(NERtcVideoStreamType type, nertc::uid_t uid,
                               uint32_t width, uint32_t height,
                               uint64_t elapsed) override;
  void onLocalVideoRenderSizeChanged(NERtcVideoStreamType type, uint32_t width,
                                     uint32_t height) override;
  void onUserVideoProfileUpdate(nertc::uid_t uid,
                                NERtcVideoProfileType max_profile) override;
  void onAudioDeviceStateChanged(const char device_id[kNERtcMaxDeviceIDLength],
                                 NERtcAudioDeviceType device_type,
                                 NERtcAudioDeviceState device_state) override;
  void onVideoDeviceStateChanged(const char device_id[kNERtcMaxDeviceIDLength],
                                 NERtcVideoDeviceType device_type,
                                 NERtcVideoDeviceState device_state) override;
  void onUserDataStart(nertc::uid_t uid) override;
  void onUserDataStop(nertc::uid_t uid) override;
  void onUserDataReceiveMessage(nertc::uid_t uid, void* pData,
                                uint64_t size) override;
  void onUserDataStateChanged(nertc::uid_t uid) override;
  void onUserDataBufferedAmountChanged(nertc::uid_t uid,
                                       uint64_t previousAmount) override;
  void onLabFeatureCallback(const char* key, const char* param) override;
  void onAiData(const char* type, const char* data) override;
  void onStartPushStreaming(NERtcErrorCode result, channel_id_t cid) override;
  void onStopPushStreaming(NERtcErrorCode result) override;
  void onPushStreamingChangeToReconnecting(NERtcErrorCode reason) override;
  void onPushStreamingReconnectedSuccess() override;
  void onScreenCaptureStatus(NERtcScreenCaptureStatus status) override;
  void onScreenCaptureSourceDataUpdate(
      NERtcScreenCaptureSourceData data) override;
  void onLocalRecorderStatus(NERtcLocalRecorderStatus status,
                             const char* task_id) override;
  void onLocalRecorderError(NERtcLocalRecorderError error,
                            const char* task_id) override;
  void onCheckNECastAudioDriverResult(
      NERtcInstallCastAudioDriverResult result) override;
  void onRemoteVideoReceiveSizeChanged(nertc::uid_t uid,
                                       NERtcVideoStreamType type,
                                       uint32_t width,
                                       uint32_t height) override;

  // audio mixing, effect observer.
 private:
  void onAudioMixingStateChanged(NERtcAudioMixingState state,
                                 NERtcAudioMixingErrorCode error_code) override;
  void onAudioMixingTimestampUpdate(uint64_t timestamp_ms) override;
  void onAudioEffectFinished(uint32_t effect_id) override;
  void onAudioEffectTimestampUpdate(uint32_t effect_id,
                                    uint64_t timestamp_ms) override;

  // media stats observer.
 private:
  void onRtcStats(const NERtcStats& stats) override;
  void onLocalAudioStats(const NERtcAudioSendStats& stats) override;
  void onRemoteAudioStats(const NERtcAudioRecvStats* stats,
                          unsigned int user_count) override;
  void onLocalVideoStats(const NERtcVideoSendStats& stats) override;
  void onRemoteVideoStats(const NERtcVideoRecvStats* stats,
                          unsigned int user_count) override;
  void onNetworkQuality(const NERtcNetworkQualityInfo* infos,
                        unsigned int user_count) override;

 private:
  IRtcEngineEx* rtc_engine_ = nullptr;
  DartCallback dart_callback_;
  Dart_Port send_port_;
  std::map<std::string, std::shared_ptr<NERtcChannelWrapper>> channel_map_;
  std::mutex channel_map_mutex_;

 private:
  static IDeviceCollection* video_device_collection_;
  static IDeviceCollection* audio_cap_device_collection_;
  static IDeviceCollection* audio_play_device_collection_;
  static std::map<std::string, RefCountImpl<IScreenCaptureSourceList>>
      screen_capture_source_list_map_;
  static std::mutex source_list_mutex_;  // 添加互斥锁
};

class NERtcSnapshotCallbackWrapper : public NERtcTakeSnapshotCallback,
                                     public IRtcMediaStatsObserver {
 public:
  static NERtcSnapshotCallbackWrapper* Create(std::string& path);
  static void Delete(NERtcSnapshotCallbackWrapper* callback);
  static void Clear();

 public:
  void onTakeSnapshotResult(int errorCode, const char* image) override;

 private:
  static std::set<NERtcSnapshotCallbackWrapper*> snapshot_callback_set_;
  static std::mutex snapshot_callback_set_mutex_;
  std::string path_;
};

#endif  // _NERTC_WRAPPER_H_