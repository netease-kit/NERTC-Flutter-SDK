// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _AudioEffectEventHandler with _EventHandler {
  NERtcAudioEffectEventCallback? _callback;

  _AudioEffectEventHandler();

  void setCallback(NERtcAudioEffectEventCallback? callback) {
    this._callback = callback;
  }

  void _handleOnAudioEffectFinished(Map<dynamic, dynamic> arguments) {
    int effectId = arguments['effectId'];
    _callback?.onAudioEffectFinished(effectId);
  }

  @override
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    if (_callback == null) return false;
    switch (method) {
      case 'onAudioEffectFinished':
        _handleOnAudioEffectFinished(arguments);
        return true;
      default:
        return false;
    }
  }
}
