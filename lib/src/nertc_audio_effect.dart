// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

///音效管理模块
class NERtcAudioEffectManager {
  final _AudioEffectEventHandler _handler = _AudioEffectEventHandler();

  NERtcAudioEffectManager._();

  _EventHandler _eventHandler() => _handler;

  AudioEffectApi _api = AudioEffectApi();

  /// 设置音效事件回调
  Future<int> setEventCallback(NERtcAudioEffectEventCallback callback) async {
    assert(callback != null);
    _handler.setCallback(callback);
    IntValue reply = await _api.setAudioEffectEventCallback();
    return reply.value;
  }

  /// 取消音效事件回调
  Future<int> clearEventCallback() async {
    _handler.setCallback(null);
    IntValue reply = await _api.clearAudioEffectEventCallback();
    return reply.value;
  }

  /// 播放指定音效文件
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  /// [options] 音效设置参数
  Future<int> playEffect(int effectId, NERtcAudioEffectOptions options) async {
    assert(effectId != null);
    IntValue reply = await _api.playEffect(PlayEffectRequest()
      ..effectId = effectId
      ..path = options?.path
      ..loopCount = options?.loopCount
      ..sendEnabled = options?.sendEnabled
      ..sendVolume = options?.sendVolume
      ..playbackEnabled = options?.playbackEnabled
      ..playbackVolume = options?.playbackVolume);
    return reply.value;
  }

  /// 停止播放指定音效文件
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> stopEffect(int effectId) async {
    assert(effectId != null);
    IntValue reply = await _api.stopEffect(IntValue()..value = effectId);
    return reply.value;
  }

  /// 停止播放所有音效文件
  Future<int> stopAllEffects() async {
    IntValue reply = await _api.stopAllEffects();
    return reply.value;
  }

  /// 暂停音效文件播放
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> pauseEffect(int effectId) async {
    assert(effectId != null);
    IntValue reply = await _api.pauseEffect(IntValue()..value = effectId);
    return reply.value;
  }

  /// 暂停所有音效文件播放
  Future<int> pauseAllEffect() async {
    IntValue reply = await _api.pauseAllEffects();
    return reply.value;
  }

  /// 恢复播放指定音效文件
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> resumeEffect(int effectId) async {
    assert(effectId != null);
    IntValue reply = await _api.resumeEffect(IntValue()..value = effectId);
    return reply.value;
  }

  /// 恢复播放所有音效文件
  Future<int> resumeAllEffect() async {
    IntValue reply = await _api.resumeAllEffects();
    return reply.value;
  }

  /// 设置音效文件发送音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  /// [volume] 发送音量[0 - 100]（默认 100）
  Future<int> setEffectSendVolume(int effectId, int volume) async {
    assert(effectId != null);
    assert(volume != null);
    IntValue reply = await _api.setEffectSendVolume(SetEffectSendVolumeRequest()
      ..effectId = effectId
      ..volume = volume);
    return reply.value;
  }

  /// 获取音效文件发送音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectSendVolume(int effectId) async {
    assert(effectId != null);
    IntValue reply =
        await _api.getEffectPlaybackVolume(IntValue()..value = effectId);
    return reply.value;
  }

  /// 设置音效文件播放音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  /// [volume] 发送音量[0 - 100]（默认 100）
  Future<int> setEffectPlaybackVolume(int effectId, int volume) async {
    assert(effectId != null);
    assert(volume != null);
    IntValue reply =
        await _api.setEffectPlaybackVolume(SetEffectPlaybackVolumeRequest()
          ..effectId = effectId
          ..volume = volume);
    return reply.value;
  }

  /// 获取音效文件播放音量
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectPlaybackVolume(int effectId) async {
    assert(effectId != null);
    IntValue reply =
        await _api.getEffectPlaybackVolume(IntValue()..value = effectId);
    return reply.value;
  }
}


/// 音效构造参数类
class NERtcAudioEffectOptions {
  const NERtcAudioEffectOptions(
      {this.path,
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
