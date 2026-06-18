// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FuturePathApp(),
      ),
    );

    // Verify that the initial screen (Home) is displayed.
    expect(find.text('Home'), findsWidgets);
  });
}
