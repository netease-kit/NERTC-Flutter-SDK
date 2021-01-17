// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

class _ChannelEventHandler with _EventHandler {
  NERtcChannelEventCallback _callback;

  _ChannelEventHandler();

  void setCallback(NERtcChannelEventCallback callback) {
    this._callback = callback;
  }

  @override
  bool handler(MethodCall call) {
    if (_callback == null) return false;
    switch (call.method) {
      case 'onJoinChannel':
        _handleOnJoinChannel(call);
        return true;
      case 'onLeaveChannel':
        _handleOnLeaveChannel(call);
        return true;
      case 'onUserJoined':
        _handleOnUserJoined(call);
        return true;
      case 'onUserLeave':
        _handleOnUserLeave(call);
        return true;
      case 'onUserAudioStart':
        _handleOnUserAudioStart(call);
        return true;
      case 'onUserAudioStop':
        _handleOnUserAudioStop(call);
        return true;
      case 'onUserVideoStart':
        _handleOnUserVideoStart(call);
        return true;
      case 'onUserVideoStop':
        _handleOnUserVideoStop(call);
        return true;
      case 'onDisconnect':
        _handleOnDisconnect(call);
        return true;
      case 'onUserAudioMute':
        _handleOnUserAudioMute(call);
        return true;
      case 'onUserVideoMute':
        _handleOnUserVideoMute(call);
        return true;
      case 'onFirstAudioDataReceived':
        _handleOnFirstAudioDataReceived(call);
        return true;
      case 'onFirstVideoDataReceived':
        _handleOnFirstVideoDataReceived(call);
        return true;
      case 'onFirstAudioFrameDecoded':
        _handleOnFirstAudioFrameDecoded(call);
        return true;
      case 'onFirstVideoFrameDecoded':
        _handleOnFirstVideoFrameDecoded(call);
        return true;
      case 'onUserVideoProfileUpdate':
        _handleOnUserVideoProfileUpdate(call);
        return true;
      case 'onConnectionTypeChanged':
        _handleOnConnectionTypeChanged(call);
        return true;
      case 'onReJoinChannel':
        _handleOnReJoinChannel(call);
        return true;
      case 'onReconnectingStart':
        _handleOnReconnectingStart(call);
        return true;
      case 'onLocalAudioVolumeIndication':
        _handleOnLocalAudioVolumeIndication(call);
        return true;
      case 'onRemoteAudioVolumeIndication':
        _handleOnRemoteAudioVolumeIndication(call);
        return true;
      case 'onConnectionStateChanged':
        _handleOnConnectionStateChanged(call);
        return true;
      case 'onLiveStreamState':
        _handleOnLiveStreamState(call);
        return true;
      case 'onError':
        _handleOnError(call);
        return true;
      case 'onWarning':
        _handleOnWarning(call);
        return true;
      case 'onClientRoleChange':
        _handleOnClientRoleChange(call);
        return true;
      case 'onUserSubStreamVideoStart':
        _handleOnUserSubStreamVideoStart(call);
        return true;
      case 'onUserSubStreamVideoStop':
        _handleOnUserSubStreamVideoStop(call);
        return true;
      default:
        return false;
    }
  }

  void _handleOnClientRoleChange(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onClientRoleChange(arguments['oldRole'], arguments['newRole']);
  }

  void _handleOnUserSubStreamVideoStart(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserSubStreamVideoStart(arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnUserSubStreamVideoStop(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserSubStreamVideoStop(arguments['uid']);
  }

  void _handleOnJoinChannel(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onJoinChannel(
        arguments['result'], arguments['channelId'], arguments['elapsed']);
  }

  void _handleOnLeaveChannel(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onLeaveChannel(arguments['result']);
  }

  void _handleOnUserJoined(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserJoined(arguments['uid']);
  }

  void _handleOnUserLeave(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserLeave(arguments['uid'], arguments['reason']);
  }

  void _handleOnUserAudioStart(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserAudioStart(arguments['uid']);
  }

  void _handleOnUserAudioStop(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserAudioStop(arguments['uid']);
  }

  void _handleOnUserVideoStart(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserVideoStart(arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnUserVideoStop(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserVideoStop(arguments['uid']);
  }

  void _handleOnDisconnect(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onDisconnect(arguments['reason']);
  }

  void _handleOnUserAudioMute(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserAudioMute(arguments['uid'], arguments['muted']);
  }

  void _handleOnUserVideoMute(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserVideoMute(arguments['uid'], arguments['muted']);
  }

  void _handleOnFirstAudioDataReceived(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onFirstAudioDataReceived(arguments['uid']);
  }

  void _handleOnFirstVideoDataReceived(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onFirstVideoDataReceived(arguments['uid']);
  }

  void _handleOnFirstAudioFrameDecoded(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onFirstAudioFrameDecoded(arguments['uid']);
  }

  void _handleOnFirstVideoFrameDecoded(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onFirstVideoFrameDecoded(
        arguments['uid'], arguments['width'], arguments['height']);
  }

  void _handleOnUserVideoProfileUpdate(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onUserVideoProfileUpdate(
        arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnConnectionTypeChanged(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onConnectionTypeChanged(arguments['newConnectionType']);
  }

  void _handleOnReJoinChannel(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onReJoinChannel(arguments['result']);
  }

  void _handleOnReconnectingStart(MethodCall call) {
    _callback.onReconnectingStart();
  }

  void _handleOnLocalAudioVolumeIndication(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onLocalAudioVolumeIndication(arguments['volume']);
  }

  void _handleOnRemoteAudioVolumeIndication(MethodCall call) {
    Map arguments = call.arguments;
    dynamic volumeArray = arguments['volumeList'];
    List<NERtcAudioVolumeInfo> volumeList = new List<NERtcAudioVolumeInfo>();
    for (Map<dynamic, dynamic> argument in volumeArray) {
      volumeList.add(NERtcAudioVolumeInfo.fromMap(argument));
    }
    _callback.onRemoteAudioVolumeIndication(
        volumeList, arguments['totalVolume']);
  }

  void _handleOnConnectionStateChanged(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onConnectionStateChanged(arguments['state'], arguments['reason']);
  }

  void _handleOnLiveStreamState(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onLiveStreamState(
        arguments['taskId'], arguments['pushUrl'], arguments['liveState']);
  }

  void _handleOnError(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onError(arguments['code']);
  }

  void _handleOnWarning(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onWarning(arguments['code']);
  }
}
