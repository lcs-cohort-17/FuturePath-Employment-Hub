import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Private constructor for internal framework tracking
  AuthService._();

  // Central singleton memory container
  static final AuthService _instance = AuthService._();

  // Public factory exposing the absolute single instance globally
  factory AuthService() => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream checking the current reactive connection changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Quick state getter evaluation
  bool get isLoggedIn => _supabase.auth.currentSession != null;

  // Information context extractions
  User? get currentUser => _supabase.auth.currentUser;
  String? get userEmail => _supabase.auth.currentUser?.email;

  // Core authentication action handlers
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Requests a deep-linked recovery link explicitly back to the app context
  Future<void> resetPassword({
    required String email,
    required String redirectTo,
  }) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }

  // Updates the password for the currently active recovery session.
  // Call this from ResetPasswordScreen after the user lands via the recovery link.
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}