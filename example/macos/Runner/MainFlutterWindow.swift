// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Cocoa
import FlutterMacOS
import Foundation

class MainFlutterWindow: NSWindow {
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    PermissionPlugin.register(with: flutterViewController.registrar(forPlugin: "PermissionPlugin"))
    LogPlugin.register(with: flutterViewController.registrar(forPlugin: "LogPlugin"))
    super.awakeFromNib()
  }
}
