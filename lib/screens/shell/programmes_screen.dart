import 'package:flutter/material.dart';

class ProgrammesScreen extends StatelessWidget {
  const ProgrammesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programmes')),
      body: const Center(
        child: Text('Available Programmes'),
      ),
    );
  }
}