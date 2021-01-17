// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

/// 通话相关的统计信息
class NERtcStats {
  /// 发送字节数（Byte），累计值
  int txBytes;

  /// 接收字节数（Byte），累计值
  int rxBytes;

  /// 当前 App 的 CPU 使用率 (%)
  ///  <p>Android 8.0及后续版本无法获取<p/>
  int cpuAppUsage;

  /// 当前系统的 CPU 使用率 (%)
  /// <p>Android 8.0及后续版本无法获取<p/>
  int cpuTotalUsage;

  /// 当前 App 的内存占比 (%) , 占最大可用内存
  int memoryAppUsageRatio;

  /// 当前系统的内存占比 (%)
  int memoryTotalUsageRatio;

  /// 当前 App 的内存大小 (KB)
  int memoryAppUsageInKBytes;

  /// 自加入频道的通话时长， 退出后再加入重新计时 ( 单位：S)
  int totalDuration;

  /// 自加入频道后累计的发送的音频字节数（Byte）
  int txAudioBytes;

  /// 自加入频道后累计的发送的视频字节数（Byte）
  int txVideoBytes;

  /// 自加入频道后累计的接收的音频字节数（Byte）
  int rxAudioBytes;

  /// 自加入频道后累计的接收的视频字节数（Byte）
  int rxVideoBytes;

  /// 音频接收码率（kbps）
  int rxAudioKBitRate;

  /// 视频接收码率（kbps）
  int rxVideoKBitRate;

  /// 音频发送码率（kbps）
  int txAudioKBitRate;

  /// 视频发送码率（kbps）
  int txVideoKBitRate;

  /// 上行平均往返时延(ms)
  int upRtt;

  /// 本地上行音频丢包率(%)
  int txAudioPacketLossRate;

  /// 本地上行视频实际丢包率(%)
  int txVideoPacketLossRate;

  /// 本地上行音频丢包数
  int txAudioPacketLossSum;

  /// 本地上行视频丢包数
  int txVideoPacketLossSum;

  /// 本地上行音频抖动 (ms)
  int txAudioJitter;

  /// 本地上行视频抖动 (ms)
  int txVideoJitter;

  /// 本地下行音频丢包率(%)
  int rxAudioPacketLossRate;

  /// 本地下行视频丢包率(%)
  int rxVideoPacketLossRate;

  /// 本地下行音频丢包数
  int rxAudioPacketLossSum;

  /// 本地下行视频丢包数
  int rxVideoPacketLossSum;

  /// 本地下行音频抖动 (ms)
  int rxAudioJitter;

  /// 本地下行视频抖动 (ms)
  int rxVideoJitter;

  NERtcStats.fromMap(Map stats)
      : txBytes = stats['txBytes'],
        rxBytes = stats['rxBytes'],
        cpuAppUsage = stats['cpuAppUsage'],
        cpuTotalUsage = stats['cpuTotalUsage'],
        memoryAppUsageRatio = stats['memoryAppUsageRatio'],
        memoryTotalUsageRatio = stats['memoryTotalUsageRatio'],
        memoryAppUsageInKBytes = stats['memoryAppUsageInKBytes'],
        totalDuration = stats['totalDuration'],
        txAudioBytes = stats['txAudioBytes'],
        txVideoBytes = stats['txVideoBytes'],
        rxAudioBytes = stats['rxAudioBytes'],
        rxVideoBytes = stats['rxVideoBytes'],
        rxAudioKBitRate = stats['rxAudioKBitRate'],
        rxVideoKBitRate = stats['rxVideoKBitRate'],
        txAudioKBitRate = stats['txAudioKBitRate'],
        txVideoKBitRate = stats['txVideoKBitRate'],
        upRtt = stats['upRtt'],
        txAudioPacketLossRate = stats['txAudioPacketLossRate'],
        txVideoPacketLossRate = stats['txVideoPacketLossRate'],
        txAudioPacketLossSum = stats['txAudioPacketLossSum'],
        txVideoPacketLossSum = stats['txVideoPacketLossSum'],
        txAudioJitter = stats['txAudioJitter'],
        txVideoJitter = stats['txVideoJitter'],
        rxAudioPacketLossRate = stats['rxAudioPacketLossRate'],
        rxVideoPacketLossRate = stats['rxVideoPacketLossRate'],
        rxAudioPacketLossSum = stats['rxAudioPacketLossSum'],
        rxVideoPacketLossSum = stats['rxVideoPacketLossSum'],
        rxAudioJitter = stats['rxAudioJitter'],
        rxVideoJitter = stats['rxVideoJitter'];

