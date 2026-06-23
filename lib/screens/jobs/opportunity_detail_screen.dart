import 'package:flutter/material.dart';
import 'job_apply_screen.dart';

class OpportunityDetailScreen extends StatelessWidget {
  // Mock data representing a record pulled from your Salesforce/Google Sheets dataset
  final String jobId = 'OPT-2026-042'; 
  final String jobTitle = 'Junior Mobile Developer (Flutter)';
  final String companyName = 'LC Studio';

  const OpportunityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(companyName, style: TextStyle(fontSize: 18, color: Colors.indigo.shade700)),
                    const SizedBox(height: 4),
                    Text('Reference ID: $jobId', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Position Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'We are looking for an energetic youth applicant to build testable Flutter interfaces, '
              'consume structured Google Sheets workflows, and maintain clean UI principles.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assignment_turned_in),
                label: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // SUBTASK 1: Navigate to Apply screen passing Job ID and Title as arguments
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyScreen(
                        jobId: jobId,
                        jobTitle: jobTitle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}