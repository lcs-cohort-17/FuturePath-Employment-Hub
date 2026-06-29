import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/models/opportunity.dart';
import 'job_apply_screen.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(opportunity.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.company,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(opportunity.location, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.work, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(opportunity.type, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              opportunity.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobApplyScreen(
                        jobId: opportunity.id,
                        jobTitle: opportunity.title,
                      ),
                    ),
                  );
                },
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