  @override
  String toString() {
    return 'NERtcStats{txBytes: $txBytes, rxBytes: $rxBytes, '
        'cpuAppUsage: $cpuAppUsage, cpuTotalUsage: $cpuTotalUsage, '
        'memoryAppUsageRatio: $memoryAppUsageRatio, '
        'memoryTotalUsageRatio: $memoryTotalUsageRatio, '
        'memoryAppUsageInKBytes: $memoryAppUsageInKBytes, '
        'totalDuration: $totalDuration, txAudioBytes: $txAudioBytes, '
        'txVideoBytes: $txVideoBytes, rxAudioBytes: $rxAudioBytes, '
        'rxVideoBytes: $rxVideoBytes, rxAudioKBitRate: $rxAudioKBitRate, '
        'rxVideoKBitRate: $rxVideoKBitRate, txAudioKBitRate: $txAudioKBitRate, '
        'txVideoKBitRate: $txVideoKBitRate, upRtt: $upRtt, '
        'txAudioPacketLossRate: $txAudioPacketLossRate, '
        'txVideoPacketLossRate: $txVideoPacketLossRate, '
        'txAudioPacketLossSum: $txAudioPacketLossSum, '
        'txVideoPacketLossSum: $txVideoPacketLossSum, '
        'txAudioJitter: $txAudioJitter, txVideoJitter: $txVideoJitter, '
        'rxAudioPacketLossRate: $rxAudioPacketLossRate, '
        'rxVideoPacketLossRate: $rxVideoPacketLossRate, '
        'rxAudioPacketLossSum: $rxAudioPacketLossSum, '
        'rxVideoPacketLossSum: $rxVideoPacketLossSum, '
        'rxAudioJitter: $rxAudioJitter, rxVideoJitter: $rxVideoJitter}';
  }
}

/// 远端用户的音频统计
class NERtcAudioRecvStats {
  /// 用户 ID，指定是哪个用户的音频流
  int uid;

  /// 接收到的码率 (kbps)
  int kbps;

  /// 丢包率
  int lossRate;

  /// 音量[0-100]
  int volume;

  /// 音频卡顿累计时长，从收到远端用户音频算起
  int totalFrozenTime;

  /// 平均音频卡顿率
  int frozenRate;

  NERtcAudioRecvStats.fromMap(Map stats)
      : uid = stats['uid'],
        kbps = stats['kbps'],
        lossRate = stats['lossRate'],
        volume = stats['volume'],
        totalFrozenTime = stats['totalFrozenTime'],
        frozenRate = stats['frozenRate'];

  @override
  String toString() {
    return 'NERtcAudioRecvStats{uid: $uid, kbps: $kbps, lossRate: $lossRate, '
        'volume: $volume, totalFrozenTime: $totalFrozenTime, frozenRate: $frozenRate}';
  }
}

/// 本地音频流上传统计信息
class NERtcAudioSendStats {
  /// 发送码率
  int kbps;

  /// 特定时间内的音频丢包率
  int lossRate;

  /// 环路延迟
  int rtt;

  /// 音量[0-100]
  int volume;

  /// 本地音频采集声道数
  int numChannels;

  /// 本地音频采样率（Hz）
  int sentSampleRate;

  NERtcAudioSendStats.fromMap(Map stats)
      : kbps = stats['kbps'],
        lossRate = stats['lossRate'],
        rtt = stats['rtt'],
        volume = stats['volume'],
        numChannels = stats['numChannels'],
        sentSampleRate = stats['sentSampleRate'];

  @override
  String toString() {
    return 'NERtcAudioSendStats{kbps: $kbps, lossRate: $lossRate, '
        'rtt: $rtt, volume: $volume, numChannels: $numChannels, '
        'sentSampleRate: $sentSampleRate}';
  }
}


/// 远端每条视频流的统计信息
class NERtcVideoLayerRecvStats {

  /// 流的类型. [NERtcVideoStreamType]
  int layerType;

  /// 视频流宽
  int width;

  /// 视频流高
  int height;

  /// 接收到的码率
  int receivedBitrate;

  /// 接收到的帧率
  int fps;

  /// 接收视频的丢包率
  int packetLossRate;

  /// 解码器输出帧率
  int decoderOutputFrameRate;

  /// 渲染帧率
  int rendererOutputFrameRate;

  /// 接收视频卡顿累计时长（ms）， 从收到对应用户的视频算起
  int totalFrozenTime;

  /// 接收视频的平均卡顿率
  int frozenRate;

