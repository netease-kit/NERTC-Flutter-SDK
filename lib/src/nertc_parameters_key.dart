// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 用于访问和设置 NERtcParameters 类中参数的键
class NERtcParameterKey<T> {
  final String key;
  const NERtcParameterKey(this.key);
}

///音视频通话的参数集合
class NERtcParameters {
  final Map<String, Object> _parameters = Map<String, Object>();

  ///是否自动订阅音频，默认为 true，即订阅音频
  static const KEY_AUTO_SUBSCRIBE_AUDIO =
      NERtcParameterKey<bool>('key_auto_subscribe_audio');

  ///是否自动订阅视频（包括主流、辅流），默认为 false, 即不订阅视频
  static const KEY_AUTO_SUBSCRIBE_VIDEO =
      NERtcParameterKey<bool>('key_auto_subscribe_video');

  ///是否关闭蓝牙SCO
  static const KEY_AUDIO_BLUETOOTH_SCO =
      NERtcParameterKey<bool>('key_audio_bluetooth_sco');

  ///前置摄像头预览是否采用镜像模式。默认为 true，开启镜像模式
  static const KEY_VIDEO_LOCAL_PREVIEW_MIRROR =
      NERtcParameterKey<bool>('key_video_local_preview_mirror');

  ///摄像头类型,传参参考 [NERtcCameraPosition]
  ///
  ///Android 独有字段
  static const KEY_VIDEO_CAMERA_TYPE =
      NERtcParameterKey<int>('key_video_camera_type');

  ///视频编码模式, 传参参考[VideoEncodeorDecodeMode]
  static const KEY_VIDEO_ENCODE_MODE =
      NERtcParameterKey<String>('key_video_encode_mode');

  ///视频解码模式, 传参参考[VideoEncodeorDecodeMode]
  static const KEY_VIDEO_DECODE_MODE =
      NERtcParameterKey<String>('key_video_decode_mode');

  ///是否开启云端音频录制。默认为 false，即关闭音频录制
  static const KEY_SERVER_RECORD_AUDIO =
      NERtcParameterKey<bool>('key_server_record_audio');

  ///是否开启云端视频录制。默认为 false，即关闭视频录制
  static const KEY_SERVER_RECORD_VIDEO =
      NERtcParameterKey<bool>('key_server_record_video');

  ///云端录制模式，传参参考[ServerRecordMode]
  static const KEY_SERVER_RECORD_MODE =
      NERtcParameterKey<int>('key_server_record_mode');

  ///本端是否为云端录制的主讲人
  static const KEY_SERVER_RECORD_SPEAKER =
      NERtcParameterKey<bool>('key_server_record_speaker');

  ///视频发布模式,传参参考 [VideoSendMode]
  static const KEY_VIDEO_SEND_MODE =
      NERtcParameterKey<int>('key_video_send_mode');

  ///AI 降噪开关。 NERTCSDK自研 AI 降噪算法，开启 AI 降噪之后，在嘈杂的环境中可以针对背景人声、键盘声等非稳态噪声进行定向降噪，同时也会提升对于环境稳态噪声的抑制，保留更纯粹的人声。
  static const KEY_AUDIO_AI_NS_ENABLE =
      NERtcParameterKey<bool>('key_audio_ai_ns_enable');

  ///是否开启双人通话模式。默认为关闭状态。 适用于 1v1 通话场景。
  ///
  ///注意：
  ///
  /// 开启了双人通话模式的客户端创建并加入房间时，该房间会成为一个双人通话房间，只允许同样开启了双通话模式的客户端加入。
  ///
  /// 请在加入房间前设置。
  static const KEY_ENABLE_1V1_MODEL =
      NERtcParameterKey<bool>('key_enable_1v1_mode');

  ///是否支持设置负数 uid ，默认为 false，即不支持设置负数 uid。 该参数需要在加入房间前设置，且不建议中途更改。
  ///
  ///注意：
  ///
  ///强烈不建议使用负数 uid ，这个只是一个应急补救措施，如果超过了 32 无符整型，那么可能存在 uid 重复的问题。
  ///
  ///如果设置支持负数 uid ，那么 SDK 会将通过所有 API 输入的负数uid 进行处理（uid & 0xffffffffL）得到正数 uid，所有 SDK 回调都是相应long 正数 uid，您需要自己强行转成 int 以能得到相应的负数。
  static const KEY_ENABLE_NEGATIVE_UID =
      NERtcParameterKey<bool>('key_enable_negative_uid');

