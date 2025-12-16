// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class Config {
  //your appkey
  static const String APP_KEY = 'your AppKey';
  static const String DEBUG_APP_KEY = 'your AppKey';
}

class UrlStore {
  static final UrlStore _instance = UrlStore._internal();

  factory UrlStore() {
    return _instance;
  }

  UrlStore._internal() : _url = '';

  String _url;

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}
