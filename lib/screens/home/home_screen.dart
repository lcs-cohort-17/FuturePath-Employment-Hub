import 'package:flutter/material.dart';
import '../../core/widgets/notification_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A365D),
        title: const Text('FuturePath Home', style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: NotificationBadge(),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
