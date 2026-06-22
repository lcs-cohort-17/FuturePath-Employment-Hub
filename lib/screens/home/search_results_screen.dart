import 'package:flutter/material.dart';
import '../shell/main_shell.dart'; // Make sure this path correctly points to your main_shell.dart

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mockup data list
    final results = [
      {
        'title': 'Software Development Programme',
        'type': 'Programme',
      },
      {
        'title': 'Junior Flutter Developer',
        'type': 'Job',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                result['type'] == 'Programme' ? Icons.school : Icons.work,
              ),
              title: Text(result['title']!),
              subtitle: Text(result['type']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 1. Instantly pop the SearchResultsScreen so it is removed from the backstack history
                Navigator.pop(context);

                if (result['type'] == 'Programme') {
                  // 2. Change tab index to Programmes tab (Index 1)
                  MainShell.shellKey.currentState?.changeTab(1);

                  // 3. Wait for the frame to finish rendering the tab switch, then push details
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      MainShell.shellKey.currentContext!,
                      MaterialPageRoute(
                        builder: (_) => MockDetailsScreen(title: result['title']!),
                      ),
                    );
                  });
                } else if (result['type'] == 'Job') {
                  // 2. Change tab index to Jobs tab (Index 2)
                  MainShell.shellKey.currentState?.changeTab(2);

                  // 3. Wait for the frame to finish rendering the tab switch, then push details
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      MainShell.shellKey.currentContext!,
                      MaterialPageRoute(
                        builder: (_) => MockDetailsScreen(title: result['title']!),
                      ),
                    );
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}

// Inline temporary Mock Detail Screen used to verify navigation
class MockDetailsScreen extends StatelessWidget {
  final String title;
  const MockDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}