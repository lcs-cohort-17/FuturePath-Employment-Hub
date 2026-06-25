import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_services.dart';

final authServiceProvider = Provider((ref) => AuthService());

// Auth state stream
final authStateProvider = StreamProvider<AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChange;
});

// Boolean for logged-in status
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (state) => state.session != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Future provider for user role
final userRoleProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(authServiceProvider);
  return await service.getUserRole();
});

// Notifier for actions (sign in, sign out, etc.)
class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  AuthNotifier(this._service) : super(const AsyncData(false));

  final AuthService _service;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _service.signIn(email, password);
      state = const AsyncData(true);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _service.signOut();
      state = const AsyncData(false);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _service.signUp(email, password);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _service.resetPassword(email);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _service.updatePassword(newPassword);
    } catch (_) {
      rethrow;
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});