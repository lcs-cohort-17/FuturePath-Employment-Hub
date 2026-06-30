import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:futurepath_employment_hub/providers/staff_provider.dart';
import 'package:futurepath_employment_hub/providers/job_provider.dart';
import 'package:futurepath_employment_hub/providers/programme_provider.dart';

void main() {
  testWidgets('FuturePath app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StaffProvider()),
          ChangeNotifierProvider(create: (_) => JobProvider()),
          ChangeNotifierProvider(create: (_) => ProgrammeProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('FuturePath'),
            ),
          ),
        ),
      ),
    );

    // Verify that the app loads.
    expect(find.text('FuturePath'), findsOneWidget);
  });
}
