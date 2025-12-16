// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

package com.netease.nertcflutter;

import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import com.netease.lava.nertc.sdk.NERtcEx;
import com.netease.lava.nertc.sdk.channel.NERtcChannel;
import com.netease.lava.nertc.sdk.channel.NERtcChannelCallback;
import com.netease.lava.nertc.sdk.stats.NERtcStatsObserver;
import io.flutter.plugin.common.BinaryMessenger;
import java.util.HashMap;
import java.util.Map;

public class NERtcChannelManager {

  private static final String TAG = "NERtcChannelManager";
  private static volatile NERtcChannelManager instance;

  private final Map<String, NERtcChannel> channelMaps = new HashMap<>();
  private final Map<String, NERtcChannelCallback> callbackMaps = new HashMap<>();
  private final Map<String, NERtcStatsObserver> statsObservers = new HashMap<>();
  private BinaryMessenger messenger;

  public static NERtcChannelManager getInstance() {
    if (instance == null) {
      synchronized (NERtcChannelManager.class) {
        if (instance == null) {
          instance = new NERtcChannelManager();
        }
      }
    }
    return instance;
  }

  public void setBinaryMessager(BinaryMessenger messenger) {
    this.messenger = messenger;
  }

  public long createChannel(@NonNull String channelName) {

    if (TextUtils.isEmpty(channelName)) {
      Log.e(TAG, "Channel name is empty");
      return -1L;
    }

    if (channelMaps.containsKey(channelName)) {
      Log.d(TAG, "Channel already exists: " + channelName);
      return 0L;
    }

    NERtcChannel channel = NERtcEx.getInstance().createChannel(channelName);
    if (channel == null) {
      Log.e(TAG, "Failed to create channel: " + channelName);
      return -1L;
    }

    // 保存到映射表
    channelMaps.put(channelName, channel);
    NERtcSubCallbackImpl callback = new NERtcSubCallbackImpl(channelName, this.messenger);
    channel.setChannelCallback(callback);
    callbackMaps.put(channelName, callback);
    return 0L;
  }

  public NERtcChannel getChannel(String channelName) {
    if (TextUtils.isEmpty(channelName)) {
      return null;
    }
    return channelMaps.get(channelName);
  }

  public NERtcChannelCallback getCallback(String channelName) {
    if (TextUtils.isEmpty(channelName)) {
      return null;
    }
    return callbackMaps.get(channelName);
  }

  public void release(String channelName) {
    if (TextUtils.isEmpty(channelName)) {
      return;
    }
    NERtcChannel channel = channelMaps.remove(channelName);
    if (channel != null) {
      channel.setChannelCallback(null);
      channel.release();
    }
    callbackMaps.remove(channelName);
    statsObservers.remove(channelName);
  }

  public void releaseAll() {

    //遍历所有 channel 并销毁
    for (NERtcChannel channel : channelMaps.values()) {
      if (channel != null) {
        channel.setChannelCallback(null);
        channel.release();
      }
    }

    // 清空所有映射表
    channelMaps.clear();
    callbackMaps.clear();
    statsObservers.clear();
  }

  public NERtcStatsObserver createStatsObserver(String channelName) {
    if (TextUtils.isEmpty(channelName)) {
      Log.e(TAG, "Channel name is empty");
      return null;
    }

    if (statsObservers.containsKey(channelName)) {
      return statsObservers.get(channelName);
    }

    NERtcStatsObserver observer = new NERtcStatsObserverImpl(this.messenger, channelName);
    statsObservers.put(channelName, observer);
    return observer;
  }

  public NERtcStatsObserver getStatsObserver(String channelName) {
    if (TextUtils.isEmpty(channelName)) {
      return null;
    }
    return statsObservers.get(channelName);
  }
}
