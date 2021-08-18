// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 添加直播任务结果回调
/// [taskId] 任务id
/// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
typedef void AddLiveTaskCallback(String taskId, int errCode);

/// 更新直播任务结果回调
/// [taskId] 任务id
/// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
typedef void UpdateLiveTaskCallback(String taskId, int errCode);

/// 删除直播任务结果回调
/// [taskId] 任务id
/// [errCode] 错误码， [NERtcLiveStreamErrorCode.ok] 操作成功 ， 其他失败
typedef void DeleteLiveTaskCallback(String taskId, int errCode);

/// NERtc 核心接口
class NERtcEngine {
  factory NERtcEngine() => _instance;

  NERtcEngine._() {
    _PlatformUtils.methodChannel.setMethodCallHandler(_handleCallbacks);
  }

  static final NERtcEngine _instance = NERtcEngine._();

  final NERtcAudioMixingManager _audioMixingManager =
      NERtcAudioMixingManager._();
  final NERtcDeviceManager _deviceManager = NERtcDeviceManager._();
  final NERtcAudioEffectManager _audioEffectManager =
      NERtcAudioEffectManager._();

  final _StatsEventHandler _statsEventHandler = _StatsEventHandler();
  final _ChannelEventHandler _channelEventHandler = _ChannelEventHandler();
  final _OnceEventHandler _onceEventHandler = _OnceEventHandler();

  /// 获取伴音管理模块
  NERtcAudioMixingManager get audioMixingManager => _audioMixingManager;

  /// 获取设备管理模块
  NERtcDeviceManager get deviceManager => _deviceManager;

  /// 获取音效管理模块
  NERtcAudioEffectManager get audioEffectManager => _audioEffectManager;

  EngineApi _api = EngineApi();

  /// 创建 NERtc 实例
  Future<int> create(
      {required String appKey,
      required NERtcChannelEventCallback channelEventCallback,
      NERtcOptions? options}) async {
    this._channelEventHandler.setCallback(channelEventCallback);
    IntValue reply = await _api.create(CreateEngineRequest()
      ..appKey = appKey
      ..logDir = options?.logDir
      ..logLevel = options?.logLevel
      ..audioAutoSubscribe = options?.audioAutoSubscribe
      ..audioDisableOverrideSpeakerOnReceiver =
          options?.audioDisableOverrideSpeakerOnReceiver
      ..audioAINSEnabled = options?.audioAINSEnabled
      ..audioDisableSWAECOnHeadset = options?.audioDisableSWAECOnHeadset
      ..videoEncodeMode = options?.videoEncodeMode?.index
      ..videoDecodeMode = options?.videoDecodeMode?.index
      ..videoCaptureObserverEnabled = options?.videoCaptureObserverEnabled
      ..serverRecordAudio = options?.serverRecordAudio
      ..serverRecordVideo = options?.serverRecordVideo
      ..serverRecordMode = options?.serverRecordMode?.index
      ..serverRecordSpeaker = options?.serverRecordSpeaker
      ..publishSelfStream = options?.publishSelfStream
      ..videoSendMode = options?.videoSendMode?.index
      ..videoH265Enabled = options?.videoH265Enabled);
    return reply.value ?? -1;
  }

  /// 销毁 NERtc实例，释放资源
  Future<int> release() async {
    this._channelEventHandler.setCallback(null);
    this.clearStatsEventCallback();
    IntValue reply = await _api.release();
    this._deviceManager.clearEventCallback();
    this._audioEffectManager.clearEventCallback();
    this._audioMixingManager.clearEventCallback();
    return reply.value ?? -1;
  }

  /// 设置统计监听
  Future<int> setStatsEventCallback(NERtcStatsEventCallback callback) async {
    _statsEventHandler.setCallback(callback);
    IntValue reply = await _api.setStatsEventCallback();
    return reply.value ?? -1;
  }

  /// 取消统计监听
  Future<int> clearStatsEventCallback() async {
    _statsEventHandler.setCallback(null);
    IntValue reply = await _api.clearStatsEventCallback();
    return reply.value ?? -1;
  }

