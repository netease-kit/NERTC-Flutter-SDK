// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

///音效管理模块
class NERtcAudioEffectManager {
  final _AudioEffectEventHandler _handler = _AudioEffectEventHandler();

  NERtcAudioEffectManager._();

  _EventHandler _eventHandler() => _handler;

  AudioEffectApi _api = AudioEffectApi();

  /// 设置音效事件回调
  Future<int> setEventCallback(NERtcAudioEffectEventCallback callback) async {
    _handler.setCallback(callback);
    IntValue reply = await _api.setAudioEffectEventCallback();
    return reply.value ?? -1;
  }

  /// 取消音效事件回调
  Future<int> clearEventCallback() async {
    _handler.setCallback(null);
    IntValue reply = await _api.clearAudioEffectEventCallback();
    return reply.value ?? -1;
  }

  /// 播放指定音效文件。
  ///
  /// 该方法播放指定的本地或在线音效文件。
  ///
  /// - 成功调用该方法后，如果播放结束，本地会触发 onAudioEffectFinished 回调。
  /// - 支持的音效文件类型包括 MP3、M4A、AAC、3GP、WMA 和 WAV 格式，支持本地文件和在线 URL。
  ///
  /// 请在加入房间后调用该方法。
  /// 您可以多次调用该方法，通过传入不同的音效文件的 effectId 和option ，同时播放多个音效文件，实现音效叠加。为获得最佳用户体验，建议同时播放的音效文件不超过 3 个。
  /// 指定音效的[effectId],每个音效均应有唯一的 ID。
  /// 音效相关参数 [option],包括混音任务类型、混音文件路径等。详细信息请参考 [NERtcCreateAudioEffectOption]。
  /// 如果成功返回 `0`。
  Future<int> playEffect(int effectId, NERtcAudioEffectOptions options) async {
    IntValue reply = await _api.playEffect(PlayEffectRequest()
      ..effectId = effectId
      ..path = options.path
      ..loopCount = options.loopCount
      ..sendEnabled = options.sendEnabled
      ..sendVolume = options.sendVolume
      ..playbackEnabled = options.playbackEnabled
      ..playbackVolume = options.playbackVolume);
    return reply.value ?? -1;
  }

  /// 停止播放指定音效文件
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> stopEffect(int effectId) async {
    IntValue reply = await _api.stopEffect(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 停止播放所有音效文件
  Future<int> stopAllEffects() async {
    IntValue reply = await _api.stopAllEffects();
    return reply.value ?? -1;
  }

  /// 暂停音效文件播放
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> pauseEffect(int effectId) async {
    IntValue reply = await _api.pauseEffect(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 暂停所有音效文件播放
  Future<int> pauseAllEffect() async {
    IntValue reply = await _api.pauseAllEffects();
    return reply.value ?? -1;
  }

  /// 恢复播放指定音效文件
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> resumeEffect(int effectId) async {
    IntValue reply = await _api.resumeEffect(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 恢复播放所有音效文件
  Future<int> resumeAllEffect() async {
    IntValue reply = await _api.resumeAllEffects();
    return reply.value ?? -1;
  }

  /// 设置音效文件发送音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  /// [volume] 发送音量[0 - 100]（默认 100）
  Future<int> setEffectSendVolume(int effectId, int volume) async {
    IntValue reply = await _api.setEffectSendVolume(SetEffectSendVolumeRequest()
      ..effectId = effectId
      ..volume = volume);
    return reply.value ?? -1;
  }

  /// 获取音效文件发送音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectSendVolume(int effectId) async {
    IntValue reply =
        await _api.getEffectPlaybackVolume(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 设置音效文件播放音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  /// [volume] 发送音量[0 - 100]（默认 100）
  Future<int> setEffectPlaybackVolume(int effectId, int volume) async {
    IntValue reply =
        await _api.setEffectPlaybackVolume(SetEffectPlaybackVolumeRequest()
          ..effectId = effectId
          ..volume = volume);
    return reply.value ?? -1;
  }

  /// 获取音效文件播放音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectPlaybackVolume(int effectId) async {
    IntValue reply =
        await _api.getEffectPlaybackVolume(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 获取音效文件时长。
  /// 该方法获取音效文件时长，单位为毫秒。
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectDuration(int effectId) async {
    IntValue reply = await _api.getEffectDuration(IntValue()..value = effectId);
    return reply.value ?? -1;
  }

  /// 获取音效的播放进度。
  /// 该方法获取当前音效播放进度，单位为毫秒。
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectCurrentPosition(int effectId) async {
    IntValue reply =
        await _api.getEffectCurrentPosition(IntValue()..value = effectId);
    return reply.value ?? -1;
  }
}

/// 音效构造参数类
class NERtcAudioEffectOptions {
  const NERtcAudioEffectOptions(
      {required this.path,
      this.loopCount = 1,
      this.sendEnabled = true,
      this.sendVolume = 100,
      this.playbackEnabled = true,
      this.playbackVolume = 100});

  /// 文件地址
  final String path;

  /// 循环次数， <= 0, 表示无限循环，默认 1
  final int loopCount;

  /// 是否发送（默认 true）
  final bool sendEnabled;

  /// 发送音量[0 - 100]（默认 100）
  final int sendVolume;

  /// 是否播放（默认 true）
  final bool playbackEnabled;

  /// 播放音量[0 - 100]（默认 100）
  final int playbackVolume;
}
