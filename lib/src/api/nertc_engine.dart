// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// NERtc 核心接口
abstract class NERtcEngine {
  static final _instance = _NERtcEngineImpl();
  bool _initialized = false;

  /// 获取全局唯一的 NERTC 实例
  static NERtcEngine get instance => _instance;

  /// 获取设备管理模块
  NERtcDeviceManager get deviceManager;

  /// 获取音效管理模块
  NERtcAudioEffectManager get audioEffectManager;

  /// 获取混音管理模块
  NERtcAudioMixingManager get audioMixingManager;

  NERtcDesktopScreenCapture get desktopScreenCapture;

  /// 设置channel事件回调
  void setEventCallback(NERtcChannelEventCallback callback);

  /// 移除channel事件回调
  void removeEventCallback(NERtcChannelEventCallback callback);

  /// 注册统计信息观测器，设置统计信息回调
  void setStatsEventCallback(NERtcStatsEventCallback callback);

  /// 移除统计信息观测回调
  void removeStatsEventCallback(NERtcStatsEventCallback callback);

  /// 设置房间推流任务事件回调
  void setLiveTaskEventCallback(NERtcLiveTaskCallback callback);

  /// 移除房间推流任务事件回调
  void removeLiveTaskEventCallback(NERtcLiveTaskCallback callback);

  /// 创建 NERtc 实例
  Future<int> create(
      {required String appKey,
      required NERtcChannelEventCallback channelEventCallback,
      NERtcOptions? options});

  Future<NERtcChannel> createChannel(String channelName);

  /// 销毁 NERtc实例，释放资源
  Future<int> release();

  /// NERtc SDK版本号
  Future<NERtcVersion> version();

  /// 检查音视频相关的多媒体设备权限。
  ///
  /// 通过本接口可以实现在音视频通话前，检查多媒体设备的权限，如相机、麦克风、扬声器、磁盘读写、网络权限等
  ///
  /// 返回缺失的权限
  ///
  /// android 独有接口
  Future<List<String?>?> checkPermission();

  /// 设置音视频通话的相关参数。 此接口提供技术预览或特别定制功能，详情请咨询技术支持
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  Future<int> setParameters(NERtcParameters params);

  /// 加入音视频房间。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法。
  ///
  /// **说明**
  ///
  /// 加入音视频房间时，如果指定房间尚未创建，云信服务器内部会自动创建一个同名房间。
  ///
  /// SDK 加入房间后，同一个房间内的用户可以互相通话，多个用户加入同一个房间，可以群聊。使用不同 App Key 的 App 之间不能互通。
  ///
  /// 用户成功加入房间后，默认订阅房间内所有其他用户的音频流，可能会因此产生用量并影响计费。如果想取消订阅，可以通过调用相应的 mute 方法实现。
  ///
  /// 直播场景中，观众角色可以通过 switchChannel 切换房间。
  ///
  /// **参数说明**
  ///
  /// [token] 安全认证签名（NERTC Token）。可设置为：
  ///
  ///   * null。调试模式下可设置为 null。安全性不高，建议在产品正式上线前在云信控制台中将鉴权方式恢复为默认的安全模式。
  ///
  ///   * 已获取的NERTC Token。安全模式下必须设置为获取到的 Token 。若未传入正确的 Token 将无法进入房间。推荐使用安全模式。
  ///
  /// [channelName] 房间名称，设置相同房间名称的用户会进入同一个通话房间。
  ///
  ///   * 字符串格式，长度为 1~64 字节。
  ///
  ///   * 支持以下89个字符：a-z, A-Z, 0-9, space, !#$%&()+-:;≤.,>? @[]^_{|}~”
  ///
  /// [uid] 用户的唯一标识 id，房间内每个用户的 uid 必须是唯一的。
  /// uid 可选，默认为 0。如果不指定（即设为 0），SDK 会自动分配一个随机 uid，并在 [NERtcChannelEventCallback.onJoinChannel] 回调方法中返回，App 层必须记住该返回值并维护，SDK 不对该返回值进行维护。
  ///
  /// [channelOptions]加入房间时设置一些特定的房间参数。默认值为 null。
  ///
  /// **相关回调**
  ///
  /// 成功调用该方加入房间后，本地会触发 [NERtcChannelEventCallback.onJoinChannel] 回调，远端会触发 [NERtcChannelEventCallback.onUserJoined] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errorFatal）：重复入会或获取房间信息失败。
  ///   * 30003（invalidParam）：参数错误，比如传入的 channelName 不符合要求。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化或正在进行网络探测。
  Future<int> joinChannel(String? token, String channelName, int uid,
      [NERtcJoinChannelOptions? channelOptions]);

  /// 离开音视频房间。 通过本接口可以实现挂断或退出通话，并释放本房间内的相关资源。
  ///
  /// **说明**
  ///
  ///结束通话时必须调用此方法离开房间，否则无法开始下一次通话。
  ///
  /// **相关回调**
  ///
  /// 成功调用该方法离开房间后，本地会触发 [NERtcChannelEventCallback.onLeaveChannel]  回调，远端会触发 [NERtcChannelEventCallback.onUserLeave] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化或正在进行网络探测。
  Future<int> leaveChannel();

  /// 更新权限密钥。
  ///
  /// 通过此接口可以实现当用户权限被变更
  ///
  /// **使用前提**
  ///
  /// 请确保已开通高级 Token 鉴权功能，具体请联系网易云信商务经理。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **业务场景**
  ///
  /// 适用于变更指定用户加入、创建房间或上下麦时发布流相关权限的场景。
  ///
  /// **参数说明**
  ///
  ///[key] 新的权限密钥。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> updatePermissionKey(String key);

  /// 开启或关闭本地音频的采集和发送。 通过本接口可以实现开启或关闭本地语音功能，进行本地音频采集及处理。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  /// * 加入房间后，语音功能默认为开启状态。
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后仍然有效。
  /// * 该方法不影响接收或播放远端音频流，enableLocalAudio(false) 适用于只下行不上行音频流的场景。
  /// * 开启或关闭本地音频采集的操作不会影响伴音/音效接口的使用，比如 enableLocalAudio(false) 后仍可以调用 [NERtcAudioMixingManager.startAudioMixing] 方法播放音乐文件。
  /// * 该方法会操作音频硬件设备，建议避免频繁开关，否则可能导致设备异常。
  ///
  ///
  ///
  /// **参数说明**
  ///
  /// [enable] 是否启用本地音频的采集和发送：
  ///   * true: 开启本地音频采集。
  ///   * false : 关闭本地音频采集。关闭后，远端用户会接收不到本地用户的音频流；但本地用户依然可以接收到远端用户的音频流。
  ///
  /// **相关回调**
  /// * 开启音频采集后，远端会触发 [NERtcChannelEventCallback.onUserAudioStart] 回调。
  /// * 关闭音频采集后，远端会触发 [NERtcChannelEventCallback.onUserAudioStop] 回调。
  ///
  /// **相关接口**
  ///
  /// [muteLocalAudioStream]：两者的差异在于，[enableLocalAudio] 用于开启本地语音采集及处理，而 [muteLocalAudioStream] 用于停止或继续发送本地音频流。
  ///
  ///  *  0（OK）：方法调用成功。
  ///  *  其他：方法调用失败。
  Future<int> enableLocalAudio(bool enable);

  /// 订阅或取消订阅指定远端用户的音频主流。
  ///
  /// 加入房间时，默认订阅所有远端用户的音频主流，您也可以通过此方法取消或恢复订阅指定远端用户的音频主流。
  ///
  /// **调用时机**
  ///
  /// 该方法仅在加入房间后收到远端用户开启音频主流的回调 [NERtcChannelEventCallback.onUserAudioStart] 后可调用。
  ///
  /// **业务场景**
  ///
  /// 适用于需要手动订阅指定用户音频流的场景。
  ///
  /// **说明**
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认。
  /// * 在开启音频自动订阅且未打开服务端 ASL 自动选路的情况下，调用该接口无效。
  ///
  /// **参数说明**
  ///
  /// [uid] 指定用户的 ID
  ///
  /// [subscribe] 是否订阅指定用户的音频主流：
  ///   * true: 订阅指定音频流（默认）
  ///   * false: 取消订阅指定音频流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30004（notSupported）：不支持该操作，由于开启了音频自动订阅且未打开服务端 ASL 自动选路。
  ///   * 30105（userNotFound）：未找到指定用户。
  ///   * 30106（invalidUserId）：非法指定用户，比如订阅了本端。
  ///   * 30107（mediaNotStarted）：媒体会话未建立，比如对端未开启音频主流。
  ///   * 30108（sourceNotFound）：媒体源未找到，比如对端未开启音频主流。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> subscribeRemoteAudio(int uid, bool subscribe);

  ///订阅或取消订阅所有远端用户的音频主流。 （后续加入的用户也同样生效）
  ///
  /// 加入房间时，默认订阅所有远端用户的音频主流，您可以通过本接口取消订阅所有远端用户的音频主流。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **业务场景**
  ///
  /// 适用于重要会议需要一键全体静音的场景。
  ///
  /// **说明**
  /// * 设置该方法的 subscribe 参数为 true 后，对后续加入房间的用户同样生效。
  /// * 在开启自动订阅（默认）时，设置该方法的 subscribe 参数为 false 可以实现取消订阅所有远端用户的音频流，但此时无法再调用 [subscribeRemoteAudio] 方法单独订阅指定远端用户的音频流。
  ///
  /// **参数说明**
  ///
  /// [subscribe] 是否订阅指定用户的音频主流：
  ///   * true: 订阅音频流（默认）
  ///   * false: 取消订阅音频流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30105（userNotFound）：未找到指定用户。
  ///   * 30106（invalidUserId）：非法指定用户，比如订阅了本端。
  ///   * 30107（mediaNotStarted）：媒体会话未建立，比如对端未开启音频主流。
  ///   * 30108（sourceNotFound）：媒体源未找到，比如对端未开启音频主流。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> subscribeAllRemoteAudio(bool subscribe);

