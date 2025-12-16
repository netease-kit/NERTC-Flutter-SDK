// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

static NSString *const methodChannelName =
    @"com.netease.nertc_core.nertc_core_example.audio_session";

@interface AppDelegate ()

@property(nonatomic, strong) FlutterMethodChannel *methodChannel;

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [self initFlutter];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)initFlutter {
  UIViewController *vc = self.window.rootViewController;
  self.methodChannel = [FlutterMethodChannel methodChannelWithName:methodChannelName
                                                   binaryMessenger:vc];
  __weak typeof(self) wSelf = self;
  [self.methodChannel
      setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult result) {
        if ([call.method isEqualToString:@"setupAudioSession"]) {
          NSNumber *value = call.arguments;
          [wSelf setupAudioSession:value.integerValue];
          result(@(YES));
        } else if ([call.method isEqualToString:@"startPlayMusic"]) {
          [wSelf startPlayMusic];
          result(@(YES));
        } else if ([call.method isEqualToString:@"stopPlayMusic"]) {
          [wSelf stopPlayMusic];
          result(@(YES));
        } else {
          result(FlutterMethodNotImplemented);
        }
      }];
}

- (void)setupAudioSession:(NSInteger)audioScenario {
  NSString *category = AVAudioSessionCategoryPlayAndRecord;
  AVAudioSessionCategoryOptions categoryOptions = AVAudioSessionCategoryOptionAllowBluetooth |
                                                  AVAudioSessionCategoryOptionDefaultToSpeaker |
                                                  AVAudioSessionCategoryOptionMixWithOthers;

  NSError *error = nil;
  [[AVAudioSession sharedInstance] setCategory:category withOptions:categoryOptions error:&error];

  // audioProfile 默认或者speech 选择 AVAudioSessionModeVoiceChat，Music选择
  // AVAudioSessionModeDefault， 如果是chatroom 不建议自己控制
  NSString *mode = AVAudioSessionModeDefault;
  if (audioScenario == 1 /*kNERtcAudioScenarioSpeech*/ ||
      audioScenario == 0 /*kNERtcAudioScenarioDefault*/) {
    mode = AVAudioSessionModeVoiceChat;
  }

  [[AVAudioSession sharedInstance] setMode:mode error:&error];

  // Sometimes category options don't stick after setting mode.
  [[AVAudioSession sharedInstance] setCategory:category withOptions:categoryOptions error:&error];

  [[AVAudioSession sharedInstance] setActive:YES error:&error];
}

- (void)startPlayMusic {
  if (_audioPlayer != nil) return;

  NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"talent" ofType:@"mp3"];
  NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
  NSError *err = nil;
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
  _audioPlayer.numberOfLoops = -1;  // infinite loop
  [_audioPlayer play];
}

- (void)stopPlayMusic {
  if (_audioPlayer != nil) {
    [_audioPlayer stop];
  }
  _audioPlayer = nil;
}

@end
