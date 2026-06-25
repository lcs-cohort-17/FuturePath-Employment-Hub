import 'package:flutter/material.dart';
import 'application_detail_screen.dart';

class ApplicationListScreen extends StatelessWidget {
  const ApplicationListScreen({super.key});

  final List<Map<String, String>> mockApplications = const [
    {'id': 'APP-001', 'name': 'John Doe', 'position': 'Junior Flutter Developer', 'status': 'Pending'},
    {'id': 'APP-002', 'name': 'Jane Smith', 'position': 'UI/UX Design Intern', 'status': 'Reviewed'},
    {'id': 'APP-003', 'name': 'Robert Brown', 'position': 'Data Analyst', 'status': 'Rejected'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
      ),
      body: ListView.separated(
        itemCount: mockApplications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final app = mockApplications[index];
          return ListTile(
            title: Text(app['name'] ?? ''),
            subtitle: Text(app['position'] ?? ''),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(app['status'] ?? '').withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                app['status'] ?? '',
                style: TextStyle(
                  color: _getStatusColor(app['status'] ?? ''),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicationDetailScreen(applicationId: app['id'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Reviewed': return Colors.blue;
      case 'Rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}
