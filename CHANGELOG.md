## 5.9.11
* New features:
  - Set video streaming mode. `setVideoStreamLayerCount`
  - Data channel. `enableLocalData` `subscribeRemoteData` `sendData`
  - Push rtmp stream. `startPushStreaming` `stopPushStreaming`
  - Play live stream. `setupPlayStreamingCanvas` `startPlayStreaming` `stopPlayStreaming` `pausePlayStreaming` `resumePlayStreaming` `muteVideoForPlayStreaming` `muteAudioForPlayStreaming`
  - Turn on live captioning. `startASRCaption` `stopASRCaption`
  - Add AI NS mode. `setAINSMode`
  - Android/macOS platform supports network multipath. `setMultiPathOption`
  - macOS/Windows supports local recording. `addLocalRecorderStreamForTask` `removeLocalRecorderStreamForTask` `addLocalRecorderStreamLayoutForTask` `removeLocalRecorderStreamLayoutForTask` `updateLocalRecorderStreamlayoutForTask` `replaceLocalRecorderStreamLayoutForTask` `updateLocalRecorderWaterMarksForTask` `pushLocalRecorderVideoFrameForTask` `showLocalRecorderStreamDefaultCoverForTask` `stopLocalRecorderRemuxMp4` `remuxFlvToMp4` `stopRemuxFlvToMp4`
  - External audio/video input. `setExternalAudioSource` `pushExternalAudioFrame` `setExternalSubStreamAudioSource` `pushExternalSubAudioFrame`
  - Spatial sound effects. `initSpatializer` `enableSpatializer` `setSpatializerRenderMode` `setSpatializerRoomProperty` `enableSpatializerRoomEffects` `updateSelfPosition` `setAudioRecvRange` `setRangeAudioMode` `setRangeAudioTeamID`
* Sub-room function supplement.

## 5.9.1
* Support enableLoopback function on android platform.

## 5.9.0
* NERtc SDK dependency to 5.9.11.

## 5.8.2304
* Replace the yuv library with NEDyldYuv.

## 5.8.2303
* New interface added:
  - `setVideoRotationMode`
* Fixed ios `enableMediaPub` error.

## 5.8.2302
* Sub channel api added:
      - `subscribeRemoteSubVideoStream` 
      - `subscribeRemoteSubStreamAudio`

## 5.8.2301+1
* Fix channel release bug.

## 5.8.2301
* Android and iOS platforms support sub-channel interface.

## 5.8.23
* Support macOS, Windows platforms.
* NERtc SDK dependency to 5.8.23.

## 5.8.15
* Support iOS arm64 architecture simulator.
* Support iOS screenCapture feature.
* NERtc SDK dependency to 5.8.15.

## 5.5.101
* Support advanced token authentication.
* New interface added: 
      - `updatePermissionKey`
      - `onPermissionKeyWillExpire`
      - `onUpdatePermissionKey`
* Update error codes: `NERtcErrorCode`
* Resolve bundle version issues in iOS info.plist
* NERtc SDK dependency to 5.5.10.

## 5.5.10-rc.0
* NERtcParameters add two new keys: `KEY_DISABLE_FIRST_USER_CREATE_CHANNEL` and `KEY_START_WITH_BACK_CAMERA`.
* `NERtcVideoConfig.frontCamera` has been deprecated. We recommend setting `KEY_START_WITH_BACK_CAMERA` using `setParameters`.
* NERtc SDK dependency to base-5.5.10.

## 5.4.701
* Bugfix: create instance incoming callback failure issue
* Add missing comments
* The `NERtcVideoView` interface has been deprecated and developers are encouraged to use the `NERtcVideoView.withInternalRenderer` interface instead.
* NERtc SDK dependency to 5.4.7

## 5.4.7
* Added `setExternalVideoSource` API to enable external video source data input.
* Added `pushExternalVideoFrame` API to push external video data frames for processing.
* Upgrade NERtc SDK dependency to 5.4.7

