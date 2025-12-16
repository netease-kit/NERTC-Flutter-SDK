// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nertc_core_platform_interface/nertc_core_platform_interface.dart';

class Utils {
  static String videoDeviceState2String(int state) {
    switch (state) {
      case 0:
        return 'initialized';
      case 1:
        return 'opened';
      case 2:
        return 'closed';
      case 3:
        return 'disconnected';
      case 4:
        return 'freezed';
      case 5:
        return 'unknownError';
      case 6:
        return 'unInitialized';
      default:
        return 'state:$state';
    }
  }

  static String audioDeviceType2String(int type) {
    switch (type) {
      case 1:
        return 'record';
      case 2:
        return 'playout';
      default:
        return 'type:$type';
    }
  }

  static String audioDeviceState2String(int state) {
    switch (state) {
      case 0:
        return 'initialized';
      case 1:
        return 'opened';
      case 2:
        return 'closed';
      case 3:
        return 'initializationError';
      case 4:
        return 'startError';
      case 5:
        return 'unknownError';
      case 6:
        return 'unInitialized';
      default:
        return 'state:$state';
    }
  }

  static String audioDevice2String(int device) {
    switch (device) {
      case 0:
        return 'speakerPhone';
      case 1:
        return 'wiredHeadset';
      case 2:
        return 'earpiece';
      case 3:
        return 'bluetoothHeadset';
      default:
        return 'device:$device';
    }
  }

  static String liveStreamState2String(int state) {
    switch (state) {
      case 505:
        return 'pushing';
      case 506:
        return 'pushFail';
      case 511:
        return 'pushStopped';
      case 512:
        return 'imageError';
      default:
        return 'state:$state';
    }
  }

  static String connectionState2String(int state) {
    switch (state) {
      case 0:
        return 'unknown';
      case 1:
        return 'disconnected';
      case 2:
        return 'connecting';
      case 3:
        return 'connected';
      case 4:
        return 'reconnecting';
      case 5:
        return 'failed';
      default:
        return 'state:$state';
    }
  }

  static String connectionStateChangeReason2String(int reason) {
    switch (reason) {
      case 1:
        return 'leaveChannel';
      case 2:
        return 'channelClosed';
      case 3:
        return 'serverKicked';
      case 4:
        return 'timeout';
      case 5:
        return 'joinChannel';
      case 6:
        return 'joinSucceed';
      case 7:
        return 'rejoinSucceed';
      case 8:
        return 'mediaConnectionDisconnected';
      case 9:
        return 'signalDisconnected';
      case 10:
        return 'requestChannelFailed';
      case 11:
        return 'joinChannelFailed';
      default:
        return 'reason:$reason';
    }
  }

  static String videoProfile2String(int profile) {
    switch (profile) {
      case 1:
        return 'low';
      case 2:
        return 'standard';
      case 3:
        return 'hd720p';
      case 4:
        return 'hd1080p';
      default:
        return 'profile:$profile';
    }
  }

  static String connectionType2String(int type) {
    switch (type) {
      case 0:
        return 'unknown';
      case 1:
        return 'ethernet';
      case 2:
        return 'wifi';
      case 3:
        return 'cellular4g';
      case 4:
        return 'cellular3g';
      case 5:
        return 'cellular2g';
      case 6:
        return 'cellularUnknown';
      case 7:
        return 'bluetooth';
      case 8:
        return 'vpn';
      case 9:
        return 'none';
      default:
        return 'type:$type';
    }
  }

  static String mediaRelayEvent2String(int event) {
    switch (event) {
      case NERtcChannelMediaRelayEvent.disconnect:
        return 'disconnect';
      case NERtcChannelMediaRelayEvent.connecting:
        return 'connecting';
      case NERtcChannelMediaRelayEvent.connected:
        return 'connected';
      case NERtcChannelMediaRelayEvent.videoSentSuccess:
        return 'videoSentSuccess';
      case NERtcChannelMediaRelayEvent.audioSentSuccess:
        return 'audioSentSuccess';
      case NERtcChannelMediaRelayEvent.otherStreamSentSuccess:
        return 'otherStreamSentSuccess';
      case NERtcChannelMediaRelayEvent.failure:
        return 'failure';
      default:
        return 'unknown';
    }
  }

  static String mediaRelayState2String(int state) {
    switch (state) {
      case NERtcChannelMediaRelayState.idle:
        return 'idle';
      case NERtcChannelMediaRelayState.connecting:
        return 'connecting';
      case NERtcChannelMediaRelayState.running:
        return 'running';
      case NERtcChannelMediaRelayState.failure:
        return 'failure';
      default:
        return 'unknown';
    }
  }
}
