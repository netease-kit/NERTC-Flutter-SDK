// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcEngineImpl extends NERtcEngine
    with
        _SDKLoggerMixin,
        LoggingApi,
        NERtcChannelEventSink,
        NERtcDeviceEventSink,
        NERtcAudioEffectEventSink,
        NERtcAudioMixingEventSink,
        NERtcStatsEventSink,
        NERtcLiveStreamEventSink {
  late _NERtcDeviceManagerImpl _deviceManager = _NERtcDeviceManagerImpl();
  final _NERtcAudioEffectMgrImpl _audioEffectMgr = _NERtcAudioEffectMgrImpl();
  final _NERtcAudioMixingMgrImpl _audioMixingMgr = _NERtcAudioMixingMgrImpl();
  late _NERtcDesktopScreenCaptureImpl _desktopScreenCapture =
      _NERtcDesktopScreenCaptureImpl();
  final _rtcStatsPlatform = NERtcStatsPlatform.instance;
  final _devicePlatform = NERtcDevicePlatform.instance;
  final _audioEffectPlatform = NERtcAudioEffectPlatform.instance;
  final _audioMixingPlatform = NERtcAudioMixingPlatform.instance;
  final _liveTaskPlatform = NERtcLiveStreamPlatform.instance;

  /// 获取设备管理模块
  NERtcDeviceManager get deviceManager => _deviceManager;
  NERtcAudioEffectManager get audioEffectManager => _audioEffectMgr;
  NERtcAudioMixingManager get audioMixingManager => _audioMixingMgr;
  NERtcDesktopScreenCapture get desktopScreenCapture => _desktopScreenCapture;

  final _eventCallbacks = <NERtcChannelEventCallback>{};
  final _statsCallbacks = <NERtcStatsEventCallback>{};
  final _liveTaskCallback = <NERtcLiveTaskCallback>{};
  final _platform = NERtcEnginePlatform.instance;

  final Map<String, NERtcChannel> _channelMaps = {};

  _NERtcEngineImpl() {}

  VoidCallback? onDispose;

  @override
  String get logTag => 'EngineApi';

  Future<int> create(
      {required String appKey,
      required NERtcChannelEventCallback channelEventCallback,
      NERtcOptions? options}) async {
    await _LogService().init(appKey, options?.logLevel, options?.logDir);
    apiLogger
        .i('createEngine#arg: appKey:$appKey, options:${options.toString()}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('createEngine', _platform.create(appKey, options));
      if (reply == 0) {
        _initialized = true;
        _platform.addRtcChannelListener(this);
        _rtcStatsPlatform.registerStatsListener(this);
        _devicePlatform.addRtcDeviceListener(this);
        _audioEffectPlatform.addRtcAudioEffectListener(this);
        _audioMixingPlatform.addRtcAudioMixingListener(this);
        _liveTaskPlatform.registerLiveStreamListener(this);
        setEventCallback(channelEventCallback);
      }
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineInitial,
          {'appKey': appKey, 'options': options?.toJson()});
      if (reply == 0) {
        _initialized = true;
        InitializedDartApiDL_();
        RegisterNERtcEventSink(this);
        RegisterAudioMixingSink(this);
        RegisterAudioEffectSink(this);
        setEventCallback(channelEventCallback);
      }
      return reply;
    }
  }

  Future<NERtcChannel> createChannel(String channelName) async {
    if (_channelMaps.containsKey(channelName)) {
      return _channelMaps[channelName]!;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      await _platform.createChannel(channelName);
    } else {
      final reply = await Invoke_(
          InvokeMethod.kNERtcEngineCreateChannel, {"channelName": channelName});
      apiLogger.e("createChannel reply: ${reply}");
    }

    final channel = _NERtcChannelImpl(channelName);
    _channelMaps[channelName] = channel;
    return channel;
  }

  Future<NERtcVersion> version() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await wrapper('version', _platform.version());
    } else {
      final version = InvokeMethod1_(jsonEncode({
        "method": InvokeMethod.kNERtcEngineVersion,
      }));
      NERtcVersion nertcVersion = new NERtcVersion(versionName: version);
      return nertcVersion;
    }
  }

  Future<List<String?>?> checkPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await wrapper('checkPermission', _platform.checkPermission());
    } else {
      return <String?>[];
    }
  }

  Future<int> setParameters(NERtcParameters params) async {
    Map<String, Object> parameters = Map<String, Object>();
    parameters = params._parameters;
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setParameters', _platform.setParameters(parameters), parameters);
      return reply;
    } else {
      parameters['method'] = InvokeMethod.kNERtcEngineSetParameters;
      final json = jsonEncode(parameters);
      int reply = InvokeMethod_(json);
      return reply;
    }
  }

  void setEventCallback(NERtcChannelEventCallback callback) {
    _eventCallbacks.add(callback);
  }

  void removeEventCallback(NERtcChannelEventCallback callback) {
    _eventCallbacks.remove(callback);
  }

  void setStatsEventCallback(NERtcStatsEventCallback callback) {
    _statsCallbacks.add(callback);
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.setStatsEventCallback();
    } else {
      RegisterMediaStatsSink(this);
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetMediaStatsObserver,
        "register": true
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
    apiLogger.i('setStatsEventCallback');
  }

  void removeStatsEventCallback(NERtcStatsEventCallback callback) {
    _statsCallbacks.remove(callback);
    if (Platform.isMacOS || Platform.isWindows) {
      RegisterMediaStatsSink(null);
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetMediaStatsObserver,
        "register": false
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
  }

  void setLiveTaskEventCallback(NERtcLiveTaskCallback callback) {
    _liveTaskCallback.add(callback);
  }

  void removeLiveTaskEventCallback(NERtcLiveTaskCallback callback) {
    _liveTaskCallback.remove(callback);
  }

  void dispose() {
    commonLogger.i('dispose');
    _eventCallbacks.clear();
    _statsCallbacks.clear();
    _liveTaskCallback.clear();

    _platform.removeRtcChannelListener(this);
    _rtcStatsPlatform.unregisterStatsListener(this);
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.clearStatsEventCallback();
    } else {
      ClearChannelEventSinkMaps();
      RegisterNERtcEventSink(null);
      RegisterAudioEffectSink(null);
      RegisterAudioMixingSink(null);
      RegisterMediaStatsSink(null);
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetMediaStatsObserver,
        "register": false
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
    _liveTaskPlatform.unregisterLiveStreamListener(this);
    _devicePlatform.removeRtcDeviceListener(this);
    _audioEffectPlatform.removeRtcAudioEffectListener(this);
    _audioMixingPlatform.removeRtcAudioMixingListener(this);

    onDispose?.call();
    onDispose = null;
  }

  @override
  void onJoinChannel(int result, int channelID, int elapsed, int uid) {
    commonLogger.i(
        'onJoinChannel: result:$result,channelId:$channelID,elapsed:$elapsed,uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onJoinChannel(result, channelID, elapsed, uid);
    }
  }

  @override
  void onLeaveChannel(int result) {
    commonLogger.i('onLeaveChannel: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLeaveChannel(result);
    }
  }

  @override
  void onUserJoined(UserJoinedEvent event) {
    if (!_initialized) return;
    final uid = event.uid;
    final joinExtraInfo = event.joinExtraInfo;
    commonLogger.i(
        'onUserJoined: uid:$uid,joinExtraInfo: {customInfo:${joinExtraInfo?.customInfo}}');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserJoined(uid, joinExtraInfo);
    }
  }

  @override
  void onUserLeave(UserLeaveEvent event) {
    if (!_initialized) return;
    final uid = event.uid;
    final reason = event.reason;
    final leaveExtraInfo = event.leaveExtraInfo;
    commonLogger.i(
        'onUserLeave: uid:$uid,reason:$reason,leaveExtraInfo:{customInfo:${leaveExtraInfo?.customInfo}}');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserLeave(uid, reason, leaveExtraInfo);
    }
  }

  @override
  void onDisconnect(int reason) {
    if (!_initialized) return;
    commonLogger.i('onDisconnect: reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onDisconnect(reason);
    }
  }

  @override
  void onUserAudioStart(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserAudioStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioStart(uid);
    }
  }

  @override
  void onUserAudioStop(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserAudioStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioStop(uid);
    }
  }

  @override
  void onUserSubStreamAudioStart(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserSubStreamAudioStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioStart(uid);
    }
  }

  @override
  void onUserSubStreamAudioStop(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserSubStreamAudioStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioStop(uid);
    }
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    if (!_initialized) return;
    commonLogger.i('onUserVideoStart: uid:$uid, maxProfile: $maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoStart(uid, maxProfile);
    }
  }

  @override
  void onUserVideoStop(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserVideoStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoStop(uid);
    }
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    if (!_initialized) return;
    commonLogger.i('onUserAudioMute: uid:$uid, muted:$muted');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioMute(uid, muted);
    }
  }

  @override
  void onUserVideoMute(UserVideoMuteEvent event) {
    if (!_initialized) return;
    final uid = event.uid;
    final muted = event.muted;
    final streamType = event.streamType;
    commonLogger
        .i('onUserVideoMute: uid:$uid, muted:$muted, streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoMute(uid, muted, streamType);
    }
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    if (!_initialized) return;
    commonLogger.i('onFirstAudioDataReceived: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstAudioDataReceived(uid);
    }
  }

  @override
  void onFirstAudioFrameDecoded(int uid) {
    if (!_initialized) return;
    commonLogger.i('onFirstAudioFrameDecoded: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstAudioFrameDecoded(uid);
    }
  }

  @override
  void onFirstVideoDataReceived(FirstVideoDataReceivedEvent event) {
    if (!_initialized) return;
    final uid = event.uid;
    final streamType = event.streamType;
    commonLogger
        .i('onFirstVideoDataReceived: uid :$uid,streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoDataReceived(uid, streamType);
    }
  }

  @override
  void onFirstVideoFrameDecoded(FirstVideoFrameDecodedEvent event) {
    if (!_initialized) return;
    final uid = event.uid;
    final width = event.width;
    final height = event.height;
    final streamType = event.streamType;
    commonLogger.i(
        'onFirstVideoFrameDecoded: uid:$uid,width:$width,height:$height,streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoFrameDecoded(uid, width, height, streamType);
    }
  }

  @override
  void onUserSubStreamAudioMute(int uid, bool muted) {
    if (!_initialized) return;
    commonLogger.i('onUserSubStreamAudioMute: uid:$uid,muted:$muted');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioMute(uid, muted);
    }
  }

  @override
  void onVirtualBackgroundSourceEnabled(
      VirtualBackgroundSourceEnabledEvent event) {
    if (!_initialized) return;
    final enabled = event.enabled;
    final reason = event.reason;
    commonLogger
        .i('onVirtualBackgroundSourceEnabled: enabled:$enabled,reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onVirtualBackgroundSourceEnabled(enabled, reason);
    }
  }

  @override
  void onConnectionTypeChanged(int newConnectionType) {
    if (!_initialized) return;
    commonLogger
        .i('onConnectionTypeChanged: newConnectionType:$newConnectionType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onConnectionTypeChanged(newConnectionType);
    }
  }

  @override
  void onReconnectingStart() {
    if (!_initialized) return;
    commonLogger.i('onReconnectingStart');
    for (var callback in _eventCallbacks.copy()) {
      callback.onReconnectingStart();
    }
  }

  @override
  void onReJoinChannel(int result, int channelId) {
    if (!_initialized) return;
    commonLogger.i('onReJoinChannel: result:$result, channelId:$channelId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onReJoinChannel(result, channelId);
    }
  }

  @override
  void onConnectionStateChanged(int state, int reason) {
    if (!_initialized) return;
    commonLogger.i('onConnectionStateChanged: state:$state, reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onConnectionStateChanged(state, reason);
    }
  }

  @override
  void onLocalAudioVolumeIndication(int volume, bool vadFlag) {
    if (!_initialized) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalAudioVolumeIndication(volume, vadFlag);
    }
  }

  @override
  void onRemoteAudioVolumeIndication(RemoteAudioVolumeIndicationEvent event) {
    if (!_initialized || event.volumeList == null) return;
    final volumeList = event.volumeList!
        .where((element) => element != null)
        .map((e) => NERtcAudioVolumeInfo(e!.uid, e.volume, e.subStreamVolume))
        .toList();
    final totalVolume = event.totalVolume;

    for (var callback in _eventCallbacks.copy()) {
      callback.onRemoteAudioVolumeIndication(volumeList, totalVolume);
    }
  }

  @override
  void onClientRoleChange(int oldRole, int newRole) {
    if (!_initialized) return;
    commonLogger.i('onClientRoleChange: oldRole:$oldRole, newRole:$newRole');
    for (var callback in _eventCallbacks.copy()) {
      callback.onClientRoleChange(oldRole, newRole);
    }
  }

  @override
  void onError(int code) {
    if (!_initialized) return;
    commonLogger.i('onError: code:$code');
    for (var callback in _eventCallbacks.copy()) {
      callback.onError(code);
    }
  }

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {
    if (!_initialized) return;
    commonLogger.i(
        'onLiveStreamState: taskId:$taskId, pushUrl:$pushUrl, liveState:$liveState');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLiveStreamState(taskId, pushUrl, liveState);
    }
  }

  @override
  void onWarning(int code) {
    if (!_initialized) return;
    commonLogger.i('onWarning: code:$code');
    for (var callback in _eventCallbacks.copy()) {
      callback.onWarning(code);
    }
  }

  @override
  void onAudioHasHowling() {
    if (!_initialized) return;
    commonLogger.i('onAudioHasHowling');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioHasHowling();
    }
  }

  @override
  void onUserSubStreamVideoStart(int uid, int maxProfile) {
    if (!_initialized) return;
    commonLogger
        .i('onUserSubStreamVideoStart: uid:$uid, maxProfile:$maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamVideoStart(uid, maxProfile);
    }
  }

  @override
  void onUserSubStreamVideoStop(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserSubStreamVideoStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamVideoStop(uid);
    }
  }

  @override
  void onRecvSEIMsg(int userID, String seiMsg) {
    if (!_initialized) return;
    commonLogger.i('onRecvSEIMsg: userID:$userID, seiMsg:$seiMsg');
    for (var callback in _eventCallbacks.copy()) {
      callback.onRecvSEIMsg(userID, seiMsg);
    }
  }

  @override
  void onAudioRecording(int code, String filePath) {
    if (!_initialized) return;
    commonLogger.i('onAudioRecording: code:$code, filePath:$filePath');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioRecording(code, filePath);
    }
  }

  @override
  void onMediaRelayStatesChange(int state, String channelName) {
    if (!_initialized) return;
    commonLogger
        .i('onMediaRelayStatesChange: state:$state, channelName:$channelName');
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRelayStatesChange(state, channelName);
    }
  }

  @override
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {
    if (!_initialized) return;
    commonLogger.i(
        'onLocalPublishFallbackToAudioOnly: isFallback:$isFallback, streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalPublishFallbackToAudioOnly(isFallback, streamType);
    }
  }

  @override
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {
    if (!_initialized) return;
    commonLogger.i(
        'onMediaRelayReceiveEvent: event:$event, code:$code,channelName:$channelName');
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRelayReceiveEvent(event, code, channelName);
    }
  }

  @override
  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType) {
    if (!_initialized) return;
    commonLogger.i(
        'onRemoteSubscribeFallbackToAudioOnly: uid:$uid, isFallback:$isFallback,streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onRemoteSubscribeFallbackToAudioOnly(
          uid, isFallback, streamType);
    }
  }

  @override
  void onLocalVideoWatermarkState(int videoStreamType, int state) {
    if (!_initialized) return;
    commonLogger.i(
        'onLocalVideoWatermarkState: videoStreamType:$videoStreamType, state:$state');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalVideoWatermarkState(videoStreamType, state);
    }
  }

  @override
  void onAudioDeviceChanged(int selected) {
    if (!_initialized) return;
    commonLogger.i('onAudioDeviceChanged: selected:$selected');
    _deviceManager.deviceEventCallbacks.forEach((element) {
      element.onAudioDeviceChanged(selected);
    });
  }

  @override
  void onAudioDeviceStateChange(int deviceType, int deviceState) {
    if (!_initialized) return;
    commonLogger.i(
        'onAudioDeviceStateChange: deviceType:$deviceType, deviceState:$deviceState');
    _deviceManager.deviceEventCallbacks.forEach((element) {
      element.onAudioDeviceStateChange(deviceType, deviceState);
    });
  }

  @override
  void onVideoDeviceStateChange(int deviceType, int deviceState) {
    if (!_initialized) return;
    commonLogger.i('onVideoDeviceStateChange: deviceState:$deviceState');
    _deviceManager.deviceEventCallbacks.forEach((element) {
      element.onVideoDeviceStateChange(deviceType, deviceState);
    });
  }

  @override
  void onCameraExposureChanged(CGPoint exposurePoint) {
    if (!_initialized) return;
    _deviceManager.deviceEventCallbacks.forEach((element) {
      element.onCameraExposureChanged(exposurePoint);
    });
  }

  @override
  void onCameraFocusChanged(CGPoint focusPoint) {
    if (!_initialized) return;
    commonLogger.i('onCameraFocusChanged: focusPoint:$focusPoint');
    _deviceManager.deviceEventCallbacks.forEach((element) {
      element.onCameraFocusChanged(focusPoint);
    });
  }

  @override
  void onAiData(String type, String data) {
    if (!_initialized) return;
    commonLogger.i('onAiData: type:$type, data:$data');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAiData(type, data);
    }
  }

  @override
  void onApiCallExecuted(String apiName, int result, String message) {
    if (!_initialized) return;
    commonLogger.i(
        'onApiCallExecuted: apiName:$apiName, result:$result, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onApiCallExecuted(apiName, result, message);
    }
  }

  @override
  void onAsrCaptionResult(
      List<Map<Object?, Object?>?> result, int resultCount) {
    if (!_initialized) return;
    commonLogger.i('onAsrCaptionResult: resultCount:$resultCount');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAsrCaptionResult(result, resultCount);
    }
  }

  @override
  void onAsrCaptionStateChanged(int asrState, int code, String message) {
    if (!_initialized) return;
    commonLogger.i(
        'onAsrCaptionStateChanged: asrState:$asrState, code:$code, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAsrCaptionStateChanged(asrState, code, message);
    }
  }

  @override
  void onCheckNECastAudioDriverResult(int result) {
    if (!_initialized) return;
    commonLogger.i('onCheckNECastAudioDriverResult: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onCheckNECastAudioDriverResult(result);
    }
  }

  @override
  void onFirstVideoFrameRender(
      int userID, int streamType, int width, int height, int elapsedTime) {
    if (!_initialized) return;
    commonLogger.i(
        'onFirstVideoFrameRender: userID:$userID, streamType:$streamType, width:$width, height:$height, elapsedTime:$elapsedTime');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoFrameRender(
          userID, streamType, width, height, elapsedTime);
    }
  }

  @override
  void onLabFeatureCallback(String key, Map<Object?, Object?> param) {
    if (!_initialized) return;
    commonLogger.i('onLabFeatureCallback: key:$key');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLabFeatureCallback(key, param);
    }
  }

  @override
  void onLocalAudioFirstPacketSent(int audioStreamType) {
    if (!_initialized) return;
    commonLogger
        .i('onLocalAudioFirstPacketSent: audioStreamType:$audioStreamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalAudioFirstPacketSent(audioStreamType);
    }
  }

  @override
  void onLocalRecorderError(int error, String taskId) {
    if (!_initialized) return;
    commonLogger.i('onLocalRecorderError: error:$error, taskId:$taskId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalRecorderError(error, taskId);
    }
  }

  @override
  void onLocalRecorderStatus(int status, String taskId) {
    if (!_initialized) return;
    commonLogger.i('onLocalRecorderStatus: status:$status, taskId:$taskId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalRecorderStatus(status, taskId);
    }
  }

  @override
  void onLocalVideoRenderSizeChanged(int videoType, int width, int height) {
    if (!_initialized) return;
    commonLogger.i(
        'onLocalVideoRenderSizeChanged: videoType:$videoType, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalVideoRenderSizeChanged(videoType, width, height);
    }
  }

  @override
  void onPlayStreamingFirstAudioFramePlayed(String streamId, int timeMs) {
    if (!_initialized) return;
    commonLogger.i(
        'onPlayStreamingFirstAudioFramePlayed: streamId:$streamId, timeMs:$timeMs');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingFirstAudioFramePlayed(streamId, timeMs);
    }
  }

  @override
  void onPlayStreamingFirstVideoFrameRender(
      String streamId, int timeMs, int width, int height) {
    if (!_initialized) return;
    commonLogger.i(
        'onPlayStreamingFirstVideoFrameRender: streamId:$streamId, timeMs:$timeMs, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingFirstVideoFrameRender(
          streamId, timeMs, width, height);
    }
  }

  @override
  void onPlayStreamingReceiveSeiMessage(String streamId, String message) {
    if (!_initialized) return;
    commonLogger.i(
        'onPlayStreamingReceiveSeiMessage: streamId:$streamId, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingReceiveSeiMessage(streamId, message);
    }
  }

  @override
  void onPlayStreamingStateChange(String streamId, int state, int reason) {
    if (!_initialized) return;
    commonLogger.i(
        'onPlayStreamingStateChange: streamId:$streamId, state:$state, reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingStateChange(streamId, state, reason);
    }
  }

  @override
  void onPushStreamingReconnectedSuccess() {
    if (!_initialized) return;
    commonLogger.i('onPushStreamingReconnectedSuccess');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPushStreamingReconnectedSuccess();
    }
  }

  @override
  void onPushStreamingReconnecting(int reason) {
    if (!_initialized) return;
    commonLogger.i('onPushStreamingReconnecting: reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPushStreamingReconnecting(reason);
    }
  }

  @override
  void onReleasedHwResources(int result) {
    if (!_initialized) return;
    commonLogger.i('onReleasedHwResources: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onReleasedHwResources(result);
    }
  }

  @override
  void onRemoteVideoSizeChanged(
      int userId, int videoType, int width, int height) {
    if (!_initialized) return;
    commonLogger.i(
        'onRemoteVideoSizeChanged: userId:$userId, videoType:$videoType, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onRemoteVideoSizeChanged(userId, videoType, width, height);
    }
  }

  @override
  void onScreenCaptureSourceDataUpdate(ScreenCaptureSourceData data) {
    if (!_initialized) return;
    commonLogger.i(
        'onScreenCaptureSourceDataUpdate: sourceId:${data.sourceId}, status:${data.status}');
    // 转换 ScreenCaptureSourceData 到 NERtcScreenCaptureSourceData
    // 根据 @JsonValue 映射类型：-1=kUnknown, 0=kWindow, 1=kScreen, 2=kCustom
    NERtcScreenCaptureSourceType sourceType;
    switch (data.type) {
      case -1:
        sourceType = NERtcScreenCaptureSourceType.kUnknown;
        break;
      case 0:
        sourceType = NERtcScreenCaptureSourceType.kWindow;
        break;
      case 1:
        sourceType = NERtcScreenCaptureSourceType.kScreen;
        break;
      case 2:
        sourceType = NERtcScreenCaptureSourceType.kCustom;
        break;
      default:
        sourceType = NERtcScreenCaptureSourceType.kUnknown;
        break;
    }
    final nertcData = NERtcScreenCaptureSourceData(
      type: sourceType,
      sourceId: data.sourceId,
      status: data.status,
      action: data.action,
      captureRect: NERtcRectangle(
        x: data.captureRect.x,
        y: data.captureRect.y,
        width: data.captureRect.width,
        height: data.captureRect.height,
      ),
      level: data.level,
    );
    for (var callback in _eventCallbacks.copy()) {
      callback.onScreenCaptureSourceDataUpdate(nertcData);
    }
  }

  @override
  void onScreenCaptureStatus(int status) {
    if (!_initialized) return;
    commonLogger.i('onScreenCaptureStatus: status:$status');
    for (var callback in _eventCallbacks.copy()) {
      callback.onScreenCaptureStatus(status);
    }
  }

  @override
  void onStartPushStreaming(int result, int channelId) {
    if (!_initialized) return;
    commonLogger
        .i('onStartPushStreaming: result:$result, channelId:$channelId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onStartPushStreaming(result, channelId);
    }
  }

  @override
  void onStopPushStreaming(int result) {
    if (!_initialized) return;
    commonLogger.i('onStopPushStreaming: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onStopPushStreaming(result);
    }
  }

  @override
  void onUserDataBufferedAmountChanged(int uid, int previousAmount) {
    if (!_initialized) return;
    commonLogger.i(
        'onUserDataBufferedAmountChanged: uid:$uid, previousAmount:$previousAmount');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataBufferedAmountChanged(uid, previousAmount);
    }
  }

  @override
  void onUserDataReceiveMessage(int uid, Uint8List bufferData, int bufferSize) {
    if (!_initialized) return;
    commonLogger
        .i('onUserDataReceiveMessage: uid:$uid, bufferSize:$bufferSize');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataReceiveMessage(uid, bufferData, bufferSize);
    }
  }

  @override
  void onUserDataStart(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserDataStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStart(uid);
    }
  }

  @override
  void onUserDataStateChanged(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserDataStateChanged: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStateChanged(uid);
    }
  }

  @override
  void onUserDataStop(int uid) {
    if (!_initialized) return;
    commonLogger.i('onUserDataStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStop(uid);
    }
  }

  @override
  void onUserVideoProfileUpdate(int uid, int maxProfile) {
    if (!_initialized) return;
    commonLogger
        .i('onUserVideoProfileUpdate: uid:$uid, maxProfile:$maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoProfileUpdate(uid, maxProfile);
    }
  }

  @override
  Future<int> release() async {
    _initialized = false;
    dispose();
    _channelMaps.clear();
    if (Platform.isAndroid || Platform.isIOS) {
      return wrapper('release', _platform.release());
    } else {
      Map<String, dynamic> wrapperJson = {
        "method": InvokeMethod.kNERtcEngineRelease
      };
      int reply = InvokeMethod_(jsonEncode(wrapperJson));
      return reply;
    }
  }

  @override
  Future<int> joinChannel(String? token, String channelName, int uid,
      [NERtcJoinChannelOptions? channelOptions]) async {
    apiLogger.i(
        'joinChannel#arg{token:$token,:channelName:$channelName,uid:$uid,channelOptions:${channelOptions.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('joinChannel',
          _platform.joinChannel(token, channelName, uid, channelOptions));
      return reply;
    } else {
      Map<String, dynamic> wrapperJson = {
        'method': InvokeMethod.kNERtcEngineJoinChannel,
        'token': token,
        'channelName': channelName,
        'uid': uid,
        'channelOptions': channelOptions?.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(wrapperJson));
      return reply;
    }
  }

  @override
  Future<int> leaveChannel() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('leaveChannel', _platform.leaveChannel());
      return reply;
    } else {
      Map<String, dynamic> wrapperJson = {
        "method": InvokeMethod.kNERtcEngineLeaveChannel
      };
      int reply = InvokeMethod_(jsonEncode(wrapperJson));
      return reply;
    }
  }

  @override
  Future<int> updatePermissionKey(String key) async {
    apiLogger.i('updatePermissionKey#arg{key:$key}');
    int reply = await wrapper(
        'updatePermissionKey', _platform.updatePermissionKey(key));
    return reply;
  }

  @override
  Future<int> enableLocalAudio(bool enable) async {
    apiLogger.i('enableLocalAudio#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('enableLocalAudio', _platform.enableLocalAudio(enable));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableLocalAudio,
        "enable": enable,
        "streamType": 0
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteAudio(int uid, bool subscribe) async {
    apiLogger.i('subscribeRemoteAudio#arg{uid:$uid,subscribe:$subscribe}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('subscribeRemoteAudio',
          _platform.subscribeRemoteAudio(uid, subscribe));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSubscribeRemoteAudioStream,
        "uid": uid,
        "subscribe": subscribe
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> subscribeAllRemoteAudio(bool subscribe) async {
    apiLogger.i('subscribeAllRemoteAudio#arg{subscribe:$subscribe}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('subscribeAllRemoteAudio',
          _platform.subscribeAllRemoteAudio(subscribe));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSubscribeAllRemoteAudioStream,
        "subscribe": subscribe
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> enableLocalVideo(bool enable,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i('enableLocalVideo#arg{enable:$enable,streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableLocalVideo', _platform.enableLocalVideo(enable, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableLocalVideo,
        "enable": enable,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> muteLocalAudioStream(bool mute) async {
    apiLogger.i('muteLocalAudioStream#arg{mute:$mute}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'muteLocalAudioStream', _platform.muteLocalAudioStream(mute));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineMuteLocalAudio,
        "mute": mute,
        "streamType": 0
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> muteLocalVideoStream(bool mute,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i('muteLocalVideoStream#arg{mute:$mute,streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('muteLocalVideoStream',
          _platform.muteLocalVideoStream(mute, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineMuteLocalVideo,
        "mute": mute,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> muteLocalSubStreamAudio(bool muted) async {
    apiLogger.i('muteLocalSubStreamAudio#arg{muted:$muted}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'muteLocalSubStreamAudio', _platform.muteLocalSubStreamAudio(muted));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineMuteLocalAudio,
        "mute": muted,
        "streamType": 1
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> enableLocalSubStreamAudio(bool enable) async {
    apiLogger.i('enableLocalSubStreamAudio#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('enableLocalSubStreamAudio',
          _platform.enableLocalSubStreamAudio(enable));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableLocalAudio,
        "enable": enable,
        "streamType": 1
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setAudioProfile(
      NERtcAudioProfile profile, NERtcAudioScenario scenario) async {
    apiLogger.i('setAudioProfile#arg{profile:$profile,scenario:$scenario}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioProfile', _platform.setAudioProfile(profile, scenario));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetAudioProfile,
        "profile": profile.index,
        "scenario": scenario.index
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setCameraCaptureConfig(NERtcCameraCaptureConfig captureConfig,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i(
        'setCameraCaptureConfig#arg{captureConfig:${captureConfig.toString()},streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setCameraCaptureConfig',
          _platform.setCameraCaptureConfig(captureConfig, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetCaptureConfig,
        "captureConfig": captureConfig.toJson(),
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i(
        'setLocalVideoConfig#arg{videoConfig:${videoConfig.toString()},streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalVideoConfig',
          _platform.setLocalVideoConfig(videoConfig, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetLocalVideoConfig,
        "config": videoConfig.toJson(),
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setVideoRotationMode(
      [int rotationMode =
          NERtcVideoRotationMode.NERtcVideoRotationModeBySystem]) async {
    if (Platform.isIOS) {
      apiLogger.i('setVideoRotationMode rotationMode:$rotationMode');
      int reply = await wrapper(
          'setVideoRotationMode', _platform.setVideoRotationMode(rotationMode));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> startVideoPreview(
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i('startVideoPreview#arg{streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startVideoPreview', _platform.startVideoPreview(streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartPreview,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopVideoPreview(
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i('stopVideoPreview#arg{streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'stopVideoPreview', _platform.stopVideoPreview(streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopPreview,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startScreenCapture(NERtcScreenConfig config) async {
    apiLogger.i('startScreenCapture#arg{config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startScreenCapture', _platform.startScreenCapture(config));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> stopScreenCapture() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('stopScreenCapture', _platform.stopScreenCapture());
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> checkNECastAudioDriver() async {
    if (Platform.isMacOS) {
      return Invoke_(InvokeMethod.kNERtcCheckNeCastAudioDriver, null);
    } else {
      return 30004; //not support.
    }
  }

  @override
  Future<int> enableLoopbackRecording(bool enable,
      {String deviceName = ""}) async {
    apiLogger.i('enableLoopbackRecording#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableLoopbackRecording', _platform.enableLoopbackRecording(enable));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEnableLoopbackRecording,
          {"enable": enable, "deviceName": deviceName});
    }
  }

  @override
  Future<int> subscribeRemoteSubStreamVideo(int uid, bool subscribe) async {
    apiLogger
        .i('subscribeRemoteSubStreamVideo#arg{uid:$uid,subscribe:$subscribe}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('subscribeRemoteSubStreamVideo',
          _platform.subscribeRemoteSubStreamVideo(uid, subscribe));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSubscribeRemoteSubVideoStream,
        "uid": uid,
        "subscribe": subscribe
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteVideoStream(
      int uid, int streamType, bool subscribe) async {
    apiLogger.i(
        'subscribeRemoteVideoStream#arg{uid:$uid,streamType:$streamType,subscribe:$subscribe}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('subscribeRemoteVideoStream',
          _platform.subscribeRemoteVideoStream(uid, streamType, subscribe));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSubscribeRemoteVideoStream,
        "uid": uid,
        "streamType": streamType,
        "subscribe": subscribe
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> enableAudioVolumeIndication(bool enable, int interval,
      {bool vad = false}) async {
    apiLogger.i(
        'enableAudioVolumeIndication#arg{enable:$enable,interval:$interval,vad:$vad}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('enableAudioVolumeIndication',
          _platform.enableAudioVolumeIndication(enable, interval, vad));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableAudioVolumeIndication,
        "enable": enable,
        "interval": interval,
        "vad": vad
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startAudioDump() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('startAudioDump', _platform.startAudioDump());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartAudioDump,
        "type": 2
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopAudioDump() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('stopAudioDump', _platform.stopAudioDump());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopAudioDump
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> enableDualStreamMode(bool enable) async {
    apiLogger.i('enableDualStreamMode#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableDualStreamMode', _platform.enableDualStreamMode(enable));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableDualStreamMode,
        "enable": enable
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setChannelProfile(int channelProfile) async {
    apiLogger.i('setChannelProfile#arg{channelProfile:$channelProfile}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setChannelProfile', _platform.setChannelProfile(channelProfile));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetChannelProfile,
        "profile": channelProfile
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> addLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo) async {
    apiLogger.i('addLiveStreamTask#arg{taskInfo:${taskInfo.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'addLiveStreamTask', _platform.addLiveStreamTask(taskInfo));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineAddLiveStreamTaskInfo,
        "taskInfo": taskInfo.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> updateLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo) async {
    apiLogger.i('updateLiveStreamTask#arg{taskInfo:${taskInfo.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'updateLiveStreamTask', _platform.updateLiveStreamTask(taskInfo));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineUpdateLiveStreamTaskInfo,
        "taskInfo": taskInfo.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> removeLiveStreamTask(String taskId) async {
    apiLogger.i('removeLiveStreamTask#arg{taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'removeLiveStreamTask', _platform.removeLiveStreamTask(taskId));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineRemoveLiveStreamTaskInfo,
        "taskId": taskId
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> adjustPlaybackSignalVolume(int volume) async {
    apiLogger.i('adjustPlaybackSignalVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('adjustPlaybackSignalVolume',
          _platform.adjustPlaybackSignalVolume(volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineAdjustPlaybackSignalVolume,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> adjustRecordingSignalVolume(int volume) async {
    apiLogger.i('adjustRecordingSignalVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('adjustRecordingSignalVolume',
          _platform.adjustRecordingSignalVolume(volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineAdjustRecordingSignalVolume,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> adjustLoopBackRecordingSignalVolume(int volume) async {
    apiLogger.i('adjustLoopBackRecordingSignalVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('adjustLoopBackRecordingSignalVolume',
          _platform.adjustLoopBackRecordingSignalVolume(volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineAdjustLoopbackRecordingSignalVolume,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> getConnectionState() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('getConnectionState', _platform.getConnectionState());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineGetChannelConnection
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> sendSEIMsg(String seiMsg,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i('sendSEIMsg#arg{seiMsg:$seiMsg,streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('sendSEIMsg', _platform.sendSEIMsg(seiMsg, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSendSEIMsg,
        "seiMsg": seiMsg,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setClientRole(int role) async {
    apiLogger.i('setClientRole#arg{role:$role}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setClientRole', _platform.setClientRole(role));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetClientRole,
        "role": role
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> uploadSdkInfo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('uploadSdkInfo', _platform.uploadSdkInfo());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineUploadSdkInfo,
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setAudioEffectPreset(int preset) async {
    apiLogger.i('setAudioEffectPreset#arg{preset:$preset}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioEffectPreset', _platform.setAudioEffectPreset(preset));
      return reply;
    } else {
      return Invoke_(AudioReverbPresentMethod.kNERtcEngineSetAudioEffectPreset,
          {"preset": preset});
    }
  }

  @override
  Future<int> setLocalVoiceEqualization(int bandFrequency, int bandGain) async {
    apiLogger.i(
        'setLocalVoiceEqualization#arg{bandFrequency:$bandFrequency,bandGain:$bandGain}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalVoiceEqualization',
          _platform.setLocalVoiceEqualization(bandFrequency, bandGain));
      return reply;
    } else {
      return Invoke_(
          AudioReverbPresentMethod.kNERtcEngineSetLocalVoiceEqualization,
          {"bandFrequency": bandFrequency, "bandGain": bandGain});
    }
  }

  @override
  Future<int> setLocalVoicePitch(double pitch) async {
    apiLogger.i('setLocalVoicePitch#arg{pitch:$pitch}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setLocalVoicePitch', _platform.setLocalVoicePitch(pitch));
      return reply;
    } else {
      return Invoke_(AudioReverbPresentMethod.kNERtcEngineSetLocalVoicePitch,
          {"pitch": pitch});
    }
  }

  @override
  Future<int> setVoiceBeautifierPreset(int preset) async {
    apiLogger.i('setVoiceBeautifierPreset#arg{preset:$preset}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setVoiceBeautifierPreset',
          _platform.setVoiceBeautifierPreset(preset));
      return reply;
    } else {
      return Invoke_(
          AudioReverbPresentMethod.kNERtcEngineSetVoiceBeautifierPreset,
          {"preset": preset});
    }
  }

  @override
  Future<int> setLocalVoiceReverbParam(NERtcReverbParam param) async {
    apiLogger.i('setLocalVoiceReverbParam#arg{param:${param.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalVoiceReverbParam',
          _platform.setLocalVoiceReverbParam(param));
      return reply;
    } else {
      return Invoke_(
          AudioReverbPresentMethod.kNERtcEngineSetLocalVoiceReverbParam,
          {"param": param.toJson()});
    }
  }

  @override
  Future<int> startAudioRecording(
      String filePath, int sampleRate, int quality) async {
    apiLogger.i(
        'startAudioRecording#arg{filePath:$filePath,sampleRate:$sampleRate,quality:$quality}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('startAudioRecording',
          _platform.startAudioRecording(filePath, sampleRate, quality));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartAudioRecording,
        "filePath": filePath,
        "sampleRate": sampleRate,
        "quality": quality
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startAudioRecordingWithConfig(
      NERtcAudioRecordingConfiguration config) async {
    apiLogger
        .i('startAudioRecordingWithConfig#arg{config:${config.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('startAudioRecordingWithConfig',
          _platform.startAudioRecordingWithConfig(config));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartAudioRecordingWithConfig,
        "config": config.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopAudioRecording() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('stopAudioRecording', _platform.stopAudioRecording());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopAudioRecording
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> switchChannel(String? token, String channelName,
      {NERtcJoinChannelOptions? channelOptions}) async {
    apiLogger.i(
        'switchChannel#arg{token:$token,channelName:$channelName,channelOptions:${channelOptions.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'switchChannel',
          _platform.switchChannel(token, channelName,
              channelOptions: channelOptions ?? null));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSwitchChannel,
        "token": token,
        "channelName": channelName,
        "channelOptions": channelOptions?.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setLocalMediaPriority(int priority, bool isPreemptive) async {
    apiLogger.i(
        'setLocalMediaPriority#arg{priority:$priority,isPreemptive:$isPreemptive}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalMediaPriority',
          _platform.setLocalMediaPriority(priority, isPreemptive));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetLocalMediaPriority,
        "priority": priority,
        "isPreemptive": isPreemptive
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) async {
    apiLogger.i('startChannelMediaRelay#arg{config:${config.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startChannelMediaRelay', _platform.startChannelMediaRelay(config));
      return reply;
    } else {
      final convertJson = {
        "method": InvokeMethod.kNERtcEngineStartChannelMediaRelay,
        "config": config.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopChannelMediaRelay() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'stopChannelMediaRelay', _platform.stopChannelMediaRelay());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopChannelMediaRelay,
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> updateChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) async {
    apiLogger.i('updateChannelMediaRelay#arg{config:${config.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'updateChannelMediaRelay', _platform.updateChannelMediaRelay(config));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineUpdateChannelMediaRelay,
        "config": config.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> adjustUserPlaybackSignalVolume(int uid, int volume) async {
    apiLogger.i('adjustUserPlaybackSignalVolume#arg{uid:$uid,volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('adjustUserPlaybackSignalVolume',
          _platform.adjustUserPlaybackSignalVolume(uid, volume));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcAdjustUserPlaybackSignalVolume,
          {"uid": uid, "volume": volume});
    }
  }

  @override
  Future<int> reportCustomEvent(String eventName, String? customIdentify,
      Map<String?, Object?>? param) async {
    apiLogger.i(
        'reportCustomEvent#arg{eventName:$eventName,customIdentify:$customIdentify,param:$param}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('reportCustomEvent',
          _platform.reportCustomEvent(eventName, customIdentify, param));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineReportCustomEvent, {
        "method": InvokeMethod.kNERtcEngineReportCustomEvent,
        "eventName": eventName,
        "customIdentify": customIdentify,
        "param": param
      });
      return reply;
    }
  }

  @override
  Future<int> enableEncryption(
      bool enable, NERtcEncryptionConfig config) async {
    apiLogger
        .i('enableEncryption#arg{enable:$enable,config:${config.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableEncryption', _platform.enableEncryption(enable, config));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineEnableEncryption,
          {"enable": enable, "config": config.toJson()});
    }
  }

  @override
  Future<int> enableSuperResolution(bool enable) async {
    apiLogger.i('enableSuperResolution#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableSuperResolution', _platform.enableSuperResolution(enable));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineEnableSuperResolution, {"enable": enable});
    }
  }

  @override
  Future<int> setAudioSessionOperationRestriction(
      NERtcAudioSessionOperationRestriction restriction) async {
    apiLogger
        .i('setAudioSessionOperationRestriction#arg{restriction:$restriction}');
    int reply = await wrapper('setAudioSessionOperationRestriction',
        _platform.setAudioSessionOperationRestriction(restriction));
    return reply;
  }

  @override
  Future<int> setLocalPublishFallbackOption(int option) async {
    apiLogger.i('setLocalPublishFallbackOption#arg{option:$option}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalPublishFallbackOption',
          _platform.setLocalPublishFallbackOption(option));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetLocalPublishFallbackOption,
        "option": option
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setRemoteSubscribeFallbackOption(int option) async {
    apiLogger.i('setRemoteSubscribeFallbackOption#arg{option:$option}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setRemoteSubscribeFallbackOption',
          _platform.setRemoteSubscribeFallbackOption(option));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetRemoteSubscribeFallbackOption,
        "option": option
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> getEffectDuration(int effectId) async {
    apiLogger.i('getEffectDuration#arg{effectId:$effectId}');
    int reply = await wrapper(
        'getEffectDuration', _platform.getEffectDuration(effectId));
    return reply;
  }

  @override
  Future<int> startLastmileProbeTest(LastmileProbeConfig config) async {
    apiLogger.i('startLastmileProbeTest#arg{config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startLastmileProbeTest', _platform.startLastmileProbeTest(config));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartLastMileProbeTest,
        "config": config.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopLastmileProbeTest() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'stopLastmileProbeTest', _platform.stopLastmileProbeTest());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopLastMileProbeTest
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setVideoCorrectionConfig(
      NERtcVideoCorrectionConfiguration? config) async {
    apiLogger.i('setVideoCorrectionConfig#arg{config:$config}');
    int reply = await wrapper(
        'setVideoCorrectionConfig', _platform.setVideoCorrectionConfig(config));
    return reply;
  }

  @override
  Future<int> enableVirtualBackground(
      bool enabled, NERtcVirtualBackgroundSource? backgroundSource,
      {bool force = false}) async {
    apiLogger.i(
        'enableVirtualBackground#arg{enabled:$enabled,backgroundSource:$backgroundSource}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('enableVirtualBackground',
          _platform.enableVirtualBackground(enabled, backgroundSource));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableVirtualBackground,
        "enabled": enabled,
        "backgroundSource": backgroundSource?.toJson(),
        "force": force
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setCloudProxy(int proxyType) async {
    apiLogger.i('setCloudProxy#arg{proxyType:$proxyType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('setCloudProxy', _platform.setCloudProxy(proxyType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetCloudProxy,
        "proxyType": proxyType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setRemoteHighPriorityAudioStream(bool enabled, int uid,
      {int streamType = NERtcAudioStreamType.kNERtcAudioStreamTypeMain}) async {
    apiLogger.i(
        'setRemoteHighPriorityAudioStream#arg{enabled:$enabled,uid:$uid,streamType:$streamType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setRemoteHighPriorityAudioStream',
          _platform.setRemoteHighPriorityAudioStream(enabled, uid, streamType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetRemoteHighPriorityAudioStream,
        "enabled": enabled,
        "uid": uid,
        "streamType": streamType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startBeauty({String filePath = ""}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('startBeauty', _platform.startBeauty());
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineStartBeauty, {"filePath": filePath});
    }
  }

  @override
  Future<void> stopBeauty() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await wrapper('stopBeauty', _platform.stopBeauty());
      return;
    } else {
      Invoke_(InvokeMethod.kNERtcEngineStopBeauty, null);
    }
  }

  @override
  Future<int> enableBeauty(bool enabled) async {
    apiLogger.i('enableBeauty#arg{enabled:$enabled}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('enableBeauty', _platform.enableBeauty(enabled));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineEnableBeauty, {"enabled": enabled});
    }
  }

  @override
  Future<int> setBeautyEffect(double level, int beautyType) async {
    apiLogger.i('setBeautyEffect#arg{level:$level,beautyType:$beautyType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setBeautyEffect', _platform.setBeautyEffect(level, beautyType));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetBeautyEffect,
          {"level": level, "beautyType": beautyType});
    }
  }

  @override
  Future<int> addBeautyFilter(String path, {String name = ''}) async {
    apiLogger.i('addBeautyFilter#arg{path:$path,name:$name}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'addBeautyFilter', _platform.addBeautyFilter(path, name));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineAddBeautyEffectFilter,
          {"path": path, "name": name});
    }
  }

  @override
  Future<void> removeBeautyFilter() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await wrapper('removeBeautyFilter', _platform.removeBeautyFilter());
      return;
    } else {
      Invoke_(InvokeMethod.kNERtcEngineRemoveBeautyEffectFilter, null);
    }
  }

  @override
  Future<int> setBeautyFilterLevel(double level) async {
    apiLogger.i('setBeautyFilterLevel#arg{level:$level}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setBeautyFilterLevel', _platform.setBeautyFilterLevel(level));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineSetBeautyFilterLevel, {"level": level});
    }
  }

  @override
  Future<int> setLocalVideoWatermarkConfigs(
      int type, NERtcVideoWatermarkConfig? config) async {
    apiLogger.i('setLocalVideoWatermarkConfigs#arg{type:$type,config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setLocalVideoWatermarkConfigs',
          _platform.setLocalVideoWatermarkConfigs(type, config));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcSetLocalVideoWaterMarkConfigs,
          {"type": type, "config": config?.toJson()});
    }
  }

  @override
  Future<int> startAudioDumpWithType(int dumpType) async {
    apiLogger.i('startAudioDumpWithType#arg{dumpType:$dumpType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startAudioDumpWithType', _platform.startAudioDumpWithType(dumpType));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartAudioDump,
        "type": dumpType
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> getNtpTimeOffset() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('getNtpTimeOffset', _platform.getNtpTimeOffset());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineGetNtpTimeOffset
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setStreamAlignmentProperty(bool enable) async {
    apiLogger.i('setStreamAlignmentProperty#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setStreamAlignmentProperty',
          _platform.setStreamAlignmentProperty(enable));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetStreamAlignmentProperty,
        "enable": enable
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  void onAudioEffectFinished(int effectId) {
    if (!_initialized) return;
    commonLogger.i('onAudioEffectFinished: effectId: $effectId');
    _audioEffectMgr.audioEffectEventCallbacks.forEach((element) {
      element.onAudioEffectFinished(effectId);
    });
  }

  @override
  void onAudioEffectTimestampUpdate(int id, int timestampMs) {
    if (!_initialized) return;
    commonLogger
        .i('onAudioEffectTimestampUpdate: id: $id, timestampMs: $timestampMs');
    _audioEffectMgr.audioEffectEventCallbacks.forEach((element) {
      element.onAudioEffectTimestampUpdate(id, timestampMs);
    });
  }

  @override
  void onAudioMixingStateChanged(int reason) {
    if (!_initialized) return;
    commonLogger.i('onAudioMixingStateChanged: reason: $reason');
    _audioMixingMgr.audioMixingEventCallbacks.forEach((element) {
      element.onAudioMixingStateChanged(reason);
    });
  }

  @override
  void onAudioMixingTimestampUpdate(int timestampMs) {
    if (!_initialized) return;
    _audioMixingMgr.audioMixingEventCallbacks.forEach((element) {
      element.onAudioMixingTimestampUpdate(timestampMs);
    });
  }

  @override
  void onLocalAudioStats(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onLocalAudioStats(NERtcAudioSendStats.fromMap(arguments));
    }
  }

  @override
  void onLocalVideoStats(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onLocalVideoStats(NERtcVideoSendStats.fromMap(arguments));
    }
  }

  @override
  void onNetworkQuality(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    List<dynamic> argumentList = arguments['list'];
    var statsList = <NERtcNetworkQualityInfo>[];
    for (Map<dynamic, dynamic> argument in argumentList) {
      statsList.add(NERtcNetworkQualityInfo.fromMap(argument));
    }
    for (var callback in _statsCallbacks.copy()) {
      callback.onNetworkQuality(statsList);
    }
  }

  @override
  void onRemoteAudioStats(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    List<dynamic> argumentList = arguments['list'];
    List<NERtcAudioRecvStats> statsList = <NERtcAudioRecvStats>[];
    for (Map<dynamic, dynamic> argument in argumentList) {
      statsList.add(NERtcAudioRecvStats.fromMap(argument));
    }
    for (var callback in _statsCallbacks.copy()) {
      callback.onRemoteAudioStats(statsList);
    }
  }

  @override
  void onRemoteVideoStats(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    List<dynamic> argumentList = arguments['list'];
    var statsList = <NERtcVideoRecvStats>[];
    for (Map<dynamic, dynamic> argument in argumentList) {
      statsList.add(NERtcVideoRecvStats.fromMap(argument));
    }
    for (var callback in _statsCallbacks.copy()) {
      callback.onRemoteVideoStats(statsList);
    }
  }

  @override
  void onRtcStats(Map<dynamic, dynamic> arguments, String tag) {
    if (!_initialized) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onRtcStats(NERtcStats.fromMap(arguments));
    }
  }

  @override
  void onLastmileProbeResult(NERtcLastmileProbeResult result) {
    commonLogger.i('onLastmileProbeResult: $result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLastmileProbeResult(result);
    }
  }

  @override
  void onLastmileQuality(int quality) {
    commonLogger.i('onLastmileQuality: $quality');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLastmileQuality(quality);
    }
  }

  @override
  Future<int> enableMediaPub(int mediaType, bool enable) async {
    apiLogger.i('enableMediaPub#arg{enable:$enable,mediaType:$mediaType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableMediaPub', _platform.enableMediaPub(mediaType, enable));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineEnableMediaPub,
        "mediaType": mediaType,
        "enable": enable
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  void onMediaRightChange(
      bool isAudioBannedByServer, bool isVideoBannedByServer) {
    commonLogger.i(
        'onMediaRightChange: isAudioBannedByServer$isAudioBannedByServer,isVideoBannedByServer:$isVideoBannedByServer');
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRightChange(isAudioBannedByServer, isVideoBannedByServer);
    }
  }

  @override
  Future<int> setAudioSubscribeOnlyBy(List<int>? uidArray) async {
    apiLogger.i('setAudioSubscribeOnlyBy#arg{uidArray:${uidArray?.join(',')}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setAudioSubscribeOnlyBy',
          _platform.setAudioSubscribeOnlyBy(uidArray));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetAudioSubscribeOnlyBy,
        "uidArray": uidArray
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteSubStreamAudio(int uid, bool subscribe) async {
    if (Platform.isAndroid || Platform.isIOS) {
      apiLogger.i(
          'subscribeRemoteSubStreamAudio#arg{uid:$uid,subscribe:$subscribe}');
      int reply = await wrapper('subscribeRemoteSubStreamAudio',
          _platform.subscribeRemoteSubStreamAudio(uid, subscribe));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSubscribeRemoteSubAudioStream,
        "uid": uid,
        "subscribe": subscribe
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  void onTakeSnapshotResult(int code, String path) {
    commonLogger.i('onTakeSnapshotResult: code: $code,path:$path');
    for (var callback in _eventCallbacks.copy()) {
      callback.onTakeSnapshotResult(code, path);
    }
  }

  @override
  Future<int> takeLocalSnapshot(int streamType, String path) async {
    apiLogger.i('takeLocalSnapshot#arg{streamType:$streamType,path:$path}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'takeLocalSnapshot', _platform.takeLocalSnapshot(streamType, path));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineTakeLocalSnapshot,
        "streamType": streamType,
        "path": path
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> takeRemoteSnapshot(int uid, int streamType, String path) async {
    apiLogger.i(
        'takeRemoteSnapshot#arg{uid:$uid,streamType:$streamType,path:$path}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('takeRemoteSnapshot',
          _platform.takeRemoteSnapshot(uid, streamType, path));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineTakeRemoteSnapshot,
          {"uid": uid, "streamType": streamType, "path": path});
    }
  }

  @override
  void onAddLiveStreamTask(String taskId, int errCode) {
    commonLogger.i('onAddLiveStreamTask: taskId: $taskId,errCode:$errCode');
    for (var callback in _liveTaskCallback.copy()) {
      callback.onAddLiveStreamTask(taskId, errCode);
    }
  }

  @override
  void onDeleteLiveStreamTask(String taskId, int errCode) {
    commonLogger.i('onDeleteLiveStreamTask: taskId: $taskId,errCode:$errCode');
    for (var callback in _liveTaskCallback.copy()) {
      callback.onDeleteLiveStreamTask(taskId, errCode);
    }
  }

  @override
  void onUpdateLiveStreamTask(String taskId, int errCode) {
    commonLogger.i('onUpdateLiveStreamTask: taskId: $taskId,errCode:$errCode');
    for (var callback in _liveTaskCallback.copy()) {
      callback.onUpdateLiveStreamTask(taskId, errCode);
    }
  }

  @override
  void onPermissionKeyWillExpire() {
    commonLogger.i('onPermissionKeyWillExpire');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPermissionKeyWillExpire();
    }
  }

  @override
  void onUpdatePermissionKey(String key, int error, int timeout) {
    commonLogger
        .i('onUpdatePermissionKey: key: $key,error:$error,timeOut:$timeout');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUpdatePermissionKey(key, error, timeout);
    }
  }

  @override
  Future<int> enableVideoCorrection(bool enable) async {
    apiLogger.i('enableVideoCorrection#arg{enable:$enable}');
    int reply = await wrapper(
        'enableVideoCorrection', _platform.enableVideoCorrection(enable));
    return reply;
  }

  Future<int> pushExternalVideoFrame(NERtcVideoFrame frame,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger.i(
        'pushExternalVideoFrame#arg{streamType:$streamType,frame:${frame.toString()}}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('pushExternalVideoFrame',
          _platform.pushExternalVideoFrame(streamType, frame));
      return reply;
    } else {
      Map<String, dynamic> params = {
        "width": frame.width,
        "height": frame.height,
        "rotation": frame.rotation,
        "format": frame.format,
        "timeStamp": frame.timeStamp,
        "strideY": frame.strideY,
        "strideU": frame.strideU,
        "strideV": frame.strideV,
        "textureId": frame.textureId,
        "streamType": streamType,
        "method": 'pushExternalVideoFrame'
      };
      return PushVideoFrame(
          jsonEncode(params), frame.data, frame.transformMatrix);
    }
  }

  @override
  Future<int> setExternalVideoSource(bool enable,
      {int streamType = NERtcVideoStreamType.main}) async {
    apiLogger
        .i('setExternalVideoSource#arg{streamType:$streamType,enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setExternalVideoSource',
          _platform.setExternalVideoSource(streamType, enable));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetExternalVideoSource,
          {"enable": enable, "streamType": streamType});
      return reply;
    }
  }

  @override
  Future<int> setVideoDump(NERtcVideoDumpType dumpType) async {
    apiLogger.i('setVideoDump#arg{dumpType:$dumpType}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('setVideoDump', _platform.setVideoDump(dumpType.index));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetVideoDump, {"dumpType": dumpType.index});
      return reply;
    }
  }

  @override
  Future<String> getParameter(String key, String extraInfo) async {
    apiLogger.i('getParameter#arg{key:$key}');
    if (Platform.isAndroid || Platform.isIOS) {
      String reply =
          await wrapper('getParameter', _platform.getParameter(key, extraInfo));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineGetParameter,
        "key": key
      };
      final result = InvokeMethod1_(jsonEncode(convertJson));
      return result;
    }
  }

  @override
  Future<int> setVideoStreamLayerCount(int layerCount) async {
    apiLogger.i('setVideoStreamLayerCount#arg{layerCount:$layerCount}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setVideoStreamLayerCount',
          _platform.setVideoStreamLayerCount(layerCount));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetVideoStreamLayerCount,
          {"layerCount": layerCount});
      return reply;
    }
  }

  @override
  Future<int> enableLocalData(bool enable) async {
    apiLogger.i('enableLocalData#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('enableLocalData', _platform.enableLocalData(enable));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineEnableLocalData, {"enabled": enable});
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteData(int uid, bool subscribe) async {
    apiLogger.i('subscribeRemoteData#arg{uid:$uid,subscribe:$subscribe}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'subscribeRemoteData', _platform.subscribeRemoteData(uid, subscribe));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSubscribeRemoteData,
          {"uid": uid, "subscribe": subscribe});
      return reply;
    }
  }

  @override
  Future<int> getFeatureSupportedType(NERtcFeatureType featureType) async {
    apiLogger.i('getFeatureSupportedType#arg{featureType:$featureType.index}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getFeatureSupportedType',
          _platform.getFeatureSupportedType(featureType.index));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineGetFeatureSupportedType,
          {"featureType": featureType.index});
      return reply;
    }
  }

  @override
  Future<bool> isFeatureSupported(NERtcFeatureType featureType) async {
    apiLogger.i('isFeatureSupported#arg{featureType:${featureType.index}');
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply = await wrapper('isFeatureSupported',
          _platform.isFeatureSupported(featureType.index));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineIsFeatureSupported,
          {"featureType": featureType.index});
      return reply == 1;
    }
  }

  @override
  Future<int> setSubscribeAudioBlocklist(
      List<int> uidList, int streamType) async {
    apiLogger.i('setSubscribeAudioBlocklist#arg{uidList:$uidList}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setSubscribeAudioBlocklist',
          _platform.setSubscribeAudioBlocklist(uidList, streamType));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSubscribeAudioBlocklist,
          {"uidList": uidList, "streamType": streamType});
      return reply;
    }
  }

  @override
  Future<int> setSubscribeAudioAllowlist(List<int> uidList) async {
    apiLogger.i('setSubscribeAudioAllowlist#arg{uidList:$uidList}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setSubscribeAudioAllowlist',
          _platform.setSubscribeAudioAllowlist(uidList));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSubscribeAudioAllowlist,
          {"uidList": uidList});
      return reply;
    }
  }

  @override
  Future<int> getNetworkType() async {
    apiLogger.i('getNetworkType#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getNetworkType', _platform.getNetworkType());
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineGetNetworkType, {});
      return reply;
    }
  }

  @override
  Future<int> stopPushStreaming() async {
    apiLogger.i('stopPushStreaming#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('stopPushStreaming', _platform.stopPushStreaming());
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStopPushStreaming, {});
      return reply;
    }
  }

  @override
  Future<int> stopPlayStreaming(String streamId) async {
    apiLogger.i('stopPlayStreaming#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'stopPlayStreaming', _platform.stopPlayStreaming(streamId));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineStopPlayStreaming, {"streamId": streamId});
      return reply;
    }
  }

  @override
  Future<int> pausePlayStreaming(String streamId) async {
    apiLogger.i('pausePlayStreaming#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'pausePlayStreaming', _platform.pausePlayStreaming(streamId));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEnginePausePlayStreaming, {"streamId": streamId});
      return reply;
    }
  }

  @override
  Future<int> resumePlayStreaming(String streamId) async {
    apiLogger.i('resumePlayStreaming#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'resumePlayStreaming', _platform.resumePlayStreaming(streamId));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineResumePlayStreaming, {"streamId": streamId});
      return reply;
    }
  }

  @override
  Future<int> muteVideoForPlayStreaming(String streamId, bool mute) async {
    apiLogger.i('muteVideoForPlayStreaming#arg{mute:$mute}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('muteVideoForPlayStreaming',
          _platform.muteVideoForPlayStreaming(streamId, mute));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineMuteVideoForPlayStreaming,
          {"mute": mute, "streamId": streamId});
      return reply;
    }
  }

  @override
  Future<int> muteAudioForPlayStreaming(String streamId, bool mute) async {
    apiLogger.i('muteAudioForPlayStreaming#arg{mute:$mute}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('muteAudioForPlayStreaming',
          _platform.muteAudioForPlayStreaming(streamId, mute));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineMuteAudioForPlayStreaming,
          {"mute": mute, "streamId": streamId});
      return reply;
    }
  }

  @override
  Future<int> stopASRCaption() async {
    apiLogger.i('stopASRCaption#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('stopASRCaption', _platform.stopASRCaption());
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStopASRCaption, {});
      return reply;
    }
  }

  @override
  Future<int> aiManualInterrupt(int dstUid) async {
    apiLogger.i('aiManualInterrupt#arg{}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'aiManualInterrupt', _platform.aiManualInterrupt(dstUid));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineAiManualInterrupt, {"dstUid": dstUid});
      return reply;
    }
  }

  @override
  Future<int> setAINSMode(NERtcAudioAINSMode mode) async {
    apiLogger.i('AINSMode#arg{mode:$mode}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('AINSMode', _platform.AINSMode(mode.index));
      return reply;
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineAINSMode, {"mode": mode.index});
      return reply;
    }
  }

  @override
  Future<int> setAudioScenario(int scenario) async {
    apiLogger.i('setAudioScenario#arg{scenario:$scenario}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioScenario', _platform.setAudioScenario(scenario));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetAudioScenario, {"scenario": scenario});
      return reply;
    }
  }

  @override
  Future<int> setExternalAudioSource(
      bool enable, int sampleRate, int channels) async {
    apiLogger.i(
        'setExternalAudioSource#arg{enable:$enable,sampleRate:$sampleRate,channels:$channels}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setExternalAudioSource',
          _platform.setExternalAudioSource(enable, sampleRate, channels));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetExternalAudioSource,
          {"enable": enable, "sampleRate": sampleRate, "channels": channels});
      return reply;
    }
  }

  @override
  Future<int> setExternalSubStreamAudioSource(
      bool enable, int sampleRate, int channels) async {
    apiLogger.i(
        'setExternalSubStreamAudioSource#arg{enable:$enable,sampleRate:$sampleRate,channels:$channels}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setExternalSubStreamAudioSource',
          _platform.setExternalSubStreamAudioSource(
              enable, sampleRate, channels));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetExternalSubStreamAudioSource,
          {"enabled": enable, "sampleRate": sampleRate, "channels": channels});
      return reply;
    }
  }

  @override
  Future<int> setAudioRecvRange(int audibleDistance, int conversationalDistance,
      NERtcDistanceRollOffModel rollOffModel) async {
    apiLogger.i(
        'setAudioRecvRange#arg{audibleDistance:$audibleDistance,conversationalDistance:$conversationalDistance,rollOffModel:${rollOffModel.index}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioRecvRange',
          _platform.setAudioRecvRange(
              audibleDistance, conversationalDistance, rollOffModel.index));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetAudioRecvRange, {
        "audioRecvRange": audibleDistance,
        "conversationalDistance": conversationalDistance,
        "rollOffModel": rollOffModel.index
      });
      return reply;
    }
  }

  @override
  Future<int> setRangeAudioMode(NERtcRangeAudioMode audioMode) async {
    apiLogger.i('setRangeAudioMode#arg{audioMode:${audioMode.index}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setRangeAudioMode', _platform.setRangeAudioMode(audioMode.index));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetRangeAudioMode,
          {"audioMode": audioMode.index});
      return reply;
    }
  }

  @override
  Future<int> setRangeAudioTeamID(int teamID) async {
    apiLogger.i('setRangeAudioTeamID#arg{teamID:${teamID}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setRangeAudioTeamID', _platform.setRangeAudioTeamID(teamID));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetRangeAudioTeamID, {"teamID": teamID});
      return reply;
    }
  }

  @override
  Future<int> updateSelfPosition(NERtcPositionInfo positionInfo) async {
    final info = positionInfo.toJson();
    apiLogger.i('updateSelfPosition#arg{positionInfo:${info}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'updateSelfPosition', _platform.updateSelfPosition(positionInfo));
      return reply;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineUpdateSelfPosition, {"positionInfo": info});
      return reply;
    }
  }

  @override
  Future<int> enableSpatializerRoomEffects(bool enable) async {
    apiLogger.i('enableSpatializerRoomEffects#arg{enable:${enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('enableSpatializerRoomEffects',
          _platform.enableSpatializerRoomEffects(enable));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableSpatializerRoomEffects,
          {"enable": enable});
      return reply;
    }
  }

  @override
  Future<int> setSpatializerRoomProperty(
      NERtcSpatializerRoomProperty property) async {
    final info = property.toJson();
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setSpatializerRoomProperty',
          _platform.setSpatializerRoomProperty(property));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSpatializerRoomProperty,
          {"property": info});
      return reply;
    }
  }

  @override
  Future<int> setSpatializerRenderMode(
      NERtcSpatializerRenderMode renderMode) async {
    apiLogger.i('setSpatializerRenderMode#arg{renderMode:${renderMode}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setSpatializerRenderMode',
          _platform.setSpatializerRenderMode(renderMode.index));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSpatializerRenderMode,
          {"renderMode": renderMode.index});
      return reply;
    }
  }

  @override
  Future<int> enableSpatializer(bool enable, bool applyToTeam) async {
    apiLogger
        .i('enableSpatializer#arg{enable:${enable},applyToTeam:$applyToTeam');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('enableSpatializer',
          _platform.enableSpatializer(enable, applyToTeam));
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableSpatializer,
          {"enable": enable, "applyToTeam": applyToTeam});
      return reply;
    }
  }

  @override
  Future<int> initSpatializer() async {
    apiLogger.i('initSpatializer');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('initSpatializer', _platform.initSpatializer());
      return reply;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineInitSpatializer, {});
      return reply;
    }
  }

  @override
  Future<int> addLocalRecorderStreamForTask(
      NERtcLocalRecordingConfig config, String taskId) async {
    apiLogger
        .i('addLocalRecorderStreamForTask#arg{config:$config,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      final info = config.toJson();
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineAddLocalRecorderStreamForTask,
          {"config": info, "taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> removeLocalRecorderStreamForTask(String taskId) async {
    apiLogger.i('removeLocalRecorderStreamForTask#arg{taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineRemoveLocalRecorderStreamForTask,
          {"taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> addLocalRecorderStreamLayoutForTask(
      NERtcLocalRecordingLayoutConfig config,
      int uid,
      int streamType,
      int streamLayer,
      String taskId) async {
    apiLogger.i(
        'addLocalRecorderStreamLayoutForTask#arg{config:$config,uid:$uid,streamType:$streamType,streamLayer:$streamLayer,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      final info = config.toJson();
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineAddLocalRecorderStreamLayoutForTask, {
        "config": info,
        "uid": uid,
        "streamType": streamType,
        "streamLayer": streamLayer,
        "taskId": taskId
      });
      return reply;
    }
  }

  @override
  Future<int> removeLocalRecorderStreamLayoutForTask(
      int uid, int streamType, int streamLayer, String taskId) async {
    apiLogger.i(
        'removeLocalRecorderStreamLayoutForTask#arg{uid:$uid,streamType:$streamType,streamLayer:$streamLayer,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineRemoveLocalRecorderStreamLayoutForTask, {
        "uid": uid,
        "streamType": streamType,
        "streamLayer": streamLayer,
        "taskId": taskId
      });
      return reply;
    }
  }

  @override
  Future<int> updateLocalRecorderStreamLayoutForTask(
      List<NERtcLocalRecordingStreamInfo> infos, String taskId) async {
    apiLogger.i(
        'updateLocalRecorderStreamLayoutForTask#arg{infos:$infos,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      final infosJson = infos.map((e) => e.toJson()).toList();
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineUpdateLocalRecorderStreamLayoutForTask,
          {"infos": infosJson, "taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> replaceLocalRecorderStreamLayoutForTask(
      List<NERtcLocalRecordingStreamInfo> infos, String taskId) async {
    apiLogger.i(
        'replaceLocalRecorderStreamLayoutForTask#arg{infos:$infos,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      final infosJson = infos.map((e) => e.toJson()).toList();
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineReplaceLocalRecorderStreamLayoutForTask,
          {"infos": infosJson, "taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> updateLocalRecorderWaterMarksForTask(
      List<NERtcVideoWatermarkConfig> watermarks, String taskId) async {
    apiLogger.i(
        'updateLocalRecorderWaterMarksForTask#arg{watermarks:$watermarks,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      final watermarksJson = watermarks.map((e) => e.toJson()).toList();
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineUpdateLocalRecorderWaterMarksForTask,
          {"watermarks": watermarksJson, "taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> pushLocalRecorderVideoFrameForTask(int uid, int streamType,
      int streamLayer, String taskId, NERtcVideoFrame frame) async {
    apiLogger.i(
        'pushLocalRecorderVideoFrameForTask#arg{uid:$uid,streamType:$streamType,streamLayer:$streamLayer,taskId:$taskId,frame:$frame}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      Map<String, dynamic> params = {
        "width": frame.width,
        "height": frame.height,
        "rotation": frame.rotation,
        "format": frame.format,
        "timeStamp": frame.timeStamp,
        "strideY": frame.strideY,
        "strideU": frame.strideU,
        "strideV": frame.strideV,
        "textureId": frame.textureId,
        "uid": uid,
        "streamType": streamType,
        "streamLayer": streamLayer,
        "taskId": taskId,
        "method": 'pushLocalRecorderVideoFrame'
      };
      String json = jsonEncode(params);
      return PushVideoFrame(json, frame.data, frame.transformMatrix);
    }
  }

  @override
  Future<int> showLocalRecorderStreamDefaultCoverForTask(bool showEnabled,
      int uid, int streamType, int streamLayer, String taskId) async {
    apiLogger.i(
        'showLocalRecorderStreamDefaultCoverForTask#arg{showEnabled:$showEnabled,uid:$uid,streamType:$streamType,streamLayer:$streamLayer,taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineShowLocalRecorderStreamDefaultCoverForTask, {
        "showEnabled": showEnabled,
        "uid": uid,
        "streamType": streamType,
        "streamLayer": streamLayer,
        "taskId": taskId
      });
      return reply;
    }
  }

  @override
  Future<int> stopLocalRecorderRemuxMp4(String taskId) async {
    apiLogger.i('stopLocalRecorderRemuxMp4#arg{taskId:$taskId}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStopLocalRecorderRemuxMp4,
          {"taskId": taskId});
      return reply;
    }
  }

  @override
  Future<int> remuxFlvToMp4(
      String flvPath, String mp4Path, bool saveOri) async {
    apiLogger.i(
        'remuxFlvToMp4#arg{flvPath:$flvPath,mp4Path:$mp4Path,saveOri:$saveOri}');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineRemuxFlvToMp4,
          {"flvPath": flvPath, "mp4Path": mp4Path, "saveOri": saveOri});
      return reply;
    }
  }

  @override
  Future<int> stopRemuxFlvToMp4() async {
    apiLogger.i('stopRemuxFlvToMp4');
    if (Platform.isAndroid || Platform.isIOS) {
      return 30004;
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStopRemuxFlvToMp4, {});
      return reply;
    }
  }

  @override
  Future<int> startPushStreaming(NERtcPushStreamingConfig config) async {
    apiLogger.i('startPushStreaming#arg{config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startPushStreaming', _platform.startPushStreaming(config));
      return reply;
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineStartPushStreaming, config.toJson());
      return reply;
    }
  }

  @override
  Future<int> startPlayStreaming(
      String streamId, NERtcPlayStreamingConfig config) async {
    apiLogger.i('startPlayStreaming#arg{streamId:$streamId,config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startPlayStreaming', _platform.startPlayStreaming(streamId, config));
      return reply;
    } else {
      Map<String, dynamic> params = config.toJson();
      params['streamId'] = streamId;
      params['method'] = InvokeMethod.kNERtcEngineStartPlayStreaming;
      int reply = InvokeMethod_(jsonEncode(params));
      return reply;
    }
  }

  @override
  Future<int> startASRCaption(NERtcASRCaptionConfig config) async {
    apiLogger.i('startASRCaption#arg{config:$config}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('startASRCaption', _platform.startASRCaption(config));
      return reply;
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineStartASRCaption, config.toJson());
      return reply;
    }
  }

  @override
  Future<int> setMultiPathOption(NERtcMultiPathOption option) async {
    apiLogger.i('setMultiPathOption#arg{option:$option}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setMultiPathOption', _platform.setMultiPathOption(option));
      return reply;
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineSetMultiPathOption, option.toJson());
      return reply;
    }
  }

  @override
  Future<int> sendData(NERtcDataExternalFrame frame) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.sendData(frame);
      return reply;
    } else {
      Map<String, dynamic> params = {"dataSize": frame.dataSize};
      return PushDataFrame(jsonEncode(params), frame.data);
    }
  }

  @override
  Future<int> pushExternalAudioFrame(NERtcAudioExternalFrame frame) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.pushExternalAudioFrame(frame);
      return reply;
    } else {
      Map<String, dynamic> params = {
        "sampleRate": frame.sampleRate,
        "numberOfChannels": frame.numberOfChannels,
        "samplesPerChannel": frame.samplesPerChannel,
        "syncTimestamp": frame.syncTimestamp,
        "streamType": NERtcAudioStreamType.kNERtcAudioStreamTypeMain
      };
      return PushAudioFrame(jsonEncode(params), frame.data);
    }
  }

  @override
  Future<int> pushExternalSubAudioFrame(NERtcAudioExternalFrame frame) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await _platform.pushExternalSubAudioFrame(frame);
      return reply;
    } else {
      Map<String, dynamic> params = {
        "sampleRate": frame.sampleRate,
        "numberOfChannels": frame.numberOfChannels,
        "samplesPerChannel": frame.samplesPerChannel,
        "syncTimestamp": frame.syncTimestamp,
        "streamType": NERtcAudioStreamType.kNERtcAudioStreamTypeSub
      };
      return PushAudioFrame(jsonEncode(params), frame.data);
    }
  }
}

/// @nodoc
extension IterableX<E> on Iterable<E> {
  Iterable<E> copy() {
    return List<E>.from(this, growable: false);
  }

  E? get firstOrNull {
    return isEmpty ? null : first;
  }

  E? get lastOrNull {
    return isEmpty ? null : last;
  }
}
