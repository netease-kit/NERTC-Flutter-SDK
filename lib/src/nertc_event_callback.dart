// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// NERtc 异步回调接口，用户需要实现该接口来完成对NERtc各种状态回调的处理
abstract class NERtcChannelEventCallback {
  /// 加入房间回调
  ///
  /// [result] 参考 [ErrorCode]
  /// [channelId] 分配的Channel ID
  /// [elapsed] 加入房间总耗时(毫秒)
  /// [uid] 用户 ID。 如果在 [NERtcEngine.joinChannel] 方法中指定了 uid，此处会返回指定的 ID; 如果未指定 uid，此处将返回云信服务器自动分配的 ID。
  void onJoinChannel(int result, int channelId, int elapsed, int uid);

  /// 退出房间回调
  ///
  /// [result] 参考 [ErrorCode]
  void onLeaveChannel(int result);

  /// 用户加入房间.
  ///
  /// [uid] 用户ID
  void onUserJoined(int uid);

  /// 用户离开房间
  ///
  /// [uid] 用户ID
  void onUserLeave(int uid, int reason);

  /// 远端用户开启音频功能。
  ///
  /// [uid]  远端用户ID.
  void onUserAudioStart(int uid);

  /// 远端用户关闭音频功能。
  ///
  /// [uid]  远端用户ID.
  void onUserAudioStop(int uid);

  /// 远端用户开启视频功能。
  ///
  /// [uid]  远端用户ID.
  /// [maxProfile] 最大支持分辨率 [NERtcVideoProfile]
  void onUserVideoStart(int uid, int maxProfile);

  /// 远端用户关闭视频功能。
  ///
  /// [uid]  远端用户ID.
  void onUserVideoStop(int uid);

  /// SDK与服务器断线回调
  ///
  /// [reason] 断线原因
  void onDisconnect(int reason);

  /// 远端用户关闭音频的发送。
  ///
  /// [uid]   远端用户ID.
  /// [muted] 是否关闭音频.
  void onUserAudioMute(int uid, bool muted);

  /// 远端用户是否关闭视频的发送
  ///
  /// [uid]   远端用户ID
  /// [muted] 是否关闭视频
  void onUserVideoMute(int uid, bool muted);

  /// 远端音频首帧回调
  /// [uid] 远端用户 ID
  void onFirstAudioDataReceived(int uid);

  /// 远端视频首帧回调
  ///
  /// [uid] 远端用户 ID
  void onFirstVideoDataReceived(int uid);

  /// 远端音频首帧解码回调
  ///
  /// [uid] 远端用户 ID
  void onFirstAudioFrameDecoded(int uid);

  /// 远端视频首帧解码回调
  ///
  /// [uid] 远端用户 ID
  /// [width] 首帧视频宽
  /// [height] 首帧视频高
  void onFirstVideoFrameDecoded(int uid, int width, int height);

  /// 用户视频能力更新
  ///
  /// [uid] 用户 ID
  /// [maxProfile] 最大支持分辨率 [NERtcVideoProfile]
  void onUserVideoProfileUpdate(int uid, int maxProfile);

  /// 本地网络类型已改变回调
  ///
  /// [newConnectionType] 参考 [NERtcConnectionType]
  void onConnectionTypeChanged(int newConnectionType);

  /// 重连开始回调，SDK内部进行重连时回调，重连结果参考 [onReJoinChannel]、[onDisconnect]
  void onReconnectingStart();

  /// 重新加入频道回调
  /// 有时候由于网络原因，客户端可能会和服务器失去连接，SDK会进行自动重连，自动重连后触发此回调方法
  ///
  /// [result] 参考 [ErrorCode]
  void onReJoinChannel(int result);

  /// 提示频道内本地用户瞬时音量的回调。
  /// 该回调默认禁用。可以通过 [enableAudioVolumeIndication] 方法开启；
  /// 开启后，本地用户说话，SDK 会按 enableAudioVolumeIndication 方法中设置的时间间隔触发该回调。
  /// 如果本地用户将自己静音（调用了 muteLocalAudioStream），SDK 不再报告该回调。
  ///
  /// [volume] （混音后的）音量，取值范围为 [0,100]。
  void onLocalAudioVolumeIndication(int volume);

