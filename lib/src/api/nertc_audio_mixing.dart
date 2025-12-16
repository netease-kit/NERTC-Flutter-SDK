// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

/// 混音管理模块
abstract class NERtcAudioMixingManager {
  /// 设置混音事件回调
  void setEventCallback(NERtcAudioMixingEventCallback callback);

  /// 移除混音事件回调
  void removeEventCallback(NERtcAudioMixingEventCallback callback);

  /// 开始播放音乐文件
  ///
  /// 该方法指定本地或在线音频文件来和录音设备采集的音频流进行混音。
  ///
  /// * 支持的音乐文件类型包括 MP3、M4A、AAC、3GP、WMA 和 WAV 格式，支持本地文件或在线 URL。
  /// * 成功调用该方法后，如果播放状态改变，本地会触发 onAudioMixingStateChanged 回调。
  ///
  /// **使用前提**
  ///
  /// 发送伴音前必须调用 [NERtcEngine.enableLocalAudio] 方法开启本地音频采集。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法在加入房间前后均可调用。
  ///
  /// **说明**
  /// - 若您在通话中途调用此接口播放音乐文件时，手动设置了伴音播放音量或发送音量，则当前通话中再次调用时默认沿用此设置。
  ///
  /// - 开启或关闭本地音频采集的操作不再影响音乐文件播放，即 enableLocalAudio(false) 后仍旧可以播放音乐文件。
  ///
  /// **参数说明**
  ///
  /// [options] 创建混音任务配置的选项，包括混音任务类型、混音文件全路径或 URL 等，详细信息请参考 [NERtcAudioMixingOptions]。
  ///
  /// **相关回调**
  ///
  /// - [NERtcAudioMixingEventCallback.onAudioMixingStateChanged]：本地用户的伴音文件播放状态改变时，本地会触发此回调；可通过此回调接收伴音文件播放状态改变的相关信息，若播放出错，可通过对应错误码排查故障，详细信息请参考 [AudioMixingError]。
  /// - [NERtcAudioMixingEventCallback.onAudioMixingTimestampUpdate]：本地用户的伴音文件播放进度回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> startAudioMixing(NERtcAudioMixingOptions options);

  /// 停止播放音乐文件及混音。
  ///
  /// 通过本接口可以实现停止播放本地或在线音频文件，或者录音设备采集的混音音频流。
  ///
  /// **使用前提**
  ///
  /// 已调用 [startAudioMixing] 方法开始播放音乐文件。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> stopAudioMixing();

  /// 暂停播放音乐文件及混音。
  ///
  /// **使用前提**
  ///
  /// 已调用 [startAudioMixing] 方法开始播放音乐文件。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  /// **相关接口**
  ///
  /// 可以继续调用 [resumeAudioMixing] 方法恢复播放伴音文件。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> pauseAudioMixing();

  /// 该方法恢复混音，继续播放伴奏。
  ///
  /// **使用前提**
  ///
  /// 已调用 [startAudioMixing] 方法开始播放音乐文件。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  /// **相关接口**
  ///
  /// 可以继续调用 [pauseAudioMixing] 方法恢复播放伴音文件。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> resumeAudioMixing();

  ///调节伴奏发送音量。 该方法调节混音里伴奏的发送音量大小。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [volume] 伴奏发送音量。取值范围为 0~200。默认 100，即原始文件音量
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> setAudioMixingSendVolume(int volume);

  ///获取伴奏发送音量。 该方法获取混音里伴奏的发送音量大小。请在房间内调用该方法。
  ///返回: 当前伴奏发送音量。
  Future<int> getAudioMixingSendVolume();

  ///调节伴奏播放音量。 该方法调节混音里伴奏的播放音量大小。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [volume] 伴奏发送音量。取值范围为 0~200。默认 100，即原始文件音量
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  Future<int> setAudioMixingPlaybackVolume(int volume);

  ///获取伴奏播放音量。 该方法获取混音里伴奏的播放音量大小。请在房间内调用该方法。
  ///
  /// **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，该方法仅可在加入房间后调用。
  ///
  ///返回: 当前伴奏播放音量
  Future<int> getAudioMixingPlaybackVolume();

  ///获取伴奏时长。 该方法获取伴奏时长，单位为毫秒。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间后调用该方法。
  ///
  /// **说明**
  ///
  /// 伴音相关方法为异步加载，刚开始伴音时，如果立即调用此方法，获取到的伴奏时长可能为小于或等于 0 。如果遇到此类问题，请稍后重试。
  ///
  /// 返回：伴奏时长，单位为毫秒
  Future<int> getAudioMixingDuration();

  ///获取音乐文件的播放进度。 该方法获取当前伴奏播放进度，单位为毫秒。
  ///
  /// **调用时机**
  ///
  /// 请在加入房间后调用该方法。
  ///
  ///返回: 音乐文件的播放位置，单位为毫秒
  Future<int> getAudioMixingCurrentPosition();

  ///设置音乐文件的播放位置。 该方法可以设置音频文件的播放位置，这样你可以根据实际情况播放文件，而非从头到尾播放整个文件
  ///
  ///[position] 音乐文件的播放位置，单位为毫秒
  ///
  /// **参数说明**
  ///
  ///如果成功返回 `0`。
  Future<int> setAudioMixingPosition(int position);

  ///设置当前伴音文件的音调。
  ///
  ///通过此接口可以实现当本地人声和播放的音乐文件混音时，仅调节音乐文件的音调。
  ///
  /// **调用时机**
  ///
  ///请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **说明**
  ///
  /// 当前伴音任务结束后，此接口的设置会恢复至默认。
  ///
  /// **参数说明**
  ///
  /// [pitch] 当前伴音文件的音调。默认值为 0，即不调整音调，取值范围为 -12 ~ 12，按半音音阶调整。每相邻两个值的音高距离相差半音；取值的绝对值越大，音调升高或降低得越多。
  Future<int> setAudioMixingPitch(int pitch);

  ///获取当前伴音文件的音调
  ///
  ///请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用
  Future<int> getAudioMixingPitch();
}

/// 混音事件回调通知
mixin class NERtcAudioMixingEventCallback {
  /// 混音任务状态回调
  ///
  /// 调用 startAudioMixing 播放混音音乐文件后，当音乐文件的播放状态发生改变时，会触发该回调
  ///
  /// [reason] 0: 正常结束  1: 混音出错 详细信息参考[NERtcAudioMixingError]
  void onAudioMixingStateChanged(int reason) {}

  /// 混音进度回调
  ///
  /// [timestampMs] 混音当前时间戳,单位为毫秒
  void onAudioMixingTimestampUpdate(int timestampMs) {}
}
