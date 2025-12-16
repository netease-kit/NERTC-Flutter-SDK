// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 用户房间事件回调通知
mixin class NERtcChannelEventCallback {
  /// 加入房间回调，表示客户端已经登入服务器。
  ///
  /// [result] 0 表示加入房间成功；其他值表示加入房间失败，详细错误码请参考 [NERtcErrorCode]
  ///
  /// [channelId] 客户端加入的房间 ID。
  ///
  /// [elapsed] 加入房间总耗时，从 joinChannel 开始到发生此事件过去的时间，单位为毫秒。
  ///
  /// [uid] 用户 ID。 如果在 [NERtcEngine.joinChannel] 方法中指定了 uid，此处会返回指定的 ID; 如果未指定 uid，此处将返回云信服务器自动分配的 ID。
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {}

  /// 退出房间回调，App 调用 [leaveChannel] 方法后，SDK 提示 App 退出房间是否成功。
  ///
  /// [result] 0 表示成功；其他值表示退出房间失败，错误码请参考 [NERtcErrorCode]
  void onLeaveChannel(int result) {}

  /// 远端用户加入房间的事件回调。
  ///
  ///  远端用户加入房间或断网重连后，SDK 会触发该回调，可以通过返回的用户 ID 订阅对应用户发布的音、视频流。
  ///      - 通信场景下，该回调通知有远端用户加入了房间，并返回新加入用户的 ID；若该用户加入之前，已有其他用户在房间中，该新加入的用户也会收到这些已有用户加入房间的回调。
  ///      - 直播场景下，该回调通知有主播加入了房间，并返回该主播的用户 ID；若该用户加入之前，已经有主播在房间中了，新加入的用户也会收到已有主播加入房间的回调。
  ///
  ///  **使用前提**
  ///
  ///  请在  [NERtcEngine.create] 初始化接口中注册回调监听。
  ///
  ///  **说明**
  ///
  ///  当 Web 端用户加入直播场景的房间中，只要该用户发布了媒体流，SDK 会默认该用户为主播，并触发此回调。
  ///
  ///  **参数说明**
  ///
  /// [uid] 新加入房间的远端用户 ID。
  /// [joinExtraInfo] 该远端用户加入的额外信息。具体请参见[NERtcUserJoinExtraInfo]。
  void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {}

  /// 远端用户离开房间的事件回调。
  ///
  ///   远端用户离开房间或掉线（在 40 ~ 50 秒内本端用户未收到远端用户的任何数据包）后，SDK 会触发该回调。
  ///
  ///  **使用前提**
  ///
  ///  请在  [NERtcEngine.create] 初始化接口中注册回调监听。
  ///
  ///  **参数说明**
  ///
  /// [uid] 离开房间的远端用户 ID。
  /// [reason] 该远端用户离开的原因，更多请参考 [NERtcErrorCode]。
  /// [leaveExtraInfo] 该远端用户离开的额外信息。
  void onUserLeave(
      int uid, int reason, NERtcUserLeaveExtraInfo? leaveExtraInfo) {}

  /// 远端用户开启音频回调。
  ///
  /// 该回调由远端用户调用 [NERtcEngine.enableLocalAudio] 方法开启音频采集和发送触发。
  ///
  /// [uid]  远端用户ID。
  void onUserAudioStart(int uid) {}

  /// 远端用户开启音频辅流回调
  ///
  /// [uid]  远端用户ID。
  void onUserSubStreamAudioStart(int uid) {}

  /// 远端用户关闭音频回调。
  ///
  /// 该回调由远端用户调用 [NERtcEngine.enableLocalAudio] 方法关闭音频采集和发送触发。
  ///
  /// [uid]  远端用户ID。
  void onUserAudioStop(int uid) {}

  /// 远端用户停用音频辅流回调
  ///
  /// [uid]  远端用户ID。
  void onUserSubStreamAudioStop(int uid) {}

  /// 远端用户开启视频功能。启用后，用户可以进行视频通话或直播。
  ///
  /// [uid]  远端用户ID。提示是哪个用户的视频流。
  ///
  /// [maxProfile] 最大支持分辨率，详细信息请参考 [NERtcVideoProfile]
  void onUserVideoStart(int uid, int maxProfile) {}

  /// 远端用户关闭视频功能。关闭后，用户只能进行语音通话或者直播。
  ///
  /// [uid]  远端用户ID。
  void onUserVideoStop(int uid) {}

  /// 与服务器连接中断，可能原因包括：网络连接失败、服务器关闭该房间、用户被踢出房间等。
  ///
  /// 在调用 [joinChannel] 加入房间成功后，如果和服务器失去连接，就会触发该回调。
  ///
  /// [reason] 连接中断的原因。详细信息请查看 [NERtcErrorCode]。
  void onDisconnect(int reason) {}

  /// 远端用户暂停或恢复发送音频流的回调。
  ///
  /// 该回调由远端用户调用 [NERtcEngine.muteLocalAudioStream] 方法开启或关闭音频发送触发。
  ///
  /// [uid]   远端用户ID。提示是哪个用户的音频流。
  ///
  /// [muted] 是否停止发送音频流：
  ///   - true：该用户已暂停发送音频流。
  ///   - false：该用户已恢复发送音频流。
  void onUserAudioMute(int uid, bool muted) {}

  /// 远端用户是否关闭视频的发送
  ///
  /// 远端用户调用 [NERtcEngine.muteLocalVideoStream] 方法取消或者恢复发布视频流时，SDK 会触发该回调向本地用户通知远端用户的发流情况。
  ///
  /// [uid]   远端用户ID，提示是哪个用户的视频流。
  ///
  /// [muted] 是否暂停发送视频流：
  ///   - true：该用户已暂停发送音频流。
  ///   - false：该用户已恢复发送音频流。
  /// [streamType] 视频通道类型：
  ///     * main（0）：主流。
  ///     * sub（1）：辅流。
  void onUserVideoMute(int uid, bool muted, int? streamType) {}

  /// 远端用户暂停或恢复发送音频辅流的回调。
  ///
  /// [uid]   远端用户ID，提示是哪个用户的音频辅流。
  ///
  /// [muted] 是否停止发送音频辅流。
  ///     - true：该用户已暂停发送音频辅流。
  ///     - false：该用户已恢复发送音频辅流。
  void onUserSubStreamAudioMute(int uid, bool muted) {}

  /// 已接收到远端音频首帧的回调。
  /// [uid] 远端用户 ID，指定是哪个用户的音频流。
  void onFirstAudioDataReceived(int uid) {}

  /// 已显示远端视频首帧的回调。当远端视频的第一帧画面显示在视窗上时，会触发此回调。
  ///
  /// [uid] 远端用户 ID
  ///
  /// [streamType]视频通道类型, 详情参考[NERtcVideoStreamType]
  ///     * main（0）：主流。
  ///     * sub（1）：辅流。
  void onFirstVideoDataReceived(int uid, int? streamType) {}

  /// 已解码远端音频首帧的回调。
  ///
  /// [uid] 远端用户 ID，指定是哪个用户的音频流。
  void onFirstAudioFrameDecoded(int uid) {}

  /// 已接收到远端视频首帧并完成解码的回调。
  ///
  /// [uid] 远端用户 ID，提示是哪个用户的视频流。
  ///
  /// [width] 首帧视频的宽度，单位为 px。
  ///
  /// [height] 首帧视频的高度，单位为 px。
  void onFirstVideoFrameDecoded(
      int uid, int width, int height, int? streamType) {}

  ///通知虚拟背景是否成功开启的回调
  ///
  /// 调用 [NERtcEngine.enableVirtualBackground] 接口启用虚拟背景功能后，SDK 会触发此回调。
  ///
  /// **说明**
  ///
  /// 如果自定义虚拟背景是 PNG 或 JPG 格式的图片，SDK 会在读取图片后才会触发此回调，因此可能存在一定延时。
  ///
  /// [enabled] 是否已成功开启虚拟背景。
  ///   * true：成功开启虚拟背景。
  ///   * false：未成功开启虚拟背景。
  ///
  /// [reason] 虚拟背景开启出错的原因或开启成功的提示。详细信息请参考 [NERtcVirtualBackgroundSourceStateReason]
  void onVirtualBackgroundSourceEnabled(bool enabled, int reason) {}

  /// 本地网络类型已改变回调
  ///
  /// 本地网络连接类型发生改变时，SDK 会触发该回调，并在回调中声明当前正在使用的网络连接类型。
  ///
  /// [newConnectionType] 当前的本地网络类型，详细信息请参考 [NERtcConnectionType]
  void onConnectionTypeChanged(int newConnectionType) {}

  /// 重连开始回调
  ///
  /// 客户端和服务器断开连接时，SDK 会进行重连，重连开始时触发此回调。重连结果请参考 [onReJoinChannel]、[onDisconnect]。
  void onReconnectingStart() {}

  /// 重新加入房间回调。
  ///
  /// 在弱网环境下，若客户端和服务器失去连接，SDK 会自动重连。自动重连成功后触发此回调方法。
  ///
  /// [result] 0 表示成功；其他值表示重新加入失败，错误码请参考 [NERtcErrorCode]
  ///
  /// [channelId] 客户端加入的房间 ID。
  void onReJoinChannel(int result, int channelId) {}

  /// 房间连接状态已改变回调。
  ///
  /// 该回调在房间连接状态发生改变的时候触发，并告知用户当前的房间连接状态和引起房间状态改变的原因。
  ///
  ///[state] 当前的网络连接状态。详细信息请参考 [NERtcConnectionState]
  ///
  /// [reason] 引起当前网络连接状态发生改变的原因。详细信息请参考 [NERtcConnectionStateChangeReason]
  void onConnectionStateChanged(int state, int reason) {}

  /// 提示房间内本地用户瞬时音量的回调。
  ///
  /// 该回调默认禁用。可以通过 [NERtcEngine.enableAudioVolumeIndication] 方法开启；
  ///
  /// 开启后，本地用户说话，SDK 会按 [NERtcEngine.enableAudioVolumeIndication] 方法中设置的时间间隔触发该回调。
  ///
  /// 如果本地用户将自己静音（调用了 [NERtcEngine.muteLocalAudioStream]），SDK 不再报告该回调。
  ///
  /// [volume] 混音后的音量，取值范围为 [0,100]
  ///
  /// [vadFlag] 是否检测到人声
  void onLocalAudioVolumeIndication(int volume, bool vadFlag) {}

  /// 提示房间内谁正在说话及说话者瞬时音量的回调。
  ///
  /// 该回调默认禁用。可以通过 [NERtcEngine.enableAudioVolumeIndication] 方法开启；
  ///
  /// 开启后，无论房间内是否有人说话，SDK 都会按 [NERtcEngine.enableAudioVolumeIndication] 方法中设置的时间间隔触发该回调
  ///
  /// 在返回的数组中:
  ///
  /// - 如果有 uid 出现在上次返回的数组中，但不在本次返回的数组中，则默认该 uid 对应的远端用户没有说话。
  ///
  /// - 如果volume 为 0，表示该用户没有说话。
  ///
  /// - 如果数组为空，则表示此时远端没有人说话。
  ///
  /// [volumeList] 每个说话者的用户 ID 和音量信息的数组: [NERtcAudioVolumeInfo]
  ///
  /// [totalVolume] 混音后的总音量 取值范围为 0~100。
  void onRemoteAudioVolumeIndication(
      List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {}

  /// 推流状态已改变回调。
  ///
  /// [taskId] 推流任务 ID。
  ///
  /// [pushUrl] 推流任务对应的 URL 地址。
  ///
  /// [liveState] 推流状态，详细信息请参考 [NERtcLiveStreamState]。
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {}

  /// 直播场景下用户角色已切换回调。
  ///
  /// 用户加入房间后，通过 [NERtcEngine.setClientRole] 切换用户角色后会触发此回调。例如从主播切换为观众、从观众切换为主播。
  ///
  /// **注意**：
  ///
  /// 直播场景下，如果您在加入房间后调用该方法切换用户角色，调用成功后，会触发以下回调：
  /// - 主播切观众，本端触发 [onClientRoleChange] 回调，远端触发 [onUserLeave] 回调。
  /// - 观众切主播，本端触发 [onClientRoleChange] 回调，远端触发 [onUserJoined] 回调。
  ///
  /// [oldRole] 切换前的角色。详细信息请参考 [NERtcClientRole]。
  ///
  /// [newRole] 切换后的角色。详细信息请参考 [NERtcClientRole]。
  void onClientRoleChange(int oldRole, int newRole) {}

  /// 发生错误回调
  ///
  /// 该回调方法表示 SDK 运行时出现了（网络或媒体相关的）错误。
  ///
  /// 通常情况下，SDK上报的错误意味着SDK无法自动恢复，需要 App 干预或提示用户。
  void onError(int code) {}

  /// 发生警告回调
  ///
  /// 该回调方法表示 SDK 运行时出现了（网络或媒体相关的）警告。
  ///
  /// 通常情况下，SDK 上报的警告信息 App 可以忽略，SDK 会自动恢复。
  void onWarning(int code) {}

  /// 远端用户开启屏幕共享辅流通道的回调。
  ///
  /// [uid] 远端用户ID。
  ///
  /// [maxProfile] 远端视频分辨率等级。详细信息请参考 [NERtcVideoProfile]
  void onUserSubStreamVideoStart(int uid, int maxProfile) {}

  /// 远端用户停止屏幕共享辅流通道的回调。
  ///
  /// [uid] 远端用户ID。
  void onUserSubStreamVideoStop(int uid) {}

  ///  啸叫检测回调。
  ///
  /// 用于检测是否由于设备距离过近产生啸叫。
  ///  当检测到有啸叫信号产生的时候，触发该回调一直到啸叫停止。
  ///
  /// 上层用户接收到回调信息，代表有啸叫产生，用户可提示用户mute麦克风或者是直接操作mute麦克风
  ///
  /// 啸叫检测用于VoIP场景，音乐场景不支持啸叫检测
  void onAudioHasHowling() {}

  /// 收到远端流的 SEI 内容回调。
  ///
  /// 当远端成功发送 SEI 后，本端会收到此回调。
  ///
  /// [uid] 发送 SEI 的用户 ID。
  ///
  /// [seiMsg] SEI 信息
  void onRecvSEIMsg(int userID, String seiMsg) {}

  /// 音频录制状态回调
  /// [code] 音频录制状态码。详细信息请参考 [NERtcAudioRecordingCode]
  ///
  /// [filePath] 音频录制文件保存路径
  void onAudioRecording(int code, String filePath) {}

  ///服务端禁言音视频权限变化回调
  ///
  /// [isAudioBannedByServer] 是否禁用音频。
  ///   * true：禁用音频。
  ///   * false：取消禁用音频。
  ///
  /// [isVideoBannedByServer] 是否禁用视频。
  ///   * true：禁用视频。
  ///   * false：取消禁用视频。
  void onMediaRightChange(
      bool isAudioBannedByServer, bool isVideoBannedByServer) {}

  /// 跨房间媒体流转发状态发生改变回调
  ///
  /// [state] 当前跨房间媒体流转发状态。详细信息请参考 [NERtcChannelMediaRelayState]
  ///
  /// [channelName] 媒体流转发的目标房间名
  void onMediaRelayStatesChange(int state, String channelName) {}

  /// 媒体流相关转发事件回调
  ///
  /// [event] 当前媒体流转发事件。详细信息请参考[NERtcChannelMediaRelayEvent]
  ///
  /// [code] 相关错误码。详细信息请参考 [NERtcErrorCode]
  ///
  /// [channelName] 媒体流转发的目标房间名
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {}

  /// 本地发布流已回退为音频流、或已恢复为音视频流回调。
  ///
  /// 如果您调用了设置本地推流回退选项 [NERtcEngine.setLocalPublishFallbackOption] 接口，并将参数设置为 [NERtcStreamFallbackOptions.audioOnly] 后，当上行网络环境不理想、本地发布的媒体流回退为音频流时，或当上行网络改善、媒体流恢复为音视频流时，会触发该回调。
  ///
  ///
  /// [isFallback] 本地发布流已回退或已恢复:
  ///   - `true`： 由于网络环境不理想，发布的媒体流已回退为音频流。
  ///   - `false`：由于网络环境改善，从音频流恢复为音视频流。
  ///
  /// [streamType] 对应的视频流类型，即主流或辅流。详细信息请参考 [NERtcVideoStreamType]
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {}

  /// 订阅的远端流已回退为音频流、或已恢复为音视频流回调。
  ///
  /// 如果你调用了设置远端订阅流回退选项 [NERtcEngine.setRemoteSubscribeFallbackOption] 接口，并将参数设置 [NERtcStreamFallbackOptions.audioOnly] 后，当下行网络环境不理想、仅接收远端音频流时， 或当下行网络改善、恢复订阅音视频流时，会触发该回调。
  ///
  /// [isFallback] 远端订阅流已回退或恢复：
  ///   - `true`： 由于网络环境不理想，订阅的远端流已回退为音频流。
  ///   - `false`：由于网络环境改善，订阅的远端流从音频流恢复为音视频流。
  ///
  /// [uid] 远端用户ID
  ///
  /// [streamType] 对应的视频流类型，即主流或辅流。详细信息请参考 [NERtcVideoStreamType]
  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType) {}

  ///本地视频水印生效结果回调
  ///
  /// [videoStreamType]对应的视频流类型，即主流或辅流。详细信息请参考[NERtcVideoStreamType]
  ///
  /// [state]	水印状态。详细信息请参考 [NERtcLocalVideoWatermarkState]
  void onLocalVideoWatermarkState(int videoStreamType, int state) {}

  ///通话前网络上下行 last mile 质量状态回调。 该回调描述本地用户在加入房间前的 last mile 网络探测的结果，以打分形式描述上下行网络质量的主观体验，您可以通过该回调预估本地用户在音视频通话中的网络体验。
  ///
  ///在调用 startLastmileProbeTest 之后，SDK 会在约 5 秒内返回该回调。
  ///
  /// [quality] 网络上下行质量，基于上下行网络的丢包率和抖动计算，探测结果主要反映上行网络的状态,详细信息请参考[NERtcNetworkQuality]
  void onLastmileQuality(int quality) {}

  ///通话前网络上下行 Last mile 质量探测报告回调。 该回调描述本地用户在加入房间前的 last mile 网络探测详细报告，报告中通过客观数据反馈上下行网络质量，包括网络抖动、丢包率等数据。您可以通过该回调客观预测本地用户在音视频通话中的网络状态。
  ///
  ///在调用 startLastmileProbeTest 之后，SDK 会在约 30 秒内返回该回调
  ///
  /// [result] 上下行 Last mile 质量探测结果,详细信息请参考 [NERtcLastmileProbeResult]
  void onLastmileProbeResult(NERtcLastmileProbeResult result) {}

  ///截图结果回调
  ///
  /// [code] 错误码。详细信息请参考 [NERtcErrorCode]
  ///
  /// [path] 截图图片存放的路径
  void onTakeSnapshotResult(int code, String path) {}

  /// 权限密钥即将过期事件回调
  ///
  /// 由于 PermissionKey 具有一定的时效，在通话过程中如果 PermissionKey 即将失效，SDK 会提前 30 秒触发该回调，提醒用户更新 PermissionKey。
  ///
  /// 在收到此回调后可以调用 [NERtcEngine.updatePermissionKey]方法更新权限密钥。
  void onPermissionKeyWillExpire() {}

  /// 更新权限密钥事件回调。
  ///
  /// 调用 [NERtcEngine.updatePermissionKey] 方法主动更新权限密钥后，SDK 会触发该回调，返回权限密钥更新的结果
  ///
  /// [key] 新的权限密钥
  ///
  /// [error] 错误码。更多请参考 [NERtcErrorCode]。
  ///
  /// [timeout] 更新后的权限密钥剩余有效时间。单位为秒。
  void onUpdatePermissionKey(String key, int error, int timeout) {}

  /// 实时字幕状态回调。
  ///
  /// [asrState] ASR 字幕状态
  ///
  /// [code] 错误码
  ///
  /// [message] 状态消息
  void onAsrCaptionStateChanged(int asrState, int code, String message) {}

  /// 实时字幕结果回调。
  ///
  /// [result] 字幕结果数组
  ///
  /// [resultCount] 结果数量
  void onAsrCaptionResult(
      List<Map<Object?, Object?>?> result, int resultCount) {}

  /// 播放流状态改变回调。
  ///
  /// [streamId] 播放流 ID
  ///
  /// [state] 播放流状态
  ///
  /// [reason] 状态改变的原因
  void onPlayStreamingStateChange(String streamId, int state, int reason) {}

  /// 播放流接收 SEI 消息回调。
  ///
  /// [streamId] 播放流 ID
  ///
  /// [message] SEI 消息内容
  void onPlayStreamingReceiveSeiMessage(String streamId, String message) {}

  /// 播放流首帧音频播放回调。
  ///
  /// [streamId] 播放流 ID
  ///
  /// [timeMs] 首帧音频播放时间，单位为毫秒
  void onPlayStreamingFirstAudioFramePlayed(String streamId, int timeMs) {}

  /// 播放流首帧视频渲染回调。
  ///
  /// [streamId] 播放流 ID
  ///
  /// [timeMs] 首帧视频渲染时间，单位为毫秒
  ///
  /// [width] 视频宽度
  ///
  /// [height] 视频高度
  void onPlayStreamingFirstVideoFrameRender(
      String streamId, int timeMs, int width, int height) {}

  /// 发送音频首包回调。
  ///
  /// [audioStreamType] 音频流类型
  void onLocalAudioFirstPacketSent(int audioStreamType) {}

  /// 已接收到远端视频首帧并完成渲染的回调。
  ///
  /// [userID] 远端用户 ID
  ///
  /// [streamType] 视频流类型
  ///
  /// [width] 视频宽度
  ///
  /// [height] 视频高度
  ///
  /// [elapsedTime] 从加入房间到首帧渲染的耗时，单位为毫秒
  void onFirstVideoFrameRender(
      int userID, int streamType, int width, int height, int elapsedTime) {}

  /// 本地视频预览的分辨率变化回调。
  ///
  /// 与是否进入房间的状态无关，与硬件状态有关，也适用于预览
  ///
  /// [videoType] 视频流类型
  ///
  /// [width] 视频宽度
  ///
  /// [height] 视频高度
  void onLocalVideoRenderSizeChanged(int videoType, int width, int height) {}

  /// 远端用户视频编码配置已更新回调。
  ///
  /// [uid] 远端用户 ID
  ///
  /// [maxProfile] 最大分辨率等级
  void onUserVideoProfileUpdate(int uid, int maxProfile) {}

  /// 语音播放设备已改变回调。
  ///
  /// [selected] 选中的设备索引
  void onAudioDeviceChanged(int selected) {}

  /// 音频设备状态已改变回调。
  ///
  /// [deviceType] 设备类型
  ///
  /// [deviceState] 设备状态
  void onAudioDeviceStateChange(int deviceType, int deviceState) {}

  /// 视频设备状态已改变回调。
  ///
  /// [deviceState] 设备状态
  void onVideoDeviceStageChange(int deviceState) {}

  /// 接口调用结果通知。
  ///
  /// [apiName] 接口名称
  ///
  /// [result] 调用结果
  ///
  /// [message] 结果消息
  void onApiCallExecuted(String apiName, int result, String message) {}

  /// 接收的远端视频分辨率变化的回调。
  ///
  /// [userId] 远端用户 ID
  ///
  /// [videoType] 视频流类型
  ///
  /// [width] 视频宽度
  ///
  /// [height] 视频高度
  void onRemoteVideoSizeChanged(
      int userId, int videoType, int width, int height) {}

  /// 远端用户开启数据通道的回调。
  ///
  /// [uid] 远端用户 ID
  void onUserDataStart(int uid) {}

  /// 远端用户停用数据通道的回调。
  ///
  /// [uid] 远端用户 ID
  void onUserDataStop(int uid) {}

  /// 远端用户通过数据通道发送数据的回调。
  ///
  /// [uid] 远端用户 ID
  ///
  /// [bufferData] 数据缓冲区
  ///
  /// [bufferSize] 数据大小
  void onUserDataReceiveMessage(
      int uid, Uint8List bufferData, int bufferSize) {}

  /// 远端用户数据通道状态变更回调。
  ///
  /// [uid] 远端用户 ID
  void onUserDataStateChanged(int uid) {}

  /// 远端用户数据通道 buffer 变更回调。
  ///
  /// [uid] 远端用户 ID
  ///
  /// [previousAmount] 之前的 buffer 数量
  void onUserDataBufferedAmountChanged(int uid, int previousAmount) {}

  /// 一些特定功能回调，建议空实现。
  ///
  /// [key] 功能键
  ///
  /// [param] 参数
  void onLabFeatureCallback(String key, Map<Object?, Object?> param) {}

  /// AI功能回调接口。
  ///
  /// [type] 数据类型
  ///
  /// [data] 数据内容
  void onAiData(String type, String data) {}

  /// 开始推流 startPushStreaming 结果回调。
  ///
  /// [result] 推流结果
  ///
  /// [channelId] 房间 ID
  void onStartPushStreaming(int result, int channelId) {}

  /// 停止推流 stopPushStreaming 结果回调。
  ///
  /// [result] 推流结果
  void onStopPushStreaming(int result) {}

  /// 推流过程中断开，变为重连状态回调。
  ///
  /// [reason] 重连原因
  void onPushStreamingReconnecting(int reason) {}

  /// 推流过程中重连成功回调。
  void onPushStreamingReconnectedSuccess() {}

  /// 释放硬件资源的回调。
  ///
  /// [result] 释放结果
  void onReleasedHwResources(int result) {}

  /// 屏幕共享状态变化回调。
  ///
  /// [status] 屏幕共享状态
  void onScreenCaptureStatus(int status) {}

  /// 屏幕共享源采集范围等变化的回调。
  ///
  /// [data] 屏幕共享源数据
  void onScreenCaptureSourceDataUpdate(NERtcScreenCaptureSourceData data) {}

  /// 本地录制状态回调。
  ///
  /// [status] 录制状态
  ///
  /// [taskId] 任务 ID
  void onLocalRecorderStatus(int status, String taskId) {}

  /// 本地录制错误回调。
  ///
  /// [error] 错误码
  ///
  /// [taskId] 任务 ID
  void onLocalRecorderError(int error, String taskId) {}

  /// 收到检测安装声卡的内容回调（仅适用于 Mac 系统）。
  ///
  /// [result] 检测结果
  void onCheckNECastAudioDriverResult(int result) {}
}

