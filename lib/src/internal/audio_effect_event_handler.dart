// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

class _AudioEffectEventHandler with _EventHandler {
  NERtcAudioEffectEventCallback _callback;

  _AudioEffectEventHandler();

  void setCallback(NERtcAudioEffectEventCallback callback) {
    this._callback = callback;
  }

  void _handleOnAudioEffectFinished(MethodCall call) {
    Map values = call.arguments;
    _callback?.onAudioEffectFinished(values['effectId']);
  }

  @override
  bool handler(MethodCall call) {
    if (_callback == null) return false;
    switch (call.method) {
      case 'onAudioEffectFinished':
        _handleOnAudioEffectFinished(call);
        return true;
      default:
        return false;
    }
  }
}
