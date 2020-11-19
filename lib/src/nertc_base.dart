// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

/// 音视频通话相关的参数设置
class NERtcOptions {
  const NERtcOptions(
      {this.logDir,
      this.logLevel,
      this.autoSubscribeAudio,
      this.videoEncodeMode,
      this.videoDecodeMode,
      this.serverRecordAudio,
      this.serverRecordVideo,
      this.serverRecordMode,
      this.serverRecordSpeaker,
      this.publishSelfStream,
      this.videoSendMode});

  /// 日志路径
  final String logDir;

  /// 日志等级
  final int logLevel;

  /// 是否自动订阅音频（默认订阅）
  final bool autoSubscribeAudio;

  /// 视频编码模式
  final NERtcMediaCodecMode videoEncodeMode;

  /// 视频解码模式.
  final NERtcMediaCodecMode videoDecodeMode;

  /// 是否开启服务器录制语音
  final bool serverRecordAudio;

  /// 是否开启服务器录制视频
  final bool serverRecordVideo;

  /// 服务器录制模式
  final NERtcServerRecordMode serverRecordMode;

  /// 是否服务器录制主讲人
  final bool serverRecordSpeaker;

  /// 是否允许在房间推流时推送自身的视频流
  final bool publishSelfStream;

  /// 视频发布模式
  final NERtcVideoSendMode videoSendMode;
}

/// 视频设置参数
class NERtcVideoConfig {
  /// 视频档位，默认高清模式
  int videoProfile = NERtcVideoProfile.standard;

  /// 视频裁剪模式
  int videoCropMode = NERtcVideoCropMode.cropDefault;

  /// 摄像头位置，默认前置摄像头
  bool frontCamera = true;

  /// 视频编码帧率
  int frameRate = NERtcVideoFrameRate.fps_30;

  /// 最小帧率。0：表示使用默认帧率
  int minFrameRate = 0;

  /// 视频编码码率，单位为Kbps。 0：表示使用默认码率，手动设置请参考码表
  int bitrate = 0;

  /// 视频编码最小码率，单位为Kbps。直播场景下使用，0：表示使用默认
  int minBitrate = 0;

  /// 带宽受限时的视频编码降级偏好
  int degradationPrefer = NERtcDegradationPreference.degradationDefault;

  @override
  String toString() {
    return 'NERtcVideoConfig{videoProfile: $videoProfile, '
        'videoCropMode: $videoCropMode, frontCamera: $frontCamera, '
        'frameRate: $frameRate, minFrameRate: $minFrameRate,'
        ' bitrate: $bitrate, minBitrate: $minBitrate, '
        'degradationPrefer: $degradationPrefer}';
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
  static const int CROP_16x9 = 1;

  ///4:3 裁剪
  static const int CROP_4x3 = 2;

  ///1:1 裁剪
  static const int CROP_1x1 = 3;
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

  ///The absence of a connection type.
  static const int none = 9;
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

  ///中等质量的音频编码，48000Hz，32Kbp
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
  static const int broadcaster = 1;

  /// 观众模式，只能接收数据
  static const int audience = 2;
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
