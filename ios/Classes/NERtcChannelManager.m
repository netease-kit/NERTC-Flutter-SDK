// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcChannelManager.h"
#import <NERtcSDK/NERtcSDK.h>
#import "NERtcStatsObserverImpl.h"
#import "NERtcSubCallbackImpl.h"

@interface NERtcChannelManager ()
@property(nonatomic, strong) NSMutableDictionary<NSString *, NERtcChannel *> *channelMaps;
@property(nonatomic, strong)
    NSMutableDictionary<NSString *, id<NERtcChannelDelegate>> *callbackMaps;
@property(nonatomic, strong)
    NSMutableDictionary<NSString *, id<NERtcChannelMediaStatsObserver>> *statsObservers;
@property(nonatomic, weak) NSObject<FlutterBinaryMessenger> *messenger;
@end

@implementation NERtcChannelManager

static NERtcChannelManager *_instance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
  dispatch_once(&onceToken, ^{
    _instance = [[NERtcChannelManager alloc] init];
  });
  return _instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _channelMaps = [[NSMutableDictionary alloc] init];
    _callbackMaps = [[NSMutableDictionary alloc] init];
    _statsObservers = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)setBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self.messenger = messenger;
}

- (NSInteger)createChannel:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    NSLog(@"[NERtcChannelManager] Channel name is empty");
    return -1;
  }

  if ([self.channelMaps objectForKey:channelName]) {
    NSLog(@"[NERtcChannelManager] Channel already exists: %@", channelName);
    return 0;
  }

  NERtcChannel *channel = [[NERtcEngine sharedEngine] createChannel:channelName];
  if (!channel) {
    NSLog(@"[NERtcChannelManager] Failed to create channel: %@", channelName);
    return -1;
  }

  // 保存到映射表
  [self.channelMaps setObject:channel forKey:channelName];

  // 创建并设置回调
  NERtcSubCallbackImpl *callback =
      [[NERtcSubCallbackImpl alloc] initWithChannelName:channelName binaryMessenger:self.messenger];
  [channel setChannelDelegate:callback];
  [self.callbackMaps setObject:callback forKey:channelName];

  return 0;
}

- (nullable NERtcChannel *)getChannel:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    return nil;
  }
  return [self.channelMaps objectForKey:channelName];
}

- (nullable id<NERtcChannelDelegate>)getCallback:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    return nil;
  }
  return [self.callbackMaps objectForKey:channelName];
}

- (void)releaseChannel:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    return;
  }

  NERtcChannel *channel = [self.channelMaps objectForKey:channelName];
  if (channel) {
    [channel setChannelDelegate:nil];
    [channel destroy];
    [self.channelMaps removeObjectForKey:channelName];
  }

  [self.callbackMaps removeObjectForKey:channelName];
  [self.statsObservers removeObjectForKey:channelName];
}

- (void)releaseAll {
  // 清空所有 channel 并销毁
  for (NSString *channelName in [self.channelMaps allKeys]) {
    NERtcChannel *channel = [self.channelMaps objectForKey:channelName];
    if (channel) {
      [channel setChannelDelegate:nil];
      [channel destroy];
    }
  }

  // 清空所有映射表
  [self.channelMaps removeAllObjects];
  [self.callbackMaps removeAllObjects];
  [self.statsObservers removeAllObjects];
}

- (nullable id<NERtcChannelMediaStatsObserver>)createStatsObserver:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    NSLog(@"[NERtcChannelManager] Channel name is empty");
    return nil;
  }

  id<NERtcChannelMediaStatsObserver> existingObserver =
      [self.statsObservers objectForKey:channelName];
  if (existingObserver) {
    return existingObserver;
  }

  NERtcStatsObserverImpl *observer =
      [[NERtcStatsObserverImpl alloc] initWithBinaryMessenger:self.messenger
                                                   channelTag:channelName];
  [self.statsObservers setObject:observer forKey:channelName];
  return observer;
}

- (nullable id<NERtcChannelMediaStatsObserver>)getStatsObserver:(NSString *)channelName {
  if (!channelName || channelName.length == 0) {
    return nil;
  }
  return [self.statsObservers objectForKey:channelName];
}

@end
