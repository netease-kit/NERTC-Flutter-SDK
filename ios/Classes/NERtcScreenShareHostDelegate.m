// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcScreenShareHostDelegate.h"
#import <Foundation/Foundation.h>
#import <NERtcSDK/NERtcSDK.h>

@interface NERtcScreenShareHostDelegate ()
@end

@implementation NERtcScreenShareHostDelegate
- (void)onBroadcastStarted {
}

- (void)onBroadcastPaused {
}

- (void)onBroadcastResumed {
}

- (void)onBroadcastFinished {
}

- (void)onNERtcReplayKitNotifyCustomInfo:(NSDictionary *)Info {
#if DEBUG
  NSLog(@"replayKit Info:%@", [Info.description stringByReplacingOccurrencesOfString:@"\n"
                                                                          withString:@""]);
#endif
}

- (void)onReceiveAudioFrame:(NEScreenShareAudioFrame *)screenAudioFrame {
}

- (void)onReceiveVideoFrame:(NEScreenShareVideoFrame *)videoFrame {
  NERtcVideoFrame *frame = [[NERtcVideoFrame alloc] init];
  frame.format = kNERtcVideoFormatI420;
  frame.width = videoFrame.width;
  frame.height = videoFrame.height;
  frame.buffer = (void *)[videoFrame.videoData bytes];
  frame.timestamp = videoFrame.timeStamp;
  frame.rotation = (NERtcVideoRotationType)videoFrame.rotation;
  int ret = [NERtcEngine.sharedEngine pushExternalVideoFrame:frame
                                                  streamType:kNERtcStreamChannelTypeSubStream];
  if (ret != kNERtcNoError) {
#if DEBUG
    NSLog(@"pushExternalVideoFrame error, ret:%d", ret);
#endif
  }
}

@end
