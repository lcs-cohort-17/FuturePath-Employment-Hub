import 'package:flutter/material.dart';
import 'application_list_screen.dart';
import 'enrolment_list_screen.dart';
import 'staff_list_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> adminModules = [
      {
        'title': 'Applications',
        'subtitle': 'Manage job and programme applications',
        'icon': Icons.description_outlined,
        'color': Colors.orange,
        'screen': const ApplicationListScreen(),
      },
      {
        'title': 'Enrolments',
        'subtitle': 'Track student and candidate enrolments',
        'icon': Icons.assignment_turned_in_outlined,
        'color': Colors.green,
        'screen': const EnrolmentListScreen(),
      },
      {
        'title': 'Staff Members',
        'subtitle': 'Manage internal team and faculty',
        'icon': Icons.people_outline,
        'color': Colors.blue,
        'screen': const StaffListScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adminModules.length,
        itemBuilder: (context, index) {
          final module = adminModules[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: (module['color'] as Color).withOpacity(0.1),
                child: Icon(module['icon'] as IconData, color: module['color'] as Color),
              ),
              title: Text(
                module['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(module['subtitle'] as String),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => module['screen'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
