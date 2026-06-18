import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // ---- Update Password (after reset) ----
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // ---- Get Current User ----
  User? get currentUser => _supabase.auth.currentUser;

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
  Stream<AuthState> get authStateChange => _supabase.auth.onAuthStateChange;
}