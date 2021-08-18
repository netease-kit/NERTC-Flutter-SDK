// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _ChannelEventHandler with _EventHandler {
  NERtcChannelEventCallback? _callback;

  _ChannelEventHandler();

  void setCallback(NERtcChannelEventCallback? callback) {
    this._callback = callback;
  }

  @override
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    if (_callback == null) return false;
    switch (method) {
      case 'onJoinChannel':
        _handleOnJoinChannel(arguments);
        return true;
      case 'onLeaveChannel':
        _handleOnLeaveChannel(arguments);
        return true;
      case 'onUserJoined':
        _handleOnUserJoined(arguments);
        return true;
      case 'onUserLeave':
        _handleOnUserLeave(arguments);
        return true;
      case 'onUserAudioStart':
        _handleOnUserAudioStart(arguments);
        return true;
      case 'onUserAudioStop':
        _handleOnUserAudioStop(arguments);
        return true;
      case 'onUserVideoStart':
        _handleOnUserVideoStart(arguments);
        return true;
      case 'onUserVideoStop':
        _handleOnUserVideoStop(arguments);
        return true;
      case 'onDisconnect':
        _handleOnDisconnect(arguments);
        return true;
      case 'onUserAudioMute':
        _handleOnUserAudioMute(arguments);
        return true;
      case 'onUserVideoMute':
        _handleOnUserVideoMute(arguments);
        return true;
      case 'onFirstAudioDataReceived':
        _handleOnFirstAudioDataReceived(arguments);
        return true;
      case 'onFirstVideoDataReceived':
        _handleOnFirstVideoDataReceived(arguments);
        return true;
      case 'onFirstAudioFrameDecoded':
        _handleOnFirstAudioFrameDecoded(arguments);
        return true;
      case 'onFirstVideoFrameDecoded':
        _handleOnFirstVideoFrameDecoded(arguments);
        return true;
      case 'onUserVideoProfileUpdate':
        _handleOnUserVideoProfileUpdate(arguments);
        return true;
      case 'onConnectionTypeChanged':
        _handleOnConnectionTypeChanged(arguments);
        return true;
      case 'onReJoinChannel':
        _handleOnReJoinChannel(arguments);
        return true;
      case 'onReconnectingStart':
        _handleOnReconnectingStart(arguments);
        return true;
      case 'onLocalAudioVolumeIndication':
        _handleOnLocalAudioVolumeIndication(arguments);
        return true;
      case 'onRemoteAudioVolumeIndication':
        _handleOnRemoteAudioVolumeIndication(arguments);
        return true;
      case 'onConnectionStateChanged':
        _handleOnConnectionStateChanged(arguments);
        return true;
      case 'onLiveStreamState':
        _handleOnLiveStreamState(arguments);
        return true;
      case 'onError':
        _handleOnError(arguments);
        return true;
      case 'onWarning':
        _handleOnWarning(arguments);
        return true;
      case 'onClientRoleChange':
        _handleOnClientRoleChange(arguments);
        return true;
      case 'onUserSubStreamVideoStart':
        _handleOnUserSubStreamVideoStart(arguments);
        return true;
      case 'onUserSubStreamVideoStop':
        _handleOnUserSubStreamVideoStop(arguments);
        return true;
      case 'onAudioHasHowling':
        _handleOnAudioHasHowling(arguments);
        return true;
      case 'onReceiveSEIMsg':
        _handleOnReceiveSEIMsg(arguments);
        return true;
      case 'onAudioRecording':
        _handleOnAudioRecording(arguments);
        return true;
      case 'onMediaRelayStatesChange':
        _handleOnMediaRelayStatesChange(arguments);
        return true;
      case 'onMediaRelayReceiveEvent':
        _handleOnMediaRelayReceiveEvent(arguments);
        return true;
      case 'onLocalPublishFallbackToAudioOnly':
        _handleOnLocalPublishFallbackToAudioOnly(arguments);
        return true;
      case 'onRemoteSubscribeFallbackToAudioOnly':
        _handleOnRemoteSubscribeFallbackToAudioOnly(arguments);
        return true;
      default:
        return false;
    }
  }

  void _handleOnClientRoleChange(Map<dynamic, dynamic> arguments) {
    _callback?.onClientRoleChange(arguments['oldRole'], arguments['newRole']);
  }

  void _handleOnUserSubStreamVideoStart(Map<dynamic, dynamic> arguments) {
    _callback?.onUserSubStreamVideoStart(
        arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnUserSubStreamVideoStop(Map<dynamic, dynamic> arguments) {
    _callback?.onUserSubStreamVideoStop(arguments['uid']);
  }

  void _handleOnJoinChannel(Map<dynamic, dynamic> arguments) {
    _callback?.onJoinChannel(arguments['result'], arguments['channelId'],
        arguments['elapsed'], arguments['uid']);
  }

  void _handleOnLeaveChannel(Map<dynamic, dynamic> arguments) {
    _callback?.onLeaveChannel(arguments['result']);
  }

  void _handleOnUserJoined(Map<dynamic, dynamic> arguments) {
    _callback?.onUserJoined(arguments['uid']);
  }

  void _handleOnUserLeave(Map<dynamic, dynamic> arguments) {
    _callback?.onUserLeave(arguments['uid'], arguments['reason']);
  }

  void _handleOnUserAudioStart(Map<dynamic, dynamic> arguments) {
    _callback?.onUserAudioStart(arguments['uid']);
  }

  void _handleOnUserAudioStop(Map<dynamic, dynamic> arguments) {
    _callback?.onUserAudioStop(arguments['uid']);
  }

  void _handleOnUserVideoStart(Map<dynamic, dynamic> arguments) {
    _callback?.onUserVideoStart(arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnUserVideoStop(Map<dynamic, dynamic> arguments) {
    _callback?.onUserVideoStop(arguments['uid']);
  }

  void _handleOnDisconnect(Map<dynamic, dynamic> arguments) {
    _callback?.onDisconnect(arguments['reason']);
  }

  void _handleOnUserAudioMute(Map<dynamic, dynamic> arguments) {
    _callback?.onUserAudioMute(arguments['uid'], arguments['muted']);
  }

  void _handleOnUserVideoMute(Map<dynamic, dynamic> arguments) {
    _callback?.onUserVideoMute(arguments['uid'], arguments['muted']);
  }

  void _handleOnFirstAudioDataReceived(Map<dynamic, dynamic> arguments) {
    _callback?.onFirstAudioDataReceived(arguments['uid']);
  }

  void _handleOnFirstVideoDataReceived(Map<dynamic, dynamic> arguments) {
    _callback?.onFirstVideoDataReceived(arguments['uid']);
  }

  void _handleOnFirstAudioFrameDecoded(Map<dynamic, dynamic> arguments) {
    _callback?.onFirstAudioFrameDecoded(arguments['uid']);
  }

  void _handleOnFirstVideoFrameDecoded(Map<dynamic, dynamic> arguments) {
    _callback?.onFirstVideoFrameDecoded(
        arguments['uid'], arguments['width'], arguments['height']);
  }

  void _handleOnUserVideoProfileUpdate(Map<dynamic, dynamic> arguments) {
    _callback?.onUserVideoProfileUpdate(
        arguments['uid'], arguments['maxProfile']);
  }

  void _handleOnConnectionTypeChanged(Map<dynamic, dynamic> arguments) {
    _callback?.onConnectionTypeChanged(arguments['newConnectionType']);
  }

  void _handleOnReJoinChannel(Map<dynamic, dynamic> arguments) {
    _callback?.onReJoinChannel(arguments['result']);
  }

  void _handleOnReconnectingStart(Map<dynamic, dynamic> arguments) {
    _callback?.onReconnectingStart();
  }

  void _handleOnLocalAudioVolumeIndication(Map<dynamic, dynamic> arguments) {
    _callback?.onLocalAudioVolumeIndication(arguments['volume']);
  }

  void _handleOnRemoteAudioVolumeIndication(Map<dynamic, dynamic> arguments) {
    dynamic volumeArray = arguments['volumeList'];
    var volumeList = <NERtcAudioVolumeInfo>[];
    for (Map<dynamic, dynamic> argument in volumeArray) {
      volumeList.add(NERtcAudioVolumeInfo.fromMap(argument));
    }
    _callback?.onRemoteAudioVolumeIndication(
        volumeList, arguments['totalVolume']);
  }

  void _handleOnConnectionStateChanged(Map<dynamic, dynamic> arguments) {
    _callback?.onConnectionStateChanged(
        arguments['state'], arguments['reason']);
  }

  void _handleOnLiveStreamState(Map<dynamic, dynamic> arguments) {
    _callback?.onLiveStreamState(
        arguments['taskId'], arguments['pushUrl'], arguments['liveState']);
  }

  void _handleOnError(Map<dynamic, dynamic> arguments) {
    _callback?.onError(arguments['code']);
  }

  void _handleOnWarning(Map<dynamic, dynamic> arguments) {
    _callback?.onWarning(arguments['code']);
  }

  void _handleOnAudioHasHowling(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioHasHowling();
  }

  void _handleOnReceiveSEIMsg(Map<dynamic, dynamic> arguments) {
    _callback?.onReceiveSEIMsg(arguments['uid'], arguments['seiMsg']);
  }

  void _handleOnAudioRecording(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioRecording(arguments['code'], arguments['filePath']);
  }

  void _handleOnMediaRelayStatesChange(Map<dynamic, dynamic> arguments) {
    _callback?.onMediaRelayStatesChange(
        arguments['state'], arguments['channelName']);
  }

  void _handleOnMediaRelayReceiveEvent(Map<dynamic, dynamic> arguments) {
    _callback?.onMediaRelayReceiveEvent(
        arguments['event'], arguments['code'], arguments['channelName']);
  }

  void _handleOnLocalPublishFallbackToAudioOnly(
      Map<dynamic, dynamic> arguments) {
    _callback?.onLocalPublishFallbackToAudioOnly(
        arguments['isFallback'], arguments['streamType']);
  }

  void _handleOnRemoteSubscribeFallbackToAudioOnly(
      Map<dynamic, dynamic> arguments) {
    _callback?.onRemoteSubscribeFallbackToAudioOnly(
        arguments['uid'], arguments['isFallback'], arguments['streamType']);
  }
}
