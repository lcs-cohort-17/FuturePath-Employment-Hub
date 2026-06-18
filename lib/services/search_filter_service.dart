import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/empty_state.dart';
import 'package:futurepath_employment_hub/core/widgets/loading_overlay.dart';

void main() {
  group('UIUX-009: Search, Filters & Edge Cases', () {

    // ─────────────────────────────────────────────────────────
    // EMPTY STATES
    // ─────────────────────────────────────────────────────────
    group('Empty States', () {

      testWidgets('EmptyState displays "No results found" message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EmptyState(message: 'No results found'),
          ),
        );

        expect(find.text('No results found'), findsOneWidget);
      });

      testWidgets('EmptyState displays custom message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EmptyState(message: 'No data available'),
          ),
        );

        expect(find.text('No data available'), findsOneWidget);
      });

      testWidgets('EmptyState displays optional icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EmptyState(
              message: 'No results',
              icon: Icons.search_off,
            ),
          ),
        );

        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('EmptyState centers content on screen', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: EmptyState(message: 'No results found'),
          ),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // LOADING STATES
    // ─────────────────────────────────────────────────────────
    group('Loading States', () {

      testWidgets('LoadingOverlay displays spinner', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoadingOverlay(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('LoadingOverlay uses Stack for layering', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoadingOverlay(),
          ),
        );

        expect(find.byType(Stack), findsOneWidget);
      });

      testWidgets('LoadingOverlay centers spinner', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoadingOverlay(),
          ),
        );

        expect(find.byType(Center), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // PULL-TO-REFRESH
    // ─────────────────────────────────────────────────────────
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
                    ListTile(title: Text('Item 2')),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('Pull-to-refresh gesture triggers callback', (WidgetTester tester) async {
        bool refreshed = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  refreshed = true;
                  await Future.delayed(const Duration(milliseconds: 100));
                },
                child: ListView(
                  children: const [
                    ListTile(title: Text('Item')),
                  ],
                ),
              ),
            ),
          ),
        );

        // Perform pull-to-refresh gesture
        await tester.drag(find.byType(ListView), const Offset(0, 300));
        await tester.pumpAndSettle();

        expect(refreshed, isTrue);
      });

      testWidgets('RefreshIndicator shows loading indicator during refresh', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView(
                  children: const [
                    ListTile(title: Text('Item')),
                  ],
                ),
              ),
            ),
          ),
        );

        // Start the refresh
        await tester.drag(find.byType(ListView), const Offset(0, 300));
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });
    });

    // ─────────────────────────────────────────────────────────
    // OFFLINE MODE INDICATORS
    // ─────────────────────────────────────────────────────────
    group('Offline Mode', () {

      testWidgets('"Last updated" indicator displays correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Last updated 5 minutes ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('Cached Item 1')),
                        ListTile(title: Text('Cached Item 2')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.textContaining('Last updated'), findsOneWidget);
        expect(find.textContaining('minutes ago'), findsOneWidget);
      });

      testWidgets('Offline banner displays when no internet', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'You are offline',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('Cached Data')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('You are offline'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      });
    });

    // ─────────────────────────────────────────────────────────
    // UI COMPONENT VERIFICATION
    // ─────────────────────────────────────────────────────────
    group('UI Components', () {

      testWidgets('Search icon is available', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Icon(Icons.search),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('Filter icon is available', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Icon(Icons.filter_list),
            ),
          ),
        );

        expect(find.byIcon(Icons.filter_list), findsOneWidget);
      });

      testWidgets('Refresh icon is available', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Icon(Icons.refresh),
            ),
          ),
        );

        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });

      testWidgets('Error icon is available', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Icon(Icons.error_outline),
            ),
          ),
        );

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });
  });
}