// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>
#import "messages.h"

NS_ASSUME_NONNULL_BEGIN

@interface NERtcChannelImpl : NSObject <NEFLTChannelApi>

/**
 * 初始化方法
 * @param messenger Flutter 二进制消息传递器
 */
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END