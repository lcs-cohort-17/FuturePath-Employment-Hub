//auth services.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserEmail = 'user_email';

  static Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserEmail);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  Future<void> logout() async {
    await clearSession();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());