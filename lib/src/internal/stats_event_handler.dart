// Copyright (c) 2014-2019 NetEase, Inc. All right reserved.

part of nertc;

class _StatsEventHandler with _EventHandler {
  NERtcStatsEventCallback _callback;

  _StatsEventHandler();

  void setCallback(NERtcStatsEventCallback callback) {
    this._callback = callback;
  }

  void _handleOnRtcStats(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onRtcStats(NERtcStats.fromMap(arguments));
  }

  void _handleOnLocalAudioStats(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onLocalAudioStats(NERtcAudioSendStats.fromMap(arguments));
  }

  void _handleOnRemoteAudioStats(MethodCall call) {
    List<dynamic> arguments = call.arguments;
    List<NERtcAudioRecvStats> statsList = new List<NERtcAudioRecvStats>();
    for (Map<dynamic, dynamic> argument in arguments) {
      statsList.add(NERtcAudioRecvStats.fromMap(argument));
    }
    _callback.onRemoteAudioStats(statsList);
  }

  void _handleOnLocalVideoStats(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onLocalVideoStats(NERtcVideoSendStats.fromMap(arguments));
  }

  void _handleOnRemoteVideoStats(MethodCall call) {
    List<dynamic> arguments = call.arguments;
    List<NERtcVideoRecvStats> statsList = new List<NERtcVideoRecvStats>();
    for (Map<dynamic, dynamic> argument in arguments) {
      statsList.add(NERtcVideoRecvStats.fromMap(argument));
    }
    _callback.onRemoteVideoStats(statsList);
  }

  void _handleOnNetworkQuality(MethodCall call) {
    List<dynamic> arguments = call.arguments;
    List<NERtcNetworkQualityInfo> statsList =
        new List<NERtcNetworkQualityInfo>();
    for (Map<dynamic, dynamic> argument in arguments) {
      statsList.add(NERtcNetworkQualityInfo.fromMap(argument));
    }
    _callback.onNetworkQuality(statsList);
  }

  @override
  bool handler(MethodCall call) {
    if (_callback == null) return false;
    switch (call.method) {
      case 'onRtcStats':
        _handleOnRtcStats(call);
        return true;
      case 'onLocalAudioStats':
        _handleOnLocalAudioStats(call);
        return true;
      case 'onRemoteAudioStats':
        _handleOnRemoteAudioStats(call);
        return true;
      case 'onLocalVideoStats':
        _handleOnLocalVideoStats(call);
        return true;
      case 'onRemoteVideoStats':
        _handleOnRemoteVideoStats(call);
        return true;
      case 'onNetworkQuality':
        _handleOnNetworkQuality(call);
        return true;
      default:
        return false;
    }
  }
}
