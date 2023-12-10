import 'dart:async' show Zone;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logging/logging.dart';
export 'package:logging/src/level.dart';

class AppLogger {
  const AppLogger._();

  static bool shouldLog() {
    return kDebugMode;
  }

  static void log<T>(
    T message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    StackTrace? stackTrace,
  }) {
    if (!shouldLog()) {
      return;
    }
    final logger = Logger(name);
    logger.log(Level.ALL, _warrning(message.toString()));
  }

  static void error<T>(
    T message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!shouldLog()) {
      return;
    }

    final logger = Logger(name);
    logger.log(Level.SHOUT, _error(message.toString()));
  }

  static String _warrning(String text) {
    return '\x1B[33m$text\x1B[0m';
  }

  static String _error(String text) {
    return '\x1B[31m$text\x1B[0m';
  }
}
