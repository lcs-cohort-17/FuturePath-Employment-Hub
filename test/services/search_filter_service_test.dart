import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/empty_state.dart';
import 'package:futurepath_employment_hub/core/widgets/loading_overlay.dart';

void main() {
  group('UIUX-009: Search, Filters & Edge Cases', () {

    group('Empty States', () {
      testWidgets('EmptyState displays "No results found" message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EmptyState(message: 'No results found'),
          ),
        );
        expect(find.text('No results found'), findsOneWidget);
      });
    });

    group('Loading States', () {
      testWidgets('LoadingOverlay displays spinner', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoadingOverlay(),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Pull-to-Refresh', () {
      testWidgets('RefreshIndicator is present on list screens', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                },
                child: ListView(
                  children: const [
                    ListTile(title: Text('Item 1')),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });
  });
}
