import 'package:flutter/foundation.dart';

/// Simple logger utility for debugging
class Logger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void logError(String message, {String tag = 'ERROR', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[$tag] $message');
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }

  static void logWarning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void logInfo(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void logSuccess(String message, {String tag = 'SUCCESS'}) {
    if (kDebugMode) {
      print('[$tag] ✓ $message');
    }
  }
}
