import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/models/application.dart';

class TrackApplicationsScreen extends StatelessWidget {
  const TrackApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applications = Application.submittedApplications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Applications'),
      ),
      body: applications.isEmpty
          ? const Center(
              child: Text('No applications submitted yet.'),
            )
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return ListTile(
                  title: Text(app.jobTitle),
                  subtitle: Text('Applied on: ${app.appliedDate.toString().split(' ')[0]}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      app.status,
                      style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
