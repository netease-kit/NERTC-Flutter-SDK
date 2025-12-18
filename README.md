# nertc_core

[![build Status](https://github.com/netease-im/NERTC-Flutter-SDK/workflows/build/badge.svg)](https://github.com/netease-im/NERTC-Flutter-SDK/actions) [![pub package](https://img.shields.io/pub/v/nertc_core.svg)](https://pub.dev/packages/nertc_core)

Flutter plugin for NetEase RTC SDK, currently supports Android/iOS/macOS/Windows platforms.

## Introduce

NetEase Real-Time Communication (NERTC) is a Real-Time Communication development platform designed for efficient audio and video communication services. Based on Netease's years of technical accumulation of instant communication and Real-Time Communication capabilities, NERTC provides you with stable, smooth, high-quality, full-platform point-to-point and multi-person Real-Time Communication services.

For more product descriptions, please see [homepage](https://doc.yunxin.163.com/nertc/guide/Dc0NTg0NzM?platform=flutter).

## Installation

Run this command at your project root path: 

```
 $ flutter pub add nertc_core
```

For more information, please see `Installing`.

## Usage

Now in your Dart code, you can use:

```dart
import 'package:nertc_core/nertc_core.dart';
```

Import it into your project. 

To ensure that your project can function properly with the SDK, you need to add the following configuration to your project.


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

### macOS

Add two rows to the `macOS/Runner/Info.plist`:

* one with the key `Privacy - Camera Usage Description` and a usage description.
* and one with the key `Privacy - Microphone Usage Description` and a usage description.

Or in text format add the key:

```xml
<key>NSCameraUsageDescription</key>
<string>Can I use the camera please?</string>
<key>NSMicrophoneUsageDescription</key>
<string>Can I use the mic please?</string>
```

For more usage, please refer to the samplecode provided on github, [click it](https://github.com/netease-im/NERTC-Flutter-SDK).

## Contact us

- If you are having trouble, you can read the [Documentation Center](https://doc.yunxin.163.com/).
- If you need after-sales technical support, you can submit a ticket in the [Netease cloud console](https://app.yunxin.163.com/index#/issue/submit).



