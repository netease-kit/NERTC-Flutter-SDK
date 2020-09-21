part of nertc;

class _AudioMixingEventHandler with _EventHandler {
  NERtcAudioMixingEventCallback _callback;

  _AudioMixingEventHandler();

  void setCallback(NERtcAudioMixingEventCallback callback) {
    this._callback = callback;
  }

  void _handleOnAudioMixingStateChanged(MethodCall call) {
    Map values = call.arguments;
    _callback?.onAudioMixingStateChanged(values['state']);
  }

  void _handleOnAudioMixingTimestampUpdate(MethodCall call) {
    Map values = call.arguments;
    _callback?.onAudioMixingTimestampUpdate(values['timestampMs']);
  }

  @override
  bool handler(MethodCall call) {
    if (_callback == null) return false;
    switch (call.method) {
      case 'onAudioMixingStateChanged':
        _handleOnAudioMixingStateChanged(call);
        return true;
      case 'onAudioMixingTimestampUpdate':
        _handleOnAudioMixingTimestampUpdate(call);
        return true;
      default:
        return false;
    }
  }
}
