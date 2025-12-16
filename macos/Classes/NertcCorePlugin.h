// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <FlutterMacOS/FlutterMacOS.h>
#import "NERtcTexture.h"

@interface NERtcCorePlugin : NSObject <FlutterPlugin>

@property(nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic, strong) NSMutableDictionary *textureCache;  // 缓存纹理信息

// 指定初始化器
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

// Texture 管理方法
- (int64_t)createTextureID;
- (void)updateFrame:(int64_t)textureId
         rgbaBuffer:(const uint8_t *)buffer
              width:(uint32_t)width
             height:(uint32_t)height;

// 清理方法
- (void)removeTexture:(int64_t)textureId;
- (void)cleanupAllTextures;

// 桥接管理方法
+ (void)setSharedInstance:(NERtcCorePlugin *)instance;
+ (NERtcCorePlugin *)sharedInstance;

@end

// C++ 桥接函数声明
#ifdef __cplusplus
extern "C" {
#endif
// 现有桥接函数
void SetNertcPluginInstance(void *instance);
int64_t CreateTextureIDFromCpp(void);
void UpdateFrameFromCpp(int64_t textureId, const uint8_t *buffer, uint32_t width, uint32_t height);
void RemoveTextureFromCpp(int64_t textureId);
bool SaveCGImageToFile(const char *filePath, const char *buffer);

// 新增桥接函数（用于 VideoViewController 调用）
void SetVideoViewBridgeDelegate(void *plugin);
void NotifyTextureDestroyed(int64_t textureId);
void NotifyAllTexturesDestroyed(void);
#ifdef __cplusplus
}
#endif
