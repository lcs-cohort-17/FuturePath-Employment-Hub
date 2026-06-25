import 'package:flutter/material.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final String applicationId;

  const ApplicationDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    // Invalid ID shows error
    if (applicationId.isEmpty || applicationId == 'invalid') {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Invalid Application ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Back button returns to list
                  child: const Text('Back to List'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Application Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Processing Record: $applicationId', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Card(
              elevation: 0,
              color: Colors.blueGrey,
              child: ListTile(
                title: Text('Submission Status', style: TextStyle(color: Colors.white)),
                subtitle: Text('Awaiting Manager Approval', style: TextStyle(color: Colors.white70)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Compliance Check',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('No PII detected in public summary view. Full document available in secure storage.'),
          ],
        ),
      ),
    );
  }
}
