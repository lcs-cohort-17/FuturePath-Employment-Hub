import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/models/programme.dart';
import 'package:futurepath_employment_hub/models/user_profile.dart';
import 'package:futurepath_employment_hub/providers/user_profile_provider.dart';

void main() {
  group('UserProfileNotifier', () {
    late UserProfile mockProfile;
    late UserProfileNotifier notifier;

    setUp(() {
      mockProfile = UserProfile(
        id: '1',
        name: 'Sipho Nkosi',
        location: 'Mitchells Plain, Cape Town',
        employmentStatus: 'Unemployed',
        isHired: false,
        email: 'sipho.dlamini@gmail.com',
        phone: '+27 82 123 4567',
        bio: 'Hardworking high school graduate.',
        skills: ['Customer Service', 'Basic Computer Skills'],
        completedProgrammes: [],
        enrolledProgrammes: [],
      );
      notifier = UserProfileNotifier();
      notifier.updateProfile(mockProfile);
    });

    test('addSkill should add a new skill', () {
      notifier.addSkill('Flutter');
      expect(notifier.state.skills, contains('Flutter'));
      expect(notifier.state.skills.length, equals(3));
    });

    test('addSkill should trim whitespace', () {
      notifier.addSkill('  Flutter  ');
      expect(notifier.state.skills, contains('Flutter'));
    });

    test('addSkill should not add empty skills', () {
      notifier.addSkill('');
      notifier.addSkill('   ');
      expect(notifier.state.skills.length, equals(2));
    });

    test('removeSkill should remove a skill', () {
      notifier.removeSkill('Customer Service');
      expect(notifier.state.skills, isNot(contains('Customer Service')));
      expect(notifier.state.skills.length, equals(1));
    });

    test('updateHiredStatus should update isHired', () {
      notifier.updateHiredStatus(true);
      expect(notifier.state.isHired, isTrue);

      notifier.updateHiredStatus(false);
      expect(notifier.state.isHired, isFalse);
    });

    test('updateEmploymentStatus should update employment status', () {
      notifier.updateEmploymentStatus('Employed');
      expect(notifier.state.employmentStatus, equals('Employed'));
    });

    test('addCompletedProgramme should add to completed list', () {
      const programme = Programme(
        id: '1',
        name: 'Computer Literacy',
        status: 'Completed',
        isCompleted: true,
      );
      notifier.addCompletedProgramme(programme);
      expect(notifier.state.completedProgrammes, contains(programme));
    });

    test('addEnrolledProgramme should add to enrolled list', () {
      const programme = Programme(
        id: '2',
        name: 'Logistics Course',
        status: 'In progress',
        isCompleted: false,
        progress: 0.5,
      );
      notifier.addEnrolledProgramme(programme);
      expect(notifier.state.enrolledProgrammes, contains(programme));
    });

    test('updateProfile should replace entire profile', () {
      final newProfile = mockProfile.copyWith(
        name: 'New Name',
        location: 'New Location',
      );
      notifier.updateProfile(newProfile);
      expect(notifier.state.name, equals('New Name'));
      expect(notifier.state.location, equals('New Location'));
    });
  });

  group('userProfileProvider', () {
    test('provider should return initial state', () {
      final container = ProviderContainer();
      final profile = container.read(userProfileProvider);
      expect(profile.name, isNotEmpty);
      expect(profile.skills, isNotEmpty);
    });

    test('provider should update state when notifier changes', () {
      final container = ProviderContainer();
      final notifier = container.read(userProfileProvider.notifier);

      notifier.addSkill('New Skill');
      final profile = container.read(userProfileProvider);

      expect(profile.skills, contains('New Skill'));
    });
  });
}
