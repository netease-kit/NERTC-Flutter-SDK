// Copyright (c) 2014-2019 NetEase, Inc. All right reserved.

part of nertc;

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

  /// Audio Mixing Manager
  NERtcAudioMixingManager get audioMixingManager => _audioMixingManager;

  /// Device Manager
  NERtcDeviceManager get deviceManager => _deviceManager;

  /// Audio Effect Manager
  NERtcAudioEffectManager get audioEffectManager => _audioEffectManager;

  EngineApi _api = EngineApi();

  /// Configure
  Future<void> create(
      {@required String appKey,
      @required NERtcChannelEventCallback channelEventCallback,
      NERtcOptions options}) {
    assert(appKey != null);
    assert(channelEventCallback != null);
    this._channelEventHandler.setCallback(channelEventCallback);
    return _api.create(CreateEngineRequest()
      ..appKey = appKey
      ..logDir = options?.logDir
      ..logLevel = options?.logLevel
      ..autoSubscribeAudio = options?.autoSubscribeAudio
      ..videoEncodeMode = options?.videoEncodeMode?.index
      ..videoDecodeMode = options?.videoDecodeMode?.index
      ..serverRecordAudio = options?.serverRecordAudio
      ..serverRecordVideo = options?.serverRecordVideo
      ..serverRecordMode = options?.serverRecordMode?.index
      ..serverRecordSpeaker = options?.serverRecordSpeaker
      ..publishSelfStream = options?.publishSelfStream
      ..videoSendMode = options?.videoSendMode?.index);
  }

  /// Release rtc engine
  Future<void> release() {
    this._channelEventHandler.setCallback(null);
    return _api.release();
  }

  /// 设置统计监听
  Future<int> setStatsEventCallback(NERtcStatsEventCallback callback) async {
    assert(callback != null);
    _statsEventHandler.setCallback(callback);
    IntValue reply = await _api.setStatsEventCallback();
    return reply.value;
  }

  /// 取消统计监听
  Future<int> clearStatsEventCallback() async {
    _statsEventHandler.setCallback(null);
    IntValue reply = await _api.clearStatsEventCallback();
    return reply.value;
  }

  ///设置频道场景
  ///只能在加入频道之前调用
  ///SDK 会根据不同的使用场景采用不同的优化策略，通信场景偏好流畅，直播场景偏好画质。
  ///
  /// [channelProfile] - 频道场景. [NERtcChannelProfile]
  Future<int> setChannelProfile(int channelProfile) async {
    assert(channelProfile != null);
    IntValue reply =
        await _api.setChannelProfile(IntValue()..value = channelProfile);
    return reply.value;
  }

  /// 加入频道
  ///
  /// [token] 如果为 null 则会采用非安全模式.
  /// [id] 用户id, 不能为 0
  Future<int> joinChannel(String token, String channelName, int uid) async {
    assert(channelName != null);
    assert(uid != null);
    IntValue reply = await _api.joinChannel(JoinChannelRequest()
      ..token = token
      ..channelName = channelName
      ..uid = uid);
    return reply.value;
  }

  /// 离开频道.
  Future<int> leaveChannel() async {
    IntValue reply = await _api.leaveChannel();
    return reply.value;
  }

  /// 开启/关闭本地语音（采集和发送）
  ///
  /// [enable] - true: 开启， false : 关闭
  Future<int> enableLocalAudio(bool enable) async {
    assert(enable != null);
    IntValue reply = await _api.enableLocalAudio(BoolValue()..value = enable);
    return reply.value;
  }

  ///订阅／取消订阅指定用户音频流
  ///
  /// [uid] 指定用户的 ID
  /// [subscribe] true: 订阅指定音频流（默认）false: 取消订阅指定音频流
  Future<int> subscribeRemoteAudioStream(int uid, bool subscribe) async {
    assert(uid != null);
    assert(subscribe != null);
    IntValue reply = await _api
        .subscribeRemoteAudioStream(SubscribeRemoteAudioStreamRequest()
          ..uid = uid
          ..subscribe = subscribe);
    return reply.value;
  }

  ///订阅／取消订阅所有用户音频（后续加入的用户也同样生效）
  ///
  /// [subscribe] true: 订阅 false: 取消订阅
  Future<int> subscribeAllRemoteAudioStreams(bool subscribe) async {
    assert(subscribe != null);
    IntValue reply = await _api
        .subscribeAllRemoteAudioStreams(BoolValue()..value = subscribe);
    return reply.value;
  }

  ///设置音频场景与模式，必须在 init 前设置有效。
  ///
  /// [profile] 设置采样率，码率，编码模式和声道数 [AudioProfile]
  /// [scenario] 设置音频应用场景 [AudioScenario]
  Future<int> setAudioProfile(
      NERtcAudioProfile profile, NERtcAudioScenario scenario) async {
    assert(profile != null);
    assert(scenario != null);
    IntValue reply = await _api.setAudioProfile(SetAudioProfileRequest()
      ..profile = profile.index
      ..scenario = scenario.index);
    return reply.value;
  }

  /// 是否开启双流模式
  ///
  /// [enable] - true:开启小流（默认），false: 关闭小流
  Future<int> enableDualStreamMode(bool enable) async {
    IntValue reply =
        await _api.enableDualStreamMode(BoolValue()..value = enable);
    return reply.value;
  }

  /// 开启/关闭本地视频采集以及发送
  ///
  /// [enable] - true: 开启， false : 关闭
  Future<int> enableLocalVideo(bool enable) async {
    IntValue reply = await _api.enableLocalVideo(BoolValue()..value = enable);
    return reply.value;
  }

  /// 设置视频参数（分辨率、摄像头位置等）
  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig) async {
    assert(videoConfig != null);
    IntValue reply = await _api.setLocalVideoConfig(SetLocalVideoConfigRequest()
      ..frontCamera = videoConfig.frontCamera
      ..videoCropMode = videoConfig.videoCropMode
      ..videoProfile = videoConfig.videoProfile
      ..frameRate = videoConfig.frameRate
      ..minFrameRate = videoConfig.minFrameRate
      ..bitrate = videoConfig.bitrate
      ..minBitrate = videoConfig.minBitrate
      ..degradationPrefer = videoConfig.degradationPrefer);
    return reply.value;
  }

  /// 开启视频预览
  Future<int> startVideoPreview() async {
    IntValue reply = await _api.startVideoPreview();
    return reply.value;
  }

  /// 停止视频预览
  Future<int> stopVideoPreview() async {
    IntValue reply = await _api.stopVideoPreview();
    return reply.value;
  }

  /// 开启屏幕共享
  Future<int> startScreenCapture(int screenProfile) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      IntValue reply =
          await _api.startScreenCapture(IntValue()..value = screenProfile);
      return reply.value;
    } else {
      return Future.value(-1);
    }
  }

  /// 停止屏幕共享
  Future<int> stopScreenCapture() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      IntValue reply = await _api.stopScreenCapture();
      return reply.value;
    } else {
      return Future.value(-1);
    }
  }

  /// 订阅 / 取消订阅指定远端用户的视频流
  Future<int> subscribeRemoteVideoStream(
      int uid, int streamType, bool subscribe) async {
    assert(uid != null);
    assert(streamType != null);
    assert(subscribe != null);
    IntValue reply = await _api
        .subscribeRemoteVideoStream(SubscribeRemoteVideoStreamRequest()
          ..uid = uid
          ..streamType = streamType
          ..subscribe = subscribe);
    return reply.value;
  }

  /// 开关本地音频发送。该方法用于允许/禁止往网络发送本地音频流。
  Future<int> muteLocalAudioStream(bool mute) async {
    assert(mute != null);
    IntValue reply = await _api.muteLocalAudioStream(BoolValue()..value = mute);
    return reply.value;
  }

  /// 开关本地视频发送
  Future<int> muteLocalVideoStream(bool mute) async {
    assert(mute != null);
    IntValue reply = await _api.muteLocalVideoStream(BoolValue()..value = mute);
    return reply.value;
  }

  /// 开始音频dump
  Future<int> startAudioDump() async {
    IntValue reply = await _api.startAudioDump();
    return reply.value;
  }

  /// 结束音频dump
  Future<int> stopAudioDump() async {
    IntValue reply = await _api.stopAudioDump();
    return reply.value;
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
    return reply.value;
  }

  Future<NERtcVideoRenderer> createVideoRenderer() async {
    NERtcVideoRenderer renderer = NERtcVideoRenderer();
    await renderer.initialize();
    return renderer;
  }

  Future<dynamic> _handleCallbacks(MethodCall call) async {
    bool handled = _channelEventHandler.handler(call) ||
        _deviceManager._eventHandler().handler(call) ||
        _audioMixingManager._eventHandler().handler(call) ||
        _statsEventHandler.handler(call) ||
        _audioEffectManager._eventHandler().handler(call);
    if (!handled) {
      String method = call.method;
      print('$method unhandled.');
    }
  }
}