  /// 设置音频编码属性。
  /// 通过此接口可以实现设置音频编码的采样率、码率、编码模式、声道数等，也可以设置音频属性的应用场景，包括聊天室场景、语音场景、音乐场景等。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// * 音乐场景下，建议将 `profile` 设置为 `HighQuality`。
  /// * 若您通过 [setChannelProfile] 接口设置房间场景为直播模式，即 `liveBroadcasting`，但未调用此方法设置音频编码属性，或仅设置 `profile` 为 `Default`，则 SDK 会自动设置 `profile` 为 `HighQuality`，且设置 `scenario` 为 `Music`。
  /// **参数说明**
  ///
  /// [profile] 设置采样率，码率，编码模式和声道数，详细信息请参考 [NERtcAudioProfile]
  ///
  /// [scenario] 设置音频应用场景，详细信息请参考 [NERtcAudioScenario]
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errorFatal）：重复入会或获取房间信息失败。
  ///   * 30003（invalidParam）：参数错误，比如传入的 channelName 不符合要求。
  Future<int> setAudioProfile(
      NERtcAudioProfile profile, NERtcAudioScenario scenario);

  /// 开启或关闭本地视频的采集与发送。
  ///
  /// 通过本接口可以实现开启或关闭本地视频，不影响接收远端视频。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// * 纯音频 SDK 禁用该接口，如需使用请前往<a href="https://doc.yunxin.163.com/nertc/sdk-download" target="_blank">云信官网</a>下载并替换成视频 SDK。
  /// * 该方法设置内部引擎为开启或关闭状态, 在 [leaveChannel] 后仍然有效。
  /// * 在您的应用切到后台或者其他应用占用摄像头时，可能会导致摄像头打开失败，需要注册 camera 动态权限，详细信息请参考<a href="https://doc.yunxin.163.com/nertc/docs/DcyNDc0ODI?platform=android#%E6%B7%BB%E5%8A%A0%E6%9D%83" target="_blank">添加权限</a>。
  /// **参数说明**
  ///
  /// [enable] 是否开启本地视频采集与发送：
  ///   * true: 开启本地视频采集。
  ///   * false : 关闭本地视频采集。关闭后，远端用户无法接收到本地用户的视频流；但本地用户仍然可以接收到远端用户的视频流。
  ///
  /// [streamType] 视频通道类型：
  ///     * main（0）：主流。
  ///     * sub（1）：辅流。
  /// **相关回调**
  /// * 开启本地视频采集后，远端会收到 [NERtcChannelEventCallback.onUserVideoStart] 回调。
  /// * 关闭本地视频采集后，远端会收到 [NERtcChannelEventCallback.onUserVideoStop] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errorFatal）：重复入会或获取房间信息失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30011（createDeviceSourceFail）：创建设备源失败，未获取到操作系统的摄像头权限。
  Future<int> enableLocalVideo(bool enable,
      {int streamType = NERtcVideoStreamType.main});

  /// 开启或关闭本地音频的采集和发送。
  /// 该方法用于向网络发送或取消发送本地音频数据，不影响本地音频的采集状态，也不影响接收或播放远端音频流。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后仍然有效。
  ///
  /// **参数说明**
  ///
  /// [mute] 是否关闭本地音频的发送：
  ///   * true: 不发送本地音频。
  ///   * false : 发送本地音频。
  ///
  /// **相关回调**
  ///
  /// 若本地用户在说话，成功调用该方法后，房间内其他用户会收到 [NERtcChannelEventCallback.onUserAudioMute] 回调。
  ///
  /// **相关接口**
  /// [enableMediaPub]：在需要开启本地音频采集（监测本地用户音量）但不发送音频流的情况下，您也可以调用[enableMediaPub]方法。
  ///
  /// 两者的差异在于，[muteLocalAudioStream] 仍然保持与服务器的音频通道连接，而 [enableMediaPub] 表示断开此通道，因此若您的实际业务场景为多人并发的大房间，建议您调用 [enableMediaPub] 方法。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30101（roomNotJoined）：尚未加入房间。
  ///   * 30107（mediaNotStarted）：媒体会话未建立，比如对端未开启音频流。
  ///   * 30200（connectionNotFound）: 连接未建立。
  Future<int> muteLocalAudioStream(bool mute);

  /// 取消或恢复发布本端视频主流。
  ///
  /// <br>调用该方法取消发布本地视频主流后，SDK 不再发送本地视频主流。
  ///
  /// **使用前提**
  ///
  /// 一般在通过 [enableLocalVideo] 接口开启本地视频采集并发送后调用该方法。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// * 调用该方法取消发布本地视频流时，设备仍然处于工作状态。
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认，即默认发布本地视频流。
  /// * 该方法与 [enableLocalVideo] 的区别在于，[enableLocalVideo]会关闭本地摄像头设备，[muteLocalVideoStream] 方法不禁用摄像头，不会影响本地视频流采集且响应速度更快。
  ///
  /// **参数说明**
  ///
  /// [mute] 是否取消发布本地视频流：
  ///   * true: 取消发布本地视频流。
  ///   * false : 恢复发布本地视频流。
  /// **相关回调**
  ///
  /// 调用此接口成功后，远端会触发 [NERtcChannelEventCallback.onUserVideoMute] 回调，通知有用户暂停或恢复发送视频主流。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30004（notSupported）：不支持的操作，比如当前使用的是纯音频 SDK。
  Future<int> muteLocalVideoStream(bool mute,
      {int streamType = NERtcVideoStreamType.main});

  ///静音或解除静音本地上行的音频辅流。
  ///
  /// **说明**
  ///
  /// 静音状态会在通话结束后被重置为非静音。
  ///
  /// **参数说明**
  ///
  /// [muted]	是否静音本地音频辅流发送。
  ///   * true（默认）：静音本地音频辅流。
  ///   * false：取消静音本地音频辅流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> muteLocalSubStreamAudio(bool muted);

  ///开启或关闭音频辅流。
  ///
  /// **相关回调**
  ///
  /// * 开启音频辅流时，远端会收到 [NERtcChannelEventCallback.onUserSubStreamAudioStart] 回调
  /// * 关闭音频辅流时，远端会收到 [NERtcChannelEventCallback.onUserSubStreamAudioStop] 回调
  ///
  /// **参数说明**
  ///
  /// [enable] 	是否开启音频辅流。
  ///   * true：开启音频辅流。
  ///   * false：关闭音频辅流。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> enableLocalSubStreamAudio(bool enable);

  /// 指定主流或辅流通道发送媒体增强补充信息（SEI）。 在本端推流传输视频流数据同时，发送流媒体补充增强信息来同步一些其他附加信息。
  ///
  /// 默认使用主流通道发送SEI 信息。
  ///
  /// 当推流方发送 SEI 后，拉流方可通过监听 [NERtcChannelEventCallback.onRecvSEIMsg] 回调获取 SEI 内容。
  ///
  /// **使用限制：**
  ///
  ///   * 数据长度限制： SEI 最大数据长度为 4096 字节，超限会发送失败。如果频繁发送大量数据会导致视频码率增大，可能会导致视频画质下降甚至卡顿。
  ///
  ///   * 发送频率限制：最高为视频发送的帧率，建议不超过 10 次/秒。
  ///
  ///   * 生效时间：SEI 数据不一定调用本接口之后立刻发出去，最快在下一帧视频数帧之后发送，最慢在接下来的 5 帧视频帧之后发送。
  ///
  ///   * SEI 数据跟随视频帧发送，由于在弱网环境下可能丢帧，SEI 数据也可能随之丢失，所以建议在发送频率限制之内多次发送，保证接收端收到的概率。
  ///
  ///   * 指定通道发送SEI之前，需要提前开启对应的数据流通道。
  ///
  /// **参数说明**
  ///
  /// [seiMsg] 自定义 SEI 数据。， 最大长度不能超过 4KB。
  ///
  /// [streamType] 指定使用哪个视频通道(主流/辅流)发送SEI。详细信息请参考 [NERtcVideoStreamType] 。
  Future<int> sendSEIMsg(String seiMsg,
      {int streamType = NERtcVideoStreamType.main});

  /// 开始记录音频 Dump。 音频 Dump 可用于分析音频问题。
  Future<int> startAudioDump();

  /// 开始记录音频 Dump。 音频 Dump 可用于分析音频问题。
  ///
  /// **参数说明**
  ///
  /// [dumpType] 音频dump类型。详细信息请参考 [NERtcAudioDumpType]
  Future<int> startAudioDumpWithType(int dumpType);

  /// 结束音频Dump。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  Future<int> stopAudioDump();

  /// 设置 SDK 预设的人声的变声音效。
  ///
  /// 设置变声音效可以将人声原因调整为多种特殊效果，改变声音特性。
  ///
  /// **调用时机**
  ///
  ///请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认，即关闭变声音效。
  ///
  /// * 此方法和 [setLocalVoicePitch] 互斥，调用了其中任一方法后，另一方法的设置会被重置为默认值。
  ///
  /// **参数说明**
  ///
  ///[preset] 预设的变声音效。默认关闭变声音效。详细信息请参考 [NERtcVoiceChangerType] 。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> setAudioEffectPreset(int preset);

  /// 设置 SDK 预设的美声效果。
  ///
  /// 调用该方法可以为本地发流用户设置 SDK 预设的人声美声效果。
  ///
  /// **调用时机**
  ///
  ///请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **业务场景**
  /// 适用于多人语聊或 K 歌房中需要美化主播或连麦者声音的场景。
  ///
  /// **说明**
  ///
  /// * 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认，即关闭美声。
  ///
  /// **参数说明**
  ///
  /// [preset] 预设的美声效果模式。默认关闭美声效果。详细信息请参考 [NERtcVoiceBeautifierType]
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> setVoiceBeautifierPreset(int preset);

  /// 设置本地语音音效均衡，即自定义设置本地人声均衡波段的中心频率。
  ///
  /// **说明**
  ///
  /// 该方法在加入房间前后都能调用，通话结束后重置为默认关闭状态。
  ///
  /// **参数说明**
  ///
  /// [bandFrequency] 频谱子带索引，取值范围是 &#91; 0-9 &#93;，分别代表 10 个频带，对应的中心频率是 &#91; 31，62，125，250，500，1k，2k，4k，8k，16k &#93; Hz。
  ///
  /// [bandGain]      每个 band 的增益，单位是 dB，每一个值的范围是 &#91; -15，15 &#93;，默认值为 0。
  Future<int> setLocalVoiceEqualization(int bandFrequency, int bandGain);

  /// 设置本地语音音调。
  ///
  /// 该方法改变本地说话人声音的音调。
  ///
  /// **说明**
  ///
  /// * 通话结束后该设置会重置，默认为 1.0。
  ///
  /// *  此方法与 [setAudioEffectPreset] 互斥，调用此方法后，已设置的变声效果会被取消。
  ///
  /// **参数说明**
  ///
  /// [pitch] 语音频率。可以在 &#91; 0.5, 2.0 &#93; 范围内设置。取值越小，则音调越低。默认值为 1.0，表示不需要修改音调。
  Future<int> setLocalVoicePitch(double pitch);

