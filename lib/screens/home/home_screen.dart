import 'package:flutter/material.dart';
import '../../services/auth_services.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    try{
      await AuthService().signOut();
    }catch(err){
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed.Try again .'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email =AuthService().userEmail ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FuturePath Employment Hub'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Confirms auth is working — shows logged in email
            Text(
              'Logged in as: $email',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('Find programmes and opportunities near you.'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}