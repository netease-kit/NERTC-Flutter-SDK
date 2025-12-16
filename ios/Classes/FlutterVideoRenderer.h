// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
#import <NERtcSDK/NERtcSDK.h>
#import "NERtcCorePlugin.h"

@interface FlutterVideoRenderer : NSObject <FlutterTexture, NERtcEngineVideoRenderSink>

@property(nonatomic) int64_t textureId;

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                              messenger:(NSObject<FlutterBinaryMessenger> *)messenger;

- (void)setMirror:(BOOL)mirror;

- (void)dispose;

@end

@interface NERtcCorePlugin (VideoRendererManager)

- (FlutterVideoRenderer *)createWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                                          messenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end
