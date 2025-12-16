// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
package com.netease.nertcflutter;

import android.content.Context;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.netease.nertcflutter.Messages.AudioEffectApi;
import com.netease.nertcflutter.Messages.AudioMixingApi;
import com.netease.nertcflutter.Messages.ChannelApi;
import com.netease.nertcflutter.Messages.DeviceManagerApi;
import com.netease.nertcflutter.Messages.EngineApi;
import com.netease.nertcflutter.Messages.VideoRendererApi;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.view.TextureRegistry;

public class NERtcCorePlugin implements FlutterPlugin, ActivityAware {

  private @Nullable FlutterState flutterState;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterState =
        new FlutterState(
            flutterPluginBinding.getApplicationContext(),
            flutterPluginBinding.getBinaryMessenger(),
            flutterPluginBinding.getTextureRegistry());
    flutterState.startListening();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (flutterState == null) {
      Log.wtf("NERtcPlugin", "Detached from the engine before registering to it.");
      return;
    }
    flutterState.stopListening();
    flutterState = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    if (flutterState != null) {
      flutterState.attachedToActivity(binding);
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    if (flutterState != null) {
      flutterState.detachedFromActivity();
    }
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    if (flutterState != null) {
      flutterState.attachedToActivity(binding);
    }
  }

  @Override
  public void onDetachedFromActivity() {
    if (flutterState != null) {
      flutterState.detachedFromActivity();
    }
  }

  private static final class FlutterState {
    private final BinaryMessenger binaryMessenger;
    private NERtcEngine engine;
    private NERtcChannelImpl channel;
    private SafeMethodChannel callbackChannel;

    FlutterState(
        Context applicationContext, BinaryMessenger messenger, TextureRegistry textureRegistry) {
      this.binaryMessenger = messenger;
      callbackChannel = new SafeMethodChannel(messenger, "flutter.yunxin.163.com/nertc_core");
      this.engine =
          new NERtcEngine(
              applicationContext, messenger, callbackChannel::invokeMethod, textureRegistry);
      this.channel = new NERtcChannelImpl(applicationContext, messenger);
      NERtcChannelManager.getInstance().setBinaryMessager(messenger);
    }

    void startListening() {
      EngineApi.setup(binaryMessenger, engine);
      ChannelApi.setup(binaryMessenger, channel);
      AudioMixingApi.setup(binaryMessenger, engine);
      AudioEffectApi.setup(binaryMessenger, engine);
      DeviceManagerApi.setup(binaryMessenger, engine);
      VideoRendererApi.setup(binaryMessenger, engine);
    }

    void stopListening() {
      EngineApi.setup(binaryMessenger, null);
      ChannelApi.setup(binaryMessenger, null);
      AudioMixingApi.setup(binaryMessenger, null);
      AudioEffectApi.setup(binaryMessenger, null);
      DeviceManagerApi.setup(binaryMessenger, null);
      VideoRendererApi.setup(binaryMessenger, null);
    }

    void attachedToActivity(@NonNull ActivityPluginBinding binding) {
      if (engine != null) {
        engine.setActivity(binding.getActivity());
        engine.setActivityResultListener(
            binding::addActivityResultListener, binding::removeActivityResultListener);
      }
      if (channel != null) {
        channel.setActivity(binding.getActivity());
        channel.setActivityResultListener(
            binding::addActivityResultListener, binding::removeActivityResultListener);
      }
    }

    void detachedFromActivity() {
      if (engine != null) {
        engine.setActivity(null);
        engine.setActivityResultListener(null, null);
      }
      if (channel != null) {
        channel.setActivity(null);
        channel.setActivityResultListener(null, null);
      }
    }
  }
}
