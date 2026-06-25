import 'package:flutter/material.dart';

class ApplicantDetailScreen extends StatelessWidget {
  final String applicantId;

  const ApplicantDetailScreen({super.key, required this.applicantId});

  @override
  Widget build(BuildContext context) {
    // 1. Invalid ID shows error
    if (applicantId.isEmpty || applicantId == 'invalid') {
      return _buildErrorState(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Applicant Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Applicant $applicantId', // 2. No PII (Anonymized)
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Professional Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Redacted for privacy compliance. Technical assessment score: 85%',
              style: TextStyle(height: 1.5),
            ),
            const Divider(height: 40),
            _buildDetailTile(Icons.verified_user_outlined, 'Status', 'Verified'),
            _buildDetailTile(Icons.calendar_today_outlined, 'Registered', '2023-Q4'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildErrorState(BuildContext context) {
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
                'Invalid Applicant Record',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // 3. Back button returns to list
                child: const Text('Return to List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
