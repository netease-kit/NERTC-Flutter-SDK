//
//  FLNERtcEngineVideoFrameDelegate.m
//  nertc
//
//  Created by zhaochong on 2020/12/24.
//

#import "FLNERtcEngineVideoFrameDelegate.h"

@interface FLNERtcEngineVideoFrameDelegate ()

@end

@implementation FLNERtcEngineVideoFrameDelegate
+ (instancetype)sharedCenter
{
    static FLNERtcEngineVideoFrameDelegate *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FLNERtcEngineVideoFrameDelegate alloc] init];
    });
    return instance;
}
- (void)onNERtcEngineVideoFrameCaptured:(CVPixelBufferRef)bufferRef rotation:(NERtcVideoRotationType)rotation {
    if (self.observer && [self.observer respondsToSelector:@selector(onNERtcEngineVideoFrameCaptured:rotation:)]) {
        [self.observer onNERtcEngineVideoFrameCaptured:bufferRef rotation:(NERtcVideoRotationType)rotation];
    }
}
@end
