// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "Messages.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@interface NEFLTNERtcUserJoinExtraInfo ()
+ (NEFLTNERtcUserJoinExtraInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTNERtcUserJoinExtraInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTNERtcUserLeaveExtraInfo ()
+ (NEFLTNERtcUserLeaveExtraInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTNERtcUserLeaveExtraInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTUserJoinedEvent ()
+ (NEFLTUserJoinedEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTUserJoinedEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTUserLeaveEvent ()
+ (NEFLTUserLeaveEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTUserLeaveEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTUserVideoMuteEvent ()
+ (NEFLTUserVideoMuteEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTUserVideoMuteEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTFirstVideoDataReceivedEvent ()
+ (NEFLTFirstVideoDataReceivedEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTFirstVideoDataReceivedEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTFirstVideoFrameDecodedEvent ()
+ (NEFLTFirstVideoFrameDecodedEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTFirstVideoFrameDecodedEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVirtualBackgroundSourceEnabledEvent ()
+ (NEFLTVirtualBackgroundSourceEnabledEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTVirtualBackgroundSourceEnabledEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTAudioVolumeInfo ()
+ (NEFLTAudioVolumeInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTAudioVolumeInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTRemoteAudioVolumeIndicationEvent ()
+ (NEFLTRemoteAudioVolumeIndicationEvent *)fromList:(NSArray *)list;
+ (nullable NEFLTRemoteAudioVolumeIndicationEvent *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTRectangle ()
+ (NEFLTRectangle *)fromList:(NSArray *)list;
+ (nullable NEFLTRectangle *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTScreenCaptureSourceData ()
+ (NEFLTScreenCaptureSourceData *)fromList:(NSArray *)list;
+ (nullable NEFLTScreenCaptureSourceData *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTNERtcLastmileProbeResult ()
+ (NEFLTNERtcLastmileProbeResult *)fromList:(NSArray *)list;
+ (nullable NEFLTNERtcLastmileProbeResult *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTNERtcLastmileProbeOneWayResult ()
+ (NEFLTNERtcLastmileProbeOneWayResult *)fromList:(NSArray *)list;
+ (nullable NEFLTNERtcLastmileProbeOneWayResult *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTRtcServerAddresses ()
+ (NEFLTRtcServerAddresses *)fromList:(NSArray *)list;
+ (nullable NEFLTRtcServerAddresses *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTCreateEngineRequest ()
+ (NEFLTCreateEngineRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTCreateEngineRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTJoinChannelOptions ()
+ (NEFLTJoinChannelOptions *)fromList:(NSArray *)list;
+ (nullable NEFLTJoinChannelOptions *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTJoinChannelRequest ()
+ (NEFLTJoinChannelRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTJoinChannelRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSubscribeRemoteAudioRequest ()
+ (NEFLTSubscribeRemoteAudioRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSubscribeRemoteAudioRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTEnableLocalVideoRequest ()
+ (NEFLTEnableLocalVideoRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTEnableLocalVideoRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetAudioProfileRequest ()
+ (NEFLTSetAudioProfileRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetAudioProfileRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetLocalVideoConfigRequest ()
+ (NEFLTSetLocalVideoConfigRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetLocalVideoConfigRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetCameraCaptureConfigRequest ()
+ (NEFLTSetCameraCaptureConfigRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetCameraCaptureConfigRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartorStopVideoPreviewRequest ()
+ (NEFLTStartorStopVideoPreviewRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartorStopVideoPreviewRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartScreenCaptureRequest ()
+ (NEFLTStartScreenCaptureRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartScreenCaptureRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSubscribeRemoteVideoStreamRequest ()
+ (NEFLTSubscribeRemoteVideoStreamRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSubscribeRemoteVideoStreamRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSubscribeRemoteSubStreamVideoRequest ()
+ (NEFLTSubscribeRemoteSubStreamVideoRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSubscribeRemoteSubStreamVideoRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTEnableAudioVolumeIndicationRequest ()
+ (NEFLTEnableAudioVolumeIndicationRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTEnableAudioVolumeIndicationRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSubscribeRemoteSubStreamAudioRequest ()
+ (NEFLTSubscribeRemoteSubStreamAudioRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSubscribeRemoteSubStreamAudioRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetAudioSubscribeOnlyByRequest ()
+ (NEFLTSetAudioSubscribeOnlyByRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetAudioSubscribeOnlyByRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartAudioMixingRequest ()
+ (NEFLTStartAudioMixingRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartAudioMixingRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTPlayEffectRequest ()
+ (NEFLTPlayEffectRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTPlayEffectRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetCameraPositionRequest ()
+ (NEFLTSetCameraPositionRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetCameraPositionRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTAddOrUpdateLiveStreamTaskRequest ()
+ (NEFLTAddOrUpdateLiveStreamTaskRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTAddOrUpdateLiveStreamTaskRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTDeleteLiveStreamTaskRequest ()
+ (NEFLTDeleteLiveStreamTaskRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTDeleteLiveStreamTaskRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSendSEIMsgRequest ()
+ (NEFLTSendSEIMsgRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSendSEIMsgRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetLocalVoiceEqualizationRequest ()
+ (NEFLTSetLocalVoiceEqualizationRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetLocalVoiceEqualizationRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSwitchChannelRequest ()
+ (NEFLTSwitchChannelRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSwitchChannelRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartAudioRecordingRequest ()
+ (NEFLTStartAudioRecordingRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartAudioRecordingRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTAudioRecordingConfigurationRequest ()
+ (NEFLTAudioRecordingConfigurationRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTAudioRecordingConfigurationRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetLocalMediaPriorityRequest ()
+ (NEFLTSetLocalMediaPriorityRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetLocalMediaPriorityRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartOrUpdateChannelMediaRelayRequest ()
+ (NEFLTStartOrUpdateChannelMediaRelayRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartOrUpdateChannelMediaRelayRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTAdjustUserPlaybackSignalVolumeRequest ()
+ (NEFLTAdjustUserPlaybackSignalVolumeRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTAdjustUserPlaybackSignalVolumeRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTEnableEncryptionRequest ()
+ (NEFLTEnableEncryptionRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTEnableEncryptionRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetLocalVoiceReverbParamRequest ()
+ (NEFLTSetLocalVoiceReverbParamRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetLocalVoiceReverbParamRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTReportCustomEventRequest ()
+ (NEFLTReportCustomEventRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTReportCustomEventRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartLastmileProbeTestRequest ()
+ (NEFLTStartLastmileProbeTestRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartLastmileProbeTestRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTCGPoint ()
+ (NEFLTCGPoint *)fromList:(NSArray *)list;
+ (nullable NEFLTCGPoint *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetVideoCorrectionConfigRequest ()
+ (NEFLTSetVideoCorrectionConfigRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetVideoCorrectionConfigRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTEnableVirtualBackgroundRequest ()
+ (NEFLTEnableVirtualBackgroundRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTEnableVirtualBackgroundRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetRemoteHighPriorityAudioStreamRequest ()
+ (NEFLTSetRemoteHighPriorityAudioStreamRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetRemoteHighPriorityAudioStreamRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVideoWatermarkImageConfig ()
+ (NEFLTVideoWatermarkImageConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTVideoWatermarkImageConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVideoWatermarkTextConfig ()
+ (NEFLTVideoWatermarkTextConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTVideoWatermarkTextConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVideoWatermarkTimestampConfig ()
+ (NEFLTVideoWatermarkTimestampConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTVideoWatermarkTimestampConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVideoWatermarkConfig ()
+ (NEFLTVideoWatermarkConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTVideoWatermarkConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetLocalVideoWatermarkConfigsRequest ()
+ (NEFLTSetLocalVideoWatermarkConfigsRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetLocalVideoWatermarkConfigsRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTPositionInfo ()
+ (NEFLTPositionInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTPositionInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSpatializerRoomProperty ()
+ (NEFLTSpatializerRoomProperty *)fromList:(NSArray *)list;
+ (nullable NEFLTSpatializerRoomProperty *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTLocalRecordingConfig ()
+ (NEFLTLocalRecordingConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTLocalRecordingConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTLocalRecordingLayoutConfig ()
+ (NEFLTLocalRecordingLayoutConfig *)fromList:(NSArray *)list;
+ (nullable NEFLTLocalRecordingLayoutConfig *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTLocalRecordingStreamInfo ()
+ (NEFLTLocalRecordingStreamInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTLocalRecordingStreamInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTNERtcVersion ()
+ (NEFLTNERtcVersion *)fromList:(NSArray *)list;
+ (nullable NEFLTNERtcVersion *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTVideoFrame ()
+ (NEFLTVideoFrame *)fromList:(NSArray *)list;
+ (nullable NEFLTVideoFrame *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTDataExternalFrame ()
+ (NEFLTDataExternalFrame *)fromList:(NSArray *)list;
+ (nullable NEFLTDataExternalFrame *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTAudioExternalFrame ()
+ (NEFLTAudioExternalFrame *)fromList:(NSArray *)list;
+ (nullable NEFLTAudioExternalFrame *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStreamingRoomInfo ()
+ (NEFLTStreamingRoomInfo *)fromList:(NSArray *)list;
+ (nullable NEFLTStreamingRoomInfo *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartPushStreamingRequest ()
+ (NEFLTStartPushStreamingRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartPushStreamingRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartPlayStreamingRequest ()
+ (NEFLTStartPlayStreamingRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartPlayStreamingRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTStartASRCaptionRequest ()
+ (NEFLTStartASRCaptionRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTStartASRCaptionRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface NEFLTSetMultiPathOptionRequest ()
+ (NEFLTSetMultiPathOptionRequest *)fromList:(NSArray *)list;
+ (nullable NEFLTSetMultiPathOptionRequest *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation NEFLTNERtcUserJoinExtraInfo
+ (instancetype)makeWithCustomInfo:(NSString *)customInfo {
  NEFLTNERtcUserJoinExtraInfo *pigeonResult = [[NEFLTNERtcUserJoinExtraInfo alloc] init];
  pigeonResult.customInfo = customInfo;
  return pigeonResult;
}
+ (NEFLTNERtcUserJoinExtraInfo *)fromList:(NSArray *)list {
  NEFLTNERtcUserJoinExtraInfo *pigeonResult = [[NEFLTNERtcUserJoinExtraInfo alloc] init];
  pigeonResult.customInfo = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.customInfo != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTNERtcUserJoinExtraInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTNERtcUserJoinExtraInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.customInfo ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTNERtcUserLeaveExtraInfo
+ (instancetype)makeWithCustomInfo:(NSString *)customInfo {
  NEFLTNERtcUserLeaveExtraInfo *pigeonResult = [[NEFLTNERtcUserLeaveExtraInfo alloc] init];
  pigeonResult.customInfo = customInfo;
  return pigeonResult;
}
+ (NEFLTNERtcUserLeaveExtraInfo *)fromList:(NSArray *)list {
  NEFLTNERtcUserLeaveExtraInfo *pigeonResult = [[NEFLTNERtcUserLeaveExtraInfo alloc] init];
  pigeonResult.customInfo = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.customInfo != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTNERtcUserLeaveExtraInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTNERtcUserLeaveExtraInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.customInfo ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTUserJoinedEvent
+ (instancetype)makeWithUid:(NSNumber *)uid
              joinExtraInfo:(nullable NEFLTNERtcUserJoinExtraInfo *)joinExtraInfo {
  NEFLTUserJoinedEvent *pigeonResult = [[NEFLTUserJoinedEvent alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.joinExtraInfo = joinExtraInfo;
  return pigeonResult;
}
+ (NEFLTUserJoinedEvent *)fromList:(NSArray *)list {
  NEFLTUserJoinedEvent *pigeonResult = [[NEFLTUserJoinedEvent alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.joinExtraInfo =
      [NEFLTNERtcUserJoinExtraInfo nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  return pigeonResult;
}
+ (nullable NEFLTUserJoinedEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTUserJoinedEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.joinExtraInfo ? [self.joinExtraInfo toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTUserLeaveEvent
+ (instancetype)makeWithUid:(NSNumber *)uid
                     reason:(NSNumber *)reason
             leaveExtraInfo:(nullable NEFLTNERtcUserLeaveExtraInfo *)leaveExtraInfo {
  NEFLTUserLeaveEvent *pigeonResult = [[NEFLTUserLeaveEvent alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.reason = reason;
  pigeonResult.leaveExtraInfo = leaveExtraInfo;
  return pigeonResult;
}
+ (NEFLTUserLeaveEvent *)fromList:(NSArray *)list {
  NEFLTUserLeaveEvent *pigeonResult = [[NEFLTUserLeaveEvent alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.reason = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.reason != nil, @"");
  pigeonResult.leaveExtraInfo =
      [NEFLTNERtcUserLeaveExtraInfo nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  return pigeonResult;
}
+ (nullable NEFLTUserLeaveEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTUserLeaveEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.reason ?: [NSNull null]),
    (self.leaveExtraInfo ? [self.leaveExtraInfo toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTUserVideoMuteEvent
+ (instancetype)makeWithUid:(NSNumber *)uid
                      muted:(NSNumber *)muted
                 streamType:(nullable NSNumber *)streamType {
  NEFLTUserVideoMuteEvent *pigeonResult = [[NEFLTUserVideoMuteEvent alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.muted = muted;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTUserVideoMuteEvent *)fromList:(NSArray *)list {
  NEFLTUserVideoMuteEvent *pigeonResult = [[NEFLTUserVideoMuteEvent alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.muted = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.muted != nil, @"");
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTUserVideoMuteEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTUserVideoMuteEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.muted ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTFirstVideoDataReceivedEvent
+ (instancetype)makeWithUid:(NSNumber *)uid streamType:(nullable NSNumber *)streamType {
  NEFLTFirstVideoDataReceivedEvent *pigeonResult = [[NEFLTFirstVideoDataReceivedEvent alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTFirstVideoDataReceivedEvent *)fromList:(NSArray *)list {
  NEFLTFirstVideoDataReceivedEvent *pigeonResult = [[NEFLTFirstVideoDataReceivedEvent alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTFirstVideoDataReceivedEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTFirstVideoDataReceivedEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTFirstVideoFrameDecodedEvent
+ (instancetype)makeWithUid:(NSNumber *)uid
                      width:(NSNumber *)width
                     height:(NSNumber *)height
                 streamType:(nullable NSNumber *)streamType {
  NEFLTFirstVideoFrameDecodedEvent *pigeonResult = [[NEFLTFirstVideoFrameDecodedEvent alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.width = width;
  pigeonResult.height = height;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTFirstVideoFrameDecodedEvent *)fromList:(NSArray *)list {
  NEFLTFirstVideoFrameDecodedEvent *pigeonResult = [[NEFLTFirstVideoFrameDecodedEvent alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.width = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.width != nil, @"");
  pigeonResult.height = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.height != nil, @"");
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 3);
  return pigeonResult;
}
+ (nullable NEFLTFirstVideoFrameDecodedEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTFirstVideoFrameDecodedEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVirtualBackgroundSourceEnabledEvent
+ (instancetype)makeWithEnabled:(NSNumber *)enabled reason:(NSNumber *)reason {
  NEFLTVirtualBackgroundSourceEnabledEvent *pigeonResult =
      [[NEFLTVirtualBackgroundSourceEnabledEvent alloc] init];
  pigeonResult.enabled = enabled;
  pigeonResult.reason = reason;
  return pigeonResult;
}
+ (NEFLTVirtualBackgroundSourceEnabledEvent *)fromList:(NSArray *)list {
  NEFLTVirtualBackgroundSourceEnabledEvent *pigeonResult =
      [[NEFLTVirtualBackgroundSourceEnabledEvent alloc] init];
  pigeonResult.enabled = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.enabled != nil, @"");
  pigeonResult.reason = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.reason != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTVirtualBackgroundSourceEnabledEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVirtualBackgroundSourceEnabledEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enabled ?: [NSNull null]),
    (self.reason ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTAudioVolumeInfo
+ (instancetype)makeWithUid:(NSNumber *)uid
                     volume:(NSNumber *)volume
            subStreamVolume:(NSNumber *)subStreamVolume {
  NEFLTAudioVolumeInfo *pigeonResult = [[NEFLTAudioVolumeInfo alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.volume = volume;
  pigeonResult.subStreamVolume = subStreamVolume;
  return pigeonResult;
}
+ (NEFLTAudioVolumeInfo *)fromList:(NSArray *)list {
  NEFLTAudioVolumeInfo *pigeonResult = [[NEFLTAudioVolumeInfo alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.volume = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.volume != nil, @"");
  pigeonResult.subStreamVolume = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.subStreamVolume != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTAudioVolumeInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTAudioVolumeInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.volume ?: [NSNull null]),
    (self.subStreamVolume ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTRemoteAudioVolumeIndicationEvent
+ (instancetype)makeWithVolumeList:(nullable NSArray<NEFLTAudioVolumeInfo *> *)volumeList
                       totalVolume:(NSNumber *)totalVolume {
  NEFLTRemoteAudioVolumeIndicationEvent *pigeonResult =
      [[NEFLTRemoteAudioVolumeIndicationEvent alloc] init];
  pigeonResult.volumeList = volumeList;
  pigeonResult.totalVolume = totalVolume;
  return pigeonResult;
}
+ (NEFLTRemoteAudioVolumeIndicationEvent *)fromList:(NSArray *)list {
  NEFLTRemoteAudioVolumeIndicationEvent *pigeonResult =
      [[NEFLTRemoteAudioVolumeIndicationEvent alloc] init];
  pigeonResult.volumeList = GetNullableObjectAtIndex(list, 0);
  pigeonResult.totalVolume = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.totalVolume != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTRemoteAudioVolumeIndicationEvent *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTRemoteAudioVolumeIndicationEvent fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.volumeList ?: [NSNull null]),
    (self.totalVolume ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTRectangle
+ (instancetype)makeWithX:(NSNumber *)x
                        y:(NSNumber *)y
                    width:(NSNumber *)width
                   height:(NSNumber *)height {
  NEFLTRectangle *pigeonResult = [[NEFLTRectangle alloc] init];
  pigeonResult.x = x;
  pigeonResult.y = y;
  pigeonResult.width = width;
  pigeonResult.height = height;
  return pigeonResult;
}
+ (NEFLTRectangle *)fromList:(NSArray *)list {
  NEFLTRectangle *pigeonResult = [[NEFLTRectangle alloc] init];
  pigeonResult.x = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.x != nil, @"");
  pigeonResult.y = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.y != nil, @"");
  pigeonResult.width = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.width != nil, @"");
  pigeonResult.height = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.height != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTRectangle *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTRectangle fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.x ?: [NSNull null]),
    (self.y ?: [NSNull null]),
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTScreenCaptureSourceData
+ (instancetype)makeWithType:(NSNumber *)type
                    sourceId:(NSNumber *)sourceId
                      status:(NSNumber *)status
                      action:(NSNumber *)action
                 captureRect:(NEFLTRectangle *)captureRect
                       level:(NSNumber *)level {
  NEFLTScreenCaptureSourceData *pigeonResult = [[NEFLTScreenCaptureSourceData alloc] init];
  pigeonResult.type = type;
  pigeonResult.sourceId = sourceId;
  pigeonResult.status = status;
  pigeonResult.action = action;
  pigeonResult.captureRect = captureRect;
  pigeonResult.level = level;
  return pigeonResult;
}
+ (NEFLTScreenCaptureSourceData *)fromList:(NSArray *)list {
  NEFLTScreenCaptureSourceData *pigeonResult = [[NEFLTScreenCaptureSourceData alloc] init];
  pigeonResult.type = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.type != nil, @"");
  pigeonResult.sourceId = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.sourceId != nil, @"");
  pigeonResult.status = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.status != nil, @"");
  pigeonResult.action = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.action != nil, @"");
  pigeonResult.captureRect = [NEFLTRectangle nullableFromList:(GetNullableObjectAtIndex(list, 4))];
  NSAssert(pigeonResult.captureRect != nil, @"");
  pigeonResult.level = GetNullableObjectAtIndex(list, 5);
  NSAssert(pigeonResult.level != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTScreenCaptureSourceData *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTScreenCaptureSourceData fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.type ?: [NSNull null]),
    (self.sourceId ?: [NSNull null]),
    (self.status ?: [NSNull null]),
    (self.action ?: [NSNull null]),
    (self.captureRect ? [self.captureRect toList] : [NSNull null]),
    (self.level ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTNERtcLastmileProbeResult
+ (instancetype)makeWithState:(NSNumber *)state
                          rtt:(NSNumber *)rtt
                 uplinkReport:(NEFLTNERtcLastmileProbeOneWayResult *)uplinkReport
               downlinkReport:(NEFLTNERtcLastmileProbeOneWayResult *)downlinkReport {
  NEFLTNERtcLastmileProbeResult *pigeonResult = [[NEFLTNERtcLastmileProbeResult alloc] init];
  pigeonResult.state = state;
  pigeonResult.rtt = rtt;
  pigeonResult.uplinkReport = uplinkReport;
  pigeonResult.downlinkReport = downlinkReport;
  return pigeonResult;
}
+ (NEFLTNERtcLastmileProbeResult *)fromList:(NSArray *)list {
  NEFLTNERtcLastmileProbeResult *pigeonResult = [[NEFLTNERtcLastmileProbeResult alloc] init];
  pigeonResult.state = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.state != nil, @"");
  pigeonResult.rtt = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.rtt != nil, @"");
  pigeonResult.uplinkReport =
      [NEFLTNERtcLastmileProbeOneWayResult nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  NSAssert(pigeonResult.uplinkReport != nil, @"");
  pigeonResult.downlinkReport =
      [NEFLTNERtcLastmileProbeOneWayResult nullableFromList:(GetNullableObjectAtIndex(list, 3))];
  NSAssert(pigeonResult.downlinkReport != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTNERtcLastmileProbeResult *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTNERtcLastmileProbeResult fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.state ?: [NSNull null]),
    (self.rtt ?: [NSNull null]),
    (self.uplinkReport ? [self.uplinkReport toList] : [NSNull null]),
    (self.downlinkReport ? [self.downlinkReport toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTNERtcLastmileProbeOneWayResult
+ (instancetype)makeWithPacketLossRate:(NSNumber *)packetLossRate
                                jitter:(NSNumber *)jitter
                    availableBandwidth:(NSNumber *)availableBandwidth {
  NEFLTNERtcLastmileProbeOneWayResult *pigeonResult =
      [[NEFLTNERtcLastmileProbeOneWayResult alloc] init];
  pigeonResult.packetLossRate = packetLossRate;
  pigeonResult.jitter = jitter;
  pigeonResult.availableBandwidth = availableBandwidth;
  return pigeonResult;
}
+ (NEFLTNERtcLastmileProbeOneWayResult *)fromList:(NSArray *)list {
  NEFLTNERtcLastmileProbeOneWayResult *pigeonResult =
      [[NEFLTNERtcLastmileProbeOneWayResult alloc] init];
  pigeonResult.packetLossRate = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.packetLossRate != nil, @"");
  pigeonResult.jitter = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.jitter != nil, @"");
  pigeonResult.availableBandwidth = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.availableBandwidth != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTNERtcLastmileProbeOneWayResult *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTNERtcLastmileProbeOneWayResult fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.packetLossRate ?: [NSNull null]),
    (self.jitter ?: [NSNull null]),
    (self.availableBandwidth ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTRtcServerAddresses
+ (instancetype)makeWithValid:(nullable NSNumber *)valid
                channelServer:(nullable NSString *)channelServer
             statisticsServer:(nullable NSString *)statisticsServer
                   roomServer:(nullable NSString *)roomServer
                 compatServer:(nullable NSString *)compatServer
                 nosLbsServer:(nullable NSString *)nosLbsServer
               nosUploadSever:(nullable NSString *)nosUploadSever
               nosTokenServer:(nullable NSString *)nosTokenServer
              sdkConfigServer:(nullable NSString *)sdkConfigServer
             cloudProxyServer:(nullable NSString *)cloudProxyServer
         webSocketProxyServer:(nullable NSString *)webSocketProxyServer
              quicProxyServer:(nullable NSString *)quicProxyServer
             mediaProxyServer:(nullable NSString *)mediaProxyServer
     statisticsDispatchServer:(nullable NSString *)statisticsDispatchServer
       statisticsBackupServer:(nullable NSString *)statisticsBackupServer
                      useIPv6:(nullable NSNumber *)useIPv6 {
  NEFLTRtcServerAddresses *pigeonResult = [[NEFLTRtcServerAddresses alloc] init];
  pigeonResult.valid = valid;
  pigeonResult.channelServer = channelServer;
  pigeonResult.statisticsServer = statisticsServer;
  pigeonResult.roomServer = roomServer;
  pigeonResult.compatServer = compatServer;
  pigeonResult.nosLbsServer = nosLbsServer;
  pigeonResult.nosUploadSever = nosUploadSever;
  pigeonResult.nosTokenServer = nosTokenServer;
  pigeonResult.sdkConfigServer = sdkConfigServer;
  pigeonResult.cloudProxyServer = cloudProxyServer;
  pigeonResult.webSocketProxyServer = webSocketProxyServer;
  pigeonResult.quicProxyServer = quicProxyServer;
  pigeonResult.mediaProxyServer = mediaProxyServer;
  pigeonResult.statisticsDispatchServer = statisticsDispatchServer;
  pigeonResult.statisticsBackupServer = statisticsBackupServer;
  pigeonResult.useIPv6 = useIPv6;
  return pigeonResult;
}
+ (NEFLTRtcServerAddresses *)fromList:(NSArray *)list {
  NEFLTRtcServerAddresses *pigeonResult = [[NEFLTRtcServerAddresses alloc] init];
  pigeonResult.valid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.channelServer = GetNullableObjectAtIndex(list, 1);
  pigeonResult.statisticsServer = GetNullableObjectAtIndex(list, 2);
  pigeonResult.roomServer = GetNullableObjectAtIndex(list, 3);
  pigeonResult.compatServer = GetNullableObjectAtIndex(list, 4);
  pigeonResult.nosLbsServer = GetNullableObjectAtIndex(list, 5);
  pigeonResult.nosUploadSever = GetNullableObjectAtIndex(list, 6);
  pigeonResult.nosTokenServer = GetNullableObjectAtIndex(list, 7);
  pigeonResult.sdkConfigServer = GetNullableObjectAtIndex(list, 8);
  pigeonResult.cloudProxyServer = GetNullableObjectAtIndex(list, 9);
  pigeonResult.webSocketProxyServer = GetNullableObjectAtIndex(list, 10);
  pigeonResult.quicProxyServer = GetNullableObjectAtIndex(list, 11);
  pigeonResult.mediaProxyServer = GetNullableObjectAtIndex(list, 12);
  pigeonResult.statisticsDispatchServer = GetNullableObjectAtIndex(list, 13);
  pigeonResult.statisticsBackupServer = GetNullableObjectAtIndex(list, 14);
  pigeonResult.useIPv6 = GetNullableObjectAtIndex(list, 15);
  return pigeonResult;
}
+ (nullable NEFLTRtcServerAddresses *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTRtcServerAddresses fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.valid ?: [NSNull null]),
    (self.channelServer ?: [NSNull null]),
    (self.statisticsServer ?: [NSNull null]),
    (self.roomServer ?: [NSNull null]),
    (self.compatServer ?: [NSNull null]),
    (self.nosLbsServer ?: [NSNull null]),
    (self.nosUploadSever ?: [NSNull null]),
    (self.nosTokenServer ?: [NSNull null]),
    (self.sdkConfigServer ?: [NSNull null]),
    (self.cloudProxyServer ?: [NSNull null]),
    (self.webSocketProxyServer ?: [NSNull null]),
    (self.quicProxyServer ?: [NSNull null]),
    (self.mediaProxyServer ?: [NSNull null]),
    (self.statisticsDispatchServer ?: [NSNull null]),
    (self.statisticsBackupServer ?: [NSNull null]),
    (self.useIPv6 ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTCreateEngineRequest
+ (instancetype)makeWithAppKey:(nullable NSString *)appKey
                                   logDir:(nullable NSString *)logDir
                          serverAddresses:(nullable NEFLTRtcServerAddresses *)serverAddresses
                                 logLevel:(nullable NSNumber *)logLevel
                       audioAutoSubscribe:(nullable NSNumber *)audioAutoSubscribe
                       videoAutoSubscribe:(nullable NSNumber *)videoAutoSubscribe
        disableFirstJoinUserCreateChannel:(nullable NSNumber *)disableFirstJoinUserCreateChannel
    audioDisableOverrideSpeakerOnReceiver:(nullable NSNumber *)audioDisableOverrideSpeakerOnReceiver
               audioDisableSWAECOnHeadset:(nullable NSNumber *)audioDisableSWAECOnHeadset
                         audioAINSEnabled:(nullable NSNumber *)audioAINSEnabled
                        serverRecordAudio:(nullable NSNumber *)serverRecordAudio
                        serverRecordVideo:(nullable NSNumber *)serverRecordVideo
                         serverRecordMode:(nullable NSNumber *)serverRecordMode
                      serverRecordSpeaker:(nullable NSNumber *)serverRecordSpeaker
                        publishSelfStream:(nullable NSNumber *)publishSelfStream
              videoCaptureObserverEnabled:(nullable NSNumber *)videoCaptureObserverEnabled
                          videoEncodeMode:(nullable NSNumber *)videoEncodeMode
                          videoDecodeMode:(nullable NSNumber *)videoDecodeMode
                            videoSendMode:(nullable NSNumber *)videoSendMode
                         videoH265Enabled:(nullable NSNumber *)videoH265Enabled
                           mode1v1Enabled:(nullable NSNumber *)mode1v1Enabled
                                 appGroup:(nullable NSString *)appGroup {
  NEFLTCreateEngineRequest *pigeonResult = [[NEFLTCreateEngineRequest alloc] init];
  pigeonResult.appKey = appKey;
  pigeonResult.logDir = logDir;
  pigeonResult.serverAddresses = serverAddresses;
  pigeonResult.logLevel = logLevel;
  pigeonResult.audioAutoSubscribe = audioAutoSubscribe;
  pigeonResult.videoAutoSubscribe = videoAutoSubscribe;
  pigeonResult.disableFirstJoinUserCreateChannel = disableFirstJoinUserCreateChannel;
  pigeonResult.audioDisableOverrideSpeakerOnReceiver = audioDisableOverrideSpeakerOnReceiver;
  pigeonResult.audioDisableSWAECOnHeadset = audioDisableSWAECOnHeadset;
  pigeonResult.audioAINSEnabled = audioAINSEnabled;
  pigeonResult.serverRecordAudio = serverRecordAudio;
  pigeonResult.serverRecordVideo = serverRecordVideo;
  pigeonResult.serverRecordMode = serverRecordMode;
  pigeonResult.serverRecordSpeaker = serverRecordSpeaker;
  pigeonResult.publishSelfStream = publishSelfStream;
  pigeonResult.videoCaptureObserverEnabled = videoCaptureObserverEnabled;
  pigeonResult.videoEncodeMode = videoEncodeMode;
  pigeonResult.videoDecodeMode = videoDecodeMode;
  pigeonResult.videoSendMode = videoSendMode;
  pigeonResult.videoH265Enabled = videoH265Enabled;
  pigeonResult.mode1v1Enabled = mode1v1Enabled;
  pigeonResult.appGroup = appGroup;
  return pigeonResult;
}
+ (NEFLTCreateEngineRequest *)fromList:(NSArray *)list {
  NEFLTCreateEngineRequest *pigeonResult = [[NEFLTCreateEngineRequest alloc] init];
  pigeonResult.appKey = GetNullableObjectAtIndex(list, 0);
  pigeonResult.logDir = GetNullableObjectAtIndex(list, 1);
  pigeonResult.serverAddresses =
      [NEFLTRtcServerAddresses nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  pigeonResult.logLevel = GetNullableObjectAtIndex(list, 3);
  pigeonResult.audioAutoSubscribe = GetNullableObjectAtIndex(list, 4);
  pigeonResult.videoAutoSubscribe = GetNullableObjectAtIndex(list, 5);
  pigeonResult.disableFirstJoinUserCreateChannel = GetNullableObjectAtIndex(list, 6);
  pigeonResult.audioDisableOverrideSpeakerOnReceiver = GetNullableObjectAtIndex(list, 7);
  pigeonResult.audioDisableSWAECOnHeadset = GetNullableObjectAtIndex(list, 8);
  pigeonResult.audioAINSEnabled = GetNullableObjectAtIndex(list, 9);
  pigeonResult.serverRecordAudio = GetNullableObjectAtIndex(list, 10);
  pigeonResult.serverRecordVideo = GetNullableObjectAtIndex(list, 11);
  pigeonResult.serverRecordMode = GetNullableObjectAtIndex(list, 12);
  pigeonResult.serverRecordSpeaker = GetNullableObjectAtIndex(list, 13);
  pigeonResult.publishSelfStream = GetNullableObjectAtIndex(list, 14);
  pigeonResult.videoCaptureObserverEnabled = GetNullableObjectAtIndex(list, 15);
  pigeonResult.videoEncodeMode = GetNullableObjectAtIndex(list, 16);
  pigeonResult.videoDecodeMode = GetNullableObjectAtIndex(list, 17);
  pigeonResult.videoSendMode = GetNullableObjectAtIndex(list, 18);
  pigeonResult.videoH265Enabled = GetNullableObjectAtIndex(list, 19);
  pigeonResult.mode1v1Enabled = GetNullableObjectAtIndex(list, 20);
  pigeonResult.appGroup = GetNullableObjectAtIndex(list, 21);
  return pigeonResult;
}
+ (nullable NEFLTCreateEngineRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTCreateEngineRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.appKey ?: [NSNull null]),
    (self.logDir ?: [NSNull null]),
    (self.serverAddresses ? [self.serverAddresses toList] : [NSNull null]),
    (self.logLevel ?: [NSNull null]),
    (self.audioAutoSubscribe ?: [NSNull null]),
    (self.videoAutoSubscribe ?: [NSNull null]),
    (self.disableFirstJoinUserCreateChannel ?: [NSNull null]),
    (self.audioDisableOverrideSpeakerOnReceiver ?: [NSNull null]),
    (self.audioDisableSWAECOnHeadset ?: [NSNull null]),
    (self.audioAINSEnabled ?: [NSNull null]),
    (self.serverRecordAudio ?: [NSNull null]),
    (self.serverRecordVideo ?: [NSNull null]),
    (self.serverRecordMode ?: [NSNull null]),
    (self.serverRecordSpeaker ?: [NSNull null]),
    (self.publishSelfStream ?: [NSNull null]),
    (self.videoCaptureObserverEnabled ?: [NSNull null]),
    (self.videoEncodeMode ?: [NSNull null]),
    (self.videoDecodeMode ?: [NSNull null]),
    (self.videoSendMode ?: [NSNull null]),
    (self.videoH265Enabled ?: [NSNull null]),
    (self.mode1v1Enabled ?: [NSNull null]),
    (self.appGroup ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTJoinChannelOptions
+ (instancetype)makeWithCustomInfo:(nullable NSString *)customInfo
                     permissionKey:(nullable NSString *)permissionKey {
  NEFLTJoinChannelOptions *pigeonResult = [[NEFLTJoinChannelOptions alloc] init];
  pigeonResult.customInfo = customInfo;
  pigeonResult.permissionKey = permissionKey;
  return pigeonResult;
}
+ (NEFLTJoinChannelOptions *)fromList:(NSArray *)list {
  NEFLTJoinChannelOptions *pigeonResult = [[NEFLTJoinChannelOptions alloc] init];
  pigeonResult.customInfo = GetNullableObjectAtIndex(list, 0);
  pigeonResult.permissionKey = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTJoinChannelOptions *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTJoinChannelOptions fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.customInfo ?: [NSNull null]),
    (self.permissionKey ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTJoinChannelRequest
+ (instancetype)makeWithToken:(nullable NSString *)token
                  channelName:(NSString *)channelName
                          uid:(NSNumber *)uid
               channelOptions:(nullable NEFLTJoinChannelOptions *)channelOptions {
  NEFLTJoinChannelRequest *pigeonResult = [[NEFLTJoinChannelRequest alloc] init];
  pigeonResult.token = token;
  pigeonResult.channelName = channelName;
  pigeonResult.uid = uid;
  pigeonResult.channelOptions = channelOptions;
  return pigeonResult;
}
+ (NEFLTJoinChannelRequest *)fromList:(NSArray *)list {
  NEFLTJoinChannelRequest *pigeonResult = [[NEFLTJoinChannelRequest alloc] init];
  pigeonResult.token = GetNullableObjectAtIndex(list, 0);
  pigeonResult.channelName = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.channelName != nil, @"");
  pigeonResult.uid = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.channelOptions =
      [NEFLTJoinChannelOptions nullableFromList:(GetNullableObjectAtIndex(list, 3))];
  return pigeonResult;
}
+ (nullable NEFLTJoinChannelRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTJoinChannelRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.token ?: [NSNull null]),
    (self.channelName ?: [NSNull null]),
    (self.uid ?: [NSNull null]),
    (self.channelOptions ? [self.channelOptions toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTSubscribeRemoteAudioRequest
+ (instancetype)makeWithUid:(nullable NSNumber *)uid subscribe:(nullable NSNumber *)subscribe {
  NEFLTSubscribeRemoteAudioRequest *pigeonResult = [[NEFLTSubscribeRemoteAudioRequest alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.subscribe = subscribe;
  return pigeonResult;
}
+ (NEFLTSubscribeRemoteAudioRequest *)fromList:(NSArray *)list {
  NEFLTSubscribeRemoteAudioRequest *pigeonResult = [[NEFLTSubscribeRemoteAudioRequest alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.subscribe = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSubscribeRemoteAudioRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSubscribeRemoteAudioRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.subscribe ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTEnableLocalVideoRequest
+ (instancetype)makeWithEnable:(nullable NSNumber *)enable
                    streamType:(nullable NSNumber *)streamType {
  NEFLTEnableLocalVideoRequest *pigeonResult = [[NEFLTEnableLocalVideoRequest alloc] init];
  pigeonResult.enable = enable;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTEnableLocalVideoRequest *)fromList:(NSArray *)list {
  NEFLTEnableLocalVideoRequest *pigeonResult = [[NEFLTEnableLocalVideoRequest alloc] init];
  pigeonResult.enable = GetNullableObjectAtIndex(list, 0);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTEnableLocalVideoRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTEnableLocalVideoRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enable ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetAudioProfileRequest
+ (instancetype)makeWithProfile:(nullable NSNumber *)profile
                       scenario:(nullable NSNumber *)scenario {
  NEFLTSetAudioProfileRequest *pigeonResult = [[NEFLTSetAudioProfileRequest alloc] init];
  pigeonResult.profile = profile;
  pigeonResult.scenario = scenario;
  return pigeonResult;
}
+ (NEFLTSetAudioProfileRequest *)fromList:(NSArray *)list {
  NEFLTSetAudioProfileRequest *pigeonResult = [[NEFLTSetAudioProfileRequest alloc] init];
  pigeonResult.profile = GetNullableObjectAtIndex(list, 0);
  pigeonResult.scenario = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSetAudioProfileRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetAudioProfileRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.profile ?: [NSNull null]),
    (self.scenario ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetLocalVideoConfigRequest
+ (instancetype)makeWithVideoProfile:(nullable NSNumber *)videoProfile
                       videoCropMode:(nullable NSNumber *)videoCropMode
                         frontCamera:(nullable NSNumber *)frontCamera
                           frameRate:(nullable NSNumber *)frameRate
                        minFrameRate:(nullable NSNumber *)minFrameRate
                             bitrate:(nullable NSNumber *)bitrate
                          minBitrate:(nullable NSNumber *)minBitrate
                   degradationPrefer:(nullable NSNumber *)degradationPrefer
                               width:(nullable NSNumber *)width
                              height:(nullable NSNumber *)height
                          cameraType:(nullable NSNumber *)cameraType
                          mirrorMode:(nullable NSNumber *)mirrorMode
                     orientationMode:(nullable NSNumber *)orientationMode
                          streamType:(nullable NSNumber *)streamType {
  NEFLTSetLocalVideoConfigRequest *pigeonResult = [[NEFLTSetLocalVideoConfigRequest alloc] init];
  pigeonResult.videoProfile = videoProfile;
  pigeonResult.videoCropMode = videoCropMode;
  pigeonResult.frontCamera = frontCamera;
  pigeonResult.frameRate = frameRate;
  pigeonResult.minFrameRate = minFrameRate;
  pigeonResult.bitrate = bitrate;
  pigeonResult.minBitrate = minBitrate;
  pigeonResult.degradationPrefer = degradationPrefer;
  pigeonResult.width = width;
  pigeonResult.height = height;
  pigeonResult.cameraType = cameraType;
  pigeonResult.mirrorMode = mirrorMode;
  pigeonResult.orientationMode = orientationMode;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTSetLocalVideoConfigRequest *)fromList:(NSArray *)list {
  NEFLTSetLocalVideoConfigRequest *pigeonResult = [[NEFLTSetLocalVideoConfigRequest alloc] init];
  pigeonResult.videoProfile = GetNullableObjectAtIndex(list, 0);
  pigeonResult.videoCropMode = GetNullableObjectAtIndex(list, 1);
  pigeonResult.frontCamera = GetNullableObjectAtIndex(list, 2);
  pigeonResult.frameRate = GetNullableObjectAtIndex(list, 3);
  pigeonResult.minFrameRate = GetNullableObjectAtIndex(list, 4);
  pigeonResult.bitrate = GetNullableObjectAtIndex(list, 5);
  pigeonResult.minBitrate = GetNullableObjectAtIndex(list, 6);
  pigeonResult.degradationPrefer = GetNullableObjectAtIndex(list, 7);
  pigeonResult.width = GetNullableObjectAtIndex(list, 8);
  pigeonResult.height = GetNullableObjectAtIndex(list, 9);
  pigeonResult.cameraType = GetNullableObjectAtIndex(list, 10);
  pigeonResult.mirrorMode = GetNullableObjectAtIndex(list, 11);
  pigeonResult.orientationMode = GetNullableObjectAtIndex(list, 12);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 13);
  return pigeonResult;
}
+ (nullable NEFLTSetLocalVideoConfigRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetLocalVideoConfigRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.videoProfile ?: [NSNull null]),
    (self.videoCropMode ?: [NSNull null]),
    (self.frontCamera ?: [NSNull null]),
    (self.frameRate ?: [NSNull null]),
    (self.minFrameRate ?: [NSNull null]),
    (self.bitrate ?: [NSNull null]),
    (self.minBitrate ?: [NSNull null]),
    (self.degradationPrefer ?: [NSNull null]),
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
    (self.cameraType ?: [NSNull null]),
    (self.mirrorMode ?: [NSNull null]),
    (self.orientationMode ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetCameraCaptureConfigRequest
+ (instancetype)makeWithExtraRotation:(NEFLTNERtcCaptureExtraRotation)extraRotation
                         captureWidth:(nullable NSNumber *)captureWidth
                        captureHeight:(nullable NSNumber *)captureHeight
                           streamType:(nullable NSNumber *)streamType {
  NEFLTSetCameraCaptureConfigRequest *pigeonResult =
      [[NEFLTSetCameraCaptureConfigRequest alloc] init];
  pigeonResult.extraRotation = extraRotation;
  pigeonResult.captureWidth = captureWidth;
  pigeonResult.captureHeight = captureHeight;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTSetCameraCaptureConfigRequest *)fromList:(NSArray *)list {
  NEFLTSetCameraCaptureConfigRequest *pigeonResult =
      [[NEFLTSetCameraCaptureConfigRequest alloc] init];
  pigeonResult.extraRotation = [GetNullableObjectAtIndex(list, 0) integerValue];
  pigeonResult.captureWidth = GetNullableObjectAtIndex(list, 1);
  pigeonResult.captureHeight = GetNullableObjectAtIndex(list, 2);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 3);
  return pigeonResult;
}
+ (nullable NEFLTSetCameraCaptureConfigRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetCameraCaptureConfigRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    @(self.extraRotation),
    (self.captureWidth ?: [NSNull null]),
    (self.captureHeight ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartorStopVideoPreviewRequest
+ (instancetype)makeWithStreamType:(nullable NSNumber *)streamType {
  NEFLTStartorStopVideoPreviewRequest *pigeonResult =
      [[NEFLTStartorStopVideoPreviewRequest alloc] init];
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTStartorStopVideoPreviewRequest *)fromList:(NSArray *)list {
  NEFLTStartorStopVideoPreviewRequest *pigeonResult =
      [[NEFLTStartorStopVideoPreviewRequest alloc] init];
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 0);
  return pigeonResult;
}
+ (nullable NEFLTStartorStopVideoPreviewRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartorStopVideoPreviewRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartScreenCaptureRequest
+ (instancetype)makeWithContentPrefer:(nullable NSNumber *)contentPrefer
                         videoProfile:(nullable NSNumber *)videoProfile
                            frameRate:(nullable NSNumber *)frameRate
                         minFrameRate:(nullable NSNumber *)minFrameRate
                              bitrate:(nullable NSNumber *)bitrate
                           minBitrate:(nullable NSNumber *)minBitrate
                                 dict:(nullable NSDictionary<NSString *, id> *)dict {
  NEFLTStartScreenCaptureRequest *pigeonResult = [[NEFLTStartScreenCaptureRequest alloc] init];
  pigeonResult.contentPrefer = contentPrefer;
  pigeonResult.videoProfile = videoProfile;
  pigeonResult.frameRate = frameRate;
  pigeonResult.minFrameRate = minFrameRate;
  pigeonResult.bitrate = bitrate;
  pigeonResult.minBitrate = minBitrate;
  pigeonResult.dict = dict;
  return pigeonResult;
}
+ (NEFLTStartScreenCaptureRequest *)fromList:(NSArray *)list {
  NEFLTStartScreenCaptureRequest *pigeonResult = [[NEFLTStartScreenCaptureRequest alloc] init];
  pigeonResult.contentPrefer = GetNullableObjectAtIndex(list, 0);
  pigeonResult.videoProfile = GetNullableObjectAtIndex(list, 1);
  pigeonResult.frameRate = GetNullableObjectAtIndex(list, 2);
  pigeonResult.minFrameRate = GetNullableObjectAtIndex(list, 3);
  pigeonResult.bitrate = GetNullableObjectAtIndex(list, 4);
  pigeonResult.minBitrate = GetNullableObjectAtIndex(list, 5);
  pigeonResult.dict = GetNullableObjectAtIndex(list, 6);
  return pigeonResult;
}
+ (nullable NEFLTStartScreenCaptureRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartScreenCaptureRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.contentPrefer ?: [NSNull null]),
    (self.videoProfile ?: [NSNull null]),
    (self.frameRate ?: [NSNull null]),
    (self.minFrameRate ?: [NSNull null]),
    (self.bitrate ?: [NSNull null]),
    (self.minBitrate ?: [NSNull null]),
    (self.dict ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSubscribeRemoteVideoStreamRequest
+ (instancetype)makeWithUid:(nullable NSNumber *)uid
                 streamType:(nullable NSNumber *)streamType
                  subscribe:(nullable NSNumber *)subscribe {
  NEFLTSubscribeRemoteVideoStreamRequest *pigeonResult =
      [[NEFLTSubscribeRemoteVideoStreamRequest alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.streamType = streamType;
  pigeonResult.subscribe = subscribe;
  return pigeonResult;
}
+ (NEFLTSubscribeRemoteVideoStreamRequest *)fromList:(NSArray *)list {
  NEFLTSubscribeRemoteVideoStreamRequest *pigeonResult =
      [[NEFLTSubscribeRemoteVideoStreamRequest alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 1);
  pigeonResult.subscribe = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTSubscribeRemoteVideoStreamRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSubscribeRemoteVideoStreamRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
    (self.subscribe ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSubscribeRemoteSubStreamVideoRequest
+ (instancetype)makeWithUid:(nullable NSNumber *)uid subscribe:(nullable NSNumber *)subscribe {
  NEFLTSubscribeRemoteSubStreamVideoRequest *pigeonResult =
      [[NEFLTSubscribeRemoteSubStreamVideoRequest alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.subscribe = subscribe;
  return pigeonResult;
}
+ (NEFLTSubscribeRemoteSubStreamVideoRequest *)fromList:(NSArray *)list {
  NEFLTSubscribeRemoteSubStreamVideoRequest *pigeonResult =
      [[NEFLTSubscribeRemoteSubStreamVideoRequest alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.subscribe = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSubscribeRemoteSubStreamVideoRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSubscribeRemoteSubStreamVideoRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.subscribe ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTEnableAudioVolumeIndicationRequest
+ (instancetype)makeWithEnable:(nullable NSNumber *)enable
                      interval:(nullable NSNumber *)interval
                           vad:(nullable NSNumber *)vad {
  NEFLTEnableAudioVolumeIndicationRequest *pigeonResult =
      [[NEFLTEnableAudioVolumeIndicationRequest alloc] init];
  pigeonResult.enable = enable;
  pigeonResult.interval = interval;
  pigeonResult.vad = vad;
  return pigeonResult;
}
+ (NEFLTEnableAudioVolumeIndicationRequest *)fromList:(NSArray *)list {
  NEFLTEnableAudioVolumeIndicationRequest *pigeonResult =
      [[NEFLTEnableAudioVolumeIndicationRequest alloc] init];
  pigeonResult.enable = GetNullableObjectAtIndex(list, 0);
  pigeonResult.interval = GetNullableObjectAtIndex(list, 1);
  pigeonResult.vad = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTEnableAudioVolumeIndicationRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTEnableAudioVolumeIndicationRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enable ?: [NSNull null]),
    (self.interval ?: [NSNull null]),
    (self.vad ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSubscribeRemoteSubStreamAudioRequest
+ (instancetype)makeWithSubscribe:(nullable NSNumber *)subscribe uid:(nullable NSNumber *)uid {
  NEFLTSubscribeRemoteSubStreamAudioRequest *pigeonResult =
      [[NEFLTSubscribeRemoteSubStreamAudioRequest alloc] init];
  pigeonResult.subscribe = subscribe;
  pigeonResult.uid = uid;
  return pigeonResult;
}
+ (NEFLTSubscribeRemoteSubStreamAudioRequest *)fromList:(NSArray *)list {
  NEFLTSubscribeRemoteSubStreamAudioRequest *pigeonResult =
      [[NEFLTSubscribeRemoteSubStreamAudioRequest alloc] init];
  pigeonResult.subscribe = GetNullableObjectAtIndex(list, 0);
  pigeonResult.uid = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSubscribeRemoteSubStreamAudioRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSubscribeRemoteSubStreamAudioRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.subscribe ?: [NSNull null]),
    (self.uid ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetAudioSubscribeOnlyByRequest
+ (instancetype)makeWithUidArray:(nullable NSArray<NSNumber *> *)uidArray {
  NEFLTSetAudioSubscribeOnlyByRequest *pigeonResult =
      [[NEFLTSetAudioSubscribeOnlyByRequest alloc] init];
  pigeonResult.uidArray = uidArray;
  return pigeonResult;
}
+ (NEFLTSetAudioSubscribeOnlyByRequest *)fromList:(NSArray *)list {
  NEFLTSetAudioSubscribeOnlyByRequest *pigeonResult =
      [[NEFLTSetAudioSubscribeOnlyByRequest alloc] init];
  pigeonResult.uidArray = GetNullableObjectAtIndex(list, 0);
  return pigeonResult;
}
+ (nullable NEFLTSetAudioSubscribeOnlyByRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetAudioSubscribeOnlyByRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uidArray ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartAudioMixingRequest
+ (instancetype)makeWithPath:(nullable NSString *)path
                   loopCount:(nullable NSNumber *)loopCount
                 sendEnabled:(nullable NSNumber *)sendEnabled
                  sendVolume:(nullable NSNumber *)sendVolume
             playbackEnabled:(nullable NSNumber *)playbackEnabled
              playbackVolume:(nullable NSNumber *)playbackVolume
              startTimeStamp:(nullable NSNumber *)startTimeStamp
           sendWithAudioType:(nullable NSNumber *)sendWithAudioType
            progressInterval:(nullable NSNumber *)progressInterval {
  NEFLTStartAudioMixingRequest *pigeonResult = [[NEFLTStartAudioMixingRequest alloc] init];
  pigeonResult.path = path;
  pigeonResult.loopCount = loopCount;
  pigeonResult.sendEnabled = sendEnabled;
  pigeonResult.sendVolume = sendVolume;
  pigeonResult.playbackEnabled = playbackEnabled;
  pigeonResult.playbackVolume = playbackVolume;
  pigeonResult.startTimeStamp = startTimeStamp;
  pigeonResult.sendWithAudioType = sendWithAudioType;
  pigeonResult.progressInterval = progressInterval;
  return pigeonResult;
}
+ (NEFLTStartAudioMixingRequest *)fromList:(NSArray *)list {
  NEFLTStartAudioMixingRequest *pigeonResult = [[NEFLTStartAudioMixingRequest alloc] init];
  pigeonResult.path = GetNullableObjectAtIndex(list, 0);
  pigeonResult.loopCount = GetNullableObjectAtIndex(list, 1);
  pigeonResult.sendEnabled = GetNullableObjectAtIndex(list, 2);
  pigeonResult.sendVolume = GetNullableObjectAtIndex(list, 3);
  pigeonResult.playbackEnabled = GetNullableObjectAtIndex(list, 4);
  pigeonResult.playbackVolume = GetNullableObjectAtIndex(list, 5);
  pigeonResult.startTimeStamp = GetNullableObjectAtIndex(list, 6);
  pigeonResult.sendWithAudioType = GetNullableObjectAtIndex(list, 7);
  pigeonResult.progressInterval = GetNullableObjectAtIndex(list, 8);
  return pigeonResult;
}
+ (nullable NEFLTStartAudioMixingRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartAudioMixingRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.path ?: [NSNull null]),
    (self.loopCount ?: [NSNull null]),
    (self.sendEnabled ?: [NSNull null]),
    (self.sendVolume ?: [NSNull null]),
    (self.playbackEnabled ?: [NSNull null]),
    (self.playbackVolume ?: [NSNull null]),
    (self.startTimeStamp ?: [NSNull null]),
    (self.sendWithAudioType ?: [NSNull null]),
    (self.progressInterval ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTPlayEffectRequest
+ (instancetype)makeWithEffectId:(nullable NSNumber *)effectId
                            path:(nullable NSString *)path
                       loopCount:(nullable NSNumber *)loopCount
                     sendEnabled:(nullable NSNumber *)sendEnabled
                      sendVolume:(nullable NSNumber *)sendVolume
                 playbackEnabled:(nullable NSNumber *)playbackEnabled
                  playbackVolume:(nullable NSNumber *)playbackVolume
                  startTimestamp:(nullable NSNumber *)startTimestamp
               sendWithAudioType:(nullable NSNumber *)sendWithAudioType
                progressInterval:(nullable NSNumber *)progressInterval {
  NEFLTPlayEffectRequest *pigeonResult = [[NEFLTPlayEffectRequest alloc] init];
  pigeonResult.effectId = effectId;
  pigeonResult.path = path;
  pigeonResult.loopCount = loopCount;
  pigeonResult.sendEnabled = sendEnabled;
  pigeonResult.sendVolume = sendVolume;
  pigeonResult.playbackEnabled = playbackEnabled;
  pigeonResult.playbackVolume = playbackVolume;
  pigeonResult.startTimestamp = startTimestamp;
  pigeonResult.sendWithAudioType = sendWithAudioType;
  pigeonResult.progressInterval = progressInterval;
  return pigeonResult;
}
+ (NEFLTPlayEffectRequest *)fromList:(NSArray *)list {
  NEFLTPlayEffectRequest *pigeonResult = [[NEFLTPlayEffectRequest alloc] init];
  pigeonResult.effectId = GetNullableObjectAtIndex(list, 0);
  pigeonResult.path = GetNullableObjectAtIndex(list, 1);
  pigeonResult.loopCount = GetNullableObjectAtIndex(list, 2);
  pigeonResult.sendEnabled = GetNullableObjectAtIndex(list, 3);
  pigeonResult.sendVolume = GetNullableObjectAtIndex(list, 4);
  pigeonResult.playbackEnabled = GetNullableObjectAtIndex(list, 5);
  pigeonResult.playbackVolume = GetNullableObjectAtIndex(list, 6);
  pigeonResult.startTimestamp = GetNullableObjectAtIndex(list, 7);
  pigeonResult.sendWithAudioType = GetNullableObjectAtIndex(list, 8);
  pigeonResult.progressInterval = GetNullableObjectAtIndex(list, 9);
  return pigeonResult;
}
+ (nullable NEFLTPlayEffectRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTPlayEffectRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.effectId ?: [NSNull null]),
    (self.path ?: [NSNull null]),
    (self.loopCount ?: [NSNull null]),
    (self.sendEnabled ?: [NSNull null]),
    (self.sendVolume ?: [NSNull null]),
    (self.playbackEnabled ?: [NSNull null]),
    (self.playbackVolume ?: [NSNull null]),
    (self.startTimestamp ?: [NSNull null]),
    (self.sendWithAudioType ?: [NSNull null]),
    (self.progressInterval ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetCameraPositionRequest
+ (instancetype)makeWithX:(nullable NSNumber *)x y:(nullable NSNumber *)y {
  NEFLTSetCameraPositionRequest *pigeonResult = [[NEFLTSetCameraPositionRequest alloc] init];
  pigeonResult.x = x;
  pigeonResult.y = y;
  return pigeonResult;
}
+ (NEFLTSetCameraPositionRequest *)fromList:(NSArray *)list {
  NEFLTSetCameraPositionRequest *pigeonResult = [[NEFLTSetCameraPositionRequest alloc] init];
  pigeonResult.x = GetNullableObjectAtIndex(list, 0);
  pigeonResult.y = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSetCameraPositionRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetCameraPositionRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.x ?: [NSNull null]),
    (self.y ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTAddOrUpdateLiveStreamTaskRequest
+ (instancetype)makeWithSerial:(nullable NSNumber *)serial
                        taskId:(nullable NSString *)taskId
                           url:(nullable NSString *)url
           serverRecordEnabled:(nullable NSNumber *)serverRecordEnabled
                      liveMode:(nullable NSNumber *)liveMode
                   layoutWidth:(nullable NSNumber *)layoutWidth
                  layoutHeight:(nullable NSNumber *)layoutHeight
         layoutBackgroundColor:(nullable NSNumber *)layoutBackgroundColor
                layoutImageUrl:(nullable NSString *)layoutImageUrl
                  layoutImageX:(nullable NSNumber *)layoutImageX
                  layoutImageY:(nullable NSNumber *)layoutImageY
              layoutImageWidth:(nullable NSNumber *)layoutImageWidth
             layoutImageHeight:(nullable NSNumber *)layoutImageHeight
     layoutUserTranscodingList:(nullable NSArray *)layoutUserTranscodingList {
  NEFLTAddOrUpdateLiveStreamTaskRequest *pigeonResult =
      [[NEFLTAddOrUpdateLiveStreamTaskRequest alloc] init];
  pigeonResult.serial = serial;
  pigeonResult.taskId = taskId;
  pigeonResult.url = url;
  pigeonResult.serverRecordEnabled = serverRecordEnabled;
  pigeonResult.liveMode = liveMode;
  pigeonResult.layoutWidth = layoutWidth;
  pigeonResult.layoutHeight = layoutHeight;
  pigeonResult.layoutBackgroundColor = layoutBackgroundColor;
  pigeonResult.layoutImageUrl = layoutImageUrl;
  pigeonResult.layoutImageX = layoutImageX;
  pigeonResult.layoutImageY = layoutImageY;
  pigeonResult.layoutImageWidth = layoutImageWidth;
  pigeonResult.layoutImageHeight = layoutImageHeight;
  pigeonResult.layoutUserTranscodingList = layoutUserTranscodingList;
  return pigeonResult;
}
+ (NEFLTAddOrUpdateLiveStreamTaskRequest *)fromList:(NSArray *)list {
  NEFLTAddOrUpdateLiveStreamTaskRequest *pigeonResult =
      [[NEFLTAddOrUpdateLiveStreamTaskRequest alloc] init];
  pigeonResult.serial = GetNullableObjectAtIndex(list, 0);
  pigeonResult.taskId = GetNullableObjectAtIndex(list, 1);
  pigeonResult.url = GetNullableObjectAtIndex(list, 2);
  pigeonResult.serverRecordEnabled = GetNullableObjectAtIndex(list, 3);
  pigeonResult.liveMode = GetNullableObjectAtIndex(list, 4);
  pigeonResult.layoutWidth = GetNullableObjectAtIndex(list, 5);
  pigeonResult.layoutHeight = GetNullableObjectAtIndex(list, 6);
  pigeonResult.layoutBackgroundColor = GetNullableObjectAtIndex(list, 7);
  pigeonResult.layoutImageUrl = GetNullableObjectAtIndex(list, 8);
  pigeonResult.layoutImageX = GetNullableObjectAtIndex(list, 9);
  pigeonResult.layoutImageY = GetNullableObjectAtIndex(list, 10);
  pigeonResult.layoutImageWidth = GetNullableObjectAtIndex(list, 11);
  pigeonResult.layoutImageHeight = GetNullableObjectAtIndex(list, 12);
  pigeonResult.layoutUserTranscodingList = GetNullableObjectAtIndex(list, 13);
  return pigeonResult;
}
+ (nullable NEFLTAddOrUpdateLiveStreamTaskRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.serial ?: [NSNull null]),
    (self.taskId ?: [NSNull null]),
    (self.url ?: [NSNull null]),
    (self.serverRecordEnabled ?: [NSNull null]),
    (self.liveMode ?: [NSNull null]),
    (self.layoutWidth ?: [NSNull null]),
    (self.layoutHeight ?: [NSNull null]),
    (self.layoutBackgroundColor ?: [NSNull null]),
    (self.layoutImageUrl ?: [NSNull null]),
    (self.layoutImageX ?: [NSNull null]),
    (self.layoutImageY ?: [NSNull null]),
    (self.layoutImageWidth ?: [NSNull null]),
    (self.layoutImageHeight ?: [NSNull null]),
    (self.layoutUserTranscodingList ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTDeleteLiveStreamTaskRequest
+ (instancetype)makeWithSerial:(nullable NSNumber *)serial taskId:(nullable NSString *)taskId {
  NEFLTDeleteLiveStreamTaskRequest *pigeonResult = [[NEFLTDeleteLiveStreamTaskRequest alloc] init];
  pigeonResult.serial = serial;
  pigeonResult.taskId = taskId;
  return pigeonResult;
}
+ (NEFLTDeleteLiveStreamTaskRequest *)fromList:(NSArray *)list {
  NEFLTDeleteLiveStreamTaskRequest *pigeonResult = [[NEFLTDeleteLiveStreamTaskRequest alloc] init];
  pigeonResult.serial = GetNullableObjectAtIndex(list, 0);
  pigeonResult.taskId = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTDeleteLiveStreamTaskRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTDeleteLiveStreamTaskRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.serial ?: [NSNull null]),
    (self.taskId ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSendSEIMsgRequest
+ (instancetype)makeWithSeiMsg:(nullable NSString *)seiMsg
                    streamType:(nullable NSNumber *)streamType {
  NEFLTSendSEIMsgRequest *pigeonResult = [[NEFLTSendSEIMsgRequest alloc] init];
  pigeonResult.seiMsg = seiMsg;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTSendSEIMsgRequest *)fromList:(NSArray *)list {
  NEFLTSendSEIMsgRequest *pigeonResult = [[NEFLTSendSEIMsgRequest alloc] init];
  pigeonResult.seiMsg = GetNullableObjectAtIndex(list, 0);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSendSEIMsgRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSendSEIMsgRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.seiMsg ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetLocalVoiceEqualizationRequest
+ (instancetype)makeWithBandFrequency:(nullable NSNumber *)bandFrequency
                             bandGain:(nullable NSNumber *)bandGain {
  NEFLTSetLocalVoiceEqualizationRequest *pigeonResult =
      [[NEFLTSetLocalVoiceEqualizationRequest alloc] init];
  pigeonResult.bandFrequency = bandFrequency;
  pigeonResult.bandGain = bandGain;
  return pigeonResult;
}
+ (NEFLTSetLocalVoiceEqualizationRequest *)fromList:(NSArray *)list {
  NEFLTSetLocalVoiceEqualizationRequest *pigeonResult =
      [[NEFLTSetLocalVoiceEqualizationRequest alloc] init];
  pigeonResult.bandFrequency = GetNullableObjectAtIndex(list, 0);
  pigeonResult.bandGain = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSetLocalVoiceEqualizationRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetLocalVoiceEqualizationRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.bandFrequency ?: [NSNull null]),
    (self.bandGain ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSwitchChannelRequest
+ (instancetype)makeWithToken:(nullable NSString *)token
                  channelName:(nullable NSString *)channelName
               channelOptions:(nullable NEFLTJoinChannelOptions *)channelOptions {
  NEFLTSwitchChannelRequest *pigeonResult = [[NEFLTSwitchChannelRequest alloc] init];
  pigeonResult.token = token;
  pigeonResult.channelName = channelName;
  pigeonResult.channelOptions = channelOptions;
  return pigeonResult;
}
+ (NEFLTSwitchChannelRequest *)fromList:(NSArray *)list {
  NEFLTSwitchChannelRequest *pigeonResult = [[NEFLTSwitchChannelRequest alloc] init];
  pigeonResult.token = GetNullableObjectAtIndex(list, 0);
  pigeonResult.channelName = GetNullableObjectAtIndex(list, 1);
  pigeonResult.channelOptions =
      [NEFLTJoinChannelOptions nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  return pigeonResult;
}
+ (nullable NEFLTSwitchChannelRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSwitchChannelRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.token ?: [NSNull null]),
    (self.channelName ?: [NSNull null]),
    (self.channelOptions ? [self.channelOptions toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTStartAudioRecordingRequest
+ (instancetype)makeWithFilePath:(nullable NSString *)filePath
                      sampleRate:(nullable NSNumber *)sampleRate
                         quality:(nullable NSNumber *)quality {
  NEFLTStartAudioRecordingRequest *pigeonResult = [[NEFLTStartAudioRecordingRequest alloc] init];
  pigeonResult.filePath = filePath;
  pigeonResult.sampleRate = sampleRate;
  pigeonResult.quality = quality;
  return pigeonResult;
}
+ (NEFLTStartAudioRecordingRequest *)fromList:(NSArray *)list {
  NEFLTStartAudioRecordingRequest *pigeonResult = [[NEFLTStartAudioRecordingRequest alloc] init];
  pigeonResult.filePath = GetNullableObjectAtIndex(list, 0);
  pigeonResult.sampleRate = GetNullableObjectAtIndex(list, 1);
  pigeonResult.quality = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTStartAudioRecordingRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartAudioRecordingRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.filePath ?: [NSNull null]),
    (self.sampleRate ?: [NSNull null]),
    (self.quality ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTAudioRecordingConfigurationRequest
+ (instancetype)makeWithFilePath:(nullable NSString *)filePath
                      sampleRate:(nullable NSNumber *)sampleRate
                         quality:(nullable NSNumber *)quality
                        position:(nullable NSNumber *)position
                       cycleTime:(nullable NSNumber *)cycleTime {
  NEFLTAudioRecordingConfigurationRequest *pigeonResult =
      [[NEFLTAudioRecordingConfigurationRequest alloc] init];
  pigeonResult.filePath = filePath;
  pigeonResult.sampleRate = sampleRate;
  pigeonResult.quality = quality;
  pigeonResult.position = position;
  pigeonResult.cycleTime = cycleTime;
  return pigeonResult;
}
+ (NEFLTAudioRecordingConfigurationRequest *)fromList:(NSArray *)list {
  NEFLTAudioRecordingConfigurationRequest *pigeonResult =
      [[NEFLTAudioRecordingConfigurationRequest alloc] init];
  pigeonResult.filePath = GetNullableObjectAtIndex(list, 0);
  pigeonResult.sampleRate = GetNullableObjectAtIndex(list, 1);
  pigeonResult.quality = GetNullableObjectAtIndex(list, 2);
  pigeonResult.position = GetNullableObjectAtIndex(list, 3);
  pigeonResult.cycleTime = GetNullableObjectAtIndex(list, 4);
  return pigeonResult;
}
+ (nullable NEFLTAudioRecordingConfigurationRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTAudioRecordingConfigurationRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.filePath ?: [NSNull null]),
    (self.sampleRate ?: [NSNull null]),
    (self.quality ?: [NSNull null]),
    (self.position ?: [NSNull null]),
    (self.cycleTime ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetLocalMediaPriorityRequest
+ (instancetype)makeWithPriority:(nullable NSNumber *)priority
                    isPreemptive:(nullable NSNumber *)isPreemptive {
  NEFLTSetLocalMediaPriorityRequest *pigeonResult =
      [[NEFLTSetLocalMediaPriorityRequest alloc] init];
  pigeonResult.priority = priority;
  pigeonResult.isPreemptive = isPreemptive;
  return pigeonResult;
}
+ (NEFLTSetLocalMediaPriorityRequest *)fromList:(NSArray *)list {
  NEFLTSetLocalMediaPriorityRequest *pigeonResult =
      [[NEFLTSetLocalMediaPriorityRequest alloc] init];
  pigeonResult.priority = GetNullableObjectAtIndex(list, 0);
  pigeonResult.isPreemptive = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTSetLocalMediaPriorityRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetLocalMediaPriorityRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.priority ?: [NSNull null]),
    (self.isPreemptive ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartOrUpdateChannelMediaRelayRequest
+ (instancetype)makeWithSourceMediaInfo:(nullable NSDictionary<id, id> *)sourceMediaInfo
                          destMediaInfo:
                              (nullable NSDictionary<id, NSDictionary<id, id> *> *)destMediaInfo {
  NEFLTStartOrUpdateChannelMediaRelayRequest *pigeonResult =
      [[NEFLTStartOrUpdateChannelMediaRelayRequest alloc] init];
  pigeonResult.sourceMediaInfo = sourceMediaInfo;
  pigeonResult.destMediaInfo = destMediaInfo;
  return pigeonResult;
}
+ (NEFLTStartOrUpdateChannelMediaRelayRequest *)fromList:(NSArray *)list {
  NEFLTStartOrUpdateChannelMediaRelayRequest *pigeonResult =
      [[NEFLTStartOrUpdateChannelMediaRelayRequest alloc] init];
  pigeonResult.sourceMediaInfo = GetNullableObjectAtIndex(list, 0);
  pigeonResult.destMediaInfo = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTStartOrUpdateChannelMediaRelayRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.sourceMediaInfo ?: [NSNull null]),
    (self.destMediaInfo ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTAdjustUserPlaybackSignalVolumeRequest
+ (instancetype)makeWithUid:(nullable NSNumber *)uid volume:(nullable NSNumber *)volume {
  NEFLTAdjustUserPlaybackSignalVolumeRequest *pigeonResult =
      [[NEFLTAdjustUserPlaybackSignalVolumeRequest alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.volume = volume;
  return pigeonResult;
}
+ (NEFLTAdjustUserPlaybackSignalVolumeRequest *)fromList:(NSArray *)list {
  NEFLTAdjustUserPlaybackSignalVolumeRequest *pigeonResult =
      [[NEFLTAdjustUserPlaybackSignalVolumeRequest alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.volume = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTAdjustUserPlaybackSignalVolumeRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.volume ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTEnableEncryptionRequest
+ (instancetype)makeWithKey:(nullable NSString *)key
                       mode:(nullable NSNumber *)mode
                     enable:(nullable NSNumber *)enable {
  NEFLTEnableEncryptionRequest *pigeonResult = [[NEFLTEnableEncryptionRequest alloc] init];
  pigeonResult.key = key;
  pigeonResult.mode = mode;
  pigeonResult.enable = enable;
  return pigeonResult;
}
+ (NEFLTEnableEncryptionRequest *)fromList:(NSArray *)list {
  NEFLTEnableEncryptionRequest *pigeonResult = [[NEFLTEnableEncryptionRequest alloc] init];
  pigeonResult.key = GetNullableObjectAtIndex(list, 0);
  pigeonResult.mode = GetNullableObjectAtIndex(list, 1);
  pigeonResult.enable = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTEnableEncryptionRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTEnableEncryptionRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.key ?: [NSNull null]),
    (self.mode ?: [NSNull null]),
    (self.enable ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetLocalVoiceReverbParamRequest
+ (instancetype)makeWithWetGain:(nullable NSNumber *)wetGain
                        dryGain:(nullable NSNumber *)dryGain
                        damping:(nullable NSNumber *)damping
                       roomSize:(nullable NSNumber *)roomSize
                      decayTime:(nullable NSNumber *)decayTime
                       preDelay:(nullable NSNumber *)preDelay {
  NEFLTSetLocalVoiceReverbParamRequest *pigeonResult =
      [[NEFLTSetLocalVoiceReverbParamRequest alloc] init];
  pigeonResult.wetGain = wetGain;
  pigeonResult.dryGain = dryGain;
  pigeonResult.damping = damping;
  pigeonResult.roomSize = roomSize;
  pigeonResult.decayTime = decayTime;
  pigeonResult.preDelay = preDelay;
  return pigeonResult;
}
+ (NEFLTSetLocalVoiceReverbParamRequest *)fromList:(NSArray *)list {
  NEFLTSetLocalVoiceReverbParamRequest *pigeonResult =
      [[NEFLTSetLocalVoiceReverbParamRequest alloc] init];
  pigeonResult.wetGain = GetNullableObjectAtIndex(list, 0);
  pigeonResult.dryGain = GetNullableObjectAtIndex(list, 1);
  pigeonResult.damping = GetNullableObjectAtIndex(list, 2);
  pigeonResult.roomSize = GetNullableObjectAtIndex(list, 3);
  pigeonResult.decayTime = GetNullableObjectAtIndex(list, 4);
  pigeonResult.preDelay = GetNullableObjectAtIndex(list, 5);
  return pigeonResult;
}
+ (nullable NEFLTSetLocalVoiceReverbParamRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetLocalVoiceReverbParamRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.wetGain ?: [NSNull null]),
    (self.dryGain ?: [NSNull null]),
    (self.damping ?: [NSNull null]),
    (self.roomSize ?: [NSNull null]),
    (self.decayTime ?: [NSNull null]),
    (self.preDelay ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTReportCustomEventRequest
+ (instancetype)makeWithEventName:(nullable NSString *)eventName
                   customIdentify:(nullable NSString *)customIdentify
                            param:(nullable NSDictionary<NSString *, id> *)param {
  NEFLTReportCustomEventRequest *pigeonResult = [[NEFLTReportCustomEventRequest alloc] init];
  pigeonResult.eventName = eventName;
  pigeonResult.customIdentify = customIdentify;
  pigeonResult.param = param;
  return pigeonResult;
}
+ (NEFLTReportCustomEventRequest *)fromList:(NSArray *)list {
  NEFLTReportCustomEventRequest *pigeonResult = [[NEFLTReportCustomEventRequest alloc] init];
  pigeonResult.eventName = GetNullableObjectAtIndex(list, 0);
  pigeonResult.customIdentify = GetNullableObjectAtIndex(list, 1);
  pigeonResult.param = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTReportCustomEventRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTReportCustomEventRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.eventName ?: [NSNull null]),
    (self.customIdentify ?: [NSNull null]),
    (self.param ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartLastmileProbeTestRequest
+ (instancetype)makeWithProbeUplink:(nullable NSNumber *)probeUplink
                      probeDownlink:(nullable NSNumber *)probeDownlink
              expectedUplinkBitrate:(nullable NSNumber *)expectedUplinkBitrate
            expectedDownlinkBitrate:(nullable NSNumber *)expectedDownlinkBitrate {
  NEFLTStartLastmileProbeTestRequest *pigeonResult =
      [[NEFLTStartLastmileProbeTestRequest alloc] init];
  pigeonResult.probeUplink = probeUplink;
  pigeonResult.probeDownlink = probeDownlink;
  pigeonResult.expectedUplinkBitrate = expectedUplinkBitrate;
  pigeonResult.expectedDownlinkBitrate = expectedDownlinkBitrate;
  return pigeonResult;
}
+ (NEFLTStartLastmileProbeTestRequest *)fromList:(NSArray *)list {
  NEFLTStartLastmileProbeTestRequest *pigeonResult =
      [[NEFLTStartLastmileProbeTestRequest alloc] init];
  pigeonResult.probeUplink = GetNullableObjectAtIndex(list, 0);
  pigeonResult.probeDownlink = GetNullableObjectAtIndex(list, 1);
  pigeonResult.expectedUplinkBitrate = GetNullableObjectAtIndex(list, 2);
  pigeonResult.expectedDownlinkBitrate = GetNullableObjectAtIndex(list, 3);
  return pigeonResult;
}
+ (nullable NEFLTStartLastmileProbeTestRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartLastmileProbeTestRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.probeUplink ?: [NSNull null]),
    (self.probeDownlink ?: [NSNull null]),
    (self.expectedUplinkBitrate ?: [NSNull null]),
    (self.expectedDownlinkBitrate ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTCGPoint
+ (instancetype)makeWithX:(NSNumber *)x y:(NSNumber *)y {
  NEFLTCGPoint *pigeonResult = [[NEFLTCGPoint alloc] init];
  pigeonResult.x = x;
  pigeonResult.y = y;
  return pigeonResult;
}
+ (NEFLTCGPoint *)fromList:(NSArray *)list {
  NEFLTCGPoint *pigeonResult = [[NEFLTCGPoint alloc] init];
  pigeonResult.x = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.x != nil, @"");
  pigeonResult.y = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.y != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTCGPoint *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTCGPoint fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.x ?: [NSNull null]),
    (self.y ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetVideoCorrectionConfigRequest
+ (instancetype)makeWithTopLeft:(nullable NEFLTCGPoint *)topLeft
                       topRight:(nullable NEFLTCGPoint *)topRight
                     bottomLeft:(nullable NEFLTCGPoint *)bottomLeft
                    bottomRight:(nullable NEFLTCGPoint *)bottomRight
                    canvasWidth:(nullable NSNumber *)canvasWidth
                   canvasHeight:(nullable NSNumber *)canvasHeight
                   enableMirror:(nullable NSNumber *)enableMirror {
  NEFLTSetVideoCorrectionConfigRequest *pigeonResult =
      [[NEFLTSetVideoCorrectionConfigRequest alloc] init];
  pigeonResult.topLeft = topLeft;
  pigeonResult.topRight = topRight;
  pigeonResult.bottomLeft = bottomLeft;
  pigeonResult.bottomRight = bottomRight;
  pigeonResult.canvasWidth = canvasWidth;
  pigeonResult.canvasHeight = canvasHeight;
  pigeonResult.enableMirror = enableMirror;
  return pigeonResult;
}
+ (NEFLTSetVideoCorrectionConfigRequest *)fromList:(NSArray *)list {
  NEFLTSetVideoCorrectionConfigRequest *pigeonResult =
      [[NEFLTSetVideoCorrectionConfigRequest alloc] init];
  pigeonResult.topLeft = [NEFLTCGPoint nullableFromList:(GetNullableObjectAtIndex(list, 0))];
  pigeonResult.topRight = [NEFLTCGPoint nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  pigeonResult.bottomLeft = [NEFLTCGPoint nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  pigeonResult.bottomRight = [NEFLTCGPoint nullableFromList:(GetNullableObjectAtIndex(list, 3))];
  pigeonResult.canvasWidth = GetNullableObjectAtIndex(list, 4);
  pigeonResult.canvasHeight = GetNullableObjectAtIndex(list, 5);
  pigeonResult.enableMirror = GetNullableObjectAtIndex(list, 6);
  return pigeonResult;
}
+ (nullable NEFLTSetVideoCorrectionConfigRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetVideoCorrectionConfigRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.topLeft ? [self.topLeft toList] : [NSNull null]),
    (self.topRight ? [self.topRight toList] : [NSNull null]),
    (self.bottomLeft ? [self.bottomLeft toList] : [NSNull null]),
    (self.bottomRight ? [self.bottomRight toList] : [NSNull null]),
    (self.canvasWidth ?: [NSNull null]),
    (self.canvasHeight ?: [NSNull null]),
    (self.enableMirror ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTEnableVirtualBackgroundRequest
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
           backgroundSourceType:(nullable NSNumber *)backgroundSourceType
                          color:(nullable NSNumber *)color
                         source:(nullable NSString *)source
                    blur_degree:(nullable NSNumber *)blur_degree {
  NEFLTEnableVirtualBackgroundRequest *pigeonResult =
      [[NEFLTEnableVirtualBackgroundRequest alloc] init];
  pigeonResult.enabled = enabled;
  pigeonResult.backgroundSourceType = backgroundSourceType;
  pigeonResult.color = color;
  pigeonResult.source = source;
  pigeonResult.blur_degree = blur_degree;
  return pigeonResult;
}
+ (NEFLTEnableVirtualBackgroundRequest *)fromList:(NSArray *)list {
  NEFLTEnableVirtualBackgroundRequest *pigeonResult =
      [[NEFLTEnableVirtualBackgroundRequest alloc] init];
  pigeonResult.enabled = GetNullableObjectAtIndex(list, 0);
  pigeonResult.backgroundSourceType = GetNullableObjectAtIndex(list, 1);
  pigeonResult.color = GetNullableObjectAtIndex(list, 2);
  pigeonResult.source = GetNullableObjectAtIndex(list, 3);
  pigeonResult.blur_degree = GetNullableObjectAtIndex(list, 4);
  return pigeonResult;
}
+ (nullable NEFLTEnableVirtualBackgroundRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTEnableVirtualBackgroundRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enabled ?: [NSNull null]),
    (self.backgroundSourceType ?: [NSNull null]),
    (self.color ?: [NSNull null]),
    (self.source ?: [NSNull null]),
    (self.blur_degree ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetRemoteHighPriorityAudioStreamRequest
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled
                            uid:(nullable NSNumber *)uid
                     streamType:(nullable NSNumber *)streamType {
  NEFLTSetRemoteHighPriorityAudioStreamRequest *pigeonResult =
      [[NEFLTSetRemoteHighPriorityAudioStreamRequest alloc] init];
  pigeonResult.enabled = enabled;
  pigeonResult.uid = uid;
  pigeonResult.streamType = streamType;
  return pigeonResult;
}
+ (NEFLTSetRemoteHighPriorityAudioStreamRequest *)fromList:(NSArray *)list {
  NEFLTSetRemoteHighPriorityAudioStreamRequest *pigeonResult =
      [[NEFLTSetRemoteHighPriorityAudioStreamRequest alloc] init];
  pigeonResult.enabled = GetNullableObjectAtIndex(list, 0);
  pigeonResult.uid = GetNullableObjectAtIndex(list, 1);
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTSetRemoteHighPriorityAudioStreamRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enabled ?: [NSNull null]),
    (self.uid ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVideoWatermarkImageConfig
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                     imagePaths:(nullable NSArray<NSString *> *)imagePaths
                            fps:(nullable NSNumber *)fps
                           loop:(nullable NSNumber *)loop {
  NEFLTVideoWatermarkImageConfig *pigeonResult = [[NEFLTVideoWatermarkImageConfig alloc] init];
  pigeonResult.wmAlpha = wmAlpha;
  pigeonResult.wmWidth = wmWidth;
  pigeonResult.wmHeight = wmHeight;
  pigeonResult.offsetX = offsetX;
  pigeonResult.offsetY = offsetY;
  pigeonResult.imagePaths = imagePaths;
  pigeonResult.fps = fps;
  pigeonResult.loop = loop;
  return pigeonResult;
}
+ (NEFLTVideoWatermarkImageConfig *)fromList:(NSArray *)list {
  NEFLTVideoWatermarkImageConfig *pigeonResult = [[NEFLTVideoWatermarkImageConfig alloc] init];
  pigeonResult.wmAlpha = GetNullableObjectAtIndex(list, 0);
  pigeonResult.wmWidth = GetNullableObjectAtIndex(list, 1);
  pigeonResult.wmHeight = GetNullableObjectAtIndex(list, 2);
  pigeonResult.offsetX = GetNullableObjectAtIndex(list, 3);
  pigeonResult.offsetY = GetNullableObjectAtIndex(list, 4);
  pigeonResult.imagePaths = GetNullableObjectAtIndex(list, 5);
  pigeonResult.fps = GetNullableObjectAtIndex(list, 6);
  pigeonResult.loop = GetNullableObjectAtIndex(list, 7);
  return pigeonResult;
}
+ (nullable NEFLTVideoWatermarkImageConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVideoWatermarkImageConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.wmAlpha ?: [NSNull null]),
    (self.wmWidth ?: [NSNull null]),
    (self.wmHeight ?: [NSNull null]),
    (self.offsetX ?: [NSNull null]),
    (self.offsetY ?: [NSNull null]),
    (self.imagePaths ?: [NSNull null]),
    (self.fps ?: [NSNull null]),
    (self.loop ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVideoWatermarkTextConfig
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                        wmColor:(nullable NSNumber *)wmColor
                       fontSize:(nullable NSNumber *)fontSize
                      fontColor:(nullable NSNumber *)fontColor
                 fontNameOrPath:(nullable NSString *)fontNameOrPath
                        content:(nullable NSString *)content {
  NEFLTVideoWatermarkTextConfig *pigeonResult = [[NEFLTVideoWatermarkTextConfig alloc] init];
  pigeonResult.wmAlpha = wmAlpha;
  pigeonResult.wmWidth = wmWidth;
  pigeonResult.wmHeight = wmHeight;
  pigeonResult.offsetX = offsetX;
  pigeonResult.offsetY = offsetY;
  pigeonResult.wmColor = wmColor;
  pigeonResult.fontSize = fontSize;
  pigeonResult.fontColor = fontColor;
  pigeonResult.fontNameOrPath = fontNameOrPath;
  pigeonResult.content = content;
  return pigeonResult;
}
+ (NEFLTVideoWatermarkTextConfig *)fromList:(NSArray *)list {
  NEFLTVideoWatermarkTextConfig *pigeonResult = [[NEFLTVideoWatermarkTextConfig alloc] init];
  pigeonResult.wmAlpha = GetNullableObjectAtIndex(list, 0);
  pigeonResult.wmWidth = GetNullableObjectAtIndex(list, 1);
  pigeonResult.wmHeight = GetNullableObjectAtIndex(list, 2);
  pigeonResult.offsetX = GetNullableObjectAtIndex(list, 3);
  pigeonResult.offsetY = GetNullableObjectAtIndex(list, 4);
  pigeonResult.wmColor = GetNullableObjectAtIndex(list, 5);
  pigeonResult.fontSize = GetNullableObjectAtIndex(list, 6);
  pigeonResult.fontColor = GetNullableObjectAtIndex(list, 7);
  pigeonResult.fontNameOrPath = GetNullableObjectAtIndex(list, 8);
  pigeonResult.content = GetNullableObjectAtIndex(list, 9);
  return pigeonResult;
}
+ (nullable NEFLTVideoWatermarkTextConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVideoWatermarkTextConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.wmAlpha ?: [NSNull null]),
    (self.wmWidth ?: [NSNull null]),
    (self.wmHeight ?: [NSNull null]),
    (self.offsetX ?: [NSNull null]),
    (self.offsetY ?: [NSNull null]),
    (self.wmColor ?: [NSNull null]),
    (self.fontSize ?: [NSNull null]),
    (self.fontColor ?: [NSNull null]),
    (self.fontNameOrPath ?: [NSNull null]),
    (self.content ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVideoWatermarkTimestampConfig
+ (instancetype)makeWithWmAlpha:(nullable NSNumber *)wmAlpha
                        wmWidth:(nullable NSNumber *)wmWidth
                       wmHeight:(nullable NSNumber *)wmHeight
                        offsetX:(nullable NSNumber *)offsetX
                        offsetY:(nullable NSNumber *)offsetY
                        wmColor:(nullable NSNumber *)wmColor
                       fontSize:(nullable NSNumber *)fontSize
                      fontColor:(nullable NSNumber *)fontColor
                 fontNameOrPath:(nullable NSString *)fontNameOrPath {
  NEFLTVideoWatermarkTimestampConfig *pigeonResult =
      [[NEFLTVideoWatermarkTimestampConfig alloc] init];
  pigeonResult.wmAlpha = wmAlpha;
  pigeonResult.wmWidth = wmWidth;
  pigeonResult.wmHeight = wmHeight;
  pigeonResult.offsetX = offsetX;
  pigeonResult.offsetY = offsetY;
  pigeonResult.wmColor = wmColor;
  pigeonResult.fontSize = fontSize;
  pigeonResult.fontColor = fontColor;
  pigeonResult.fontNameOrPath = fontNameOrPath;
  return pigeonResult;
}
+ (NEFLTVideoWatermarkTimestampConfig *)fromList:(NSArray *)list {
  NEFLTVideoWatermarkTimestampConfig *pigeonResult =
      [[NEFLTVideoWatermarkTimestampConfig alloc] init];
  pigeonResult.wmAlpha = GetNullableObjectAtIndex(list, 0);
  pigeonResult.wmWidth = GetNullableObjectAtIndex(list, 1);
  pigeonResult.wmHeight = GetNullableObjectAtIndex(list, 2);
  pigeonResult.offsetX = GetNullableObjectAtIndex(list, 3);
  pigeonResult.offsetY = GetNullableObjectAtIndex(list, 4);
  pigeonResult.wmColor = GetNullableObjectAtIndex(list, 5);
  pigeonResult.fontSize = GetNullableObjectAtIndex(list, 6);
  pigeonResult.fontColor = GetNullableObjectAtIndex(list, 7);
  pigeonResult.fontNameOrPath = GetNullableObjectAtIndex(list, 8);
  return pigeonResult;
}
+ (nullable NEFLTVideoWatermarkTimestampConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVideoWatermarkTimestampConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.wmAlpha ?: [NSNull null]),
    (self.wmWidth ?: [NSNull null]),
    (self.wmHeight ?: [NSNull null]),
    (self.offsetX ?: [NSNull null]),
    (self.offsetY ?: [NSNull null]),
    (self.wmColor ?: [NSNull null]),
    (self.fontSize ?: [NSNull null]),
    (self.fontColor ?: [NSNull null]),
    (self.fontNameOrPath ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVideoWatermarkConfig
+ (instancetype)makeWithWatermarkType:(NEFLTNERtcVideoWatermarkType)WatermarkType
                       imageWatermark:(nullable NEFLTVideoWatermarkImageConfig *)imageWatermark
                        textWatermark:(nullable NEFLTVideoWatermarkTextConfig *)textWatermark
                   timestampWatermark:
                       (nullable NEFLTVideoWatermarkTimestampConfig *)timestampWatermark {
  NEFLTVideoWatermarkConfig *pigeonResult = [[NEFLTVideoWatermarkConfig alloc] init];
  pigeonResult.WatermarkType = WatermarkType;
  pigeonResult.imageWatermark = imageWatermark;
  pigeonResult.textWatermark = textWatermark;
  pigeonResult.timestampWatermark = timestampWatermark;
  return pigeonResult;
}
+ (NEFLTVideoWatermarkConfig *)fromList:(NSArray *)list {
  NEFLTVideoWatermarkConfig *pigeonResult = [[NEFLTVideoWatermarkConfig alloc] init];
  pigeonResult.WatermarkType = [GetNullableObjectAtIndex(list, 0) integerValue];
  pigeonResult.imageWatermark =
      [NEFLTVideoWatermarkImageConfig nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  pigeonResult.textWatermark =
      [NEFLTVideoWatermarkTextConfig nullableFromList:(GetNullableObjectAtIndex(list, 2))];
  pigeonResult.timestampWatermark =
      [NEFLTVideoWatermarkTimestampConfig nullableFromList:(GetNullableObjectAtIndex(list, 3))];
  return pigeonResult;
}
+ (nullable NEFLTVideoWatermarkConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVideoWatermarkConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    @(self.WatermarkType),
    (self.imageWatermark ? [self.imageWatermark toList] : [NSNull null]),
    (self.textWatermark ? [self.textWatermark toList] : [NSNull null]),
    (self.timestampWatermark ? [self.timestampWatermark toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTSetLocalVideoWatermarkConfigsRequest
+ (instancetype)makeWithType:(NSNumber *)type config:(nullable NEFLTVideoWatermarkConfig *)config {
  NEFLTSetLocalVideoWatermarkConfigsRequest *pigeonResult =
      [[NEFLTSetLocalVideoWatermarkConfigsRequest alloc] init];
  pigeonResult.type = type;
  pigeonResult.config = config;
  return pigeonResult;
}
+ (NEFLTSetLocalVideoWatermarkConfigsRequest *)fromList:(NSArray *)list {
  NEFLTSetLocalVideoWatermarkConfigsRequest *pigeonResult =
      [[NEFLTSetLocalVideoWatermarkConfigsRequest alloc] init];
  pigeonResult.type = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.type != nil, @"");
  pigeonResult.config =
      [NEFLTVideoWatermarkConfig nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  return pigeonResult;
}
+ (nullable NEFLTSetLocalVideoWatermarkConfigsRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetLocalVideoWatermarkConfigsRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.type ?: [NSNull null]),
    (self.config ? [self.config toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTPositionInfo
+ (instancetype)makeWithMSpeakerPosition:(NSArray<NSNumber *> *)mSpeakerPosition
                      mSpeakerQuaternion:(NSArray<NSNumber *> *)mSpeakerQuaternion
                           mHeadPosition:(NSArray<NSNumber *> *)mHeadPosition
                         mHeadQuaternion:(NSArray<NSNumber *> *)mHeadQuaternion {
  NEFLTPositionInfo *pigeonResult = [[NEFLTPositionInfo alloc] init];
  pigeonResult.mSpeakerPosition = mSpeakerPosition;
  pigeonResult.mSpeakerQuaternion = mSpeakerQuaternion;
  pigeonResult.mHeadPosition = mHeadPosition;
  pigeonResult.mHeadQuaternion = mHeadQuaternion;
  return pigeonResult;
}
+ (NEFLTPositionInfo *)fromList:(NSArray *)list {
  NEFLTPositionInfo *pigeonResult = [[NEFLTPositionInfo alloc] init];
  pigeonResult.mSpeakerPosition = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.mSpeakerPosition != nil, @"");
  pigeonResult.mSpeakerQuaternion = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.mSpeakerQuaternion != nil, @"");
  pigeonResult.mHeadPosition = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.mHeadPosition != nil, @"");
  pigeonResult.mHeadQuaternion = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.mHeadQuaternion != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTPositionInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTPositionInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.mSpeakerPosition ?: [NSNull null]),
    (self.mSpeakerQuaternion ?: [NSNull null]),
    (self.mHeadPosition ?: [NSNull null]),
    (self.mHeadQuaternion ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSpatializerRoomProperty
+ (instancetype)makeWithRoomCapacity:(NSNumber *)roomCapacity
                            material:(NSNumber *)material
                    reflectionScalar:(NSNumber *)reflectionScalar
                          reverbGain:(NSNumber *)reverbGain
                          reverbTime:(NSNumber *)reverbTime
                    reverbBrightness:(NSNumber *)reverbBrightness {
  NEFLTSpatializerRoomProperty *pigeonResult = [[NEFLTSpatializerRoomProperty alloc] init];
  pigeonResult.roomCapacity = roomCapacity;
  pigeonResult.material = material;
  pigeonResult.reflectionScalar = reflectionScalar;
  pigeonResult.reverbGain = reverbGain;
  pigeonResult.reverbTime = reverbTime;
  pigeonResult.reverbBrightness = reverbBrightness;
  return pigeonResult;
}
+ (NEFLTSpatializerRoomProperty *)fromList:(NSArray *)list {
  NEFLTSpatializerRoomProperty *pigeonResult = [[NEFLTSpatializerRoomProperty alloc] init];
  pigeonResult.roomCapacity = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.roomCapacity != nil, @"");
  pigeonResult.material = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.material != nil, @"");
  pigeonResult.reflectionScalar = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.reflectionScalar != nil, @"");
  pigeonResult.reverbGain = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.reverbGain != nil, @"");
  pigeonResult.reverbTime = GetNullableObjectAtIndex(list, 4);
  NSAssert(pigeonResult.reverbTime != nil, @"");
  pigeonResult.reverbBrightness = GetNullableObjectAtIndex(list, 5);
  NSAssert(pigeonResult.reverbBrightness != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTSpatializerRoomProperty *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSpatializerRoomProperty fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.roomCapacity ?: [NSNull null]),
    (self.material ?: [NSNull null]),
    (self.reflectionScalar ?: [NSNull null]),
    (self.reverbGain ?: [NSNull null]),
    (self.reverbTime ?: [NSNull null]),
    (self.reverbBrightness ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTLocalRecordingConfig
+ (instancetype)makeWithFilePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                           width:(NSNumber *)width
                          height:(NSNumber *)height
                       framerate:(NSNumber *)framerate
                  recordFileType:(NSNumber *)recordFileType
                      remuxToMp4:(NSNumber *)remuxToMp4
                      videoMerge:(NSNumber *)videoMerge
                     recordAudio:(NSNumber *)recordAudio
                     audioFormat:(NSNumber *)audioFormat
                     recordVideo:(NSNumber *)recordVideo
                 videoRecordMode:(NSNumber *)videoRecordMode
                   watermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)watermarkList
                   coverFilePath:(nullable NSString *)coverFilePath
              coverWatermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)coverWatermarkList
            defaultCoverFilePath:(nullable NSString *)defaultCoverFilePath {
  NEFLTLocalRecordingConfig *pigeonResult = [[NEFLTLocalRecordingConfig alloc] init];
  pigeonResult.filePath = filePath;
  pigeonResult.fileName = fileName;
  pigeonResult.width = width;
  pigeonResult.height = height;
  pigeonResult.framerate = framerate;
  pigeonResult.recordFileType = recordFileType;
  pigeonResult.remuxToMp4 = remuxToMp4;
  pigeonResult.videoMerge = videoMerge;
  pigeonResult.recordAudio = recordAudio;
  pigeonResult.audioFormat = audioFormat;
  pigeonResult.recordVideo = recordVideo;
  pigeonResult.videoRecordMode = videoRecordMode;
  pigeonResult.watermarkList = watermarkList;
  pigeonResult.coverFilePath = coverFilePath;
  pigeonResult.coverWatermarkList = coverWatermarkList;
  pigeonResult.defaultCoverFilePath = defaultCoverFilePath;
  return pigeonResult;
}
+ (NEFLTLocalRecordingConfig *)fromList:(NSArray *)list {
  NEFLTLocalRecordingConfig *pigeonResult = [[NEFLTLocalRecordingConfig alloc] init];
  pigeonResult.filePath = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.filePath != nil, @"");
  pigeonResult.fileName = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.fileName != nil, @"");
  pigeonResult.width = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.width != nil, @"");
  pigeonResult.height = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.height != nil, @"");
  pigeonResult.framerate = GetNullableObjectAtIndex(list, 4);
  NSAssert(pigeonResult.framerate != nil, @"");
  pigeonResult.recordFileType = GetNullableObjectAtIndex(list, 5);
  NSAssert(pigeonResult.recordFileType != nil, @"");
  pigeonResult.remuxToMp4 = GetNullableObjectAtIndex(list, 6);
  NSAssert(pigeonResult.remuxToMp4 != nil, @"");
  pigeonResult.videoMerge = GetNullableObjectAtIndex(list, 7);
  NSAssert(pigeonResult.videoMerge != nil, @"");
  pigeonResult.recordAudio = GetNullableObjectAtIndex(list, 8);
  NSAssert(pigeonResult.recordAudio != nil, @"");
  pigeonResult.audioFormat = GetNullableObjectAtIndex(list, 9);
  NSAssert(pigeonResult.audioFormat != nil, @"");
  pigeonResult.recordVideo = GetNullableObjectAtIndex(list, 10);
  NSAssert(pigeonResult.recordVideo != nil, @"");
  pigeonResult.videoRecordMode = GetNullableObjectAtIndex(list, 11);
  NSAssert(pigeonResult.videoRecordMode != nil, @"");
  pigeonResult.watermarkList = GetNullableObjectAtIndex(list, 12);
  pigeonResult.coverFilePath = GetNullableObjectAtIndex(list, 13);
  pigeonResult.coverWatermarkList = GetNullableObjectAtIndex(list, 14);
  pigeonResult.defaultCoverFilePath = GetNullableObjectAtIndex(list, 15);
  return pigeonResult;
}
+ (nullable NEFLTLocalRecordingConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTLocalRecordingConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.filePath ?: [NSNull null]),
    (self.fileName ?: [NSNull null]),
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
    (self.framerate ?: [NSNull null]),
    (self.recordFileType ?: [NSNull null]),
    (self.remuxToMp4 ?: [NSNull null]),
    (self.videoMerge ?: [NSNull null]),
    (self.recordAudio ?: [NSNull null]),
    (self.audioFormat ?: [NSNull null]),
    (self.recordVideo ?: [NSNull null]),
    (self.videoRecordMode ?: [NSNull null]),
    (self.watermarkList ?: [NSNull null]),
    (self.coverFilePath ?: [NSNull null]),
    (self.coverWatermarkList ?: [NSNull null]),
    (self.defaultCoverFilePath ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTLocalRecordingLayoutConfig
+ (instancetype)makeWithOffsetX:(NSNumber *)offsetX
                        offsetY:(NSNumber *)offsetY
                          width:(NSNumber *)width
                         height:(NSNumber *)height
                    scalingMode:(NSNumber *)scalingMode
                  watermarkList:(nullable NSArray<NEFLTVideoWatermarkConfig *> *)watermarkList
                  isScreenShare:(NSNumber *)isScreenShare
                        bgColor:(NSNumber *)bgColor {
  NEFLTLocalRecordingLayoutConfig *pigeonResult = [[NEFLTLocalRecordingLayoutConfig alloc] init];
  pigeonResult.offsetX = offsetX;
  pigeonResult.offsetY = offsetY;
  pigeonResult.width = width;
  pigeonResult.height = height;
  pigeonResult.scalingMode = scalingMode;
  pigeonResult.watermarkList = watermarkList;
  pigeonResult.isScreenShare = isScreenShare;
  pigeonResult.bgColor = bgColor;
  return pigeonResult;
}
+ (NEFLTLocalRecordingLayoutConfig *)fromList:(NSArray *)list {
  NEFLTLocalRecordingLayoutConfig *pigeonResult = [[NEFLTLocalRecordingLayoutConfig alloc] init];
  pigeonResult.offsetX = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.offsetX != nil, @"");
  pigeonResult.offsetY = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.offsetY != nil, @"");
  pigeonResult.width = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.width != nil, @"");
  pigeonResult.height = GetNullableObjectAtIndex(list, 3);
  NSAssert(pigeonResult.height != nil, @"");
  pigeonResult.scalingMode = GetNullableObjectAtIndex(list, 4);
  NSAssert(pigeonResult.scalingMode != nil, @"");
  pigeonResult.watermarkList = GetNullableObjectAtIndex(list, 5);
  pigeonResult.isScreenShare = GetNullableObjectAtIndex(list, 6);
  NSAssert(pigeonResult.isScreenShare != nil, @"");
  pigeonResult.bgColor = GetNullableObjectAtIndex(list, 7);
  NSAssert(pigeonResult.bgColor != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTLocalRecordingLayoutConfig *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTLocalRecordingLayoutConfig fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.offsetX ?: [NSNull null]),
    (self.offsetY ?: [NSNull null]),
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
    (self.scalingMode ?: [NSNull null]),
    (self.watermarkList ?: [NSNull null]),
    (self.isScreenShare ?: [NSNull null]),
    (self.bgColor ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTLocalRecordingStreamInfo
+ (instancetype)makeWithUid:(NSNumber *)uid
                 streamType:(NSNumber *)streamType
                streamLayer:(NSNumber *)streamLayer
               layoutConfig:(NEFLTLocalRecordingLayoutConfig *)layoutConfig {
  NEFLTLocalRecordingStreamInfo *pigeonResult = [[NEFLTLocalRecordingStreamInfo alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.streamType = streamType;
  pigeonResult.streamLayer = streamLayer;
  pigeonResult.layoutConfig = layoutConfig;
  return pigeonResult;
}
+ (NEFLTLocalRecordingStreamInfo *)fromList:(NSArray *)list {
  NEFLTLocalRecordingStreamInfo *pigeonResult = [[NEFLTLocalRecordingStreamInfo alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  NSAssert(pigeonResult.uid != nil, @"");
  pigeonResult.streamType = GetNullableObjectAtIndex(list, 1);
  NSAssert(pigeonResult.streamType != nil, @"");
  pigeonResult.streamLayer = GetNullableObjectAtIndex(list, 2);
  NSAssert(pigeonResult.streamLayer != nil, @"");
  pigeonResult.layoutConfig =
      [NEFLTLocalRecordingLayoutConfig nullableFromList:(GetNullableObjectAtIndex(list, 3))];
  NSAssert(pigeonResult.layoutConfig != nil, @"");
  return pigeonResult;
}
+ (nullable NEFLTLocalRecordingStreamInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTLocalRecordingStreamInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.streamType ?: [NSNull null]),
    (self.streamLayer ?: [NSNull null]),
    (self.layoutConfig ? [self.layoutConfig toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTNERtcVersion
+ (instancetype)makeWithVersionName:(nullable NSString *)versionName
                        versionCode:(nullable NSNumber *)versionCode
                          buildType:(nullable NSString *)buildType
                          buildDate:(nullable NSString *)buildDate
                      buildRevision:(nullable NSString *)buildRevision
                          buildHost:(nullable NSString *)buildHost
                          serverEnv:(nullable NSString *)serverEnv
                        buildBranch:(nullable NSString *)buildBranch
                     engineRevision:(nullable NSString *)engineRevision {
  NEFLTNERtcVersion *pigeonResult = [[NEFLTNERtcVersion alloc] init];
  pigeonResult.versionName = versionName;
  pigeonResult.versionCode = versionCode;
  pigeonResult.buildType = buildType;
  pigeonResult.buildDate = buildDate;
  pigeonResult.buildRevision = buildRevision;
  pigeonResult.buildHost = buildHost;
  pigeonResult.serverEnv = serverEnv;
  pigeonResult.buildBranch = buildBranch;
  pigeonResult.engineRevision = engineRevision;
  return pigeonResult;
}
+ (NEFLTNERtcVersion *)fromList:(NSArray *)list {
  NEFLTNERtcVersion *pigeonResult = [[NEFLTNERtcVersion alloc] init];
  pigeonResult.versionName = GetNullableObjectAtIndex(list, 0);
  pigeonResult.versionCode = GetNullableObjectAtIndex(list, 1);
  pigeonResult.buildType = GetNullableObjectAtIndex(list, 2);
  pigeonResult.buildDate = GetNullableObjectAtIndex(list, 3);
  pigeonResult.buildRevision = GetNullableObjectAtIndex(list, 4);
  pigeonResult.buildHost = GetNullableObjectAtIndex(list, 5);
  pigeonResult.serverEnv = GetNullableObjectAtIndex(list, 6);
  pigeonResult.buildBranch = GetNullableObjectAtIndex(list, 7);
  pigeonResult.engineRevision = GetNullableObjectAtIndex(list, 8);
  return pigeonResult;
}
+ (nullable NEFLTNERtcVersion *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTNERtcVersion fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.versionName ?: [NSNull null]),
    (self.versionCode ?: [NSNull null]),
    (self.buildType ?: [NSNull null]),
    (self.buildDate ?: [NSNull null]),
    (self.buildRevision ?: [NSNull null]),
    (self.buildHost ?: [NSNull null]),
    (self.serverEnv ?: [NSNull null]),
    (self.buildBranch ?: [NSNull null]),
    (self.engineRevision ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTVideoFrame
+ (instancetype)makeWithWidth:(nullable NSNumber *)width
                       height:(nullable NSNumber *)height
                     rotation:(nullable NSNumber *)rotation
                       format:(nullable NSNumber *)format
                    timeStamp:(nullable NSNumber *)timeStamp
                         data:(nullable FlutterStandardTypedData *)data
                      strideY:(nullable NSNumber *)strideY
                      strideU:(nullable NSNumber *)strideU
                      strideV:(nullable NSNumber *)strideV
                    textureId:(nullable NSNumber *)textureId
              transformMatrix:(nullable NSArray<NSNumber *> *)transformMatrix {
  NEFLTVideoFrame *pigeonResult = [[NEFLTVideoFrame alloc] init];
  pigeonResult.width = width;
  pigeonResult.height = height;
  pigeonResult.rotation = rotation;
  pigeonResult.format = format;
  pigeonResult.timeStamp = timeStamp;
  pigeonResult.data = data;
  pigeonResult.strideY = strideY;
  pigeonResult.strideU = strideU;
  pigeonResult.strideV = strideV;
  pigeonResult.textureId = textureId;
  pigeonResult.transformMatrix = transformMatrix;
  return pigeonResult;
}
+ (NEFLTVideoFrame *)fromList:(NSArray *)list {
  NEFLTVideoFrame *pigeonResult = [[NEFLTVideoFrame alloc] init];
  pigeonResult.width = GetNullableObjectAtIndex(list, 0);
  pigeonResult.height = GetNullableObjectAtIndex(list, 1);
  pigeonResult.rotation = GetNullableObjectAtIndex(list, 2);
  pigeonResult.format = GetNullableObjectAtIndex(list, 3);
  pigeonResult.timeStamp = GetNullableObjectAtIndex(list, 4);
  pigeonResult.data = GetNullableObjectAtIndex(list, 5);
  pigeonResult.strideY = GetNullableObjectAtIndex(list, 6);
  pigeonResult.strideU = GetNullableObjectAtIndex(list, 7);
  pigeonResult.strideV = GetNullableObjectAtIndex(list, 8);
  pigeonResult.textureId = GetNullableObjectAtIndex(list, 9);
  pigeonResult.transformMatrix = GetNullableObjectAtIndex(list, 10);
  return pigeonResult;
}
+ (nullable NEFLTVideoFrame *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTVideoFrame fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.width ?: [NSNull null]),
    (self.height ?: [NSNull null]),
    (self.rotation ?: [NSNull null]),
    (self.format ?: [NSNull null]),
    (self.timeStamp ?: [NSNull null]),
    (self.data ?: [NSNull null]),
    (self.strideY ?: [NSNull null]),
    (self.strideU ?: [NSNull null]),
    (self.strideV ?: [NSNull null]),
    (self.textureId ?: [NSNull null]),
    (self.transformMatrix ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTDataExternalFrame
+ (instancetype)makeWithData:(nullable FlutterStandardTypedData *)data
                    dataSize:(nullable NSNumber *)dataSize {
  NEFLTDataExternalFrame *pigeonResult = [[NEFLTDataExternalFrame alloc] init];
  pigeonResult.data = data;
  pigeonResult.dataSize = dataSize;
  return pigeonResult;
}
+ (NEFLTDataExternalFrame *)fromList:(NSArray *)list {
  NEFLTDataExternalFrame *pigeonResult = [[NEFLTDataExternalFrame alloc] init];
  pigeonResult.data = GetNullableObjectAtIndex(list, 0);
  pigeonResult.dataSize = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable NEFLTDataExternalFrame *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTDataExternalFrame fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.data ?: [NSNull null]),
    (self.dataSize ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTAudioExternalFrame
+ (instancetype)makeWithData:(nullable FlutterStandardTypedData *)data
                  sampleRate:(nullable NSNumber *)sampleRate
            numberOfChannels:(nullable NSNumber *)numberOfChannels
           samplesPerChannel:(nullable NSNumber *)samplesPerChannel
               syncTimestamp:(nullable NSNumber *)syncTimestamp {
  NEFLTAudioExternalFrame *pigeonResult = [[NEFLTAudioExternalFrame alloc] init];
  pigeonResult.data = data;
  pigeonResult.sampleRate = sampleRate;
  pigeonResult.numberOfChannels = numberOfChannels;
  pigeonResult.samplesPerChannel = samplesPerChannel;
  pigeonResult.syncTimestamp = syncTimestamp;
  return pigeonResult;
}
+ (NEFLTAudioExternalFrame *)fromList:(NSArray *)list {
  NEFLTAudioExternalFrame *pigeonResult = [[NEFLTAudioExternalFrame alloc] init];
  pigeonResult.data = GetNullableObjectAtIndex(list, 0);
  pigeonResult.sampleRate = GetNullableObjectAtIndex(list, 1);
  pigeonResult.numberOfChannels = GetNullableObjectAtIndex(list, 2);
  pigeonResult.samplesPerChannel = GetNullableObjectAtIndex(list, 3);
  pigeonResult.syncTimestamp = GetNullableObjectAtIndex(list, 4);
  return pigeonResult;
}
+ (nullable NEFLTAudioExternalFrame *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTAudioExternalFrame fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.data ?: [NSNull null]),
    (self.sampleRate ?: [NSNull null]),
    (self.numberOfChannels ?: [NSNull null]),
    (self.samplesPerChannel ?: [NSNull null]),
    (self.syncTimestamp ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStreamingRoomInfo
+ (instancetype)makeWithUid:(nullable NSNumber *)uid
                channelName:(nullable NSString *)channelName
                      token:(nullable NSString *)token {
  NEFLTStreamingRoomInfo *pigeonResult = [[NEFLTStreamingRoomInfo alloc] init];
  pigeonResult.uid = uid;
  pigeonResult.channelName = channelName;
  pigeonResult.token = token;
  return pigeonResult;
}
+ (NEFLTStreamingRoomInfo *)fromList:(NSArray *)list {
  NEFLTStreamingRoomInfo *pigeonResult = [[NEFLTStreamingRoomInfo alloc] init];
  pigeonResult.uid = GetNullableObjectAtIndex(list, 0);
  pigeonResult.channelName = GetNullableObjectAtIndex(list, 1);
  pigeonResult.token = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable NEFLTStreamingRoomInfo *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStreamingRoomInfo fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.uid ?: [NSNull null]),
    (self.channelName ?: [NSNull null]),
    (self.token ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartPushStreamingRequest
+ (instancetype)makeWithStreamingUrl:(nullable NSString *)streamingUrl
                   streamingRoomInfo:(nullable NEFLTStreamingRoomInfo *)streamingRoomInfo {
  NEFLTStartPushStreamingRequest *pigeonResult = [[NEFLTStartPushStreamingRequest alloc] init];
  pigeonResult.streamingUrl = streamingUrl;
  pigeonResult.streamingRoomInfo = streamingRoomInfo;
  return pigeonResult;
}
+ (NEFLTStartPushStreamingRequest *)fromList:(NSArray *)list {
  NEFLTStartPushStreamingRequest *pigeonResult = [[NEFLTStartPushStreamingRequest alloc] init];
  pigeonResult.streamingUrl = GetNullableObjectAtIndex(list, 0);
  pigeonResult.streamingRoomInfo =
      [NEFLTStreamingRoomInfo nullableFromList:(GetNullableObjectAtIndex(list, 1))];
  return pigeonResult;
}
+ (nullable NEFLTStartPushStreamingRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartPushStreamingRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.streamingUrl ?: [NSNull null]),
    (self.streamingRoomInfo ? [self.streamingRoomInfo toList] : [NSNull null]),
  ];
}
@end

@implementation NEFLTStartPlayStreamingRequest
+ (instancetype)makeWithStreamId:(nullable NSString *)streamId
                    streamingUrl:(nullable NSString *)streamingUrl
                    playOutDelay:(nullable NSNumber *)playOutDelay
                reconnectTimeout:(nullable NSNumber *)reconnectTimeout
                       muteAudio:(nullable NSNumber *)muteAudio
                       muteVideo:(nullable NSNumber *)muteVideo
                 pausePullStream:(nullable NSNumber *)pausePullStream {
  NEFLTStartPlayStreamingRequest *pigeonResult = [[NEFLTStartPlayStreamingRequest alloc] init];
  pigeonResult.streamId = streamId;
  pigeonResult.streamingUrl = streamingUrl;
  pigeonResult.playOutDelay = playOutDelay;
  pigeonResult.reconnectTimeout = reconnectTimeout;
  pigeonResult.muteAudio = muteAudio;
  pigeonResult.muteVideo = muteVideo;
  pigeonResult.pausePullStream = pausePullStream;
  return pigeonResult;
}
+ (NEFLTStartPlayStreamingRequest *)fromList:(NSArray *)list {
  NEFLTStartPlayStreamingRequest *pigeonResult = [[NEFLTStartPlayStreamingRequest alloc] init];
  pigeonResult.streamId = GetNullableObjectAtIndex(list, 0);
  pigeonResult.streamingUrl = GetNullableObjectAtIndex(list, 1);
  pigeonResult.playOutDelay = GetNullableObjectAtIndex(list, 2);
  pigeonResult.reconnectTimeout = GetNullableObjectAtIndex(list, 3);
  pigeonResult.muteAudio = GetNullableObjectAtIndex(list, 4);
  pigeonResult.muteVideo = GetNullableObjectAtIndex(list, 5);
  pigeonResult.pausePullStream = GetNullableObjectAtIndex(list, 6);
  return pigeonResult;
}
+ (nullable NEFLTStartPlayStreamingRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartPlayStreamingRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.streamId ?: [NSNull null]),
    (self.streamingUrl ?: [NSNull null]),
    (self.playOutDelay ?: [NSNull null]),
    (self.reconnectTimeout ?: [NSNull null]),
    (self.muteAudio ?: [NSNull null]),
    (self.muteVideo ?: [NSNull null]),
    (self.pausePullStream ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTStartASRCaptionRequest
+ (instancetype)makeWithSrcLanguage:(nullable NSString *)srcLanguage
                     srcLanguageArr:(nullable NSArray<NSString *> *)srcLanguageArr
                     dstLanguageArr:(nullable NSArray<NSString *> *)dstLanguageArr
          needTranslateSameLanguage:(nullable NSNumber *)needTranslateSameLanguage {
  NEFLTStartASRCaptionRequest *pigeonResult = [[NEFLTStartASRCaptionRequest alloc] init];
  pigeonResult.srcLanguage = srcLanguage;
  pigeonResult.srcLanguageArr = srcLanguageArr;
  pigeonResult.dstLanguageArr = dstLanguageArr;
  pigeonResult.needTranslateSameLanguage = needTranslateSameLanguage;
  return pigeonResult;
}
+ (NEFLTStartASRCaptionRequest *)fromList:(NSArray *)list {
  NEFLTStartASRCaptionRequest *pigeonResult = [[NEFLTStartASRCaptionRequest alloc] init];
  pigeonResult.srcLanguage = GetNullableObjectAtIndex(list, 0);
  pigeonResult.srcLanguageArr = GetNullableObjectAtIndex(list, 1);
  pigeonResult.dstLanguageArr = GetNullableObjectAtIndex(list, 2);
  pigeonResult.needTranslateSameLanguage = GetNullableObjectAtIndex(list, 3);
  return pigeonResult;
}
+ (nullable NEFLTStartASRCaptionRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTStartASRCaptionRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.srcLanguage ?: [NSNull null]),
    (self.srcLanguageArr ?: [NSNull null]),
    (self.dstLanguageArr ?: [NSNull null]),
    (self.needTranslateSameLanguage ?: [NSNull null]),
  ];
}
@end

@implementation NEFLTSetMultiPathOptionRequest
+ (instancetype)makeWithEnableMediaMultiPath:(nullable NSNumber *)enableMediaMultiPath
                                   mediaMode:(nullable NSNumber *)mediaMode
                             badRttThreshold:(nullable NSNumber *)badRttThreshold
                              redAudioPacket:(nullable NSNumber *)redAudioPacket
                           redAudioRtxPacket:(nullable NSNumber *)redAudioRtxPacket
                              redVideoPacket:(nullable NSNumber *)redVideoPacket
                           redVideoRtxPacket:(nullable NSNumber *)redVideoRtxPacket {
  NEFLTSetMultiPathOptionRequest *pigeonResult = [[NEFLTSetMultiPathOptionRequest alloc] init];
  pigeonResult.enableMediaMultiPath = enableMediaMultiPath;
  pigeonResult.mediaMode = mediaMode;
  pigeonResult.badRttThreshold = badRttThreshold;
  pigeonResult.redAudioPacket = redAudioPacket;
  pigeonResult.redAudioRtxPacket = redAudioRtxPacket;
  pigeonResult.redVideoPacket = redVideoPacket;
  pigeonResult.redVideoRtxPacket = redVideoRtxPacket;
  return pigeonResult;
}
+ (NEFLTSetMultiPathOptionRequest *)fromList:(NSArray *)list {
  NEFLTSetMultiPathOptionRequest *pigeonResult = [[NEFLTSetMultiPathOptionRequest alloc] init];
  pigeonResult.enableMediaMultiPath = GetNullableObjectAtIndex(list, 0);
  pigeonResult.mediaMode = GetNullableObjectAtIndex(list, 1);
  pigeonResult.badRttThreshold = GetNullableObjectAtIndex(list, 2);
  pigeonResult.redAudioPacket = GetNullableObjectAtIndex(list, 3);
  pigeonResult.redAudioRtxPacket = GetNullableObjectAtIndex(list, 4);
  pigeonResult.redVideoPacket = GetNullableObjectAtIndex(list, 5);
  pigeonResult.redVideoRtxPacket = GetNullableObjectAtIndex(list, 6);
  return pigeonResult;
}
+ (nullable NEFLTSetMultiPathOptionRequest *)nullableFromList:(NSArray *)list {
  return (list) ? [NEFLTSetMultiPathOptionRequest fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.enableMediaMultiPath ?: [NSNull null]),
    (self.mediaMode ?: [NSNull null]),
    (self.badRttThreshold ?: [NSNull null]),
    (self.redAudioPacket ?: [NSNull null]),
    (self.redAudioRtxPacket ?: [NSNull null]),
    (self.redVideoPacket ?: [NSNull null]),
    (self.redVideoRtxPacket ?: [NSNull null]),
  ];
}
@end

@interface NEFLTNERtcSubChannelEventSinkCodecReader : FlutterStandardReader
@end
@implementation NEFLTNERtcSubChannelEventSinkCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:[self readValue]];
    case 129:
      return [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:[self readValue]];
    case 130:
      return [NEFLTAudioExternalFrame fromList:[self readValue]];
    case 131:
      return [NEFLTAudioRecordingConfigurationRequest fromList:[self readValue]];
    case 132:
      return [NEFLTAudioVolumeInfo fromList:[self readValue]];
    case 133:
      return [NEFLTCGPoint fromList:[self readValue]];
    case 134:
      return [NEFLTCreateEngineRequest fromList:[self readValue]];
    case 135:
      return [NEFLTDataExternalFrame fromList:[self readValue]];
    case 136:
      return [NEFLTDeleteLiveStreamTaskRequest fromList:[self readValue]];
    case 137:
      return [NEFLTEnableAudioVolumeIndicationRequest fromList:[self readValue]];
    case 138:
      return [NEFLTEnableEncryptionRequest fromList:[self readValue]];
    case 139:
      return [NEFLTEnableLocalVideoRequest fromList:[self readValue]];
    case 140:
      return [NEFLTEnableVirtualBackgroundRequest fromList:[self readValue]];
    case 141:
      return [NEFLTFirstVideoDataReceivedEvent fromList:[self readValue]];
    case 142:
      return [NEFLTFirstVideoFrameDecodedEvent fromList:[self readValue]];
    case 143:
      return [NEFLTJoinChannelOptions fromList:[self readValue]];
    case 144:
      return [NEFLTJoinChannelRequest fromList:[self readValue]];
    case 145:
      return [NEFLTLocalRecordingConfig fromList:[self readValue]];
    case 146:
      return [NEFLTLocalRecordingLayoutConfig fromList:[self readValue]];
    case 147:
      return [NEFLTLocalRecordingStreamInfo fromList:[self readValue]];
    case 148:
      return [NEFLTNERtcLastmileProbeOneWayResult fromList:[self readValue]];
    case 149:
      return [NEFLTNERtcLastmileProbeResult fromList:[self readValue]];
    case 150:
      return [NEFLTNERtcUserJoinExtraInfo fromList:[self readValue]];
    case 151:
      return [NEFLTNERtcUserLeaveExtraInfo fromList:[self readValue]];
    case 152:
      return [NEFLTNERtcVersion fromList:[self readValue]];
    case 153:
      return [NEFLTPlayEffectRequest fromList:[self readValue]];
    case 154:
      return [NEFLTPositionInfo fromList:[self readValue]];
    case 155:
      return [NEFLTRectangle fromList:[self readValue]];
    case 156:
      return [NEFLTRemoteAudioVolumeIndicationEvent fromList:[self readValue]];
    case 157:
      return [NEFLTReportCustomEventRequest fromList:[self readValue]];
    case 158:
      return [NEFLTRtcServerAddresses fromList:[self readValue]];
    case 159:
      return [NEFLTScreenCaptureSourceData fromList:[self readValue]];
    case 160:
      return [NEFLTSendSEIMsgRequest fromList:[self readValue]];
    case 161:
      return [NEFLTSetAudioProfileRequest fromList:[self readValue]];
    case 162:
      return [NEFLTSetAudioSubscribeOnlyByRequest fromList:[self readValue]];
    case 163:
      return [NEFLTSetCameraCaptureConfigRequest fromList:[self readValue]];
    case 164:
      return [NEFLTSetCameraPositionRequest fromList:[self readValue]];
    case 165:
      return [NEFLTSetLocalMediaPriorityRequest fromList:[self readValue]];
    case 166:
      return [NEFLTSetLocalVideoConfigRequest fromList:[self readValue]];
    case 167:
      return [NEFLTSetLocalVideoWatermarkConfigsRequest fromList:[self readValue]];
    case 168:
      return [NEFLTSetLocalVoiceEqualizationRequest fromList:[self readValue]];
    case 169:
      return [NEFLTSetLocalVoiceReverbParamRequest fromList:[self readValue]];
    case 170:
      return [NEFLTSetMultiPathOptionRequest fromList:[self readValue]];
    case 171:
      return [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:[self readValue]];
    case 172:
      return [NEFLTSetVideoCorrectionConfigRequest fromList:[self readValue]];
    case 173:
      return [NEFLTSpatializerRoomProperty fromList:[self readValue]];
    case 174:
      return [NEFLTStartASRCaptionRequest fromList:[self readValue]];
    case 175:
      return [NEFLTStartAudioMixingRequest fromList:[self readValue]];
    case 176:
      return [NEFLTStartAudioRecordingRequest fromList:[self readValue]];
    case 177:
      return [NEFLTStartLastmileProbeTestRequest fromList:[self readValue]];
    case 178:
      return [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:[self readValue]];
    case 179:
      return [NEFLTStartPlayStreamingRequest fromList:[self readValue]];
    case 180:
      return [NEFLTStartPushStreamingRequest fromList:[self readValue]];
    case 181:
      return [NEFLTStartScreenCaptureRequest fromList:[self readValue]];
    case 182:
      return [NEFLTStartorStopVideoPreviewRequest fromList:[self readValue]];
    case 183:
      return [NEFLTStreamingRoomInfo fromList:[self readValue]];
    case 184:
      return [NEFLTSubscribeRemoteAudioRequest fromList:[self readValue]];
    case 185:
      return [NEFLTSubscribeRemoteSubStreamAudioRequest fromList:[self readValue]];
    case 186:
      return [NEFLTSubscribeRemoteSubStreamVideoRequest fromList:[self readValue]];
    case 187:
      return [NEFLTSubscribeRemoteVideoStreamRequest fromList:[self readValue]];
    case 188:
      return [NEFLTSwitchChannelRequest fromList:[self readValue]];
    case 189:
      return [NEFLTUserJoinedEvent fromList:[self readValue]];
    case 190:
      return [NEFLTUserLeaveEvent fromList:[self readValue]];
    case 191:
      return [NEFLTUserVideoMuteEvent fromList:[self readValue]];
    case 192:
      return [NEFLTVideoFrame fromList:[self readValue]];
    case 193:
      return [NEFLTVideoWatermarkConfig fromList:[self readValue]];
    case 194:
      return [NEFLTVideoWatermarkImageConfig fromList:[self readValue]];
    case 195:
      return [NEFLTVideoWatermarkTextConfig fromList:[self readValue]];
    case 196:
      return [NEFLTVideoWatermarkTimestampConfig fromList:[self readValue]];
    case 197:
      return [NEFLTVirtualBackgroundSourceEnabledEvent fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTNERtcSubChannelEventSinkCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTNERtcSubChannelEventSinkCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTAddOrUpdateLiveStreamTaskRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAdjustUserPlaybackSignalVolumeRequest class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioExternalFrame class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioRecordingConfigurationRequest class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioVolumeInfo class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCGPoint class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCreateEngineRequest class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDataExternalFrame class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDeleteLiveStreamTaskRequest class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableAudioVolumeIndicationRequest class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableEncryptionRequest class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableLocalVideoRequest class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableVirtualBackgroundRequest class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoDataReceivedEvent class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoFrameDecodedEvent class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelOptions class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelRequest class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingConfig class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingLayoutConfig class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingStreamInfo class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeOneWayResult class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeResult class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserJoinExtraInfo class]]) {
    [self writeByte:150];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserLeaveExtraInfo class]]) {
    [self writeByte:151];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcVersion class]]) {
    [self writeByte:152];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPlayEffectRequest class]]) {
    [self writeByte:153];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPositionInfo class]]) {
    [self writeByte:154];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRectangle class]]) {
    [self writeByte:155];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRemoteAudioVolumeIndicationEvent class]]) {
    [self writeByte:156];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTReportCustomEventRequest class]]) {
    [self writeByte:157];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRtcServerAddresses class]]) {
    [self writeByte:158];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTScreenCaptureSourceData class]]) {
    [self writeByte:159];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSendSEIMsgRequest class]]) {
    [self writeByte:160];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioProfileRequest class]]) {
    [self writeByte:161];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioSubscribeOnlyByRequest class]]) {
    [self writeByte:162];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraCaptureConfigRequest class]]) {
    [self writeByte:163];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraPositionRequest class]]) {
    [self writeByte:164];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalMediaPriorityRequest class]]) {
    [self writeByte:165];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoConfigRequest class]]) {
    [self writeByte:166];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoWatermarkConfigsRequest class]]) {
    [self writeByte:167];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceEqualizationRequest class]]) {
    [self writeByte:168];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceReverbParamRequest class]]) {
    [self writeByte:169];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetMultiPathOptionRequest class]]) {
    [self writeByte:170];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetRemoteHighPriorityAudioStreamRequest class]]) {
    [self writeByte:171];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetVideoCorrectionConfigRequest class]]) {
    [self writeByte:172];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSpatializerRoomProperty class]]) {
    [self writeByte:173];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartASRCaptionRequest class]]) {
    [self writeByte:174];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioMixingRequest class]]) {
    [self writeByte:175];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioRecordingRequest class]]) {
    [self writeByte:176];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartLastmileProbeTestRequest class]]) {
    [self writeByte:177];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartOrUpdateChannelMediaRelayRequest class]]) {
    [self writeByte:178];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPlayStreamingRequest class]]) {
    [self writeByte:179];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPushStreamingRequest class]]) {
    [self writeByte:180];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartScreenCaptureRequest class]]) {
    [self writeByte:181];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartorStopVideoPreviewRequest class]]) {
    [self writeByte:182];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStreamingRoomInfo class]]) {
    [self writeByte:183];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteAudioRequest class]]) {
    [self writeByte:184];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamAudioRequest class]]) {
    [self writeByte:185];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamVideoRequest class]]) {
    [self writeByte:186];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteVideoStreamRequest class]]) {
    [self writeByte:187];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSwitchChannelRequest class]]) {
    [self writeByte:188];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserJoinedEvent class]]) {
    [self writeByte:189];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserLeaveEvent class]]) {
    [self writeByte:190];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserVideoMuteEvent class]]) {
    [self writeByte:191];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoFrame class]]) {
    [self writeByte:192];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkConfig class]]) {
    [self writeByte:193];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkImageConfig class]]) {
    [self writeByte:194];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTextConfig class]]) {
    [self writeByte:195];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTimestampConfig class]]) {
    [self writeByte:196];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVirtualBackgroundSourceEnabledEvent class]]) {
    [self writeByte:197];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTNERtcSubChannelEventSinkCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTNERtcSubChannelEventSinkCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTNERtcSubChannelEventSinkCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTNERtcSubChannelEventSinkCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTNERtcSubChannelEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTNERtcSubChannelEventSinkCodecReaderWriter *readerWriter =
        [[NEFLTNERtcSubChannelEventSinkCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

@interface NEFLTNERtcSubChannelEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcSubChannelEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onJoinChannelChannelTag:(NSString *)arg_channelTag
                         result:(NSNumber *)arg_result
                      channelId:(NSNumber *)arg_channelId
                        elapsed:(NSNumber *)arg_elapsed
                            uid:(NSNumber *)arg_uid
                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onJoinChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null], arg_channelId ?: [NSNull null],
    arg_elapsed ?: [NSNull null], arg_uid ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLeaveChannelChannelTag:(NSString *)arg_channelTag
                          result:(NSNumber *)arg_result
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLeaveChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserJoinedChannelTag:(NSString *)arg_channelTag
                         event:(NEFLTUserJoinedEvent *)arg_event
                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserJoined"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserLeaveChannelTag:(NSString *)arg_channelTag
                        event:(NEFLTUserLeaveEvent *)arg_event
                   completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onUserLeave"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioStartChannelTag:(NSString *)arg_channelTag
                               uid:(NSNumber *)arg_uid
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserAudioStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioStartChannelTag:(NSString *)arg_channelTag
                                        uid:(NSNumber *)arg_uid
                                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserSubStreamAudioStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioStopChannelTag:(NSString *)arg_channelTag
                              uid:(NSNumber *)arg_uid
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserAudioStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioStopChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserSubStreamAudioStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoStartChannelTag:(NSString *)arg_channelTag
                               uid:(NSNumber *)arg_uid
                        maxProfile:(NSNumber *)arg_maxProfile
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserVideoStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoStopChannelTag:(NSString *)arg_channelTag
                              uid:(NSNumber *)arg_uid
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserVideoStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onDisconnectChannelTag:(NSString *)arg_channelTag
                        reason:(NSNumber *)arg_reason
                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onDisconnect"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioMuteChannelTag:(NSString *)arg_channelTag
                              uid:(NSNumber *)arg_uid
                            muted:(NSNumber *)arg_muted
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserAudioMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_muted ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoMuteChannelTag:(NSString *)arg_channelTag
                            event:(NEFLTUserVideoMuteEvent *)arg_event
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserVideoMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioMuteChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                     muted:(NSNumber *)arg_muted
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserSubStreamAudioMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_muted ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstAudioDataReceivedChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onFirstAudioDataReceived"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoDataReceivedChannelTag:(NSString *)arg_channelTag
                                     event:(NEFLTFirstVideoDataReceivedEvent *)arg_event
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onFirstVideoDataReceived"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstAudioFrameDecodedChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onFirstAudioFrameDecoded"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoFrameDecodedChannelTag:(NSString *)arg_channelTag
                                     event:(NEFLTFirstVideoFrameDecodedEvent *)arg_event
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onFirstVideoFrameDecoded"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)
    onVirtualBackgroundSourceEnabledChannelTag:(NSString *)arg_channelTag
                                         event:(NEFLTVirtualBackgroundSourceEnabledEvent *)arg_event
                                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onVirtualBackgroundSourceEnabled"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onConnectionTypeChangedChannelTag:(NSString *)arg_channelTag
                        newConnectionType:(NSNumber *)arg_newConnectionType
                               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onConnectionTypeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_newConnectionType ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReconnectingStartChannelTag:(NSString *)arg_channelTag
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onReconnectingStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReJoinChannelChannelTag:(NSString *)arg_channelTag
                           result:(NSNumber *)arg_result
                        channelId:(NSNumber *)arg_channelId
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onReJoinChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null], arg_channelId ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onConnectionStateChangedChannelTag:(NSString *)arg_channelTag
                                     state:(NSNumber *)arg_state
                                    reason:(NSNumber *)arg_reason
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onConnectionStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_state ?: [NSNull null], arg_reason ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalAudioVolumeIndicationChannelTag:(NSString *)arg_channelTag
                                        volume:(NSNumber *)arg_volume
                                       vadFlag:(NSNumber *)arg_vadFlag
                                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalAudioVolumeIndication"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_volume ?: [NSNull null], arg_vadFlag ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteAudioVolumeIndicationChannelTag:(NSString *)arg_channelTag
                                          event:(NEFLTRemoteAudioVolumeIndicationEvent *)arg_event
                                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onRemoteAudioVolumeIndication"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLiveStreamStateChannelTag:(NSString *)arg_channelTag
                             taskId:(NSString *)arg_taskId
                            pushUrl:(NSString *)arg_pushUrl
                          liveState:(NSNumber *)arg_liveState
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLiveStreamState"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_taskId ?: [NSNull null], arg_pushUrl ?: [NSNull null],
    arg_liveState ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onClientRoleChangeChannelTag:(NSString *)arg_channelTag
                             oldRole:(NSNumber *)arg_oldRole
                             newRole:(NSNumber *)arg_newRole
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onClientRoleChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_oldRole ?: [NSNull null], arg_newRole ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onErrorChannelTag:(NSString *)arg_channelTag
                     code:(NSNumber *)arg_code
               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onError"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_code ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onWarningChannelTag:(NSString *)arg_channelTag
                       code:(NSNumber *)arg_code
                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onWarning"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_code ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamVideoStartChannelTag:(NSString *)arg_channelTag
                                        uid:(NSNumber *)arg_uid
                                 maxProfile:(NSNumber *)arg_maxProfile
                                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserSubStreamVideoStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamVideoStopChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserSubStreamVideoStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioHasHowlingChannelTag:(NSString *)arg_channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAudioHasHowling"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRecvSEIMsgChannelTag:(NSString *)arg_channelTag
                        userID:(NSNumber *)arg_userID
                        seiMsg:(NSString *)arg_seiMsg
                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onRecvSEIMsg"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_userID ?: [NSNull null], arg_seiMsg ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioRecordingChannelTag:(NSString *)arg_channelTag
                              code:(NSNumber *)arg_code
                          filePath:(NSString *)arg_filePath
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAudioRecording"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_code ?: [NSNull null], arg_filePath ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRightChangeChannelTag:(NSString *)arg_channelTag
               isAudioBannedByServer:(NSNumber *)arg_isAudioBannedByServer
               isVideoBannedByServer:(NSNumber *)arg_isVideoBannedByServer
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onMediaRightChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_isAudioBannedByServer ?: [NSNull null],
    arg_isVideoBannedByServer ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRelayStatesChangeChannelTag:(NSString *)arg_channelTag
                                     state:(NSNumber *)arg_state
                               channelName:(NSString *)arg_channelName
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onMediaRelayStatesChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_state ?: [NSNull null], arg_channelName ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRelayReceiveEventChannelTag:(NSString *)arg_channelTag
                                     event:(NSNumber *)arg_event
                                      code:(NSNumber *)arg_code
                               channelName:(NSString *)arg_channelName
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onMediaRelayReceiveEvent"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_event ?: [NSNull null], arg_code ?: [NSNull null],
    arg_channelName ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalPublishFallbackToAudioOnlyChannelTag:(NSString *)arg_channelTag
                                         isFallback:(NSNumber *)arg_isFallback
                                         streamType:(NSNumber *)arg_streamType
                                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalPublishFallbackToAudioOnly"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_isFallback ?: [NSNull null],
    arg_streamType ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteSubscribeFallbackToAudioOnlyChannelTag:(NSString *)arg_channelTag
                                                   uid:(NSNumber *)arg_uid
                                            isFallback:(NSNumber *)arg_isFallback
                                            streamType:(NSNumber *)arg_streamType
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onRemoteSubscribeFallbackToAudioOnly"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_isFallback ?: [NSNull null],
    arg_streamType ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalVideoWatermarkStateChannelTag:(NSString *)arg_channelTag
                             videoStreamType:(NSNumber *)arg_videoStreamType
                                       state:(NSNumber *)arg_state
                                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalVideoWatermarkState"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_videoStreamType ?: [NSNull null],
    arg_state ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLastmileQualityChannelTag:(NSString *)arg_channelTag
                            quality:(NSNumber *)arg_quality
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLastmileQuality"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_quality ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLastmileProbeResultChannelTag:(NSString *)arg_channelTag
                                 result:(NEFLTNERtcLastmileProbeResult *)arg_result
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLastmileProbeResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onTakeSnapshotResultChannelTag:(NSString *)arg_channelTag
                                  code:(NSNumber *)arg_code
                                  path:(NSString *)arg_path
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onTakeSnapshotResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_code ?: [NSNull null], arg_path ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPermissionKeyWillExpireChannelTag:(NSString *)arg_channelTag
                                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPermissionKeyWillExpire"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUpdatePermissionKeyChannelTag:(NSString *)arg_channelTag
                                    key:(NSString *)arg_key
                                  error:(NSNumber *)arg_error
                                timeout:(NSNumber *)arg_timeout
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUpdatePermissionKey"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_key ?: [NSNull null], arg_error ?: [NSNull null],
    arg_timeout ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAsrCaptionStateChangedChannelTag:(NSString *)arg_channelTag
                                  asrState:(NSNumber *)arg_asrState
                                      code:(NSNumber *)arg_code
                                   message:(NSString *)arg_message
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAsrCaptionStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_asrState ?: [NSNull null], arg_code ?: [NSNull null],
    arg_message ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAsrCaptionResultChannelTag:(NSString *)arg_channelTag
                              result:(NSArray<NSDictionary<id, id> *> *)arg_result
                         resultCount:(NSNumber *)arg_resultCount
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAsrCaptionResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null], arg_resultCount ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingStateChangeChannelTag:(NSString *)arg_channelTag
                                    streamId:(NSString *)arg_streamId
                                       state:(NSNumber *)arg_state
                                      reason:(NSNumber *)arg_reason
                                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPlayStreamingStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_streamId ?: [NSNull null], arg_state ?: [NSNull null],
    arg_reason ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingReceiveSeiMessageChannelTag:(NSString *)arg_channelTag
                                          streamId:(NSString *)arg_streamId
                                           message:(NSString *)arg_message
                                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPlayStreamingReceiveSeiMessage"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_streamId ?: [NSNull null], arg_message ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingFirstAudioFramePlayedChannelTag:(NSString *)arg_channelTag
                                              streamId:(NSString *)arg_streamId
                                                timeMs:(NSNumber *)arg_timeMs
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPlayStreamingFirstAudioFramePlayed"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_streamId ?: [NSNull null], arg_timeMs ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingFirstVideoFrameRenderChannelTag:(NSString *)arg_channelTag
                                              streamId:(NSString *)arg_streamId
                                                timeMs:(NSNumber *)arg_timeMs
                                                 width:(NSNumber *)arg_width
                                                height:(NSNumber *)arg_height
                                            completion:
                                                (void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPlayStreamingFirstVideoFrameRender"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_streamId ?: [NSNull null], arg_timeMs ?: [NSNull null],
    arg_width ?: [NSNull null], arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalAudioFirstPacketSentChannelTag:(NSString *)arg_channelTag
                              audioStreamType:(NSNumber *)arg_audioStreamType
                                   completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalAudioFirstPacketSent"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_audioStreamType ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoFrameRenderChannelTag:(NSString *)arg_channelTag
                                   userID:(NSNumber *)arg_userID
                               streamType:(NSNumber *)arg_streamType
                                    width:(NSNumber *)arg_width
                                   height:(NSNumber *)arg_height
                              elapsedTime:(NSNumber *)arg_elapsedTime
                               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onFirstVideoFrameRender"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_userID ?: [NSNull null], arg_streamType ?: [NSNull null],
    arg_width ?: [NSNull null], arg_height ?: [NSNull null], arg_elapsedTime ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalVideoRenderSizeChangedChannelTag:(NSString *)arg_channelTag
                                      videoType:(NSNumber *)arg_videoType
                                          width:(NSNumber *)arg_width
                                         height:(NSNumber *)arg_height
                                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalVideoRenderSizeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_videoType ?: [NSNull null], arg_width ?: [NSNull null],
    arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoProfileUpdateChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                maxProfile:(NSNumber *)arg_maxProfile
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserVideoProfileUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioDeviceChangedChannelTag:(NSString *)arg_channelTag
                              selected:(NSNumber *)arg_selected
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAudioDeviceChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_selected ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioDeviceStateChangeChannelTag:(NSString *)arg_channelTag
                                deviceType:(NSNumber *)arg_deviceType
                               deviceState:(NSNumber *)arg_deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onAudioDeviceStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_deviceType ?: [NSNull null],
    arg_deviceState ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onApiCallExecutedChannelTag:(NSString *)arg_channelTag
                            apiName:(NSString *)arg_apiName
                             result:(NSNumber *)arg_result
                            message:(NSString *)arg_message
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onApiCallExecuted"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_apiName ?: [NSNull null], arg_result ?: [NSNull null],
    arg_message ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteVideoSizeChangedChannelTag:(NSString *)arg_channelTag
                                    userId:(NSNumber *)arg_userId
                                 videoType:(NSNumber *)arg_videoType
                                     width:(NSNumber *)arg_width
                                    height:(NSNumber *)arg_height
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onRemoteVideoSizeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_userId ?: [NSNull null], arg_videoType ?: [NSNull null],
    arg_width ?: [NSNull null], arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStartChannelTag:(NSString *)arg_channelTag
                              uid:(NSNumber *)arg_uid
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserDataStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStopChannelTag:(NSString *)arg_channelTag
                             uid:(NSNumber *)arg_uid
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserDataStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataReceiveMessageChannelTag:(NSString *)arg_channelTag
                                       uid:(NSNumber *)arg_uid
                                bufferData:(FlutterStandardTypedData *)arg_bufferData
                                bufferSize:(NSNumber *)arg_bufferSize
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserDataReceiveMessage"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_bufferData ?: [NSNull null],
    arg_bufferSize ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStateChangedChannelTag:(NSString *)arg_channelTag
                                     uid:(NSNumber *)arg_uid
                              completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserDataStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataBufferedAmountChangedChannelTag:(NSString *)arg_channelTag
                                              uid:(NSNumber *)arg_uid
                                   previousAmount:(NSNumber *)arg_previousAmount
                                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onUserDataBufferedAmountChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_uid ?: [NSNull null], arg_previousAmount ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLabFeatureCallbackChannelTag:(NSString *)arg_channelTag
                                   key:(NSString *)arg_key
                                 param:(NSDictionary<id, id> *)arg_param
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLabFeatureCallback"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_key ?: [NSNull null], arg_param ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAiDataChannelTag:(NSString *)arg_channelTag
                      type:(NSString *)arg_type
                      data:(NSString *)arg_data
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcSubChannelEventSink.onAiData"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_type ?: [NSNull null], arg_data ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onStartPushStreamingChannelTag:(NSString *)arg_channelTag
                                result:(NSNumber *)arg_result
                             channelId:(NSNumber *)arg_channelId
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onStartPushStreaming"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null], arg_channelId ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onStopPushStreamingChannelTag:(NSString *)arg_channelTag
                               result:(NSNumber *)arg_result
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onStopPushStreaming"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPushStreamingReconnectingChannelTag:(NSString *)arg_channelTag
                                       reason:(NSNumber *)arg_reason
                                   completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPushStreamingReconnecting"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPushStreamingReconnectedSuccessChannelTag:(NSString *)arg_channelTag
                                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onPushStreamingReconnectedSuccess"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReleasedHwResourcesChannelTag:(NSString *)arg_channelTag
                                 result:(NSNumber *)arg_result
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onReleasedHwResources"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onScreenCaptureStatusChannelTag:(NSString *)arg_channelTag
                                 status:(NSNumber *)arg_status
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onScreenCaptureStatus"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_status ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onScreenCaptureSourceDataUpdateChannelTag:(NSString *)arg_channelTag
                                             data:(NEFLTScreenCaptureSourceData *)arg_data
                                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onScreenCaptureSourceDataUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_data ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalRecorderStatusChannelTag:(NSString *)arg_channelTag
                                 status:(NSNumber *)arg_status
                                 taskId:(NSString *)arg_taskId
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalRecorderStatus"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_status ?: [NSNull null], arg_taskId ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalRecorderErrorChannelTag:(NSString *)arg_channelTag
                                 error:(NSNumber *)arg_error
                                taskId:(NSString *)arg_taskId
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onLocalRecorderError"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_channelTag ?: [NSNull null], arg_error ?: [NSNull null], arg_taskId ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onCheckNECastAudioDriverResultChannelTag:(NSString *)arg_channelTag
                                          result:(NSNumber *)arg_result
                                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcSubChannelEventSink.onCheckNECastAudioDriverResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcSubChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_channelTag ?: [NSNull null], arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

@interface NEFLTNERtcChannelEventSinkCodecReader : FlutterStandardReader
@end
@implementation NEFLTNERtcChannelEventSinkCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:[self readValue]];
    case 129:
      return [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:[self readValue]];
    case 130:
      return [NEFLTAudioExternalFrame fromList:[self readValue]];
    case 131:
      return [NEFLTAudioRecordingConfigurationRequest fromList:[self readValue]];
    case 132:
      return [NEFLTAudioVolumeInfo fromList:[self readValue]];
    case 133:
      return [NEFLTCGPoint fromList:[self readValue]];
    case 134:
      return [NEFLTCreateEngineRequest fromList:[self readValue]];
    case 135:
      return [NEFLTDataExternalFrame fromList:[self readValue]];
    case 136:
      return [NEFLTDeleteLiveStreamTaskRequest fromList:[self readValue]];
    case 137:
      return [NEFLTEnableAudioVolumeIndicationRequest fromList:[self readValue]];
    case 138:
      return [NEFLTEnableEncryptionRequest fromList:[self readValue]];
    case 139:
      return [NEFLTEnableLocalVideoRequest fromList:[self readValue]];
    case 140:
      return [NEFLTEnableVirtualBackgroundRequest fromList:[self readValue]];
    case 141:
      return [NEFLTFirstVideoDataReceivedEvent fromList:[self readValue]];
    case 142:
      return [NEFLTFirstVideoFrameDecodedEvent fromList:[self readValue]];
    case 143:
      return [NEFLTJoinChannelOptions fromList:[self readValue]];
    case 144:
      return [NEFLTJoinChannelRequest fromList:[self readValue]];
    case 145:
      return [NEFLTLocalRecordingConfig fromList:[self readValue]];
    case 146:
      return [NEFLTLocalRecordingLayoutConfig fromList:[self readValue]];
    case 147:
      return [NEFLTLocalRecordingStreamInfo fromList:[self readValue]];
    case 148:
      return [NEFLTNERtcLastmileProbeOneWayResult fromList:[self readValue]];
    case 149:
      return [NEFLTNERtcLastmileProbeResult fromList:[self readValue]];
    case 150:
      return [NEFLTNERtcUserJoinExtraInfo fromList:[self readValue]];
    case 151:
      return [NEFLTNERtcUserLeaveExtraInfo fromList:[self readValue]];
    case 152:
      return [NEFLTNERtcVersion fromList:[self readValue]];
    case 153:
      return [NEFLTPlayEffectRequest fromList:[self readValue]];
    case 154:
      return [NEFLTPositionInfo fromList:[self readValue]];
    case 155:
      return [NEFLTRectangle fromList:[self readValue]];
    case 156:
      return [NEFLTRemoteAudioVolumeIndicationEvent fromList:[self readValue]];
    case 157:
      return [NEFLTReportCustomEventRequest fromList:[self readValue]];
    case 158:
      return [NEFLTRtcServerAddresses fromList:[self readValue]];
    case 159:
      return [NEFLTScreenCaptureSourceData fromList:[self readValue]];
    case 160:
      return [NEFLTSendSEIMsgRequest fromList:[self readValue]];
    case 161:
      return [NEFLTSetAudioProfileRequest fromList:[self readValue]];
    case 162:
      return [NEFLTSetAudioSubscribeOnlyByRequest fromList:[self readValue]];
    case 163:
      return [NEFLTSetCameraCaptureConfigRequest fromList:[self readValue]];
    case 164:
      return [NEFLTSetCameraPositionRequest fromList:[self readValue]];
    case 165:
      return [NEFLTSetLocalMediaPriorityRequest fromList:[self readValue]];
    case 166:
      return [NEFLTSetLocalVideoConfigRequest fromList:[self readValue]];
    case 167:
      return [NEFLTSetLocalVideoWatermarkConfigsRequest fromList:[self readValue]];
    case 168:
      return [NEFLTSetLocalVoiceEqualizationRequest fromList:[self readValue]];
    case 169:
      return [NEFLTSetLocalVoiceReverbParamRequest fromList:[self readValue]];
    case 170:
      return [NEFLTSetMultiPathOptionRequest fromList:[self readValue]];
    case 171:
      return [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:[self readValue]];
    case 172:
      return [NEFLTSetVideoCorrectionConfigRequest fromList:[self readValue]];
    case 173:
      return [NEFLTSpatializerRoomProperty fromList:[self readValue]];
    case 174:
      return [NEFLTStartASRCaptionRequest fromList:[self readValue]];
    case 175:
      return [NEFLTStartAudioMixingRequest fromList:[self readValue]];
    case 176:
      return [NEFLTStartAudioRecordingRequest fromList:[self readValue]];
    case 177:
      return [NEFLTStartLastmileProbeTestRequest fromList:[self readValue]];
    case 178:
      return [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:[self readValue]];
    case 179:
      return [NEFLTStartPlayStreamingRequest fromList:[self readValue]];
    case 180:
      return [NEFLTStartPushStreamingRequest fromList:[self readValue]];
    case 181:
      return [NEFLTStartScreenCaptureRequest fromList:[self readValue]];
    case 182:
      return [NEFLTStartorStopVideoPreviewRequest fromList:[self readValue]];
    case 183:
      return [NEFLTStreamingRoomInfo fromList:[self readValue]];
    case 184:
      return [NEFLTSubscribeRemoteAudioRequest fromList:[self readValue]];
    case 185:
      return [NEFLTSubscribeRemoteSubStreamAudioRequest fromList:[self readValue]];
    case 186:
      return [NEFLTSubscribeRemoteSubStreamVideoRequest fromList:[self readValue]];
    case 187:
      return [NEFLTSubscribeRemoteVideoStreamRequest fromList:[self readValue]];
    case 188:
      return [NEFLTSwitchChannelRequest fromList:[self readValue]];
    case 189:
      return [NEFLTUserJoinedEvent fromList:[self readValue]];
    case 190:
      return [NEFLTUserLeaveEvent fromList:[self readValue]];
    case 191:
      return [NEFLTUserVideoMuteEvent fromList:[self readValue]];
    case 192:
      return [NEFLTVideoFrame fromList:[self readValue]];
    case 193:
      return [NEFLTVideoWatermarkConfig fromList:[self readValue]];
    case 194:
      return [NEFLTVideoWatermarkImageConfig fromList:[self readValue]];
    case 195:
      return [NEFLTVideoWatermarkTextConfig fromList:[self readValue]];
    case 196:
      return [NEFLTVideoWatermarkTimestampConfig fromList:[self readValue]];
    case 197:
      return [NEFLTVirtualBackgroundSourceEnabledEvent fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTNERtcChannelEventSinkCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTNERtcChannelEventSinkCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTAddOrUpdateLiveStreamTaskRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAdjustUserPlaybackSignalVolumeRequest class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioExternalFrame class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioRecordingConfigurationRequest class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioVolumeInfo class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCGPoint class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCreateEngineRequest class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDataExternalFrame class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDeleteLiveStreamTaskRequest class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableAudioVolumeIndicationRequest class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableEncryptionRequest class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableLocalVideoRequest class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableVirtualBackgroundRequest class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoDataReceivedEvent class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoFrameDecodedEvent class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelOptions class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelRequest class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingConfig class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingLayoutConfig class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingStreamInfo class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeOneWayResult class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeResult class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserJoinExtraInfo class]]) {
    [self writeByte:150];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserLeaveExtraInfo class]]) {
    [self writeByte:151];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcVersion class]]) {
    [self writeByte:152];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPlayEffectRequest class]]) {
    [self writeByte:153];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPositionInfo class]]) {
    [self writeByte:154];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRectangle class]]) {
    [self writeByte:155];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRemoteAudioVolumeIndicationEvent class]]) {
    [self writeByte:156];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTReportCustomEventRequest class]]) {
    [self writeByte:157];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRtcServerAddresses class]]) {
    [self writeByte:158];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTScreenCaptureSourceData class]]) {
    [self writeByte:159];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSendSEIMsgRequest class]]) {
    [self writeByte:160];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioProfileRequest class]]) {
    [self writeByte:161];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioSubscribeOnlyByRequest class]]) {
    [self writeByte:162];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraCaptureConfigRequest class]]) {
    [self writeByte:163];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraPositionRequest class]]) {
    [self writeByte:164];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalMediaPriorityRequest class]]) {
    [self writeByte:165];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoConfigRequest class]]) {
    [self writeByte:166];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoWatermarkConfigsRequest class]]) {
    [self writeByte:167];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceEqualizationRequest class]]) {
    [self writeByte:168];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceReverbParamRequest class]]) {
    [self writeByte:169];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetMultiPathOptionRequest class]]) {
    [self writeByte:170];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetRemoteHighPriorityAudioStreamRequest class]]) {
    [self writeByte:171];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetVideoCorrectionConfigRequest class]]) {
    [self writeByte:172];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSpatializerRoomProperty class]]) {
    [self writeByte:173];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartASRCaptionRequest class]]) {
    [self writeByte:174];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioMixingRequest class]]) {
    [self writeByte:175];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioRecordingRequest class]]) {
    [self writeByte:176];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartLastmileProbeTestRequest class]]) {
    [self writeByte:177];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartOrUpdateChannelMediaRelayRequest class]]) {
    [self writeByte:178];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPlayStreamingRequest class]]) {
    [self writeByte:179];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPushStreamingRequest class]]) {
    [self writeByte:180];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartScreenCaptureRequest class]]) {
    [self writeByte:181];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartorStopVideoPreviewRequest class]]) {
    [self writeByte:182];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStreamingRoomInfo class]]) {
    [self writeByte:183];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteAudioRequest class]]) {
    [self writeByte:184];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamAudioRequest class]]) {
    [self writeByte:185];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamVideoRequest class]]) {
    [self writeByte:186];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteVideoStreamRequest class]]) {
    [self writeByte:187];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSwitchChannelRequest class]]) {
    [self writeByte:188];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserJoinedEvent class]]) {
    [self writeByte:189];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserLeaveEvent class]]) {
    [self writeByte:190];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserVideoMuteEvent class]]) {
    [self writeByte:191];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoFrame class]]) {
    [self writeByte:192];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkConfig class]]) {
    [self writeByte:193];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkImageConfig class]]) {
    [self writeByte:194];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTextConfig class]]) {
    [self writeByte:195];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTimestampConfig class]]) {
    [self writeByte:196];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVirtualBackgroundSourceEnabledEvent class]]) {
    [self writeByte:197];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTNERtcChannelEventSinkCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTNERtcChannelEventSinkCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTNERtcChannelEventSinkCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTNERtcChannelEventSinkCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTNERtcChannelEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTNERtcChannelEventSinkCodecReaderWriter *readerWriter =
        [[NEFLTNERtcChannelEventSinkCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

@interface NEFLTNERtcChannelEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcChannelEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onJoinChannelResult:(NSNumber *)arg_result
                  channelId:(NSNumber *)arg_channelId
                    elapsed:(NSNumber *)arg_elapsed
                        uid:(NSNumber *)arg_uid
                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onJoinChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_result ?: [NSNull null], arg_channelId ?: [NSNull null], arg_elapsed ?: [NSNull null],
    arg_uid ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLeaveChannelResult:(NSNumber *)arg_result
                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onLeaveChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserJoinedEvent:(NEFLTUserJoinedEvent *)arg_event
               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserJoined"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserLeaveEvent:(NEFLTUserLeaveEvent *)arg_event
              completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserLeave"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioStartUid:(NSNumber *)arg_uid
                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioStartUid:(NSNumber *)arg_uid
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserSubStreamAudioStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioStopUid:(NSNumber *)arg_uid
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioStopUid:(NSNumber *)arg_uid
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserSubStreamAudioStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoStartUid:(NSNumber *)arg_uid
                 maxProfile:(NSNumber *)arg_maxProfile
                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoStopUid:(NSNumber *)arg_uid
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onDisconnectReason:(NSNumber *)arg_reason
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onDisconnect"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserAudioMuteUid:(NSNumber *)arg_uid
                     muted:(NSNumber *)arg_muted
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserAudioMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_muted ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoMuteEvent:(NEFLTUserVideoMuteEvent *)arg_event
                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserVideoMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamAudioMuteUid:(NSNumber *)arg_uid
                              muted:(NSNumber *)arg_muted
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserSubStreamAudioMute"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_muted ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstAudioDataReceivedUid:(NSNumber *)arg_uid
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onFirstAudioDataReceived"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoDataReceivedEvent:(NEFLTFirstVideoDataReceivedEvent *)arg_event
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onFirstVideoDataReceived"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstAudioFrameDecodedUid:(NSNumber *)arg_uid
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onFirstAudioFrameDecoded"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoFrameDecodedEvent:(NEFLTFirstVideoFrameDecodedEvent *)arg_event
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onFirstVideoFrameDecoded"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onVirtualBackgroundSourceEnabledEvent:(NEFLTVirtualBackgroundSourceEnabledEvent *)arg_event
                                   completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onVirtualBackgroundSourceEnabled"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onConnectionTypeChangedNewConnectionType:(NSNumber *)arg_newConnectionType
                                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onConnectionTypeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_newConnectionType ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReconnectingStartWithCompletion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onReconnectingStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:nil
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReJoinChannelResult:(NSNumber *)arg_result
                    channelId:(NSNumber *)arg_channelId
                   completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onReJoinChannel"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null], arg_channelId ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onConnectionStateChangedState:(NSNumber *)arg_state
                               reason:(NSNumber *)arg_reason
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onConnectionStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_state ?: [NSNull null], arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalAudioVolumeIndicationVolume:(NSNumber *)arg_volume
                                   vadFlag:(NSNumber *)arg_vadFlag
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalAudioVolumeIndication"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_volume ?: [NSNull null], arg_vadFlag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteAudioVolumeIndicationEvent:(NEFLTRemoteAudioVolumeIndicationEvent *)arg_event
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onRemoteAudioVolumeIndication"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_event ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLiveStreamStateTaskId:(NSString *)arg_taskId
                        pushUrl:(NSString *)arg_pushUrl
                      liveState:(NSNumber *)arg_liveState
                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLiveStreamState"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_taskId ?: [NSNull null], arg_pushUrl ?: [NSNull null], arg_liveState ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onClientRoleChangeOldRole:(NSNumber *)arg_oldRole
                          newRole:(NSNumber *)arg_newRole
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onClientRoleChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_oldRole ?: [NSNull null], arg_newRole ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onErrorCode:(NSNumber *)arg_code completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onError"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_code ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onWarningCode:(NSNumber *)arg_code
           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onWarning"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_code ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamVideoStartUid:(NSNumber *)arg_uid
                          maxProfile:(NSNumber *)arg_maxProfile
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserSubStreamVideoStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserSubStreamVideoStopUid:(NSNumber *)arg_uid
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserSubStreamVideoStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioHasHowlingWithCompletion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onAudioHasHowling"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:nil
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRecvSEIMsgUserID:(NSNumber *)arg_userID
                    seiMsg:(NSString *)arg_seiMsg
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onRecvSEIMsg"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_userID ?: [NSNull null], arg_seiMsg ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioRecordingCode:(NSNumber *)arg_code
                    filePath:(NSString *)arg_filePath
                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAudioRecording"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_code ?: [NSNull null], arg_filePath ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRightChangeIsAudioBannedByServer:(NSNumber *)arg_isAudioBannedByServer
                          isVideoBannedByServer:(NSNumber *)arg_isVideoBannedByServer
                                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onMediaRightChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_isAudioBannedByServer ?: [NSNull null], arg_isVideoBannedByServer ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRelayStatesChangeState:(NSNumber *)arg_state
                          channelName:(NSString *)arg_channelName
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onMediaRelayStatesChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_state ?: [NSNull null], arg_channelName ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onMediaRelayReceiveEventEvent:(NSNumber *)arg_event
                                 code:(NSNumber *)arg_code
                          channelName:(NSString *)arg_channelName
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onMediaRelayReceiveEvent"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_event ?: [NSNull null], arg_code ?: [NSNull null], arg_channelName ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalPublishFallbackToAudioOnlyIsFallback:(NSNumber *)arg_isFallback
                                         streamType:(NSNumber *)arg_streamType
                                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalPublishFallbackToAudioOnly"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_isFallback ?: [NSNull null], arg_streamType ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteSubscribeFallbackToAudioOnlyUid:(NSNumber *)arg_uid
                                     isFallback:(NSNumber *)arg_isFallback
                                     streamType:(NSNumber *)arg_streamType
                                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onRemoteSubscribeFallbackToAudioOnly"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_uid ?: [NSNull null], arg_isFallback ?: [NSNull null], arg_streamType ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalVideoWatermarkStateVideoStreamType:(NSNumber *)arg_videoStreamType
                                            state:(NSNumber *)arg_state
                                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalVideoWatermarkState"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_videoStreamType ?: [NSNull null], arg_state ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLastmileQualityQuality:(NSNumber *)arg_quality
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLastmileQuality"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_quality ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLastmileProbeResultResult:(NEFLTNERtcLastmileProbeResult *)arg_result
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLastmileProbeResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onTakeSnapshotResultCode:(NSNumber *)arg_code
                            path:(NSString *)arg_path
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onTakeSnapshotResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_code ?: [NSNull null], arg_path ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPermissionKeyWillExpireWithCompletion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPermissionKeyWillExpire"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:nil
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUpdatePermissionKeyKey:(NSString *)arg_key
                           error:(NSNumber *)arg_error
                         timeout:(NSNumber *)arg_timeout
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUpdatePermissionKey"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_key ?: [NSNull null], arg_error ?: [NSNull null], arg_timeout ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAsrCaptionStateChangedAsrState:(NSNumber *)arg_asrState
                                    code:(NSNumber *)arg_code
                                 message:(NSString *)arg_message
                              completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onAsrCaptionStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_asrState ?: [NSNull null], arg_code ?: [NSNull null], arg_message ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAsrCaptionResultResult:(NSArray<NSDictionary<id, id> *> *)arg_result
                     resultCount:(NSNumber *)arg_resultCount
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onAsrCaptionResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null], arg_resultCount ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingStateChangeStreamId:(NSString *)arg_streamId
                                     state:(NSNumber *)arg_state
                                    reason:(NSNumber *)arg_reason
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPlayStreamingStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_streamId ?: [NSNull null], arg_state ?: [NSNull null], arg_reason ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingReceiveSeiMessageStreamId:(NSString *)arg_streamId
                                         message:(NSString *)arg_message
                                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPlayStreamingReceiveSeiMessage"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_streamId ?: [NSNull null], arg_message ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingFirstAudioFramePlayedStreamId:(NSString *)arg_streamId
                                              timeMs:(NSNumber *)arg_timeMs
                                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPlayStreamingFirstAudioFramePlayed"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_streamId ?: [NSNull null], arg_timeMs ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPlayStreamingFirstVideoFrameRenderStreamId:(NSString *)arg_streamId
                                              timeMs:(NSNumber *)arg_timeMs
                                               width:(NSNumber *)arg_width
                                              height:(NSNumber *)arg_height
                                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPlayStreamingFirstVideoFrameRender"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_streamId ?: [NSNull null], arg_timeMs ?: [NSNull null], arg_width ?: [NSNull null],
    arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalAudioFirstPacketSentAudioStreamType:(NSNumber *)arg_audioStreamType
                                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalAudioFirstPacketSent"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_audioStreamType ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onFirstVideoFrameRenderUserID:(NSNumber *)arg_userID
                           streamType:(NSNumber *)arg_streamType
                                width:(NSNumber *)arg_width
                               height:(NSNumber *)arg_height
                          elapsedTime:(NSNumber *)arg_elapsedTime
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onFirstVideoFrameRender"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_userID ?: [NSNull null], arg_streamType ?: [NSNull null], arg_width ?: [NSNull null],
    arg_height ?: [NSNull null], arg_elapsedTime ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalVideoRenderSizeChangedVideoType:(NSNumber *)arg_videoType
                                         width:(NSNumber *)arg_width
                                        height:(NSNumber *)arg_height
                                    completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalVideoRenderSizeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_videoType ?: [NSNull null], arg_width ?: [NSNull null], arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserVideoProfileUpdateUid:(NSNumber *)arg_uid
                         maxProfile:(NSNumber *)arg_maxProfile
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserVideoProfileUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_maxProfile ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioDeviceChangedSelected:(NSNumber *)arg_selected
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onAudioDeviceChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_selected ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioDeviceStateChangeDeviceType:(NSNumber *)arg_deviceType
                               deviceState:(NSNumber *)arg_deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onAudioDeviceStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_deviceType ?: [NSNull null], arg_deviceState ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onApiCallExecutedApiName:(NSString *)arg_apiName
                          result:(NSNumber *)arg_result
                         message:(NSString *)arg_message
                      completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onApiCallExecuted"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_apiName ?: [NSNull null], arg_result ?: [NSNull null], arg_message ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteVideoSizeChangedUserId:(NSNumber *)arg_userId
                             videoType:(NSNumber *)arg_videoType
                                 width:(NSNumber *)arg_width
                                height:(NSNumber *)arg_height
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onRemoteVideoSizeChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_userId ?: [NSNull null], arg_videoType ?: [NSNull null], arg_width ?: [NSNull null],
    arg_height ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStartUid:(NSNumber *)arg_uid
                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataStart"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStopUid:(NSNumber *)arg_uid
               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onUserDataStop"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataReceiveMessageUid:(NSNumber *)arg_uid
                         bufferData:(FlutterStandardTypedData *)arg_bufferData
                         bufferSize:(NSNumber *)arg_bufferSize
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserDataReceiveMessage"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[
    arg_uid ?: [NSNull null], arg_bufferData ?: [NSNull null], arg_bufferSize ?: [NSNull null]
  ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataStateChangedUid:(NSNumber *)arg_uid
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserDataStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onUserDataBufferedAmountChangedUid:(NSNumber *)arg_uid
                            previousAmount:(NSNumber *)arg_previousAmount
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onUserDataBufferedAmountChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_uid ?: [NSNull null], arg_previousAmount ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLabFeatureCallbackKey:(NSString *)arg_key
                          param:(NSDictionary<id, id> *)arg_param
                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLabFeatureCallback"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_key ?: [NSNull null], arg_param ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAiDataType:(NSString *)arg_type
                data:(NSString *)arg_data
          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcChannelEventSink.onAiData"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_type ?: [NSNull null], arg_data ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onStartPushStreamingResult:(NSNumber *)arg_result
                         channelId:(NSNumber *)arg_channelId
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onStartPushStreaming"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null], arg_channelId ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onStopPushStreamingResult:(NSNumber *)arg_result
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onStopPushStreaming"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPushStreamingReconnectingReason:(NSNumber *)arg_reason
                               completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPushStreamingReconnecting"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onPushStreamingReconnectedSuccessWithCompletion:
    (void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onPushStreamingReconnectedSuccess"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:nil
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onReleasedHwResourcesResult:(NSNumber *)arg_result
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onReleasedHwResources"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onScreenCaptureStatusStatus:(NSNumber *)arg_status
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onScreenCaptureStatus"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_status ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onScreenCaptureSourceDataUpdateData:(NEFLTScreenCaptureSourceData *)arg_data
                                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onScreenCaptureSourceDataUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_data ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalRecorderStatusStatus:(NSNumber *)arg_status
                             taskId:(NSString *)arg_taskId
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalRecorderStatus"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_status ?: [NSNull null], arg_taskId ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalRecorderErrorError:(NSNumber *)arg_error
                           taskId:(NSString *)arg_taskId
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onLocalRecorderError"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_error ?: [NSNull null], arg_taskId ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onCheckNECastAudioDriverResultResult:(NSNumber *)arg_result
                                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcChannelEventSink.onCheckNECastAudioDriverResult"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcChannelEventSinkGetCodec()];
  [channel sendMessage:@[ arg_result ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

@interface NEFLTChannelApiCodecReader : FlutterStandardReader
@end
@implementation NEFLTChannelApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:[self readValue]];
    case 129:
      return [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:[self readValue]];
    case 130:
      return [NEFLTDataExternalFrame fromList:[self readValue]];
    case 131:
      return [NEFLTDeleteLiveStreamTaskRequest fromList:[self readValue]];
    case 132:
      return [NEFLTEnableAudioVolumeIndicationRequest fromList:[self readValue]];
    case 133:
      return [NEFLTEnableEncryptionRequest fromList:[self readValue]];
    case 134:
      return [NEFLTEnableLocalVideoRequest fromList:[self readValue]];
    case 135:
      return [NEFLTJoinChannelOptions fromList:[self readValue]];
    case 136:
      return [NEFLTJoinChannelRequest fromList:[self readValue]];
    case 137:
      return [NEFLTPositionInfo fromList:[self readValue]];
    case 138:
      return [NEFLTReportCustomEventRequest fromList:[self readValue]];
    case 139:
      return [NEFLTSendSEIMsgRequest fromList:[self readValue]];
    case 140:
      return [NEFLTSetAudioSubscribeOnlyByRequest fromList:[self readValue]];
    case 141:
      return [NEFLTSetCameraCaptureConfigRequest fromList:[self readValue]];
    case 142:
      return [NEFLTSetLocalMediaPriorityRequest fromList:[self readValue]];
    case 143:
      return [NEFLTSetLocalVideoConfigRequest fromList:[self readValue]];
    case 144:
      return [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:[self readValue]];
    case 145:
      return [NEFLTSpatializerRoomProperty fromList:[self readValue]];
    case 146:
      return [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:[self readValue]];
    case 147:
      return [NEFLTStartScreenCaptureRequest fromList:[self readValue]];
    case 148:
      return [NEFLTSubscribeRemoteVideoStreamRequest fromList:[self readValue]];
    case 149:
      return [NEFLTVideoFrame fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTChannelApiCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTChannelApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTAddOrUpdateLiveStreamTaskRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAdjustUserPlaybackSignalVolumeRequest class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDataExternalFrame class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDeleteLiveStreamTaskRequest class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableAudioVolumeIndicationRequest class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableEncryptionRequest class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableLocalVideoRequest class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelOptions class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelRequest class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPositionInfo class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTReportCustomEventRequest class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSendSEIMsgRequest class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioSubscribeOnlyByRequest class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraCaptureConfigRequest class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalMediaPriorityRequest class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoConfigRequest class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetRemoteHighPriorityAudioStreamRequest class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSpatializerRoomProperty class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartOrUpdateChannelMediaRelayRequest class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartScreenCaptureRequest class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteVideoStreamRequest class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoFrame class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTChannelApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTChannelApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTChannelApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTChannelApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTChannelApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTChannelApiCodecReaderWriter *readerWriter =
        [[NEFLTChannelApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void NEFLTChannelApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                          NSObject<NEFLTChannelApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.getChannelName"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(getChannelNameChannelTag:error:)],
          @"NEFLTChannelApi api (%@) doesn't respond to @selector(getChannelNameChannelTag:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSString *output = [api getChannelNameChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setStatsEventCallback"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setStatsEventCallbackChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setStatsEventCallbackChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setStatsEventCallbackChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"clearStatsEventCallback"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(clearStatsEventCallbackChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(clearStatsEventCallbackChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api clearStatsEventCallbackChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setChannelProfile"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setChannelProfileChannelTag:
                                                               channelProfile:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setChannelProfileChannelTag:channelProfile:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_channelProfile = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setChannelProfileChannelTag:arg_channelTag
                                             channelProfile:arg_channelProfile
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableMediaPub"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableMediaPubChannelTag:
                                                                 mediaType:enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableMediaPubChannelTag:mediaType:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mediaType = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api enableMediaPubChannelTag:arg_channelTag
                                               mediaType:arg_mediaType
                                                  enable:arg_enable
                                                   error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.joinChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(joinChannelChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(joinChannelChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTJoinChannelRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api joinChannelChannelTag:arg_channelTag
                                              request:arg_request
                                                error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.leaveChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(leaveChannelChannelTag:error:)],
          @"NEFLTChannelApi api (%@) doesn't respond to @selector(leaveChannelChannelTag:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api leaveChannelChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setClientRole"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setClientRoleChannelTag:role:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setClientRoleChannelTag:role:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_role = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setClientRoleChannelTag:arg_channelTag role:arg_role error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.getConnectionState"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getConnectionStateChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(getConnectionStateChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getConnectionStateChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.release"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(releaseChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to @selector(releaseChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api releaseChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLocalAudioChannelTag:enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableLocalAudioChannelTag:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableLocalAudioChannelTag:arg_channelTag
                                                    enable:arg_enable
                                                     error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.muteLocalAudioStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(muteLocalAudioStreamChannelTag:mute:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(muteLocalAudioStreamChannelTag:mute:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api muteLocalAudioStreamChannelTag:arg_channelTag
                                                          mute:arg_mute
                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteAudioChannelTag:
                                                                             uid:subscribe:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteAudioChannelTag:uid:subscribe:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteAudioChannelTag:arg_channelTag
                                                           uid:arg_uid
                                                     subscribe:arg_subscribe
                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"subscribeRemoteSubAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (subscribeRemoteSubAudioChannelTag:uid:subscribe:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteSubAudioChannelTag:uid:subscribe:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteSubAudioChannelTag:arg_channelTag
                                                              uid:arg_uid
                                                        subscribe:arg_subscribe
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setLocalVideoConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalVideoConfigChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setLocalVideoConfigChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSetLocalVideoConfigRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setLocalVideoConfigChannelTag:arg_channelTag
                                                      request:arg_request
                                                        error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalVideo"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLocalVideoChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableLocalVideoChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTEnableLocalVideoRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableLocalVideoChannelTag:arg_channelTag
                                                   request:arg_request
                                                     error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.muteLocalVideoStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(muteLocalVideoStreamChannelTag:mute:streamType:error:)],
          @"NEFLTChannelApi api (%@) doesn't respond to "
          @"@selector(muteLocalVideoStreamChannelTag:mute:streamType:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api muteLocalVideoStreamChannelTag:arg_channelTag
                                                          mute:arg_mute
                                                    streamType:arg_streamType
                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.switchCamera"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(switchCameraChannelTag:error:)],
          @"NEFLTChannelApi api (%@) doesn't respond to @selector(switchCameraChannelTag:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api switchCameraChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"subscribeRemoteVideoStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteVideoStreamChannelTag:
                                                                               request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteVideoStreamChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSubscribeRemoteVideoStreamRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteVideoStreamChannelTag:arg_channelTag
                                                             request:arg_request
                                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"subscribeRemoteSubVideoStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (subscribeRemoteSubVideoStreamChannelTag:uid:subscribe:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteSubVideoStreamChannelTag:uid:subscribe:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteSubVideoStreamChannelTag:arg_channelTag
                                                                    uid:arg_uid
                                                              subscribe:arg_subscribe
                                                                  error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"enableAudioVolumeIndication"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableAudioVolumeIndicationChannelTag:
                                                                                request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableAudioVolumeIndicationChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTEnableAudioVolumeIndicationRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableAudioVolumeIndicationChannelTag:arg_channelTag
                                                              request:arg_request
                                                                error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.takeLocalSnapshot"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(takeLocalSnapshotChannelTag:
                                                                   streamType:path:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(takeLocalSnapshotChannelTag:streamType:path:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NSString *arg_path = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api takeLocalSnapshotChannelTag:arg_channelTag
                                                 streamType:arg_streamType
                                                       path:arg_path
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.takeRemoteSnapshot"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (takeRemoteSnapshotChannelTag:uid:streamType:path:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(takeRemoteSnapshotChannelTag:uid:streamType:path:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 2);
        NSString *arg_path = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        NSNumber *output = [api takeRemoteSnapshotChannelTag:arg_channelTag
                                                         uid:arg_uid
                                                  streamType:arg_streamType
                                                        path:arg_path
                                                       error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"subscribeAllRemoteAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeAllRemoteAudioChannelTag:
                                                                          subscribe:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeAllRemoteAudioChannelTag:subscribe:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api subscribeAllRemoteAudioChannelTag:arg_channelTag
                                                        subscribe:arg_subscribe
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setCameraCaptureConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setCameraCaptureConfigChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setCameraCaptureConfigChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSetCameraCaptureConfigRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setCameraCaptureConfigChannelTag:arg_channelTag
                                                         request:arg_request
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setVideoStreamLayerCount"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setVideoStreamLayerCountChannelTag:
                                                                          layerCount:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setVideoStreamLayerCountChannelTag:layerCount:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_layerCount = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setVideoStreamLayerCountChannelTag:arg_channelTag
                                                        layerCount:arg_layerCount
                                                             error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"getFeatureSupportedType"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getFeatureSupportedTypeChannelTag:type:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(getFeatureSupportedTypeChannelTag:type:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_type = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api getFeatureSupportedTypeChannelTag:arg_channelTag
                                                             type:arg_type
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"switchCameraWithPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(switchCameraWithPositionChannelTag:
                                                                            position:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(switchCameraWithPositionChannelTag:position:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_position = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api switchCameraWithPositionChannelTag:arg_channelTag
                                                          position:arg_position
                                                             error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.startScreenCapture"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startScreenCaptureChannelTag:
                                                                       request:completion:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(startScreenCaptureChannelTag:request:completion:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTStartScreenCaptureRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        [api startScreenCaptureChannelTag:arg_channelTag
                                  request:arg_request
                               completion:^(NSNumber *_Nullable output,
                                            FlutterError *_Nullable error) {
                                 callback(wrapResult(output, error));
                               }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.stopScreenCapture"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopScreenCaptureChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(stopScreenCaptureChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopScreenCaptureChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"enableLoopbackRecording"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLoopbackRecordingChannelTag:enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableLoopbackRecordingChannelTag:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableLoopbackRecordingChannelTag:arg_channelTag
                                                           enable:arg_enable
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"adjustLoopBackRecordingSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (adjustLoopBackRecordingSignalVolumeChannelTag:volume:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(adjustLoopBackRecordingSignalVolumeChannelTag:volume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api adjustLoopBackRecordingSignalVolumeChannelTag:arg_channelTag
                                                                       volume:arg_volume
                                                                        error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setExternalVideoSource"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setExternalVideoSourceChannelTag:
                                                                        streamType:enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setExternalVideoSourceChannelTag:streamType:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setExternalVideoSourceChannelTag:arg_channelTag
                                                      streamType:arg_streamType
                                                          enable:arg_enable
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.pushExternalVideoFrame"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pushExternalVideoFrameChannelTag:
                                                                        streamType:frame:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(pushExternalVideoFrameChannelTag:streamType:frame:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NEFLTVideoFrame *arg_frame = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api pushExternalVideoFrameChannelTag:arg_channelTag
                                                      streamType:arg_streamType
                                                           frame:arg_frame
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.addLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(addLiveStreamTaskChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(addLiveStreamTaskChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTAddOrUpdateLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api addLiveStreamTaskChannelTag:arg_channelTag
                                                    request:arg_request
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.updateLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateLiveStreamTaskChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(updateLiveStreamTaskChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTAddOrUpdateLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api updateLiveStreamTaskChannelTag:arg_channelTag
                                                       request:arg_request
                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.removeLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(removeLiveStreamTaskChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(removeLiveStreamTaskChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTDeleteLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api removeLiveStreamTaskChannelTag:arg_channelTag
                                                       request:arg_request
                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.sendSEIMsg"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(sendSEIMsgChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(sendSEIMsgChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSendSEIMsgRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api sendSEIMsgChannelTag:arg_channelTag
                                             request:arg_request
                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setLocalMediaPriority"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalMediaPriorityChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setLocalMediaPriorityChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSetLocalMediaPriorityRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setLocalMediaPriorityChannelTag:arg_channelTag
                                                        request:arg_request
                                                          error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.startChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startChannelMediaRelayChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(startChannelMediaRelayChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTStartOrUpdateChannelMediaRelayRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api startChannelMediaRelayChannelTag:arg_channelTag
                                                         request:arg_request
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"updateChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateChannelMediaRelayChannelTag:
                                                                            request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(updateChannelMediaRelayChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTStartOrUpdateChannelMediaRelayRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api updateChannelMediaRelayChannelTag:arg_channelTag
                                                          request:arg_request
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.stopChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopChannelMediaRelayChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(stopChannelMediaRelayChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopChannelMediaRelayChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"adjustUserPlaybackSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(adjustUserPlaybackSignalVolumeChannelTag:
                                                                                   request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(adjustUserPlaybackSignalVolumeChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTAdjustUserPlaybackSignalVolumeRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api adjustUserPlaybackSignalVolumeChannelTag:arg_channelTag
                                                                 request:arg_request
                                                                   error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setLocalPublishFallbackOption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalPublishFallbackOptionChannelTag:
                                                                                   option:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setLocalPublishFallbackOptionChannelTag:option:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_option = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setLocalPublishFallbackOptionChannelTag:arg_channelTag
                                                                 option:arg_option
                                                                  error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setRemoteSubscribeFallbackOption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setRemoteSubscribeFallbackOptionChannelTag:option:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setRemoteSubscribeFallbackOptionChannelTag:option:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_option = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setRemoteSubscribeFallbackOptionChannelTag:arg_channelTag
                                                                    option:arg_option
                                                                     error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableEncryption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableEncryptionChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableEncryptionChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTEnableEncryptionRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableEncryptionChannelTag:arg_channelTag
                                                   request:arg_request
                                                     error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setRemoteHighPriorityAudioStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setRemoteHighPriorityAudioStreamChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setRemoteHighPriorityAudioStreamChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSetRemoteHighPriorityAudioStreamRequest *arg_request =
            GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setRemoteHighPriorityAudioStreamChannelTag:arg_channelTag
                                                                   request:arg_request
                                                                     error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setAudioSubscribeOnlyBy"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioSubscribeOnlyByChannelTag:
                                                                            request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setAudioSubscribeOnlyByChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSetAudioSubscribeOnlyByRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setAudioSubscribeOnlyByChannelTag:arg_channelTag
                                                          request:arg_request
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"enableLocalSubStreamAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLocalSubStreamAudioChannelTag:
                                                                               enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableLocalSubStreamAudioChannelTag:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableLocalSubStreamAudioChannelTag:arg_channelTag
                                                             enable:arg_enable
                                                              error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableLocalData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLocalDataChannelTag:enabled:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableLocalDataChannelTag:enabled:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableLocalDataChannelTag:arg_channelTag
                                                  enabled:arg_enabled
                                                    error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.subscribeRemoteData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteDataChannelTag:
                                                                      subscribe:userID:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteDataChannelTag:subscribe:userID:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_userID = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteDataChannelTag:arg_channelTag
                                                    subscribe:arg_subscribe
                                                       userID:arg_userID
                                                        error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.sendData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(sendDataChannelTag:frame:error:)],
          @"NEFLTChannelApi api (%@) doesn't respond to @selector(sendDataChannelTag:frame:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTDataExternalFrame *arg_frame = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api sendDataChannelTag:arg_channelTag frame:arg_frame error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.reportCustomEvent"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(reportCustomEventChannelTag:request:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(reportCustomEventChannelTag:request:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTReportCustomEventRequest *arg_request = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api reportCustomEventChannelTag:arg_channelTag
                                                    request:arg_request
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setAudioRecvRange"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setAudioRecvRangeChannelTag:
                                  audibleDistance:conversationalDistance:rollOffMode:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setAudioRecvRangeChannelTag:audibleDistance:conversationalDistance:"
                @"rollOffMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_audibleDistance = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_conversationalDistance = GetNullableObjectAtIndex(args, 2);
        NSNumber *arg_rollOffMode = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        NSNumber *output = [api setAudioRecvRangeChannelTag:arg_channelTag
                                            audibleDistance:arg_audibleDistance
                                     conversationalDistance:arg_conversationalDistance
                                                rollOffMode:arg_rollOffMode
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRangeAudioMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRangeAudioModeChannelTag:audioMode:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setRangeAudioModeChannelTag:audioMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_audioMode = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setRangeAudioModeChannelTag:arg_channelTag
                                                  audioMode:arg_audioMode
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setRangeAudioTeamID"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRangeAudioTeamIDChannelTag:teamID:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setRangeAudioTeamIDChannelTag:teamID:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_teamID = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setRangeAudioTeamIDChannelTag:arg_channelTag
                                                       teamID:arg_teamID
                                                        error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.updateSelfPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateSelfPositionChannelTag:
                                                                  positionInfo:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(updateSelfPositionChannelTag:positionInfo:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTPositionInfo *arg_positionInfo = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api updateSelfPositionChannelTag:arg_channelTag
                                                positionInfo:arg_positionInfo
                                                       error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"enableSpatializerRoomEffects"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableSpatializerRoomEffectsChannelTag:
                                                                                  enable:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableSpatializerRoomEffectsChannelTag:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableSpatializerRoomEffectsChannelTag:arg_channelTag
                                                                enable:arg_enable
                                                                 error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setSpatializerRoomProperty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSpatializerRoomPropertyChannelTag:
                                                                              property:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setSpatializerRoomPropertyChannelTag:property:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NEFLTSpatializerRoomProperty *arg_property = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setSpatializerRoomPropertyChannelTag:arg_channelTag
                                                            property:arg_property
                                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setSpatializerRenderMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSpatializerRenderModeChannelTag:
                                                                          renderMode:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setSpatializerRenderModeChannelTag:renderMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_renderMode = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setSpatializerRenderModeChannelTag:arg_channelTag
                                                        renderMode:arg_renderMode
                                                             error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.enableSpatializer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableSpatializerChannelTag:
                                                                       enable:applyToTeam:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(enableSpatializerChannelTag:enable:applyToTeam:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_applyToTeam = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api enableSpatializerChannelTag:arg_channelTag
                                                     enable:arg_enable
                                                applyToTeam:arg_applyToTeam
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi.setUpSpatializer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setUpSpatializerChannelTag:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setUpSpatializerChannelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setUpSpatializerChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setSubscribeAudioBlocklist"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setSubscribeAudioBlocklistChannelTag:uidArray:streamType:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setSubscribeAudioBlocklistChannelTag:uidArray:streamType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSArray<NSNumber *> *arg_uidArray = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setSubscribeAudioBlocklistChannelTag:arg_channelTag
                                                            uidArray:arg_uidArray
                                                          streamType:arg_streamType
                                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.ChannelApi."
                        @"setSubscribeAudioAllowlist"
        binaryMessenger:binaryMessenger
                  codec:NEFLTChannelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSubscribeAudioAllowlistChannelTag:
                                                                              uidArray:error:)],
                @"NEFLTChannelApi api (%@) doesn't respond to "
                @"@selector(setSubscribeAudioAllowlistChannelTag:uidArray:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        NSArray<NSNumber *> *arg_uidArray = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setSubscribeAudioAllowlistChannelTag:arg_channelTag
                                                            uidArray:arg_uidArray
                                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface NEFLTEngineApiCodecReader : FlutterStandardReader
@end
@implementation NEFLTEngineApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:[self readValue]];
    case 129:
      return [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:[self readValue]];
    case 130:
      return [NEFLTAudioExternalFrame fromList:[self readValue]];
    case 131:
      return [NEFLTAudioRecordingConfigurationRequest fromList:[self readValue]];
    case 132:
      return [NEFLTAudioVolumeInfo fromList:[self readValue]];
    case 133:
      return [NEFLTCGPoint fromList:[self readValue]];
    case 134:
      return [NEFLTCreateEngineRequest fromList:[self readValue]];
    case 135:
      return [NEFLTDataExternalFrame fromList:[self readValue]];
    case 136:
      return [NEFLTDeleteLiveStreamTaskRequest fromList:[self readValue]];
    case 137:
      return [NEFLTEnableAudioVolumeIndicationRequest fromList:[self readValue]];
    case 138:
      return [NEFLTEnableEncryptionRequest fromList:[self readValue]];
    case 139:
      return [NEFLTEnableLocalVideoRequest fromList:[self readValue]];
    case 140:
      return [NEFLTEnableVirtualBackgroundRequest fromList:[self readValue]];
    case 141:
      return [NEFLTFirstVideoDataReceivedEvent fromList:[self readValue]];
    case 142:
      return [NEFLTFirstVideoFrameDecodedEvent fromList:[self readValue]];
    case 143:
      return [NEFLTJoinChannelOptions fromList:[self readValue]];
    case 144:
      return [NEFLTJoinChannelRequest fromList:[self readValue]];
    case 145:
      return [NEFLTLocalRecordingConfig fromList:[self readValue]];
    case 146:
      return [NEFLTLocalRecordingLayoutConfig fromList:[self readValue]];
    case 147:
      return [NEFLTLocalRecordingStreamInfo fromList:[self readValue]];
    case 148:
      return [NEFLTNERtcLastmileProbeOneWayResult fromList:[self readValue]];
    case 149:
      return [NEFLTNERtcLastmileProbeResult fromList:[self readValue]];
    case 150:
      return [NEFLTNERtcUserJoinExtraInfo fromList:[self readValue]];
    case 151:
      return [NEFLTNERtcUserLeaveExtraInfo fromList:[self readValue]];
    case 152:
      return [NEFLTNERtcVersion fromList:[self readValue]];
    case 153:
      return [NEFLTPlayEffectRequest fromList:[self readValue]];
    case 154:
      return [NEFLTPositionInfo fromList:[self readValue]];
    case 155:
      return [NEFLTRectangle fromList:[self readValue]];
    case 156:
      return [NEFLTRemoteAudioVolumeIndicationEvent fromList:[self readValue]];
    case 157:
      return [NEFLTReportCustomEventRequest fromList:[self readValue]];
    case 158:
      return [NEFLTRtcServerAddresses fromList:[self readValue]];
    case 159:
      return [NEFLTScreenCaptureSourceData fromList:[self readValue]];
    case 160:
      return [NEFLTSendSEIMsgRequest fromList:[self readValue]];
    case 161:
      return [NEFLTSetAudioProfileRequest fromList:[self readValue]];
    case 162:
      return [NEFLTSetAudioSubscribeOnlyByRequest fromList:[self readValue]];
    case 163:
      return [NEFLTSetCameraCaptureConfigRequest fromList:[self readValue]];
    case 164:
      return [NEFLTSetCameraPositionRequest fromList:[self readValue]];
    case 165:
      return [NEFLTSetLocalMediaPriorityRequest fromList:[self readValue]];
    case 166:
      return [NEFLTSetLocalVideoConfigRequest fromList:[self readValue]];
    case 167:
      return [NEFLTSetLocalVideoWatermarkConfigsRequest fromList:[self readValue]];
    case 168:
      return [NEFLTSetLocalVoiceEqualizationRequest fromList:[self readValue]];
    case 169:
      return [NEFLTSetLocalVoiceReverbParamRequest fromList:[self readValue]];
    case 170:
      return [NEFLTSetMultiPathOptionRequest fromList:[self readValue]];
    case 171:
      return [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:[self readValue]];
    case 172:
      return [NEFLTSetVideoCorrectionConfigRequest fromList:[self readValue]];
    case 173:
      return [NEFLTSpatializerRoomProperty fromList:[self readValue]];
    case 174:
      return [NEFLTStartASRCaptionRequest fromList:[self readValue]];
    case 175:
      return [NEFLTStartAudioMixingRequest fromList:[self readValue]];
    case 176:
      return [NEFLTStartAudioRecordingRequest fromList:[self readValue]];
    case 177:
      return [NEFLTStartLastmileProbeTestRequest fromList:[self readValue]];
    case 178:
      return [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:[self readValue]];
    case 179:
      return [NEFLTStartPlayStreamingRequest fromList:[self readValue]];
    case 180:
      return [NEFLTStartPushStreamingRequest fromList:[self readValue]];
    case 181:
      return [NEFLTStartScreenCaptureRequest fromList:[self readValue]];
    case 182:
      return [NEFLTStartorStopVideoPreviewRequest fromList:[self readValue]];
    case 183:
      return [NEFLTStreamingRoomInfo fromList:[self readValue]];
    case 184:
      return [NEFLTSubscribeRemoteAudioRequest fromList:[self readValue]];
    case 185:
      return [NEFLTSubscribeRemoteSubStreamAudioRequest fromList:[self readValue]];
    case 186:
      return [NEFLTSubscribeRemoteSubStreamVideoRequest fromList:[self readValue]];
    case 187:
      return [NEFLTSubscribeRemoteVideoStreamRequest fromList:[self readValue]];
    case 188:
      return [NEFLTSwitchChannelRequest fromList:[self readValue]];
    case 189:
      return [NEFLTUserJoinedEvent fromList:[self readValue]];
    case 190:
      return [NEFLTUserLeaveEvent fromList:[self readValue]];
    case 191:
      return [NEFLTUserVideoMuteEvent fromList:[self readValue]];
    case 192:
      return [NEFLTVideoFrame fromList:[self readValue]];
    case 193:
      return [NEFLTVideoWatermarkConfig fromList:[self readValue]];
    case 194:
      return [NEFLTVideoWatermarkImageConfig fromList:[self readValue]];
    case 195:
      return [NEFLTVideoWatermarkTextConfig fromList:[self readValue]];
    case 196:
      return [NEFLTVideoWatermarkTimestampConfig fromList:[self readValue]];
    case 197:
      return [NEFLTVirtualBackgroundSourceEnabledEvent fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTEngineApiCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTEngineApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTAddOrUpdateLiveStreamTaskRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAdjustUserPlaybackSignalVolumeRequest class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioExternalFrame class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioRecordingConfigurationRequest class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioVolumeInfo class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCGPoint class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCreateEngineRequest class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDataExternalFrame class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDeleteLiveStreamTaskRequest class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableAudioVolumeIndicationRequest class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableEncryptionRequest class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableLocalVideoRequest class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableVirtualBackgroundRequest class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoDataReceivedEvent class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoFrameDecodedEvent class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelOptions class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelRequest class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingConfig class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingLayoutConfig class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingStreamInfo class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeOneWayResult class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeResult class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserJoinExtraInfo class]]) {
    [self writeByte:150];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserLeaveExtraInfo class]]) {
    [self writeByte:151];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcVersion class]]) {
    [self writeByte:152];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPlayEffectRequest class]]) {
    [self writeByte:153];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPositionInfo class]]) {
    [self writeByte:154];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRectangle class]]) {
    [self writeByte:155];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRemoteAudioVolumeIndicationEvent class]]) {
    [self writeByte:156];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTReportCustomEventRequest class]]) {
    [self writeByte:157];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRtcServerAddresses class]]) {
    [self writeByte:158];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTScreenCaptureSourceData class]]) {
    [self writeByte:159];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSendSEIMsgRequest class]]) {
    [self writeByte:160];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioProfileRequest class]]) {
    [self writeByte:161];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioSubscribeOnlyByRequest class]]) {
    [self writeByte:162];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraCaptureConfigRequest class]]) {
    [self writeByte:163];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraPositionRequest class]]) {
    [self writeByte:164];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalMediaPriorityRequest class]]) {
    [self writeByte:165];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoConfigRequest class]]) {
    [self writeByte:166];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoWatermarkConfigsRequest class]]) {
    [self writeByte:167];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceEqualizationRequest class]]) {
    [self writeByte:168];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceReverbParamRequest class]]) {
    [self writeByte:169];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetMultiPathOptionRequest class]]) {
    [self writeByte:170];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetRemoteHighPriorityAudioStreamRequest class]]) {
    [self writeByte:171];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetVideoCorrectionConfigRequest class]]) {
    [self writeByte:172];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSpatializerRoomProperty class]]) {
    [self writeByte:173];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartASRCaptionRequest class]]) {
    [self writeByte:174];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioMixingRequest class]]) {
    [self writeByte:175];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioRecordingRequest class]]) {
    [self writeByte:176];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartLastmileProbeTestRequest class]]) {
    [self writeByte:177];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartOrUpdateChannelMediaRelayRequest class]]) {
    [self writeByte:178];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPlayStreamingRequest class]]) {
    [self writeByte:179];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPushStreamingRequest class]]) {
    [self writeByte:180];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartScreenCaptureRequest class]]) {
    [self writeByte:181];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartorStopVideoPreviewRequest class]]) {
    [self writeByte:182];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStreamingRoomInfo class]]) {
    [self writeByte:183];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteAudioRequest class]]) {
    [self writeByte:184];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamAudioRequest class]]) {
    [self writeByte:185];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamVideoRequest class]]) {
    [self writeByte:186];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteVideoStreamRequest class]]) {
    [self writeByte:187];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSwitchChannelRequest class]]) {
    [self writeByte:188];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserJoinedEvent class]]) {
    [self writeByte:189];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserLeaveEvent class]]) {
    [self writeByte:190];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserVideoMuteEvent class]]) {
    [self writeByte:191];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoFrame class]]) {
    [self writeByte:192];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkConfig class]]) {
    [self writeByte:193];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkImageConfig class]]) {
    [self writeByte:194];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTextConfig class]]) {
    [self writeByte:195];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTimestampConfig class]]) {
    [self writeByte:196];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVirtualBackgroundSourceEnabledEvent class]]) {
    [self writeByte:197];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTEngineApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTEngineApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTEngineApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTEngineApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTEngineApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTEngineApiCodecReaderWriter *readerWriter = [[NEFLTEngineApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void NEFLTEngineApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                         NSObject<NEFLTEngineApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.create"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(createRequest:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTCreateEngineRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api createRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.createChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(createChannelChannelTag:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(createChannelChannelTag:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api createChannelChannelTag:arg_channelTag error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.version"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(versionWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(versionWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NEFLTNERtcVersion *output = [api versionWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.checkPermission"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(checkPermissionWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(checkPermissionWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSArray<NSString *> *output = [api checkPermissionWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setParameters"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setParametersParams:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(setParametersParams:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSDictionary<NSString *, id> *arg_params = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setParametersParams:arg_params error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.release"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(releaseWithCompletion:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(releaseWithCompletion:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api releaseWithCompletion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setStatsEventCallback"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setStatsEventCallbackWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setStatsEventCallbackWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api setStatsEventCallbackWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.clearStatsEventCallback"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(clearStatsEventCallbackWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(clearStatsEventCallbackWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api clearStatsEventCallbackWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setChannelProfile"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setChannelProfileChannelProfile:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setChannelProfileChannelProfile:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_channelProfile = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setChannelProfileChannelProfile:arg_channelProfile error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.joinChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(joinChannelRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(joinChannelRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTJoinChannelRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api joinChannelRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.leaveChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(leaveChannelWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(leaveChannelWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api leaveChannelWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updatePermissionKey"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(updatePermissionKeyKey:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(updatePermissionKeyKey:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api updatePermissionKeyKey:arg_key error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(enableLocalAudioEnable:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(enableLocalAudioEnable:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableLocalAudioEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteAudioRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteAudioRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSubscribeRemoteAudioRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteAudioRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeAllRemoteAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeAllRemoteAudioSubscribe:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeAllRemoteAudioSubscribe:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api subscribeAllRemoteAudioSubscribe:arg_subscribe error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioProfile"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setAudioProfileRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setAudioProfileRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetAudioProfileRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioProfileRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableDualStreamMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableDualStreamModeEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableDualStreamModeEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableDualStreamModeEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVideoConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalVideoConfigRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalVideoConfigRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetLocalVideoConfigRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalVideoConfigRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setCameraCaptureConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setCameraCaptureConfigRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setCameraCaptureConfigRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetCameraCaptureConfigRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCameraCaptureConfigRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoRotationMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setVideoRotationModeRotationMode:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setVideoRotationModeRotationMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_rotationMode = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setVideoRotationModeRotationMode:arg_rotationMode error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startVideoPreview"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(startVideoPreviewRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(startVideoPreviewRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartorStopVideoPreviewRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startVideoPreviewRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopVideoPreview"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopVideoPreviewRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopVideoPreviewRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartorStopVideoPreviewRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopVideoPreviewRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalVideo"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(enableLocalVideoRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(enableLocalVideoRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTEnableLocalVideoRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableLocalVideoRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"enableLocalSubStreamAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLocalSubStreamAudioEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableLocalSubStreamAudioEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableLocalSubStreamAudioEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"subscribeRemoteSubStreamAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteSubStreamAudioRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteSubStreamAudioRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSubscribeRemoteSubStreamAudioRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteSubStreamAudioRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalSubStreamAudio"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(muteLocalSubStreamAudioMuted:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(muteLocalSubStreamAudioMuted:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_muted = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api muteLocalSubStreamAudioMuted:arg_muted error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioSubscribeOnlyBy"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioSubscribeOnlyByRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setAudioSubscribeOnlyByRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetAudioSubscribeOnlyByRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioSubscribeOnlyByRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startScreenCapture"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startScreenCaptureRequest:completion:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startScreenCaptureRequest:completion:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartScreenCaptureRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        [api
            startScreenCaptureRequest:arg_request
                           completion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
                             callback(wrapResult(output, error));
                           }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopScreenCapture"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopScreenCaptureWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopScreenCaptureWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopScreenCaptureWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLoopbackRecording"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableLoopbackRecordingEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableLoopbackRecordingEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableLoopbackRecordingEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"subscribeRemoteVideoStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteVideoStreamRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteVideoStreamRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSubscribeRemoteVideoStreamRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteVideoStreamRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"subscribeRemoteSubStreamVideo"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteSubStreamVideoRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteSubStreamVideoRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSubscribeRemoteSubStreamVideoRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteSubStreamVideoRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalAudioStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(muteLocalAudioStreamMute:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(muteLocalAudioStreamMute:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api muteLocalAudioStreamMute:arg_mute error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.muteLocalVideoStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(muteLocalVideoStreamMute:streamType:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(muteLocalVideoStreamMute:streamType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api muteLocalVideoStreamMute:arg_mute
                                              streamType:arg_streamType
                                                   error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioDump"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startAudioDumpWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(startAudioDumpWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api startAudioDumpWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioDumpWithType"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startAudioDumpWithTypeDumpType:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startAudioDumpWithTypeDumpType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_dumpType = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startAudioDumpWithTypeDumpType:arg_dumpType error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopAudioDump"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopAudioDumpWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopAudioDumpWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopAudioDumpWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"enableAudioVolumeIndication"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableAudioVolumeIndicationRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableAudioVolumeIndicationRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTEnableAudioVolumeIndicationRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableAudioVolumeIndicationRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"adjustRecordingSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(adjustRecordingSignalVolumeVolume:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(adjustRecordingSignalVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api adjustRecordingSignalVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"adjustPlaybackSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(adjustPlaybackSignalVolumeVolume:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(adjustPlaybackSignalVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api adjustPlaybackSignalVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"adjustLoopBackRecordingSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(adjustLoopBackRecordingSignalVolumeVolume:
                                                                                      error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(adjustLoopBackRecordingSignalVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api adjustLoopBackRecordingSignalVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(addLiveStreamTaskRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(addLiveStreamTaskRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAddOrUpdateLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api addLiveStreamTaskRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateLiveStreamTaskRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(updateLiveStreamTaskRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAddOrUpdateLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api updateLiveStreamTaskRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeLiveStreamTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(removeLiveStreamTaskRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(removeLiveStreamTaskRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTDeleteLiveStreamTaskRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api removeLiveStreamTaskRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setClientRole"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setClientRoleRole:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(setClientRoleRole:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_role = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setClientRoleRole:arg_role error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getConnectionState"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(getConnectionStateWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(getConnectionStateWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getConnectionStateWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.uploadSdkInfo"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(uploadSdkInfoWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(uploadSdkInfoWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api uploadSdkInfoWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.sendSEIMsg"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(sendSEIMsgRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(sendSEIMsgRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSendSEIMsgRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api sendSEIMsgRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setLocalVoiceReverbParam"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalVoiceReverbParamRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalVoiceReverbParamRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetLocalVoiceReverbParamRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalVoiceReverbParamRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioEffectPreset"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioEffectPresetPreset:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setAudioEffectPresetPreset:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_preset = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioEffectPresetPreset:arg_preset error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setVoiceBeautifierPreset"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setVoiceBeautifierPresetPreset:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setVoiceBeautifierPresetPreset:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_preset = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setVoiceBeautifierPresetPreset:arg_preset error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalVoicePitch"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setLocalVoicePitchPitch:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setLocalVoicePitchPitch:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_pitch = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalVoicePitchPitch:arg_pitch error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setLocalVoiceEqualization"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalVoiceEqualizationRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalVoiceEqualizationRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetLocalVoiceEqualizationRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalVoiceEqualizationRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.switchChannel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(switchChannelRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(switchChannelRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSwitchChannelRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api switchChannelRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startAudioRecording"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startAudioRecordingRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startAudioRecordingRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartAudioRecordingRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startAudioRecordingRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"startAudioRecordingWithConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startAudioRecordingWithConfigRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startAudioRecordingWithConfigRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAudioRecordingConfigurationRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startAudioRecordingWithConfigRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopAudioRecording"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopAudioRecordingWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopAudioRecordingWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopAudioRecordingWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setLocalMediaPriority"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalMediaPriorityRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalMediaPriorityRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetLocalMediaPriorityRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalMediaPriorityRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableMediaPub"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableMediaPubMediaType:enable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableMediaPubMediaType:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mediaType = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableMediaPubMediaType:arg_mediaType
                                                 enable:arg_enable
                                                  error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startChannelMediaRelayRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startChannelMediaRelayRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartOrUpdateChannelMediaRelayRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startChannelMediaRelayRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateChannelMediaRelayRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(updateChannelMediaRelayRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartOrUpdateChannelMediaRelayRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api updateChannelMediaRelayRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopChannelMediaRelay"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopChannelMediaRelayWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopChannelMediaRelayWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopChannelMediaRelayWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"adjustUserPlaybackSignalVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(adjustUserPlaybackSignalVolumeRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(adjustUserPlaybackSignalVolumeRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAdjustUserPlaybackSignalVolumeRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api adjustUserPlaybackSignalVolumeRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setLocalPublishFallbackOption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalPublishFallbackOptionOption:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalPublishFallbackOptionOption:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_option = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalPublishFallbackOptionOption:arg_option error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setRemoteSubscribeFallbackOption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRemoteSubscribeFallbackOptionOption:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setRemoteSubscribeFallbackOptionOption:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_option = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setRemoteSubscribeFallbackOptionOption:arg_option error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableSuperResolution"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableSuperResolutionEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableSuperResolutionEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableSuperResolutionEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableEncryption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(enableEncryptionRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(enableEncryptionRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTEnableEncryptionRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableEncryptionRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setAudioSessionOperationRestriction"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioSessionOperationRestrictionOption:
                                                                                      error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setAudioSessionOperationRestrictionOption:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_option = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioSessionOperationRestrictionOption:arg_option error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableVideoCorrection"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableVideoCorrectionEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableVideoCorrectionEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableVideoCorrectionEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.reportCustomEvent"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(reportCustomEventRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(reportCustomEventRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTReportCustomEventRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api reportCustomEventRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getEffectDuration"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(getEffectDurationEffectId:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(getEffectDurationEffectId:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectDurationEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startLastmileProbeTest"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startLastmileProbeTestRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(startLastmileProbeTestRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartLastmileProbeTestRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startLastmileProbeTestRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopLastmileProbeTest"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopLastmileProbeTestWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopLastmileProbeTestWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopLastmileProbeTestWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setVideoCorrectionConfig"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setVideoCorrectionConfigRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setVideoCorrectionConfigRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetVideoCorrectionConfigRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setVideoCorrectionConfigRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableVirtualBackground"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableVirtualBackgroundRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableVirtualBackgroundRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTEnableVirtualBackgroundRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableVirtualBackgroundRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setRemoteHighPriorityAudioStream"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRemoteHighPriorityAudioStreamRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setRemoteHighPriorityAudioStreamRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetRemoteHighPriorityAudioStreamRequest *arg_request =
            GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setRemoteHighPriorityAudioStreamRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setCloudProxy"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setCloudProxyProxyType:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setCloudProxyProxyType:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_proxyType = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCloudProxyProxyType:arg_proxyType error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startBeauty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startBeautyWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(startBeautyWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api startBeautyWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopBeauty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopBeautyWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopBeautyWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api stopBeautyWithError:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableBeauty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableBeautyEnabled:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(enableBeautyEnabled:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableBeautyEnabled:arg_enabled error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setBeautyEffect"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setBeautyEffectLevel:beautyType:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setBeautyEffectLevel:beautyType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_level = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_beautyType = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setBeautyEffectLevel:arg_level
                                          beautyType:arg_beautyType
                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.addBeautyFilter"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(addBeautyFilterPath:name:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(addBeautyFilterPath:name:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_path = GetNullableObjectAtIndex(args, 0);
        NSString *arg_name = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api addBeautyFilterPath:arg_path name:arg_name error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.removeBeautyFilter"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(removeBeautyFilterWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(removeBeautyFilterWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api removeBeautyFilterWithError:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setBeautyFilterLevel"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setBeautyFilterLevelLevel:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setBeautyFilterLevelLevel:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_level = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setBeautyFilterLevelLevel:arg_level error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setLocalVideoWatermarkConfigs"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setLocalVideoWatermarkConfigsRequest:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setLocalVideoWatermarkConfigsRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetLocalVideoWatermarkConfigsRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setLocalVideoWatermarkConfigsRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setStreamAlignmentProperty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setStreamAlignmentPropertyEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setStreamAlignmentPropertyEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setStreamAlignmentPropertyEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getNtpTimeOffset"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getNtpTimeOffsetWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(getNtpTimeOffsetWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getNtpTimeOffsetWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.takeLocalSnapshot"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(takeLocalSnapshotStreamType:path:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(takeLocalSnapshotStreamType:path:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 0);
        NSString *arg_path = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api takeLocalSnapshotStreamType:arg_streamType
                                                       path:arg_path
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.takeRemoteSnapshot"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(takeRemoteSnapshotUid:streamType:path:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(takeRemoteSnapshotUid:streamType:path:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NSString *arg_path = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api takeRemoteSnapshotUid:arg_uid
                                           streamType:arg_streamType
                                                 path:arg_path
                                                error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setExternalVideoSource"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setExternalVideoSourceStreamType:enable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setExternalVideoSourceStreamType:enable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setExternalVideoSourceStreamType:arg_streamType
                                                          enable:arg_enable
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushExternalVideoFrame"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pushExternalVideoFrameStreamType:frame:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(pushExternalVideoFrameStreamType:frame:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 0);
        NEFLTVideoFrame *arg_frame = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api pushExternalVideoFrameStreamType:arg_streamType
                                                           frame:arg_frame
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setVideoDump"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setVideoDumpDumpType:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setVideoDumpDumpType:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_dumpType = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setVideoDumpDumpType:arg_dumpType error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getParameter"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(getParameterKey:extraInfo:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(getParameterKey:extraInfo:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_key = GetNullableObjectAtIndex(args, 0);
        NSString *arg_extraInfo = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSString *output = [api getParameterKey:arg_key extraInfo:arg_extraInfo error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setVideoStreamLayerCount"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setVideoStreamLayerCountLayerCount:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setVideoStreamLayerCountLayerCount:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_layerCount = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setVideoStreamLayerCountLayerCount:arg_layerCount error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableLocalData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(enableLocalDataEnabled:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(enableLocalDataEnabled:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableLocalDataEnabled:arg_enabled error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.subscribeRemoteData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(subscribeRemoteDataSubscribe:userID:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(subscribeRemoteDataSubscribe:userID:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_subscribe = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_userID = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api subscribeRemoteDataSubscribe:arg_subscribe
                                                      userID:arg_userID
                                                       error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getFeatureSupportedType"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getFeatureSupportedTypeType:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(getFeatureSupportedTypeType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_type = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getFeatureSupportedTypeType:arg_type error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.isFeatureSupported"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(isFeatureSupportedType:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(isFeatureSupportedType:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_type = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api isFeatureSupportedType:arg_type error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setSubscribeAudioBlocklist"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSubscribeAudioBlocklistUidArray:
                                                                          streamType:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setSubscribeAudioBlocklistUidArray:streamType:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NSNumber *> *arg_uidArray = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setSubscribeAudioBlocklistUidArray:arg_uidArray
                                                        streamType:arg_streamType
                                                             error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setSubscribeAudioAllowlist"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSubscribeAudioAllowlistUidArray:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setSubscribeAudioAllowlistUidArray:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NSNumber *> *arg_uidArray = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setSubscribeAudioAllowlistUidArray:arg_uidArray error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.getNetworkType"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getNetworkTypeWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(getNetworkTypeWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getNetworkTypeWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startPushStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(startPushStreamingRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(startPushStreamingRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartPushStreamingRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startPushStreamingRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startPlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(startPlayStreamingRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(startPlayStreamingRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartPlayStreamingRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startPlayStreamingRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopPushStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopPushStreamingWithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopPushStreamingWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopPushStreamingWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopPlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopPlayStreamingStreamId:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopPlayStreamingStreamId:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopPlayStreamingStreamId:arg_streamId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pausePlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pausePlayStreamingStreamId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(pausePlayStreamingStreamId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api pausePlayStreamingStreamId:arg_streamId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.resumePlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(resumePlayStreamingStreamId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(resumePlayStreamingStreamId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api resumePlayStreamingStreamId:arg_streamId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"muteVideoForPlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(muteVideoForPlayStreamingStreamId:mute:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(muteVideoForPlayStreamingStreamId:mute:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api muteVideoForPlayStreamingStreamId:arg_streamId
                                                             mute:arg_mute
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"muteAudioForPlayStreaming"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(muteAudioForPlayStreamingStreamId:mute:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(muteAudioForPlayStreamingStreamId:mute:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api muteAudioForPlayStreamingStreamId:arg_streamId
                                                             mute:arg_mute
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.startASRCaption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(startASRCaptionRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(startASRCaptionRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartASRCaptionRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startASRCaptionRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopASRCaption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopASRCaptionWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopASRCaptionWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopASRCaptionWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setMultiPathOption"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setMultiPathOptionRequest:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setMultiPathOptionRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetMultiPathOptionRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setMultiPathOptionRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.aiManualInterrupt"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(aiManualInterruptDstUid:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(aiManualInterruptDstUid:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_dstUid = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api aiManualInterruptDstUid:arg_dstUid error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.AINSMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(AINSModeMode:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(AINSModeMode:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mode = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api AINSModeMode:arg_mode error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioScenario"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setAudioScenarioScenario:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setAudioScenarioScenario:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_scenario = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioScenarioScenario:arg_scenario error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setExternalAudioSource"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setExternalAudioSourceEnabled:
                                                                     sampleRate:channels:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setExternalAudioSourceEnabled:sampleRate:channels:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_sampleRate = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_channels = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setExternalAudioSourceEnabled:arg_enabled
                                                   sampleRate:arg_sampleRate
                                                     channels:arg_channels
                                                        error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setExternalSubStreamAudioSource"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setExternalSubStreamAudioSourceEnabled:sampleRate:channels:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setExternalSubStreamAudioSourceEnabled:sampleRate:channels:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_sampleRate = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_channels = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setExternalSubStreamAudioSourceEnabled:arg_enabled
                                                            sampleRate:arg_sampleRate
                                                              channels:arg_channels
                                                                 error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setAudioRecvRange"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setAudioRecvRangeAudibleDistance:
                                                      conversationalDistance:rollOffMode:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to "
          @"@selector(setAudioRecvRangeAudibleDistance:conversationalDistance:rollOffMode:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_audibleDistance = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_conversationalDistance = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_rollOffMode = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setAudioRecvRangeAudibleDistance:arg_audibleDistance
                                          conversationalDistance:arg_conversationalDistance
                                                     rollOffMode:arg_rollOffMode
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRangeAudioMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRangeAudioModeAudioMode:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setRangeAudioModeAudioMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_audioMode = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setRangeAudioModeAudioMode:arg_audioMode error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setRangeAudioTeamID"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setRangeAudioTeamIDTeamID:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(setRangeAudioTeamIDTeamID:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_teamID = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setRangeAudioTeamIDTeamID:arg_teamID error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.updateSelfPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateSelfPositionPositionInfo:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(updateSelfPositionPositionInfo:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTPositionInfo *arg_positionInfo = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api updateSelfPositionPositionInfo:arg_positionInfo error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"enableSpatializerRoomEffects"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableSpatializerRoomEffectsEnable:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableSpatializerRoomEffectsEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api enableSpatializerRoomEffectsEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setSpatializerRoomProperty"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSpatializerRoomPropertyProperty:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setSpatializerRoomPropertyProperty:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSpatializerRoomProperty *arg_property = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setSpatializerRoomPropertyProperty:arg_property error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"setSpatializerRenderMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSpatializerRenderModeRenderMode:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(setSpatializerRenderModeRenderMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_renderMode = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setSpatializerRenderModeRenderMode:arg_renderMode error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.enableSpatializer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableSpatializerEnable:applyToTeam:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(enableSpatializerEnable:applyToTeam:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_applyToTeam = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableSpatializerEnable:arg_enable
                                            applyToTeam:arg_applyToTeam
                                                  error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.setUpSpatializer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setUpSpatializerWithError:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(setUpSpatializerWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api setUpSpatializerWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"addLocalRecordStreamForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(addLocalRecordStreamForTaskConfig:taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(addLocalRecordStreamForTaskConfig:taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTLocalRecordingConfig *arg_config = GetNullableObjectAtIndex(args, 0);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api addLocalRecordStreamForTaskConfig:arg_config
                                                           taskId:arg_taskId
                                                            error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"removeLocalRecorderStreamForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(removeLocalRecorderStreamForTaskTaskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(removeLocalRecorderStreamForTaskTaskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api removeLocalRecorderStreamForTaskTaskId:arg_taskId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"addLocalRecorderStreamLayoutForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector
               (addLocalRecorderStreamLayoutForTaskConfig:
                                                      uid:streamType:streamLayer:taskId:error:)],
          @"NEFLTEngineApi api (%@) doesn't respond to "
          @"@selector(addLocalRecorderStreamLayoutForTaskConfig:uid:streamType:streamLayer:taskId:"
          @"error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTLocalRecordingLayoutConfig *arg_config = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 2);
        NSNumber *arg_streamLayer = GetNullableObjectAtIndex(args, 3);
        NSNumber *arg_taskId = GetNullableObjectAtIndex(args, 4);
        FlutterError *error;
        NSNumber *output = [api addLocalRecorderStreamLayoutForTaskConfig:arg_config
                                                                      uid:arg_uid
                                                               streamType:arg_streamType
                                                              streamLayer:arg_streamLayer
                                                                   taskId:arg_taskId
                                                                    error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"removeLocalRecorderStreamLayoutForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (removeLocalRecorderStreamLayoutForTaskUid:
                                                     streamType:streamLayer:taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(removeLocalRecorderStreamLayoutForTaskUid:streamType:streamLayer:"
                @"taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamLayer = GetNullableObjectAtIndex(args, 2);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        NSNumber *output = [api removeLocalRecorderStreamLayoutForTaskUid:arg_uid
                                                               streamType:arg_streamType
                                                              streamLayer:arg_streamLayer
                                                                   taskId:arg_taskId
                                                                    error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"updateLocalRecorderStreamLayoutForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (updateLocalRecorderStreamLayoutForTaskInfos:taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(updateLocalRecorderStreamLayoutForTaskInfos:taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NEFLTLocalRecordingStreamInfo *> *arg_infos = GetNullableObjectAtIndex(args, 0);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api updateLocalRecorderStreamLayoutForTaskInfos:arg_infos
                                                                     taskId:arg_taskId
                                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"replaceLocalRecorderStreamLayoutForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (replaceLocalRecorderStreamLayoutForTaskInfos:taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(replaceLocalRecorderStreamLayoutForTaskInfos:taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NEFLTLocalRecordingStreamInfo *> *arg_infos = GetNullableObjectAtIndex(args, 0);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api replaceLocalRecorderStreamLayoutForTaskInfos:arg_infos
                                                                      taskId:arg_taskId
                                                                       error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"updateLocalRecorderWaterMarksForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (updateLocalRecorderWaterMarksForTaskWatermarks:taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(updateLocalRecorderWaterMarksForTaskWatermarks:taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<NEFLTVideoWatermarkConfig *> *arg_watermarks = GetNullableObjectAtIndex(args, 0);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api updateLocalRecorderWaterMarksForTaskWatermarks:arg_watermarks
                                                                        taskId:arg_taskId
                                                                         error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"pushLocalRecorderVideoFrameForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (pushLocalRecorderVideoFrameForTaskUid:
                                                 streamType:streamLayer:taskId:frame:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(pushLocalRecorderVideoFrameForTaskUid:streamType:streamLayer:taskId:"
                @"frame:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamLayer = GetNullableObjectAtIndex(args, 2);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 3);
        NEFLTVideoFrame *arg_frame = GetNullableObjectAtIndex(args, 4);
        FlutterError *error;
        NSNumber *output = [api pushLocalRecorderVideoFrameForTaskUid:arg_uid
                                                           streamType:arg_streamType
                                                          streamLayer:arg_streamLayer
                                                               taskId:arg_taskId
                                                                frame:arg_frame
                                                                error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"showLocalRecorderStreamDefaultCoverForTask"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (showLocalRecorderStreamDefaultCoverForTaskShowEnabled:
                                                                        uid:streamType:streamLayer
                                                                           :taskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(showLocalRecorderStreamDefaultCoverForTaskShowEnabled:uid:streamType:"
                @"streamLayer:taskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_showEnabled = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_streamType = GetNullableObjectAtIndex(args, 2);
        NSNumber *arg_streamLayer = GetNullableObjectAtIndex(args, 3);
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 4);
        FlutterError *error;
        NSNumber *output =
            [api showLocalRecorderStreamDefaultCoverForTaskShowEnabled:arg_showEnabled
                                                                   uid:arg_uid
                                                            streamType:arg_streamType
                                                           streamLayer:arg_streamLayer
                                                                taskId:arg_taskId
                                                                 error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"stopLocalRecorderRemuxMp4"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopLocalRecorderRemuxMp4TaskId:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(stopLocalRecorderRemuxMp4TaskId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_taskId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopLocalRecorderRemuxMp4TaskId:arg_taskId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.remuxFlvToMp4"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(remuxFlvToMp4FlvPath:mp4Path:saveOri:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(remuxFlvToMp4FlvPath:mp4Path:saveOri:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_flvPath = GetNullableObjectAtIndex(args, 0);
        NSString *arg_mp4Path = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_saveOri = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api remuxFlvToMp4FlvPath:arg_flvPath
                                             mp4Path:arg_mp4Path
                                             saveOri:arg_saveOri
                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.stopRemuxFlvToMp4"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopRemuxFlvToMp4WithError:)],
          @"NEFLTEngineApi api (%@) doesn't respond to @selector(stopRemuxFlvToMp4WithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopRemuxFlvToMp4WithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.sendData"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(sendDataFrame:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to @selector(sendDataFrame:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTDataExternalFrame *arg_frame = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api sendDataFrame:arg_frame error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi.pushExternalAudioFrame"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pushExternalAudioFrameFrame:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(pushExternalAudioFrameFrame:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAudioExternalFrame *arg_frame = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api pushExternalAudioFrameFrame:arg_frame error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.EngineApi."
                        @"pushExternalSubAudioFrame"
        binaryMessenger:binaryMessenger
                  codec:NEFLTEngineApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pushExternalSubAudioFrameFrame:error:)],
                @"NEFLTEngineApi api (%@) doesn't respond to "
                @"@selector(pushExternalSubAudioFrameFrame:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTAudioExternalFrame *arg_frame = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api pushExternalSubAudioFrameFrame:arg_frame error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
NSObject<FlutterMessageCodec> *NEFLTVideoRendererApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void NEFLTVideoRendererApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                NSObject<NEFLTVideoRendererApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"createVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createVideoRendererWithError:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(createVideoRendererWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api createVideoRendererWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi.setMirror"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setMirrorTextureId:mirror:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setMirrorTextureId:mirror:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_mirror = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setMirrorTextureId:arg_textureId mirror:arg_mirror error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"setupLocalVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setupLocalVideoRendererTextureId:
                                                                        channelTag:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setupLocalVideoRendererTextureId:channelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 0);
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setupLocalVideoRendererTextureId:arg_textureId
                                                      channelTag:arg_channelTag
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"setupRemoteVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setupRemoteVideoRendererUid:
                                                                    textureId:channelTag:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setupRemoteVideoRendererUid:textureId:channelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 1);
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setupRemoteVideoRendererUid:arg_uid
                                                  textureId:arg_textureId
                                                 channelTag:arg_channelTag
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"setupLocalSubStreamVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setupLocalSubStreamVideoRendererTextureId:channelTag:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setupLocalSubStreamVideoRendererTextureId:channelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 0);
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setupLocalSubStreamVideoRendererTextureId:arg_textureId
                                                               channelTag:arg_channelTag
                                                                    error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"setupRemoteSubStreamVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector
                     (setupRemoteSubStreamVideoRendererUid:textureId:channelTag:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setupRemoteSubStreamVideoRendererUid:textureId:channelTag:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_uid = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 1);
        NSString *arg_channelTag = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api setupRemoteSubStreamVideoRendererUid:arg_uid
                                                           textureId:arg_textureId
                                                          channelTag:arg_channelTag
                                                               error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"setupPlayStreamingCanvas"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setupPlayStreamingCanvasStreamId:
                                                                         textureId:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(setupPlayStreamingCanvasStreamId:textureId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_streamId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setupPlayStreamingCanvasStreamId:arg_streamId
                                                       textureId:arg_textureId
                                                           error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.VideoRendererApi."
                        @"disposeVideoRenderer"
        binaryMessenger:binaryMessenger
                  codec:NEFLTVideoRendererApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(disposeVideoRendererTextureId:error:)],
                @"NEFLTVideoRendererApi api (%@) doesn't respond to "
                @"@selector(disposeVideoRendererTextureId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_textureId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api disposeVideoRendererTextureId:arg_textureId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface NEFLTNERtcDeviceEventSinkCodecReader : FlutterStandardReader
@end
@implementation NEFLTNERtcDeviceEventSinkCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTCGPoint fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTNERtcDeviceEventSinkCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTNERtcDeviceEventSinkCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTCGPoint class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTNERtcDeviceEventSinkCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTNERtcDeviceEventSinkCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTNERtcDeviceEventSinkCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTNERtcDeviceEventSinkCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTNERtcDeviceEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTNERtcDeviceEventSinkCodecReaderWriter *readerWriter =
        [[NEFLTNERtcDeviceEventSinkCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

@interface NEFLTNERtcDeviceEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcDeviceEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onAudioDeviceChangedSelected:(NSNumber *)arg_selected
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcDeviceEventSink.onAudioDeviceChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcDeviceEventSinkGetCodec()];
  [channel sendMessage:@[ arg_selected ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioDeviceStateChangeDeviceType:(NSNumber *)arg_deviceType
                               deviceState:(NSNumber *)arg_deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcDeviceEventSink.onAudioDeviceStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcDeviceEventSinkGetCodec()];
  [channel sendMessage:@[ arg_deviceType ?: [NSNull null], arg_deviceState ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onVideoDeviceStateChangeDeviceType:(NSNumber *)arg_deviceType
                               deviceState:(NSNumber *)arg_deviceState
                                completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcDeviceEventSink.onVideoDeviceStateChange"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcDeviceEventSinkGetCodec()];
  [channel sendMessage:@[ arg_deviceType ?: [NSNull null], arg_deviceState ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onCameraFocusChangedFocusPoint:(NEFLTCGPoint *)arg_focusPoint
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcDeviceEventSink.onCameraFocusChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcDeviceEventSinkGetCodec()];
  [channel sendMessage:@[ arg_focusPoint ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onCameraExposureChangedExposurePoint:(NEFLTCGPoint *)arg_exposurePoint
                                  completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcDeviceEventSink.onCameraExposureChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcDeviceEventSinkGetCodec()];
  [channel sendMessage:@[ arg_exposurePoint ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

@interface NEFLTDeviceManagerApiCodecReader : FlutterStandardReader
@end
@implementation NEFLTDeviceManagerApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTSetCameraPositionRequest fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTDeviceManagerApiCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTDeviceManagerApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTSetCameraPositionRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTDeviceManagerApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTDeviceManagerApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTDeviceManagerApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTDeviceManagerApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTDeviceManagerApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTDeviceManagerApiCodecReaderWriter *readerWriter =
        [[NEFLTDeviceManagerApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void NEFLTDeviceManagerApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                                NSObject<NEFLTDeviceManagerApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.isSpeakerphoneOn"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isSpeakerphoneOnWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isSpeakerphoneOnWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isSpeakerphoneOnWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isCameraZoomSupported"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isCameraZoomSupportedWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isCameraZoomSupportedWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isCameraZoomSupportedWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isCameraTorchSupported"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isCameraTorchSupportedWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isCameraTorchSupportedWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isCameraTorchSupportedWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isCameraFocusSupported"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isCameraFocusSupportedWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isCameraFocusSupportedWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isCameraFocusSupportedWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isCameraExposurePositionSupported"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isCameraExposurePositionSupportedWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isCameraExposurePositionSupportedWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isCameraExposurePositionSupportedWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setSpeakerphoneOn"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setSpeakerphoneOnEnable:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setSpeakerphoneOnEnable:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enable = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setSpeakerphoneOnEnable:arg_enable error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.switchCamera"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(switchCameraWithError:)],
          @"NEFLTDeviceManagerApi api (%@) doesn't respond to @selector(switchCameraWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api switchCameraWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setCameraZoomFactor"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setCameraZoomFactorFactor:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setCameraZoomFactorFactor:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_factor = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCameraZoomFactorFactor:arg_factor error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.getCameraMaxZoom"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getCameraMaxZoomWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(getCameraMaxZoomWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getCameraMaxZoomWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setCameraTorchOn"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(setCameraTorchOnOn:error:)],
          @"NEFLTDeviceManagerApi api (%@) doesn't respond to @selector(setCameraTorchOnOn:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_on = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCameraTorchOnOn:arg_on error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setCameraFocusPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setCameraFocusPositionRequest:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setCameraFocusPositionRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetCameraPositionRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCameraFocusPositionRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setCameraExposurePosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setCameraExposurePositionRequest:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setCameraExposurePositionRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTSetCameraPositionRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setCameraExposurePositionRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setPlayoutDeviceMute"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setPlayoutDeviceMuteMute:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setPlayoutDeviceMuteMute:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setPlayoutDeviceMuteMute:arg_mute error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isPlayoutDeviceMute"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isPlayoutDeviceMuteWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isPlayoutDeviceMuteWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isPlayoutDeviceMuteWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setRecordDeviceMute"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setRecordDeviceMuteMute:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setRecordDeviceMuteMute:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_mute = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setRecordDeviceMuteMute:arg_mute error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"isRecordDeviceMute"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isRecordDeviceMuteWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(isRecordDeviceMuteWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isRecordDeviceMuteWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.enableEarback"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(enableEarbackEnabled:volume:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(enableEarbackEnabled:volume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_enabled = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api enableEarbackEnabled:arg_enabled volume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.setEarbackVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEarbackVolumeVolume:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setEarbackVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setEarbackVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"setAudioFocusMode"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioFocusModeFocusMode:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(setAudioFocusModeFocusMode:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_focusMode = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioFocusModeFocusMode:arg_focusMode error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi.getCurrentCamera"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getCurrentCameraWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(getCurrentCameraWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getCurrentCameraWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"switchCameraWithPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(switchCameraWithPositionPosition:error:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(switchCameraWithPositionPosition:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_position = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api switchCameraWithPositionPosition:arg_position error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.DeviceManagerApi."
                        @"getCameraCurrentZoom"
        binaryMessenger:binaryMessenger
                  codec:NEFLTDeviceManagerApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getCameraCurrentZoomWithError:)],
                @"NEFLTDeviceManagerApi api (%@) doesn't respond to "
                @"@selector(getCameraCurrentZoomWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getCameraCurrentZoomWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface NEFLTAudioMixingApiCodecReader : FlutterStandardReader
@end
@implementation NEFLTAudioMixingApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTStartAudioMixingRequest fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTAudioMixingApiCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTAudioMixingApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTStartAudioMixingRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTAudioMixingApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTAudioMixingApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTAudioMixingApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTAudioMixingApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTAudioMixingApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTAudioMixingApiCodecReaderWriter *readerWriter =
        [[NEFLTAudioMixingApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void NEFLTAudioMixingApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                              NSObject<NEFLTAudioMixingApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.startAudioMixing"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startAudioMixingRequest:error:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(startAudioMixingRequest:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTStartAudioMixingRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api startAudioMixingRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.stopAudioMixing"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopAudioMixingWithError:)],
          @"NEFLTAudioMixingApi api (%@) doesn't respond to @selector(stopAudioMixingWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopAudioMixingWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.pauseAudioMixing"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(pauseAudioMixingWithError:)],
          @"NEFLTAudioMixingApi api (%@) doesn't respond to @selector(pauseAudioMixingWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api pauseAudioMixingWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi.resumeAudioMixing"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(resumeAudioMixingWithError:)],
          @"NEFLTAudioMixingApi api (%@) doesn't respond to @selector(resumeAudioMixingWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api resumeAudioMixingWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"setAudioMixingSendVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioMixingSendVolumeVolume:error:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(setAudioMixingSendVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioMixingSendVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"getAudioMixingSendVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAudioMixingSendVolumeWithError:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(getAudioMixingSendVolumeWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getAudioMixingSendVolumeWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"setAudioMixingPlaybackVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioMixingPlaybackVolumeVolume:error:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(setAudioMixingPlaybackVolumeVolume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioMixingPlaybackVolumeVolume:arg_volume error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"getAudioMixingPlaybackVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAudioMixingPlaybackVolumeWithError:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(getAudioMixingPlaybackVolumeWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getAudioMixingPlaybackVolumeWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"getAudioMixingDuration"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAudioMixingDurationWithError:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(getAudioMixingDurationWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getAudioMixingDurationWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"getAudioMixingCurrentPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAudioMixingCurrentPositionWithError:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(getAudioMixingCurrentPositionWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getAudioMixingCurrentPositionWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"setAudioMixingPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioMixingPositionPosition:error:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(setAudioMixingPositionPosition:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_position = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioMixingPositionPosition:arg_position error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"setAudioMixingPitch"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setAudioMixingPitchPitch:error:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(setAudioMixingPitchPitch:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_pitch = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api setAudioMixingPitchPitch:arg_pitch error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioMixingApi."
                        @"getAudioMixingPitch"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioMixingApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getAudioMixingPitchWithError:)],
                @"NEFLTAudioMixingApi api (%@) doesn't respond to "
                @"@selector(getAudioMixingPitchWithError:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getAudioMixingPitchWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
NSObject<FlutterMessageCodec> *NEFLTNERtcAudioMixingEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface NEFLTNERtcAudioMixingEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcAudioMixingEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onAudioMixingStateChangedReason:(NSNumber *)arg_reason
                             completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcAudioMixingEventSink.onAudioMixingStateChanged"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcAudioMixingEventSinkGetCodec()];
  [channel sendMessage:@[ arg_reason ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioMixingTimestampUpdateTimestampMs:(NSNumber *)arg_timestampMs
                                     completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcAudioMixingEventSink.onAudioMixingTimestampUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcAudioMixingEventSinkGetCodec()];
  [channel sendMessage:@[ arg_timestampMs ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

@interface NEFLTAudioEffectApiCodecReader : FlutterStandardReader
@end
@implementation NEFLTAudioEffectApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTPlayEffectRequest fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTAudioEffectApiCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTAudioEffectApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTPlayEffectRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTAudioEffectApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTAudioEffectApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTAudioEffectApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTAudioEffectApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTAudioEffectApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTAudioEffectApiCodecReaderWriter *readerWriter =
        [[NEFLTAudioEffectApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void NEFLTAudioEffectApiSetup(id<FlutterBinaryMessenger> binaryMessenger,
                              NSObject<NEFLTAudioEffectApi> *api) {
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.playEffect"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(playEffectRequest:error:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(playEffectRequest:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NEFLTPlayEffectRequest *arg_request = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api playEffectRequest:arg_request error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.stopEffect"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopEffectEffectId:error:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(stopEffectEffectId:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api stopEffectEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.stopAllEffects"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(stopAllEffectsWithError:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(stopAllEffectsWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api stopAllEffectsWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.pauseEffect"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(pauseEffectEffectId:error:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(pauseEffectEffectId:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api pauseEffectEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.resumeEffect"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(resumeEffectEffectId:error:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(resumeEffectEffectId:error:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api resumeEffectEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.pauseAllEffects"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(pauseAllEffectsWithError:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(pauseAllEffectsWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api pauseAllEffectsWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.resumeAllEffects"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert(
          [api respondsToSelector:@selector(resumeAllEffectsWithError:)],
          @"NEFLTAudioEffectApi api (%@) doesn't respond to @selector(resumeAllEffectsWithError:)",
          api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api resumeAllEffectsWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi."
                        @"setEffectSendVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEffectSendVolumeEffectId:volume:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(setEffectSendVolumeEffectId:volume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setEffectSendVolumeEffectId:arg_effectId
                                                     volume:arg_volume
                                                      error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi."
                        @"getEffectSendVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getEffectSendVolumeEffectId:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(getEffectSendVolumeEffectId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectSendVolumeEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi."
                        @"setEffectPlaybackVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEffectPlaybackVolumeEffectId:volume:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(setEffectPlaybackVolumeEffectId:volume:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_volume = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setEffectPlaybackVolumeEffectId:arg_effectId
                                                         volume:arg_volume
                                                          error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi."
                        @"getEffectPlaybackVolume"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getEffectPlaybackVolumeEffectId:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(getEffectPlaybackVolumeEffectId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectPlaybackVolumeEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectDuration"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getEffectDurationEffectId:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(getEffectDurationEffectId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectDurationEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:@"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi."
                        @"getEffectCurrentPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getEffectCurrentPositionEffectId:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(getEffectCurrentPositionEffectId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectCurrentPositionEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectPitch"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEffectPitchEffectId:pitch:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(setEffectPitchEffectId:pitch:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_pitch = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setEffectPitchEffectId:arg_effectId pitch:arg_pitch error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.getEffectPitch"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getEffectPitchEffectId:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(getEffectPitchEffectId:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getEffectPitchEffectId:arg_effectId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel = [[FlutterBasicMessageChannel alloc]
           initWithName:
               @"dev.flutter.pigeon.nertc_core_platform_interface.AudioEffectApi.setEffectPosition"
        binaryMessenger:binaryMessenger
                  codec:NEFLTAudioEffectApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEffectPositionEffectId:position:error:)],
                @"NEFLTAudioEffectApi api (%@) doesn't respond to "
                @"@selector(setEffectPositionEffectId:position:error:)",
                api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_effectId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_position = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api setEffectPositionEffectId:arg_effectId
                                                 position:arg_position
                                                    error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
NSObject<FlutterMessageCodec> *NEFLTNERtcAudioEffectEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface NEFLTNERtcAudioEffectEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcAudioEffectEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onAudioEffectFinishedEffectId:(NSNumber *)arg_effectId
                           completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcAudioEffectEventSink.onAudioEffectFinished"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcAudioEffectEventSinkGetCodec()];
  [channel sendMessage:@[ arg_effectId ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAudioEffectTimestampUpdateId:(NSNumber *)arg_id
                           timestampMs:(NSNumber *)arg_timestampMs
                            completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcAudioEffectEventSink.onAudioEffectTimestampUpdate"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcAudioEffectEventSinkGetCodec()];
  [channel sendMessage:@[ arg_id ?: [NSNull null], arg_timestampMs ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

@interface NEFLTNERtcStatsEventSinkCodecReader : FlutterStandardReader
@end
@implementation NEFLTNERtcStatsEventSinkCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128:
      return [NEFLTAddOrUpdateLiveStreamTaskRequest fromList:[self readValue]];
    case 129:
      return [NEFLTAdjustUserPlaybackSignalVolumeRequest fromList:[self readValue]];
    case 130:
      return [NEFLTAudioExternalFrame fromList:[self readValue]];
    case 131:
      return [NEFLTAudioRecordingConfigurationRequest fromList:[self readValue]];
    case 132:
      return [NEFLTAudioVolumeInfo fromList:[self readValue]];
    case 133:
      return [NEFLTCGPoint fromList:[self readValue]];
    case 134:
      return [NEFLTCreateEngineRequest fromList:[self readValue]];
    case 135:
      return [NEFLTDataExternalFrame fromList:[self readValue]];
    case 136:
      return [NEFLTDeleteLiveStreamTaskRequest fromList:[self readValue]];
    case 137:
      return [NEFLTEnableAudioVolumeIndicationRequest fromList:[self readValue]];
    case 138:
      return [NEFLTEnableEncryptionRequest fromList:[self readValue]];
    case 139:
      return [NEFLTEnableLocalVideoRequest fromList:[self readValue]];
    case 140:
      return [NEFLTEnableVirtualBackgroundRequest fromList:[self readValue]];
    case 141:
      return [NEFLTFirstVideoDataReceivedEvent fromList:[self readValue]];
    case 142:
      return [NEFLTFirstVideoFrameDecodedEvent fromList:[self readValue]];
    case 143:
      return [NEFLTJoinChannelOptions fromList:[self readValue]];
    case 144:
      return [NEFLTJoinChannelRequest fromList:[self readValue]];
    case 145:
      return [NEFLTLocalRecordingConfig fromList:[self readValue]];
    case 146:
      return [NEFLTLocalRecordingLayoutConfig fromList:[self readValue]];
    case 147:
      return [NEFLTLocalRecordingStreamInfo fromList:[self readValue]];
    case 148:
      return [NEFLTNERtcLastmileProbeOneWayResult fromList:[self readValue]];
    case 149:
      return [NEFLTNERtcLastmileProbeResult fromList:[self readValue]];
    case 150:
      return [NEFLTNERtcUserJoinExtraInfo fromList:[self readValue]];
    case 151:
      return [NEFLTNERtcUserLeaveExtraInfo fromList:[self readValue]];
    case 152:
      return [NEFLTNERtcVersion fromList:[self readValue]];
    case 153:
      return [NEFLTPlayEffectRequest fromList:[self readValue]];
    case 154:
      return [NEFLTPositionInfo fromList:[self readValue]];
    case 155:
      return [NEFLTRectangle fromList:[self readValue]];
    case 156:
      return [NEFLTRemoteAudioVolumeIndicationEvent fromList:[self readValue]];
    case 157:
      return [NEFLTReportCustomEventRequest fromList:[self readValue]];
    case 158:
      return [NEFLTRtcServerAddresses fromList:[self readValue]];
    case 159:
      return [NEFLTScreenCaptureSourceData fromList:[self readValue]];
    case 160:
      return [NEFLTSendSEIMsgRequest fromList:[self readValue]];
    case 161:
      return [NEFLTSetAudioProfileRequest fromList:[self readValue]];
    case 162:
      return [NEFLTSetAudioSubscribeOnlyByRequest fromList:[self readValue]];
    case 163:
      return [NEFLTSetCameraCaptureConfigRequest fromList:[self readValue]];
    case 164:
      return [NEFLTSetCameraPositionRequest fromList:[self readValue]];
    case 165:
      return [NEFLTSetLocalMediaPriorityRequest fromList:[self readValue]];
    case 166:
      return [NEFLTSetLocalVideoConfigRequest fromList:[self readValue]];
    case 167:
      return [NEFLTSetLocalVideoWatermarkConfigsRequest fromList:[self readValue]];
    case 168:
      return [NEFLTSetLocalVoiceEqualizationRequest fromList:[self readValue]];
    case 169:
      return [NEFLTSetLocalVoiceReverbParamRequest fromList:[self readValue]];
    case 170:
      return [NEFLTSetMultiPathOptionRequest fromList:[self readValue]];
    case 171:
      return [NEFLTSetRemoteHighPriorityAudioStreamRequest fromList:[self readValue]];
    case 172:
      return [NEFLTSetVideoCorrectionConfigRequest fromList:[self readValue]];
    case 173:
      return [NEFLTSpatializerRoomProperty fromList:[self readValue]];
    case 174:
      return [NEFLTStartASRCaptionRequest fromList:[self readValue]];
    case 175:
      return [NEFLTStartAudioMixingRequest fromList:[self readValue]];
    case 176:
      return [NEFLTStartAudioRecordingRequest fromList:[self readValue]];
    case 177:
      return [NEFLTStartLastmileProbeTestRequest fromList:[self readValue]];
    case 178:
      return [NEFLTStartOrUpdateChannelMediaRelayRequest fromList:[self readValue]];
    case 179:
      return [NEFLTStartPlayStreamingRequest fromList:[self readValue]];
    case 180:
      return [NEFLTStartPushStreamingRequest fromList:[self readValue]];
    case 181:
      return [NEFLTStartScreenCaptureRequest fromList:[self readValue]];
    case 182:
      return [NEFLTStartorStopVideoPreviewRequest fromList:[self readValue]];
    case 183:
      return [NEFLTStreamingRoomInfo fromList:[self readValue]];
    case 184:
      return [NEFLTSubscribeRemoteAudioRequest fromList:[self readValue]];
    case 185:
      return [NEFLTSubscribeRemoteSubStreamAudioRequest fromList:[self readValue]];
    case 186:
      return [NEFLTSubscribeRemoteSubStreamVideoRequest fromList:[self readValue]];
    case 187:
      return [NEFLTSubscribeRemoteVideoStreamRequest fromList:[self readValue]];
    case 188:
      return [NEFLTSwitchChannelRequest fromList:[self readValue]];
    case 189:
      return [NEFLTUserJoinedEvent fromList:[self readValue]];
    case 190:
      return [NEFLTUserLeaveEvent fromList:[self readValue]];
    case 191:
      return [NEFLTUserVideoMuteEvent fromList:[self readValue]];
    case 192:
      return [NEFLTVideoFrame fromList:[self readValue]];
    case 193:
      return [NEFLTVideoWatermarkConfig fromList:[self readValue]];
    case 194:
      return [NEFLTVideoWatermarkImageConfig fromList:[self readValue]];
    case 195:
      return [NEFLTVideoWatermarkTextConfig fromList:[self readValue]];
    case 196:
      return [NEFLTVideoWatermarkTimestampConfig fromList:[self readValue]];
    case 197:
      return [NEFLTVirtualBackgroundSourceEnabledEvent fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface NEFLTNERtcStatsEventSinkCodecWriter : FlutterStandardWriter
@end
@implementation NEFLTNERtcStatsEventSinkCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[NEFLTAddOrUpdateLiveStreamTaskRequest class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAdjustUserPlaybackSignalVolumeRequest class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioExternalFrame class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioRecordingConfigurationRequest class]]) {
    [self writeByte:131];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTAudioVolumeInfo class]]) {
    [self writeByte:132];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCGPoint class]]) {
    [self writeByte:133];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTCreateEngineRequest class]]) {
    [self writeByte:134];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDataExternalFrame class]]) {
    [self writeByte:135];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTDeleteLiveStreamTaskRequest class]]) {
    [self writeByte:136];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableAudioVolumeIndicationRequest class]]) {
    [self writeByte:137];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableEncryptionRequest class]]) {
    [self writeByte:138];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableLocalVideoRequest class]]) {
    [self writeByte:139];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTEnableVirtualBackgroundRequest class]]) {
    [self writeByte:140];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoDataReceivedEvent class]]) {
    [self writeByte:141];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTFirstVideoFrameDecodedEvent class]]) {
    [self writeByte:142];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelOptions class]]) {
    [self writeByte:143];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTJoinChannelRequest class]]) {
    [self writeByte:144];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingConfig class]]) {
    [self writeByte:145];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingLayoutConfig class]]) {
    [self writeByte:146];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTLocalRecordingStreamInfo class]]) {
    [self writeByte:147];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeOneWayResult class]]) {
    [self writeByte:148];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcLastmileProbeResult class]]) {
    [self writeByte:149];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserJoinExtraInfo class]]) {
    [self writeByte:150];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcUserLeaveExtraInfo class]]) {
    [self writeByte:151];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTNERtcVersion class]]) {
    [self writeByte:152];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPlayEffectRequest class]]) {
    [self writeByte:153];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTPositionInfo class]]) {
    [self writeByte:154];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRectangle class]]) {
    [self writeByte:155];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRemoteAudioVolumeIndicationEvent class]]) {
    [self writeByte:156];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTReportCustomEventRequest class]]) {
    [self writeByte:157];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTRtcServerAddresses class]]) {
    [self writeByte:158];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTScreenCaptureSourceData class]]) {
    [self writeByte:159];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSendSEIMsgRequest class]]) {
    [self writeByte:160];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioProfileRequest class]]) {
    [self writeByte:161];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetAudioSubscribeOnlyByRequest class]]) {
    [self writeByte:162];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraCaptureConfigRequest class]]) {
    [self writeByte:163];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetCameraPositionRequest class]]) {
    [self writeByte:164];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalMediaPriorityRequest class]]) {
    [self writeByte:165];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoConfigRequest class]]) {
    [self writeByte:166];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVideoWatermarkConfigsRequest class]]) {
    [self writeByte:167];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceEqualizationRequest class]]) {
    [self writeByte:168];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetLocalVoiceReverbParamRequest class]]) {
    [self writeByte:169];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetMultiPathOptionRequest class]]) {
    [self writeByte:170];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetRemoteHighPriorityAudioStreamRequest class]]) {
    [self writeByte:171];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSetVideoCorrectionConfigRequest class]]) {
    [self writeByte:172];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSpatializerRoomProperty class]]) {
    [self writeByte:173];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartASRCaptionRequest class]]) {
    [self writeByte:174];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioMixingRequest class]]) {
    [self writeByte:175];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartAudioRecordingRequest class]]) {
    [self writeByte:176];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartLastmileProbeTestRequest class]]) {
    [self writeByte:177];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartOrUpdateChannelMediaRelayRequest class]]) {
    [self writeByte:178];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPlayStreamingRequest class]]) {
    [self writeByte:179];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartPushStreamingRequest class]]) {
    [self writeByte:180];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartScreenCaptureRequest class]]) {
    [self writeByte:181];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStartorStopVideoPreviewRequest class]]) {
    [self writeByte:182];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTStreamingRoomInfo class]]) {
    [self writeByte:183];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteAudioRequest class]]) {
    [self writeByte:184];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamAudioRequest class]]) {
    [self writeByte:185];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteSubStreamVideoRequest class]]) {
    [self writeByte:186];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSubscribeRemoteVideoStreamRequest class]]) {
    [self writeByte:187];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTSwitchChannelRequest class]]) {
    [self writeByte:188];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserJoinedEvent class]]) {
    [self writeByte:189];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserLeaveEvent class]]) {
    [self writeByte:190];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTUserVideoMuteEvent class]]) {
    [self writeByte:191];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoFrame class]]) {
    [self writeByte:192];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkConfig class]]) {
    [self writeByte:193];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkImageConfig class]]) {
    [self writeByte:194];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTextConfig class]]) {
    [self writeByte:195];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVideoWatermarkTimestampConfig class]]) {
    [self writeByte:196];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[NEFLTVirtualBackgroundSourceEnabledEvent class]]) {
    [self writeByte:197];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface NEFLTNERtcStatsEventSinkCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation NEFLTNERtcStatsEventSinkCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[NEFLTNERtcStatsEventSinkCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[NEFLTNERtcStatsEventSinkCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *NEFLTNERtcStatsEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    NEFLTNERtcStatsEventSinkCodecReaderWriter *readerWriter =
        [[NEFLTNERtcStatsEventSinkCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

@interface NEFLTNERtcStatsEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcStatsEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onRtcStatsArguments:(NSDictionary<id, id> *)arg_arguments
                 channelTag:(NSString *)arg_channelTag
                 completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRtcStats"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalAudioStatsArguments:(NSDictionary<id, id> *)arg_arguments
                        channelTag:(NSString *)arg_channelTag
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onLocalAudioStats"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteAudioStatsArguments:(NSDictionary<id, id> *)arg_arguments
                         channelTag:(NSString *)arg_channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRemoteAudioStats"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onLocalVideoStatsArguments:(NSDictionary<id, id> *)arg_arguments
                        channelTag:(NSString *)arg_channelTag
                        completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onLocalVideoStats"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onRemoteVideoStatsArguments:(NSDictionary<id, id> *)arg_arguments
                         channelTag:(NSString *)arg_channelTag
                         completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onRemoteVideoStats"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onNetworkQualityArguments:(NSDictionary<id, id> *)arg_arguments
                       channelTag:(NSString *)arg_channelTag
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:
          @"dev.flutter.pigeon.nertc_core_platform_interface.NERtcStatsEventSink.onNetworkQuality"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcStatsEventSinkGetCodec()];
  [channel sendMessage:@[ arg_arguments ?: [NSNull null], arg_channelTag ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end

NSObject<FlutterMessageCodec> *NEFLTNERtcLiveStreamEventSinkGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface NEFLTNERtcLiveStreamEventSink ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation NEFLTNERtcLiveStreamEventSink

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onUpdateLiveStreamTaskTaskId:(NSString *)arg_taskId
                             errCode:(NSNumber *)arg_errCode
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcLiveStreamEventSink.onUpdateLiveStreamTask"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcLiveStreamEventSinkGetCodec()];
  [channel sendMessage:@[ arg_taskId ?: [NSNull null], arg_errCode ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onAddLiveStreamTaskTaskId:(NSString *)arg_taskId
                          errCode:(NSNumber *)arg_errCode
                       completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcLiveStreamEventSink.onAddLiveStreamTask"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcLiveStreamEventSinkGetCodec()];
  [channel sendMessage:@[ arg_taskId ?: [NSNull null], arg_errCode ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
- (void)onDeleteLiveStreamTaskTaskId:(NSString *)arg_taskId
                             errCode:(NSNumber *)arg_errCode
                          completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.nertc_core_platform_interface."
                             @"NERtcLiveStreamEventSink.onDeleteLiveStreamTask"
             binaryMessenger:self.binaryMessenger
                       codec:NEFLTNERtcLiveStreamEventSinkGetCodec()];
  [channel sendMessage:@[ arg_taskId ?: [NSNull null], arg_errCode ?: [NSNull null] ]
                 reply:^(id reply) {
                   completion(nil);
                 }];
}
@end
