import 'package:flutter/material.dart';
import 'job_apply_success_screen.dart';

class ApplyScreen extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const ApplyScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for $jobTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Job ID: $jobId', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //1. (Your logic to send submission to Google Sheets goes here)
                  //2. Safely swap screens and clear the form from the stack
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobApplySuccessScreen()),
                    );
                  },
                child: const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
