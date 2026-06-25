import 'package:flutter/material.dart';

class ProgrammeDetailScreen extends StatefulWidget {
  final String programmeId;

  const ProgrammeDetailScreen({
    super.key,
    required this.programmeId,
  });

  @override
  State<ProgrammeDetailScreen> createState() => _ProgrammeDetailScreenState();
}

class _ProgrammeDetailScreenState extends State<ProgrammeDetailScreen> {
  late Future<Map<String, dynamic>?> _programmeData;

  @override
  void initState() {
    super.initState();
    _programmeData = _fetchProgrammeDetails(widget.programmeId);
  }

  Future<Map<String, dynamic>?> _fetchProgrammeDetails(String id) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    // Enforce invalid ID fallback
    if (id.isEmpty || id == 'invalid') {
      return null;
    }

    // Mock successful data response
    return {
      'id': id,
      'title': id == 'PROG-001'
          ? 'Software Engineering Boot Camp'
          : 'Vocational Training Programme',
      'description':
          'This intensive programme provides industry-standard training and hands-on experience in specialized technical domains.',
      'duration': '12 Weeks',
      'location': 'Hybrid / Cape Town',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programme Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _programmeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorState(context);
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REFERENCE: ${data['id']}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.blueGrey,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  data['title'],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 40),
                _buildInfoRow(Icons.calendar_today, 'Duration', data['duration']),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_outlined, 'Location', data['location']),
                const SizedBox(height: 24),
                Text(
                  'About the Programme',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['description'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Incomplete Record',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The requested programme ID is invalid or no longer exists in our system.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Return to Programmes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
