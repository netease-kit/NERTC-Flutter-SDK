// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 设备管理模块
class NERtcDeviceManager {
  final _DeviceEventHandler _handler = _DeviceEventHandler();

  NERtcDeviceManager._();

  _EventHandler _eventHandler() => _handler;

  DeviceManagerApi _api = DeviceManagerApi();

  /// 设置设备事件回调
  Future<int> setEventCallback(NERtcDeviceEventCallback callback) async {
    _handler.setCallback(callback);
    IntValue reply = await _api.setDeviceEventCallback();
    return reply.value ?? -1;
  }

  /// 取消设备事件回调
  Future<int> clearEventCallback() async {
    _handler.setCallback(null);
    IntValue reply = await _api.clearDeviceEventCallback();
    return reply.value ?? -1;
  }

  /// 获取扬声器是否开启
  Future<bool> isSpeakerphoneOn() async {
    BoolValue reply = await _api.isSpeakerphoneOn();
    return reply.value ?? false;
  }

  /// 设置扬声器是否开启
  Future<int> setSpeakerphoneOn(bool enable) async {
    IntValue reply = await _api.setSpeakerphoneOn(BoolValue()..value = enable);
    return reply.value ?? -1;
  }

  /// 切换摄像头
  Future<int> switchCamera() async {
    IntValue reply = await _api.switchCamera();
    return reply.value ?? -1;
  }

  /// 设置缩放
  Future<int> setCameraZoomFactor(int factor) async {
    IntValue reply = await _api.setCameraZoomFactor(IntValue()..value = factor);
    return reply.value ?? -1;
  }

  /// 获取摄像头支持的最大视频缩放比例
  Future<double> getCameraMaxZoom() async {
    DoubleValue reply = await _api.getCameraMaxZoom();
    return reply.value ?? 0.0;
  }

  /// 开启或关闭闪光灯
  Future<int> setCameraTorchOn(bool on) async {
    IntValue reply = await _api.setCameraTorchOn(BoolValue()..value = on);
    return reply.value ?? -1;
  }

  /// 设置对焦区域
  Future<int> setCameraFocusPosition(double x, double y) async {
    IntValue reply =
        await _api.setCameraFocusPosition(SetCameraFocusPositionRequest()
          ..x = x
          ..y = y);
    return reply.value ?? -1;
  }

  /// 设置是否音频播放静音
  Future<int> setPlayoutDeviceMute(bool mute) async {
    IntValue reply = await _api.setPlayoutDeviceMute(BoolValue()..value = mute);
    return reply.value ?? -1;
  }

  /// 获取当前音频播放设备是否静音
  Future<bool> isPlayoutDeviceMute() async {
    BoolValue reply = await _api.isPlayoutDeviceMute();
    return reply.value ?? false;
  }

  /// 设置是否音频采集静音
  Future<int> setRecordDeviceMute(bool mute) async {
    IntValue reply = await _api.setRecordDeviceMute(BoolValue()..value = mute);
    return reply.value ?? -1;
  }

  /// 获取音频采集设备是否静音
  Future<bool> isRecordDeviceMute() async {
    BoolValue reply = await _api.isRecordDeviceMute();
    return reply.value ?? false;
  }

  ///开启或关闭耳返
  ///
  /// [enabled] true:开启,false:关闭
  /// [volume] 耳返音量 [0 - 100]（默认 100）
  Future<int> enableEarBack(bool enabled, int volume) async {
    IntValue reply = await _api.enableEarback(EnableEarbackRequest()
      ..enabled = enabled
      ..volume = volume);
    return reply.value ?? -1;
  }

  ///设置耳返音量
  ///
  /// [volume] 耳返音量 [0 - 100]（默认 100）
  Future<int> setEarBackVolume(int volume) async {
    IntValue reply = await _api.setEarbackVolume(IntValue()..value = volume);
    return reply.value ?? -1;
  }

  /// 设置音频焦点模式.
  /// 目前仅针对 Android 平台
  ///
  /// [focusMode] 焦点模式 [NERtcAudioFocusMode]
  Future<int> setAudioFocusMode(int focusMode) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      IntValue reply =
          await _api.setAudioFocusMode(IntValue()..value = focusMode);
      return reply.value ?? -1;
    } else {
      return -1;
    }
  }
}
