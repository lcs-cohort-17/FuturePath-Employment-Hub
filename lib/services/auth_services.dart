import 'package:flutter/foundation.dart';

class AuthService {
  /// Sends a password reset email to the user
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // TODO: Replace with your actual API endpoint
      // For now, we'll simulate an API call
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('Password reset link sent to: $email');
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      rethrow;
    }
  }

  /// Validates if the email format is correct
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}