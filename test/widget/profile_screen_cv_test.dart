import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/models/user_profile.dart';
import 'package:futurepath_employment_hub/screens/profile/profile_screen.dart';

void main() {
  testWidgets('shows the saved CV name on the profile screen', (tester) async {
    final profile = UserProfile(
      id: '1',
      name: 'Test User',
      location: 'Cape Town',
      employmentStatus: 'Unemployed',
      isHired: false,
      email: 'test@example.com',
      cvFileName: 'resume.pdf',
      completedProgrammes: const [],
      enrolledProgrammes: const [],
      savedProgrammes: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreenContent(
          userProfile: profile,
          onSignOut: () {},
          onNavigateToCV: () {},
          onNavigateToNotifications: () {},
          onNavigateToTrackApplications: () {},
        ),
      ),
    );

    expect(find.textContaining('resume.pdf'), findsWidgets);
  });
}
