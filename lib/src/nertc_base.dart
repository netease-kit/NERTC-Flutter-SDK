// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

/// 音视频通话相关的参数设置
class NERtcOptions {
  const NERtcOptions(
      {this.logDir,
      this.logLevel,
      this.audioAutoSubscribe,
      this.audioDisableOverrideSpeakerOnReceiver,
      this.audioDisableSWAECOnHeadset,
      this.audioAINSEnabled,
      this.serverRecordAudio,
      this.serverRecordVideo,
      this.serverRecordMode,
      this.serverRecordSpeaker,
      this.publishSelfStream,
      this.videoEncodeMode,
      this.videoDecodeMode,
      this.videoCaptureObserverEnabled,
      this.videoSendMode,
      this.videoH265Enabled,
      this.mode1v1Enabled});

  /// 日志路径
  final String? logDir;

  /// 日志等级
  final int? logLevel;

  /// 是否自动订阅音频（默认订阅）
  final bool? audioAutoSubscribe;

  /// 系统切换听筒事件时，禁用切换到扬声器.
  /// 仅在iOS平台有效.
  /// 默认值 false, 如设置 true 则禁止SDK在系统切换到听筒时做切换扬声器操作，需要用户自己处理切换听筒事件
  final bool? audioDisableOverrideSpeakerOnReceiver;

  /// 设置耳机时不使用软件回声消除功能
  /// 仅在iOS平台有效.
  /// 默认值 false,如设置true 则SDK在耳机模式下不使用软件回声消除功能，会对某些机型下 耳机的音质效果有影响
  final bool? audioDisableSWAECOnHeadset;

  /// 设置是否开启AI降噪，开启AI降噪，在嘈杂环境下，让对方更清晰听到您的声音
  final bool? audioAINSEnabled;

  /// 是否开启服务器录制语音
  final bool? serverRecordAudio;

  /// 是否开启服务器录制视频
  final bool? serverRecordVideo;

  /// 服务器录制模式
  final NERtcServerRecordMode? serverRecordMode;

  /// 是否服务器录制主讲人
  final bool? serverRecordSpeaker;

  /// 是否允许在房间推流时推送自身的视频流
  final bool? publishSelfStream;

  /// 是否允许视频帧回调.
  /// 仅在iOS平台有效.
  final bool? videoCaptureObserverEnabled;

  /// 视频编码模式
  final NERtcMediaCodecMode? videoEncodeMode;

  /// 视频解码模式.
  final NERtcMediaCodecMode? videoDecodeMode;

  /// 视频发布模式
  final NERtcVideoSendMode? videoSendMode;

  ///是否开启H265
  final bool? videoH265Enabled;

  /// 是否开启频道1V1模式，joinChannel 前设置生效
  final bool? mode1v1Enabled;
}

/// Camera类型
/// 仅 Android 平台支持
class NERtcCameraType {
  /// 使用 android.hardware.camera 进行视频采集
  /// 默认情况下使用 [camera1]
  static const int camera1 = 1;

  /// 使用 android.hardware.camera2 进行视频采集
  static const int camera2 = 2;
}

///屏幕共享编码策略倾向
class NERtcSubStreamContentPrefer {
  /// （默认）内容类型为动画。当共享的内容是视频、电影或游戏时，推荐用户选择该内容类型
  static const int motion = 0;

  /// 内容类型为细节。当共享的内容是图片或文字时，推荐选择该内容类型（该模式下帧率最高10帧）
  static const int details = 1;
}

/// 视频设置参数
class NERtcVideoConfig {
  /// 视频编码的分辨率，用于衡量编码质量视频档位。 详细信息请参考 [NERtcVideoProfile]。
  int videoProfile = NERtcVideoProfile.standard;

  /// 视频画面裁剪模式，默认为 [NERtcVideoCropMode.cropDefault]。自定义视频输入不支持设置裁剪模式。
  int videoCropMode = NERtcVideoCropMode.cropDefault;

  /// 摄像头位置，默认前置摄像头
  bool frontCamera = true;

  /// 视频编码的帧率。详细信息请参考 [NERtcVideoFrameRate]。
  int frameRate = NERtcVideoFrameRate.fps_30;

  /// 视频编码的最小帧率。默认为 0，表示使用默认最小帧率。
  int minFrameRate = 0;

  /// 视频编码的码率，单位为 Kbps。您可以根据场景需要，手动设置想要的码率。
  ///
  /// - 若设置的视频码率超出合理范围，SDK 会自动按照合理区间处理码率。
  /// - 若设置为 0，SDK将会自行计算处理。
  int bitrate = 0;

