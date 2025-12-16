// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLNERtcEngineVideoFrameObserver_h
#define FLNERtcEngineVideoFrameObserver_h

#endif /* FLNERtcEngineVideoFrameObserver_h */

#import <NERtcSDK/NERtcSDK.h>
/**
 本地视频数据采集回调
 如果需要对采集数据做美颜等处理，需要实现这个 protocol
 */
@protocol FLNERtcEngineVideoFrameObserver <NSObject>

@optional

/**
 视频采集帧回调
 需要同步返回，enqine 将会继续视频处理流程

 @param bufferRef CVPixelBufferRef, iOS 原生格式
 @param rotation 视频方向
 */
- (void)onNERtcEngineVideoFrameCaptured:(CVPixelBufferRef)bufferRef
                               rotation:(NERtcVideoRotationType)rotation;
@end
