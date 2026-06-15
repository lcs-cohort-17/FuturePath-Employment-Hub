import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();

  factory AuthService() => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

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

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  bool get isLoggedIn =>
      _supabase.auth.currentSession != null;

  User? get currentUser =>
      _supabase.auth.currentUser;

  String? get userEmail =>
      _supabase.auth.currentUser?.email;

  Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}