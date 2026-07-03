import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---
// ARCHITECTURE NOTE: AuthService is the only file that imports supabase_flutter.
// Supports dependency injection (for tests) AND a singleton factory (for production).
// ---
class AuthService {
  final GoTrueClient _auth;

  // --- 1. Private constructor used for all instance creation
  AuthService._(this._auth);

  // --- 2. Named constructor for dependency injection (tests, custom clients)
  AuthService.withClient(GoTrueClient auth) : _auth = auth;

  // --- 3. Singleton factory (default, unnamed) – production use
  static final AuthService _instance = AuthService._(Supabase.instance.client.auth);
  factory AuthService() => _instance;

  // --- 4. Core streams & getters
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  bool get isLoggedIn => _auth.currentSession != null;
  String? get userEmail => _auth.currentUser?.email;
  User? get currentUser => _auth.currentUser;

  // --- 5. Authentication methods (using rich return types)
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Same as signOut but for compatibility with existing UI
  Future<void> logout() async {
    await signOut();
  }

  // --- 6. Password reset (from Ticket 002)
  Future<void> resetPassword({
    required String email,
    required String redirectTo,
  }) async {
    await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    return await _auth.updateUser(UserAttributes(password: newPassword));
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());