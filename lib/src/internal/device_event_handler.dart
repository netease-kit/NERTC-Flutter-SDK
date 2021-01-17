// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

class _DeviceEventHandler with _EventHandler {
  NERtcDeviceEventCallback _callback;

  _DeviceEventHandler();

  void setCallback(NERtcDeviceEventCallback callback) {
    this._callback = callback;
  }

  @override
  bool handler(MethodCall call) {
    if (_callback == null) return false;
    switch (call.method) {
      case 'onAudioDeviceChanged':
        _handleOnAudioDeviceChanged(call);
        return true;
      case 'onAudioDeviceStateChange':
        _handleOnAudioDeviceStateChange(call);
        return true;
      case 'onVideoDeviceStateChange':
        _handleOnVideoDeviceStageChange(call);
        return true;
      case 'onAudioHasHowling':
        _handleOnAudioHasHowling(call);
        return true;
      default:
        return false;
    }
  }

  void _handleOnAudioHasHowling(call) {
    _callback.onAudioHasHowling();
  }
  void _handleOnAudioDeviceChanged(MethodCall call) {
    Map arguments = call.arguments;
    _callback.onAudioDeviceChanged(arguments['selected']);
  }

  void _handleOnAudioDeviceStateChange(call) {
    Map arguments = call.arguments;
    _callback.onAudioDeviceStateChange(
        arguments['deviceType'], arguments['deviceState']);
  }

  void _handleOnVideoDeviceStageChange(call) {
    Map arguments = call.arguments;
    _callback.onVideoDeviceStageChange(arguments['deviceState']);
  }
}
