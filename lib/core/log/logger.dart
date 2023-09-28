import 'dart:developer' as dev show log;

import 'package:flutter/foundation.dart' show kDebugMode;
export 'package:logging/src/level.dart';

class AppLogger {
  const AppLogger._();

  static bool shouldLog() {
    return kDebugMode;
  }

  static error(
    String message, {
    StackTrace? stackTrace,
    String? error,
    String name = '',
    int level = 0,
  }) {
    if (!shouldLog()) {
      return;
    }
    dev.log(
      message,
      stackTrace: stackTrace,
      error: error,
      name: name,
      level: level,
    );
  }
}