  /// 视频编码的最小码率，单位为 Kbps。您可以根据场景需要，手动设置想要的最小码率，若设置为0，SDK 将会自行计算处理。
  int minBitrate = 0;

  /// 带宽受限时的视频编码降级偏好。详细信息请参考 [NERtcDegradationPreference]。`
  int degradationPrefer = NERtcDegradationPreference.degradationDefault;

  /// 视频编码分辨率，衡量编码质量，以宽x高表示。与maxProfile属性二选一。
  /// width表示视频帧在横轴上的像素，即自定义宽。
  ///
  /// - 设置为负数时表示采用 maxProfile档位。
  /// - 如果需要自定义分辨率场景，则设置此属性，maxProfile属性失效。
  ///
  /// 自定义视频输入 width 和 height 无效，会自动根据 maxProfile缩放。
  int width = 0;

  /// 视频编码分辨率，衡量编码质量，以宽x高表示。与maxProfile属性二选一。
  /// height表示视频帧在纵轴上的像素，即自定义高。
  ///
  /// - 设置为负数时表示采用 maxProfile档位。
  /// - 如果需要自定义分辨率场景，则设置此属性，maxProfile属性失效。
  ///
  /// 自定义视频输入width和height无效，会自动根据 maxProfile缩放。
  int height = 0;

  /// Camera 类型，仅 Android 平台支持
  int cameraType = NERtcCameraType.camera1;

  /// 设置本地视频编码的镜像模式，即本地发送视频的镜像模式，只影响远端用户看到的视频画面。 详细信息请参考 [NERtcVideoMirrorMode]。
  int mirrorMode = NERtcVideoMirrorMode.auto;

  /// 设置本地视频编码的方向模式，即本地发送视频的方向模式，只影响远端用户看到的视频画面。 详细信息请参考 {@link NERtcVideoOutputOrientationMode}。
  int orientationMode = NERtcVideoOutputOrientationMode.adaptative;

  @override
  String toString() {
    return 'NERtcVideoConfig{videoProfile: $videoProfile, '
        'videoCropMode: $videoCropMode, frontCamera: $frontCamera, '
        'frameRate: $frameRate, minFrameRate: $minFrameRate, '
        'bitrate: $bitrate, minBitrate: $minBitrate, '
        'degradationPrefer: $degradationPrefer, width: $width, height: $height, '
        'cameraType: $cameraType, mirrorMode: $mirrorMode, '
        'orientationMode: $orientationMode}';
  }
}

/// 屏幕录制编码参数
class NERtcScreenConfig {
  /// 屏幕共享编码策略倾向
  int contentPrefer = NERtcSubStreamContentPrefer.motion;

  /// 视频档位，默认高清模式
  int videoProfile = NERtcVideoProfile.standard;

  /// 视频编码帧率
  int frameRate = NERtcVideoFrameRate.fps_30;

  /// 最小帧率。0：表示使用默认帧率
  int minFrameRate = 0;

  /// 视频编码码率，单位为Kbps。 0：表示使用默认码率，手动设置请参考码表
  int bitrate = 0;

  /// 视频编码最小码率，单位为Kbps。直播场景下使用，0：表示使用默认
  int minBitrate = 0;

  @override
  String toString() {
    return 'NERtcScreenConfig{contentPrefer: $contentPrefer, '
        'videoProfile: $videoProfile, frameRate: $frameRate, '
        'minFrameRate: $minFrameRate, bitrate: $bitrate, minBitrate: $minBitrate}';
  }
}

///视频清晰度
class NERtcVideoProfile {
  ///标清,（320x180/240 @15fps）
  static const int low = 1;

  ///高清, (640x360/480 @30fps)
  static const int standard = 2;

  ///超清, (1280x720 @30 fps)
  static const int hd720p = 3;

  ///1080P, (1920x1080 @30fps)
  static const int hd1080p = 4;
}

/// 视频镜像模式
class NERtcVideoMirrorMode {
  /// （默认）由 SDK 决定镜像模式
  static const int auto = 0;

  /// 启用镜像模式
  static const int enabled = 1;

  /// 关闭镜像模式
  static const int disabled = 2;
}

/// 视频旋转方向模式
class NERtcVideoOutputOrientationMode {
  ///（默认）该模式下 SDK 输出的视频方向与采集到的视频方向一致。接收端会根据收到的视频旋转信息对视频进行旋转。
  ///
  /// 该模式适用于接收端可以调整视频方向的场景。
  /// - 如果采集的视频是横屏模式，则输出的视频也是横屏模式。
  /// - 如果采集的视频是竖屏模式，则输出的视频也是竖屏模式。
  static const int adaptative = 0;

