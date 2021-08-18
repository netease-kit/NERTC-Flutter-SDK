// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

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
  bool handler(String method, Map<dynamic, dynamic> arguments) {
    switch (method) {
      case 'onOnceEvent':
        _handleOnceEvent(arguments);
        return true;
      default:
        return false;
    }
  }

  void _handleOnceEvent(Map<dynamic, dynamic> arguments) {
    int? serial = arguments['serial'];
    OnceEventCallback? callback = _handlers.remove(serial);
    if (callback != null) callback(arguments['arguments']);
  }
}
