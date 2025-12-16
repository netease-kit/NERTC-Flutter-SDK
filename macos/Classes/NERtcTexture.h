// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <CoreVideo/CoreVideo.h>
#import <FlutterMacOS/FlutterMacOS.h>

@interface NERtcTexture : NSObject <FlutterTexture>

@property(nonatomic, assign) int64_t textureId;
@property(nonatomic, assign) uint32_t width;
@property(nonatomic, assign) uint32_t height;

// 初始化方法
- (instancetype)initWithTextureId:(int64_t)textureId width:(uint32_t)width height:(uint32_t)height;

// 更新纹理数据
- (BOOL)updateRGBABuffer:(const uint8_t *)buffer width:(uint32_t)width height:(uint32_t)height;

// 主动清理资源
- (void)cleanup;

@end
