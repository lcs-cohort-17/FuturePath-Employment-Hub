import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/profile/notifications_screen.dart';
import 'package:futurepath_employment_hub/screens/profile/track_applications_screen.dart';

void main() {
  final mockApplications = [
    {
      'title': 'Flutter Developer',
      'company': 'Tech Corp',
      'status': 'Under Review',
      'progress': 50,
      'appliedDate': DateTime.now().toString(),
    },
  ];

  group('UIUX-008: Notifications & Track Applications', () {
    group('Notifications Screen', () {
      testWidgets('Notifications screen renders without error', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const NotificationsScreen(),
            ),
          ),
        );

        expect(find.byType(NotificationsScreen), findsOneWidget);
      });

      testWidgets('Notifications screen displays title', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const NotificationsScreen(),
            ),
          ),
        );

        expect(find.text('Notifications'), findsOneWidget);
      });

      testWidgets('Notifications screen uses Scaffold', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const NotificationsScreen(),
            ),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Notifications screen is scrollable', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const NotificationsScreen(),
            ),
          ),
        );

        expect(find.byType(ListView), findsWidgets);
      });
    });

    group('Track Applications Screen', () {
      testWidgets('Track Applications screen renders without error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.byType(TrackApplicationsScreen), findsOneWidget);
      });

      testWidgets('Track Applications screen displays title', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.text('Track Applications'), findsOneWidget);
      });

      testWidgets('Track Applications screen uses Scaffold', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Track Applications displays application title', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.text('Flutter Developer'), findsOneWidget);
      });

      testWidgets('Track Applications displays company name', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.text('Tech Corp'), findsOneWidget);
      });

      testWidgets('Track Applications displays status chip', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.byType(Chip), findsWidgets);
      });

      testWidgets('Track Applications uses ListView', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('Track Applications shows progress when expanded', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: TrackApplicationsScreen(applications: mockApplications),
          ),
        );

        // Tap to expand
        await tester.tap(find.text('Flutter Developer'));
        await tester.pumpAndSettle();

        // Now progress bar should be visible
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });
  });
}