  /// 加入音视频房间。
  ///
  /// 加入音视频房间时，如果指定房间尚未创建，云信服务器内部会自动创建一个同名房间。
  ///
  /// SDK 加入房间后，同一个房间内的用户可以互相通话，多个用户加入同一个房间，可以群聊。使用不同 App Key 的 App 之间不能互通。
  /// 成功调用该方加入房间后，本地会触发 onJoinChannel 回调，远端会触发 onUserJoined 回调。
  /// 用户成功加入房间后，默认订阅房间内所有其他用户的音频流，可能会因此产生用量并影响计费。如果想取消订阅，可以通过调用相应的 mute 方法实现。
  /// 直播场景中，观众角色可以通过 switchChannel 切换房间。
  ///
  /// [token] 安全认证签名（NERTC Token）。可设置为：
  /// * null。调试模式下可设置为 null。安全性不高，建议在产品正式上线前在云信控制台中将鉴权方式恢复为默认的安全模式。
  /// * 已获取的NERTC Token。安全模式下必须设置为获取到的 Token 。若未传入正确的 Token 将无法进入房间。推荐使用安全模式。
  ///
  /// [channelName] 房间名称，设置相同房间名称的用户会进入同一个通话房间。
  /// * 字符串格式，长度为 1~64 字节。
  /// * 支持以下89个字符：a-z, A-Z, 0-9, space, !#$%&()+-:;≤.,>? @[]^_{|}~”
  ///
  /// [uid] 用户的唯一标识 id，房间内每个用户的 uid 必须是唯一的。
  /// uid 可选，默认为 0。如果不指定（即设为 0），SDK 会自动分配一个随机 uid，并在 onJoinChannel 回调方法中返回，App 层必须记住该返回值并维护，SDK 不对该返回值进行维护。
  Future<int> joinChannel(String? token, String channelName, int uid) async {
    IntValue reply = await _api.joinChannel(JoinChannelRequest()
      ..token = token
      ..channelName = channelName
      ..uid = uid);
    return reply.value ?? -1;
  }

  /// 离开频道.
  Future<int> leaveChannel() async {
    IntValue reply = await _api.leaveChannel();
    return reply.value ?? -1;
  }

  /// 开启/关闭本地语音（采集和发送）
  ///
  /// [enable] - true: 开启， false : 关闭
  Future<int> enableLocalAudio(bool enable) async {
    IntValue reply = await _api.enableLocalAudio(BoolValue()..value = enable);
    return reply.value ?? -1;
  }

  ///订阅／取消订阅指定用户音频流
  ///
  /// [uid] 指定用户的 ID
  /// [subscribe] true: 订阅指定音频流（默认）false: 取消订阅指定音频流
  Future<int> subscribeRemoteAudio(int uid, bool subscribe) async {
    IntValue reply =
        await _api.subscribeRemoteAudio(SubscribeRemoteAudioRequest()
          ..uid = uid
          ..subscribe = subscribe);
    return reply.value ?? -1;
  }

  ///订阅／取消订阅所有用户音频（后续加入的用户也同样生效）
  ///
  /// [subscribe] true: 订阅 false: 取消订阅
  Future<int> subscribeAllRemoteAudio(bool subscribe) async {
    IntValue reply =
        await _api.subscribeAllRemoteAudio(BoolValue()..value = subscribe);
    return reply.value ?? -1;
  }

  ///设置音频场景与模式，必须在 init 前设置有效。
  ///
  /// [profile] 设置采样率，码率，编码模式和声道数 [AudioProfile]
  /// [scenario] 设置音频应用场景 [AudioScenario]
  Future<int> setAudioProfile(
      NERtcAudioProfile profile, NERtcAudioScenario scenario) async {
    IntValue reply = await _api.setAudioProfile(SetAudioProfileRequest()
      ..profile = profile.index
      ..scenario = scenario.index);
    return reply.value ?? -1;
  }

  /// 开启/关闭本地视频采集以及发送
  ///
  /// [enable] - true: 开启， false : 关闭
  Future<int> enableLocalVideo(bool enable) async {
    IntValue reply = await _api.enableLocalVideo(BoolValue()..value = enable);
    return reply.value ?? -1;
  }

