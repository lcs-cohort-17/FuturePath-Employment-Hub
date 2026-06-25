import 'package:flutter/material.dart';
import '../programmes/programme_list_screen.dart';
import '../jobs/opportunity_list_screen.dart';
import 'application_list_screen.dart';
import 'enrolment_list_screen.dart';
import 'applicant_list_screen.dart';
import 'employer_list_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> adminModules = [
      {
        'title': 'Programmes',
        'subtitle': 'Manage curriculum and learning paths',
        'icon': Icons.school_outlined,
        'color': Colors.indigo,
        'screen': const ProgrammeListScreen(),
      },
      {
        'title': 'Jobs',
        'subtitle': 'Review and post job opportunities',
        'icon': Icons.work_outline,
        'color': Colors.teal,
        'screen': const OpportunityListScreen(),
      },
      {
        'title': 'Applicants',
        'subtitle': 'Search and manage registered talent',
        'icon': Icons.person_search_outlined,
        'color': Colors.blue,
        'screen': const ApplicantListScreen(),
      },
      {
        'title': 'Employers',
        'subtitle': 'Maintain partner company profiles',
        'icon': Icons.business_center_outlined,
        'color': Colors.deepOrange,
        'screen': const EmployerListScreen(),
      },
      {
        'title': 'Enrolments',
        'subtitle': 'Monitor active student progress',
        'icon': Icons.assignment_turned_in_outlined,
        'color': Colors.green,
        'screen': const EnrolmentListScreen(),
      },
      {
        'title': 'Applications',
        'subtitle': 'Process pending intake requests',
        'icon': Icons.description_outlined,
        'color': Colors.amber.shade800,
        'screen': const ApplicationListScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Administration'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adminModules.length,
        itemBuilder: (context, index) {
          final module = adminModules[index];
          final Color color = module['color'] as Color;

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  module['icon'] as IconData,
                  color: color,
                  size: 28,
                ),
              ),
              title: Text(
                module['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                module['subtitle'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => module['screen'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