## 5.4.0
* Upgrade NERtc SDK dependency to 5.4.0

## 5.4.0-rc.0
* Upgrade NERtc SDK dependency to 5.4.0

## 4.6.52-rc.1
* Upgrade NERtc SDK dependency to 4.6.52

## 4.6.52-rc.0
* Upgrade NERtc SDK dependency to 4.6.52

## 4.6.43-rc.0
* Upgrade NERtc SDK dependency to 4.6.43

## 4.4.147-rc.0
* Upgrade Android NERtc SDK dependency to 4.4.147

## 4.4.146-rc.0
* Upgrade Android NERtc SDK dependency to 4.4.146

## 4.4.145-dev.0
* Upgrade Android NERtc SDK dependency to 4.4.145-SNAPSHOT

## 4.4.143-rc.0
* Upgrade NERtc SDK dependency to 4.4.143

## 4.4.142-rc.0
* Upgrade NERtc SDK dependency to 4.4.142

## 4.4.14-rc.0
* Add `NERtcOptions.videoAutoSubscribe` to subscribe remote video automatically.
* Add `NERtcOptions.disableFirstJoinUserCreateChannel` to disable create channel when first user join.
* Upgrade NERtc SDK dependency to 4.4.140

## 4.4.13-rc.0
* Upgrade NERtc SDK dependency to 4.4.13 for Android

## 4.4.11-rc.0
* Upgrade NERtc SDK to 4.4.11
* Add `setCameraCaptureConfig` API to configure camera capture profiles.

## 4.4.9-rc.0
* Upgrade NERtc SDK to 4.4.9

## 4.4.8-rc.0
* Upgrade NERtc SDK to 4.4.8

## 4.4.7-rc.0
* Upgrade NERtc SDK to 4.4.7

## 4.4.6-rc.0
* Upgrade NERtc SDK to 4.4.6

## 4.4.2-rc.8
* Fix create engine error

## 4.4.2-rc.7
* Add `NERtcServerAddresses` class to configure server addresses.

## 4.4.2-rc.6
* Fix iOS crash when dealing with `onNERtcEngineRecvSEIMsg`

## 4.4.2-rc.5
* Fix Android NullPointerException

## 4.4.2-rc.4
* Fix Android NullPointerException

## 4.4.2-rc.3
* Fix iOS rtc event callbacks

## 4.4.2-rc.2
* Fix iOS setParameters

## 4.4.2-rc.1
* Always enable local audio volume report

## 4.4.2-rc.0
* Upgrade NERtc SDK to 4.4.2
  
## 4.4.0-rc.1
* Upgrade NERtc SDK to 4.4.0

## 4.3.1-rc.2
* Upgrade NERtc SDK to 4.3.1

## 4.2.149-rc.0
* Update to NERtc SDK 4.2.149

## 4.2.1-rc.4
* Fixed media relay error

## 4.2.1-rc.3
* Fixed ios `startScreenCapture` error
* Fixed ios `stopScreenCapture` error

## 4.2.1-rc.2
* Upgrade NERtc SDK to 4.2.1

## 4.1.1-rc.2
* adapt flutter version 2.2.3+

## 4.1.1-rc.1
* fix android init error

## 4.1.1-rc.0
* Upgrade NERtc SDK to 4.1.1

## 4.1.0-rc.2
* Upgrade NERtc SDK to 4.1.1

## 3.9.0
* Upgrade NERtc SDK to 3.9.0

## 0.3.8+1
* Upgrade NERtc SDK to 3.8.1

## 0.3.7+2
* Fixed video view error

## 0.3.7+1
* Fixed iOS `setAudioProfile` error

## 0.3.7
* Upgrade NERtc SDK to 3.7.0

## 0.3.6+4
* Fixed `enableLocalVideo` error

## 0.3.6+3
* Initial release
