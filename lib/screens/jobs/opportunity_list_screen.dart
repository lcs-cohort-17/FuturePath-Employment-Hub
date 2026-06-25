import 'package:flutter/material.dart';
import 'opportunity_detail_screen.dart';
import 'employer_detail_screen.dart';

class OpportunityListScreen extends StatelessWidget {
  const OpportunityListScreen({super.key});

  final List<Map<String, String>> mockJobs = const [
    {
      'id': 'JOB-901',
      'title': 'Junior Flutter Developer',
      'employerId': 'EMP-101',
      'company': 'Tech Solutions Inc',
    },
    {
      'id': 'JOB-902',
      'title': 'UI/UX Design Intern',
      'employerId': 'EMP-102',
      'company': 'Creative Agency',
    },
    {
      'id': 'JOB-903',
      'title': 'Backend Systems Engineer',
      'employerId': 'invalid',
      'company': 'Legacy Systems',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Opportunities'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: mockJobs.length,
        itemBuilder: (context, index) {
          final job = mockJobs[index];
          final String jobId = job['id'] ?? '';
          final String employerId = job['employerId'] ?? '';

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                job['title'] ?? 'Position Available',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  job['company'] ?? 'Confidential Employer',
                  style: TextStyle(color: Colors.blueGrey.shade700),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.business_rounded, color: Colors.blue),
                tooltip: 'View Employer Profile',
                onPressed: () {
                  // Explicit trigger to Employer Detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployerDetailScreen(
                        employerId: employerId,
                      ),
                    ),
                  );
                },
              ),
              onTap: () {
                // Main row trigger to Opportunity Detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpportunityDetailScreen(
                      jobId: jobId,
                    ),
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
