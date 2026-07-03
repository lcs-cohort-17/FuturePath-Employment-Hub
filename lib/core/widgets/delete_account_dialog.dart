// lib/core/widgets/delete_account_dialog.dart

import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

/// Confirmation dialog shown before permanently deleting an account.
///
/// Returns `true` when the user taps "Delete My Account", `false` / null
/// otherwise.  Call via [showDeleteAccountDialog].
class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Warning icon ────────────────────────────────────────────────
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.errorLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: AppTheme.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ───────────────────────────────────────────────────────
            const Text(
              'Delete account?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // ── Body ────────────────────────────────────────────────────────
            const Text(
              'This action cannot be undone. All your personal data — '
                  'including your profile, applications, and enrolments — '
                  'will be permanently removed.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mutedText,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ── POPIA notice chip ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surface3,
                borderRadius: BorderRadius.circular(8),
                border: const Border.fromBorderSide(
                  BorderSide(color: AppTheme.border, width: 0.5),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined,
                      size: 14, color: AppTheme.subtleText),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Your right to be forgotten under POPIA will be honoured.',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.subtleText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── Confirm button ───────────────────────────────────────────────
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
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete My Account',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Cancel button ────────────────────────────────────────────────
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
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience helper — shows [DeleteAccountDialog] and returns the result.
Future<bool> showDeleteAccountDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (_) => const DeleteAccountDialog(),
  );
  return result ?? false;
}
