// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Cocoa
import FlutterMacOS

class LogPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "log_macos",
      binaryMessenger: registrar.messenger
    )
    let instance = LogPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "log":
      if let message = call.arguments as? String {
        NSLog("%@", message)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Message is required", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
