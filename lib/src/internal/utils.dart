// Copyright (c) 2019-2020 NetEase, Inc. All right reserved.

part of nertc;

class _PlatformUtils {
  // Method Channel
  static const MethodChannel _kChannel = MethodChannel('nertc_flutter');

  static MethodChannel get methodChannel => _kChannel;
}