  /// 该模式下 SDK 固定输出横屏模式的视频。如果采集到的视频是竖屏模式，则视频编码器会对其进行裁剪。
  ///
  /// 该模式适用于接收端无法调整视频方向的场景，例如旁路推流。
  static const int fixedLandscape = 1;

  /// 该模式下 SDK 固定输出竖屏模式的视频，如果采集到的视频是横屏模式，则视频编码器会对其进行裁剪。
  ///
  /// 该模式适用于接收端无法调整视频方向的场景，例如旁路推流。
  static const int fixedPortrait = 2;
}

///屏幕共享清晰度
class NERtcScreenProfile {
  ///高清, (640x360/480 @5fps)
  static const int hd480p = 0;

  ///超清, (1280x720 @5 fps)
  static const int hd720p = 1;

  ///1080P, (1920x1080 @5fps)
  static const int hd1080p = 2;
}

///视频画布缩放方式
enum NERtcVideoViewFitType {
  /// As large as possible while still containing the source entirely within the
  /// target box.
  contain,

  /// As small as possible while still covering the entire target box.
  cover,
}

///视频裁剪模式
class NERtcVideoCropMode {
  ///相机原始比例
  static const int cropDefault = 0;

  ///16:9 裁剪
  static const int crop_16x9 = 1;

  ///4:3 裁剪
  static const int crop_4x3 = 2;

  ///1:1 裁剪
  static const int crop_1x1 = 3;
}

/// 视频流类型
class NERtcVideoStreamType {
  /// 主流
  static const int main = 1;

  /// 辅流
  static const int sub = 2;
}

///网络类型定义
class NERtcConnectionType {
  ///Unknown data connection.
  static const int unknown = 0;

  ///The Ethernet data connection.
  static const int ethernet = 1;

  ///The WIFI data connection.
  static const int wifi = 2;

  ///The Mobile(4G) data connection.
  static const int cellular4g = 3;

  ///The Mobile(3G) data connection.
  static const int cellular3g = 4;

  ///The Mobile(2G) data connection.
  static const int cellular2g = 5;

  /// The Unknown cellular data connection.
  static const int cellularUnknown = 6;

  ///The Bluetooth data connection.
  static const int bluetooth = 7;

  ///The VPN data connection.
  static const int vpn = 8;

  ///The Mobile(5G) data connection.
  static const int cellular5g = 9;

  ///The absence of a connection type.
  static const int none = 10;
}

///语音设备类型
class NERtcAudioDevice {
  /// 扬声器
  static const int speakerPhone = 0;

  /// 有线耳机
  static const int wiredHeadset = 1;

  /// 听筒
  static const int earpiece = 2;

  /// 蓝牙耳机
  static const int bluetoothHeadset = 3;
}

///音频设备状态
class NERtcAudioDeviceState {
  /// 初始化, Only iOS
  static const int initialized = 0;

  /// 打开成功
  static const int opened = 1;

  /// 已关闭
  static const int closed = 2;

  /// 初始化失败
  static const int initializationError = 3;

  /// 开启失败
  static const int startError = 4;

  /// 未知错误
  static const int unknownError = 5;

  /// 反初始化
  static const int unInitialized = 6;
}

///视频设备状态
class NERtcVideoDeviceState {
  /// 初始化, Only iOS
  static const int initialized = 0;

  ///打开成功
  static const int opened = 1;

  ///已关闭
  static const int closed = 2;

  ///相机断开，可能被其他应用抢占
  static const int disconnected = 3;

  ///相机冻结
  static const int freezed = 4;

  ///未知错误
  static const int unknownError = 5;

  /// 反初始化
  static const int unInitialized = 6;
}

///音频设备类型
class NERtcAudioDeviceType {
  /// 音频播放设备
  static const int playout = 2;

  /// 音频采集设备
  static const int record = 1;
}

///音频应用场景
enum NERtcAudioScenario {
  ///默认设置为Speech
  scenarioDefault,

  ///语音场景. AudioProfile 推荐使用 MIDDLE_QUALITY 及以下
  scenarioSpeech,

  ///音乐场景。AudioProfile 推荐使用 MIDDLE_QUALITY_STEREO 及以上
  scenarioMusic
}

///音频属性。设置采样率，码率，编码模式和声道数
enum NERtcAudioProfile {
  ///默认设置。Speech场景下为Standard，Music场景下为HighQuality
  profileDefault,

  ///普通质量的音频编码，16000Hz，20Kbps
  profileStandard,

  /// 普通质量的音频编码，16000Hz，32Kbps
  profileStandardExtend,

  ///中等质量的音频编码，48000Hz，32Kbps
  profileMiddleQuality,

  ///中等质量的立体声编码，48000Hz * 2，64Kbps
  profileMiddleQualityStereo,

