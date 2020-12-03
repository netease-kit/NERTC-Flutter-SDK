// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

typedef void OnceEventCallback(dynamic args);

class _OnceEventHandler with _EventHandler {
  Map<int, OnceEventCallback> _handlers = {};
  _OnceEventHandler();

  int serial = 0;

  int addOnceCallback(OnceEventCallback callback) {
    _handlers[++serial] = callback;
    return serial;
  }

  @override
  bool handler(MethodCall call) {
    switch (call.method) {
      case 'onOnceEvent':
        _handleOnceEvent(call);
        return true;
      default:
        return false;
    }
  }

  void _handleOnceEvent(MethodCall call) {
    Map arguments = call.arguments;
    int serial = arguments['serial'];
    OnceEventCallback callback = _handlers.remove(serial);
    if (callback != null) callback(arguments['arguments']);
  }
}
