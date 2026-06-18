import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/screens/shell/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath Employment Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        canvasColor: const Color(0xFF050505),
        useMaterial3: true,
      ),
      // Use MainShell as home to provide the persistent Bottom Navigation Bar
      home: const MainShell(),
    );
  }
}
