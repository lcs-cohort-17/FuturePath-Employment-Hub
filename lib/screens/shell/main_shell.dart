import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FuturePath'),
      ),
      body: const Center(
        child: Text('Home Screen - Coming Soon'),
      ),
    );
  }
}