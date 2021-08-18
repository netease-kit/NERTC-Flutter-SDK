// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _StatsEventHandler with _EventHandler {
  NERtcStatsEventCallback? _callback;

  _StatsEventHandler();

  void setCallback(NERtcStatsEventCallback? callback) {
    this._callback = callback;
  }

  void _handleOnRtcStats(Map<dynamic, dynamic> arguments) {
    _callback!.onRtcStats(NERtcStats.fromMap(arguments));
  }

  void _handleOnLocalAudioStats(Map<dynamic, dynamic> arguments) {
    _callback!.onLocalAudioStats(NERtcAudioSendStats.fromMap(arguments));
  }

  void _handleOnRemoteAudioStats(Map<dynamic, dynamic> arguments) {
    List<dynamic> argumentList = arguments['list'];
    List<NERtcAudioRecvStats> statsList = <NERtcAudioRecvStats>[];
    for (Map<dynamic, dynamic> argument in argumentList) {
      statsList.add(NERtcAudioRecvStats.fromMap(argument));
    }
    _callback!.onRemoteAudioStats(statsList);
  }

  void _handleOnLocalVideoStats(Map<dynamic, dynamic> arguments) {
    _callback!.onLocalVideoStats(NERtcVideoSendStats.fromMap(arguments));
  }

  void _handleOnRemoteVideoStats(Map<dynamic, dynamic> arguments) {
    List<dynamic> argumentList = arguments['list'];
    var statsList = <NERtcVideoRecvStats>[];
    for (Map<dynamic, dynamic> argument in argumentList) {
      statsList.add(NERtcVideoRecvStats.fromMap(argument));
    }
    _callback!.onRemoteVideoStats(statsList);
  }

  void _handleOnNetworkQuality(Map<dynamic, dynamic> arguments) {
    List<dynamic> argumentList = arguments['list'];
    var statsList = <NERtcNetworkQualityInfo>[];
    for (Map<dynamic, dynamic> argument in argumentList ) {
      statsList.add(NERtcNetworkQualityInfo.fromMap(argument));
    }
    _callback!.onNetworkQuality(statsList);
  }

  @override
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    if (_callback == null) return false;
    switch (method) {
      case 'onRtcStats':
        _handleOnRtcStats(arguments);
        return true;
      case 'onLocalAudioStats':
        _handleOnLocalAudioStats(arguments);
        return true;
      case 'onRemoteAudioStats':
        _handleOnRemoteAudioStats(arguments);
        return true;
      case 'onLocalVideoStats':
        _handleOnLocalVideoStats(arguments);
        return true;
      case 'onRemoteVideoStats':
        _handleOnRemoteVideoStats(arguments);
        return true;
      case 'onNetworkQuality':
        _handleOnNetworkQuality(arguments);
        return true;
      default:
        return false;
    }
  }
}
