// lib/providers/user_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/programme.dart';

// Mock data for development
final mockUserProfile = UserProfile(
  id: '1',
  name: 'Sipho Nkosi',
  location: 'Mitchells Plain, Cape Town',
  employmentStatus: 'Unemployed',
  isHired: false,
  email: 'sipho.dlamini@gmail.com',
  phone: '+27 82 123 4567',
  bio: 'Hardworking high school graduate looking for entry-level opportunities in tech and logistics.',
  skills: ['Customer Service', 'Basic Computer Skills', 'Communication'],
  completedProgrammes: [
    Programme(
      id: '1',
      name: 'Computer Literacy Certificate',
      status: 'Certificate issued',
      isCompleted: true,
    ),
    Programme(
      id: '2',
      name: 'Customer Service Training',
      status: 'Certificate issued',
      isCompleted: true,
    ),
  ],
  enrolledProgrammes: [
    Programme(
      id: '3',
      name: 'Introduction to Logistics',
      status: 'In progress',
      isCompleted: false,
      progress: 0.6,
    ),
  ],
);

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(mockUserProfile);

  void updateProfile(UserProfile updatedProfile) {
    state = updatedProfile;
  }

  void addSkill(String skill) {
    if (!state.skills.contains(skill)) {
      state = state.copyWith(
        skills: [...state.skills, skill],
      );
      // TODO: Call API to save to backend
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
      skills: state.skills.where((s) => s != skill).toList(),
    );
    // TODO: Call API to save to backend
  }

  void updateHiredStatus(bool isHired) {
    state = state.copyWith(isHired: isHired);
    // TODO: Call API to save to backend
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

// For reading only (no updates)
final userProfileReadOnlyProvider = Provider<UserProfile>((ref) {
  return ref.watch(userProfileProvider);
});