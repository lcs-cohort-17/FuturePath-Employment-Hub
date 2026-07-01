// lib/core/widgets/delete_account_error_sheet.dart

import 'package:flutter/material.dart';
// import '../errors/delete_account_error.dart';
// import '../theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/errors/delete_account_error.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';


/// Maps a [DeleteAccountErrorCode] to a UI-ready descriptor.
class _ErrorDescriptor {
  const _ErrorDescriptor({
    required this.title,
    required this.body,
    required this.icon,
    required this.canRetry,
  });

  final String title;
  final String body;
  final IconData icon;
  final bool canRetry;
}

_ErrorDescriptor _describe(DeleteAccountErrorCode code) {
  switch (code) {
    case DeleteAccountErrorCode.noInternet:
      return const _ErrorDescriptor(
        title: 'No internet connection',
        body:
        'Your device is offline. Check your Wi-Fi or mobile data and try again.',
        icon: Icons.wifi_off_rounded,
        canRetry: true,
      );
    case DeleteAccountErrorCode.serverError:
      return const _ErrorDescriptor(
        title: 'Server error',
        body:
        'Our servers ran into a problem (500). Your account has not been deleted. '
            'Please try again in a moment.',
        icon: Icons.dns_rounded,
        canRetry: true,
      );
    case DeleteAccountErrorCode.authDeletionFailed:
      return const _ErrorDescriptor(
        title: 'Partial deletion (auth)',
        body:
        'Your profile data was removed but your sign-in credentials could not be '
            'deleted (auth error). Contact support at help@futurepath.co.za '
            'quoting code AUTH-DEL-001.',
        icon: Icons.lock_reset_rounded,
        canRetry: false,
      );
    case DeleteAccountErrorCode.sessionExpired:
      return const _ErrorDescriptor(
        title: 'Session expired',
        body:
        'Your session timed out before the request could complete. '
            'Sign in again and retry.',
        icon: Icons.timer_off_rounded,
        canRetry: false,
      );
    case DeleteAccountErrorCode.unknown:
      return const _ErrorDescriptor(
        title: 'Something went wrong',
        body:
        'An unexpected error occurred (ERR-000). Your account has not been '
            'deleted. Please try again or contact support.',
        icon: Icons.error_outline_rounded,
        canRetry: true,
      );
  }
}

/// Bottom sheet that presents a categorised deletion error.
///
/// [onRetry] is only shown when [descriptor.canRetry] is true.
class DeleteAccountErrorSheet extends StatelessWidget {
  const DeleteAccountErrorSheet({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onDismiss,
  });

  final DeleteAccountException error;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final d = _describe(error.code);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ────────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Icon + Title row ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.errorLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(d.icon, color: AppTheme.error, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  d.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Body ──────────────────────────────────────────────────────────
          Text(
            d.body,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.mutedText,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // ── Actions ───────────────────────────────────────────────────────
          if (d.canRetry) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: onRetry,
                child: const Text(
                  'Try again',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.mutedText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppTheme.border, width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onDismiss,
              child: Text(
                d.canRetry ? 'Cancel' : 'Close',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience helper — shows [DeleteAccountErrorSheet] as a modal bottom sheet.
Future<void> showDeleteAccountErrorSheet({
  required BuildContext context,
  required DeleteAccountException error,
  required VoidCallback onRetry,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) => DeleteAccountErrorSheet(
      error: error,
      onRetry: () {
        Navigator.of(context).pop();
        onRetry();
      },
      onDismiss: () => Navigator.of(context).pop(),
    ),
  );
}
