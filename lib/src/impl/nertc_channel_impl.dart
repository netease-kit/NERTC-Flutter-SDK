// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcChannelImpl extends NERtcChannel
    with
        _SDKLoggerMixin,
        LoggingApi,
        NERtcSubChannelEventSink,
        NERtcStatsEventSink {
  final String channelTag;
  final _platform = NERtcChannelPlatform.instance;
  final _rtcStatsPlatform = NERtcStatsPlatform.instance;
  final _eventCallbacks = <NERtcChannelEventCallback>{};
  final _statsCallbacks = <NERtcStatsEventCallback>{};

  _NERtcChannelImpl(this.channelTag) {
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.addRtcChannelListener(this);
      _rtcStatsPlatform.registerStatsListener(this);
    } else {
      RegisterNERtcSubChannelEventSink(channelTag, this);
    }
  }

  void dispose() {
    commonLogger.i('dispose');
    _eventCallbacks.clear();
    _statsCallbacks.clear();

    _platform.removeRtcChannelListener(this);
    _rtcStatsPlatform.unregisterStatsListener(this);
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.clearStatsEventCallback(channelTag);
    }

    final engine = NERtcEngine.instance as _NERtcEngineImpl;
    engine._channelMaps.remove(channelTag);
  }

  @override
  Future<String> getChannelName(String channelTag) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.getChannelName(channelTag);
    } else {
      Map<String, dynamic> convertJson = {
        "isChannel": true,
        "method": InvokeMethod.kNERtcChannelGetChannelName,
        "channelTag": channelTag,
      };
      String reply = InvokeMethod1_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> enableMediaPub(int mediaType, bool enable) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.enableMediaPub(channelTag, mediaType, enable);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableMediaPub, {
        "isChannel": true,
        "channelTag": channelTag,
        "mediaType": mediaType,
        "enable": enable
      });
      return reply;
    }
  }

  @override
  Future<int> enableAudioVolumeIndication(bool enable, int interval,
      {bool vad = false}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.enableAudioVolumeIndication(
          channelTag, enable, interval, vad);
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineEnableAudioVolumeIndication, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "interval": interval,
        "vad": vad
      });
      return reply;
    }
  }

  @override
  Future<int> enableLocalAudio(bool enable) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.enableLocalAudio(channelTag, enable);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableLocalAudio, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "streamType": 0
      });
      return reply;
    }
  }

  @override
  Future<int> enableLocalVideo(bool enable,
      {int streamType = NERtcVideoStreamType.main}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.enableLocalVideo(channelTag, enable, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableLocalVideo, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "streamType": streamType
      });
      return reply;
    }
  }

  @override
  Future<int> getConnectionState() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.getConnectionState(channelTag);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineGetChannelConnection, {
        "isChannel": true,
        "channelTag": channelTag,
      });
      return reply;
    }
  }

  @override
  Future<int> joinChannel(String? token, String channelName, int uid,
      NERtcJoinChannelOptions? channelOptions) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.joinChannel(
          channelTag, token, channelName, uid, channelOptions);
    } else {
      Map<String, dynamic> params = {
        "isChannel": true,
        "channelTag": channelTag,
        "channelName": channelName,
        "uid": uid,
      };
      if (token != null) {
        params["token"] = token;
      }
      if (channelOptions != null) {
        params["channelOptions"] = channelOptions.toJson();
      }
      int reply = Invoke_(InvokeMethod.kNERtcEngineJoinChannel, params);
      return reply;
    }
  }

  @override
  Future<int> leaveChannel() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.leaveChannel(channelTag);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineLeaveChannel, {
        "isChannel": true,
        "channelTag": channelTag,
      });
      return reply;
    }
  }

  @override
  Future<int> muteLocalAudioStream(bool mute) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.muteLocalAudioStream(channelTag, mute);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineMuteLocalAudio, {
        "isChannel": true,
        "channelTag": channelTag,
        "mute": mute,
        "streamType": 0
      });
      return reply;
    }
  }

  @override
  Future<int> muteLocalVideoStream(bool mute,
      {int streamType = NERtcVideoStreamType.main}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.muteLocalVideoStream(channelTag, mute, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineMuteLocalVideo, {
        "isChannel": true,
        "channelTag": channelTag,
        "mute": mute,
        "streamType": streamType
      });
      return reply;
    }
  }

  @override
  Future<int> release() async {
    dispose();
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.release(channelTag);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineRelease, {
        "isChannel": true,
        "channelTag": channelTag,
      });
      return reply;
    }
  }

  @override
  Future<int> setChannelProfile(int channelProfile) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.setChannelProfile(channelTag, channelProfile);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetChannelProfile, {
        "isChannel": true,
        "channelTag": channelTag,
        "profile": channelProfile
      });
      return reply;
    }
  }

  @override
  Future<int> setClientRole(int role) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.setClientRole(channelTag, role);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetClientRole,
          {"isChannel": true, "channelTag": channelTag, "role": role});
      return reply;
    }
  }

  @override
  void setEventCallback(NERtcChannelEventCallback callback) {
    _eventCallbacks.add(callback);
  }

  @override
  void removeEventCallback(NERtcChannelEventCallback callback) {
    _eventCallbacks.remove(callback);
  }

  @override
  Future<int> setLocalVideoConfig(NERtcVideoConfig videoConfig,
      {int streamType = NERtcVideoStreamType.main}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.setLocalVideoConfig(
          channelTag, videoConfig, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetLocalVideoConfig, {
        "isChannel": true,
        "channelTag": channelTag,
        "videoConfig": videoConfig.toJson(),
        "streamType": streamType
      });
      return reply;
    }
  }

  @override
  void setStatsEventCallback(NERtcStatsEventCallback callback) {
    _statsCallbacks.add(callback);
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.setStatsEventCallback(channelTag);
    } else {
      RegisterNERtcSubChannelStatsSink(channelTag, this);
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetMediaStatsObserver,
        "register": true,
        "isChannel": true,
        "channelTag": this.channelTag,
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
    apiLogger.i('channelTag: $channelTag, setStatsEventCallback.');
  }

  @override
  void removeStatsEventCallback(NERtcStatsEventCallback callback) {
    _statsCallbacks.remove(callback);
    if (Platform.isAndroid || Platform.isIOS) {
      _platform.clearStatsEventCallback(channelTag);
    } else {
      RegisterMediaStatsSink(null);
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetMediaStatsObserver,
        "register": false,
        "isChannel": true,
        "channelTag": this.channelTag
      };
      InvokeMethod_(jsonEncode(convertJson));
    }
    apiLogger.i('channelTag: $channelTag, removeStatsEventCallback.');
  }

  @override
  Future<int> subscribeRemoteAudio(int uid, bool subscribe) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.subscribeRemoteAudio(channelTag, uid, subscribe);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSubscribeRemoteAudioStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "subscribe": subscribe
      });
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteSubStreamAudio(int uid, bool subscribe) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.subscribeRemoteSubAudio(
          channelTag, uid, subscribe);
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSubscribeRemoteSubAudioStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "subscribe": subscribe
      });
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteVideoStream(
      int uid, int streamType, bool subscribe) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.subscribeRemoteVideoStream(
          channelTag, uid, streamType, subscribe);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSubscribeRemoteVideoStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "streamType": streamType,
        "subscribe": subscribe
      });
      return reply;
    }
  }

  @override
  Future<int> subscribeRemoteSubVideoStream(int uid, bool subscribe) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.subscribeRemoteSubVideoStream(
          channelTag, uid, subscribe);
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSubscribeRemoteSubVideoStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "subscribe": subscribe
      });
      return reply;
    }
  }

  @override
  Future<int> switchCamera() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.switchCamera(channelTag);
    } else {
      return 30004;
    }
  }

  @override
  Future<int> takeLocalSnapshot(int streamType, String path) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.takeLocalSnapshot(channelTag, streamType, path);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineTakeLocalSnapshot, {
        "isChannel": true,
        "channelTag": channelTag,
        "streamType": streamType,
        "path": path
      });
      return reply;
    }
  }

  @override
  Future<int> takeRemoteSnapshot(int uid, int streamType, String path) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _platform.takeRemoteSnapshot(
          channelTag, uid, streamType, path);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineTakeRemoteSnapshot, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "streamType": streamType,
        "path": path
      });
      return reply;
    }
  }

  @override
  void onAudioHasHowling(String channelTag) {
    if (this.channelTag != channelTag) {
      return;
    }
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioHasHowling();
    }
  }

  @override
  void onAudioRecording(String channelTag, int code, String filePath) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioRecording(code, filePath);
    }
  }

  @override
  void onClientRoleChange(String channelTag, int oldRole, int newRole) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onClientRoleChange(oldRole, newRole);
    }
  }

  @override
  void onConnectionStateChanged(String channelTag, int state, int reason) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onConnectionStateChanged(state, reason);
    }
  }

  @override
  void onConnectionTypeChanged(String channelTag, int newConnectionType) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onConnectionTypeChanged(newConnectionType);
    }
  }

  @override
  void onDisconnect(String channelTag, int reason) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onDisconnect(reason);
    }
  }

  @override
  void onError(String channelTag, int code) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onError(code);
    }
  }

  @override
  void onFirstAudioDataReceived(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstAudioDataReceived(uid);
    }
  }

  @override
  void onFirstAudioFrameDecoded(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstAudioFrameDecoded(uid);
    }
  }

  @override
  void onFirstVideoDataReceived(
      String channelTag, FirstVideoDataReceivedEvent event) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoDataReceived(event.uid, event.streamType);
    }
  }

  @override
  void onFirstVideoFrameDecoded(
      String channelTag, FirstVideoFrameDecodedEvent event) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoFrameDecoded(
          event.uid, event.width, event.height, event.streamType);
    }
  }

  @override
  void onJoinChannel(
      String channelTag, int result, int channelId, int elapsed, int uid) {
    commonLogger.i(
        'onJoinChannel result:$result, channelId:$channelId, elapsed:$elapsed, uid:$uid');
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onJoinChannel(result, channelId, elapsed, uid);
    }
  }

  @override
  void onLastmileProbeResult(
      String channelTag, NERtcLastmileProbeResult result) {
    commonLogger.i('onLastmileProbeResult result:$result');
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLastmileProbeResult(result);
    }
  }

  @override
  void onLastmileQuality(String channelTag, int quality) {
    commonLogger.i('onLastmileQuality quality:$quality');
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLastmileQuality(quality);
    }
  }

  @override
  void onLeaveChannel(String channelTag, int result) {
    commonLogger.i('onLeaveChannel result:$result');
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLeaveChannel(result);
    }
  }

  @override
  void onLiveStreamState(
      String channelTag, String taskId, String pushUrl, int liveState) {
    commonLogger.i(
        'onLiveStreamState taskId:$taskId, pushUrl:$pushUrl, liveState:$liveState');
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLiveStreamState(taskId, pushUrl, liveState);
    }
  }

  @override
  void onLocalAudioVolumeIndication(
      String channelTag, int volume, bool vadFlag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalAudioVolumeIndication(volume, vadFlag);
    }
  }

  @override
  void onLocalPublishFallbackToAudioOnly(
      String channelTag, bool isFallback, int streamType) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalPublishFallbackToAudioOnly(isFallback, streamType);
    }
  }

  @override
  void onLocalVideoWatermarkState(
      String channelTag, int videoStreamType, int state) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalVideoWatermarkState(videoStreamType, state);
    }
  }

  @override
  void onMediaRelayReceiveEvent(
      String channelTag, int event, int code, String channelName) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRelayReceiveEvent(event, code, channelName);
    }
  }

  @override
  void onMediaRelayStatesChange(
      String channelTag, int state, String channelName) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRelayStatesChange(state, channelName);
    }
  }

  @override
  void onMediaRightChange(String channelTag, bool isAudioBannedByServer,
      bool isVideoBannedByServer) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onMediaRightChange(isAudioBannedByServer, isVideoBannedByServer);
    }
  }

  @override
  void onPermissionKeyWillExpire(String channelTag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onPermissionKeyWillExpire();
    }
  }

  @override
  void onReJoinChannel(String channelTag, int result, int channelId) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onReJoinChannel(result, channelId);
    }
  }

  @override
  void onReconnectingStart(String channelTag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onReconnectingStart();
    }
  }

  @override
  void onRecvSEIMsg(String channelTag, int userID, String seiMsg) {
    if (this.channelTag != channelTag) return;
    for (var callback in _eventCallbacks.copy()) {
      callback.onRecvSEIMsg(userID, seiMsg);
    }
  }

  @override
  void onRemoteAudioVolumeIndication(
      String channelTag, RemoteAudioVolumeIndicationEvent event) {
    if (this.channelTag != channelTag) return;
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
  void onRemoteSubscribeFallbackToAudioOnly(
      String channelTag, int uid, bool isFallback, int streamType) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onRemoteSubscribeFallbackToAudioOnly: uid:$uid, isFallback:$isFallback,streamType:$streamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onRemoteSubscribeFallbackToAudioOnly(
          uid, isFallback, streamType);
    }
  }

  @override
  void onTakeSnapshotResult(String channelTag, int code, String path) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onTakeSnapshotResult: code: $code,path:$path');
    for (var callback in _eventCallbacks.copy()) {
      callback.onTakeSnapshotResult(code, path);
    }
  }

  @override
  void onUpdatePermissionKey(
      String channelTag, String key, int error, int timeout) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onUpdatePermissionKey: key: $key,error:$error,timeOut:$timeout');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUpdatePermissionKey(key, error, timeout);
    }
  }

  @override
  void onUserAudioMute(String channelTag, int uid, bool muted) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserAudioMute: uid:$uid, muted:$muted');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioMute(uid, muted);
    }
  }

  @override
  void onUserAudioStart(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserAudioStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioStart(uid);
    }
  }

  @override
  void onUserAudioStop(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserAudioStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserAudioStop(uid);
    }
  }

  @override
  void onUserJoined(String channelTag, UserJoinedEvent event) {
    if (this.channelTag != channelTag) return;
    final uid = event.uid;
    final joinExtraInfo = event.joinExtraInfo;
    commonLogger.i(
        'onUserJoined: uid:$uid,joinExtraInfo: {customInfo:${joinExtraInfo?.customInfo}}');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserJoined(uid, joinExtraInfo);
    }
  }

  @override
  void onUserLeave(String channelTag, UserLeaveEvent event) {
    if (this.channelTag != channelTag) return;
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
  void onUserSubStreamAudioMute(String channelTag, int uid, bool muted) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserSubStreamAudioMute: uid:$uid,muted:$muted');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioMute(uid, muted);
    }
  }

  @override
  void onUserSubStreamAudioStart(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserSubStreamAudioStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioStart(uid);
    }
  }

  @override
  void onUserSubStreamAudioStop(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserSubStreamAudioStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamAudioStop(uid);
    }
  }

  @override
  void onUserSubStreamVideoStart(String channelTag, int uid, int maxProfile) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onUserSubStreamVideoStart: uid:$uid, maxProfile:$maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamVideoStart(uid, maxProfile);
    }
  }

  @override
  void onUserSubStreamVideoStop(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserSubStreamVideoStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserSubStreamVideoStop(uid);
    }
  }

  @override
  void onUserVideoMute(String channelTag, UserVideoMuteEvent event) {
    if (this.channelTag != channelTag) return;
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
  void onUserVideoStart(String channelTag, int uid, int maxProfile) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserVideoStart: uid:$uid, maxProfile: $maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoStart(uid, maxProfile);
    }
  }

  @override
  void onUserVideoStop(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserVideoStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoStop(uid);
    }
  }

  @override
  void onVirtualBackgroundSourceEnabled(
      String channelTag, VirtualBackgroundSourceEnabledEvent event) {
    if (this.channelTag != channelTag) return;
    final enabled = event.enabled;
    final reason = event.reason;
    commonLogger
        .i('onVirtualBackgroundSourceEnabled: enabled:$enabled,reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onVirtualBackgroundSourceEnabled(enabled, reason);
    }
  }

  @override
  void onWarning(String channelTag, int code) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onWarning: code:$code');
    for (var callback in _eventCallbacks.copy()) {
      callback.onWarning(code);
    }
  }

  @override
  void onLocalAudioStats(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onLocalAudioStats(NERtcAudioSendStats.fromMap(arguments));
    }
  }

  @override
  void onLocalVideoStats(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onLocalVideoStats(NERtcVideoSendStats.fromMap(arguments));
    }
  }

  @override
  void onNetworkQuality(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
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
  void onRemoteAudioStats(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
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
  void onRemoteVideoStats(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
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
  void onRtcStats(Map<dynamic, dynamic> arguments, String channelTag) {
    if (this.channelTag != channelTag) return;
    for (var callback in _statsCallbacks.copy()) {
      callback.onRtcStats(NERtcStats.fromMap(arguments));
    }
  }

  @override
  Future<int> addLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.addLiveStreamTask(channelTag, taskInfo);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineAddLiveStreamTaskInfo, {
        "isChannel": true,
        "channelTag": channelTag,
        "taskInfo": taskInfo.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> adjustUserPlaybackSignalVolume(int uid, int volume) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.adjustUserPlaybackSignalVolume(channelTag, uid, volume);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcAdjustUserPlaybackSignalVolume, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "volume": volume
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> enableEncryption(bool enable, NERtcEncryptionConfig config) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.enableEncryption(channelTag, enable, config);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableEncryption, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "config": config.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> enableLocalData(bool enable) {
    if (Platform.isAndroid) {
      return _platform.enableLocalData(channelTag, enable);
    } else {
      return Future.value(30004);
    }
  }

  @override
  Future<int> enableLocalSubStreamAudio(bool enable) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.enableLocalSubStreamAudio(channelTag, enable);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableLocalAudio, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "streamType": 1
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> enableSpatializer(bool enable, bool applyToTeam) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.enableSpatializer(channelTag, enable, applyToTeam);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableSpatializer, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "applyToTeam": applyToTeam
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> enableSpatializerRoomEffects(bool enable) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.enableSpatializerRoomEffects(channelTag, enable);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineEnableSpatializerRoomEffects,
          {"isChannel": true, "channelTag": channelTag, "enable": enable});
      return Future.value(reply);
    }
  }

  @override
  Future<int> getFeatureSupportedType(NERtcFeatureType featureType) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.getFeatureSupportedType(channelTag, featureType.index);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineGetFeatureSupportedType, {
        "isChannel": true,
        "channelTag": channelTag,
        "type": featureType.index
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> initSpatializer() {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.initSpatializer(channelTag);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineInitSpatializer, {
        "isChannel": true,
        "channelTag": channelTag,
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> pushExternalVideoFrame(NERtcVideoFrame frame,
      {int streamType = NERtcVideoStreamType.main}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.pushExternalVideoFrame(channelTag, streamType, frame);
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
        "isChannel": true,
        "channelTag": channelTag
      };
      return PushVideoFrame(
          jsonEncode(params), frame.data, frame.transformMatrix);
    }
  }

  @override
  Future<int> removeLiveStreamTask(String taskId) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.removeLiveStreamTask(channelTag, taskId);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineRemoveLiveStreamTaskInfo,
          {"isChannel": true, "channelTag": channelTag, "taskId": taskId});
      return Future.value(reply);
    }
  }

  @override
  Future<int> reportCustomEvent(
      String eventName, String? customIdentify, Map<String?, Object?>? param) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.reportCustomEvent(
          channelTag, eventName, customIdentify, param);
    } else {
      Map<String, dynamic> params = {
        "isChannel": true,
        "channelTag": channelTag,
        "eventName": eventName
      };
      if (customIdentify != null) {
        params["customIdentify"] = customIdentify;
      }
      if (param != null) {
        params["param"] = param;
      }
      int reply = Invoke_(InvokeMethod.kNERtcEngineReportCustomEvent, params);
      return Future.value(reply);
    }
  }

  @override
  Future<int> sendData(NERtcDataExternalFrame frame) {
    if (Platform.isAndroid) {
      return _platform.sendData(channelTag, frame);
    } else {
      return Future.value(30004);
    }
  }

  @override
  Future<int> sendSEIMsg(String seiMsg,
      {int streamType = NERtcVideoStreamType.main}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.sendSEIMsg(channelTag, seiMsg, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSendSEIMsg, {
        "isChannel": true,
        "channelTag": channelTag,
        "seiMsg": seiMsg,
        "streamType": streamType
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setAudioRecvRange(int audibleDistance, int conversationalDistance,
      NERtcDistanceRollOffModel rollOffModel) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setAudioRecvRange(channelTag, audibleDistance,
          conversationalDistance, rollOffModel.index);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetAudioRecvRange, {
        "isChannel": true,
        "channelTag": channelTag,
        "audibleDistance": audibleDistance,
        "conversationalDistance": conversationalDistance,
        "rollOffMode": rollOffModel.index
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setAudioSubscribeOnlyBy(List<int>? uidArray) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setAudioSubscribeOnlyBy(channelTag, uidArray);
    } else {
      Map<String, dynamic> params = {
        "isChannel": true,
        "channelTag": channelTag,
      };
      if (uidArray != null) {
        params["uidArray"] = uidArray;
      }
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineSetAudioSubscribeOnlyBy, params);
      return Future.value(reply);
    }
  }

  @override
  Future<int> setCameraCaptureConfig(NERtcCameraCaptureConfig captureConfig,
      {int streamType = NERtcVideoStreamType.main}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setCameraCaptureConfig(
          channelTag, captureConfig, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetCaptureConfig, {
        "isChannel": true,
        "channelTag": channelTag,
        "captureConfig": captureConfig.toJson(),
        "streamType": streamType
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setExternalVideoSource(bool enable,
      {int streamType = NERtcVideoStreamType.main}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setExternalVideoSource(channelTag, streamType, enable);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetExternalVideoSource, {
        "isChannel": true,
        "channelTag": channelTag,
        "enable": enable,
        "streamType": streamType
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setLocalMediaPriority(int priority, bool isPreemptive) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setLocalMediaPriority(
          channelTag, priority, isPreemptive);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetLocalMediaPriority, {
        "isChannel": true,
        "channelTag": channelTag,
        "priority": priority,
        "isPreemptive": isPreemptive
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setLocalPublishFallbackOption(int option) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setLocalPublishFallbackOption(channelTag, option);
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetLocalPublishFallbackOption,
          {"isChannel": true, "channelTag": channelTag, "option": option});
      return Future.value(reply);
    }
  }

  @override
  Future<int> setRangeAudioMode(NERtcRangeAudioMode audioMode) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setRangeAudioMode(channelTag, audioMode.index);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetRangeAudioMode, {
        "isChannel": true,
        "channelTag": channelTag,
        "audioMode": audioMode.index
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setRangeAudioTeamID(int teamID) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setRangeAudioTeamID(channelTag, teamID);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetRangeAudioTeamID,
          {"isChannel": true, "channelTag": channelTag, "teamID": teamID});
      return Future.value(reply);
    }
  }

  @override
  Future<int> setRemoteHighPriorityAudioStream(bool enabled, int uid,
      {int streamType = NERtcAudioStreamType.kNERtcAudioStreamTypeMain}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setRemoteHighPriorityAudioStream(
          channelTag, enabled, uid, streamType);
    } else {
      int reply =
          Invoke_(InvokeMethod.kNERtcEngineSetRemoteHighPriorityAudioStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "uid": uid,
        "enabled": enabled,
        "streamType": streamType
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setRemoteSubscribeFallbackOption(int option) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setRemoteSubscribeFallbackOption(channelTag, option);
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSetRemoteSubscribeFallbackOption,
          {"isChannel": true, "channelTag": channelTag, "option": option});
      return Future.value(reply);
    }
  }

  @override
  Future<int> setSpatializerRenderMode(NERtcSpatializerRenderMode renderMode) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setSpatializerRenderMode(channelTag, renderMode.index);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSpatializerRenderMode, {
        "isChannel": true,
        "channelTag": channelTag,
        "renderMode": renderMode.index
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setSpatializerRoomProperty(
      NERtcSpatializerRoomProperty property) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setSpatializerRoomProperty(channelTag, property);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSpatializerRoomProperty, {
        "isChannel": true,
        "channelTag": channelTag,
        "property": property.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setSubscribeAudioAllowlist(List<int> uidList) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setSubscribeAudioAllowlist(channelTag, uidList);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSubscribeAudioAllowlist,
          {"isChannel": true, "channelTag": channelTag, "uidArray": uidList});
      return Future.value(reply);
    }
  }

  @override
  Future<int> setSubscribeAudioBlocklist(List<int> uidList, int streamType) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setSubscribeAudioBlocklist(
          channelTag, uidList, streamType);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetSubscribeAudioBlocklist, {
        "isChannel": true,
        "channelTag": channelTag,
        "uidArray": uidList,
        "streamType": streamType
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> setVideoStreamLayerCount(int layerCount) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.setVideoStreamLayerCount(channelTag, layerCount);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineSetVideoStreamLayerCount, {
        "isChannel": true,
        "channelTag": channelTag,
        "layerCount": layerCount
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> startChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.startChannelMediaRelay(channelTag, config);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStartChannelMediaRelay, {
        "isChannel": true,
        "channelTag": channelTag,
        "config": config.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> startScreenCapture(NERtcScreenConfig config) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.startScreenCapture(channelTag, config);
    } else {
      return Future.value(30004);
    }
  }

  @override
  Future<int> stopChannelMediaRelay() {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.stopChannelMediaRelay(channelTag);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineStopChannelMediaRelay, {
        "isChannel": true,
        "channelTag": channelTag,
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> stopScreenCapture() {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.stopScreenCapture(channelTag);
    } else {
      int reply = Invoke_(ScreenCaptureMethod.kNERtcEngineStopScreenCapture,
          {"isChannel": true, "channelTag": channelTag});
      return Future.value(reply);
    }
  }

  @override
  Future<int> subscribeAllRemoteAudio(bool subscribe) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.subscribeAllRemoteAudio(channelTag, subscribe);
    } else {
      int reply = Invoke_(
          InvokeMethod.kNERtcEngineSubscribeAllRemoteAudioStream, {
        "isChannel": true,
        "channelTag": channelTag,
        "subscribe": subscribe
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> subscribeRemoteData(int uid, bool subscribe) {
    if (Platform.isAndroid) {
      return _platform.subscribeRemoteData(channelTag, uid, subscribe);
    } else {
      return Future.value(30004);
    }
  }

  @override
  Future<int> switchCameraWithPosition(int position) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.switchCameraWithPosition(channelTag, position);
    } else {
      return Future.value(30004);
    }
  }

  @override
  Future<int> updateChannelMediaRelay(
      NERtcChannelMediaRelayConfiguration config) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.updateChannelMediaRelay(channelTag, config);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineUpdateChannelMediaRelay, {
        "isChannel": true,
        "channelTag": channelTag,
        "config": config.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> updateLiveStreamTask(NERtcLiveStreamTaskInfo taskInfo) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.updateLiveStreamTask(channelTag, taskInfo);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineUpdateLiveStreamTaskInfo, {
        "isChannel": true,
        "channelTag": channelTag,
        "taskInfo": taskInfo.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  Future<int> updateSelfPosition(NERtcPositionInfo positionInfo) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _platform.updateSelfPosition(channelTag, positionInfo);
    } else {
      int reply = Invoke_(InvokeMethod.kNERtcEngineUpdateSelfPosition, {
        "isChannel": true,
        "channelTag": channelTag,
        "positionInfo": positionInfo.toJson()
      });
      return Future.value(reply);
    }
  }

  @override
  IScreenCaptureList? getScreenCaptureSources(
      NERtcSize thumbSize, NERtcSize iconSize, bool includeScreen) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return null;
    }
    print(
        "Getting screen capture sources with thumbSize: $thumbSize, iconSize: $iconSize, includeScreen: $includeScreen");
    return _NERtcScreenCaptureListImpl(
        thumbSize, iconSize, includeScreen, channelTag);
  }

  @override
  int pauseScreenCapture() {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEnginePauseScreenCapture,
        {"isChannel": true, "channelTag": channelTag});
  }

  @override
  int resumeScreenCapture() {
    return Invoke_(ScreenCaptureMethod.kNERtcEngineResumeScreenCapture,
        {"isChannel": true, "channelTag": channelTag});
  }

  @override
  int setExcludeWindowList(List<int> windowLists, int count) {
    return Invoke_(ScreenCaptureMethod.kNERtcEngineSetExcludeWindowList, {
      "isChannel": true,
      "channelTag": channelTag,
      "windowLists": windowLists,
      "count": count
    });
  }

  @override
  int setScreenCaptureMouseCursor(bool captureCursor) {
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineSetScreenCaptureMouseCursor, {
      "isChannel": true,
      "channelTag": channelTag,
      "captureCursor": captureCursor
    });
  }

  @override
  int setScreenCaptureSource(NERtcScreenCaptureSourceInfo source,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEngineSetScreenCaptureSource, {
      "isChannel": true,
      "channelTag": channelTag,
      "source": source.toJson(),
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByDisplayId(int displayId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByDisplayId, {
      "isChannel": true,
      "channelTag": channelTag,
      "displayId": displayId,
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByScreenRect(NERtcRectangle screenRect,
      NERtcRectangle regionRect, NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByScreenRect, {
      "isChannel": true,
      "channelTag": channelTag,
      "screenRect": screenRect.toJson(),
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int startScreenCaptureByWindowId(int windowId, NERtcRectangle regionRect,
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineStartScreenCaptureByWindowId, {
      "isChannel": true,
      "channelTag": channelTag,
      "windowId": windowId,
      "regionRect": regionRect.toJson(),
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int updateScreenCaptureParameters(
      NERtcScreenCaptureParameters captureParams) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(
        ScreenCaptureMethod.kNERtcEngineUpdateScreenCaptureParameters, {
      "isChannel": true,
      "channelTag": channelTag,
      "captureParams": captureParams.toJson()
    });
  }

  @override
  int updateScreenCaptureRegion(NERtcRectangle regionRect) {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Android and iOS not support.");
      return 30004;
    }
    return Invoke_(ScreenCaptureMethod.kNERtcEngineUpdateScreenCaptureRegion, {
      "isChannel": true,
      "channelTag": channelTag,
      "regionRect": regionRect.toJson()
    });
  }

  @override
  void onAiData(String channelTag, String type, String data) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onAiData: type:$type, data:$data');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAiData(type, data);
    }
  }

  @override
  void onApiCallExecuted(
      String channelTag, String apiName, int result, String message) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onApiCallExecuted: apiName:$apiName, result:$result, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onApiCallExecuted(apiName, result, message);
    }
  }

  @override
  void onAsrCaptionResult(
      String channelTag, List<Map<Object?, Object?>?> result, int resultCount) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onAsrCaptionResult: resultCount:$resultCount');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAsrCaptionResult(result, resultCount);
    }
  }

  @override
  void onAsrCaptionStateChanged(
      String channelTag, int asrState, int code, String message) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onAsrCaptionStateChanged: asrState:$asrState, code:$code, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAsrCaptionStateChanged(asrState, code, message);
    }
  }

  @override
  void onAudioDeviceChanged(String channelTag, int selected) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onAudioDeviceChanged: selected:$selected');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioDeviceChanged(selected);
    }
  }

  @override
  void onAudioDeviceStateChange(
      String channelTag, int deviceType, int deviceState) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onAudioDeviceStateChange: deviceType:$deviceType, deviceState:$deviceState');
    for (var callback in _eventCallbacks.copy()) {
      callback.onAudioDeviceStateChange(deviceType, deviceState);
    }
  }

  @override
  void onCheckNECastAudioDriverResult(String channelTag, int result) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onCheckNECastAudioDriverResult: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onCheckNECastAudioDriverResult(result);
    }
  }

  @override
  void onFirstVideoFrameRender(String channelTag, int userID, int streamType,
      int width, int height, int elapsedTime) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onFirstVideoFrameRender: userID:$userID, streamType:$streamType, width:$width, height:$height, elapsedTime:$elapsedTime');
    for (var callback in _eventCallbacks.copy()) {
      callback.onFirstVideoFrameRender(
          userID, streamType, width, height, elapsedTime);
    }
  }

  @override
  void onLabFeatureCallback(
      String channelTag, String key, Map<Object?, Object?> param) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onLabFeatureCallback: key:$key');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLabFeatureCallback(key, param);
    }
  }

  @override
  void onLocalAudioFirstPacketSent(String channelTag, int audioStreamType) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onLocalAudioFirstPacketSent: audioStreamType:$audioStreamType');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalAudioFirstPacketSent(audioStreamType);
    }
  }

  @override
  void onLocalRecorderError(String channelTag, int error, String taskId) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onLocalRecorderError: error:$error, taskId:$taskId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalRecorderError(error, taskId);
    }
  }

  @override
  void onLocalRecorderStatus(String channelTag, int status, String taskId) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onLocalRecorderStatus: status:$status, taskId:$taskId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalRecorderStatus(status, taskId);
    }
  }

  @override
  void onLocalVideoRenderSizeChanged(
      String channelTag, int videoType, int width, int height) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onLocalVideoRenderSizeChanged: videoType:$videoType, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onLocalVideoRenderSizeChanged(videoType, width, height);
    }
  }

  @override
  void onPlayStreamingFirstAudioFramePlayed(
      String channelTag, String streamId, int timeMs) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onPlayStreamingFirstAudioFramePlayed: streamId:$streamId, timeMs:$timeMs');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingFirstAudioFramePlayed(streamId, timeMs);
    }
  }

  @override
  void onPlayStreamingFirstVideoFrameRender(
      String channelTag, String streamId, int timeMs, int width, int height) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onPlayStreamingFirstVideoFrameRender: streamId:$streamId, timeMs:$timeMs, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingFirstVideoFrameRender(
          streamId, timeMs, width, height);
    }
  }

  @override
  void onPlayStreamingReceiveSeiMessage(
      String channelTag, String streamId, String message) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onPlayStreamingReceiveSeiMessage: streamId:$streamId, message:$message');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingReceiveSeiMessage(streamId, message);
    }
  }

  @override
  void onPlayStreamingStateChange(
      String channelTag, String streamId, int state, int reason) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onPlayStreamingStateChange: streamId:$streamId, state:$state, reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPlayStreamingStateChange(streamId, state, reason);
    }
  }

  @override
  void onPushStreamingReconnectedSuccess(String channelTag) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onPushStreamingReconnectedSuccess');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPushStreamingReconnectedSuccess();
    }
  }

  @override
  void onPushStreamingReconnecting(String channelTag, int reason) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onPushStreamingReconnecting: reason:$reason');
    for (var callback in _eventCallbacks.copy()) {
      callback.onPushStreamingReconnecting(reason);
    }
  }

  @override
  void onReleasedHwResources(String channelTag, int result) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onReleasedHwResources: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onReleasedHwResources(result);
    }
  }

  @override
  void onRemoteVideoSizeChanged(
      String channelTag, int userId, int videoType, int width, int height) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onRemoteVideoSizeChanged: userId:$userId, videoType:$videoType, width:$width, height:$height');
    for (var callback in _eventCallbacks.copy()) {
      callback.onRemoteVideoSizeChanged(userId, videoType, width, height);
    }
  }

  @override
  void onScreenCaptureSourceDataUpdate(
      String channelTag, ScreenCaptureSourceData data) {
    if (this.channelTag != channelTag) return;
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
  void onScreenCaptureStatus(String channelTag, int status) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onScreenCaptureStatus: status:$status');
    for (var callback in _eventCallbacks.copy()) {
      callback.onScreenCaptureStatus(status);
    }
  }

  @override
  void onStartPushStreaming(String channelTag, int result, int channelId) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onStartPushStreaming: result:$result, channelId:$channelId');
    for (var callback in _eventCallbacks.copy()) {
      callback.onStartPushStreaming(result, channelId);
    }
  }

  @override
  void onStopPushStreaming(String channelTag, int result) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onStopPushStreaming: result:$result');
    for (var callback in _eventCallbacks.copy()) {
      callback.onStopPushStreaming(result);
    }
  }

  @override
  void onUserDataBufferedAmountChanged(
      String channelTag, int uid, int previousAmount) {
    if (this.channelTag != channelTag) return;
    commonLogger.i(
        'onUserDataBufferedAmountChanged: uid:$uid, previousAmount:$previousAmount');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataBufferedAmountChanged(uid, previousAmount);
    }
  }

  @override
  void onUserDataReceiveMessage(
      String channelTag, int uid, Uint8List bufferData, int bufferSize) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onUserDataReceiveMessage: uid:$uid, bufferSize:$bufferSize');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataReceiveMessage(uid, bufferData, bufferSize);
    }
  }

  @override
  void onUserDataStart(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserDataStart: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStart(uid);
    }
  }

  @override
  void onUserDataStateChanged(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserDataStateChanged: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStateChanged(uid);
    }
  }

  @override
  void onUserDataStop(String channelTag, int uid) {
    if (this.channelTag != channelTag) return;
    commonLogger.i('onUserDataStop: uid:$uid');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserDataStop(uid);
    }
  }

  @override
  void onUserVideoProfileUpdate(String channelTag, int uid, int maxProfile) {
    if (this.channelTag != channelTag) return;
    commonLogger
        .i('onUserVideoProfileUpdate: uid:$uid, maxProfile:$maxProfile');
    for (var callback in _eventCallbacks.copy()) {
      callback.onUserVideoProfileUpdate(uid, maxProfile);
    }
  }
}
