import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/screens/auth/sign_up_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

void main() {
  setUpAll(() async {
    // Prevent platform channel exceptions during Supabase initialization
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://supabase.co',
      publishableKey: 'mock-anon-key-12345',
    );
  });

  group('UIUX-011: Signup Screen Comprehensive Tests', () {

    Widget createWidgetUnderTest() {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SignupScreen(),
      );
    }

    group('Dropdown Options & Choice Fields', () {
      testWidgets('validates dropdown field choices render correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final genderDropdown = find.widgetWithText(DropdownButtonFormField<String>, 'Select gender');
        final qualificationDropdown = find.widgetWithText(DropdownButtonFormField<String>, 'Select qualification');
        final employmentDropdown = find.widgetWithText(DropdownButtonFormField<String>, 'Select employment status');

        expect(genderDropdown, findsOneWidget);
        expect(qualificationDropdown, findsOneWidget);
        expect(employmentDropdown, findsOneWidget);
      });

      testWidgets('allows multi-selection checking on FilterChips skills', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final communicationChip = find.widgetWithText(FilterChip, 'Communication');
        expect(communicationChip, findsOneWidget);

        // FIX: Scroll down inside SingleChildScrollView to bring the chip into view area
        await tester.ensureVisible(communicationChip);
        await tester.pumpAndSettle();

        FilterChip communicationWidget = tester.widget<FilterChip>(communicationChip);
        expect(communicationWidget.selected, isFalse);

        // Tap the chip now that it is visible
        await tester.tap(communicationChip);
        await tester.pumpAndSettle();

        communicationWidget = tester.widget<FilterChip>(communicationChip);
        expect(communicationWidget.selected, isTrue);
      });
    });

    group('Interactive Regex & Form Rules', () {
      testWidgets('enforces strict rules on input phone formats', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final phoneFieldFinder = find.widgetWithText(TextFormField, '071 234 5678');
        final phoneField = tester.widget<TextFormField>(phoneFieldFinder);

        expect(phoneField.validator!(''), equals('Contact number is required'));
        expect(phoneField.validator!('071 abc 1234'), equals('Enter a valid contact number'));
        expect(phoneField.validator!('0712345678'), isNull);
      });

      testWidgets('enforces safety rules on password complexity match strings', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // FIX: Find the password text field directly by its hidden hint text layout parameter
        final passwordFinder = find.widgetWithText(TextFormField, 'Password');
        final passwordField = tester.widget<TextFormField>(passwordFinder);

        expect(passwordField.validator!(''), equals('Password is required'));
        expect(passwordField.validator!('123'), equals('Password must be at least 6 characters'));
        expect(passwordField.validator!('password123'), isNull);
      });
    });

    group('Submission Component Elements', () {
      testWidgets('renders account creation submission action button', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final buttonFinder = find.widgetWithText(FilledButton, 'Create Account');
        expect(buttonFinder, findsOneWidget);

        final filledButton = tester.widget<FilledButton>(buttonFinder);
        expect(filledButton.onPressed, isNotNull);
      });
    });
  });
}
