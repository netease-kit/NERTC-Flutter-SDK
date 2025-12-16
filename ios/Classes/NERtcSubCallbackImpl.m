// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NERtcSubCallbackImpl.h"

@interface NERtcSubCallbackImpl ()

@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, strong) NEFLTNERtcSubChannelEventSink *eventSink;

@end

@implementation NERtcSubCallbackImpl

- (instancetype)initWithChannelName:(NSString *)channelName
                    binaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger {
  self = [super init];
  if (self) {
    _channelName = channelName;
    _eventSink = [[NEFLTNERtcSubChannelEventSink alloc] initWithBinaryMessenger:binaryMessenger];
  }
  return self;
}

- (void)dispose {
  _eventSink = nil;
  _channelName = nil;
}

- (void)onNERtcChannelDidJoinChannelWithResult:(NERtcError)result
                                     channelId:(uint64_t)channelId
                                       elapsed:(uint64_t)elapsed
                                        userID:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onJoinChannelChannelTag:_channelName
                                 result:@(result)
                              channelId:@(channelId)
                                elapsed:@(elapsed)
                                    uid:@(userID)
                             completion:^(FlutterError *_Nullable error){
                                 // 处理完成回调
                             }];
  }
}

- (void)onNERtcChannelDidTakeSnapshotWithResult:(NSNumber *)code path:(NSString *)path {
  if (_eventSink) {
    [_eventSink onTakeSnapshotResultChannelTag:_channelName
                                          code:code
                                          path:path
                                    completion:^(FlutterError *_Nullable error){
                                        // 处理完成回调
                                    }];
  }
}

#pragma mark - NERtcChannelDelegate

- (void)onNERtcChannelDidLeaveChannelWithResult:(NERtcError)result {
  if (_eventSink) {
    [_eventSink onLeaveChannelChannelTag:_channelName
                                  result:@(result)
                              completion:^(FlutterError *_Nullable error){
                                  // 处理完成回调
                              }];
  }
}

- (void)onNERtcChannelUserDidJoinWithUserID:(uint64_t)userID userName:(NSString *)userName {
  // 使用废弃的方法，保持兼容性
}

- (void)onNERtcChannelUserDidJoinWithUserID:(uint64_t)userID
                                   userName:(NSString *)userName
                              joinExtraInfo:(NERtcUserJoinExtraInfo *)joinExtraInfo {
  if (_eventSink) {
    NEFLTNERtcUserJoinExtraInfo *info =
        [NEFLTNERtcUserJoinExtraInfo makeWithCustomInfo:joinExtraInfo.customInfo];
    NEFLTUserJoinedEvent *event =
        [NEFLTUserJoinedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                            joinExtraInfo:info];

    [_eventSink onUserJoinedChannelTag:_channelName
                                 event:event
                            completion:^(FlutterError *_Nullable error){
                                // 处理完成回调
                            }];
  }
}

- (void)onNERtcChannelUserDidLeaveWithUserID:(uint64_t)userID
                                      reason:(NERtcSessionLeaveReason)reason {
  // 使用废弃的方法，保持兼容性
}

- (void)onNERtcChannelUserDidLeaveWithUserID:(uint64_t)userID
                                      reason:(NERtcSessionLeaveReason)reason
                              leaveExtraInfo:(NERtcUserLeaveExtraInfo *)leaveExtraInfo {
  if (_eventSink) {
    NEFLTNERtcUserLeaveExtraInfo *info =
        [NEFLTNERtcUserLeaveExtraInfo makeWithCustomInfo:leaveExtraInfo.customInfo];

    NEFLTUserLeaveEvent *event =
        [NEFLTUserLeaveEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                  reason:[NSNumber numberWithInteger:reason]
                          leaveExtraInfo:info];

    [_eventSink onUserLeaveChannelTag:_channelName
                                event:event
                           completion:^(FlutterError *_Nullable error){
                               // 处理完成回调
                           }];
  }
}

- (void)onNERtcChannelUserAudioDidStart:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserAudioStartChannelTag:_channelName
                                       uid:@(userID)
                                completion:^(FlutterError *_Nullable error){
                                    // 处理完成回调
                                }];
  }
}

- (void)onNERtcChannelUserAudioDidStop:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserAudioStopChannelTag:_channelName
                                      uid:@(userID)
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

