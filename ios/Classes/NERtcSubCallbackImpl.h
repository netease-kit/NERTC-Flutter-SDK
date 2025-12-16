// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>
#import "messages.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * NERtc子频道回调实现类
 * 实现NERtcChannelDelegate协议，处理子频道相关的事件回调
 */
@interface NERtcSubCallbackImpl : NSObject <NERtcChannelDelegate>

/**
 * 初始化方法
 * @param channelName 频道名称
 * @param binaryMessenger Flutter二进制消息传递器
 */
- (instancetype)initWithChannelName:(NSString *)channelName
                    binaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;

/**
 * 加入频道回调
 * @param result 加入频道结果
 * @param channelId 频道ID
 * @param elapsed 加入频道耗时
 * @param userID 用户ID
 */
- (void)onNERtcChannelDidJoinChannelWithResult:(NERtcError)result
                                     channelId:(uint64_t)channelId
                                       elapsed:(uint64_t)elapsed
                                        userID:(uint64_t)userID;

/**
 * 截图回调
 * @param code 截图结果码
 * @param path 截图路径
 */
- (void)onNERtcChannelDidTakeSnapshotWithResult:(NSNumber *)code path:(NSString *)path;

/**
 * 释放资源
 */
- (void)dispose;

@end

NS_ASSUME_NONNULL_END