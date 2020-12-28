//
//  FLNERtcEngineVideoFrameObserver.h
//  nertc
//
//  Created by zhaochong on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import "FLNERtcEngineVideoFrameObserver.h"
NS_ASSUME_NONNULL_BEGIN

@interface FLNERtcEngineVideoFrameDelegate: NSObject
+ (instancetype)sharedCenter;
@property(nonatomic, strong, nullable) id <FLNERtcEngineVideoFrameObserver> observer;

@end


NS_ASSUME_NONNULL_END
