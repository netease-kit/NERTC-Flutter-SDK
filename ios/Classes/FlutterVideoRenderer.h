
#import "NERtcPlugin.h"
#import <NERtcSDK/NERtcSDK.h>


@interface FlutterVideoRenderer : NSObject<FlutterTexture, NERtcEngineVideoRenderSink>

@property (nonatomic) int64_t textureId;

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                              messenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (void)dispose;

@end


@interface NERtcPlugin (VideoRendererManager)

- (FlutterVideoRenderer *)createWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                       messenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end
