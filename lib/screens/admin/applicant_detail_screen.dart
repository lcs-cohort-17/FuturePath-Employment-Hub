import 'package:flutter/material.dart';

class ApplicantDetailScreen extends StatelessWidget {
  final String applicantId;

  const ApplicantDetailScreen({super.key, required this.applicantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Profile'),
      ),
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
                'John Doe',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Contact Information'),
            _buildDetailTile(Icons.email, 'Email', 'john.doe@example.com'),
            _buildDetailTile(Icons.phone, 'Phone', '+27 71 234 5678'),
            _buildDetailTile(Icons.location_on, 'Location', 'Johannesburg, SA'),
            const SizedBox(height: 24),
            _buildSectionTitle('Skills & Expertise'),
            Wrap(
              spacing: 8,
              children: ['Flutter', 'Dart', 'Firebase', 'Git', 'REST APIs']
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Education'),
            const Text(
              'BSc in Computer Science\nUniversity of South Africa',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: Colors.grey),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}