  ///设置本地语音混响效果
  ///
  /// **调用时机**
  ///
  /// 该方法在加入房间前后都能调用，通话结束后重置为默认的关闭状态。
  ///
  /// **参数说明**
  ///
  /// [param] 混响参数，详细信息请参考 [NERtcReverbParam]
  Future<int> setLocalVoiceReverbParam(NERtcReverbParam param);

  /// 设置视频编码属性。通过此接口可以设置视频主流或辅流的编码分辨率、裁剪模式、码率、帧率、带宽受限时的视频编码降级偏好、编码的镜像模式、编码的方向模式参数。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// - 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  ///
  /// - 设置成功后，下一次开启本端视频时生效。
  ///
  /// - 每个属性对应一套视频参数，例如分辨率、帧率、码率等。所有设置的参数均为理想情况下的最大值。当视频引擎因网络环境等原因无法达到设置的分辨率、帧率或码率的最大值时，会取最接近最大值的那个值。
  /// - 此接口为全量参数配置接口，重复调用此接口时，SDK 会刷新此前的所有参数配置，以最新的传参为准。所以每次修改配置时都需要设置所有参数，未设置的参数将取默认值。
  ///
  /// **参数说明**
  ///
  /// [config] 视频编码属性配置 ，详细信息请参考 [NERtcVideoConfig]。
  ///
  /// [streamType]视频通道类型：
  ///     * main（0）：主流。
  ///     * sub（1）：辅流。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam)：参数错误，比如 videoConfig 设置为空。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30004（notSupported）：不支持的操作，比如当前使用的是纯音频 SDK。
  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig,
      {int streamType = NERtcVideoStreamType.main});

  /// 设置本地摄像头的采集偏好等配置。
  ///
  /// 通过此接口可以设置本地摄像头采集的主流视频宽度、高度、旋转角度等。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **业务场景**
  ///
  /// 在视频通话或直播中，SDK 自动控制摄像头的输出参数。默认情况下，SDK 会根据用户该接口的配置匹配最合适的分辨率进行采集。但是在部分业务场景中，如果采集画面质量无法满足实际需求，可以调用该接口调整摄像头的采集配置。
  ///
  /// **说明**
  ///
  /// - 纯音频 SDK 禁用该接口，如需使用请前往<a href="https://doc.yunxin.163.com/nertc/sdk-download" target="_blank">云信官网</a>下载并替换成视频 SDK。
  /// - 该方法支持在加入房间后动态调用，设置成功后，会自动重启摄像头采集模块。
  /// - 若系统相机不支持您设置的分辨率，会自动调整为最相近一档的分辨率，因此建议您设置为常规标准的分辨率。
  /// - 设置较高的采集分辨率会增加性能消耗，例如 CPU 和内存占用等，尤其是在开启视频前处理的场景下。
  ///
  /// - 在视频通话或直播中，SDK 自动控制摄像头的输出参数。默认情况下，SDK 根据用户的 [setLocalVideoConfig] 配置匹配最合适的分辨率进行采集。但是在部分业务场景中，如果采集画面质量无法满足实际需求，可以调用该接口调整摄像头的采集配置。
  ///
  /// - 需要采集并预览高清画质时，可以通过参数 [NERtcCameraCapturePreference] 将采集偏好设置为 `kQuality`，此时 SDK 会自动设置较高的摄像头输出参数，本地采集与预览画面比编码参数更加清晰。
  ///
  /// - 需要自定义设置摄像头采集的视频尺寸时，请通过参数 [NERtcCameraCapturePreference]  将采集偏好设为 `kManual`，并通过 [NERtcCameraCaptureConfig] 中的 `captureWidth` 和 `captureHeight` 自定义设置本地摄像头采集的视频宽高。
  ///
  /// **参数说明**
  ///
  /// [captureConfig] 本地摄像头采集配置，详情请参见[NERtcCameraCaptureConfig]。
  /// [streamType] 视频通道类型：
  ///   * main：主流
  ///   * sub：辅流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam)：参数错误，比如 videoConfig 设置为空。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30004（notSupported）：不支持的操作，比如当前使用的是纯音频 SDK。
  Future<int> setCameraCaptureConfig(NERtcCameraCaptureConfig captureConfig,
      {int streamType = NERtcVideoStreamType.main});

  /// 设置本地视频画面的旋转模式。
  ///
  /// 该接口用于设置本地视频画面在本地和远端设备上的旋转模式，可以指定本地画面和系统设备的横屏/竖屏模式一致、或者和 App UI 的横屏/竖屏模式一致。
  ///
  ///  **调用时机**
  ///  - 请在加入房间之前调用此接口。
  ///
  ///  **说明**
  ///  - 无论在哪种旋转模式下，采集端和播放端的旋转模式均保持一致。即本地看到的本地画面和远端看到的本地画面总是同样横屏模式或同样竖屏模式。
  ///  - iOS 平台专有接口
  ///
  ///  **参数说明**
  ///  [rotationMode] 视频旋转模式。详细信息请参考 [NERtcVideoRotationMode]
  ///
  ///  **返回值**
  ///  操作返回值，成功则返回 0
  Future<int> setVideoRotationMode(
      [int rotationMode =
          NERtcVideoRotationMode.NERtcVideoRotationModeBySystem]);

  /// 开启视频预览。 通过本接口可以实现在加入房间前启动本地视频预览，支持预览本地摄像头或外部输入视频。
  ///
  /// **使用前提**
  ///
  /// 请在设置视频画布后调用该方法。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法仅可当不在房间内时可调用。
  ///
  /// **业务场景**
  ///
  /// 适用于加入房间前检查设备状态是否可用、预览视频效果等场景。
  ///
  /// **说明**
  ///
  /// * 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  /// * 在加入房间前预览视频效果时设置的美颜、虚拟背景等视频效果在房间内仍然生效；在房间内设置的视频效果在退出房间后预览视频时也可生效。
  ///
  /// **参数说明**
  ///
  /// [streamType] 视频通道类型：
  ///   * main：主流
  ///   * sub：辅流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30004（notSupported）：不支持的操作，比如当前使用的是纯音频 SDK。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化或已经加入房间。
  ///   * 30008（deviceNotFound）：未找到设备。
  ///   * 30011（createDeviceSourceFail ）：创建设备源失败。
  Future<int> startVideoPreview({int streamType = NERtcVideoStreamType.main});

  /// 停止视频预览。 通过本接口可以实现在预览本地视频后关闭预览。
  ///
  /// **使用前提**
  ///
  /// 请在通过 [startVideoPreview] 接口开启视频预览后调用该方法。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法仅可当不在房间内时可调用。
  ///
  /// **说明**
  ///
  /// 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  ///
  /// **参数说明**
  ///
  /// [streamType] 视频通道类型：
  ///   * main：主流
  ///   * sub：辅流
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化或已经加入房间。
  Future<int> stopVideoPreview({int streamType = NERtcVideoStreamType.main});

  /// 开启屏幕共享。
  ///
  /// 通过此接口开启屏幕共享后，屏幕共享内容以视频辅流的形式发送。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **相关回调**
  ///
  /// 成功开启屏幕共享辅流后，远端会触发 [NERtcChannelEventCallback.onUserSubStreamVideoStart] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> startScreenCapture(NERtcScreenConfig config);

  /// 关闭屏幕共享。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **相关回调**
  ///
  /// 成功开启屏幕共享辅流后，远端会触发 [NERtcChannelEventCallback.onUserSubStreamVideoStop] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> stopScreenCapture();

  /// 检测虚拟声卡是否安装（仅适用于 Mac 系统）。
  Future<int> checkNECastAudioDriver();

  /// 开启或关闭音频共享.
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否开启音频共享。
  ///   * true：开启音频共享。
  ///   * false：关闭音频共享
  Future<int> enableLoopbackRecording(bool enable, {String deviceName = ""});

  /// 订阅或取消订阅指定远端用户的视频主流。
  ///
  /// 加入房间后，默认不订阅所有远端用户的视频主流；若您希望看到指定远端用户的视频，可以在监听到对方加入房间或发布视频流之后，通过此方法订阅该用户的视频主流。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [uid]  待订阅用户的 userID。
  ///
  /// [streamType] 订阅的视频流类型, 详细信息参考 [NERtcRemoteVideoStreamType]
  ///   * high：高清画质的大流。
  ///   * low：低清画质的小流。
  ///
  /// [subscribe] 是否订阅远端用户的视频流：
  ///   * true：订阅远端视频流。
  ///   * false：不订阅远端视频流。
  Future<int> subscribeRemoteVideoStream(
      int uid, int streamType, bool subscribe);

  /// 订阅或取消订阅远端用户的视频辅流。
  ///
  /// **使用前提**
  ///
  /// - 请先设置远端用户的视频辅流画布。
  /// - 建议在收到远端用户发布视频辅流的回调通知 [NERtcChannelEventCallback.onUserSubStreamVideoStart] 后调用此接口。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [uid] 待订阅用户的 userID。
  ///
  /// [subscribe] 是否订阅远端的视频辅流：
  ///   * true：订阅远端视频辅流。
  ///   * false：不订阅远端视频辅流。
  ///
  /// **相关回调**
  /// - [NERtcChannelEventCallback.onUserSubStreamVideoStart]：远端用户发布视频辅流的回调。
  /// - [NERtcChannelEventCallback.onUserSubStreamVideoStop]：远端用户停止发布视频辅流的回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30105（userNotFound）：未找到该远端用户，可能对方还未加入房间。
  ///   * 30106（invalidUserId）：无效的 uid，比如不能订阅本端。
  ///   * 30107（mediaNotStarted）：媒体会话尚未建立。
  Future<int> subscribeRemoteSubStreamVideo(int uid, bool subscribe);

  /// 设置是否订阅指定远端用户的音频辅流。
  ///
  /// **调用时机**
  ///
  /// * 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  /// * 请在指定远端用户加入房间，且收到远端用户开启音频辅流的回调 [NERtcChannelEventCallback.onUserSubStreamAudioStart] 后，再调用本接口。
  ///
  /// **说明**
  ///
  /// 加入房间时，默认订阅所有远端用户的音频流。
  ///
  /// **参数说明**
  ///
  /// [uid] 待订阅用户的 userID。
  ///
  /// [subscribe] 是否订阅远端用户的音频辅流。
  ///   * true：订阅远端音频辅流。
  ///   * false：不订阅远端音频辅流。
  ///
  /// **相关回调**
  /// - [NERtcChannelEventCallback.onUserSubStreamAudioStart]：远端用户发布音频辅流的回调。
  /// - [NERtcChannelEventCallback.onUserSubStreamAudioStop]：远端用户停止发布音频辅流的回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30004（notSupported）：操作不支持，比如已开启自动订阅音频辅流。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30105（userNotFound）：未找到该远端用户，可能对方还未加入房间。
  ///   * 30101（roomNotJoined）：尚未加入房间。
  ///   * 30107（mediaNotStarted）：媒体会话尚未建立。
  Future<int> subscribeRemoteSubStreamAudio(int uid, bool subscribe);

  /// 启用说话者音量提示。通过此接口可以实现允许 SDK 定期向 App 反馈房间内发音频流的用户和瞬时音量最高的远端用户（最多 3 位，包括本端）的音量相关信息，即当前谁在说话以及说话者的音量。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **业务场景**
  ///
  /// 适用于通过发言者的人声相关信息做出 UI 上的音量展示的场景，或根据发言者的音量大小进行视图布局的动态调整。
  ///
  /// **说明**
  /// - 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认。如果您离开房间后重新加入房间，需要重新调用本接口。
  /// - 建议设置本地采集音量为默认值（100）或小于该值，否则可能会导致音质问题。
  /// - 该方法仅设置应用程序中的采集信号音量，不修改设备音量，也不会影响伴音、音效等的音量；若您需要修改设备音量，请调用设备管理相关接口。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否启用说话者音量提示。
  ///   * true：启用说话者音量提示。
  ///   * false：关闭说话者音量提示。
  ///
  /// [interval] 指定音量提示的时间间隔。单位为毫秒。必须设置为 100 毫秒的整数倍值，建议设置为 200 毫秒以上。
  ///
  /// [vad] 是否启用本地采集人声监测：
  ///   * true：启用本地采集人声监测。
  ///   * false：关闭本地采集人声监测。
  /// **相关回调**
  ///
  /// 启用该方法后，只要房间内有发流用户，无论是否有人说话，SDK 都会在加入房间后根据预设的时间间隔触发 [onRemoteAudioVolumeIndication] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errFatal）：内部错误，比如音频相关模块未初始化成功。
  ///   * 30003（invalidParam）：参数错误，比如时间间隔小于 100ms。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> enableAudioVolumeIndication(bool enable, int interval,
      {bool vad = false});

  /// 设置房间的场景。
  /// 通过此接口可以实现设置房间场景为通话（默认）或直播场景。针对不同场景采取的优化策略不同，通话场景侧重语音流畅度，直播场景侧重视频清晰度。
  ///
  /// **调用时机**
  ///
  /// 请在初始化后调用该方法，且该方法仅可在加入房间前调用。
  ///
  /// **参数说明**
  ///
  /// [channelProfile] 房间的场景。具体请参见 [NERtcChannelProfile]。
  ///   * communication：通信场景。
  ///   * liveBroadcasting：直播场景。
  Future<int> setChannelProfile(int channelProfile);

  /// 设置是否开启视频大小流模式。
  ///
  /// 通过本接口可以实现设置单流或者双流模式。发送端开启双流模式后，接收端可以选择接收大流还是小流。其中，大流指高分辨率、高码率的视频流，小流指低分辨率、低码率的视频流。
  ///
  /// **调用时机**
  ///
  ///  请在初始化后调用该方法，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  /// - 纯音频 SDK 禁用该接口，如需使用请前往<a href="https://doc.yunxin.163.com/nertc/sdk-download" target="_blank">云信官网</a>下载并替换成视频 SDK。
  /// - 该方法只对摄像头数据生效，对自定义输入、屏幕共享等视频流无效。
  /// - 该接口的设置会在摄像头重启后生效。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否开启双流模式：
  ///   * true（默认）：开启双流模式。
  ///   * false：关闭双流模式。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> enableDualStreamMode(bool enable);

  /// 添加房间内推流任务。成功添加后当前用户可以收到该直播流的状态通知。通话中有效。
  ///
  /// 通过此接口可以实现增加一路旁路推流任务；若需推送多路流，则需多次调用该方法。
  ///
  /// **使用前提**
  ///
  /// 请先通过 [setChannelProfile] 接口设置房间模式为直播模式。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///  - 仅角色为主播的房间成员能调用此接口，观众成员无相关推流权限。
  ///  - 同一个音视频房间（即同一个 channelId）可以创建 6 个不同的推流任务。
  ///
  /// **参数说明**
  ///
  /// [taskInfo] 推流任务信息。
  ///
  ///
  /// **相关回调**
  ///
  /// * [NERtcLiveTaskCallback.onAddLiveStreamTask]：添加直播任务结果回调，操作成功后返回该回调。
  /// * [NERtcChannelEventCallback.onLiveStreamState]：推流任务状态已改变回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 403（reserveNoPermission）：权限不足，观众模式下不支持此操作。
  ///   * 30003（invalidParam）：参数错误，比如推流任务 ID 参数为空。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> addLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo);

  /// 更新房间内指定推流任务。通过此接口可以实现调整指定推流任务的编码参数、画布布局、推流模式等。
  ///
  /// **使用前提**
  ///
  /// 请先调用 [addLiveStreamTask] 方法添加推流任务。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///  - 仅角色为主播的房间成员能调用此接口，观众成员无相关推流权限。
  ///
  /// **参数说明**
  ///
  /// [taskInfo] 推流任务信息
  ///
  /// **相关回调**
  ///
  /// * [NERtcLiveTaskCallback.onUpdateLiveStreamTask]：更新直播任务结果回调，操作成功后返回该回调。
  /// * [NERtcChannelEventCallback.onLiveStreamState]：推流任务状态已改变回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 403（reserveNoPermission）：权限不足，观众模式下不支持此操作。
  ///   * 30003（invalidParam）：参数错误，比如推流任务 ID 参数为空。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> updateLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo);

  /// 删除房间内指定推流任务。
  ///
  /// **使用前提**
  ///
  /// 请先调用 [addLiveStreamTask] 方法添加推流任务。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  /// - 仅角色为主播的房间成员能调用此接口，观众成员无相关推流权限。
  /// - 通话结束，房间成员全部离开房间后，推流任务会自动删除；如果房间内还有用户存在，则需要创建推流任务的用户删除推流任务。
  ///
  /// **参数说明**
  ///
  /// [taskId]   直播任务id
  ///
  /// **相关回调**
  ///
  /// * [NERtcLiveTaskCallback.onDeleteLiveStreamTask]：删除直播任务结果回调，操作成功后返回该回调。
  /// * [NERtcChannelEventCallback.onLiveStreamState]：推流任务状态已改变回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 403（reserveNoPermission）：权限不足，观众模式下不支持此操作。
  ///   * 30003（invalidParam）：参数错误，比如推流任务 ID 参数为空。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> removeLiveStreamTask(String taskId);

  /// 调节采集信号音量。
  ///
  /// 通过本接口可以实现设置录制声音的信号幅度，从而达到调节采集音量的目的。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  /// - 该方法设置内部引擎为启用状态，在 [leaveChannel] 后设置失效，将恢复至默认。
  /// - 建议设置本地采集音量为默认值（100）或小于该值，否则可能会导致音质问题。
  /// - 该方法仅设置应用程序中的采集信号音量，不修改设备音量，也不会影响伴音、音效等的音量；若您需要修改设备音量，请调用设备管理相关接口。  ///
  ///
  /// **参数说明**
  ///
  /// [volume] 采集信号音量，取值范围为 0 ~ 400。
  ///   * 0: 静音
  ///   * 100: 原始音量 (默认)
  ///   * 400: 最大可为原始音量的 4 倍(自带溢出保护)
  Future<int> adjustRecordingSignalVolume(int volume);

  /// 调节本地播放的所有远端用户的信号音量。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// 建议设置本地播放音量时使用默认值（100）或小于该值，否则可能会导致音质问题。
  ///
  /// **参数说明**
  ///
  /// [volume] 采集信号音量，取值范围为 0 ~ 400。
  ///   * 0: 静音
  ///   * 100: 原始音量 (默认)
  ///   * 400: 最大可为原始音量的 4 倍(自带溢出保护)
  Future<int> adjustPlaybackSignalVolume(int volume);

  ///调整共享音频音量。
  ///
  /// **参数说明**
  ///
  /// [volume] 采集信号量。该参数的取值范围为 0 ~ 100。
  Future<int> adjustLoopBackRecordingSignalVolume(int volume);

  ///  设置直播场景下的用户角色。 通过本接口可以实现将用户角色在“主播”（broadcaster）和“观众“（audience）之间的切换，用户加入房间后默认为“主播”。
  ///
  /// **使用前提**
  ///
  /// 该方法仅在通过 [setChannelProfile] 方法设置房间场景为直播场景（liveBroadcasting）时调用有效。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **业务场景**
  ///
  /// 适用于观众上下麦与主播互动的互动直播场景。
  ///
  /// **说明**
  ///
  /// 用户切换为观众角色时，SDK 会自动关闭音视频设备。
  ///
  /// 在加入频道前或在频道中，用户可以通过setClientRole 接口设置本端模式为观众或主播模式。
  ///
  /// **参数说明**
  ///
  /// [role] 用户角色，具体请参见 [NERtcClientRole]。用户角色包括：
  ///   * broadcaster（0）：设置用户角色为主播。主播可以开关摄像头等设备、可以发布流、可以操作互动直播推流相关接口、加入或退出房间状态对其他房间内用户可见。
  ///   * audience（1）：设置用户角色为观众。观众只能收流不能发流加入或退出房间状态对其他房间内用户不可见。
  ///
  /// **相关回调**
  ///
  /// - 加入房间前调用该方法设置用户角色，不会触发任何回调，在加入房间成功后角色自动生效：
  ///          - 设置用户角色为主播：加入房间后，远端用户触发 [NERtcChannelEventCallback.onUserJoined] 回调。
  ///          - 设置用户角色为观众：加入房间后，远端用户不触发任何回调。
  /// - 加入房间后调用该方法切换用户角色：
  ///          - 从观众角色切为主播：本端用户触发[NERtcChannelEventCallback.onClientRoleChange] 回调，远端用户触发 [onUserJoined] 回调。
  ///          - 从主播角色切为观众：本端用户触发 [NERtcChannelEventCallback.onClientRoleChange] 回调，远端用户触发 [onUserLeave] 回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errFatal）：内部错误，比如音频相关模块未初始化成功。
  ///   * 30003（invalidParam）：参数错误，比如传入的 int 值不是观众或主播。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> setClientRole(int role);

  /// 获取当前房间连接状态。
  ///
  /// 房间连接状态参考 [NERtcConnectionState]
  Future<int> getConnectionState();

  /// 上传SDK日志信息。上传的信息包括 log 和 Audio dump 等文件。
  ///
  /// **调用时机**
  ///
  /// 只能在加入房间后调用。
  Future<int> uploadSdkInfo();

  /// 快速切换音视频房间。
  ///
  /// 房间场景为直播场景时，房间中角色为观众的成员可以调用该方法从当前房间快速切换至另一个房间。
  ///
  /// **使用前提**
  ///
  /// * 该方法仅适用于直播场景中，请确保已通过 [setChannelProfile] 方法设置房间场景为直播场景（liveBroadcasting）。
  /// * 该方法仅适用于角色为观众的音视频房间成员调用。请确保已通过 [setClientRole] 设置房间成员的角色为观众。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///
  /// 房间成员成功切换房间后，默认订阅房间内所有其他成员的音频流，因此产生用量并影响计费。如果想取消订阅，可以通过调用 [subscribeRemoteAudio] 方法，并设置 subscribe 参数为 false。
  ///
  /// **参数说明**
  ///
  /// [token] 在服务器端生成的用于鉴权的安全认证签名（Token）。可设置为：
  ///
  ///   * 已获取的 Token。安全模式下必须设置为获取到的 Token。默认 token 有效期 10 min，也可以定期通过应用服务器向云信服务器申请 token 或者申请长期且可复用的 token。推荐使用安全模式。
  ///
  ///   * 非安全模式下可设置为 null。安全性不高，建议在产品正式上线前联系对应商务经理转为安全模式。
  ///
  /// [channelName] 期望切换到的目标房间名称
  ///
  /// **相关回调**
  ///
  /// 成功调用该方法切换房间后：
  /// 本端会先收到离开房间的回调 [NERtcChannelEventCallback.onLeaveChannel]，其中 result 参数为 [NERtcErrorCode.leaveChannelForSwitch]。再收到成功加入新房间的回调 [NERtcChannelEventCallback.onJoinChannel]。
  ///
  /// 远端用户会收到 [NERtcChannelEventCallback.onUserLeave] 和 [NERtcChannelEventCallback.onUserJoined]  的回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 403（reserveNoPermission）：没有权限，比如主播无法切换房间。
  ///   * 30001（errFatal）：内部错误，比如音频相关模块未初始化成功。
  ///   * 30003（invalidParam）：参数错误，比如房间名称为空字符串。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  ///   * 30100 (roomAlreadyJoined): 频道名无效，已在此频道中。
  ///   * 30101（roomNotJoined): 尚未加入房间。
  Future<int> switchChannel(String? token, String channelName,
      {NERtcJoinChannelOptions? channelOptions});

  /// 开始客户端录音。
  ///
  /// 调用该方法后，客户端会录制房间内所有用户混音后的音频流，并将其保存在本地一个录音文件中。录制开始或结束时，自动触发 [onAudioRecording] 回调。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///
  /// * 指定的录音音质不同，录音文件会保存为不同格式：
  ///     * WAV：音质保真度高，文件大。
  ///     * AAC：音质保真度低，文件小。
  /// * 客户端只能同时运行一个录音任务，正在录音时，如果重复调用 startAudioRecording，会结束当前录制任务，并重新开始新的录音任务。
  /// * 本端用户离开房间时，自动停止录音。您也可以在通话中随时调用 [stopAudioRecording] 手动停止录音。
  ///
  /// **参数说明**
  ///
  /// [filePath] 录音文件在本地保存的绝对路径，需要精确到文件名及格式。例如：sdcard/xxx/audio.aac。 请确保指定的路径存在并且可写, 目前仅支持 WAV 或 AAC 文件格式。
  ///
  /// [sampleRate] 录音采样率（Hz），可以设为 16000、32000（默认）、44100 或 48000。
  ///
  /// [quality] 录音音质，只在 AAC 格式下有效。详细说明请参考 [NERtcAudioRecordingQuality]。
  ///
  /// **相关回调**
  ///
  /// 调用此接口成功后会触发 [NERtcChannelEventCallback.onAudioRecording] 回调，通知音频录制任务状态已更新。音频录制状态码请参考 [NERtcAudioRecordingCode]。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误，比如设置的采样率无效。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> startAudioRecording(String filePath, int sampleRate, int quality);

  ///开始客户端录音。 调用该方法后，客户端会录制房间内所有用户混音后的音频流，并将其保存在本地一个录音文件中。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///
  /// * 指定的录音音质不同，录音文件会保存为不同格式：
  ///     * WAV：音质保真度高，文件大。
  ///     * AAC：音质保真度低，文件小。
  /// * 客户端只能同时运行一个录音任务，正在录音时，如果重复调用 startAudioRecording，会结束当前录制任务，并重新开始新的录音任务。
  /// * 本端用户离开房间时，自动停止录音。您也可以在通话中随时调用 [stopAudioRecording] 手动停止录音。
  ///
  /// **参数说明**
  ///
  /// [config] 录音的配置，包括循环缓存的最大时长跨度、录音文件的保存路径、录音文件所包含的内容、录音音质、录音采样率等。详细说明请参考 [NERtcAudioRecordingConfiguration]。
  ///
  /// **相关回调**
  ///
  /// 调用此接口成功后会触发 [NERtcChannelEventCallback.onAudioRecording] 回调，通知音频录制任务状态已更新。音频录制状态码请参考 [NERtcAudioRecordingCode]。
  Future<int> startAudioRecordingWithConfig(
      NERtcAudioRecordingConfiguration config);

  /// 停止客户端本地录音。
  ///
  /// 本端用户离开房间时自动停止录音，您也可以在通话中随时调用 [stopAudioRecording] 手动停止录音。
  ///
  /// **使用前提**
  ///
  /// * 请先调用 [startAudioRecordingWithConfig] 或 [startAudioRecording] 方法开启客户端本地音频录制。
  /// * 该接口需要在 [leaveChannel] 之前调用。
  ///
  /// **相关回调**
  ///
  /// 调用此接口成功后会触发 [NERtcChannelEventCallback.onAudioRecording] 回调，通知音频录制任务状态已更新。音频录制状态码请参考 [NERtcAudioRecordingCode]。
  Future<int> stopAudioRecording();

  /// 设置本地用户的媒体流优先级。
  ///
  /// 如果某个用户的优先级为高，那么该用户媒体流的优先级就会高于其他用户，弱网环境下 SDK 会优先保证高优先级用户收到的媒体流的质量。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后，加入房间之前调用此方法。
  ///
  /// **说明**
  /// * 一个音视频房间中只有一个高优先级的用户。建议房间中只有一位用户调用 [setLocalMediaPriority] 将本端媒体流设为高优先级，否则需要开启抢占模式，保证本地用户的高优先级设置生效。
  /// * 调用 [switchChannel] 方法快速切换房间后，媒体优先级会恢复为默认值，即普通优先级。
  ///
  /// **参数说明**
  ///
  /// [priority] 本地用户的媒体流优先级，默认为 [NERtcMediaPriority.normal]，即普通优先级，详细信息请参考 [NERtcMediaPriority]。
  ///
  /// [isPreemptive] 是否开启抢占模式。
  ///   * true：开启抢占模式。抢占模式开启后，本地用户可以抢占其他用户的高优先级，被抢占的用户的媒体优先级变为普通优先级，在抢占者退出房间后，其他用户的优先级仍旧维持普通优先级。
  ///   * false：关闭抢占模式。抢占模式关闭时，如果房间中已有高优先级用户，则本地用户的高优先级设置不生效，仍旧为普通优先级。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> setLocalMediaPriority(int priority, bool isPreemptive);

  /// 开始跨房间媒体流转发。
  ///
  /// - 该方法可用于实现跨房间连麦等场景。支持同时转发到 4 个房间，同一个房间可以有多个转发进来的媒体流。
  ///
  /// - 成功调用该方法后，SDK 会触发 [NERtcChannelEventCallback.onMediaRelayStatesChange] 和 [NERtcChannelEventCallback.onMediaRelayReceiveEvent] 回调，并在回调中报告当前的跨房间媒体流转发状态和事件。
  ///
  ///
  /// **调用时机**
  ///
  /// 请在成功加入房间后调用该方法。
  ///
  /// **说明**
  ///
  /// * 调用此方法需要通过 [config] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 设置目标房间。
  ///
  /// * 该方法仅对直播场景下的主播角色有效。
  ///
  /// * 成功调用该方法后，若您想再次调用该方法，必须先调用 [stopChannelMediaRelay] 方法退出当前的转发状态。
  ///
  /// * 成功开始跨房间转发媒体流后，如果您需要修改目标房间，例如添加或删减目标房间等，可以调用方法 [updateChannelMediaRelay] 更新目标房间信息。
  ///
  /// [config] 跨房间媒体流转发参数配置信息。详细信息请参考 [NERtcChannelMediaRelayConfiguration]。
  Future<int> startChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config);

  /// 更新媒体流转发的目标房间。
  ///
  /// 成功开始跨房间转发媒体流后，如果你希望将流转发到多个目标房间，或退出当前的转发房间，可以调用该方法。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间并成功调用 [startChannelMediaRelay] 开始跨房间媒体流转发后，调用此方法。
  ///
  /// **说明**
  ///
  /// * 调用此方法前需要通过 [NERtcChannelMediaRelayConfiguration] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 设置目标房间。
  ///
  /// * 跨房间媒体流转发最多支持 4 个目标房间，您可以在调用该方法之前，通过 [NERtcChannelMediaRelayConfiguration] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 移除不需要的房间，再添加新的目标房间。
  ///
  /// **参数说明**
  ///
  /// [config]  跨房间媒体流转发参数配置信息。详细信息请参考 [NERtcChannelMediaRelayConfiguration]。
  ///
  /// **相关回调**
  ///
  /// 成功调用此方法后，SDK 会触发 [NERtcChannelEventCallback.onMediaRelayStatesChange] 和 [NERtcChannelEventCallback.onMediaRelayReceiveEvent] 回调，并在回调中报告当前的跨房间媒体流转发状态和事件。
  Future<int> updateChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config);

  /// 停止跨房间媒体流转发。
  ///
  /// 主播离开房间时，跨房间媒体流转发自动停止，您也可以在需要的时候随时调用 [stopChannelMediaRelay] 方法，此时主播会退出所有目标房间。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间并成功调用 [startChannelMediaRelay] 开始跨房间媒体流转发后，调用此方法。
  ///
  /// **相关回调**
  ///
  /// - 成功调用该方法后，SDK 会触发 [NERtcChannelEventCallback.onMediaRelayStatesChange] 回调。如果报告 [NERtcChannelMediaRelayState.idle]，则表示已停止转发媒体流。
  ///
  /// - 如果该方法调用不成功，SDK 会触发 [NERtcChannelEventCallback.onMediaRelayStatesChange] 回调，并报告状态码 [NERtcChannelMediaRelayState.failure]。
  Future<int> stopChannelMediaRelay();

  /// 调节本地播放的指定远端用户的信号音量。
  ///
  /// 加入房间后，您可以多次调用该方法设置本地播放的不同远端用户的音量；也可以反复调节本地播放的某个远端用户的音量。
  ///
  /// **调用时机**
  ///
  /// 请在成功加入房间后调用该方法。
  ///
  /// **说明**
  ///
  /// * 该方法在本次通话中有效。如果远端用户中途退出房间，则再次加入此房间时仍旧维持该设置，通话结束后设置失效。
  ///
  /// * 该方法调节的是本地播放的指定远端用户混音后的音量，且每次只能调整一位远端用户。若需调整多位远端用户在本地播放的音量，则需多次调用该方法。
  ///
  /// **参数说明**
  ///
  /// [uid] 远端用户 ID。
  ///
  /// [volume] 播放音量，取值范围为 &#91; 0,100 &#93;。
  ///     * 0：静音。
  ///     * 100：原始音量。
  Future<int> adjustUserPlaybackSignalVolume(int uid, int volume);

  ///用户自定义上报事件。
  ///
  /// **参数说明**
  ///
  /// [eventName] 事件名，不能为空。
  ///
  /// [customIdentify] 自定义标识，比如产品或业务类型，如果不需要，请填null
  ///
  /// [param] 参数键值对, 参数值支持String 及java基本类型(int 、bool....), 如不需要填null
  Future<int> reportCustomEvent(
      String eventName, String? customIdentify, Map<String?, Object?>? param);

  /// 设置弱网条件下发布的音视频流回退选项。
  ///
  /// 在网络不理想的环境下，发布的音视频质量都会下降。使用该接口并将 option 设置为 [NERtcStreamFallbackOptions.audioOnly] 后:
  ///
  /// - SDK 会在上行弱网且音视频质量严重受影响时，自动关断视频流，尽量保证音频质量。
  ///
  /// - 同时 SDK 会持续监控网络质量，并在网络质量改善时恢复音视频流。
  ///
  /// - 当本地发布的音视频流回退为音频流时，或由音频流恢复为音视频流时，SDK 会触发本地发布的媒体流已回退为音频流 [NERtcChannelEventCallback.onLocalPublishFallbackToAudioOnly] 回调。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间 [joinChannel] 前调用此方法。
  ///
  /// **参数说明**
  ///
  /// [options] 发布音视频流的回退选项，默认为不开启回退。 详细信息请参考 [NERtcStreamFallbackOptions]。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> setLocalPublishFallbackOption(int option);

  /// 设置弱网条件下订阅的音视频流回退选项。
  ///
  /// 弱网环境下，订阅的音视频质量会下降。通过该接口设置订阅音视频流的回退选项后：
  ///
  /// - SDK 会在下行弱网且音视频质量严重受影响时，将视频流切换为小流，或关断视频流，从而保证或提高通信质量。
  ///
  /// - SDK 会持续监控网络质量，并在网络质量改善时自动恢复音视频流。
  ///
  /// - 当远端订阅流回退为音频流时，或由音频流恢复为音视频流时，SDK 会触发远端订阅流已回退为音频流回调。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间 [joinChannel] 前调用此方法。
  ///
  /// **参数说明**
  ///
  /// [option] 订阅音视频流的回退选项，默认为弱网时回退到视频小流。详细信息请参考 [NERtcStreamFallbackOptions]。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> setRemoteSubscribeFallbackOption(int option);

  /// 启用或停止 AI 超分。
  ///
  /// **说明**
  /// * 使用 AI 超分功能之前，请联系技术支持开通 AI 超分功能。
  /// * AI 超分仅对以下类型的视频流有效：
  ///
  ///   * 必须为本端接收到第一路 360P 的视频流。
  ///
  ///   * 必须为摄像头采集到的主流大流视频。AI 超分功能暂不支持复原重建小流和屏幕共享辅流。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否启用 AI 超分。默认为关闭状态。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> enableSuperResolution(bool enable);

  /// 开启或关闭媒体流加密。
  ///
  /// **业务场景**
  ///
  /// 在金融行业等安全性要求较高的场景下，您可以在加入房间前通过此方法设置媒体流加密模式。
  ///
  /// **说明**
  /// - 请在加入房间前调用该方法，加入房间后无法修改加密模式与密钥。用户离开房间后，SDK 会自动关闭加密。如需重新开启加密，需要在用户再次加入房间前调用此方法。
  /// - 同一房间内，所有开启媒体流加密的用户必须使用相同的加密模式和密钥，否则使用不同密钥的成员加入房间时会报错 ENGINE_ERROR_ENCRYPT_NOT_SUITABLE（30113）。
  /// - 安全起见，建议每次启用媒体流加密时都更换新的密钥。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否开启媒体流加密。
  ///      - true: 开启
  ///      - false:（默认）关闭
  /// [config] 媒体流加密方案。详细信息请参考 [NERtcEncryptionConfig]。
  Future<int> enableEncryption(bool enable, NERtcEncryptionConfig config);

  /// 设置 SDK 对 Audio Session 的控制权限。
  ///
  /// 该方法仅适用于 iOS 平台。
  ///
  /// **说明**
  /// - 该方法限制 SDK 对 Audio Session 的操作权限。在默认情况下，SDK 和 App 对 Audio Session 都有控制权，但某些场景下，App 会希望限制 SDK 对 Audio Session 的控制权限，而使用其他应用或第三方组件对Audio Session 进行操控。
  /// - 一旦调用该方法限制了 SDK 对 Audio Session 的控制权限， SDK 将无法对 Audio Session 进行相关设置，而需要用户自己或第三方组件进行维护。
  /// **调用时机**
  ///
  /// 该接口只能在入会之前调用。
  Future<int> setAudioSessionOperationRestriction(
      NERtcAudioSessionOperationRestriction restriction);

  /// 获取音效文件时长。
  ///
  /// **调用时机**
  ///
  /// 请在房间内调用该方法.
  ///
  /// **参数说明**
  ///
  ///[effectId] 音效 ID
  ///
  ///返回：音效文件时长，单位为毫秒。
  Future<int> getEffectDuration(int effectId);

  ///开始通话前网络质量探测。 启用该方法后，SDK 会通过回调方式反馈上下行网络的质量状态与质量探测报告，包括带宽、丢包率、网络抖动和往返时延等数据。一般用于通话前的网络质量探测场景，用户加入房间之前可以通过该方法预估音视频通话中本地用户的主观体验和客观网络状态。 相关回调如下：
  ///
  /// **说明**
  /// * 请在加入房间（joinChannel）前调用此方法。
  /// * 调用该方法后，在收到[NERtcChannelEventCallback.onLastmileQuality] 和 [NERtcChannelEventCallback.onLastmileProbeResult] 回调之前请不要调用其他方法，否则可能会由于 API 操作过于频繁导致此方法无法执行。
  /// **相关回调**
  ///
  /// [NERtcChannelEventCallback.onLastmileQuality]：网络质量状态回调，以打分形式描述上下行网络质量的主观体验。该回调视网络情况在约 5 秒内返回。
  ///
  /// [NERtcChannelEventCallback.onLastmileProbeResult]：网络质量探测报告回调，报告中通过客观数据反馈上下行网络质量。该回调视网络情况在约 30 秒内返回。
  ///
  /// **参数说明**
  ///
  /// [config]Last mile 网络探测配置。详细说明请参考 [LastmileProbeConfig]

  Future<int> startLastmileProbeTest(LastmileProbeConfig config);

  ///停止通话前网络质量探测。
  Future<int> stopLastmileProbeTest();

  ///设置视频图像矫正参数。
  ///
  ///说明：
  ///
  /// * 矫正参数结构体的前 4 个参数，代表了待矫正区域相对于屏幕上视图的坐标，每个坐标点的 x 和 y 的取值范围均为 0 ~ 1 的浮点数。
  /// * 矫正参数结构体的后 3 个参数只有在使用了外部视频渲染功能时才需要传入。
  /// * config 可以传入 null，清空之前设置过的矫正参数，将画面恢复至矫正之前的效果。
  ///
  /// **参数说明**
  ///
  /// [config] 视频图像矫正相关参数。详细说明请参考[NERtcVideoCorrectionConfiguration]。
  Future<int> setVideoCorrectionConfig(
      NERtcVideoCorrectionConfiguration? config);

  /// 开启/关闭虚拟背景。 启用虚拟背景功能后，您可以使用自定义背景图片替换本地用户的原始背景图片。 替换后，频道内所有用户都可以看到自定义背景图片。
  ///
  /// **说明**
  ///
  /// * 建议您在满足以下条件的场景中使用该功能：
  ///     * 采用高清摄像设备，环境光线均匀。
  ///     * 捕获的视频图像整洁，用户肖像半长且基本无遮挡，并且背景是与用户衣服颜色不同的单一颜色。
  /// * 虚拟背景功能不支持在 Texture 格式的视频或通过 Push 方法从自定义视频源获取的视频中设置虚拟背景。
  /// * 若您设置背景图片为自定义本地图片，SDK 会在保证背景图片内容不变形的前提下，对图片进行一定程度上的缩放和裁剪，以适配视频采集分辨率。
  ///
  /// **参数说明**
  ///
  /// [enabled] 设置是否开启虚拟背景。
  ///
  /// [backgroundSource] 自定义背景图片。详细信息请参考[NERtcVirtualBackgroundSource]。
  ///
  /// **相关回调**
  ///
  ///您可以通过 [NERtcChannelEventCallback.onVirtualBackgroundSourceEnabled] 回调查看虚拟背景是否开启成功或出错原因。
  Future<int> enableVirtualBackground(
      bool enabled, NERtcVirtualBackgroundSource? backgroundSource,
      {bool force = false});

  ///设置远端用户音频流的高优先级。 支持在音频自动订阅的情况下，设置某一个远端用户的音频为最高优先级，可以优先听到该用户的音频
  ///
  /// **说明**
  ///
  /// - 该接口需要通话中设置，并需要打开自动订阅（默认打开）。
  ///
  ///- 该接口只能设置一个用户的优先级，后设置的会覆盖之前的设置。
  ///
  ///- 该接口通话结束后，优先级设置重置。
  ///
  /// **参数说明**
  ///
  /// [enabled]是否设置音频订阅优先级。rue：设置音频订阅优先级。false：取消设置音频订阅优先级。
  ///
  /// [uid] 用户 ID
  ///
  /// [streamType] 订阅音频流的类型。默认为 [NERtcAudioStreamType.kNERtcAudioStreamTypeMain]
  Future<int> setRemoteHighPriorityAudioStream(bool enabled, int uid,
      {int streamType});

  ///开启并设置云代理服务。 在内网环境下，如果用户防火墙开启了网络限制，请参考《使用云代理》将指定 IP 地址和端口号加入防火墙白名单，然后调用此方法开启云代理，并将 proxyType 参数设置为 NERtcTransportTypeUDPProxy(1)，即指定使用 UDP 协议的云代理。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间前调用此方法。
  ///
  ///
  /// 如果需要关闭已设置的云代理，请调用 [setCloudProxy]，并将参数设置为 `NONE_PROXY`。

  /// [proxyType] 云代理类型。详细信息请参考 [NERtcTransportType]。 该参数为必填参数，若未赋值，SDK 会报错。
  ///
  /// **相关回调**
  ///
  /// 成功连接云代理后，SDK 会触发 [NERtcChannelEventCallback.onConnectionStateChanged] 回调。
  Future<int> setCloudProxy(int proxyType);

  ///开启美颜功能模块。
  ///
  /// **调用时机**
  ///
  /// - 请先调用 [enableLocalVideo] 方法开启本地视频采集。
  /// - 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// 开启美颜功能模块后，默认无美颜效果，您需要通过 [setBeautyEffect] 或 [addBeautyFilter] 接口设置美颜或滤镜效果。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> startBeauty({String filePath = ""});

  ///结束美颜功能模块。 通过此接口实现关闭美颜功能模块后，SDK 会自动销毁美颜引擎并释放资源。
  ///
  /// **调用时机**
  ///
  ///请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  Future<void> stopBeauty();

  ///暂停或恢复美颜效果。 通过此接口实现取消美颜效果后，包括全局美颜、滤镜在内的所有美颜效果都会暂时关闭，直至重新恢复美颜效果。
  ///
  /// **调用时机**
  ///
  /// - 请先调用 [startBeauty] 方法开启美颜功能模块。
  ///
  /// - 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **参数说明**
  ///
  /// [enabled] 是否恢复美颜效果：true：恢复美颜效果。false：取消美颜效果。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> enableBeauty(bool enabled);

  ///设置美颜效果。 通过此接口可以实现设置磨皮、美白、大眼等多种全局美颜类型和对应的美颜强度
  ///
  /// **调用时机**
  ///
  /// - 请先调用 [startBeauty] 方法开启美颜功能模块。
  /// - 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// 您可以多次调用此接口以叠加多种全局美颜效果，也可以在此基础上通过其他方法叠加滤镜等自定义效果。
  ///
  /// **参数说明**
  ///
  /// [level] 对应美颜类型的强度。取值范围为 [0, 1]，各种美颜效果的默认值不同。
  ///
  /// [beautyType] 美颜类型，具体请参见 [NERtcBeautyEffectType]。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> setBeautyEffect(double level, int beautyType);

  ///添加滤镜效果。 通过此接口可以实现加载滤镜资源，并添加对应的滤镜效果；若您需要更换滤镜，重复调用此接口使用新的滤镜资源即可。
  ///
  /// **调用时机**
  ///
  /// - 请先调用 [startBeauty] 方法开启美颜功能模块。
  /// - 请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用。
  ///
  /// **说明**
  ///
  /// - 使用滤镜、贴纸和美妆等自定义美颜效果之前，请联系商务经理获取美颜资源或模型。
  ///
  /// - 滤镜效果可以和全局美颜、贴纸、美妆等效果互相叠加，但是不支持叠加多个滤镜。
  ///
  /// **参数说明**
  ///
  /// [path] 滤镜资源或模型所在路径。支持 SD 卡上的绝对路径，或 asset 目录下的相对路径:
  ///   - SD卡："/storage/emulated/0/Android/data/com.netease.lava.nertc.demo/files/filter_portrait/filter_style_FN1"
  ///   - asset: "2D/bunny"
  ///
  /// [name] iOS端需要滤镜资源或模型文件的名称。
  Future<int> addBeautyFilter(String path, {String name = ''});

  ///取消滤镜效果。
  Future<void> removeBeautyFilter();

  ///设置滤镜强度。 取值越大，滤镜强度越大，您可以根据业务需求自定义设置滤镜强度。
  ///
  /// **说明**
  ///
  ///滤镜强度设置实时生效，更换滤镜后滤镜强度不变，如需调整，可以再次调用此接口重新设置滤镜强度。
  ///
  /// **参数说明**
  ///
  /// [level] 滤镜强度。取值范围为 &#91; 0 - 1 &#93;，默认值为 0.5。
  Future<int> setBeautyFilterLevel(double level);

  ///设置视频水印。水印在本地预览及发送过程中均生效。
  ///
  /// **说明**
  ///
  /// - 设置水印后，建议关注水印状态回调 [NERtcChannelEventCallback.onLocalVideoWatermarkState]。
  /// - [setLocalVideoWatermarkConfigs] 接口的设置在通话结束后仍然有效，直至销毁 SDK。
  /// **参数说明**
  ///
  /// [type] 水印的视频流类型。支持设置为主流或辅流。详细信息请参考 [NERtcVideoStreamType]。
  ///
  /// [config] 水印设置。设置为 null 表示取消之前的水印。详细信息请参考 [NERtcVideoWatermarkConfig]。
  Future<int> setLocalVideoWatermarkConfigs(
      int type, NERtcVideoWatermarkConfig? config);

  ///开启精准对齐。 通过此接口可以实现精准对齐功能，对齐本地系统与服务端的时间。
  ///
  /// **调用时机**
  ///
  ///请在引擎初始化之后调用此接口，且该方法仅可在加入房间前调用。
  ///
  /// **业务场景**
  ///
  /// 适用于 KTV 实时合唱的场景。
  ///
  /// **参数说明**
  ///
  /// [enable] 是否开启精准对齐功能：
  ///   * true：开启精准对齐功能。
  ///   * false：关闭精准对齐功能。
  ///
  /// **相关接口**
  ///
  /// 可以调用 [getNtpTimeOffset] 方法获取本地系统时间与服务端时间的差值。
  Future<int> setStreamAlignmentProperty(bool enable);

  ///获取本地系统时间与服务端时间差值。
  ///
  ///可以用于做时间对齐，通过 (毫秒级系统时间 - offset) 可能得到当前服务端时间
  ///
  ///return  本地与服务端时间差值，单位为毫秒（ms）。如果没有成功加入音视频房间，返回 0。
  Future<int> getNtpTimeOffset();

  ///开启或关闭本地媒体流（主流）的发送。 该方法用于开始或停止向网络发送本地音频或视频数据。
  ///
  ///该方法不影响接收或播放远端媒体流，也不会影响本地音频或视频的采集状态。
  ///
  /// **说明**
  /// - 该方法暂时仅支持控制音频流的发送。
  ///
  /// - 停止发送媒体流的状态会在通话结束后被重置为允许发送。
  ///
  /// **参数说明**
  ///
  /// [enabled] 是否发布本地媒体流。
  ///    - true（默认）：发布本地媒体流。
  ///    - false：不发布本地媒体流。
  /// [mediaType] 媒体发布类型，暂时仅支持音频，详细信息请参考[NERtcMediaPubType]
  ///
  /// **相关回调**
  ///
  /// 成功调用该方法切换本地用户的发流状态后，房间内其他用户会收到 [NERtcChannelEventCallback.onUserAudioStart]:（开启发送音频）或 [NERtcChannelEventCallback.onUserAudioStop]:（停止发送音频）的回调。
  ///
  /// **相关接口**
  ///
  ///  [muteLocalAudioStream]：
  ///       - 在需要开启本地音频采集（监测本地用户音量）但不发送音频流的情况下，您也可以调用 [muteLocalAudioStream](true) 方法。
  ///       - 两者的差异在于， [muteLocalAudioStream](true) 仍然保持与服务器的音频通道连接，而 [enableMediaPub](false) 表示断开此通道，因此若您的实际业务场景为多人并发的大房间，建议您调用 [enableMediaPub] 方法。
  Future<int> enableMediaPub(int mediaType, bool enable);

  ///设置自己的音频只能被房间内指定的人订阅。 默认房间所有其他人都可以订阅自己的音频。
  ///
  /// **调用时机**
  ///
  ///此接口需要在加入房间成功后调用。
  ///
  /// **说明**
  ///
  ///  对于调用接口时不在房间的 uid 不生效。
  ///
  /// **参数说明**
  ///
  /// [uidArray] 可订阅自己音频的用户 uid 列表，此列表为全量列表。如果列表为空或 null，表示其他所有人均可订阅自己的音频。
  Future<int> setAudioSubscribeOnlyBy(List<int>? uidArray);

  /// 截取本地主流或本地辅流的视频画面。
  ///
  /// **说明**
  ///
  ///  - 需要在 [startVideoPreview] 或者 [enableLocalVideo] 并 [joinChannel] 成功之后调用。
  ///  - 视频截图功能可以截取实时视频流数据和编码水印信息。
  ///  - 同时设置文字、时间戳或图片水印时，如果不同类型的水印位置有重叠，会按照图片、文本、时间戳的顺序进行图层覆盖。
  ///
  /// **参数说明**
  ///
  /// [streamType] 截图的视频流类型。详细信息请参考 [NERtcVideoStreamType]。
  ///
  /// [path] 截图存放的路径。
  ///
  /// **相关回调**
  ///
  /// 截图画面数据存放在[path]中，通过 [NERtcChannelEventCallback.onTakeSnapshotResult] 回调返回。
  Future<int> takeLocalSnapshot(int streamType, String path);

  ///远端视频画面截图。 调用 [takeRemoteSnapshot] 截取指定 uid 远端主流和远端辅流的视频画面，并通过 [NERtcChannelEventCallback.onTakeSnapshotResult] 回调返回截图画面的数据。
  ///
  /// **说明**
  ///
  /// - [takeRemoteSnapshot] 需要在收到 [NERtcChannelEventCallback.onUserVideoStart] 与 [NERtcChannelEventCallback.onUserSubStreamVideoStart] 回调之后调用。
  /// - 视频截图功能可以截取实时视频流数据和编码水印信息。
  /// - 同时设置文字、时间戳或图片水印时，如果不同类型的水印位置有重叠，会按照图片、文本、时间戳的顺序进行图层覆盖。
  ///
  /// **参数说明**
  ///
  /// [uid] 远端用户 ID。
  ///
  /// [streamType] 截图的视频流类型。支持设置为主流或辅流。详细信息请参考 [NERtcVideoStreamType]。
  ///
  /// [path] 截图存放的路径。
  Future<int> takeRemoteSnapshot(int uid, int streamType, String path);

  ///是否启用视频图像畸变矫正。
  ///
  /// **说明**
  ///
  /// - 当使用相机去拍摄物体时，存在着一个从三维世界到二维图像的映射过程，这个过程中由于相机位置的变化和移动，会对拍摄物体的成像产生一定的形变影响。
  ///
  /// - 开启该功能时，根据合适的参数，可以通过算法把这个形变进行复原。
  ///
  /// - 使用该功能时，本地画布的渲染模式需要为 fit（即视频帧保持自身比例不变全部显示在当前视图中），否则矫正功能可能不会正常生效。
  ///
  /// - 矫正参数生效后，本地画面和对端看到的画面，均会是矫正以后的画面
  ///
  /// [enable] 是否开启视频图像矫正。
  ///   - true：开启视频图像矫正。
  ///   - false（默认）：关闭视频图像矫正。
  Future<int> enableVideoCorrection(bool enable);

  ///开启或关闭外部视频源数据输入。
  ///
  ///**说明**
  ///
  /// - 通过本接口可以实现创建自定义的外部视频源，您可以选择通过主流或辅流通道传输该外部视频源的数据。
  ///
  /// - 当外部视频源输入作为主流或辅流时，内部引擎为启用状态，在切换房间（switchChannel）、主动离开房间（leaveChannel）、触发断网重连失败回调（onDisconnect）或触发重新加入房间回调（onReJoinChannel）后仍然有效。如果需要关闭该功能，请在下次通话前调用接口关闭该功能。
  ///
  /// [enable] 是否使用外部视频源。
  ///   - true：开启外部视频源。
  ///   - false（默认）：关闭外部视频源。
  ///
  /// [streamType] 外部视频源的视频流类型。您可以选择通过主流或辅流通道传输该外部视频源的数据，默认主流。详细信息请参考 [NERtcVideoStreamType]。
  Future<int> setExternalVideoSource(bool enable,
      {int streamType = NERtcVideoStreamType.main});

  ///推送外部视频帧。
  ///
  ///**说明**
  ///
  /// - 请在通过 [setExternalVideoSource] 接口开启外部视频源数据输入后调用该方法，且必须使用同一种视频通道，即同为主流或辅流。
  ///
  /// - 调用该方法设置开启外部视频源输入时，内部引擎为启用状态，在离开房间（leaveChannel）后，该接口设置失效，将恢复至默认。
  ///
  /// [frame] 外部视频帧的数据信息, 详细信息请参考 [NERtcVideoFrame]。
  ///
  /// [streamType] 外部视频源的视频流类型。您可以选择通过主流或辅流通道传输该外部视频源的数据，默认主流。详细信息请参考 [NERtcVideoStreamType]。
  Future<int> pushExternalVideoFrame(NERtcVideoFrame frame,
      {int streamType = NERtcVideoStreamType.main});

  /// 设置视频dump
  Future<int> setVideoDump(NERtcVideoDumpType dumpType);

  /// 获取参数
  Future<String> getParameter(String key, String extraInfo);

  /// 设置视频流层数
  Future<int> setVideoStreamLayerCount(int layerCount);

  /// 启用本地数据
  Future<int> enableLocalData(bool enable);

  /// 订阅远端数据
  Future<int> subscribeRemoteData(int uid, bool subscribe);

  /// 获取功能支持类型
  Future<int> getFeatureSupportedType(NERtcFeatureType featureType);

  /// 是否支持功能
  Future<bool> isFeatureSupported(NERtcFeatureType featureType);

  /// 设置订阅音频黑名单
  /// streamType 参考 [NERtcAudioStreamType]
  Future<int> setSubscribeAudioBlocklist(List<int> uidList, int streamType);

  /// 设置订阅音频白名单
  Future<int> setSubscribeAudioAllowlist(List<int> uidList);

  /// 获取网络类型
  Future<int> getNetworkType();

  /// 停止推流
  Future<int> stopPushStreaming();

  /// 停止播放流
  Future<int> stopPlayStreaming(String streamId);

  /// 暂停播放流
  Future<int> pausePlayStreaming(String streamId);

  /// 恢复播放流
  Future<int> resumePlayStreaming(String streamId);

  /// 静音播放流视频
  Future<int> muteVideoForPlayStreaming(String streamId, bool mute);

  /// 静音播放流音频
  Future<int> muteAudioForPlayStreaming(String streamId, bool mute);

  /// 停止ASR字幕
  Future<int> stopASRCaption();

  /// AI手动中断
  Future<int> aiManualInterrupt(int dstUid);

  /// 设置AINS模式 [NERtcAudioAINSMode]
  Future<int> setAINSMode(NERtcAudioAINSMode mode);

  /// 设置音频场景
  Future<int> setAudioScenario(int scenario);

  /// 设置外部音频源
  Future<int> setExternalAudioSource(bool enable, int sampleRate, int channels);

  /// 设置外部子流音频源
  Future<int> setExternalSubStreamAudioSource(
      bool enable, int sampleRate, int channels);

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

  /// 添加本地录制流任务
  /// @since V5.6.40
  /// [config] 录制配置
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> addLocalRecorderStreamForTask(
      NERtcLocalRecordingConfig config, String taskId);

  /// 移除本地录制流任务
  /// @since V5.6.40
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> removeLocalRecorderStreamForTask(String taskId);

  /// 添加指定用户的指定流的录制流布局
  /// @since V5.6.40
  /// [config] 录制配置
  /// [uid] 用户 ID
  /// [streamType] 流类型
  /// [streamLayer] 流的录制混流层级
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> addLocalRecorderStreamLayoutForTask(
      NERtcLocalRecordingLayoutConfig config,
      int uid,
      int streamType,
      int streamLayer,
      String taskId);

  /// 移除指定用户的指定流的录制流布局
  /// @since V5.6.40
  /// [uid] 用户 ID
  /// [streamType] 流类型
  /// [streamLayer] 流的录制混流层级
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> removeLocalRecorderStreamLayoutForTask(
      int uid, int streamType, int streamLayer, String taskId);

  /// 更新指定用户的指定流的录制流布局
  /// @since V5.6.40
  /// [infos] 录制流布局配置数组
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> updateLocalRecorderStreamLayoutForTask(
      List<NERtcLocalRecordingStreamInfo> infos, String taskId);

  /// 替换指定用户的指定流的录制流布局
  /// @since V5.6.40
  /// [infos] 录制流布局配置数组
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> replaceLocalRecorderStreamLayoutForTask(
      List<NERtcLocalRecordingStreamInfo> infos, String taskId);

  /// 更新录制文件水印
  /// @since V5.9.5
  /// [watermarks] 水印配置数组
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> updateLocalRecorderWaterMarksForTask(
      List<NERtcVideoWatermarkConfig> watermarks, String taskId);

  /// 推送本地录制视频帧
  /// @since V5.6.40
  /// [uid] 用户 ID
  /// [streamType] 流类型
  /// [streamLayer] 数据的录制混流层级
  /// [taskId] 录制任务 ID
  /// [frame] 视频帧
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> pushLocalRecorderVideoFrameForTask(int uid, int streamType,
      int streamLayer, String taskId, NERtcVideoFrame frame);

  /// 显示录制默认封面
  /// @since V5.6.40
  /// [showEnabled] 是否显示封面
  /// [uid] 用户 ID
  /// [streamType] 流类型
  /// [streamLayer] 流的录制混流层级
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> showLocalRecorderStreamDefaultCoverForTask(bool showEnabled,
      int uid, int streamType, int streamLayer, String taskId);

  /// 停止录制文件转码为mp4
  /// @since V5.6.40
  /// [taskId] 录制任务 ID
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> stopLocalRecorderRemuxMp4(String taskId);

  /// 将flv转码为mp4
  /// @since V5.6.50
  /// [flvPath] flv文件目录，包含文件名及后缀名
  /// [mp4Path] 录制的mp4文件目录，包含文件名及后缀名
  /// [saveOri] 是否保留flv文件，true为保存，false为删除
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> remuxFlvToMp4(String flvPath, String mp4Path, bool saveOri);

  /// 停止将flv转码为mp4
  /// @since V5.6.50
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> stopRemuxFlvToMp4();

  /// 开始推流
  /// @since V5.8.2303
  /// [config] 推流配置
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> startPushStreaming(NERtcPushStreamingConfig config);

  /// 开始播放rtmp流
  /// @since V5.8.2303
  /// [streamId] 流ID
  /// [config] 拉流配置
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> startPlayStreaming(
      String streamId, NERtcPlayStreamingConfig config);

  /// 开启实时字幕
  /// @since V5.8.2303
  /// [config] ASR字幕配置
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> startASRCaption(NERtcASRCaptionConfig config);

  /// 设置网络多路径选项
  /// @since V5.8.2303
  /// [option] 多路径选项
  /// @return
  /// - 0: 方法调用成功
  /// - 其他: 调用失败
  Future<int> setMultiPathOption(NERtcMultiPathOption option);

  Future<int> sendData(NERtcDataExternalFrame frame);

  Future<int> pushExternalAudioFrame(NERtcAudioExternalFrame frame);

  Future<int> pushExternalSubAudioFrame(NERtcAudioExternalFrame frame);
}
