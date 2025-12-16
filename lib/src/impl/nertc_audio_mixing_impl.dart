// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcAudioMixingMgrImpl extends NERtcAudioMixingManager
    with _SDKLoggerMixin, LoggingApi {
  final _platform = NERtcAudioMixingPlatform.instance;
  final _audioMixingEventCallbacks = <NERtcAudioMixingEventCallback>{};

  _NERtcAudioMixingMgrImpl();

  List<NERtcAudioMixingEventCallback> get audioMixingEventCallbacks =>
      _audioMixingEventCallbacks.toList();

  @override
  String get logTag => 'AudioMixingApi';

  @override
  void setEventCallback(NERtcAudioMixingEventCallback callback) {
    _audioMixingEventCallbacks.add(callback);
  }

  @override
  void removeEventCallback(NERtcAudioMixingEventCallback callback) {
    _audioMixingEventCallbacks.remove(callback);
  }

  @override
  Future<int> getAudioMixingCurrentPosition() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getAudioMixingCurrentPosition',
          _platform.getAudioMixingCurrentPosition());
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineGetAudioMixingCurrentPosition, null);
    }
  }

  @override
  Future<int> getAudioMixingDuration() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'getAudioMixingDuration', _platform.getAudioMixingDuration());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineGetAudioMixingDuration, null);
    }
  }

  @override
  Future<int> getAudioMixingPitch() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('getAudioMixingPitch', _platform.getAudioMixingPitch());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineGetAudioMixingPitch, null);
    }
  }

  @override
  Future<int> getAudioMixingPlaybackVolume() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('getAudioMixingPlaybackVolume',
          _platform.getAudioMixingPlaybackVolume());
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineGetAudioMixingPlaybackVolume, null);
    }
  }

  @override
  Future<int> getAudioMixingSendVolume() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'getAudioMixingSendVolume', _platform.getAudioMixingSendVolume());
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineGetAudioMixingSendVolume, null);
    }
  }

  @override
  Future<int> pauseAudioMixing() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('pauseAudioMixing', _platform.pauseAudioMixing());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEnginePauseAudioMixing
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> resumeAudioMixing() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('resumeAudioMixing', _platform.resumeAudioMixing());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineResumeAudioMixing
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setAudioMixingPitch(int pitch) async {
    apiLogger.i('setAudioMixingPitch#arg{pitch:$pitch}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioMixingPitch', _platform.setAudioMixingPitch(pitch));
      return reply;
    } else {
      return Invoke_(
          InvokeMethod.kNERtcEngineSetAudioMixingPitch, {"pitch": pitch});
    }
  }

  @override
  Future<int> setAudioMixingPlaybackVolume(int volume) async {
    apiLogger.i('setAudioMixingPlaybackVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setAudioMixingPlaybackVolume',
          _platform.setAudioMixingPlaybackVolume(volume));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetAudioMixingPlaybackVolume,
          {"volume": volume});
    }
  }

  @override
  Future<int> setAudioMixingPosition(int position) async {
    apiLogger.i('setAudioMixingPosition#arg{position:$position}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioMixingPosition', _platform.setAudioMixingPosition(position));
      return reply;
    } else {
      return Invoke_(InvokeMethod.kNERtcEngineSetAudioMixingPosition,
          {"position": position});
    }
  }

  @override
  Future<int> setAudioMixingSendVolume(int volume) async {
    apiLogger.i('setAudioMixingSendVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setAudioMixingSendVolume',
          _platform.setAudioMixingSendVolume(volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineSetAudioMixingSendVolume,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> startAudioMixing(NERtcAudioMixingOptions options) async {
    apiLogger.i('startAudioMixing#arg{options:$options}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'startAudioMixing', _platform.startAudioMixing(options));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStartAudioMixing,
        "options": options.toJson()
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> stopAudioMixing() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('stopAudioMixing', _platform.stopAudioMixing());
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcEngineStopAudioMixing
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }
}
