import 'package:flutter/material.dart';
import 'enrolment_detail_screen.dart';

class EnrolmentListScreen extends StatelessWidget {
  const EnrolmentListScreen({super.key});

  final List<Map<String, String>> mockEnrolments = const [
    {'id': 'ENR-101', 'student': 'Alice Johnson', 'programme': 'Software Engineering Boot Camp'},
    {'id': 'ENR-102', 'student': 'Bob Wilson', 'programme': 'Digital Marketing Certificate'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolments'),
      ),
      body: ListView.builder(
        itemCount: mockEnrolments.length,
        itemBuilder: (context, index) {
          final enr = mockEnrolments[index];
          return ListTile(
            leading: const Icon(Icons.school, color: Colors.green),
            title: Text(enr['student'] ?? ''),
            subtitle: Text(enr['programme'] ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnrolmentDetailScreen(enrolmentId: enr['id'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
