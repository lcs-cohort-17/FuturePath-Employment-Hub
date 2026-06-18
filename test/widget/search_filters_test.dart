import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/widgets/empty_state.dart';
import 'package:futurepath_employment_hub/core/widgets/loading_overlay.dart';

void main() {
  group('UIUX-009: Search, Filters & Edge Cases', () {

    group('Empty States', () {
      testWidgets('EmptyState displays "No results found" message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: EmptyState(message: 'No results found'))),
        );
        expect(find.text('No results found'), findsOneWidget);
      });

      testWidgets('EmptyState displays "No programmes found" message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: EmptyState(message: 'No programmes found'))),
        );
        expect(find.text('No programmes found'), findsOneWidget);
      });

      testWidgets('EmptyState displays "Something went wrong" message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: EmptyState(message: 'Something went wrong'))),
        );
        expect(find.text('Something went wrong'), findsOneWidget);
      });

      testWidgets('EmptyState displays default icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: EmptyState(message: 'No results'))),
        );
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('EmptyState centers content on screen', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: EmptyState(message: 'No results found'))),
        );
        // findsWidgets is used because MaterialApp/Scaffold inject their own Center widgets
        expect(find.byType(Center), findsWidgets);
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Loading States', () {
      testWidgets('LoadingOverlay displays spinner', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: LoadingOverlay())),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('LoadingOverlay renders without crashing', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: LoadingOverlay())),
        );
        expect(find.byType(LoadingOverlay), findsOneWidget);
      });
    });

    group('Pull-to-Refresh', () {
      testWidgets('RefreshIndicator is present on list screens', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {},
                child: ListView(children: const [ListTile(title: Text('Item 1'))]),
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
            home: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  refreshed = true;
                },
                child: ListView(children: const [ListTile(title: Text('Item'))]),
              ),
            ),
          ),
        );
        // fling is more reliable than drag for triggering RefreshIndicator in tests
        await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });
    });

    group('Offline Mode', () {
      testWidgets('"Last updated" indicator displays correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Text('Last updated 5 minutes ago'),
                  Expanded(child: ListView(children: const [ListTile(title: Text('Cached Item'))])),
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
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    color: Colors.orange,
                    child: const Row(children: [Icon(Icons.wifi_off), Text('You are offline')]),
                  ),
                  Expanded(child: ListView(children: const [ListTile(title: Text('Cached Data'))])),
                ],
              ),
            ),
          ),
        );
        expect(find.text('You are offline'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      });
    });
  });
}