  /// 提示频道内谁正在说话及说话者瞬时音量的回调。
  /// 该回调默认禁用。可以通过 enableAudioVolumeIndication 方法开启；
  /// 开启后，无论频道内是否有人说话，SDK 都会按 enableAudioVolumeIndication 方法中设置的时间间隔触发该回调
  ///
  /// 在返回的数组中:
  /// - 如果有 uid 出现在上次返回的数组中，但不在本次返回的数组中，则默认该 uid 对应的远端用户没有说话。
  /// - 如果volume 为 0，表示该用户没有说话。
  /// - 如果数组为空，则表示此时远端没有人说话。
  ///
  /// [volumeList] 每个说话者的用户 ID 和音量信息的数组: [NERtcAudioVolumeInfo]
  /// [totalVolume] 混音后的总音量 取值范围为 [0,100]。
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume);

  /// 频道连接状态回调
  /// [state] 当前的网络连接状态 [NERtcConnectionState]
  /// [reason] 引起当前网络连接状态发生改变的原因 [ConnectionStateChangeReason]
  void onConnectionStateChanged(int state, int reason);

  /// 直播状态回调
  /// [taskId] 直播task id
  /// [pushUrl] 直播推流url
  /// [liveState] 直播状态 [NERtcLiveStreamState]
  void onLiveStreamState(String taskId, String pushUrl, int liveState);

  /// 角色切换成功回调
  /// 直播场景下，如果您在加入房间后调用该方法切换用户角色，调用成功后，会触发回调
  /// 角色定义参考 [NERtcClientRole].
  /// [oldRole] 之前的角色.
  /// [newRole] 现在的角色
  void onClientRoleChange(int oldRole, int newRole);

  /// 发生警告回调
  /// 该回调方法表示 SDK 运行时出现了（网络或媒体相关的）警告。
  /// 通常情况下，SDK 上报的警告信息 App 可以忽略，SDK 会自动恢复
  void onError(int code);

  /// 发生错误回调
  /// 该回调方法表示 SDK 运行时出现了（网络或媒体相关的）错误。
  /// 通常情况下，SDK上报的错误意味着SDK无法自动恢复，需要 App 干预或提示用户
  void onWarning(int code);

  /// 远端用户开启视频辅流
  ///
  /// [uid] 远端用户ID.
  /// [maxProfile] 最大支持分辨率. [NERtcVideoProfile]
  void onUserSubStreamVideoStart(int uid, int maxProfile);

  /// 远端用户开启视频辅流
  ///
  /// [uid] 远端用户ID.
  void onUserSubStreamVideoStop(int uid);

  ///  啸叫检测回调
  ///  用于检测是否由于设备距离过近产生啸叫。
  ///  当检测到有啸叫信号产生的时候，触发该回调一直到啸叫停止
  ///  上层用户接收到回调信息，代表有啸叫产生，用户可提示用户mute麦克风或者是直接操作mute麦克风
  ///  啸叫检测用于VoIP场景，音乐场景不支持啸叫检测
  void onAudioHasHowling();

  /// 收到sei 信息
  ///
  /// [uid] 远端用户ID.
  /// [seiMsg] SEI 信息
  void onReceiveSEIMsg(int userID, String seiMsg);

  /// 音频录制状态回调
  /// [code] 音频录制状态码。详细信息请参考 [NERtcAudioRecordingCode]
  /// [filePath] 音频录制文件保存路径
  void onAudioRecording(int code, String filePath);

  /// 跨房间媒体流转发状态发生改变回调
  ///
  /// [state] 当前跨房间媒体流转发状态。详细信息请参考 [NERtcChannelMediaRelayState]
  /// [channelName] 媒体流转发的目标房间名
  void onMediaRelayStatesChange(int state, String channelName);

  /// 媒体流相关转发事件回调
  ///
  /// [event] 当前媒体流转发事件。详细信息请参考[NERtcChannelMediaRelayEvent]
  /// [code] 相关错误码。详细信息请参考 [NERtcErrorCode]
  /// [channelName] 媒体流转发的目标房间名
  void onMediaRelayReceiveEvent(int event, int code, String channelName);

  /// 本地发布流已回退为音频流、或已恢复为音视频流回调。
  ///
  /// 如果您调用了设置本地推流回退选项 [NERtcEngine.setLocalPublishFallbackOption] 接口，
  /// 并将参数设置为 [NERtcStreamFallbackOptions.audioOnly] 后，当上行网络环境不理想、本地发布的媒体流回退为音频流时，
  /// 或当上行网络改善、媒体流恢复为音视频流时，会触发该回调。
  ///
  ///
  /// [isFallback] 本地发布流已回退或已恢复:
  /// - `true`： 由于网络环境不理想，发布的媒体流已回退为音频流。
  /// - `false`：由于网络环境改善，从音频流恢复为音视频流。
  ///
  /// [streamType] 对应的视频流类型，即主流或辅流。详细信息请参考 [NERtcVideoStreamType]
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType);

  /// 订阅的远端流已回退为音频流、或已恢复为音视频流回调。
  /// 如果你调用了设置远端订阅流回退选项 [NERtcEngine.setRemoteSubscribeFallbackOption] 接口,
  /// 并将参数设置 [NERtcStreamFallbackOptions.audioOnly] 后，当下行网络环境不理想、仅接收远端音频流时，
  /// 或当下行网络改善、恢复订阅音视频流时，会触发该回调。
  ///
  /// [isFallback] 远端订阅流已回退或恢复：
  /// - `true`： 由于网络环境不理想，订阅的远端流已回退为音频流。
  /// - `false`：由于网络环境改善，订阅的远端流从音频流恢复为音视频流。
  ///
  /// [uid] 为远端用户ID，[streamType] 对应的视频流类型，即主流或辅流。详细信息请参考 [NERtcVideoStreamType]
  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType);
}