  ///高质量的音频编码，48000Hz，64Kbps
  profileHighQuality,

  ///高质量的立体声编码，48000Hz * 2，128Kbps
  profileHighQualityStereo
}

/// 编解码模式，主要用来区分软件编解码和硬件编解码
enum NERtcMediaCodecMode {
  /// 优先使用硬件编解码器
  hardware,

  /// 优先使用软件编解码器
  software
}

/// 服务器录制模式
enum NERtcServerRecordMode {
  /// 混合与单人一起录制
  mixAndSingle,

  /// 混合录制
  mix,

  /// 单人录制
  single
}

/// 伴音任务状态更新
enum NERtcAudioMixingTaskState {
  ///伴音任务结束
  finished,

  /// 伴音任务出错
  error
}

///错误码定义
class NERtcErrorCode {
  /// 成功
  static const int ok = 0;

  ///参数错误
  static const int illegalArgument = -400;

  ///状态错误
  static const int illegalStatus = -500;

  ///未初始化
  static const int uninitialized = -501;

  ///操作不支持
  static const int invalidOperation = -700;

  ///请求超时
  static const int reserveTimeout = 408;

  ///参数错误
  static const int reserveInvalidParameter = 414;

  ///只支持两个用户, 有第三个人试图使用相同的频道名分配频道
  static const int reserveMoreThanTwoUser = 600;

  ///没有权限，包括没有开通音视频功能、没有开通非安全但是请求了非安全等
  static const int reserveNoPermission = 403;

  ///分配频道服务器出错
  static const int reserveServerFail = 500;

  ///内部错误
  static const int errorFatal = 30001;

  ///内存溢出
  static const int outOfMemory = 30002;

  ///参数错误
  static const int invalidParam = 30003;

  ///不支持
  static const int notSupported = 30004;

  ///状态错误
  static const int invalidState = 30005;

  ///缺乏资源
  static const int lackOfResource = 30006;

  ///序号非法
  static const int invalidIndex = 30007;

  ///设备未找到
  static const int deviceNotFound = 30008;

  ///设备ID非法
  static const int invalidDeviceSourceId = 30009;

  ///视频能力非法
  static const int invalidVideoProfile = 30010;

  ///创建设备失败
  static const int createDeviceSourceFail = 30011;

  ///画布非法
  static const int invalidRender = 30012;

  ///预览已打开
  static const int devicePreviewAlreadyStarted = 30013;

  ///挂起
  static const int transmitPending = 30014;

  ///连接失败
  static const int connectFail = 30015;

  ///创建dump 失败
  static const int createDumpFileFail = 30016;

  ///开始dump失败
  static const int startDumpFail = 30017;

  ///房间已加入
  static const int roomAlreadyJoined = 30100;

  ///房间未加入
  static const int roomNotJoined = 30101;

  ///重复离开房间
  static const int roomRepeatedlyLeave = 30102;

  ///请求加入房间失败
  static const int requestJoinRoomFail = 30103;

  ///会话未找到
  static const int sessionNotFound = 30104;

  ///用户未找到
  static const int userNotFound = 30105;

  ///非法用户
  static const int invalidUserId = 30106;

  ///媒体会话未建立
  static const int mediaNotStarted = 30107;

  ///媒体源未找到
  static const int sourceNotFound = 30108;

  ///切换房间状态无效
  static const int switchChannelInvalidState = 30109;

  /// 原因通常为重复调用 startChannelMediaRelay。成功调用startChannelMediaRelay后，必须先调用 stopChannelMediaRelay 方法退出当前的转发状态，才能再次调用该方法
  static const int channelMediaRelayInvalidState = 30110;

  /// 媒体流转发权限不足
  ///
  /// 原因通常包括：
  /// - 源房间的房间类型为双人房间（1V1模式）。此时无法转发媒体流。
  /// - 调用 startChannelMediaRelay 开启媒体流转发的成员角色为观众角色，仅主播角色可以转发媒体流。
  static const int channelMediaRelayPermissionDenied = 30111;

  /// 停止媒体流转发操作失败
  /// 原因通常为未开启媒体流转发。请确认调用 stopChannelMediaRelay 前，是否已成功调用 startChannelMediaRelay 开启媒体流转发。
  static const int channelMediaRelayStopFailed = 30112;

  /// 设置的媒体流加密密钥与房间中其他成员不一致，加入房间失败。
  /// 请通过 enableEncryption 重新设置加密密钥。
  static const int encryptNotSuitable = 30113;

  ///连接未找到
  static const int connectionNotFound = 30200;

  ///媒体流未找到
  static const int streamNotFound = 30201;

