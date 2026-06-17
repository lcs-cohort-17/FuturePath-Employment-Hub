import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/app_shell.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn();
  runApp(FuturePathApp(startLoggedIn: loggedIn));
}

class FuturePathApp extends StatelessWidget {
  final bool startLoggedIn;
  const FuturePathApp({super.key, required this.startLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: startLoggedIn ? const AppShell() : const LoginScreen(),
    );
  }
}