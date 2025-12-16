// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/services.dart';

//macOS release 包控制台打印
class NativeLogHelper {
  static const _channel = MethodChannel('log_macos');

  static void log(String message) {
    if (Platform.isMacOS) {
      _channel.invokeMethod('log', message).catchError((e) {
        // Prevent infinite loop if logging fails
      });
    }
  }
}
