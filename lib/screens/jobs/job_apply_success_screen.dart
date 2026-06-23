import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String jobTitle;

  const SuccessScreen({super.key, required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 90, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Application Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              'Your application for $jobTitle has been securely transmitted.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            
            // SUBTASK 4: Navigate to Track Applications using Named Routes
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/trackApplications');
                },
                child: const Text('Track Application'),
              ),
            ),
            const SizedBox(height: 12),
            
            // SUBTASK 3: Use simple pop to clean up stack and return to Job Details
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}