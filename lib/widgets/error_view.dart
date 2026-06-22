// just avoids repetition for UI, reusable widget
//optional

import 'package:flutter/material.dart';

import '../utils/error_handler.dart';

class ErrorView extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final message =
    AppErrorHandler.getUserFriendlyMessage(
      error,
    );

    final showRetry =
    AppErrorHandler.shouldShowRetry(
      error,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            if (showRetry && onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}