  ///添加track失败
  static const int addTrackFail = 30202;

  ///track未找到
  static const int trackNotFound = 30203;

  ///媒体连接已断开
  static const int mediaConnectionDisconnected = 30204;

  ///信令断开
  static const int signalDisconnected = 30205;

  ///被管理员踢出房间
  static const int serverKicked = 30206;

  ///房间被关闭
  static const int roomClosed = 30207;

  /// 因为切换频道而离开房间
  static const int leaveChannelForSwitch = 30208;
}

/// 运行时错误
class NERtcRuntimeError {
  /// 没有音频权限
  static const int admNoAuthorize = 50000;

  /// 没有视频权限
  static const int vdmNoAuthorize = 50001;

  /// 麦克风初始化失败
  static const int admRecordInitError = 50103;

  /// 麦克风打开失败
  static const int admRecordStartError = 50104;

  /// 麦克风运行错误
  static const int admRecordUnknownError = 50105;

  /// 音频播放设备初始化失败
  static const int admPlayoutInitError = 50203;

  /// 音频播放设备打开失败
  static const int admPlayoutStartError = 50204;

  /// 音频播放设备运行错误
  static const int admPlayoutUnknownError = 50205;

  /// 相机被其他应用抢占
  static const int vdmCameraDisconnectError = 50303;

  /// 相机已冻结
  static const int vdmCameraFreezedError = 50304;

  /// 相机运行错误
  static const int vdmCameraUnknownError = 50305;
}

///日志级别
class NERtcLogLevel {
  ///Fatal 级别日志信息
  static const int fatal = 0;

  ///Error 级别日志信息
  static const int error = 1;

  ///Warning 级别日志信息
  static const int warning = 2;

  ///Info 级别日志信息。默认级别
  static const int info = 3;

  ///Detail Info 级别日志信息
  static const int detail_info = 4;

  ///Verbose 级别日志信息
  static const int verbose = 5;

  ///Debug 级别日志信息。如果你想获取最完整的日志，可以将日志级别设为该等级
  static const int debug = 6;
}

/// 网络状态
class NERTcNetworkStatus {
  /// 未知
  static const int unknown = 0;

  /// 非常好
  static const int excellent = 1;

  /// 好
  static const int good = 2;

  /// 不太好
  static const int poor = 3;

  /// 差
  static const int bad = 4;

  /// 非常差
  static const int veryBad = 5;

  /// 无网络
  static const int down = 6;
}

/// 频道场景
class NERtcChannelProfile {
  /// 通信场景
  static const int communication = 0;

  /// 直播场景
  static const int liveBroadcasting = 1;
}

/// 远端视频流类型
class NERtcRemoteVideoStreamType {
  /// 高分辨率的远端视频流
  static const int high = 0;

  /// 低分辨率的远端视频流
  static const int low = 1;
}

/// 与会者角色， 主播/观众
class NERtcUserRole {
  /// 主播模式，能发送和接收数据
  static const int broadcaster = 0;

  /// 观众模式，只能接收数据
  static const int audience = 1;
}

/// 语音设备类型
class NERtcAudioFocusMode {
  /// 不请求音频焦点
  static const int audioFocusOff = 0;

  /// 长时间获得焦点
  static const int audioFocusGain = 1;

  /// 短暂性获得焦点，用完应立即释放，比如notification sounds
  static const int audioFocusGainTransient = 2;

  /// 临时请求, 降低其他音频应用的声音，可混音播放
  static const int audioFocusGainTransientMayDuck = 3;

  /// 短暂性获得焦点，录音或者语音识别
  static const int audioFocusGainTransientExclusive = 4;
}

/// 视频发布流类型
enum NERtcVideoSendMode {
  /// 按对端订阅格式发流
  none,

  /// 初始发送大流
  high,

  /// 初始发布小流
  low,

  /// 初始大小流同时发送
  all
}

/// 带宽受限时的视频编码降级偏好
class NERtcDegradationPreference {
  /// COMMUNICATION模式（BALANCED）/LIVE_BROADCASTING（MAINTAIN_QUALITY）
  static const int degradationDefault = 0;

  /// 降低视频质量以保证编码帧率
  static const int degradationMaintainFrameRate = 1;

  /// 降低编码帧率以保证视频质量
  static const int degradationMaintainQuality = 2;

  /// 在编码帧率和视频质量之间保持平衡
  static const int degradationBalanced = 3;
}

/// 视频编码帧率
class NERtcVideoFrameRate {
  static const int fps_7 = 7;
  static const int fps_10 = 10;
  static const int fps_15 = 15;
  static const int fps_24 = 24;
  static const int fps_30 = 30;
}

