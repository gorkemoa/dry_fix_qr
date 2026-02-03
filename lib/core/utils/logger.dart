import 'dart:developer' as dev;

class Logger {
  static void log(String message) {
    dev.log(message, name: 'DryFixApp');
  }
}
