import 'package:flutter/material.dart';
import 'applicant_detail_screen.dart';

class ApplicantListScreen extends StatelessWidget {
  const ApplicantListScreen({super.key});

  final List<Map<String, String>> mockApplicants = const [
    {'id': 'USR-001', 'name': 'John Doe', 'email': 'john.doe@example.com', 'skills': 'Flutter, Dart, Firebase'},
    {'id': 'USR-002', 'name': 'Jane Smith', 'email': 'jane.s@example.com', 'skills': 'UI/UX, Figma, Adobe XD'},
    {'id': 'USR-003', 'name': 'Michael Chen', 'email': 'm.chen@example.com', 'skills': 'Python, Django, AWS'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Applicants'),
      ),
      body: ListView.builder(
        itemCount: mockApplicants.length,
        itemBuilder: (context, index) {
          final applicant = mockApplicants[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person_outline),
            ),
            title: Text(applicant['name'] ?? ''),
            subtitle: Text(applicant['email'] ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicantDetailScreen(
                    applicantId: applicant['id'] ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
