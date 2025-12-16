// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

///音效管理模块
abstract class NERtcAudioEffectManager {
  /// 设置伴音事件回调
  void setEventCallback(NERtcAudioEffectEventCallback callback);

  /// 移除伴音事件回调
  void removeEventCallback(NERtcAudioEffectEventCallback callback);

  /// 播放指定音效文件。
  ///
  /// 该方法播放指定的本地或在线音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  ///  **说明**
  ///
  /// - 您可以多次调用该方法，通过传入不同的音效文件的 effectId 和option ，同时播放多个音效文件，实现音效叠加。为获得最佳用户体验，建议同时播放的音效文件不超过 3 个。
  /// - 若通过此接口成功播放某指定音效文件后，反复停止或重新播放该 effectId 对应的音效文件，仅首次播放时设置的 option 有效，后续的 option 设置无效。
  /// - 支持的音效文件类型包括 MP3、M4A、AAC、3GP、WMA 和 WAV 格式，支持本地文件和在线 URL。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID，每个音效均应有唯一的 ID。
  ///
  /// [options] 音效相关参数 ,包括混音任务类型、混音文件路径等。详细信息请参考 [NERtcAudioEffectOptions]。
  ///
  ///  **相关回调**
  ///
  ///   * [NERtcAudioEffectEventCallback.onAudioEffectTimestampUpdate]：本地音效文件播放进度回调。
  ///   * [NERtcAudioEffectEventCallback.onAudioEffectFinished]：本地音效文件播放已结束回调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化或已经加入房间。
  Future<int> playEffect(int effectId, NERtcAudioEffectOptions options);

  /// 停止播放指定音效文件
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误，未找到 ID 对应的音效文件。
  ///   * 30005（invalidState)：状态错误，比如引擎尚未初始化。
  Future<int> stopEffect(int effectId);

  /// 停止播放所有音效文件。通过此接口可以实现在同时播放多个音效文件时，可以一次性停止播放所有文件（含暂停播放的文件）。
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **相关接口**
  ///
  /// 可以调用 [stopEffect] 方法停止播放指定音效文件。
  Future<int> stopAllEffects();

  /// 暂停音效文件播放
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> pauseEffect(int effectId);

  /// 暂停所有音效文件播放
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  Future<int> pauseAllEffect();

  /// 恢复播放指定音效文件
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> resumeEffect(int effectId);

  /// 恢复播放所有音效文件
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  Future<int> resumeAllEffect();

  ///获取音效的播放进度
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  ///[effectId] 指定音效文件的 ID。每个音效文件均对应唯一的 ID。
  ///
  ///返回：音效的播放进度，单位为毫秒
  Future<int> getEffectCurrentPosition(int effectId);

  ///设置音效文件发送音量
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  /// [volume] 音效发送音量。范围为0~200，默认为100，表示原始音量。
  Future<int> setEffectSendVolume(int effectId, int volume);

  /// 获取音效文件发送音量
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectSendVolume(int effectId);

  /// 设置音效文件播放音量
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  /// [volume] 音效播放音量。范围为 0~200，默认为 100。
  Future<int> setEffectPlaybackVolume(int effectId, int volume);

  /// 获取音效文件播放音量
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的
  Future<int> getEffectPlaybackVolume(int effectId);

  /// 获取音效文件时长。单位为毫秒。
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  Future<int> getEffectDuration(int effectId);

  /// 设置指定音效文件的音调。
  ///
  /// 通过此接口可以实现当本地人声和播放的音乐文件混音时，仅调节音乐文件的音调
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **业务场景**
  ///
  /// 适用于 K 歌中为了匹配人声，调节背景音乐音高的场景。
  ///
  /// **说明**
  ///
  /// 当前音效任务结束后，此接口的设置会恢复至默认。
  ///
  /// **参数说明**
  ///
  ///[effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  ///[pitch] 指定音效文件的音调。默认值为 0，即不调整音调，取值范围为 -12 ~ 12，按半音音阶调整。每相邻两个值的音高距离相差半音；取值的绝对值越大，音调升高或降低得越多。
  ///
  /// **相关接口**
  ///
  /// 可以调用 [getEffectPitch] 方法获取指定音效文件的音调。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误，比如 pitch 超出范围。
  ///   * 30005（invalidState)：当前状态不支持的操作，比如找不到对应的音效任务或引擎尚未初始化。
  Future<int> setEffectPitch(int effectId, int pitch);

  ///获取指定音效文件的音调。
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  ///[effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30005（invalidState)：当前状态不支持的操作，比如找不到对应的音效任务或引擎尚未初始化。
  Future<int> getEffectPitch(int effectId);

  ///设置指定音效文件的播放位置。
  ///
  ///通过此接口可以实现根据实际情况播放音效文件，而非从头到尾播放整个文件。
  ///
  ///  **使用前提**
  ///
  /// 请先调用 [playEffect] 接口播放音效文件。
  ///
  ///  **调用时机**
  ///
  /// 请在引擎初始化之后调用此接口，且该方法仅可在加入房间后调用。
  ///
  /// **参数说明**
  ///
  ///[effectId] 指定音效的 ID。每个音效均有唯一的 ID
  ///
  ///[position] 指定音效文件的起始播放位置。单位为毫秒。
  ///
  /// **相关接口**
  ///
  ///   * [getEffectCurrentPosition]：获取指定音效文件的当前播放位置。
  ///   * [NERtcAudioEffectEventCallback.onAudioEffectTimestampUpdate]：注册此回调实时获取指定音效文件的当前播放进度，默认为每隔 1s 返回一次。
  ///
  /// **返回值**
  /// * 0（OK）：方法调用成功。
  /// * 其他：方法调用失败。
  ///   * 30003（invalidParam）：参数错误，比如 effectId 无效。
  ///   * 30005（invalidState)：当前状态不支持的操作，比如找不到对应的音效任务或引擎尚未初始化。
  Future<int> setEffectPosition(int effectId, int position);
}

///音效事件回调通知
mixin class NERtcAudioEffectEventCallback {
  ///本地音效文件播放已结束回调
  ///
  /// [effectId] 指定音效的 ID。每个音效均有唯一的 ID
  void onAudioEffectFinished(int effectId) {}

  ///本地用户的指定音效文件播放进度回调。
  ///
  ///调用 playEffect()方法播放音效文件后，SDK 会触发该回调，默认每 1s 返回一次。
  ///
  /// [id] 指定音效文件的 ID。每个音效均有唯一的 ID。
  ///
  /// [timestampMs] 指定音效文件的当前播放进度。单位为毫秒。
  void onAudioEffectTimestampUpdate(int id, int timestampMs) {}
}
