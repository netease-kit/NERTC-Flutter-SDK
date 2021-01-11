# nertc
[![build Status](https://github.com/netease-im/NERTC-Flutter-SDK/workflows/build/badge.svg)](https://github.com/netease-im/NERTC-Flutter-SDK/actions) [![pub package](https://img.shields.io/pub/v/nertc.svg)](https://pub.dev/packages/nertc)

Flutter plugin for NetEase RTC SDK.

## Usage
Add `nertc` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### iOS

Add two rows to the `ios/Runner/Info.plist`:

* one with the key `Privacy - Camera Usage Description` and a usage description.
* and one with the key `Privacy - Microphone Usage Description` and a usage description.

Or in text format add the key:

```xml
<key>NSCameraUsageDescription</key>
<string>Can I use the camera please?</string>
<key>NSMicrophoneUsageDescription</key>
<string>Can I use the mic please?</string>
```

### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```
minSdkVersion 21
```