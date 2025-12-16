// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class _NERtcDeviceManagerImpl extends NERtcDeviceManager
    with _SDKLoggerMixin, LoggingApi {
  final _platform = NERtcDevicePlatform.instance;

  final _deviceEventCallbacks = <NERtcDeviceEventCallback>{};

  List<NERtcDeviceEventCallback> get deviceEventCallbacks =>
      _deviceEventCallbacks.toList();

  _NERtcDeviceManagerImpl();

  @override
  String get logTag => 'DeviceManagerApi';

  @override
  void setEventCallback(NERtcDeviceEventCallback callback) {
    _deviceEventCallbacks.add(callback);
  }

  @override
  void removeEventCallback(NERtcDeviceEventCallback callback) {
    _deviceEventCallbacks.remove(callback);
  }

  @override
  Future<double> getCameraMaxZoom() async {
    if (Platform.isAndroid || Platform.isIOS) {
      double reply =
          await wrapper('getCameraMaxZoom', _platform.getCameraMaxZoom());
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<bool> isCameraExposurePositionSupported() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply = await wrapper('isCameraExposurePositionSupported',
          _platform.isCameraExposurePositionSupported());
      return reply;
    } else {
      return false; // not support.
    }
  }

  @override
  Future<bool> isCameraFocusSupported() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply = await wrapper(
          'isCameraFocusSupported', _platform.isCameraFocusSupported());
      return reply;
    } else {
      return false; // not suppport.
    }
  }

  @override
  Future<bool> isCameraTorchSupported() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply = await wrapper(
          'isCameraTorchSupported', _platform.isCameraTorchSupported());
      return reply;
    } else {
      return false; // not support.
    }
  }

  @override
  Future<bool> isCameraZoomSupported() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply = await wrapper(
          'isCameraZoomSupported', _platform.isCameraZoomSupported());
      return reply;
    } else {
      return false; // not support.
    }
  }

  @override
  Future<bool> isPlayoutDeviceMute() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply =
          await wrapper('isPlayoutDeviceMute', _platform.isPlayoutDeviceMute());
      return reply;
    } else {
      Map<String, dynamic> convert = {
        "method": InvokeMethod.kNERtcIsPlayoutDeviceMute,
      };
      int reply = InvokeMethod_(jsonEncode(convert));
      return reply == 1;
    }
  }

  @override
  Future<bool> isRecordDeviceMute() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply =
          await wrapper('isRecordDeviceMute', _platform.isRecordDeviceMute());
      return reply;
    } else {
      Map<String, dynamic> convert = {
        "method": InvokeMethod.kNERtcIsRecordDeviceMute
      };
      int reply = InvokeMethod_(jsonEncode(convert));
      return reply == 1;
    }
  }

  @override
  Future<int> setCameraFocusPosition(double x, double y) async {
    apiLogger.i('setCameraFocusPosition#arg{x:$x,y:$y}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setCameraFocusPosition', _platform.setCameraFocusPosition(x, y));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> setCameraTorchOn(bool on) async {
    apiLogger.i('setCameraTorchOn#arg{on:$on}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('setCameraTorchOn', _platform.setCameraTorchOn(on));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> setCameraZoomFactor(double factor) async {
    apiLogger.i('setCameraTorchOn#arg{factor:$factor}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setCameraZoomFactor', _platform.setCameraZoomFactor(factor));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> setPlayoutDeviceMute(bool mute) async {
    apiLogger.i('setPlayoutDeviceMute#arg{mute:$mute}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setPlayoutDeviceMute', _platform.setPlayoutDeviceMute(mute));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetPlayoutDeviceMute,
        "mute": mute
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setRecordDeviceMute(bool mute) async {
    apiLogger.i('setRecordDeviceMute#arg{mute:$mute}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setRecordDeviceMute', _platform.setRecordDeviceMute(mute));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetRecordDeviceMute,
        "mute": mute
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> switchCamera() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('switchCamera', _platform.switchCamera());
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> enableEarback(bool enabled, int volume) async {
    apiLogger.i('enableEarback#arg{enabled:$enabled,volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'enableEarback', _platform.enableEarback(enabled, volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetEarback,
        "enabled": enabled,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<bool> isSpeakerphoneOn() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool reply =
          await wrapper('isSpeakerphoneOn', _platform.isSpeakerphoneOn());
      return reply;
    } else {
      return false;
    }
  }

  @override
  Future<int> setAudioFocusMode(int focusMode) async {
    apiLogger.i('setAudioFocusMode#arg{focusMode:$focusMode}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setAudioFocusMode', _platform.setAudioFocusMode(focusMode));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> setEarbackVolume(int volume) async {
    apiLogger.i('setEarbackVolume#arg{volume:$volume}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('setEarbackVolume', _platform.setEarbackVolume(volume));
      return reply;
    } else {
      Map<String, dynamic> convertJson = {
        "method": InvokeMethod.kNERtcSetEarbackVolume,
        "volume": volume
      };
      int reply = InvokeMethod_(jsonEncode(convertJson));
      return reply;
    }
  }

  @override
  Future<int> setSpeakerphoneOn(bool enable) async {
    apiLogger.i('setSpeakerphoneOn#arg{enable:$enable}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'setSpeakerphoneOn', _platform.setSpeakerphoneOn(enable));
      return reply;
    } else {
      // not support.
      apiLogger.i("setSpeakerphoneOn is not support.");
      return 30004;
    }
  }

  @override
  Future<int> getCameraCurrentZoom() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper(
          'getCameraCurrentZoom', _platform.getCameraCurrentZoom());
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> getCurrentCamera() async {
    if (Platform.isAndroid || Platform.isIOS) {
      int reply =
          await wrapper('getCurrentCamera', _platform.getCurrentCamera());
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> switchCameraWithPosition(int position) async {
    apiLogger.i('switchCameraWithPosition#arg{position:$position}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('switchCameraWithPosition',
          _platform.switchCameraWithPosition(position));
      return reply;
    } else {
      return 30004;
    }
  }

  @override
  Future<int> setCameraExposurePosition(double x, double y) async {
    apiLogger.i('setCameraExposurePosition#arg{x:$x,y:$y}');
    if (Platform.isAndroid || Platform.isIOS) {
      int reply = await wrapper('setCameraExposurePosition',
          _platform.setCameraExposurePosition(x, y));
      return reply;
    } else {
      return 30004; // not support.
    }
  }

  @override
  IDeviceCollection? getDeviceCollection(NERtcDeviceType type,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture}) {
    if (Platform.isIOS || Platform.isAndroid) {
      print("mobile is not support.");
      return null;
    }

    apiLogger.i("getDeviceCollection, type: $type");
    if (type == NERtcDeviceType.audio) {
      return DeviceCollectionImpl(NERtcDeviceType.audio, usage: usage);
    } else {
      return DeviceCollectionImpl(NERtcDeviceType.video, usage: usage);
    }
  }

  @override
  Future<int> setDevice(NERtcDeviceType type, String deviceId,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture,
      int streamType = NERtcVideoStreamType.main}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("mobile is not support.");
      return 30004;
    }

    apiLogger.i("setDevice type: $type, deviceId: $deviceId");
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcSetDevice,
      "type": type.index,
      "deviceId": deviceId,
      "usage": usage.index,
      "streamType": streamType
    };

    int reply = InvokeMethod_(jsonEncode(convertJson));
    return reply;
  }

  @override
  Future<String> queryVideoDevice(int streamType,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("mobile is not support.");
      return "";
    }

    apiLogger.i("queryVideoDevice streamType: $streamType");
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcQueryDevice,
      "streamType": streamType,
      "type": NERtcDeviceType.video.index,
      "usage": usage.index
    };

    String reply = InvokeMethod1_(jsonEncode(convertJson));
    if (reply.isNotEmpty) {
      return jsonDecode(reply)["deviceId"];
    }
    return reply;
  }

  @override
  Future<String> queryAudioDevice(int streamType,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("mobile is not support.");
      return "";
    }

    apiLogger.i("queryAudioDevice streamType: $streamType");
    Map<String, dynamic> convertJson = {
      "method": InvokeMethod.kNERtcQueryDevice,
      "streamType": streamType,
      "type": NERtcDeviceType.audio.index,
      "usage": usage.index
    };

    String reply = InvokeMethod1_(jsonEncode(convertJson));
    if (reply.isNotEmpty) {
      return jsonDecode(reply)["deviceId"];
    }
    return reply;
  }
}
