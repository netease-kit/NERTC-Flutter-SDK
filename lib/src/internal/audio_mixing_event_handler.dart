// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _AudioMixingEventHandler with _EventHandler {
  NERtcAudioMixingEventCallback? _callback;

  _AudioMixingEventHandler();

  void setCallback(NERtcAudioMixingEventCallback? callback) {
    this._callback = callback;
  }

  void _handleOnAudioMixingStateChanged(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioMixingStateChanged(arguments['state']);
  }

  void _handleOnAudioMixingTimestampUpdate(Map<dynamic, dynamic> arguments) {
    _callback?.onAudioMixingTimestampUpdate(arguments['timestampMs']);
  }

  @override
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    if (_callback == null) return false;
    switch (method) {
      case 'onAudioMixingStateChanged':
        _handleOnAudioMixingStateChanged(arguments);
        return true;
      case 'onAudioMixingTimestampUpdate':
        _handleOnAudioMixingTimestampUpdate(arguments);
        return true;
      default:
        return false;
    }
  }
}