  ///Login 事件中的一个自定义字段，适用于协助客户标识一些额外信息
  static const KEY_CUSTOM_EXTRA_INFO =
      NERtcParameterKey<String>('key_custom_extra_info');

  ///本地用户静音时是否返回原始音量。 布尔值，默认值为 false。
  ///
  ///true：返回 NERtcCallbackEx#onLocalAudioVolumeIndication 中的原始音量。
  ///
  ///false：返回 NERtcCallbackEx#onLocalAudioVolumeIndication 中的录音音量，静音时为 0。
  static const KEY_ENABLE_REPORT_VOLUME_WHEN_MUTE =
      NERtcParameterKey<bool>('key_enable_report_volume_when_mute');

  ///是否关闭sdk 视频解码（默认不关闭），关闭后SDK 将不会解码远端视频，因此也不法渲染接收到的远端视频
  ///
  ///注意：
  ///
  /// 需要在初始化前设置，释放SDK 后失效。
  static const KEY_DISABLE_VIDEO_DECODER =
      NERtcParameterKey<bool>('key_disable_video_decoder');

  ///登录扩展字段,SDK会把该字段放入getchannelInfo请求参数中的customData字段
  static const KEY_LOGIN_CUSTOM_DATA =
      NERtcParameterKey<String>('sdk.getChannelInfo.custom.data');

  ///当系统切换听筒或扬声器时，SDK 是否以系统设置为准。布尔值，默认为 false。
  ///
  ///true: 以系统设置为准。例如当系统切换为听筒时，应用的音频播放则自动转为听筒，开发者需要自行处理该切换事件。
  ///
  ///false: 以 SDK 设置为准，SDK 不允许用户通过系统变更音频播放路由为听筒或扬声器。例如当 SDK 设置为扬声器时，即使系统切换为听筒模式，SDK 也会自动将系统修改回扬声器模式。
  ///
  ///iOS 独有字段
  static const KEY_DISABLE_SPEAKER_ON_RECEIVER =
      NERtcParameterKey<bool>('key_disable_override_speaker_on_receiver');

  ///是否需要支持 Callkit 框架。布尔值，默认为 false。
  ///
  ///true: 需要支持，如果需要使用苹果 callkit 框架来实现发起通话，接听通话，需要设置 YES。
  ///
  ///false: 不需要支持。
  ///
  ///iOS 独有字段
  static const KEY_SUPPORT_CALLKIT =
      NERtcParameterKey<bool>('key_support_callkit');

  /// 设置耳机时不使用软件回声消除功能，默认值 false;
  ///
  /// 如设置true, 则SDK在耳机模式下不使用软件回声消除功能，会对某些机型下 耳机的音质效果有影响
  ///
  ///iOS 独有字段
  static const KEY_DISABLE_SWAEC_ON_HEADSET =
      NERtcParameterKey<bool>('key_disable_swaec_on_headset');

  /// 禁止用户进入房间自动创建房间功能，默认不禁止，默认值 false;
  static const KEY_DISABLE_FIRST_USER_CREATE_CHANNEL =
      NERtcParameterKey<bool>('key_disable_first_user_create_channel');

  /// 第一次开启摄像头时，是否使用后摄像头。
  ///
  /// 布尔值，默认值 false，即不使用后置摄像头。
  static const KEY_START_WITH_BACK_CAMERA =
      NERtcParameterKey<bool>('key_start_with_back_camera');

  void setParameter<T, S extends T>(NERtcParameterKey<T> key, S value) {
    if (value != null) {
      _parameters[key.key] = value;
    }
  }
}

///编解码模式，主要用来区分软件编解码和硬件编解码
class VideoEncodeorDecodeMode {
  ///系统自动选择编解码器
  static const String defaultMode = 'media_codec_default';

  ///优先使用硬件编解码器
  static const String hardWare = 'media_codec_hardware';

  ///优先使用软件编解码器
  static const String softWare = 'media_codec_software';
}

///服务器录制模式
class ServerRecordMode {
  ///合流+单流录制。
  static const int mixAndSingle = 0;

  ///合流录制模式
  static const int mix = 1;

  ///单流录制模式
  static const int single = 2;
}

///视频发布流类型
class VideoSendMode {
  ///按对端订阅格式发流
  static const int sendOnPubNone = 0;

  ///初始发布大流
  static const int sendOnPubHigh = 1;

  ///初始发送小流
  static const int sendOnPubLow = 2;

  ///初始大小流同时发送
  static const int sendOnPubAll = 3;
}
