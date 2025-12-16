// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcTexture.h"
#import <Foundation/Foundation.h>

@interface NERtcTexture ()

@property(nonatomic, assign) CVPixelBufferRef pixelBuffer;
@property(nonatomic, assign) BOOL hasNewFrame;
@property(nonatomic, strong) dispatch_queue_t bufferQueue;

@end

@implementation NERtcTexture

- (instancetype)initWithTextureId:(int64_t)textureId width:(uint32_t)width height:(uint32_t)height {
  if (self = [super init]) {
    _textureId = textureId;
    _width = width;
    _height = height;
    _pixelBuffer = NULL;
    _hasNewFrame = NO;

    // 创建串行队列来管理缓冲区操作
    _bufferQueue = dispatch_queue_create("com.netease.nertc.texture.buffer", DISPATCH_QUEUE_SERIAL);

    NSLog(@"NERtcTexture initialized with textureId: %lld, size: %ux%u", textureId, width, height);
  }
  return self;
}

- (void)cleanup {
  dispatch_sync(_bufferQueue, ^{
    if (self.pixelBuffer) {
      CVPixelBufferRelease(self.pixelBuffer);
      self.pixelBuffer = NULL;
    }
    self.hasNewFrame = NO;
  });
}

- (void)dealloc {
  NSLog(@"NERtcTexture dealloc: textureId %lld", _textureId);
  [self cleanup];  // 确保资源被释放
}

