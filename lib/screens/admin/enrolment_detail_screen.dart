import 'package:flutter/material.dart';

class EnrolmentDetailScreen extends StatelessWidget {
  final String enrolmentId;

  const EnrolmentDetailScreen({super.key, required this.enrolmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolment Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text('Enrolment ID: $enrolmentId', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Alice Johnson',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            _buildInfoRow(Icons.book, 'Programme', 'Software Engineering Boot Camp'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.calendar_month, 'Enrolment Date', 'Jan 15, 2024'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.check_circle, 'Progress', 'Module 3 of 12'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
