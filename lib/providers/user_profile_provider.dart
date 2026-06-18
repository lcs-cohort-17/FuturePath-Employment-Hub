import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/programme.dart';

// Mock data for development
final mockUserProfile = UserProfile(
  id: '1',
  name: 'Sipho Nkosi',
  displayName: 'Sipho Nkosi',
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
      progress: 1.0,
    ),
    Programme(
      id: '2',
      name: 'Customer Service Training',
      status: 'Certificate issued',
      isCompleted: true,
      progress: 1.0,
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

  void setUserProfile(UserProfile profile) {
    state = profile;
  }

  void updateProfile(UserProfile updatedProfile) {
    state = updatedProfile;
  }

  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !state.skills.contains(trimmed)) {
      state = state.copyWith(
        skills: [...state.skills, trimmed],
      );
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
      skills: state.skills.where((s) => s != skill).toList(),
    );
  }

  void updateHiredStatus(bool isHired) {
    state = state.copyWith(isHired: isHired);
  }

  void updateEmploymentStatus(String status) {
    state = state.copyWith(employmentStatus: status);
  }

  void addSavedProgramme(Programme programme) {
    final updatedSaved = List<Programme>.from(state.savedProgrammes)..add(programme);
    state = state.copyWith(savedProgrammes: updatedSaved);
  }

  void removeSavedProgramme(String programmeId) {
    final updatedSaved = state.savedProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    state = state.copyWith(savedProgrammes: updatedSaved);
  }

  void addEnrolledProgramme(Programme programme) {
    final updatedEnrolled = List<Programme>.from(state.enrolledProgrammes)..add(programme);
    state = state.copyWith(enrolledProgrammes: updatedEnrolled);
  }

  void removeEnrolledProgramme(String programmeId) {
    final updatedEnrolled = state.enrolledProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    state = state.copyWith(enrolledProgrammes: updatedEnrolled);
  }

  void addCompletedProgramme(Programme programme) {
    final updatedCompleted = List<Programme>.from(state.completedProgrammes)..add(programme);
    state = state.copyWith(completedProgrammes: updatedCompleted);
  }

  void clearProfile() {
    state = mockUserProfile;
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

// For reading only (no updates)
final userProfileReadOnlyProvider = Provider<UserProfile>((ref) {
  return ref.watch(userProfileProvider);
});
