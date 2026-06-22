import 'dart:async';
import 'dart:io';

class AppErrorHandler {
  static String getUserFriendlyMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Check your Wi-Fi.';
    }

    if (error is TimeoutException) {
      return 'Request timed out. Try again.';
    }

    if (error.runtimeType.toString() ==
        'GoogleSheetsException') {
      return 'Cannot access the sheet. Contact support.';
    }

    if (error is FormatException) {
      return 'Data format error. Please report this.';
    }

    return 'Something went wrong. Please try again.';
  }

  static bool shouldShowRetry(dynamic error) {
    return error is SocketException ||
        error is TimeoutException;
  }
}