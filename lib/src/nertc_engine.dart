// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

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
      ..videoSendMode = options?.videoSendMode?.index);
  }

  /// 销毁 NERtc实例，释放资源
  Future<int> release() async {
    this._channelEventHandler.setCallback(null);
    this.clearStatsEventCallback();
    IntValue reply = await _api.release();
    this._deviceManager.clearEventCallback();
    this._audioEffectManager.clearEventCallback();
    this._audioMixingManager.clearEventCallback();
    return reply.value;
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
  Future<int> subscribeRemoteAudio(int uid, bool subscribe) async {
    assert(uid != null);
    assert(subscribe != null);
    IntValue reply =
        await _api.subscribeRemoteAudio(SubscribeRemoteAudioRequest()
          ..uid = uid
          ..subscribe = subscribe);
    return reply.value;
  }

  ///订阅／取消订阅所有用户音频（后续加入的用户也同样生效）
  ///
  /// [subscribe] true: 订阅 false: 取消订阅
  Future<int> subscribeAllRemoteAudio(bool subscribe) async {
    assert(subscribe != null);
    IntValue reply =
        await _api.subscribeAllRemoteAudio(BoolValue()..value = subscribe);
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
      ..degradationPrefer = videoConfig.degradationPrefer
      ..width = videoConfig.width
      ..height = videoConfig.height
      ..cameraType = videoConfig.cameraType);
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

  /// 开启辅流形式的屏幕共享
  Future<int> startScreenCapture(NERtcScreenConfig config) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      IntValue reply = await _api.startScreenCapture(StartScreenCaptureRequest()
        ..bitrate = config.bitrate
        ..contentPrefer = config.contentPrefer
        ..frameRate = config.frameRate
        ..minBitrate = config.minBitrate
        ..minFrameRate = config.minFrameRate
        ..videoProfile = config.videoProfile);
      return reply.value;
    } else {
      return Future.value(-1);
    }
  }

  /// 关闭辅流形式的屏幕共享
  Future<int> stopScreenCapture() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      IntValue reply = await _api.stopScreenCapture();
      return reply.value;
    } else {
      return Future.value(-1);
    }
  }

  /// 订阅或取消订阅指定远端用户的视频流
  Future<int> subscribeRemoteVideo(
      int uid, int streamType, bool subscribe) async {
    assert(uid != null);
    assert(streamType != null);
    assert(subscribe != null);
    IntValue reply =
        await _api.subscribeRemoteVideo(SubscribeRemoteVideoRequest()
          ..uid = uid
          ..streamType = streamType
          ..subscribe = subscribe);
    return reply.value;
  }

  /// 订阅或取消订阅别人的辅流视频
  ///
  /// [uid] userID
  /// [subscribe] 是否订阅
  Future<int> subscribeRemoteSubStreamVideo(int uid, bool subscribe) async {
    assert(uid != null);
    assert(subscribe != null);
    IntValue reply = await _api
        .subscribeRemoteSubStreamVideo(SubscribeRemoteSubStreamVideoRequest()
          ..uid = uid
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

  /// 是否开启双流模式
  ///
  /// [enable] - true:开启小流（默认），false: 关闭小流
  Future<int> enableDualStreamMode(bool enable) async {
    IntValue reply =
        await _api.enableDualStreamMode(BoolValue()..value = enable);
    return reply.value;
  }

  /// 添加房间推流任务，成功添加后当前用户可以收到该直播流的状态通知。通话中有效。
  /// [taskInfo] 直播任务信息
  /// [AddLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> addLiveStreamTask(
      NERtcLiveStreamTaskInfo taskInfo, AddLiveTaskCallback callback) async {
    assert(taskInfo != null);
    int serial = -1;
    if (callback != null) {
      serial = _onceEventHandler.addOnceCallback((args) {
        callback(args['taskId'], args['errCode']);
      });
    }
    List<Map<dynamic, dynamic>> userTranscodingList =
        taskInfo?.layout?.userTranscodingList?.map((e) => e._toMap())?.toList();
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
    return reply.value;
  }

  /// 更新修改房间推流任务。通话中有效。
  /// [taskInfo] 直播任务信息
  /// [UpdateLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> updateLiveStreamTask(
      NERtcLiveStreamTaskInfo taskInfo, UpdateLiveTaskCallback callback) async {
    assert(taskInfo != null);
    int serial = -1;
    if (callback != null) {
      serial = _onceEventHandler.addOnceCallback((args) {
        callback(args['taskId'], args['errCode']);
      });
    }
    List<Map<dynamic, dynamic>> userTranscodingList =
        taskInfo?.layout?.userTranscodingList?.map((e) => e._toMap())?.toList();
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
    return reply.value;
  }

  /// 删除房间推流任务。通话中有效
  ///
  /// [taskId]   直播任务id
  /// [DeleteLiveTaskCallback]  操作结果回调，方法调用成功才有回调
  Future<int> removeLiveStreamTask(
      String taskId, DeleteLiveTaskCallback callback) async {
    assert(taskId != null);
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
    return reply.value;
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
    return reply.value;
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
    return reply.value;
  }

  /// 设置用户角色
  /// 在加入频道前或在频道中，用户可以通过setClientRole 接口设置本端模式为观众或主播模式。
  /// [role] 用户角色.  [NERtcClientRole]
  Future<int> setClientRole(int role) async {
    IntValue reply = await _api.setClientRole(IntValue()..value = role);
    return reply.value;
  }

  /// 获取连接状态
  ///
  /// 状态参考 [NERtcConnectionState]
  Future<int> getConnectionState() async {
    IntValue reply = await _api.getConnectionState();
    return reply.value;
  }

  /// 上传SDK日志信息
  /// 只能在加入频道后调用
  Future<int> uploadSdkInfo() async {
    IntValue reply = await _api.uploadSdkInfo();
    return reply.value;
  }

  Future<dynamic> _handleCallbacks(MethodCall call) async {
    bool handled = _onceEventHandler.handler(call) ||
        _channelEventHandler.handler(call) ||
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
