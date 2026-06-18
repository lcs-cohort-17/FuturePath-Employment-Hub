import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../services/auth_services.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const _ProtectedHomeRoute(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}

class _ProtectedHomeRoute extends StatefulWidget {
  const _ProtectedHomeRoute();

  @override
  State<_ProtectedHomeRoute> createState() => _ProtectedHomeRouteState();
}

class _ProtectedHomeRouteState extends State<_ProtectedHomeRoute> {
  late final Future<bool> _isLoggedIn = AuthService.isLoggedIn();
  bool _redirectedToLogin = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const AppShell();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _redirectToLogin();
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _redirectToLogin() {
    if (_redirectedToLogin) return;
    _redirectedToLogin = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
        (route) => false,
      );
    });
  }
}
