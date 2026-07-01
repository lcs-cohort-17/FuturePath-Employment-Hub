import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:futurepath_employment_hub/providers/admin_provider.dart';

void main() {
  testWidgets('FuturePath app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AdminProvider()),
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

    expect(find.text('FuturePath'), findsOneWidget);
  });
}