/// 直播推流模式
class NERtcLiveStreamMode {
  /// 推流带视频
  static const int liveStreamModeVideo = 0;

  /// 推流纯音频
  static const int liveStreamModeAudio = 1;
}

/// 直播推流状态
class NERtcLiveStreamState {
  /// 推流中
  static const int pushing = 505;

  /// 互动直播推流失败
  static const int pushFail = 506;

  /// 推流结束
  static const int pushStopped = 511;

  /// 背景图片设置出错
  static const int imageError = 512;
}

/// LiveStream Error Code
class NERtcLiveStreamErrorCode {
  /// 成功
  static const int ok = 0;

  /// Task请求无效，被后续操作覆盖
  static const int requestIsInvaild = 1301;

  /// Task参数格式错误
  static const int invaild = 1400;

  /// 房间已经退出
  static const int roomExited = 1401;

  /// 推流任务超出上限
  static const int numLimit = 1402;

  /// 推流ID重复
  static const int duplicateId = 1403;

  /// TaskId任务不存在，或频道不存在
  static const int notFound = 1404;

  /// 请求失败
  static const int requestError = 1417;

  /// 服务器内部错误
  static const int internalServerErr = 1500;

  /// 布局参数错误
  static const int invalidLayout = 1501;

  /// 用户图片错误
  static const int userPictureError = 1502;
}

/// 直播布局
class NERtcLiveStreamLayout {
  NERtcLiveStreamLayout({
    this.width,
    this.height,
    this.backgroundImg,
    this.userTranscodingList,
    this.backgroundColor,
  });

  /// 视频推流宽度
  int? width;

  /// 视频推流高度
  int? height;

  /// 视频推流背景色 RGB
  Color? backgroundColor;

  /// 视频推流背景图
  NERtcLiveStreamImageInfo? backgroundImg;

  /// 成员布局数组
  List<NERtcLiveStreamUserTranscoding>? userTranscodingList;
}

class NERtcLiveStreamVideoScaleMode {
  /// 视频尺寸等比缩放。优先保证视频内容全部显示。因视频尺寸与显示视窗尺寸不一致造成的视窗未被填满的区域填充背景色。
  static const int liveStreamModeVideoScaleFit = 0;

  /// 视频尺寸等比缩放。优先保证视窗被填满。因视频尺寸与显示视窗尺寸不一致而多出的视频将被截掉。
  static const int liveStreamModeVideoScaleCropFill = 1;
}

/// 直播成员布局
class NERtcLiveStreamUserTranscoding {
  NERtcLiveStreamUserTranscoding(
      {required this.uid,
      this.videoPush = true,
      this.audioPush = true,
      this.adaption = NERtcLiveStreamVideoScaleMode.liveStreamModeVideoScaleFit,
      this.x = 0,
      this.y = 0,
      this.width = 0,
      this.height = 0});

  /// 用户uid
  int uid;

  /// 是否推送该用户视频流，推流模式为 [NERtcLiveStreamMode.liveStreamModeAudio] 时无效
  bool videoPush;

  /// 是否推送该用户音频流
  bool audioPush;

  /// 视频流裁剪模式, 参考 [NERtcLiveStreamVideoScaleMode]
  int adaption;

  /// 画面离主画面左边距
  int x;

  /// 画面离主画面上边距
  int y;

  /// 画面在主画面的显示宽度，画面右边超出主画面会失败
  int width;

  /// 画面在主画面的显示高度，画面底边超出主画面会失败
  int height;

  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> map = <dynamic, dynamic>{};
    map['uid'] = uid;
    map['videoPush'] = videoPush;
    map['audioPush'] = audioPush;
    map['adaption'] = adaption;
    map['x'] = x;
    map['y'] = y;
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}

/// 推流背景图片设置
class NERtcLiveStreamImageInfo {
  NERtcLiveStreamImageInfo(
      {this.url, this.x = 0, this.y = 0, this.width = 0, this.height = 0});

  /// 图片地址url
  String? url;

  /// 图片离主画面左边距 ， 默认 0
  int x;

  /// 图片离主画面上边距 ， 默认 0
  int y;

  /// 图片在主画面的显示宽度，图片右边超出主画面会失败 ， 默认主画面宽度
  int width;

  /// 图片在主画面的显示高度，图片底边超出主画面会失败， 默认主画面高度
  int height;
}

/// 房间推流任务参数
class NERtcLiveStreamTaskInfo {
  NERtcLiveStreamTaskInfo(
      {required this.taskId,
      required this.url,
      this.serverRecordEnabled = false,
      this.liveMode = NERtcLiveStreamMode.liveStreamModeVideo,
      this.layout});

