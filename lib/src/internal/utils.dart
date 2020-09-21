// Copyright (c) 2014-2019 NetEase, Inc. All right reserved.

part of nertc;

class _PlatformUtils {
  // Method Channel
  static const MethodChannel _kChannel = MethodChannel('nertc_flutter');

  static MethodChannel get methodChannel => _kChannel;
}

