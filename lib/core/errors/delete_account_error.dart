// lib/core/errors/delete_account_error.dart

/// Categorised error codes for the delete-account flow.
/// INT-013 — replace mock throw sites with real Supabase error mapping.
enum DeleteAccountErrorCode {
  /// Device has no network connectivity.
  noInternet,

  /// Supabase responded with a 5xx status or the PostgREST call timed out.
  serverError,

  /// The auth-user deletion step failed after the applicant row was removed.
  /// Partial state — admin must clean up manually.
  authDeletionFailed,

  /// The session token expired before the request completed.
  sessionExpired,

  /// Supabase returned an unexpected payload or the client threw an
  /// unrecognised exception.
  unknown,
}

class DeleteAccountException implements Exception {
  const DeleteAccountException({
    required this.code,
    required this.userMessage,
    this.technicalDetail,
  });

  final DeleteAccountErrorCode code;

  /// Plain-language message shown directly in the UI.
  final String userMessage;

  /// Optional detail for logging — never shown to the user.
  final String? technicalDetail;

  @override
  String toString() =>
      'DeleteAccountException(${code.name}): $userMessage'
          '${technicalDetail != null ? ' [$technicalDetail]' : ''}';
}
