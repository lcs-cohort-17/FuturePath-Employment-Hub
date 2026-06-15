import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/auth_services.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final authState = snapshot.data!;

        if (authState.event ==
            AuthChangeEvent.passwordRecovery) {
          return const ResetPasswordScreen();
        }

        if (AuthService().isLoggedIn) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}