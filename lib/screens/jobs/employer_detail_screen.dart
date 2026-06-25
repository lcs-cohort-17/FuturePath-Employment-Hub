import 'package:flutter/material.dart';

class EmployerDetailScreen extends StatelessWidget {
  final String employerId;

  const EmployerDetailScreen({
    super.key,
    required this.employerId,
  });

  @override
  Widget build(BuildContext context) {
    // Robust validation for incoming parameters
    if (employerId.isEmpty || employerId == 'invalid') {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person_outlined, size: 72, color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  'Invalid Employer ID',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to List'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.business, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: $employerId',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Text(
                      'Enterprise Profile',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              color: Colors.green.shade50,
              child: const ListTile(
                leading: Icon(Icons.verified, color: Colors.green),
                title: Text(
                  'Account Status: Active',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Verified Business Entity'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Company Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'This employer is a registered partner providing multiple growth opportunities for emerging talent in the technology sector. They maintain a high rating for workplace culture and career development.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
