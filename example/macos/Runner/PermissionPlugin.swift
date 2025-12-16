// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import AVFoundation
import FlutterMacOS

class PermissionPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "permission_macos",
      binaryMessenger: registrar.messenger
    )
    let instance = PermissionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestCameraPermission":
      requestCameraPermission(result: result)
    case "requestMicrophonePermission":
      requestMicrophonePermission(result: result)
    case "checkCameraPermission":
      result(checkCameraPermission())
    case "checkMicrophonePermission":
      result(checkMicrophonePermission())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - 摄像头权限

  private func checkCameraPermission() -> Bool {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    return status == .authorized
  }

  private func requestCameraPermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        result(granted)
      }
    }
  }

  // MARK: - 麦克风权限

  private func checkMicrophonePermission() -> Bool {
    let status = AVCaptureDevice.authorizationStatus(for: .audio)
    return status == .authorized
  }

  private func requestMicrophonePermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .audio) { granted in
      DispatchQueue.main.async {
        result(granted)
      }
    }
  }
}
