// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 设备管理模块
abstract class NERtcDeviceManager {
  /// 设置设备事件回调
  void setEventCallback(NERtcDeviceEventCallback callback);

  /// 移除设备事件回调
  void removeEventCallback(NERtcDeviceEventCallback callback);

  ///切换前置或后置摄像头
  ///
  ///使用前提：请在调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 方法且开启摄像头之后调用此接口
  ///调用时机：请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用
  ///
  ///注意：
  ///  纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  ///  该方法需要在相机启动后才可调用
  Future<int> switchCamera();

  ///设置摄像头缩放比例。
  ///
  ///通过此接口实现设置摄像头缩放比例前，建议先通过 [getCameraMaxZoom] 接口查看摄像头支持的最大缩放比例，并根据实际需求合理设置需要的缩放比例
  ///
  ///使用前提：请在启用相机后调用此接口
  ///
  ///调用时机：请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用
  ///
  ///注意：
  ///
  /// 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK
  ///
  /// [factor] 摄像头缩放比例
  Future<int> setCameraZoomFactor(double factor);

  ///获取摄像头支持的最大缩放比例。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel]后
  ///
  ///返回: 摄像头支持的最大视频缩放比例
  Future<double> getCameraMaxZoom();

  ///设置是否打开闪光灯。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 后
  ///
  /// [on] 是否打开闪光灯。true：打开闪光灯。false：关闭闪光灯。
  ///
  /// 返回 0:成功 1: 失败 2:设备不支持闪光灯
  Future<int> setCameraTorchOn(bool on);

  ///设置摄像头的手动对焦位置。
  ///
  ///通过此接口实现设置摄像头的手动曝光位置前，建议先通过[NERtcDeviceManager.isCameraFocusSupported] 接口检测设备是否支持手动对焦功能
  ///
  ///使用前提：请在启用相机后调用此接口
  ///
  ///调用时机：请在引擎初始化之后调用此接口，且该方法在加入房间前后均可调用
  ///
  ///注意：
  ///
  /// 纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK
  ///
  /// [x] 触摸点相对于视图的横坐标，iOS取值范围为 0 ~ 1,Android取值范围为[-1100,1100]
  ///
  /// [y] 触摸点相对于视图的纵坐标，iOS取值范围为 0 ~ 1,Android取值范围为[-1100,1100]
  Future<int> setCameraFocusPosition(double x, double y);

  ///检测设备当前使用的摄像头是否支持缩放功能。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 后。
  ///
  ///返回  true:设备支持摄像头缩放功能； false: 设备不支持摄像头缩放功能。
  Future<bool> isCameraZoomSupported();

  ///检测设备是否支持闪光灯常亮
  ///
  ///注意：
  ///
  /// 一般情况下，App 默认开启前置摄像头，因此如果设备前置摄像头不支持闪光灯，直接使用该方法会返回 false。如果需要检查后置摄像头是否支持闪光灯，需要先使用 switchCamera 切换摄像头，再使用该方法。
  ///
  /// 该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel]后
  ///
  /// 返回 true：设备支持闪光灯常亮； false：设备不支持闪光灯常亮。
  Future<bool> isCameraTorchSupported();

  ///检测设备是否支持手动对焦功能。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel]后。
  ///
  ///返回 true：设备支持手动对焦功能；false：设备不支持手动对焦功能
  Future<bool> isCameraFocusSupported();

  ///检测设备是否支持手动曝光功能。 该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 后。
  ///返回 true：设置支持手动曝光功能；false：设备不支持手动曝光功能。
  Future<bool> isCameraExposurePositionSupported();

  ///设置是否静音音频播放设备。
  ///
  ///请在初始化后调用该方法，且该方法仅可在加入房间后调用。
  ///
  ///注意：
  ///
  /// 此接口仅静音播放的音频数据，不影响播放设备的运行
  ///
  /// [mute]是否静音音频播放设备
  Future<int> setPlayoutDeviceMute(bool mute);

  ///查看当前音频播放设备是否静音
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<bool> isPlayoutDeviceMute();

  ///设置是否静音音频采集设备
  ///
  ///请在初始化后调用该方法，且该方法仅可在加入房间后调用。
  ///
  ///注意：
  ///
  ///  适用于麦克风采集和伴音同时开启时，只发送伴音音频的场景。
  ///
  /// [mute] 是否静音音频采集设备
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30001（errorFatal）：重复入会或获取房间信息失败。
  ///   * 30005（kNERtcErrInvalidState)：状态错误，比如引擎尚未初始化。
  Future<int> setRecordDeviceMute(bool mute);

  ///查看当前音频采集设备是否静音
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<bool> isRecordDeviceMute();

  ///设置是否由扬声器播放声音。
  ///
  ///通过本接口可以实现设置是否将语音路由到扬声器，即设备外放。
  ///
  /// 注意：若设备连接了耳机或蓝牙，则无法开启外放
  ///
  /// [enable] 是否将音频路由到扬声器：true：启用扬声器播放, false：关闭扬声器播放
  Future<int> setSpeakerphoneOn(bool enable);