  NERtcVideoLayerRecvStats.fromMap(Map stats)
      : layerType = stats['layerType'],
        width = stats['width'],
        height = stats['height'],
        receivedBitrate = stats['receivedBitrate'],
        fps = stats['fps'],
        packetLossRate = stats['packetLossRate'],
        decoderOutputFrameRate = stats['decoderOutputFrameRate'],
        rendererOutputFrameRate = stats['rendererOutputFrameRate'],
        totalFrozenTime = stats['totalFrozenTime'],
        frozenRate = stats['frozenRate'];

  @override
  String toString() {
    return 'NERtcVideoLayerRecvStats{layerType: $layerType,'
        ' width: $width, height: $height, '
        'receivedBitrate: $receivedBitrate, '
        'fps: $fps, packetLossRate: $packetLossRate, '
        'decoderOutputFrameRate: $decoderOutputFrameRate, '
        'rendererOutputFrameRate: $rendererOutputFrameRate, '
        'totalFrozenTime: $totalFrozenTime, frozenRate: $frozenRate}';
  }
}

/// 远端视频流的统计信息
class NERtcVideoRecvStats {
  /// 用户 ID，指定是哪个用户的视频流
  int uid;

  /// 当前uid 每条流的接收下行统计信息
  List<NERtcVideoLayerRecvStats> layers = List();

  NERtcVideoRecvStats.fromMap(Map stats) {
    uid = stats['uid'];
    List mapLayers = stats['layers'];
    for(var layer in mapLayers) {
        layers.add(NERtcVideoLayerRecvStats.fromMap(layer));
    }
  }

  @override
  String toString() {
    return 'NERtcVideoRecvStats{uid: $uid, layers: $layers}';
  }
}


/// 本地视频单条流统计信息
class NERtcVideoLayerSendStats {
  /// 流的类型. [NERtcVideoStreamType]
  int layerType;

  /// 视频流宽
  int width;

  /// 视频流高
  int height;

  /// 发送码率(kbps)
  int sendBitrate;

  /// 编码输出帧率
  int encoderOutputFrameRate;

  /// 视频采集帧率
  int captureFrameRate;

  /// 编码器的目标码率(kbps)
  int targetBitrate;

  /// 编码器的实际编码码率(kbps)
  int encoderBitrate;

  /// 视频发送帧率
  int sentFrameRate;

  /// 视频渲染帧率
  int renderFrameRate;

  NERtcVideoLayerSendStats.fromMap(Map stats)
      : layerType = stats['layerType'],
        width = stats['width'],
        height = stats['height'],
        sendBitrate = stats['sendBitrate'],
        encoderOutputFrameRate = stats['encoderOutputFrameRate'],
        captureFrameRate = stats['captureFrameRate'],
        targetBitrate = stats['targetBitrate'],
        encoderBitrate = stats['encoderBitrate'],
        sentFrameRate = stats['sentFrameRate'],
        renderFrameRate = stats['renderFrameRate'];

  @override
  String toString() {
    return 'NERtcVideoLayerSendStats{layerType: $layerType, '
        'width: $width, height: $height, sendBitrate: $sendBitrate, '
        'encoderOutputFrameRate: $encoderOutputFrameRate, '
        'captureFrameRate: $captureFrameRate, targetBitrate: $targetBitrate, '
        'sentFrameRate: $sentFrameRate}';
  }
}

/// 本地视频流上传统计信息
class NERtcVideoSendStats {
  /// 具体每条流的上行统计信息
  List<NERtcVideoLayerSendStats> layers =  List();

  NERtcVideoSendStats.fromMap(Map stats) {
    List mapLayers = stats['layers'];
    for(var layer in mapLayers) {
      layers.add(NERtcVideoLayerSendStats.fromMap(layer));
    }
  }

  @override
  String toString() {
    return 'NERtcVideoSendStats{layers: $layers}';
  }
}

/// 语音音量
class NERtcAudioVolumeInfo {
  /// 用户 ID
  int uid;

  /// 音量[0-100]
  int volume;

  NERtcAudioVolumeInfo.fromMap(Map stats)
      : uid = stats['uid'],
        volume = stats['volume'];

  @override
  String toString() {
    return 'AudioVolumeInfo{uid: $uid, volume: $volume}';
  }
}

/// 用户的网络质量
class NERtcNetworkQualityInfo {
  /// 用户 ID
  int uid;

  /// 上行网络质量 [NERTcNetworkStatus]
  int txQuality;

  /// 下行网络质量 [NERTcNetworkStatus]
  int rxQuality;

  NERtcNetworkQualityInfo.fromMap(Map stats)
      : uid = stats['uid'],
        txQuality = stats['txQuality'],
        rxQuality = stats['rxQuality'];

  @override
  String toString() {
    return 'NERtcNetworkQualityInfo{uid: $uid, txQuality: $txQuality, rxQuality: $rxQuality}';
  }
}
