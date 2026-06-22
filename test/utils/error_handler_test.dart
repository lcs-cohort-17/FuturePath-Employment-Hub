import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:futurepath_employment_hub/utils/error_handler.dart';

void main() {
  group('AppErrorHandler', () {
    test(
      'returns internet message for SocketException',
          () {
        final error = const SocketException(
          'No internet',
        );

        final message =
        AppErrorHandler.getUserFriendlyMessage(
          error,
        );

        expect(
          message,
          'No internet connection. Check your Wi-Fi.',
        );
      },
    );

    test(
      'returns timeout message for TimeoutException',
          () {
        final error = TimeoutException(
          'Timeout',
        );

        final message =
        AppErrorHandler.getUserFriendlyMessage(
          error,
        );

        expect(
          message,
          'Request timed out. Try again.',
        );
      },
    );

    test(
      'returns format message for FormatException',
          () {
        final error = FormatException();

        final message =
        AppErrorHandler.getUserFriendlyMessage(
          error,
        );

        expect(
          message,
          'Data format error. Please report this.',
        );
      },
    );

    test(
      'returns generic message for unknown error',
          () {
        final error = Exception(
          'Unknown',
        );

        final message =
        AppErrorHandler.getUserFriendlyMessage(
          error,
        );

        expect(
          message,
          'Something went wrong. Please try again.',
        );
      },
    );

    test(
      'SocketException should show retry',
          () {
        expect(
          AppErrorHandler.shouldShowRetry(
            const SocketException(''),
          ),
          true,
        );
      },
    );

    test(
      'TimeoutException should show retry',
          () {
        expect(
          AppErrorHandler.shouldShowRetry(
            TimeoutException(''),
          ),
          true,
        );
      },
    );

    test(
      'FormatException should not show retry',
          () {
        expect(
          AppErrorHandler.shouldShowRetry(
            FormatException(),
          ),
          false,
        );
      },
    );
  });
}