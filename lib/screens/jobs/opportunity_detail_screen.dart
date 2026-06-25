import 'package:flutter/material.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final String jobId;

  const OpportunityDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    // Immediate validation check
    if (jobId.isEmpty || jobId == 'invalid') {
      return _buildErrorScaffold(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'JOB ID: $jobId',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Role & Responsibilities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'As a team member, you will be responsible for building, testing, and maintaining high-quality software solutions. You will work closely with cross-functional teams to deliver impactful features for our users.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Requirements:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text('• 2+ years of experience in mobile development\n'
                '• Strong understanding of Dart and Flutter\n'
                '• Familiarity with REST APIs and state management'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'Invalid Job ID',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'We could not find the job record you are looking for. Please try again from the list.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Back to Opportunities'),
            ),
          ],
        ),
      ),
    );
  }
}