  /// 推流任务ID，为推流任务的唯一标识，用于过程中增删任务操作
  String taskId;

  /// 直播推流地址
  String url;

  /// 服务器录制功能是否开启
  bool serverRecordEnabled;

  /// 直播推流模式 [NERtcLiveStreamMode]
  int liveMode;

  /// 视频布局
  NERtcLiveStreamLayout? layout;
}

/// 频道连接状态
class NERtcConnectionState {
  /// 未知
  static const int unknown = 0;

  /// 网络连接断开
  static const int disconnected = 1;

  ///建立网络连接中
  static const int connecting = 2;

  /// 网络已连接
  static const int connected = 3;

  /// 重新建立网络连接中
  static const int reconnecting = 4;

  /// 网络连接失败
  static const int failed = 5;
}

/// 频道连接状态变更原因
class NERtcConnectionStateChangeReason {
  /// 离开房间
  static const int leaveChannel = 1;

  /// 房间被关闭
  static const int channelClosed = 2;

  /// 用户被踢
  static const int serverKicked = 3;

  /// 超时离开
  static const int timeout = 4;

  /// 加入房间
  static const int joinChannel = 5;

  /// 加入房间成功
  static const int joinSucceed = 6;

  /// 重新加入房间成功（重连）
  static const int rejoinSucceed = 7;

  /// 媒体连接断开
  static const int mediaConnectionDisconnected = 8;

  /// 信令连接断开
  static const int signalDisconnected = 9;

  /// 请求频道失败
  static const int requestChannelFailed = 10;

  /// 加入频道失败
  static const int joinChannelFailed = 11;
}

/// 用户角色
class NERtcClientRole {
  /// 主播
  static const int broadcaster = 0;

  /// 观众
  static const int audience = 1;
}

/// 变声 预设值
class NERtcVoiceChangerType {
  /// 关闭
  static const int off = 0;

  /// 机器人
  static const int robot = 1;

  /// 巨人
  static const int giant = 2;

  /// 恐怖
  static const int horror = 3;

  /// 成熟
  static const int mature = 4;

  /// 男变女
  static const int manToWoman = 5;

  /// 女变男
  static const int womanToMan = 6;

  /// 男变萝莉
  static const int manToLoli = 7;

  /// 女变萝莉
  static const int womanToLoli = 8;
}

/// 美声效果
class NERtcVoiceBeautifierType {
  /// 默认关闭
  static const int off = 0;

  /// 低沉
  static const int muffled = 1;

  /// 圆润
  static const int mellow = 2;

  /// 清澈
  static const int clear = 3;

  /// 磁性
  static const int magnetic = 4;

  /// 录音棚
  static const int recordingStudio = 5;

  /// 天籁
  static const int nature = 6;

  /// KTV
  static const int ktv = 7;

  /// 悠远
  static const int remote = 8;

  /// 教堂
  static const int church = 9;

  /// 卧室
  static const int bedroom = 10;

  /// live
  static const int live = 11;
}

///伴音错误状态
class NERtcAudioMixingError {
  /// 伴音正常结束
  static const int finish = 0;

  /// 音频解码错误
  static const int errorDecode = 1;

  /// 操作中断码
  static const int errorInterrupt = 2;

  /// 404 http/https 对应的文件找不到
  static const int errorHttpNotFound = 3;

  /// 打开流/文件失败
  static const int errorOpen = 4;

  /// 获取解码信息失败/超时
  static const int errorNoInfo = 5;

  /// 无音频流
  static const int errorNoStream = 6;

  /// 无解码器
  static const int errorNoCodec = 7;

  /// 无内存
  static const int errorNoMemory = 8;

  /// 解码器打开失败/超时
  static const int errorCodecOpen = 9;

  /// 无效音频参数（声道、采样率）
  static const int errorInvalidInfo = 10;

  /// 打开流/文件超时
  static const int errorOpenTimeout = 11;

  /// 网络IO 超时
  static const int errorIOTimeout = 12;

  /// 网络IO 错误
  static const int errorIO = 13;
}

/// 媒体流优先级
class NERtcMediaPriority {
  /// 高优先级
  static const int high = 50;

  /// （默认）普通优先级
  static const int normal = 100;
}

/// 录音音质
class NERtcAudioRecordingQuality {
  /// 低音质
  static const int low = 0;

  /// （默认）中音质
  static const int medium = 1;

  /// 高音质
  static const int high = 2;
}

/// 录音回调事件状态码
class NERtcAudioRecordingCode {
  /// 不支持的录音文件格式
  static const int errorSuffix = 1;

  /// 无法创建录音文件，原因通常包括：
  /// - 应用没有磁盘写入权限。
  /// - 文件路径不存在。
  static const int openFileFailed = 2;

