// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface NERtcChannelManager : NSObject

/**
 * 获取单例实例
 */
+ (instancetype)sharedInstance;

/**
 * 设置二进制消息传递器
 * @param messenger Flutter二进制消息传递器
 */
- (void)setBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

/**
 * 创建频道
 * @param channelName 频道名称
 * @return 0表示成功，-1表示失败
 */
- (NSInteger)createChannel:(NSString *)channelName;

/**
 * 获取频道实例
 * @param channelName 频道名称
 * @return 频道实例，如果不存在则返回nil
 */
- (nullable NERtcChannel *)getChannel:(NSString *)channelName;

/**
 * 获取频道回调实例
 * @param channelName 频道名称
 * @return 频道回调实例，如果不存在则返回nil
 */
- (nullable id<NERtcChannelDelegate>)getCallback:(NSString *)channelName;

/**
 * 释放频道资源
 * @param channelName 频道名称
 */
- (void)releaseChannel:(NSString *)channelName;

- (void)releaseAll;

/**
 * 创建统计观察者
 * @param channelName 频道名称
 * @return 统计观察者实例，如果创建失败则返回nil
 */
- (nullable id<NERtcChannelMediaStatsObserver>)createStatsObserver:(NSString *)channelName;

/**
 * 获取统计观察者
 * @param channelName 频道名称
 * @return 统计观察者实例，如果不存在则返回nil
 */
- (nullable id<NERtcChannelMediaStatsObserver>)getStatsObserver:(NSString *)channelName;

@end

NS_ASSUME_NONNULL_END