  /// 设置视频编码属性。
  ///
  /// - 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  /// - 可以在加入房间前或加入房间后调用。
  /// - 设置成功后，下一次开启本端视频时生效。
  /// - 每个属性对应一套视频参数，例如分辨率、帧率、码率等。所有设置的参数均为理想情况下的最大值。当视频引擎因网络环境等原因无法达到设置的分辨率、帧率或码率的最大值时，会取最接近最大值的那个值。
  ///
  /// 视频编码属性配置 [config]，详细信息请参考 [NERtcVideoEncodeConfiguration]。
  /// 如果成功返回 `0`。
  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig) async {
    IntValue reply = await _api.setLocalVideoConfig(SetLocalVideoConfigRequest()
      ..frontCamera = videoConfig.frontCamera
      ..videoCropMode = videoConfig.videoCropMode
      ..videoProfile = videoConfig.videoProfile
      ..frameRate = videoConfig.frameRate
      ..minFrameRate = videoConfig.minFrameRate
      ..bitrate = videoConfig.bitrate
      ..minBitrate = videoConfig.minBitrate
      ..degradationPrefer = videoConfig.degradationPrefer
      ..width = videoConfig.width
      ..height = videoConfig.height
      ..cameraType = videoConfig.cameraType
      ..mirrorMode = videoConfig.mirrorMode
      ..orientationMode = videoConfig.orientationMode);
    return reply.value ?? -1;
  }

  /// 开启视频预览
  Future<int> startVideoPreview() async {
    IntValue reply = await _api.startVideoPreview();
    return reply.value ?? -1;
  }

  /// 停止视频预览
  Future<int> stopVideoPreview() async {
    IntValue reply = await _api.stopVideoPreview();
    return reply.value ?? -1;
  }

  /// 开启辅流形式的屏幕共享
  Future<int> startScreenCapture(NERtcScreenConfig config) async {
    IntValue reply = await _api.startScreenCapture(StartScreenCaptureRequest()
      ..bitrate = config.bitrate
      ..contentPrefer = config.contentPrefer
      ..frameRate = config.frameRate
      ..minBitrate = config.minBitrate
      ..minFrameRate = config.minFrameRate
      ..videoProfile = config.videoProfile);
    return reply.value ?? -1;
  }

  /// 关闭辅流形式的屏幕共享
  Future<int> stopScreenCapture() async {
    IntValue reply = await _api.stopScreenCapture();
    return reply.value ?? -1;
  }

  /// 订阅或取消订阅指定远端用户的视频流
  Future<int> subscribeRemoteVideo(
      int uid, int streamType, bool subscribe) async {
    IntValue reply =
        await _api.subscribeRemoteVideo(SubscribeRemoteVideoRequest()
          ..uid = uid
          ..streamType = streamType
          ..subscribe = subscribe);
    return reply.value ?? -1;
  }

  /// 订阅或取消订阅别人的辅流视频
  ///
  /// [uid] userID
  /// [subscribe] 是否订阅
  Future<int> subscribeRemoteSubStreamVideo(int uid, bool subscribe) async {
    IntValue reply = await _api
        .subscribeRemoteSubStreamVideo(SubscribeRemoteSubStreamVideoRequest()
          ..uid = uid
          ..subscribe = subscribe);
    return reply.value ?? -1;
  }

  /// 开关本地音频发送。该方法用于允许/禁止往网络发送本地音频流。
  Future<int> muteLocalAudioStream(bool mute) async {
    IntValue reply = await _api.muteLocalAudioStream(BoolValue()..value = mute);
    return reply.value ?? -1;
  }

  /// 开关本地视频发送
  Future<int> muteLocalVideoStream(bool mute) async {
    IntValue reply = await _api.muteLocalVideoStream(BoolValue()..value = mute);
    return reply.value ?? -1;
  }

  /// 开始音频dump
  Future<int> startAudioDump() async {
    IntValue reply = await _api.startAudioDump();
    return reply.value ?? -1;
  }

  /// 结束音频dump
  Future<int> stopAudioDump() async {
    IntValue reply = await _api.stopAudioDump();
    return reply.value ?? -1;
  }

  /// 启用说话者音量提示。该方法允许 SDK 定期向 App 反馈当前谁在说话以及说话者的音量
  ///
  /// [enable] 是否启用说话者音量提示
  /// [interval] 指定音量提示的时间间隔，单位为毫秒。必须设置为 100 毫秒的整数倍值
  Future<int> enableAudioVolumeIndication(bool enable, int interval) async {
    IntValue reply = await _api
        .enableAudioVolumeIndication(EnableAudioVolumeIndicationRequest()
          ..enable = enable
          ..interval = interval);
    return reply.value ?? -1;
  }

  ///设置频道场景
  ///只能在加入频道之前调用
  ///SDK 会根据不同的使用场景采用不同的优化策略，通信场景偏好流畅，直播场景偏好画质。
  ///
  /// [channelProfile] - 频道场景. [NERtcChannelProfile]
  Future<int> setChannelProfile(int channelProfile) async {
    IntValue reply =
        await _api.setChannelProfile(IntValue()..value = channelProfile);
    return reply.value ?? -1;
  }

  /// 是否开启双流模式
  ///
  /// [enable] - true:开启小流（默认），false: 关闭小流
  Future<int> enableDualStreamMode(bool enable) async {
    IntValue reply =
        await _api.enableDualStreamMode(BoolValue()..value = enable);
    return reply.value ?? -1;
  }

  /// 添加房间推流任务，成功添加后当前用户可以收到该直播流的状态通知。通话中有效。
  /// [taskInfo] 直播任务信息
  /// [AddLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> addLiveStreamTask(
      NERtcLiveStreamTaskInfo taskInfo, AddLiveTaskCallback? callback) async {
    int serial = -1;
    if (callback != null) {
      serial = _onceEventHandler.addOnceCallback((args) {
        callback(args['taskId'], args['errCode']);
      });
    }
    List<Map<dynamic, dynamic>>? userTranscodingList =
        taskInfo.layout?.userTranscodingList?.map((e) => e._toMap()).toList();
    IntValue reply =
        await _api.addLiveStreamTask(AddOrUpdateLiveStreamTaskRequest()
          ..serial = serial
          ..taskId = taskInfo.taskId
          ..url = taskInfo.url
          ..serverRecordEnabled = taskInfo.serverRecordEnabled
          ..liveMode = taskInfo.liveMode
          ..layoutWidth = taskInfo.layout?.width
          ..layoutHeight = taskInfo.layout?.height
          ..layoutBackgroundColor = taskInfo.layout?.backgroundColor?.value
          ..layoutImageUrl = taskInfo.layout?.backgroundImg?.url
          ..layoutImageX = taskInfo.layout?.backgroundImg?.x
          ..layoutImageY = taskInfo.layout?.backgroundImg?.y
          ..layoutImageWidth = taskInfo.layout?.backgroundImg?.width
          ..layoutImageHeight = taskInfo.layout?.backgroundImg?.height
          ..layoutUserTranscodingList = userTranscodingList);
    return reply.value ?? -1;
  }

  /// 更新修改房间推流任务。通话中有效。
  /// [taskInfo] 直播任务信息
  /// [UpdateLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> updateLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo,
      UpdateLiveTaskCallback? callback) async {
    int serial = -1;
    if (callback != null) {
      serial = _onceEventHandler.addOnceCallback((args) {
        callback(args['taskId'], args['errCode']);
      });
    }
    List<Map<dynamic, dynamic>>? userTranscodingList =
        taskInfo.layout?.userTranscodingList?.map((e) => e._toMap()).toList();
    IntValue reply =
        await _api.updateLiveStreamTask(AddOrUpdateLiveStreamTaskRequest()
          ..serial = serial
          ..taskId = taskInfo.taskId
          ..url = taskInfo.url
          ..serverRecordEnabled = taskInfo.serverRecordEnabled
          ..liveMode = taskInfo.liveMode
          ..layoutWidth = taskInfo.layout?.width
          ..layoutHeight = taskInfo.layout?.height
          ..layoutBackgroundColor = taskInfo.layout?.backgroundColor?.value
          ..layoutImageUrl = taskInfo.layout?.backgroundImg?.url
          ..layoutImageX = taskInfo.layout?.backgroundImg?.x
          ..layoutImageY = taskInfo.layout?.backgroundImg?.y
          ..layoutImageWidth = taskInfo.layout?.backgroundImg?.width
          ..layoutImageHeight = taskInfo.layout?.backgroundImg?.height
          ..layoutUserTranscodingList = userTranscodingList);
    return reply.value ?? -1;
  }

  /// 删除房间推流任务。通话中有效
  ///
  /// [taskId]   直播任务id
  /// [DeleteLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> removeLiveStreamTask(
      String taskId, DeleteLiveTaskCallback? callback) async {
    int serial = -1;
    if (callback != null) {
      serial = _onceEventHandler.addOnceCallback((args) {
        callback(args['taskId'], args['errCode']);
      });
    }
    IntValue reply =
        await _api.removeLiveStreamTask(DeleteLiveStreamTaskRequest()
          ..serial = serial
          ..taskId = taskId);
    return reply.value ?? -1;
  }

  /// 调节录音音量
  /// 加入频道前后都可以调用
  /// 调节范围为：[0~400]
  /// 0: 静音
  /// 100: 原始音量 (默认)
  /// 400: 最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// [volume] 调节的音量值。
  Future<int> adjustRecordingSignalVolume(int volume) async {
    IntValue reply =
        await _api.adjustRecordingSignalVolume(IntValue()..value = volume);
    return reply.value ?? -1;
  }

  /// 调节播放音量
  /// 加入频道前后都可以调用
  /// 调节范围为：[0~400]
  /// 0: 静音
  /// 100: 原始音量 (默认)
  /// 400: 最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// [volume] 调节的音量值。
  Future<int> adjustPlaybackSignalVolume(int volume) async {
    IntValue reply =
        await _api.adjustPlaybackSignalVolume(IntValue()..value = volume);
    return reply.value ?? -1;
  }

  /// 设置用户角色
  /// 在加入频道前或在频道中，用户可以通过setClientRole 接口设置本端模式为观众或主播模式。
  /// [role] 用户角色.  [NERtcClientRole]
  Future<int> setClientRole(int role) async {
    IntValue reply = await _api.setClientRole(IntValue()..value = role);
    return reply.value ?? -1;
  }

  /// 发送 SEI 信息
  /// 默认使用主流通道发送SEI 信息
  /// 接收SEI信息参考 [NERtcChannelEventCallback.onReceiveSEIMsg]
  /// 本接口有以下限制：
  ///   * sei 的发送的最大数据长度为 4k，若发送大量数据，会导致视频码率增大，可能导致视频画质下降甚至卡顿
  ///   * sei 发送的频率，最高为视频发送的帧率，建议不超过 10 次/秒
  ///   * sei 数据不一定立刻发出去，最快在下一帧视频数帧之后发送，最慢在接下来的 5 帧视频帧之后发送
  ///   * sei 数据有可能由于弱网信息而丢失，所以建议多次发送来保证接收端收到的概率
  ///   * 需要使用哪个通道发送sei时，需要提前把对应的数据流通道开启
  ///
  /// [seiMsg] sei 信息 ， 最大长度不能超过4k
  /// [streamType] 指定使用那个视频通道(主流/辅流)发送SEI. [NERtcVideoStreamType]
  Future<int> sendSEIMsg(String seiMsg,
      {int streamType = NERtcVideoStreamType.main}) async {
    IntValue reply = await _api.sendSEIMsg(SendSEIMsgRequest()
      ..seiMsg = seiMsg
      ..streamType = streamType);
    return reply.value ?? -1;
  }

  /// 获取连接状态
  ///
  /// 状态参考 [NERtcConnectionState]
  Future<int> getConnectionState() async {
    IntValue reply = await _api.getConnectionState();
    return reply.value ?? -1;
  }

  /// 上传SDK日志信息
  /// 只能在加入频道后调用
  Future<int> uploadSdkInfo() async {
    IntValue reply = await _api.uploadSdkInfo();
    return reply.value ?? -1;
  }

  /// 设置 SDK 预设的人声的变声音效。
  /// <br>设置变声音效可以将人声原因调整为多种特殊效果，改变声音特性。
  ///
  /// <p><b>注意</b>：
  /// <ul><li> 此方法在加入房间前后都能调用，通话结束后重置为默认关闭状态。
  /// <li> 此方法和 [setLocalVoicePitch] 互斥，调用此方法后，本地语音语调会恢复为默认值 1.0。
  /// [preset] 预设的变声音效。默认关闭变声音效。详细信息请参考 [NERtcVoiceChangerType] 。
  Future<int> setAudioEffectPreset(int preset) async {
    IntValue reply =
        await _api.setAudioEffectPreset(IntValue()..value = preset);
    return reply.value ?? -1;
  }

  /// 设置 SDK 预设的美声效果。
  /// <br>调用该方法可以为本地发流用户设置 SDK 预设的人声美声效果。
  ///
  /// <p><b>注意</b>：该方法在加入房间前后都能调用，通话结束后重置为默认关闭状态。
  /// [preset] 预设的美声效果模式。默认关闭美声效果。详细信息请参考 [NERtcVoiceBeautifierType]
  Future<int> setVoiceBeautifierPreset(int preset) async {
    IntValue reply =
        await _api.setVoiceBeautifierPreset(IntValue()..value = preset);
    return reply.value ?? -1;
  }

  /// 设置本地语音音调。
  /// <br>该方法改变本地说话人声音的音调。
  /// <p><b>注意</b>：
  /// * <ul><li> 通话结束后该设置会重置，默认为 1.0。
  /// * <li> 此方法与 [setAudioEffectPreset] 互斥，调用此方法后，已设置的变声效果会被取消。
  /// [pitch] 语音频率。可以在 [0.5, 2.0] 范围内设置。取值越小，则音调越低。默认值为 1.0，表示不需要修改音调。
  Future<int> setLocalVoicePitch(double pitch) async {
    IntValue reply =
        await _api.setLocalVoicePitch(DoubleValue()..value = pitch);
    return reply.value ?? -1;
  }

  /// 设置本地语音音效均衡，即自定义设置本地人声均衡波段的中心频率。
  ///
  /// <p><b>注意</b>：该方法在加入房间前后都能调用，通话结束后重置为默认关闭状态。
  ///
  /// [bandFrequency] 频谱子带索引，取值范围是 [0-9]，分别代表 10 个频带，对应的中心频率是 [31，62，125，250，500，1k，2k，4k，8k，16k] Hz。
  /// [bandGain]      每个 band 的增益，单位是 dB，每一个值的范围是 [-15，15]，默认值为 0。
  Future<int> setLocalVoiceEqualization(int bandFrequency, int bandGain) async {
    IntValue reply =
        await _api.setLocalVoiceEqualization(SetLocalVoiceEqualizationRequest()
          ..bandFrequency = bandFrequency
          ..bandGain = bandGain);
    return reply.value ?? -1;
  }

  /// 快速切换音视频房间。
  /// <br>房间场景为直播场景时，房间中角色为观众的成员可以调用该方法从当前房间快速切换至另一个房间。
  /// <br>成功调用该方切换房间后：
  /// <ul><li> 本端会先收到离开房间的回调 [NERtcChannelEventCallback.onLeaveChannel]，其中 result 参数为 [NERtcErrorCode.leaveChannelForSwitch]。再收到成功加入新房间的回调 [NERtcChannelEventCallback.onJoinChannel]。
  /// <li> 远端用户会收到 [NERtcChannelEventCallback.onUserLeave] 和 [NERtcChannelEventCallback.onUserJoined]  的回调。
  /// 房间成员成功切换房间后，默认订阅房间内所有其他成员的音频流，因此产生用量并影响计费。如果想取消订阅，可以通过调用相应的 [subscribeRemoteAudio] 方法传入false实现。
  ///
  /// <br>该方法仅适用于直播场景中，角色为观众的音视频房间成员。即已通过接口 [setChannelProfile] 设置房间场景为直播，通过 [setClientRole] 设置房间成员的角色为观众。
  ///
  /// [token] 在服务器端生成的用于鉴权的安全认证签名（Token）。可设置为：
  /// <ul><li> 已获取的 Token。安全模式下必须设置为获取到的 Token。默认 token 有效期 10 min，也可以定期通过应用服务器向云信服务器申请 token 或者申请长期且可复用的 token。推荐使用安全模式。
  /// <li><code>null</code>。非安全模式下可设置为 null。安全性不高，建议在产品正式上线前联系对应商务经理转为安全模式。
  /// [channelName] 期望切换到的目标房间名称
  ///
  /// <br>方法调用成功返回 0 ，其他调用失败：
  /// <ul><li> [NERtcErrorCode.switchChannelNotJoined]: 切换频道时不在会议中
  /// <li> [NERtcErrorCode.reserveNoPermission]: 用户角色不是观众。
  /// <li> [NERtcErrorCode.roomAlreadyJoined]: 频道名无效，已在此频道中。
  Future<int> switchChannel(String? token, String channelName) async {
    IntValue reply = await _api.switchChannel(SwitchChannelRequest()
      ..token = token
      ..channelName = channelName);
    return reply.value ?? -1;
  }

  /// 开始客户端录音。
  ///
  /// 调用该方法后，客户端会录制房间内所有用户混音后的音频流，并将其保存在本地一个录音文件中。录制开始或结束时，自动触发 [onAudioRecording] 回调。
  ///
  /// 指定的录音音质不同，录音文件会保存为不同格式：
  ///  <ul><li>WAV：音质保真度高，文件大。</li>
  ///  <li>AAC：音质保真度低，文件小。</li></ul>
  ///
  /// 请在加入房间后调用此方法。
  /// 客户端只能同时运行一个录音任务，正在录音时，如果重复调用 startAudioRecording，会结束当前录制任务，并重新开始新的录音任务。
  /// 当前用户离开房间时，自动停止录音。您也可以在通话中随时调用 stopAudioRecording 手动停止录音。
  ///
  /// [filePath] 录音文件在本地保存的绝对路径，需要精确到文件名及格式。例如：sdcard/xxx/audio.aac。 请确保指定的路径存在并且可写, 目前仅支持 WAV 或 AAC 文件格式。
  /// [sampleRate] 录音采样率（Hz），可以设为 16000、32000（默认）、44100 或 48000。
  /// [quality] 录音音质，只在 AAC 格式下有效。详细说明请参考 [NERtcAudioRecordingQuality].
  Future<int> startAudioRecording(
      String filePath, int sampleRate, int quality) async {
    IntValue reply = await _api.startAudioRecording(StartAudioRecordingRequest()
      ..filePath = filePath
      ..sampleRate = sampleRate
      ..quality = quality);
    return reply.value ?? -1;
  }

  /// 停止客户端录音。
  ///
  /// 本端离开房间时自动停止录音，您也可以在通话中随时调用 stopAudioRecording 手动停止录音。
  /// 该接口需要在 leaveChannel 之前调用。
  Future<int> stopAudioRecording() async {
    IntValue reply = await _api.stopAudioRecording();
    return reply.value ?? -1;
  }

  /// 设置本地用户的媒体流优先级。
  ///
  /// 如果某个用户的优先级为高，那么该用户媒体流的优先级就会高于其他用户，弱网环境下 SDK 会优先保证高优先级用户收到的媒体流的质量。
  ///
  /// 请在加入房间前调用此方法。一个音视频房间中只有一个高优先级的用户。建议房间中只有一位用户调用 [setLocalMediaPriority] 将本端媒体流设为高优先级，否则需要开启抢占模式，保证本地用户的高优先级设置生效。
  /// [priority] 本地用户的媒体流优先级，默认为 [NERtcMediaPriority.normal]，详细信息请参考 [NERtcMediaPriority]。
  /// [isPreemptive] 是否开启抢占模式。抢占模式开启后，本地用户可以抢占其他用户的高优先级，被抢占的用户的媒体优先级变为普通优先级，在抢占者退出房间后，其他用户的优先级仍旧维持普通优先级。
  /// 抢占模式关闭时，如果房间中已有高优先级用户，则本地用户的高优先级设置不生效，仍旧为普通优先级。
  Future<int> setLocalMediaPriority(int priority, bool isPreemptive) async {
    IntValue reply =
        await _api.setLocalMediaPriority(SetLocalMediaPriorityRequest()
          ..priority = priority
          ..isPreemptive = isPreemptive);
    return reply.value ?? -1;
  }

  /// 开始跨房间媒体流转发。
  /// - 该方法可用于实现跨房间连麦等场景。支持同时转发到 4 个房间，同一个房间可以有多个转发进来的媒体流。
  /// - 成功调用该方法后，SDK 会触发 [onMediaRelayStatesChange] 和 [onMediaRelayReceiveEvent] 回调，并在回调中报告当前的跨房间媒体流转发状态和事件。
  ///
  ///
  /// 请在成功加入房间后调用该方法。调用此方法前需要通过 [config] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 设置目标房间。
  /// 该方法仅对直播场景下的主播角色有效。
  /// 成功调用该方法后，若您想再次调用该方法，必须先调用 [stopChannelMediaRelay] 方法退出当前的转发状态。
  /// 成功开始跨房间转发媒体流后，如果您需要修改目标房间，例如添加或删减目标房间等，可以调用方法 [updateChannelMediaRelay] 更新目标房间信息。
  /// [config] 跨房间媒体流转发参数配置信息。详细信息请参考 [NERtcChannelMediaRelayConfiguration]。
  Future<int> startChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) async {
    StartOrUpdateChannelMediaReplayRequest request =
        StartOrUpdateChannelMediaReplayRequest();
    request.sourceMediaInfo = config.sourceMediaInfo?._toMap();
    request.destMediaInfo = {};
    config.destMediaInfo.forEach((key, value) {
      request.destMediaInfo![key] = value._toMap();
    });
    IntValue reply = await _api.startChannelMediaReplay(request);
    return reply.value ?? -1;
  }

  /// 更新媒体流转发的目标房间。
  ///
  /// 成功开始跨房间转发媒体流后，如果你希望将流转发到多个目标房间，或退出当前的转发房间，可以调用该方法。
  /// - 成功开始跨房间转发媒体流后，如果您需要修改目标房间，例如添加或删减目标房间等，可以调用此方法。
  /// - 成功调用此方法后，SDK 会触发 [onMediaRelayStatesChange] 和 [onMediaRelayReceiveEvent] 回调，并在回调中报告当前的跨房间媒体流转发状态和事件。
  ///
  ///
  /// 请在加入房间并成功调用 [startChannelMediaRelay] 开始跨房间媒体流转发后，调用此方法。
  /// 调用此方法前需要通过 [NERtcChannelMediaRelayConfiguration] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 设置目标房间。
  /// 跨房间媒体流转发最多支持 4 个目标房间，您可以在调用该方法之前，
  /// 通过 [NERtcChannelMediaRelayConfiguration] 中的 [NERtcChannelMediaRelayConfiguration.destMediaInfo] 移除不需要的房间，再添加新的目标房间。
  ///
  /// [config]  跨房间媒体流转发参数配置信息。详细信息请参考 [NERtcChannelMediaRelayConfiguration]。
  Future<int> updateChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) async {
    StartOrUpdateChannelMediaReplayRequest request =
        StartOrUpdateChannelMediaReplayRequest();
    request.sourceMediaInfo = config.sourceMediaInfo?._toMap();
    request.destMediaInfo = {};
    config.destMediaInfo.forEach((key, value) {
      request.destMediaInfo![key] = value._toMap();
    });
    IntValue reply = await _api.updateChannelMediaRelay(request);
    return reply.value ?? -1;
  }

  /// 停止跨房间媒体流转发。
  ///
  /// 主播离开房间时，跨房间媒体流转发自动停止，您也可以在需要的时候随时调用 [stopChannelMediaRelay] 方法，此时主播会退出所有目标房间。
  /// - 成功调用该方法后，SDK 会触发 [onMediaRelayStatesChange] 回调。如果报告 [NERtcChannelMediaRelayState.idle]，则表示已停止转发媒体流。
  /// - 如果该方法调用不成功，SDK 会触发 [onMediaRelayStatesChange] 回调，并报告状态码 [NERtcChannelMediaRelayState.failure]。
  Future<int> stopChannelMediaRelay() async {
    IntValue reply = await _api.stopChannelMediaRelay();
    return reply.value ?? -1;
  }

  /// 调节本地播放的指定远端用户的信号音量。
  ///
  /// 加入房间后，您可以多次调用该方法设置本地播放的不同远端用户的音量；也可以反复调节本地播放的某个远端用户的音量。
  ///
  /// 请在成功加入房间后调用该方法。
  /// 该方法在本次通话中有效。如果远端用户中途退出房间，则再次加入此房间时仍旧维持该设置，通话结束后设置失效。
  /// 该方法调节的是本地播放的指定远端用户混音后的音量，且每次只能调整一位远端用户。若需调整多位远端用户在本地播放的音量，则需多次调用该方法。
  ///
  /// [uid] 远端用户 ID。 [volume] 播放音量，取值范围为 [0,100]。
  Future<int> adjustUserPlaybackSignalVolume(int uid, int volume) async {
    IntValue reply = await _api
        .adjustUserPlaybackSignalVolume(AdjustUserPlaybackSignalVolumeRequest()
          ..uid = uid
          ..volume = volume);
    return reply.value ?? -1;
  }

  /// 设置弱网条件下发布的音视频流回退选项。
  ///
  /// 在网络不理想的环境下，发布的音视频质量都会下降。使用该接口并将 option 设置为 [NERtcStreamFallbackOptions.audioOnly] 后:
  /// - SDK 会在上行弱网且音视频质量严重受影响时，自动关断视频流，尽量保证音频质量。
  /// - 同时 SDK 会持续监控网络质量，并在网络质量改善时恢复音视频流。
  /// - 当本地发布的音视频流回退为音频流时，或由音频流恢复为音视频流时，SDK 会触发本地发布的媒体流已回退为音频流 [onLocalPublishFallbackToAudioOnly] 回调。
  ///
  /// 请在加入房间 [joinChannel] 前调用此方法。
  ///
  /// [options] 发布音视频流的回退选项，默认为不开启回退。 详细信息请参考 [NERtcStreamFallbackOptions]。
  /// 如果成功返回 `0`。
  Future<int> setLocalPublishFallbackOption(int option) async {
    IntValue reply =
        await _api.setLocalPublishFallbackOption(IntValue()..value = option);
    return reply.value ?? -1;
  }

  /// 设置弱网条件下订阅的音视频流回退选项。
  ///
  /// 弱网环境下，订阅的音视频质量会下降。通过该接口设置订阅音视频流的回退选项后：
  /// - SDK 会在下行弱网且音视频质量严重受影响时，将视频流切换为小流，或关断视频流，从而保证或提高通信质量。
  /// - SDK 会持续监控网络质量，并在网络质量改善时自动恢复音视频流。
  /// - 当远端订阅流回退为音频流时，或由音频流恢复为音视频流时，SDK 会触发远端订阅流已回退为音频流回调。
  ///
  /// 请在加入房间 [joinChannel] 前调用此方法。
  ///
  /// [option] 订阅音视频流的回退选项，默认为弱网时回退到视频小流。详细信息请参考 [NERtcStreamFallbackOptions]。
  /// 如果成功返回 `0`。
  Future<int> setRemoteSubscribeFallbackOption(int option) async {
    IntValue reply =
        await _api.setRemoteSubscribeFallbackOption(IntValue()..value = option);
    return reply.value ?? -1;
  }

  /// 启用或停止 AI 超分。
  /// 使用 AI 超分功能之前，请联系技术支持开通 AI 超分功能。
  /// AI 超分仅对以下类型的视频流有效：
  /// * 必须为本端接收到第一路 360P 的视频流。
  /// * 必须为摄像头采集到的主流大流视频。AI 超分功能暂不支持复原重建小流和屏幕共享辅流。
  Future<int> enableSuperResolution(bool enable) async {
    IntValue reply =
        await _api.enableSuperResolution(BoolValue()..value = enable);
    return reply.value ?? -1;
  }

  /// 开启或关闭媒体流加密。
  ///
  /// 在金融行业等安全性要求较高的场景下，您可以在加入房间前通过此方法设置媒体流加密模式。
  ///
  /// 请在加入房间前调用该方法，加入房间后无法修改加密模式与密钥。用户离开房间后，SDK 会自动关闭加密。如需重新开启加密，需要在用户再次加入房间前调用此方法。
  /// 同一房间内，所有开启媒体流加密的用户必须使用相同的加密模式和密钥，否则使用不同密钥的成员加入房间时会报错 ENGINE_ERROR_ENCRYPT_NOT_SUITABLE（30113）。
  /// 安全起见，建议每次启用媒体流加密时都更换新的密钥。

  Future<int> enableEncryption(
      bool enable, NERtcEncryptionConfig config) async {
    IntValue reply = await _api.enableEncryption(EnableEncryptionRequest()
      ..enable = enable
      ..key = config.key
      ..mode = config.mode.index);
    return reply.value ?? -1;
  }

  Future<dynamic> _handleCallbacks(MethodCall call) async {
    String method = call.method;
    Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;

    bool handled = _onceEventHandler.handler(method, arguments) ||
        _channelEventHandler.handler(method, arguments) ||
        _deviceManager._eventHandler().handler(method, arguments) ||
        _audioMixingManager._eventHandler().handler(method, arguments) ||
        _statsEventHandler.handler(method, arguments) ||
        _audioEffectManager._eventHandler().handler(method, arguments);
    if (!handled) {
      String method = call.method;
      print('$method unhandled.');
    }
  }
}
