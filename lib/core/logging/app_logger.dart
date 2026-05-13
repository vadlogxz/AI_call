import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogTag {
  auth,
  network,
  router,
  call,
  agents,
  dictionary,
  settings,
  provider,
  other;

  String get _label => '[${name.toUpperCase()}]';
}

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String message, {LogTag tag = LogTag.other, Object? data}) {
    if (kDebugMode) _logger.d(_format(message, tag, data));
  }

  static void info(String message, {LogTag tag = LogTag.other, Object? data}) {
    if (kDebugMode) _logger.i(_format(message, tag, data));
  }

  static void warning(String message, {LogTag tag = LogTag.other, Object? data}) {
    if (kDebugMode) _logger.w(_format(message, tag, data));
  }

  static void error(
    String message, {
    LogTag tag = LogTag.other,
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    _logger.e(_format(message, tag, data), error: error, stackTrace: stackTrace);
  }

  static String _format(String message, LogTag tag, Object? data) {
    final base = '${tag._label} $message';
    return data == null ? base : '$base\nData: $data';
  }
}
