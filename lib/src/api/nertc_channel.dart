// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

abstract class NERtcChannel {
  void setEventCallback(NERtcChannelEventCallback callback);

  void removeEventCallback(NERtcChannelEventCallback callback);

  void setStatsEventCallback(NERtcStatsEventCallback callback);

  void removeStatsEventCallback(NERtcStatsEventCallback callback);

  Future<String> getChannelName(String channelTag);

  Future<int> setChannelProfile(int channelProfile);

  Future<int> joinChannel(String? token, String channelName, int uid,
      NERtcJoinChannelOptions? channelOptions);

  Future<int> leaveChannel();

  Future<int> setClientRole(int role);

  Future<int> getConnectionState();

  Future<int> release();

  /**
   * 媒体流发送，暂时仅支持音频
   * @param mediaType [NERtcMediaPubType]
   */
  Future<int> enableMediaPub(int mediaType, bool enable);

  Future<int> enableLocalAudio(bool enable);

  Future<int> muteLocalAudioStream(bool mute);

  Future<int> subscribeRemoteAudio(int uid, bool subscribe);

  Future<int> subscribeRemoteSubStreamAudio(int uid, bool subscribe);

  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig,
      {int streamType = NERtcVideoStreamType.main});

  Future<int> enableLocalVideo(bool enable,
      {int streamType = NERtcVideoStreamType.main});

  Future<int> muteLocalVideoStream(bool mute,
      {int streamType = NERtcVideoStreamType.main});

  Future<int> switchCamera();

  Future<int> subscribeRemoteVideoStream(
      int uid, int streamType, bool subscribe);

  Future<int> subscribeRemoteSubVideoStream(int uid, bool subscribe);

  Future<int> enableAudioVolumeIndication(bool enable, int interval,
      {bool vad = false});

  Future<int> takeLocalSnapshot(int streamType, String path);

  Future<int> takeRemoteSnapshot(int uid, int streamType, String path);

  // add new interface.
  /// 订阅或取消订阅所有远端用户的音频主流。 （后续加入的用户也同样生效）
  Future<int> subscribeAllRemoteAudio(bool subscribe);

  /// 设置本地摄像头的采集偏好等配置。
  Future<int> setCameraCaptureConfig(NERtcCameraCaptureConfig captureConfig,
      {int streamType = NERtcVideoStreamType.main});

  /// 设置视频流层数
  Future<int> setVideoStreamLayerCount(int layerCount);

  /// 获取功能支持类型
  Future<int> getFeatureSupportedType(NERtcFeatureType featureType);

  ///指定前置/后置摄像头
  Future<int> switchCameraWithPosition(int position);

  /// 开启屏幕共享。
  /// exclude pc interface.
  Future<int> startScreenCapture(NERtcScreenConfig config);

  /// 关闭屏幕共享。
  Future<int> stopScreenCapture();

  ///开启或关闭外部视频源数据输入。
  Future<int> setExternalVideoSource(bool enable,
      {int streamType = NERtcVideoStreamType.main});

  ///推送外部视频帧。
  Future<int> pushExternalVideoFrame(NERtcVideoFrame frame,
      {int streamType = NERtcVideoStreamType.main});

  /// 添加房间内推流任务。成功添加后当前用户可以收到该直播流的状态通知。通话中有效。
  Future<int> addLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo);

  /// 更新房间内指定推流任务。通过此接口可以实现调整指定推流任务的编码参数、画布布局、推流模式等。
  Future<int> updateLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo);

  /// 删除房间内指定推流任务。
  Future<int> removeLiveStreamTask(String taskId);

  /// 指定主流或辅流通道发送媒体增强补充信息（SEI）。 在本端推流传输视频流数据同时，发送流媒体补充增强信息来同步一些其他附加信息。
  Future<int> sendSEIMsg(String seiMsg,
      {int streamType = NERtcVideoStreamType.main});

  /// 设置本地用户的媒体流优先级。
  Future<int> setLocalMediaPriority(int priority, bool isPreemptive);

  /// 开始跨房间媒体流转发。
  Future<int> startChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config);

  /// 更新媒体流转发的目标房间。
  Future<int> updateChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config);

  /// 停止跨房间媒体流转发。
  Future<int> stopChannelMediaRelay();

  /// 调节本地播放的指定远端用户的信号音量。
  Future<int> adjustUserPlaybackSignalVolume(int uid, int volume);

  /// 设置弱网条件下发布的音视频流回退选项。
  Future<int> setLocalPublishFallbackOption(int option);

  /// 设置弱网条件下订阅的音视频流回退选项。
  Future<int> setRemoteSubscribeFallbackOption(int option);

  /// 开启或关闭媒体流加密。
  Future<int> enableEncryption(bool enable, NERtcEncryptionConfig config);

  ///设置远端用户音频流的高优先级。 支持在音频自动订阅的情况下，设置某一个远端用户的音频为最高优先级，可以优先听到该用户的音频
  Future<int> setRemoteHighPriorityAudioStream(bool enabled, int uid,
      {int streamType});

  ///设置自己的音频只能被房间内指定的人订阅。 默认房间所有其他人都可以订阅自己的音频。
  Future<int> setAudioSubscribeOnlyBy(List<int>? uidArray);

  ///开启或关闭音频辅流。
  Future<int> enableLocalSubStreamAudio(bool enable);

  /// 启用本地数据
  Future<int> enableLocalData(bool enable);

  /// 订阅远端数据
  Future<int> subscribeRemoteData(int uid, bool subscribe);

  Future<int> sendData(NERtcDataExternalFrame frame);

  ///用户自定义上报事件。
  Future<int> reportCustomEvent(
      String eventName, String? customIdentify, Map<String?, Object?>? param);

  Future<int> setAudioRecvRange(int audibleDistance, int conversationalDistance,
      NERtcDistanceRollOffModel rollOffModel);

  Future<int> setRangeAudioMode(NERtcRangeAudioMode audioMode);

  Future<int> setRangeAudioTeamID(int teamID);

  Future<int> updateSelfPosition(NERtcPositionInfo positionInfo);

  Future<int> enableSpatializerRoomEffects(bool enable);

  Future<int> setSpatializerRoomProperty(NERtcSpatializerRoomProperty property);

  Future<int> setSpatializerRenderMode(NERtcSpatializerRenderMode renderMode);

  Future<int> enableSpatializer(bool enable, bool applyToTeam);

  Future<int> initSpatializer();

  /// 设置订阅音频黑名单
  /// streamType 参考 [NERtcAudioStreamType]
  Future<int> setSubscribeAudioBlocklist(List<int> uidList, int streamType);

  /// 设置订阅音频白名单
  Future<int> setSubscribeAudioAllowlist(List<int> uidList);

  // ====  Only sub channel interface. ======

  /// 获得一个可以分享的屏幕和窗口的列表
  IScreenCaptureList? getScreenCaptureSources(
      NERtcSize thumbSize, NERtcSize iconSize, bool includeScreen);

  /// 开启屏幕共享，共享范围为指定屏幕的指定区域。
  int startScreenCaptureByScreenRect(NERtcRectangle screenRect,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams);

  /// 开启屏幕共享，共享范围为指定屏幕的指定区域。
  int startScreenCaptureByDisplayId(int displayId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams);

  /// 通过指定屏幕 ID 开启屏幕共享。
  int startScreenCaptureByWindowId(int windowId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams);

  /// 设置屏幕分享参数，该方法在屏幕分享过程中调用，用来快速切换采集源。
  int setScreenCaptureSource(NERtcScreenCaptureSourceInfo source,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams);

  /// 在共享屏幕或窗口时，更新共享的区域。
  int updateScreenCaptureRegion(NERtcRectangle regionRect);

  /// 在共享屏幕或窗口时，更新是否显示鼠标。
  int setScreenCaptureMouseCursor(bool captureCursor);

  /// 暂停屏幕共享。
  int pauseScreenCapture();

  /// 恢复屏幕共享。
  int resumeScreenCapture();

  /// 设置共享整个屏幕或屏幕指定区域时，需要屏蔽的窗口列表。
  int setExcludeWindowList(List<int> windowLists, int count);

  /// 更新屏幕共享参数。
  int updateScreenCaptureParameters(NERtcScreenCaptureParameters captureParams);
}
