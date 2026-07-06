import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/models/user_profile.dart';
import 'package:futurepath_employment_hub/models/programme.dart';
import 'package:futurepath_employment_hub/core/errors/delete_account_error.dart';
import 'package:futurepath_employment_hub/services/user_profile_service.dart';

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
      title: 'Computer Literacy Certificate',
      status: 'Certificate issued',
      isCompleted: true,
      progress: 1.0,
    ),
    Programme(
      id: '2',
      title: 'Customer Service Training',
      status: 'Certificate issued',
      isCompleted: true,
      progress: 1.0,
    ),
  ],
  enrolledProgrammes: [
    Programme(
      id: '3',
      title: 'Introduction to Logistics',
      status: 'In progress',
      isCompleted: false,
      progress: 0.6,
    ),
  ],
);

// Empty profile for initial state
final emptyUserProfile = UserProfile(
  id: '',
  name: '',
  displayName: '',
  location: '',
  employmentStatus: '',
  isHired: false,
  email: '',
  skills: [],
  completedProgrammes: [],
  enrolledProgrammes: [],
);

class UserProfileNotifier extends Notifier<UserProfile> {
  final UserProfileService _profileService = UserProfileService();

  @override
  UserProfile build() {
    return emptyUserProfile;
  }

  Future<void> fetchProfile(String userId) async {
    final profile = await _profileService.fetchUserProfile(userId);
    if (profile != null) {
      state = profile;
    }
  }

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
    state = emptyUserProfile;
  }

  // ── Delete-account state ────────────────────────────────────────────────

  bool _isDeletingAccount = false;
  bool get isDeletingAccount => _isDeletingAccount;

  DeleteAccountException? _deleteAccountError;
  DeleteAccountException? get deleteAccountError => _deleteAccountError;

  /// Deletes the account for [userId] then clears local profile state.
  Future<bool> deleteAccount(String userId) async {
    _isDeletingAccount = true;
    _deleteAccountError = null;

    try {
      await UserProfileService().deleteUserAccount(userId);
      clearProfile();
      _isDeletingAccount = false;
      return true;
    } on DeleteAccountException catch (e) {
      _deleteAccountError = e;
      _isDeletingAccount = false;
      return false;
    } catch (e) {
      _deleteAccountError = DeleteAccountException(
        code: DeleteAccountErrorCode.unknown,
        userMessage: 'An unexpected error occurred.',
        technicalDetail: e.toString(),
      );
      _isDeletingAccount = false;
      return false;
    }
  }

  void clearDeleteAccountError() {
    _deleteAccountError = null;
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(() {
  return UserProfileNotifier();
});
