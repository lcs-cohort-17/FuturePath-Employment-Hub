import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';
import '../../screens/auth/login_screen.dart';

// ---
// ARCHITECTURE NOTE: AppGate listens to Supabase's auth stream and
// rebuilds whenever login state changes. Replaces the one-time
// _getInitialRoute() check — this reacts to session expiry too.
// ---
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {

        print('Stream event: ${snapshot.data?.event}, session: ${snapshot.data?.session}');
        // Still waiting for first auth event
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;
        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}