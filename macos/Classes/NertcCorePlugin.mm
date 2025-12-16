// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
#import "NERtcCorePlugin.h"
#include <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#include <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#include <cstdio>
#include <iostream>
#include "../../wrapper/video_view_controller.h"
#import "NERtcTexture.h"

#pragma mark - FlutterPlugin

@implementation NERtcCorePlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
  // 创建并注册插件实例
  NERtcCorePlugin *instance = [[NERtcCorePlugin alloc] initWithRegistrar:registrar];

  // 将实例与 registrar 关联，确保实例不会被释放
  objc_setAssociatedObject(registrar, "NERtcCorePlugin", instance,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSLog(@"Detaching NERtcCorePlugin from engine");

  // 清理所有纹理资源
  [self cleanupAllTextures];

  // 清理共享实例
  [NERtcCorePlugin setSharedInstance:nil];

  // 清理 registrar 引用
  self.registrar = nil;
}

- (void)dealloc {
  NSLog(@"NERtcCorePlugin dealloc: %p", self);

  // 确保所有纹理被清理
  [self cleanupAllTextures];

  // 如果当前实例是共享实例，则清理它
  if ([NERtcCorePlugin sharedInstance] == self) {
    [NERtcCorePlugin setSharedInstance:nil];
  }
}

- (instancetype)init {
  self = [super init];
  return self;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  NSLog(@"*****************initWithRegistrar: %p, self: %p", registrar, self);
  if (self) {
    self.registrar = registrar;
    self.textureCache = [[NSMutableDictionary alloc] init];  // 初始化纹理缓存
    NSLog(@"After assignment - self.registrar: %p", self.registrar);

    // 验证 registrar 的有效性
    if (self.registrar) {
      id<FlutterTextureRegistry> textureRegistry = [self.registrar textures];
      NSLog(@"Texture registry check: %p", textureRegistry);
    }

    // 只设置一次
    [NERtcCorePlugin setSharedInstance:self];

    // 初始化 VideoController
    [self initializeVideoController];
  }
  return self;
}

#pragma mark - Private Methods

- (void)initializeVideoController {
  @try {
    NSLog(@"Initializing VideoController with NERtcCorePlugin instance: %p", self);

    // 安全地初始化 C++ 组件，并设置桥接
    VideoViewController *controller = VideoViewController::GetInstance();
    if (controller) {
      // 设置回调，让 C++ 可以通过这个插件实例创建 texture
      NSLog(@"Setting plugin instance for C++ bridge");
      SetNertcPluginInstance((__bridge void *)self);
    } else {
      NSLog(@"Warning: VideoViewController::GetInstance() returned null");
    }
  } @catch (NSException *exception) {
    NSLog(@"Failed to initialize VideoController: %@", exception.reason);
  }
}

#pragma mark - Texture Management

- (int64_t)createTextureID {
  NSLog(@"createTextureID called, self: %p, registrar: %p", self, self.registrar);

  if (!self.registrar) {
    NSLog(@"Error: registrar is nil when creating texture");
    return -1;
  }

  id<FlutterTextureRegistry> textureRegistry = [self.registrar textures];
  NSLog(@"textureRegistry: %p", textureRegistry);

  if (!textureRegistry) {
    NSLog(@"Error: textureRegistry is nil");
    return -1;
  }

  // 创建自定义纹理对象（初始尺寸为 1x1，稍后会更新）
  NERtcTexture *texture = [[NERtcTexture alloc] initWithTextureId:0 width:1 height:1];

  // 注册纹理到 Flutter，获取真正的 texture ID
  int64_t textureId = [textureRegistry registerTexture:texture];

  // 更新纹理对象的 texture ID 为实际分配的 ID
  texture.textureId = textureId;

  if (textureId <= 0) {
    NSLog(@"Error: Failed to register texture with Flutter, got ID: %lld", textureId);
    return -1;
  }

  // 将纹理信息保存到缓存中
  NSNumber *textureIdKey = @(textureId);
  NSDictionary *textureInfo = @{
    @"textureId" : textureIdKey,
    @"texture" : texture,
    @"created" : [NSDate date]
    // 移除 registrar 和 textureRegistry 引用
  };

  self.textureCache[textureIdKey] = textureInfo;

  NSLog(@"Created and registered texture ID: %lld, cached info: %@", textureId, textureInfo);

  return textureId;
}