/// 通话中统计信息回调通知
mixin class NERtcStatsEventCallback {
  /// 当前通话统计回调
  ///
  /// SDK 定期向 App 报告当前通话的统计信息，每 2 秒触发一次。
  void onRtcStats(NERtcStats stats) {}

  /// 本地音频流统计信息回调
  ///
  /// 该回调描述本地设备发送音频流的统计信息，每 2 秒触发一次。
  void onLocalAudioStats(NERtcAudioSendStats stats) {}

  /// 通话中远端音频流的统计信息回调。
  ///
  /// 该回调描述远端用户在通话中端到端的音频流统计信息，每 2 秒触发一次。
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {}

  ///  本地视频流统计信息回调
  ///
  /// 该回调描述本地设备发送视频流的统计信息，每 2 秒触发一次。
  void onLocalVideoStats(NERtcVideoSendStats stats) {}

  ///  通话中远端视频流的统计信息回调
  ///
  /// 该回调描述远端用户在通话中端到端的视频流统计信息，每 2 秒触发一次。
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {}

  ///  通话中每个用户的网络上下行质量报告回调
  ///
  /// 该回调描述每个用户在通话中的网络状态，每 2 秒触发一次。
  ///
  /// [statsList] 包括下行网络质量 [rxQuality] 和 上行网络质量 [txQuality]。
  ///   * unknown（0）：网络质量未知
  ///   * excellent（1）：质量极好
  ///   * good（2）：用户主观体验相当于极好，但码率可能略低。
  ///   * poor（3）：用户主观体验有瑕疵，但不影响沟通。
  ///   * bad（4）：勉强能沟通，但不顺畅。
  ///   * veryBad（5）：网络质量非常差，基本不能沟通。
  ///   * down（6）： 完全无法沟通。
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {}
}

/// 直播事件回调通知
mixin class NERtcLiveTaskCallback {
  /// 添加直播任务结果回调
  /// [taskId] 直播任务 ID
  ///
  /// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
  void onAddLiveStreamTask(String taskId, int errCode) {}

  /// 删除直播任务结果回调
  /// [taskId] 直播任务 ID
  ///
  /// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
  void onDeleteLiveStreamTask(String taskId, int errCode) {}

  /// 更新直播任务结果回调
  /// [taskId] 直播任务 ID
  ///
  /// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
  void onUpdateLiveStreamTask(String taskId, int errCode) {}
}
