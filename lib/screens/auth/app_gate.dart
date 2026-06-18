import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent, AuthState;

import '../../services/auth_services.dart ';
import '../home/home_screen.dart';
import '../auth/login_screen.dart';
import '../auth/reset_password_screen.dart';

/// The first widget the app mounts.
/// Routes to HomeScreen, LoginScreen, or ResetPasswordScreen
/// based on the current auth state.
class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  final AuthService _auth = AuthService();

  // null  → still checking (show spinner)
  // false → no session (show Login)
  // true  → valid session (show Home)
  bool? _hasSession;

  // Flipped to true when a password-recovery deep-link is detected
  bool _isPasswordRecovery = false;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();
    _listenToAuthChanges();
  }

  void _checkInitialSession() {
    final loggedIn = _auth.isLoggedIn;
    if (mounted) {
      setState(() => _hasSession = loggedIn);
    }
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges.listen((AuthState state) {
      if (!mounted) return;

      final event = state.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        setState(() {
          _isPasswordRecovery = true;
          _hasSession = true;
        });
        return;
      }

      setState(() {
        _isPasswordRecovery = false;
        _hasSession = state.session != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSession == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isPasswordRecovery) {
      return const ResetPasswordScreen();
    }

    if (_hasSession == true) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}