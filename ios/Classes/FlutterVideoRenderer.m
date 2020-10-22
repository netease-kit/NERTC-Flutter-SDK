#import "FlutterVideoRenderer.h"
#import <NERtcSDK/NERtcSDK.h>
#include "libyuv.h"


@interface FlutterVideoRenderer () <FlutterStreamHandler>
@property (nonatomic, weak) id<FlutterTextureRegistry> registry;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end


@implementation FlutterVideoRenderer {
    CVPixelBufferRef _pixelBufferRef;
    void * _i420Buffer;
    CGSize _frameSize;
    CGSize _renderSize;
    NERtcVideoRotationType _rotation;
    FlutterEventChannel* _eventChannel;
    bool _isFirstFrameRendered;
}


@synthesize textureId  = _textureId;

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                              messenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    self = [super init];
    if (self){
        _isFirstFrameRendered = false;
        _i420Buffer = NULL;
        _registry = registry;
        _pixelBufferRef = nil;
        _eventSink = nil;
        _rotation  = kNERtcVideoRotation_0;
        _frameSize = CGSizeZero;
        _renderSize = CGSizeZero;
        _textureId  = [registry registerTexture:self];
        _eventChannel = [FlutterEventChannel
                         eventChannelWithName:[NSString stringWithFormat:@"NERtcFlutterRenderer/Texture%lld", _textureId]
                         binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
    }
    return self;
}

- (void)dealloc {
    if(_pixelBufferRef){
        CVBufferRelease(_pixelBufferRef);
    }
    if(_i420Buffer) {
        free(_i420Buffer);
    }
}

- (CVPixelBufferRef)copyPixelBuffer {
    if(_pixelBufferRef != nil) {
        return _pixelBufferRef;
    }
    return nil;
}

-(void)dispose{
    [_registry unregisterTexture:_textureId];
}


