// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _DeviceEventHandler with _EventHandler {
  NERtcDeviceEventCallback? _callback;

  _DeviceEventHandler();

  void setCallback(NERtcDeviceEventCallback? callback) {
    this._callback = callback;
  }

  @override
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    if (_callback == null) return false;
    switch (method) {
      case 'onAudioDeviceChanged':
        _handleOnAudioDeviceChanged(arguments);
        return true;
      case 'onAudioDeviceStateChange':
        _handleOnAudioDeviceStateChange(arguments);
        return true;
      case 'onVideoDeviceStateChange':
        _handleOnVideoDeviceStageChange(arguments);
        return true;
      default:
        return false;
    }
  }

  void _handleOnAudioDeviceChanged(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioDeviceChanged(arguments['selected']);
  }

  void _handleOnAudioDeviceStateChange(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioDeviceStateChange(
        arguments['deviceType'], arguments['deviceState']);
  }

  void _handleOnVideoDeviceStageChange(Map<dynamic, dynamic> arguments) {
    _callback?.onVideoDeviceStageChange(arguments['deviceState']);
  }
}