abstract class NERtcDeviceEventCallback {
  /// 语音播放设备发生改变
  ///
  /// [selected] 选择的设备 [NERtcAudioDevice]
  void onAudioDeviceChanged(int selected);

  ///音频设备状态回调
  ///
  /// [deviceType] 选择的设备 [NERtcAudioDeviceType]
  /// [deviceState] 选择的设备 [NERtcAudioDeviceState]
  void onAudioDeviceStateChange(int deviceType, int deviceState);

  ///视频设备状态回调
  ///
  /// [deviceState] 选择的设备 [NERtcVideoDeviceState]
  void onVideoDeviceStageChange(int deviceState);
}

/// 伴音相关事件通知
abstract class NERtcAudioMixingEventCallback {
  /// 混音任务状态回调
  ///
  /// [reason] 0: 正常结束  1: 混音出错
  void onAudioMixingStateChanged(int reason);

  /// 混音进度回调
  ///
  /// [timestampMs] 混音当前时间戳
  void onAudioMixingTimestampUpdate(int timestampMs);
}

/// 音效相关事件通知
abstract class NERtcAudioEffectEventCallback {
  /// 音效结束回调
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  void onAudioEffectFinished(int effectId);
}

/// 当前通话统计回调
abstract class NERtcStatsEventCallback {
  /// 当前通话统计回调
  ///  SDK 定期向 App 报告当前通话的统计信息，每 2 秒触发一次。
  void onRtcStats(NERtcStats stats);

  /// 本地音频流统计信息回调
  ///  该回调描述本地设备发送音频流的统计信息，每 2 秒触发一次。
  void onLocalAudioStats(NERtcAudioSendStats stats);

  /// 通话中远端音频流的统计信息回调。
  ///  该回调描述远端用户在通话中端到端的音频流统计信息，每 2 秒触发一次。
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList);

  ///  本地视频流统计信息回调
  ///  该回调描述本地设备发送视频流的统计信息，每 2 秒触发一次。
  void onLocalVideoStats(NERtcVideoSendStats stats);

  ///  通话中远端视频流的统计信息回调
  ///  该回调描述远端用户在通话中端到端的视频流统计信息，每 2 秒触发一次。
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList);

  ///  通话中每个用户的网络上下行质量报告回调
  ///  该回调描述每个用户在通话中的网络状态，每 2 秒触发一次。
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList);
}