-(void)copyI420BufferToCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                      withI420Buffer:(void*)i420Buffer
                         bufferWidth:(int)width bufferHeight:(int)height {
    const uint8_t* src_y = i420Buffer;
    int src_stride_y = width;
    const uint8_t* src_u = src_y + src_stride_y * height;
    int src_stride_u = (int)(width + 1) / 2;
    const uint8_t* src_v = src_y + src_stride_y * height + src_stride_u * (int)((height + 1) / 2);
    int src_stride_v = (int)(width + 1) / 2;
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    const OSType pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    uint8_t* dst = CVPixelBufferGetBaseAddress(pixelBuffer);
    const size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    if (pixelFormat == kCVPixelFormatType_32BGRA) {
        // Corresponds to libyuv::FOURCC_ARGB
        I420ToARGB(src_y,
                   src_stride_y,
                   src_u,
                   src_stride_u,
                   src_v,
                   src_stride_v,
                   dst,
                   (int)bytesPerRow,
                   width,
                   height);
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}


#pragma mark - NERtcEngineVideoRenderSink

- (void)onNERtcEngineRenderFrame:(NERtcVideoFrame *_Nonnull)frame {
    
    //Current supported I420
    if(frame.format != kNERtcVideoFormatI420) return;
    
    CGSize current_size = (frame.rotation % 180 == 0) ?
    CGSizeMake(frame.width, frame.height) :
    CGSizeMake(frame.height, frame.width);
    
    if (!CGSizeEqualToSize(_frameSize, current_size)) {
        [self setSize:current_size];
    }
    
    // I420Rotate
    if (frame.rotation == kNERtcVideoRotation_90 ||
        frame.rotation == kNERtcVideoRotation_270) {
        
        const uint8_t* src_y =  frame.buffer;
        int src_stride_y = frame.width;
        const uint8_t* src_u =  src_y + src_stride_y * frame.height;
        int src_stride_u = (int)((frame.width + 1) / 2);
        const uint8_t* src_v =  src_y + src_stride_y * frame.height + src_stride_u * ((frame.height + 1) / 2);
        int src_stride_v = (int)((frame.width + 1) / 2);


        uint8_t* dst_y = _i420Buffer;
        int dst_stride_y = _frameSize.width;
        uint8_t* dst_u = dst_y + (int)(dst_stride_y * _frameSize.height);
        int dst_stride_u = (_frameSize.width + 1) / 2;
        uint8_t* dst_v = dst_y + (int)(dst_stride_y * _frameSize.height) + (int)(dst_stride_u * (int)((_frameSize.height + 1) / 2));
        int dst_stride_v = (_frameSize.width + 1) / 2;

        
        I420Rotate(src_y, src_stride_y,
                   src_u, src_stride_u,
                   src_v, src_stride_v,
                   (uint8_t*)dst_y, dst_stride_y,
                   (uint8_t*)dst_u, dst_stride_u,
                   (uint8_t*)dst_v, dst_stride_v,
                   frame.width, frame.height,
                   (RotationModeEnum)frame.rotation);
        
        [self copyI420BufferToCVPixelBuffer:_pixelBufferRef withI420Buffer:_i420Buffer bufferWidth:_frameSize.width bufferHeight:_frameSize.height];
        
    } else {
        [self copyI420BufferToCVPixelBuffer:_pixelBufferRef withI420Buffer:frame.buffer bufferWidth:frame.width bufferHeight:frame.height];
    }
    
    
    __weak FlutterVideoRenderer *weakSelf = self;
    if(_renderSize.width != frame.width || _renderSize.height != frame.height || _rotation != frame.rotation){
        dispatch_async(dispatch_get_main_queue(), ^{
            FlutterVideoRenderer *strongSelf = weakSelf;
            if(strongSelf.eventSink){
                strongSelf.eventSink(@{
                    @"event" : @"onFrameResolutionChanged",
                    @"id": @(strongSelf.textureId),
                    @"width": @(frame.width),
                    @"height": @(frame.height),
                    @"rotation": @(frame.rotation)
                                     });
            }
        });
        _renderSize = CGSizeMake(frame.width, frame.height);
        _rotation = frame.rotation;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FlutterVideoRenderer *strongSelf = weakSelf;
        [strongSelf.registry textureFrameAvailable:strongSelf.textureId];
        if (!strongSelf->_isFirstFrameRendered) {
            if (strongSelf.eventSink) {
                strongSelf.eventSink(@{@"event":@"onFirstFrameRendered"});
                strongSelf->_isFirstFrameRendered = true;
            }
        }
    });
}


- (void)setSize:(CGSize)size {
    if(_pixelBufferRef == nil || (size.width != _frameSize.width || size.height != _frameSize.height))
    {
        // CVPixelBufferCreate
        if(_pixelBufferRef){
            CVBufferRelease(_pixelBufferRef);
        }
        NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
        CVPixelBufferCreate(kCFAllocatorDefault,
                            size.width, size.height,
                            kCVPixelFormatType_32BGRA,
                            (__bridge CFDictionaryRef)(pixelAttributes), &_pixelBufferRef);
        
        CVBufferRetain(_pixelBufferRef);

        
        // I420 Buffer
        if(_i420Buffer != NULL) {
            free(_i420Buffer);
        }
        int stride_y = size.width;
        int stride_u = (size.width + 1) / 2;
        int stride_v = (size.width + 1) / 2;
        size_t dataSize = stride_y * size.height + (stride_u + stride_v) * ((size.height + 1) / 2);
        _i420Buffer = malloc(dataSize);
        
        _frameSize = size;
    }
}



#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)sink {
    _eventSink = sink;
    return nil;
}


@end


#pragma mark - VideoRendererManager


@implementation NERtcPlugin (VideoRendererManager)

- (FlutterVideoRenderer *)createWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                                          messenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    return [[FlutterVideoRenderer alloc] initWithTextureRegistry:registry messenger:messenger];
}


@end

