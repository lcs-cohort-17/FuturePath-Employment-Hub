import 'package:flutter/material.dart';
import '../jobs/employer_detail_screen.dart';

class EmployerListScreen extends StatelessWidget {
  const EmployerListScreen({super.key});

  final List<Map<String, String>> mockEmployers = const [
    {'id': 'EMP-101', 'name': 'Tech Solutions Inc', 'industry': 'Software Development'},
    {'id': 'EMP-102', 'name': 'Creative Agency', 'industry': 'Design & Media'},
    {'id': 'EMP-103', 'name': 'Global Logistics', 'industry': 'Supply Chain'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Employers'),
      ),
      body: ListView.separated(
        itemCount: mockEmployers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final emp = mockEmployers[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.business, color: Colors.white),
            ),
            title: Text(emp['name'] ?? ''),
            subtitle: Text(emp['industry'] ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployerDetailScreen(
                    employerId: emp['id'] ?? '',
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
