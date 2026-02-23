import 'dart:developer' as dev;

class Logger {
  static void info(String message) {
    _log('🔵 INFO: $message');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('🔴 ERROR: $message');
    if (error != null) _log('   Details: $error');
    if (stackTrace != null) _log('   StackTrace: $stackTrace');
  }

  static void warning(String message) {
    _log('🟡 WARNING: $message');
  }

  static void debug(String message) {
    _log('🟢 DEBUG: $message');
  }

  static void request(String method, String url, dynamic data) {
    _log('🚀 REQUEST [$method] -> $url');
    if (data != null) _log('   Body: $data');
  }

  static void response(String url, dynamic data) {
    _log('✅ RESPONSE <- $url');
    if (data != null) _log('   Data: $data');
  }

  static void _log(String message) {
    dev.log(message, name: 'DryUstaApp', time: DateTime.now());
  }
}