- (void)updateFrame:(int64_t)textureId
         rgbaBuffer:(const uint8_t *)buffer
              width:(uint32_t)width
             height:(uint32_t)height {
  if (!buffer) {
    NSLog(@"Error: RGBA buffer is null");
    return;
  }

  if (width == 0 || height == 0) {
    NSLog(@"Error: Invalid frame dimensions - width: %u, height: %u", width, height);
    return;
  }

  if (!self.registrar) {
    NSLog(@"Error: registrar is nil when updating frame");
    return;
  }

  id<FlutterTextureRegistry> textureRegistry = [self.registrar textures];
  if (!textureRegistry) {
    NSLog(@"Error: textureRegistry is nil when updating frame");
    return;
  }

  // 从缓存中获取纹理信息
  NSNumber *textureIdKey = @(textureId);
  NSDictionary *textureInfo = self.textureCache[textureIdKey];

  if (!textureInfo) {
    NSLog(@"Error: Texture %lld not found in cache", textureId);
    return;
  }

  NERtcTexture *texture = textureInfo[@"texture"];
  if (!texture) {
    NSLog(@"Error: No texture object found for textureId %lld", textureId);
    return;
  }

  // 更新纹理数据
  BOOL success = [texture updateRGBABuffer:buffer width:width height:height];
  if (!success) {
    NSLog(@"Error: Failed to update RGBA buffer for texture %lld", textureId);
    return;
  }

  // 通知 Flutter 纹理已更新
  [textureRegistry textureFrameAvailable:textureId];

  // NSLog(@"Frame updated successfully for texture: %lld", textureId);
}

- (void)removeTexture:(int64_t)textureId {
  NSNumber *textureIdKey = @(textureId);
  NSDictionary *textureInfo = self.textureCache[textureIdKey];

  if (textureInfo) {
    NERtcTexture *texture = textureInfo[@"texture"];

    // 清理纹理资源
    if (texture) {
      [texture cleanup];
    }

    // 从 Flutter 注销纹理
    id<FlutterTextureRegistry> textureRegistry = [self.registrar textures];
    if (textureRegistry) {
      [textureRegistry unregisterTexture:textureId];
    }

    // 从缓存中移除
    [self.textureCache removeObjectForKey:textureIdKey];

    NSLog(@"Removed texture %lld from cache", textureId);
  }
}

- (void)cleanupAllTextures {
  NSLog(@"Cleaning up all textures, count: %lu", (unsigned long)self.textureCache.count);

  // 复制键以避免在迭代时修改字典
  NSArray *textureIds = [self.textureCache.allKeys copy];

  for (NSNumber *textureIdKey in textureIds) {
    [self removeTexture:[textureIdKey longLongValue]];
  }

  [self.textureCache removeAllObjects];
  NSLog(@"All textures cleaned up");
}

// 静态实例管理
static NERtcCorePlugin *g_shared_nertc_plugin = nil;

+ (void)setSharedInstance:(NERtcCorePlugin *)instance {
  @synchronized([NERtcCorePlugin class]) {
    g_shared_nertc_plugin = instance;
    NSLog(@"Setting shared NERtcCorePlugin instance: %p", instance);
  }
}

+ (NERtcCorePlugin *)sharedInstance {
  @synchronized([NERtcCorePlugin class]) {
    // 添加程序退出检查
    static BOOL isAppTerminating = NO;
    if (isAppTerminating) {
      return nil;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      // 注册程序退出通知
      [[NSNotificationCenter defaultCenter]
          addObserverForName:NSApplicationWillTerminateNotification
                      object:nil
                       queue:nil
                  usingBlock:^(NSNotification *_Nonnull note) {
                    isAppTerminating = YES;
                    [g_shared_nertc_plugin cleanupAllTextures];
                    g_shared_nertc_plugin = nil;
                  }];
    });

    return g_shared_nertc_plugin;
  }
}

@end

#pragma mark - C++ Bridge Functions

