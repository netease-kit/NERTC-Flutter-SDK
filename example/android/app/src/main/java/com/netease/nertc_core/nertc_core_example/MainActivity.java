// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
package com.netease.nertc_core.nertc_core_example;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  MethodChannel foregroundServiceChannel;

  @Override
  protected void onDestroy() {
    super.onDestroy();
    foregroundServiceChannel.setMethodCallHandler(null);
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    foregroundServiceChannel =
        new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(),
            "com.netease.nertc_core.nertc_core_example.foreground_service");
    foregroundServiceChannel.setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("startForegroundService")) {
            CallForegroundService.start(this, new ForegroundServiceConfig());
            result.success(null);
          } else if (call.method.equals("cancelForegroundService")) {
            CallForegroundService.cancel(this);
            result.success(null);
          } else {
            result.notImplemented();
          }
        });
  }
}
