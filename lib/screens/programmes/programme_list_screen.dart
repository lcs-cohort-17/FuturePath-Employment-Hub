import 'package:flutter/material.dart';
import 'programme_detail_screen.dart';

class ProgrammeListScreen extends StatelessWidget {
  const ProgrammeListScreen({super.key});

  final List<Map<String, String>> mockProgrammes = const [
    {
      'id': 'PROG-001',
      'name': 'Software Engineering Boot Camp',
    },
    {
      'id': 'PROG-002',
      'name': 'Digital Marketing Certificate',
    },
    {
      'id': 'PROG-003',
      'name': 'Data Analytics Intensive',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Programmes'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: mockProgrammes.length,
        separatorBuilder: (context, index) => const Divider(
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final programme = mockProgrammes[index];
          final String programmeId = programme['id'] ?? '';

          return ListTile(
            title: Text(
              programme['name'] ?? 'Unknown Programme',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Ref: $programmeId'),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgrammeDetailScreen(
                    programmeId: programmeId,
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