- (void)onNERtcChannelUser:(uint64_t)userID audioMuted:(BOOL)muted {
  if (_eventSink) {
    [_eventSink onUserAudioMuteChannelTag:_channelName
                                      uid:@(userID)
                                    muted:@(muted)
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

- (void)onNERtcChannelUserSubStreamAudioDidStart:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserSubStreamAudioStartChannelTag:_channelName
                                                uid:@(userID)
                                         completion:^(FlutterError *_Nullable error){
                                             // 处理完成回调
                                         }];
  }
}

- (void)onNERtcChannelUserSubStreamAudioDidStop:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserSubStreamAudioStopChannelTag:_channelName
                                               uid:@(userID)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelUser:(uint64_t)userID subStreamAudioMuted:(BOOL)muted {
  if (_eventSink) {
    [_eventSink onUserSubStreamAudioMuteChannelTag:_channelName
                                               uid:@(userID)
                                             muted:@(muted)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelUserVideoDidStartWithUserID:(uint64_t)userID
                                     videoProfile:(NERtcVideoProfileType)profile {
  if (_eventSink) {
    [_eventSink onUserVideoStartChannelTag:_channelName
                                       uid:@(userID)
                                maxProfile:@(profile)
                                completion:^(FlutterError *_Nullable error){
                                    // 处理完成回调
                                }];
  }
}

- (void)onNERtcChannelUserVideoStreamDidStart:(uint64_t)userID
                                   streamType:(NERtcStreamChannelType)streamType
                                streamProfile:(NERtcVideoProfileType)profile {
  // 处理新版本的视频开始回调
  if (streamType == kNERtcStreamChannelTypeMainStream) {
    // 这里就不处理了，onNERtcChannelUserVideoDidStartWithUserID 会执行到。
    //[self onNERtcChannelUserVideoDidStartWithUserID:userID videoProfile:profile];
  } else if (streamType == kNERtcStreamChannelTypeSubStream) {
    if (_eventSink) {
      [_eventSink onUserSubStreamVideoStartChannelTag:_channelName
                                                  uid:@(userID)
                                           maxProfile:@(profile)
                                           completion:^(FlutterError *_Nullable error){
                                               // 处理完成回调
                                           }];
    }
  }
}

- (void)onNERtcChannelUserSubStreamDidStartWithUserID:(uint64_t)userID
                                     subStreamProfile:(NERtcVideoProfileType)profile {
  // 处理辅流视频开始回调（屏幕共享）
  if (_eventSink) {
    [_eventSink onUserSubStreamVideoStartChannelTag:_channelName
                                                uid:@(userID)
                                         maxProfile:@(profile)
                                         completion:^(FlutterError *_Nullable error){
                                             // 处理完成回调
                                         }];
  }
}

// 主流回调
- (void)onNERtcChannelUserVideoDidStop:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserVideoStopChannelTag:_channelName
                                      uid:@(userID)
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

// 辅流回调
- (void)onNERtcChannelUserSubStreamDidStop:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onUserSubStreamVideoStopChannelTag:_channelName
                                               uid:@(userID)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelUser:(uint64_t)userID videoMuted:(BOOL)muted {
  // 处理视频静音回调
  if (_eventSink) {
    NEFLTUserVideoMuteEvent *event = [NEFLTUserVideoMuteEvent
        makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
              muted:[NSNumber numberWithBool:muted]
         streamType:[NSNumber numberWithUnsignedInteger:kNERtcAudioStreamMain]];

    [_eventSink onUserVideoMuteChannelTag:_channelName
                                    event:event
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

- (void)onNERtcChannelConnectionStateChangeWithState:(NERtcConnectionStateType)state
                                              reason:(NERtcReasonConnectionChangedType)reason {
  if (_eventSink) {
    [_eventSink onConnectionStateChangedChannelTag:_channelName
                                             state:@(state)
                                            reason:@(reason)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelDidClientRoleChanged:(NERtcClientRole)oldRole
                                   newRole:(NERtcClientRole)newRole {
  if (_eventSink) {
    [_eventSink onClientRoleChangeChannelTag:_channelName
                                     oldRole:@(oldRole)
                                     newRole:@(newRole)
                                  completion:^(FlutterError *_Nullable error){
                                      // 处理完成回调
                                  }];
  }
}

- (void)onNERtcChannelDidDisconnectWithReason:(NERtcError)reason {
  if (_eventSink) {
    [_eventSink onDisconnectChannelTag:_channelName
                                reason:@(reason)
                            completion:^(FlutterError *_Nullable error){
                                // 处理完成回调
                            }];
  }
}

- (void)onNERtcChannelFirstAudioDataDidReceiveWithUserID:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onFirstAudioDataReceivedChannelTag:_channelName
                                               uid:@(userID)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelFirstVideoDataDidReceiveWithUserID:(uint64_t)userID {
  // 使用废弃的方法，保持兼容性
}

- (void)onNERtcChannelFirstVideoDataDidReceiveWithUserID:(uint64_t)userID
                                              streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
    NEFLTFirstVideoDataReceivedEvent *event =
        [NEFLTFirstVideoDataReceivedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                           streamType:type];

    [_eventSink onFirstVideoDataReceivedChannelTag:_channelName
                                             event:event
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelFirstAudioFrameDidDecodeWithUserID:(uint64_t)userID {
  if (_eventSink) {
    [_eventSink onFirstAudioFrameDecodedChannelTag:_channelName
                                               uid:@(userID)
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelFirstVideoFrameDecoded:(uint64_t)userID
                                       width:(uint32_t)width
                                      height:(uint32_t)height {
  // 使用废弃的方法，保持兼容性
}

- (void)onNERtcChannelFirstVideoFrameDecoded:(uint64_t)userID
                                       width:(uint32_t)width
                                      height:(uint32_t)height
                                  streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    NSNumber *type = [NSNumber numberWithUnsignedInteger:streamType];
    NEFLTFirstVideoFrameDecodedEvent *event =
        [NEFLTFirstVideoFrameDecodedEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                                width:[NSNumber numberWithUnsignedInt:width]
                                               height:[NSNumber numberWithUnsignedInt:height]
                                           streamType:type];

    [_eventSink onFirstVideoFrameDecodedChannelTag:_channelName
                                             event:event
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelReconnectingStart {
  if (_eventSink) {
    [_eventSink onReconnectingStartChannelTag:_channelName
                                   completion:^(FlutterError *_Nullable error){
                                       // 处理完成回调
                                   }];
  }
}

- (void)onNERtcChannelRejoinChannel:(NERtcError)result {
  if (_eventSink) {
    [_eventSink onReJoinChannelChannelTag:_channelName
                                   result:@(result)
                                channelId:@(0)
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

- (void)onLocalAudioVolumeIndication:(int)volume withVad:(BOOL)vadFlag {
  if (_eventSink) {
    [_eventSink onLocalAudioVolumeIndicationChannelTag:_channelName
                                                volume:@(volume)
                                               vadFlag:@(vadFlag)
                                            completion:^(FlutterError *_Nullable error){
                                                // 处理完成回调
                                            }];
  }
}

- (void)onRemoteAudioVolumeIndication:(NSArray<NERtcAudioVolumeInfo *> *)speakers
                          totalVolume:(int)totalVolume {
  if (_eventSink && speakers.count > 0) {
    NSMutableArray<NEFLTAudioVolumeInfo *> *speaker = [[NSMutableArray alloc] init];
    for (NERtcAudioVolumeInfo *item in speakers) {
      NEFLTAudioVolumeInfo *info = [NEFLTAudioVolumeInfo
              makeWithUid:[NSNumber numberWithUnsignedLongLong:item.uid]
                   volume:[NSNumber numberWithUnsignedInteger:item.volume]
          subStreamVolume:[NSNumber numberWithUnsignedInteger:item.subStreamVolume]];
      [speaker addObject:info];
    }

    NEFLTRemoteAudioVolumeIndicationEvent *event = [NEFLTRemoteAudioVolumeIndicationEvent
        makeWithVolumeList:speaker
               totalVolume:[NSNumber numberWithInt:totalVolume]];

    [_eventSink onRemoteAudioVolumeIndicationChannelTag:_channelName
                                                  event:event
                                             completion:^(FlutterError *_Nullable error){
                                                 // 处理完成回调
                                             }];
  }
}

- (void)onNERtcChannelLiveStreamState:(NERtcLiveStreamStateCode)state
                               taskID:(NSString *)taskID
                                  url:(NSString *)url {
  if (_eventSink) {
    [_eventSink onLiveStreamStateChannelTag:_channelName
                                     taskId:taskID
                                    pushUrl:url
                                  liveState:[NSNumber numberWithInteger:state]
                                 completion:^(FlutterError *_Nullable error){
                                     // 处理完成回调
                                 }];
  }
}

- (void)onNERtcChannelDidError:(NERtcError)errCode {
  if (_eventSink) {
    [_eventSink onErrorChannelTag:_channelName
                             code:@(errCode)
                       completion:^(FlutterError *_Nullable error){
                           // 处理完成回调
                       }];
  }
}

- (void)onNERtcChannelDidWarning:(NERtcWarning)warnCode msg:(NSString *)msg {
  if (_eventSink) {
    [_eventSink onWarningChannelTag:_channelName
                               code:@(warnCode)
                         completion:^(FlutterError *_Nullable error){
                             // 处理完成回调
                         }];
  }
}

- (void)onNERtcChannelRecvSEIMsg:(uint64_t)userID message:(NSData *)message {
  if (_eventSink) {
    NSString *msg = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
    [_eventSink onRecvSEIMsgChannelTag:_channelName
                                userID:@(userID)
                                seiMsg:msg
                            completion:^(FlutterError *_Nullable error){
                                // 处理完成回调
                            }];
  }
}

- (void)onNERtcChannelMediaRelayStateDidChange:(NERtcChannelMediaRelayState)state
                                   channelName:(NSString *)channelName {
  if (_eventSink) {
    [_eventSink onMediaRelayStatesChangeChannelTag:_channelName
                                             state:@(state)
                                       channelName:channelName
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelDidReceiveChannelMediaRelayEvent:(NERtcChannelMediaRelayEvent)event
                                           channelName:(NSString *)channelName
                                             errorCode:(NERtcError)error {
  if (_eventSink) {
    [_eventSink onMediaRelayReceiveEventChannelTag:_channelName
                                             event:@(event)
                                              code:@(error)
                                       channelName:channelName
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelLocalPublishFallbackToAudioOnly:(BOOL)isFallback
                                           streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    [_eventSink onLocalPublishFallbackToAudioOnlyChannelTag:_channelName
                                                 isFallback:@(isFallback)
                                                 streamType:@(streamType)
                                                 completion:^(FlutterError *_Nullable error){
                                                     // 处理完成回调
                                                 }];
  }
}

- (void)onNERtcChannelRemoteSubscribeFallbackToAudioOnly:(uint64_t)userID
                                              isFallback:(BOOL)isFallback
                                              streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    [_eventSink onRemoteSubscribeFallbackToAudioOnlyChannelTag:_channelName
                                                           uid:@(userID)
                                                    isFallback:@(isFallback)
                                                    streamType:@(streamType)
                                                    completion:^(FlutterError *_Nullable error){
                                                        // 处理完成回调
                                                    }];
  }
}

- (void)onNERtcChannelUserVideoStreamDidStop:(uint64_t)userID
                                  streamType:(NERtcStreamChannelType)streamType {
  // 处理新版本的视频停止回调
  if (streamType == kNERtcStreamChannelTypeMainStream) {
    // 调用废弃的方法，保持兼容性
    [self onNERtcChannelUserVideoDidStop:userID];
  } else if (streamType == kNERtcStreamChannelTypeSubStream) {
    // 调用辅流停止方法
    [self onNERtcChannelUserSubStreamDidStop:userID];
  }
}

- (void)onNERtcChannelUser:(uint64_t)userID
                videoMuted:(BOOL)muted
                streamType:(NERtcStreamChannelType)streamType {
  // 处理带 streamType 的视频静音回调
  if (_eventSink) {
    NSNumber *streamTypeNumber = [NSNumber numberWithUnsignedInteger:streamType];
    NEFLTUserVideoMuteEvent *event =
        [NEFLTUserVideoMuteEvent makeWithUid:[NSNumber numberWithUnsignedLongLong:userID]
                                       muted:[NSNumber numberWithBool:muted]
                                  streamType:streamTypeNumber];

    [_eventSink onUserVideoMuteChannelTag:_channelName
                                    event:event
                               completion:^(FlutterError *_Nullable error){
                                   // 处理完成回调
                               }];
  }
}

- (void)onNERtcChannelFirstVideoFrameRender:(uint64_t)userID
                                      width:(uint32_t)width
                                     height:(uint32_t)height
                                    elapsed:(uint64_t)elapsed
                                 streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    [_eventSink onFirstVideoFrameRenderChannelTag:_channelName
                                           userID:[NSNumber numberWithUnsignedLongLong:userID]
                                       streamType:[NSNumber numberWithUnsignedInteger:streamType]
                                            width:[NSNumber numberWithUnsignedInt:width]
                                           height:[NSNumber numberWithUnsignedInt:height]
                                      elapsedTime:[NSNumber numberWithUnsignedLongLong:elapsed]
                                       completion:^(FlutterError *_Nullable error){
                                           // 处理完成回调
                                       }];
  }
}

- (void)onNERtcChannelRemoteVideoSizeDidChangedWithUserID:(uint64_t)userID
                                                    width:(uint32_t)width
                                                   height:(uint32_t)height
                                               streamType:(NERtcStreamChannelType)streamType {
  if (_eventSink) {
    [_eventSink onRemoteVideoSizeChangedChannelTag:_channelName
                                            userId:[NSNumber numberWithUnsignedLongLong:userID]
                                         videoType:[NSNumber numberWithUnsignedInteger:streamType]
                                             width:[NSNumber numberWithUnsignedInt:width]
                                            height:[NSNumber numberWithUnsignedInt:height]
                                        completion:^(FlutterError *_Nullable error){
                                            // 处理完成回调
                                        }];
  }
}

- (void)onNERtcChannelLocalVideoRenderSizeChanged:(NERtcStreamChannelType)streamType
                                            width:(uint32_t)width
                                           height:(uint32_t)height {
  if (_eventSink) {
    [_eventSink
        onLocalVideoRenderSizeChangedChannelTag:_channelName
                                      videoType:[NSNumber numberWithUnsignedInteger:streamType]
                                          width:[NSNumber numberWithUnsignedInt:width]
                                         height:[NSNumber numberWithUnsignedInt:height]
                                     completion:^(FlutterError *_Nullable error){
                                         // 处理完成回调
                                     }];
  }
}

- (void)onLocalAudioVolumeIndication:(int)volume {
  // 调用带 VAD 的版本，vadFlag 默认为 NO
  [self onLocalAudioVolumeIndication:volume withVad:NO];
}

- (void)onNERtcChannelMediaRightChangeWithAudio:(BOOL)isAudioBannedByServer
                                          video:(BOOL)isVideoBannedByServer {
  if (_eventSink) {
    [_eventSink onMediaRightChangeChannelTag:_channelName
                       isAudioBannedByServer:[NSNumber numberWithBool:isAudioBannedByServer]
                       isVideoBannedByServer:[NSNumber numberWithBool:isVideoBannedByServer]
                                  completion:^(FlutterError *_Nullable error){
                                      // 处理完成回调
                                  }];
  }
}

- (void)onNERtcChannelApiDidExecuted:(NSString *)apiName
                             errCode:(NERtcError)errCode
                                 msg:(NSString *)msg {
  if (_eventSink) {
    [_eventSink onApiCallExecutedChannelTag:_channelName
                                    apiName:apiName
                                     result:[NSNumber numberWithInt:errCode]
                                    message:msg
                                 completion:^(FlutterError *_Nullable error){
                                     // 处理完成回调
                                 }];
  }
}

- (void)onNERtcChannelPermissionKeyWillExpire {
  if (_eventSink) {
    [_eventSink onPermissionKeyWillExpireChannelTag:_channelName
                                         completion:^(FlutterError *_Nullable error){
                                             // 处理完成回调
                                         }];
  }
}

- (void)onNERtcChannelUpdatePermissionKey:(NSString *)key
                                    error:(NERtcError)error
                                  timeout:(NSUInteger)timeout {
  if (_eventSink) {
    [_eventSink onUpdatePermissionKeyChannelTag:_channelName
                                            key:key
                                          error:[NSNumber numberWithInt:error]
                                        timeout:[NSNumber numberWithUnsignedInteger:timeout]
                                     completion:^(FlutterError *_Nullable error){
                                         // 处理完成回调
                                     }];
  }
}

- (void)onNERtcChannelLabFeatureDidCallbackWithKey:(NSString *)key param:(id)param {
  if (_eventSink && key != nil && param != nil) {
    // 将 id param 转换为 NSDictionary<id, id>
    NSDictionary<id, id> *paramDict;
    if ([param isKindOfClass:[NSDictionary class]]) {
      paramDict = (NSDictionary<id, id> *)param;
    } else {
      // 如果不是 Dictionary，创建一个包含该对象的 Dictionary
      paramDict = @{@"value" : param};
    }
    [_eventSink onLabFeatureCallbackChannelTag:_channelName
                                           key:key
                                         param:paramDict
                                    completion:^(FlutterError *_Nullable error){
                                        // 处理完成回调
                                    }];
  }
}

@end
