// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nertc;

class LogOptions {
  /// 是否开启 Flutter 端日志输出
  static bool flutterLogEnabled = true;

  /// 当前是否支持日志输出
  static bool get isSupported =>
      flutterLogEnabled && (Platform.isIOS || Platform.isAndroid);
}

class _LogService {
  static const pathSegmentRtc = 'NERtcSDK';
  static const pathSegmentLog = 'log';

  static final _LogService _instance = _LogService._();

  _LogService._();

  factory _LogService() => _instance;

  String? _rootPath;

  String? get rtcLogDir {
    final path = _rootPath;
    if (path != null && Platform.isIOS) {
      final index = path.lastIndexOf(RegExp(pathSegmentLog));
      return path.substring(0, index);
    }
    return path;
  }

  String calculateMagicHash(String input) {
    final value = sha1.convert(utf8.encode(input)).toString();
    return '${input.substring(0, 5)}_$value';
  }

  Future<bool> init(String appkey, int? logLevel, String? logDir) async {
    if (!LogOptions.isSupported) {
      return false;
    }
    if (_rootPath != null) {
      return true;
    }
    final level = determineALogLevel(logLevel ?? NERtcLogLevel.info);
    final path = await ensureALogPath(logDir, calculateMagicHash(appkey));
    if (path == null) {
      return false;
    }
    final success = Alog.init(level, path, 'flt_nertc_sdk');
    print(
        'ALogService init result: level=$level, path=$path, success=$success');
    if (success) {
      _rootPath = path;
    }
    return success;
  }

  ALogLevel determineALogLevel(int logLevel) {
    switch (logLevel) {
      case NERtcLogLevel.fatal:
      case NERtcLogLevel.error:
        return ALogLevel.error;
      case NERtcLogLevel.warning:
        return ALogLevel.warning;
      case NERtcLogLevel.debug:
        return ALogLevel.debug;
      case NERtcLogLevel.verbose:
        return ALogLevel.verbose;
      default:
        return ALogLevel.info;
    }
  }

  Future<String?> ensureALogPath(
      String? logDir, String iosExtraPathSegment) async {
    try {
      String? path;
      if (logDir == null || logDir.isEmpty) {
        path = await getDefaultLogPath();
      } else {
        path = logDir;
      }
      if (path != null) {
        path = path.endsWith('/') ? path : '$path/';

        /// iOS NERtc SDK 会在自定义路径后添加 `log/{iosExtraPathSegment}` 文件夹
        if (Platform.isIOS) {
          path = '$path$pathSegmentLog/$iosExtraPathSegment/';
        }
        return (await Directory(path).create(recursive: true)).path;
      }
    } catch (e) {
      print('ALogService ensure log path exception: $e');
    }
    return null;
  }

  Future<String?> getDefaultLogPath() async {
    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/$pathSegmentRtc';
    } else if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return '${directory.path}/$pathSegmentRtc/$pathSegmentLog';
      }
    } else {
      print('ALogService unsupported platform: ${Platform.operatingSystem}');
    }
    return null;
  }
}

/// @nodoc
class Logger {
  const Logger();

  void v(String content) {}

  void d(String content) {}

  void i(String content) {}

  void w(String content) {}

  void e(String content) {}

  void test(String content) {}
}

class _ALogger extends Logger {
  final String tag;
  final String module;
  final AlogType type;

  _ALogger.api(this.tag, this.module) : type = AlogType.api;

  _ALogger.normal(this.tag, this.module) : type = AlogType.normal;

  void v(String content) {
    Alog.v(tag: tag, type: type, moduleName: module, content: content);
  }

  void d(String content) {
    Alog.d(tag: tag, type: type, moduleName: module, content: content);
  }

  void i(String content) {
    Alog.i(tag: tag, type: type, moduleName: module, content: content);
  }

  void w(String content) {
    Alog.w(tag: tag, type: type, moduleName: module, content: content);
  }

  void e(String content) {
    Alog.e(tag: tag, type: type, moduleName: module, content: content);
  }

  void test(String content) {
    Alog.test(tag: tag, type: type, moduleName: module, content: content);
  }
}

/// @nodoc
/// 用于 SDK 层日志输出
mixin _SDKLoggerMixin {
  static const moduleName = 'FLTNERtc';

  Logger? _apiLogger, _commonLogger;

  Logger get apiLogger {
    _apiLogger ??= LogOptions.isSupported
        ? _ALogger.api(logTag, moduleName)
        : const Logger();
    return _apiLogger!;
  }

  Logger get commonLogger {
    _commonLogger ??= LogOptions.isSupported
        ? _ALogger.normal(logTag, moduleName)
        : const Logger();
    return _commonLogger!;
  }

  String get logTag {
    return runtimeType.toString();
  }
}

/// @nodoc
/// 可用于 APP 层日志输出
mixin AppLoggerMixin {
  static const moduleName = 'APP';

  Logger? _logger;

  Logger get logger {
    _logger ??= LogOptions.isSupported
        ? _ALogger.normal(logTag, moduleName)
        : const Logger();
    return _logger!;
  }

  String get logTag {
    return runtimeType.toString();
  }
}

/// @nodoc
mixin LoggingApi on _SDKLoggerMixin {
  Future<T> wrapper<T>(String apiName, Future<T> apiAction, [Map? args]) async {
    if (args != null && args.isNotEmpty) {
      apiLogger.i('$apiName, args=$args');
    } else {
      apiLogger.i(apiName);
    }
    final start = DateTime.now();
    return apiAction.then((value) {
      final elapsed = DateTime.now().difference(start);
      dynamic result = value;
      apiLogger.i(
          '$apiName done. result=$result, elapsed=${elapsed.inMilliseconds}ms');
      return value;
    });
  }
}
