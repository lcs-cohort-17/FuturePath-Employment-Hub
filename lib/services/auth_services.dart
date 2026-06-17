import 'package:supabase_flutter/supabase_flutter.dart';

// ---
// ARCHITECTURE NOTE: AuthService is the only file that imports
// supabase_flutter directly. All screens go through this class.
// Mirrors the service layer pattern from Clock-It's PHP controllers.
// GoTrueClient injected via constructor to allow mocking in tests.
// ---
class AuthService {
  final GoTrueClient _auth;

  // ---
  // NOTE: auth parameter optional — defaults to real Supabase client
  // in production, accepts mock in tests.
  // ---
  AuthService({GoTrueClient? auth})
      : _auth = auth ?? Supabase.instance.client.auth;

  // Auth state stream — AppGate listens to this
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  bool get isLoggedIn => _auth.currentSession != null;
  String? get userEmail => _auth.currentUser?.email;
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}