  ///检查扬声器状态启用状态。
  ///
  ///返回扬声器是否开启:
  ///
  ///true：扬声器已开启，语音输出到扬声器,
  ///false：扬声器未开启，语音输出到其他音频设备，例如听筒、耳机等
  Future<bool> isSpeakerphoneOn();

  ///开启或关闭耳返
  ///
  /// [enabled] true:开启,false:关闭
  ///
  /// [volume] 耳返音量 [0 - 100]（默认 100）
  Future<int> enableEarback(bool enabled, int volume);

  ///设置耳返音量
  ///
  /// [volume] 耳返音量 [0 - 100]（默认 100）
  Future<int> setEarbackVolume(int volume);

  /// 设置音频焦点模式.
  ///
  /// 目前仅针对 Android 平台
  ///
  /// [focusMode] 焦点模式 [NERtcAudioFocusMode]
  Future<int> setAudioFocusMode(int focusMode);

  ///查看当前摄像头配置。用于查看当前使用的摄像头为前置摄像头还是后置摄像头。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 后
  ///
  ///目前仅针对 Android 平台
  Future<int> getCurrentCamera();

  ///指定前置/后置摄像头。
  ///
  ///该方法需要在相机启动后调用，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.joinChannel] 后。
  ///
  /// [position] 相机类型。详细信息请参考 [NERtcCameraPosition]。该参数为必填参数，若未赋值，SDK 会报错。
  Future<int> switchCameraWithPosition(int position);

  ///设置摄像头的手动曝光位置。
  ///
  ///通过此接口实现设置摄像头的手动曝光位置前，建议先通过 [NERtcDeviceManager.isCameraExposurePositionSupported] 接口检测设备是否支持手动曝光功能。
  ///
  ///请在启用相机后调用此接口，例如调用 [NERtcEngine.startVideoPreview] 或 [NERtcEngine.enableLocalVideo] 之后。
  ///
  ///注意:
  ///
  ///  纯音频 SDK 禁用该接口，如需使用请前往云信官网下载并替换成视频 SDK。
  ///
  /// [x] 触摸点相对于视图的横坐标，iOS取值范围为 0 ~ 1,Android取值范围为[-1100,1100]
  ///
  /// [y] 触摸点相对于视图的纵坐标，iOS取值范围为 0 ~ 1,Android取值范围为[-1100,1100]
  Future<int> setCameraExposurePosition(double x, double y);

  ///目前仅支持 Android 平台
  ///
  ///获取当前摄像头缩放比例。
  ///
  ///返回：当前缩放比例。
  Future<int> getCameraCurrentZoom();

  /// 获取设备控制接口
  ///
  /// [type] 指定设备类型，audio 表示音频设备，video 表示视频设备
  IDeviceCollection? getDeviceCollection(NERtcDeviceType type,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.playout});

  /// 设置设备，包括音频/视频设备
  Future<int> setDevice(NERtcDeviceType type, String deviceId,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture,
      int streamType = NERtcVideoStreamType.main});

  Future<String> queryVideoDevice(int streamType,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture});

  Future<String> queryAudioDevice(int streamType,
      {NERtcDeviceUsage usage = NERtcDeviceUsage.capture});
}

/// 设备事件回调通知
mixin class NERtcDeviceEventCallback {
  ///语音播放设备已改变回调
  ///
  /// [selected] 选择的设备，详细信息请参考 [NERtcAudioDevice]
  void onAudioDeviceChanged(int selected) {}

  ///音频设备状态已改变回调
  ///
  /// [deviceType] 设备类型。详细信息请参考[NERtcAudioDeviceType]
  ///
  /// [deviceState] 设备状态。详细信息请参考 [NERtcAudioDeviceState]
  void onAudioDeviceStateChange(int deviceType, int deviceState) {}

  ///视频设备状态已改变回调。 该回调提示系统视频设备状态发生改变，比如被拔出或移除。如果设备已使用外接摄像头采集，外接摄像头被拔开后，视频会中断
  ///
  /// [deviceState] 设备状态. 详细信息请参考 [NERtcVideoDeviceState]
  ///
  /// [deviceType] 设备类型。详细信息请参考 [NERtcVideoDeviceType]
  void onVideoDeviceStateChange(int deviceType, int deviceState) {}

  ///摄像头曝光区域已改变回调。 该回调是由本地用户调用 [NERtcDeviceManager.setCameraExposurePosition] 方法改变曝光位置触发的
  ///
  /// [exposurePoint] 新的曝光区域位置
  void onCameraExposureChanged(CGPoint exposurePoint) {}

  ///摄像头对焦区域已改变回调。 该回调表示相机的对焦区域发生了改变。 该回调是由本地用户调用 [NERtcDeviceManager.setCameraFocusPosition] 方法改变对焦位置触发的
  ///
  /// [focusPoint] 新的对焦区域位置
  void onCameraFocusChanged(CGPoint focusPoint) {}
}