- (BOOL)updateRGBABuffer:(const uint8_t *)buffer width:(uint32_t)width height:(uint32_t)height {
  if (!buffer) {
    NSLog(@"Error: RGBA buffer is null for texture %lld", _textureId);
    return NO;
  }

  if (width == 0 || height == 0) {
    NSLog(@"Error: Invalid dimensions %ux%u for texture %lld", width, height, _textureId);
    return NO;
  }

  // NSLog(@"Updating texture %lld with RGBA data: size %ux%u", _textureId, width, height);

  __block BOOL success = NO;

  if (dispatch_get_current_queue() == _bufferQueue) {
    // 已在目标队列，直接执行更新逻辑
    // 如果尺寸发生变化，需要重新创建 pixel buffer
    if (self.pixelBuffer && (self.width != width || self.height != height)) {
      // 确保引用计数正确
      CVPixelBufferRelease(self.pixelBuffer);
      self.pixelBuffer = NULL;
      NSLog(@"Released old CVPixelBuffer for texture %lld due to size change", self.textureId);
    }

    // 创建新的 pixel buffer（如果需要）
    if (!self.pixelBuffer) {
      NSDictionary *options = @{
        (NSString *)kCVPixelBufferCGImageCompatibilityKey : @YES,
        (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
        (NSString *)kCVPixelBufferMetalCompatibilityKey : @YES
      };

      CVReturn status =
          CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA,
                              (__bridge CFDictionaryRef)options, &self->_pixelBuffer);

      if (status != kCVReturnSuccess) {
        NSLog(@"Error: Failed to create CVPixelBuffer for texture %lld, status: %d", self.textureId,
              status);
        return NO;
      }

      self.width = width;
      self.height = height;
      NSLog(@"Created new CVPixelBuffer for texture %lld with size %ux%u", self.textureId, width,
            height);
    }

    // 锁定 pixel buffer 基地址
    CVReturn lockStatus = CVPixelBufferLockBaseAddress(self.pixelBuffer, 0);
    if (lockStatus != kCVReturnSuccess) {
      NSLog(@"Error: Failed to lock CVPixelBuffer for texture %lld, status: %d", self.textureId,
            lockStatus);
      return NO;
    }

    // 获取 pixel buffer 信息
    void *pixelData = CVPixelBufferGetBaseAddress(self.pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(self.pixelBuffer);

    //        size_t pixelBufferHeight = CVPixelBufferGetHeight(self.pixelBuffer);
    //        size_t pixelBufferWidth = CVPixelBufferGetWidth(self.pixelBuffer);
    //        NSLog(@"Updating texture %lld: source=%ux%u, dest=%zux%zu, bytesPerRow=%zu",
    //              self.textureId, width, height, pixelBufferWidth, pixelBufferHeight,
    //              bytesPerRow);

    // 将 RGBA 数据转换为 BGRA 并复制到 pixel buffer
    uint8_t *destRow = (uint8_t *)pixelData;
    const uint8_t *srcRow = buffer;

    for (uint32_t y = 0; y < height; y++) {
      uint8_t *dest = destRow;
      const uint8_t *src = srcRow;

      for (uint32_t x = 0; x < width; x++) {
        // 从 RGBA 转换到 BGRA
        dest[0] = src[2];  // B <- R
        dest[1] = src[1];  // G <- G
        dest[2] = src[0];  // R <- B
        dest[3] = src[3];  // A <- A

        dest += 4;
        src += 4;
      }

      destRow += bytesPerRow;
      srcRow += width * 4;  // 源数据每行宽度 * 4 字节
    }

    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(self.pixelBuffer, 0);

    // 标记有新帧
    self.hasNewFrame = YES;
    success = YES;

    // NSLog(@"Successfully updated texture %lld with RGBA data", self.textureId);
  } else {
    dispatch_sync(_bufferQueue, ^{
      // 如果尺寸发生变化，需要重新创建 pixel buffer
      if (self.pixelBuffer && (self.width != width || self.height != height)) {
        // 确保引用计数正确
        CVPixelBufferRelease(self.pixelBuffer);
        self.pixelBuffer = NULL;
        NSLog(@"Released old CVPixelBuffer for texture %lld due to size change", self.textureId);
      }

      // 创建新的 pixel buffer（如果需要）
      if (!self.pixelBuffer) {
        NSDictionary *options = @{
          (NSString *)kCVPixelBufferCGImageCompatibilityKey : @YES,
          (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
          (NSString *)kCVPixelBufferMetalCompatibilityKey : @YES
        };

        CVReturn status =
            CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA,
                                (__bridge CFDictionaryRef)options, &self->_pixelBuffer);

        if (status != kCVReturnSuccess) {
          NSLog(@"Error: Failed to create CVPixelBuffer for texture %lld, status: %d",
                self.textureId, status);
          return;
        }

        self.width = width;
        self.height = height;
        NSLog(@"Created new CVPixelBuffer for texture %lld with size %ux%u", self.textureId, width,
              height);
      }

      // 锁定 pixel buffer 基地址
      CVReturn lockStatus = CVPixelBufferLockBaseAddress(self.pixelBuffer, 0);
      if (lockStatus != kCVReturnSuccess) {
        NSLog(@"Error: Failed to lock CVPixelBuffer for texture %lld, status: %d", self.textureId,
              lockStatus);
        return;
      }

      // 获取 pixel buffer 信息
      void *pixelData = CVPixelBufferGetBaseAddress(self.pixelBuffer);
      size_t bytesPerRow = CVPixelBufferGetBytesPerRow(self.pixelBuffer);

      //        size_t pixelBufferHeight = CVPixelBufferGetHeight(self.pixelBuffer);
      //        size_t pixelBufferWidth = CVPixelBufferGetWidth(self.pixelBuffer);
      //        NSLog(@"Updating texture %lld: source=%ux%u, dest=%zux%zu, bytesPerRow=%zu",
      //              self.textureId, width, height, pixelBufferWidth, pixelBufferHeight,
      //              bytesPerRow);

      // 将 RGBA 数据转换为 BGRA 并复制到 pixel buffer
      uint8_t *destRow = (uint8_t *)pixelData;
      const uint8_t *srcRow = buffer;

      for (uint32_t y = 0; y < height; y++) {
        uint8_t *dest = destRow;
        const uint8_t *src = srcRow;

        for (uint32_t x = 0; x < width; x++) {
          // 从 RGBA 转换到 BGRA
          dest[0] = src[2];  // B <- R
          dest[1] = src[1];  // G <- G
          dest[2] = src[0];  // R <- B
          dest[3] = src[3];  // A <- A

          dest += 4;
          src += 4;
        }

        destRow += bytesPerRow;
        srcRow += width * 4;  // 源数据每行宽度 * 4 字节
      }

      // 解锁 pixel buffer
      CVPixelBufferUnlockBaseAddress(self.pixelBuffer, 0);

      // 标记有新帧
      self.hasNewFrame = YES;
      success = YES;

      // NSLog(@"Successfully updated texture %lld with RGBA data", self.textureId);
    });
  }

  return success;
}

#pragma mark - FlutterTexture Protocol

- (CVPixelBufferRef)copyPixelBuffer {
  __block CVPixelBufferRef result = NULL;

  dispatch_sync(_bufferQueue, ^{
    if (self.pixelBuffer && self.hasNewFrame) {
      result = CVPixelBufferRetain(self.pixelBuffer);  // ✅ 增加引用计数
      self.hasNewFrame = NO;
    }
  });

  return result;  // 调用者负责释放
}

- (void)onTextureUnregistered:(NSObject<FlutterTexture> *)texture {
  NSLog(@"Texture %lld unregistered", _textureId);

  // 使用 cleanup 方法确保一致的清理逻辑
  [self cleanup];
}

@end
