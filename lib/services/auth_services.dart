import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String passwordResetRedirectUrl =
      'io.futurepath://reset-password';

  // ---- Sign In ----
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ---- Sign Up ----
  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // ---- Sign Out ----
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ---- Forgot Password (reset) ----
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: passwordResetRedirectUrl,
    );
  }

  // ---- Update Password (after reset) ----
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // ---- Get Current User ----
  User? get currentUser => _supabase.auth.currentUser;

  // ---- Compatibility getter required by AUTH-002 ----
  bool get isLoggedIn => _supabase.auth.currentSession != null;

  // ---- Get User Role (from profiles table) ----
  Future<String?> getUserRole() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return response?['role'] as String?;
  }

  // ---- Auth State Stream ----
  Stream<AuthState> get authStateChange =>
      _supabase.auth.onAuthStateChange;

  // ---- Compatibility alias required by AUTH-002 ----
  Stream<AuthState> get authStateChanges => authStateChange;
}