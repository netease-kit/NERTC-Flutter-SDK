// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>
#import "messages.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * NERtc统计信息观察者实现类
 * 实现NERtcEngineMediaStatsObserver协议，将统计信息回调转发给Flutter层
 */
@interface NERtcStatsObserverImpl : NSObject <NERtcChannelMediaStatsObserver>

/**
 * 初始化方法
 * @param binaryMessenger Flutter二进制消息传递器
 * @param channelTag 频道标识
 */
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger
                             channelTag:(NSString *)channelTag;

@end

NS_ASSUME_NONNULL_END