  /// 开始录制
  static const int start = 3;

  /// 录制错误。原因通常为磁盘空间已满，无法写入
  static const int error = 4;

  /// 完成录制
  static const int finish = 5;
}

/// 媒体流转发相关的数据结构
class NERtcChannelMediaRelayInfo {
  /// 用户 ID
  int channelUid;

  /// 房间名
  String channelName;

  /// 房间 Token
  String channelToken;

  NERtcChannelMediaRelayInfo(
      {required this.channelUid,
      required this.channelName,
      required this.channelToken});

  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> map = <dynamic, dynamic>{};
    map['channelUid'] = channelUid;
    map['channelName'] = channelName;
    map['channelToken'] = channelToken;
    return map;
  }

  static NERtcChannelMediaRelayInfo fromMap(Map<String, dynamic> map) {
    return NERtcChannelMediaRelayInfo(
        channelUid: map['channelUid'] ?? 0,
        channelName: map['channelName'] ?? '',
        channelToken: map['channelToken'] ?? '');
  }
}

/// 媒体流转发参数，包括源房间、目标房间列表等
class NERtcChannelMediaRelayConfiguration {
  /// 源房间信息
  NERtcChannelMediaRelayInfo? sourceMediaInfo;

  /// 目标房间信息列表
  Map<String, NERtcChannelMediaRelayInfo> destMediaInfo;

  NERtcChannelMediaRelayConfiguration(this.sourceMediaInfo, this.destMediaInfo);
}

/// 媒体流转发状态
class NERtcChannelMediaRelayState {
  /// 初始状态。在成功调用 [NERtcEngine.stopChannelMediaRelay] 停止跨房间媒体流转发后， [onNERtcEngineChannelMediaRelayStateDidChange] 会回调该状态
  static const int idle = 0;

  /// SDK 尝试跨房间转发媒体流
  static const int connecting = 1;

  /// 源房间主播角色成功加入目标频道
  static const int running = 2;

  /// 发生异常，详见 [onMediaRelayReceiveEvent] 的 error 中提示的错误信息
  static const int failure = 3;
}

/// 媒体流转发回调事件
class NERtcChannelMediaRelayEvent {
  /// 媒体流转发停止
  static const int disconnect = 0;

  /// 正在连接服务器，开始尝试转发媒体流
  static const int connecting = 1;

  /// 连接服务器成功
  static const int connected = 2;

  /// 视频媒体流成功转发到目标房间
  static const int videoSentSuccess = 3;

  /// 音频媒体流成功转发到目标房间
  static const int audioSentSuccess = 4;

  /// 屏幕共享等其他媒体流成功转发到目标房间
  static const int otherStreamSentSuccess = 5;

  /// 媒体流转发失败。原因包括：
  /// - reserveInvalidParameter(414)：请求参数错误。
  /// - channelMediaRelayInvalidState(30110)：重复调用 startChannelMediaRelay。
  /// - channelMediaRelayPermissionDenied(30111)：媒体流转发权限不足。例如调用 startChannelMediaRelay 的房间成员为观众角色、或房间为双人通话房间，不支持转发媒体流。
  /// - channelMediaRelayStopFailed(30112)：调用 stopChannelMediaRelay 前，未调用 startChannelMediaRelay。
  static const int failure = 100;
}

class NERtcStreamFallbackOptions {
  /// 上行或下行网络较弱时，不对音视频流作回退处理，但不能保证音视频流的质量。
  ///
  /// 该选项只对 [NERtcEngine.setLocalPublishFallbackOption] 方法有效，对 [NERtcEngine.setRemoteSubscribeFallbackOption] 方法无效。
  static const int disabled = 0;

  /// 在下行网络条件较差的情况下，SDK 将只接收视频小流，即低分辨率、低码率视频流。
  ///
  /// 该选项只对 [setRemoteSubscribeFallbackOption] 方法有效，对 [setLocalPublishFallbackOption] 方法无效。
  static const int videoStreamLow = 1;

  /// 上行网络较弱时，只发布音频流。
  /// 下行网络较弱时，先尝试只接收视频小流，即低分辨率、低码率视频流。如果网络环境无法显示视频，则再回退到只接收音频流。
  static const int audioOnly = 2;
}

/// 配置媒体流加密模式和密钥
class NERtcEncryptionConfig {
  /// 媒体流加密模式
  NERtcEncryptionMode mode;

  /// 媒体流加密密钥。字符串类型，推荐设置为英文字符串
  String key;

  NERtcEncryptionConfig(this.mode, this.key);
}

/// 媒体流加密模式
enum NERtcEncryptionMode { GMCryptoSM4ECB }
