// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcStatsObserverImpl.h"

@interface NERtcStatsObserverImpl ()

@property(nonatomic, strong) NEFLTNERtcStatsEventSink *eventSink;
@property(nonatomic, copy) NSString *channelTag;

@end

@implementation NERtcStatsObserverImpl

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                             channelTag:(NSString *)channelTag {
  self = [super init];
  if (self) {
    _eventSink = [[NEFLTNERtcStatsEventSink alloc] initWithBinaryMessenger:binaryMessenger];
    _channelTag = [channelTag copy];
  }
  return self;
}

#pragma mark - NERtcEngineMediaStatsObserver

- (void)onRtcStats:(NERtcStats *)stat {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onRtcStats");
#endif
  if (!stat) return;

  NSDictionary *statsDic = [self toRtcStats:stat];
  [_eventSink onRtcStatsArguments:statsDic
                       channelTag:_channelTag
                       completion:^(FlutterError *_Nullable error) {
                         if (error) {
                           NSLog(@"onRtcStats error: %@", error.message);
                         }
                       }];
}

- (void)onLocalAudioStat:(NERtcAudioSendStats *)stat {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onLocalAudioStat");
#endif
  if (!stat) return;

  NSDictionary *statsDic = [self toLocalAudioStats:stat];
  [_eventSink onLocalAudioStatsArguments:statsDic
                              channelTag:_channelTag
                              completion:^(FlutterError *_Nullable error) {
                                if (error) {
                                  NSLog(@"onLocalAudioStat error: %@", error.message);
                                }
                              }];
}

- (void)onRemoteAudioStats:(NSArray<NERtcAudioRecvStats *> *)stats {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onRemoteAudioStats");
#endif
  if (!stats || stats.count == 0) return;

  NSMutableArray<NSDictionary *> *statsList = [[NSMutableArray alloc] init];
  for (NERtcAudioRecvStats *stat in stats) {
    NSDictionary *statDic = [self toRemoteAudioStats:stat];
    if (statDic) {
      [statsList addObject:statDic];
    }
  }

  NSDictionary *resultDic = @{@"list" : statsList};
  [_eventSink onRemoteAudioStatsArguments:resultDic
                               channelTag:_channelTag
                               completion:^(FlutterError *_Nullable error) {
                                 if (error) {
                                   NSLog(@"onRemoteAudioStats error: %@", error.message);
                                 }
                               }];
}

- (void)onLocalVideoStat:(NERtcVideoSendStats *)stat {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onLocalVideoStat");
#endif
  if (!stat) return;

  NSDictionary *statsDic = [self toLocalVideoStats:stat];
  [_eventSink onLocalVideoStatsArguments:statsDic
                              channelTag:_channelTag
                              completion:^(FlutterError *_Nullable error) {
                                if (error) {
                                  NSLog(@"onLocalVideoStat error: %@", error.message);
                                }
                              }];
}

- (void)onRemoteVideoStats:(NSArray<NERtcVideoRecvStats *> *)stats {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onRemoteVideoStats");
#endif
  if (!stats || stats.count == 0) return;

  NSMutableArray<NSDictionary *> *statsList = [[NSMutableArray alloc] init];
  for (NERtcVideoRecvStats *stat in stats) {
    NSDictionary *statDic = [self toRemoteVideoStats:stat];
    if (statDic) {
      [statsList addObject:statDic];
    }
  }

  NSDictionary *resultDic = @{@"list" : statsList};
  [_eventSink onRemoteVideoStatsArguments:resultDic
                               channelTag:_channelTag
                               completion:^(FlutterError *_Nullable error) {
                                 if (error) {
                                   NSLog(@"onRemoteVideoStats error: %@", error.message);
                                 }
                               }];
}

- (void)onNetworkQuality:(NSArray<NERtcNetworkQualityStats *> *)stats {
#ifdef DEBUG
  NSLog(@"NERtcStatsObserverImpl:onNetworkQuality");
#endif
  if (!stats || stats.count == 0) return;

  NSMutableArray<NSDictionary *> *statsList = [[NSMutableArray alloc] init];
  for (NERtcNetworkQualityStats *stat in stats) {
    NSDictionary *statDic = [self toNetworkQualityStats:stat];
    if (statDic) {
      [statsList addObject:statDic];
    }
  }

  NSDictionary *resultDic = @{@"list" : statsList};
  [_eventSink onNetworkQualityArguments:resultDic
                             channelTag:_channelTag
                             completion:^(FlutterError *_Nullable error) {
                               if (error) {
                                 NSLog(@"onNetworkQuality error: %@", error.message);
                               }
                             }];
}

