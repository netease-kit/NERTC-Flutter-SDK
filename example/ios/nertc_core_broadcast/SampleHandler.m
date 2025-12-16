// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "SampleHandler.h"

#if TARGET_IPHONE_SIMULATOR
@interface SampleHandler ()
@end

@implementation SampleHandler

@end
#else
#import <NERtcReplayKit/NERtcReplayKit.h>

@interface SampleHandler () <NEScreenShareSampleHandlerDelegate>
@end

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *, NSObject *> *)setupInfo {
  // User has requested to start the broadcast. Setup info from the UI extension can be supplied but
  // optional.

  NEScreenShareBroadcasterOptions *options = [[NEScreenShareBroadcasterOptions alloc] init];
#if DEBUG
  options.enableDebug = YES;
  options.appGroup = @"group.com.netease.nertcflutter.Example";
#else
  options.enableDebug = NO;
  options.appGroup = @"group.com.netease.nertcflutter.Example";
#endif
  [NEScreenShareSampleHandler sharedInstance].delegate = self;
  [[NEScreenShareSampleHandler sharedInstance] broadcastStartedWithSetupInfo:options];
}

- (void)broadcastPaused {
  // User has requested to pause the broadcast. Samples will stop being delivered.
  [[NEScreenShareSampleHandler sharedInstance] broadcastPaused];
}

- (void)broadcastResumed {
  // User has requested to resume the broadcast. Samples delivery will resume.
  [[NEScreenShareSampleHandler sharedInstance] broadcastResumed];
}

- (void)broadcastFinished {
  // User has requested to finish the broadcast.
  [[NEScreenShareSampleHandler sharedInstance] broadcastFinished];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   withType:(RPSampleBufferType)sampleBufferType {
  [[NEScreenShareSampleHandler sharedInstance] processSampleBuffer:sampleBuffer
                                                          withType:sampleBufferType];
}

- (void)onRequestToFinishBroadcastWithError:(NSError *)error {
  [self finishBroadcastWithError:error];
}

@end
#endif
