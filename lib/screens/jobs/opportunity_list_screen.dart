import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/models/opportunity.dart';
import 'opportunity_detail_screen.dart';

class OpportunityListScreen extends StatelessWidget {
  const OpportunityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final opportunities = [
      Opportunity(
        id: '1',
        title: 'Software Engineer',
        company: 'Tech Corp',
        description: 'We are looking for a Flutter developer.',
        location: 'Remote',
        type: 'Full-time',
      ),
      Opportunity(
        id: '2',
        title: 'Product Designer',
        company: 'Design Studio',
        description: 'Expert in UI/UX design.',
        location: 'Johannesburg',
        type: 'Contract',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Opportunities'),
      ),
      body: ListView.builder(
        itemCount: opportunities.length,
        itemBuilder: (context, index) {
          final opportunity = opportunities[index];
          return ListTile(
            title: Text(opportunity.title),
            subtitle: Text(opportunity.company),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpportunityDetailScreen(
                    opportunity: opportunity,
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
