import 'package:flutter/material.dart';
import 'job_apply_screen.dart';

class OpportunityDetailScreen extends StatelessWidget {
  const OpportunityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Junior Developer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Job ID: JOB-2026'),
            const SizedBox(height: 16),
            const Text(
              'We are looking for a Junior Developer to join our team...',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ApplyScreen(
                        jobId: 'JOB-2026', // Passing the required data forward
                        jobTitle: 'Junior Developer',
                      ),
                    ),
                  );
                },
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