// C++ 桥接函数，让 C++ 代码可以调用
extern "C" {
void SetNertcPluginInstance(void *instance) {
  NERtcCorePlugin *plugin = (__bridge NERtcCorePlugin *)instance;
  if (plugin && [plugin isKindOfClass:[NERtcCorePlugin class]]) {
    [NERtcCorePlugin setSharedInstance:plugin];
  } else {
    NSLog(@"Error: Trying to set invalid NERtcCorePlugin instance");
  }
}

int64_t CreateTextureIDFromCpp() {
  NERtcCorePlugin *plugin = [NERtcCorePlugin sharedInstance];

  if (!plugin) {
    NSLog(@"Error: NERtcCorePlugin shared instance not set");
    return -1;
  }

  // 再次验证类型（虽然在设置时已经验证过）
  if (![plugin isKindOfClass:[NERtcCorePlugin class]]) {
    NSLog(@"Error: Shared instance is not NERtcCorePlugin, actual class: %@", [plugin class]);
    return -1;
  }

  NSLog(@"Calling createTextureID on NERtcCorePlugin instance: %p", plugin);
  return [plugin createTextureID];
}

void UpdateFrameFromCpp(int64_t textureId, const uint8_t *buffer, uint32_t width, uint32_t height) {
  NERtcCorePlugin *plugin = [NERtcCorePlugin sharedInstance];

  if (!plugin) {
    NSLog(@"Error: NERtcCorePlugin shared instance not set for UpdateFrame");
    return;
  }

  // 验证类型
  if (![plugin isKindOfClass:[NERtcCorePlugin class]]) {
    NSLog(@"Error: Shared instance is not NERtcCorePlugin for UpdateFrame, actual class: %@",
          [plugin class]);
    return;
  }

  // NSLog(@"Calling updateFrame on NERtcCorePlugin instance: %p", plugin);
  [plugin updateFrame:textureId rgbaBuffer:buffer width:width height:height];
}

bool SaveCGImageToFile(const char *filePath, const char *buffer) {
  if (filePath == NULL || buffer == NULL) {
    NSLog(@"Error: Invalid parameters for SaveCGImageToFile");
    return false;
  }

  CGImageRef image = (CGImageRef)buffer;
  if (image == NULL) {
    NSLog(@"Error: Invalid CGImageRef");
    return false;
  }

  NSString *nsFilePath = [NSString stringWithUTF8String:filePath];
  CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:nsFilePath];
  if (url == NULL) {
    NSLog(@"Error: Failed to create CFURLRef from filePath: %s", filePath);
    return false;
  }

  CFStringRef imageType = kUTTypeJPEG;
  CGImageDestinationRef dest = CGImageDestinationCreateWithURL(url, imageType, 1, NULL);
  if (dest == NULL) {
    NSLog(@"Error: Failed to create CGImageDestination");
    return false;
  }

  // 添加图片到目标
  CGImageDestinationAddImage(dest, image, NULL);

  // 完成写入
  BOOL success = CGImageDestinationFinalize(dest);
  CFRelease(dest);

  if (success) {
    NSLog(@"Successfully saved image to: %s", filePath);
  } else {
    NSLog(@"Error: Failed to save image to: %s", filePath);
  }

  return success;
}

void RemoveTextureFromCpp(int64_t textureId) {
  NERtcCorePlugin *plugin = [NERtcCorePlugin sharedInstance];

  if (!plugin) {
    NSLog(@"Error: NERtcCorePlugin shared instance not set for RemoveTexture");
    return;
  }

  [plugin removeTexture:textureId];
}

void SetVideoViewBridgeDelegate(void *plugin) {
  // 这个函数现在不需要做任何事情，因为我们直接使用 sharedInstance
  if (plugin) {
    NSLog(@"VideoViewBridge delegate set (using sharedInstance)");
  } else {
    NSLog(@"VideoViewBridge delegate cleared (using sharedInstance)");
  }
}

void NotifyTextureDestroyed(int64_t textureId) {
  @autoreleasepool {
    NERtcCorePlugin *plugin = [NERtcCorePlugin sharedInstance];
    if (plugin) {
      // 强引用，防止在执行过程中被释放
      if ([NSThread isMainThread]) {
        [plugin removeTexture:textureId];
      } else {
        // 使用强引用传递给 block
        dispatch_async(dispatch_get_main_queue(), ^{
          [plugin removeTexture:textureId];
        });
      }
    }
  }
}

void NotifyAllTexturesDestroyed(void) {
  NERtcCorePlugin *plugin = [NERtcCorePlugin sharedInstance];
  if (plugin) {
    if ([NSThread isMainThread]) {
      [plugin cleanupAllTextures];
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        NERtcCorePlugin *currentPlugin = [NERtcCorePlugin sharedInstance];
        if (currentPlugin) {
          [currentPlugin cleanupAllTextures];
        }
      });
    }
    NSLog(@"Notified all textures destroyed");
  } else {
    NSLog(@"Warning: NERtcCorePlugin shared instance not available for cleanup all textures");
  }
}
}