#pragma mark - Private Methods

- (NSDictionary *)toRtcStats:(NERtcStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:@(stat.txBytes) forKey:@"txBytes"];
  [map setObject:@(stat.rxBytes) forKey:@"rxBytes"];
  [map setObject:@(stat.cpuAppUsage) forKey:@"cpuAppUsage"];
  [map setObject:@(stat.cpuTotalUsage) forKey:@"cpuTotalUsage"];
  [map setObject:@(stat.memoryAppUsageRatio) forKey:@"memoryAppUsageRatio"];
  [map setObject:@(stat.memoryTotalUsageRatio) forKey:@"memoryTotalUsageRatio"];
  [map setObject:@(stat.memoryAppUsageInKBytes) forKey:@"memoryAppUsageInKBytes"];
  [map setObject:@(stat.totalDuration) forKey:@"totalDuration"];
  [map setObject:@(stat.txAudioBytes) forKey:@"txAudioBytes"];
  [map setObject:@(stat.txVideoBytes) forKey:@"txVideoBytes"];
  [map setObject:@(stat.rxAudioBytes) forKey:@"rxAudioBytes"];
  [map setObject:@(stat.rxVideoBytes) forKey:@"rxVideoBytes"];
  [map setObject:@(stat.rxAudioKBitRate) forKey:@"rxAudioKBitRate"];
  [map setObject:@(stat.rxVideoKBitRate) forKey:@"rxVideoKBitRate"];
  [map setObject:@(stat.txAudioKBitRate) forKey:@"txAudioKBitRate"];
  [map setObject:@(stat.txVideoKBitRate) forKey:@"txVideoKBitRate"];
  [map setObject:@(stat.upRtt) forKey:@"upRtt"];
  [map setObject:@(stat.downRtt) forKey:@"downRtt"];
  [map setObject:@(stat.txAudioPacketLossRate) forKey:@"txAudioPacketLossRate"];
  [map setObject:@(stat.txVideoPacketLossRate) forKey:@"txVideoPacketLossRate"];
  [map setObject:@(stat.txAudioPacketLossSum) forKey:@"txAudioPacketLossSum"];
  [map setObject:@(stat.txVideoPacketLossSum) forKey:@"txVideoPacketLossSum"];
  [map setObject:@(stat.txAudioJitter) forKey:@"txAudioJitter"];
  [map setObject:@(stat.txVideoJitter) forKey:@"txVideoJitter"];
  [map setObject:@(stat.rxAudioPacketLossRate) forKey:@"rxAudioPacketLossRate"];
  [map setObject:@(stat.rxVideoPacketLossRate) forKey:@"rxVideoPacketLossRate"];
  [map setObject:@(stat.rxAudioPacketLossSum) forKey:@"rxAudioPacketLossSum"];
  [map setObject:@(stat.rxVideoPacketLossSum) forKey:@"rxVideoPacketLossSum"];
  [map setObject:@(stat.rxAudioJitter) forKey:@"rxAudioJitter"];
  [map setObject:@(stat.rxVideoJitter) forKey:@"rxVideoJitter"];
  return map;
}

- (NSDictionary *)toLocalAudioStats:(NERtcAudioSendStats *)stat {
  NSMutableDictionary *statsMap = [[NSMutableDictionary alloc] init];
  NSMutableArray<NSDictionary *> *layers = [[NSMutableArray alloc] init];

  for (NERtcAudioLayerSendStats *layer in stat.audioLayers) {
    NSMutableDictionary *layerMap = [[NSMutableDictionary alloc] init];
    int streamType = (layer.streamType == kNERtcAudioStreamMain) ? 0 : 1;
    [layerMap setObject:@(streamType) forKey:@"streamType"];
    [layerMap setObject:@(layer.sentBitrate) forKey:@"kbps"];
    [layerMap setObject:@(layer.lossRate) forKey:@"lossRate"];
    [layerMap setObject:@(layer.rtt) forKey:@"rtt"];
    [layerMap setObject:@(layer.volume) forKey:@"volume"];
    [layerMap setObject:@(layer.numChannels) forKey:@"numChannels"];
    [layerMap setObject:@(layer.sentSampleRate) forKey:@"sentSampleRate"];
    [layerMap setObject:@(layer.capVolume) forKey:@"capVolume"];
    [layers addObject:layerMap];
  }
  [statsMap setObject:layers forKey:@"layers"];
  return statsMap;
}

