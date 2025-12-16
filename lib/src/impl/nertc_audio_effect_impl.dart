// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcAudioEffectMgrImpl extends NERtcAudioEffectManager
    with _SDKLoggerMixin, LoggingApi {
  final _platform = NERtcAudioEffectPlatform.instance;
  final _audioEffectEventCallbacks = <NERtcAudioEffectEventCallback>{};

  List<NERtcAudioEffectEventCallback> get audioEffectEventCallbacks =>
      _audioEffectEventCallbacks.toList();

  _NERtcAudioEffectMgrImpl();

  @override
  String get logTag => 'AudioEffectApi';

  @override
  Future<int> pauseAllEffect() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('pauseAllEffect', _platform.pauseAllEffect());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEnginePauseAllEffects, {});
    }
  }

  @override
  Future<int> pauseEffect(int effectId) async {
    apiLogger.i('pauseEffect#arg{effectId:$effectId}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('pauseEffect', _platform.pauseEffect(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEnginePauseAudioEffect, {"effectId": effectId});
    }
  }

  @override
  Future<int> playEffect(int effectId, NERtcAudioEffectOptions options) async {
    apiLogger.i('playEffect#arg{effectId:$effectId,options:$options}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('playEffect', _platform.playEffect(effectId, options));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineStartAudioEffect,
          {"effectId": effectId, "options": options.toJson()});
    }
  }

  @override
  Future<int> resumeAllEffect() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('resumeAllEffect', _platform.resumeAllEffect());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineResumeAllEffects, {});
    }
  }

  @override
  Future<int> resumeEffect(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('resumeEffect', _platform.resumeEffect(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineResumeEffect, {"effectId": effectId});
    }
  }

  @override
  Future<int> stopAllEffects() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('stopAllEffects', _platform.stopAllEffects());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineStopAllAudioEffects, {});
    }
  }

  @override
  Future<int> stopEffect(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('stopEffect', _platform.stopEffect(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineStopAudioEffect, {"effectId": effectId});
    }
  }

  @override
  Future<int> getEffectCurrentPosition(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getEffectCurrentPosition',
          _platform.getEffectCurrentPosition(effectId));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineGetEffectCurrentPosition,
          {"effectId": effectId});
    }
  }

  @override
  Future<int> getEffectDuration(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'getEffectDuration', _platform.getEffectDuration(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineGetEffectDuration, {"effectId": effectId});
    }
  }

  @override
  Future<int> getEffectPitch(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('getEffectPitch', _platform.getEffectPitch(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineGetEffectPitch, {"effectId": effectId});
    }
  }

  @override
  Future<int> getEffectPlaybackVolume(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getEffectPlaybackVolume',
          _platform.getEffectPlaybackVolume(effectId));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineGetEffectPlaybackVolume,
          {"effectId": effectId});
    }
  }

  @override
  Future<int> getEffectSendVolume(int effectId) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'getEffectSendVolume', _platform.getEffectSendVolume(effectId));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineGetEffectSendVolume, {"effectId": effectId});
    }
  }

  @override
  Future<int> setEffectPitch(int effectId, int pitch) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setEffectPitch', _platform.setEffectPitch(effectId, pitch));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetEffectPitch,
          {"effectId": effectId, "pitch": pitch});
    }
  }

  @override
  Future<int> setEffectPlaybackVolume(int effectId, int volume) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setEffectPlaybackVolume',
          _platform.setEffectPlaybackVolume(effectId, volume));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetEffectPlaybackVolume,
          {"effectId": effectId, "volume": volume});
    }
  }

  @override
  Future<int> setEffectPosition(int effectId, int position) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setEffectPosition', _platform.setEffectPosition(effectId, position));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetEffectPosition,
          {"effectId": effectId, "position": position});
    }
  }

  @override
  Future<int> setEffectSendVolume(int effectId, int volume) async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setEffectSendVolume',
          _platform.setEffectSendVolume(effectId, volume));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetEffectSendVolume,
          {"effectId": effectId, "volume": volume});
    }
  }

  @override
  void setEventCallback(NERtcAudioEffectEventCallback callback) {
    _audioEffectEventCallbacks.add(callback);
  }

  @override
  void removeEventCallback(NERtcAudioEffectEventCallback callback) {
    _audioEffectEventCallbacks.remove(callback);
  }
}
