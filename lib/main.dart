import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/shell/main_shell.dart';
import 'providers/admin_provider.dart';

void main() {
  runApp(const FuturePathApp());
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'FuturePath',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF111111),
          primaryColor: const Color(0xFFE03A2F),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE03A2F),
            secondary: Color(0xFFE03A2F),
            surface: Color(0xFF1A1A1A),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111111),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFFF0EDE8),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/admin/dashboard': (context) => MainShell(key: mainShellKey),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text(
                  'Page not found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}