- (NSDictionary *)toRemoteAudioStats:(NERtcAudioRecvStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:@(stat.uid) forKey:@"uid"];

  NSMutableArray<NSDictionary *> *layers = [[NSMutableArray alloc] init];
  if (stat.audioLayers) {
    for (NERtcAudioLayerRecvStats *layer in stat.audioLayers) {
      NSMutableDictionary *layerMap = [[NSMutableDictionary alloc] init];
      int streamType = (layer.streamType == kNERtcAudioStreamMain) ? 0 : 1;
      [layerMap setObject:@(layer.receivedBitrate) forKey:@"kbps"];
      [layerMap setObject:@(layer.audioLossRate) forKey:@"lossRate"];
      [layerMap setObject:@(layer.volume) forKey:@"volume"];
      [layerMap setObject:@(layer.totalFrozenTime) forKey:@"totalFrozenTime"];
      [layerMap setObject:@(layer.frozenRate) forKey:@"frozenRate"];
      [layerMap setObject:@(streamType) forKey:@"streamType"];
      [layers addObject:layerMap];
    }
  }
  [map setObject:layers forKey:@"list"];
  return map;
}

- (NSDictionary *)toLocalVideoStats:(NERtcVideoSendStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  NSMutableArray<NSDictionary *> *layers = [[NSMutableArray alloc] init];

  if (stat.videoLayers) {
    for (NERtcVideoLayerSendStats *layer in stat.videoLayers) {
      NSMutableDictionary *layerMap = [[NSMutableDictionary alloc] init];
      [layerMap setObject:@(layer.layerType) forKey:@"layerType"];
      [layerMap setObject:@(layer.captureWidth) forKey:@"captureWidth"];
      [layerMap setObject:@(layer.captureHeight) forKey:@"captureHeight"];
      [layerMap setObject:@(layer.width) forKey:@"width"];
      [layerMap setObject:@(layer.height) forKey:@"height"];
      [layerMap setObject:@(layer.sendBitrate) forKey:@"sendBitrate"];
      [layerMap setObject:@(layer.encoderOutputFrameRate) forKey:@"encoderOutputFrameRate"];
      [layerMap setObject:@(layer.captureFrameRate) forKey:@"captureFrameRate"];
      [layerMap setObject:@(layer.targetBitrate) forKey:@"targetBitrate"];
      [layerMap setObject:@(layer.encoderBitrate) forKey:@"encoderBitrate"];
      [layerMap setObject:@(layer.sentFrameRate) forKey:@"sentFrameRate"];
      [layerMap setObject:@(layer.renderFrameRate) forKey:@"renderFrameRate"];
      [layerMap setObject:layer.encoderName ?: @"" forKey:@"encoderName"];
      [layerMap setObject:@(layer.dropBwStrategyEnabled) forKey:@"dropBwStrategyEnabled"];
      [layers addObject:layerMap];
    }
  }
  [map setObject:layers forKey:@"layers"];
  return map;
}

- (NSDictionary *)toRemoteVideoStats:(NERtcVideoRecvStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:@(stat.uid) forKey:@"uid"];

  NSMutableArray<NSDictionary *> *layers = [[NSMutableArray alloc] init];
  if (stat.videoLayers) {
    for (NERtcVideoLayerRecvStats *layer in stat.videoLayers) {
      NSMutableDictionary *layerMap = [[NSMutableDictionary alloc] init];
      [layerMap setObject:@(layer.layerType) forKey:@"layerType"];
      [layerMap setObject:@(layer.width) forKey:@"width"];
      [layerMap setObject:@(layer.height) forKey:@"height"];
      [layerMap setObject:@(layer.receivedBitrate) forKey:@"receivedBitrate"];
      [layerMap setObject:@(layer.fps) forKey:@"fps"];
      [layerMap setObject:@(layer.packetLossRate) forKey:@"packetLossRate"];
      [layerMap setObject:@(layer.decoderOutputFrameRate) forKey:@"decoderOutputFrameRate"];
      [layerMap setObject:@(layer.rendererOutputFrameRate) forKey:@"rendererOutputFrameRate"];
      [layerMap setObject:@(layer.totalFrozenTime) forKey:@"totalFrozenTime"];
      [layerMap setObject:@(layer.frozenRate) forKey:@"frozenRate"];
      [layerMap setObject:layer.decoderName ?: @"" forKey:@"decoderName"];
      [layers addObject:layerMap];
    }
  }
  [map setObject:layers forKey:@"layers"];
  return map;
}

- (NSDictionary *)toNetworkQualityStats:(NERtcNetworkQualityStats *)stat {
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  [map setObject:@(stat.userId) forKey:@"uid"];
  [map setObject:@(stat.txQuality) forKey:@"txQuality"];
  [map setObject:@(stat.rxQuality) forKey:@"rxQuality"];
  return map;
}

@end