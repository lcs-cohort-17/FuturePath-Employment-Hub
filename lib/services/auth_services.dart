import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String _sessionKey = 'user_session';

  static Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  static Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  static Future<bool> isLoggedIn() async {
    final email = await getSession();
    return email != null && email.isNotEmpty;
  }

  // Add this method for forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('Password reset link sent to: $email');
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      rethrow;
    }
  }
}