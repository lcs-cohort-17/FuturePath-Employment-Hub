import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/public_data_provider.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmesAsync = ref.watch(trainingProgrammesProvider);
    final opportunitiesAsync = ref.watch(employmentOpportunitiesProvider);
    final employersAsync = ref.watch(employersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sheets Test"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // PROGRAMMES
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Programmes",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            programmesAsync.when(
              data: (programmes) => Column(
                children: programmes.map((programme) {
                  return Card(
                    child: ListTile(
                      title: Text(programme.name),
                      subtitle: Text(programme.category),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text("Error: $error"),
            ),

            const SizedBox(height: 30),

            // OPPORTUNITIES
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Opportunities",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            opportunitiesAsync.when(
              data: (opportunities) => Column(
                children: opportunities.map((opportunity) {
                  return Card(
                    child: ListTile(
                      title: Text(opportunity.positionTitle),
                      subtitle: Text(opportunity.location),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text("Error: $error"),
            ),

            const SizedBox(height: 30),

            // EMPLOYERS
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Employers",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            employersAsync.when(
              data: (employers) => Column(
                children: employers.map((employer) {
                  return Card(
                    child: ListTile(
                      title: Text(employer.companyName),
                      subtitle: Text(employer.industry),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text("Error: $error"),
            ),
          ],
        ),
      ),
    );
  }
}