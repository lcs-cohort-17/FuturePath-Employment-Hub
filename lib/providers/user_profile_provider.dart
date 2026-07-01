import 'package:flutter/foundation.dart';
import 'package:futurepath_employment_hub/models/user_profile.dart';
import 'package:futurepath_employment_hub/models/programme.dart';

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
    const Programme(
      id: '1',
      title: 'Computer Literacy Certificate',
      status: 'Certificate issued',
      isCompleted: true,
      progress: 1.0,
    ),
    const Programme(
      id: '2',
      title: 'Customer Service Training',
      status: 'Certificate issued',
      isCompleted: true,
      progress: 1.0,
    ),
  ],
  enrolledProgrammes: [
    const Programme(
      id: '3',
      title: 'Introduction to Logistics',
      status: 'In progress',
      isCompleted: false,
      progress: 0.6,
    ),
  ],
);

class UserProfileProvider extends ChangeNotifier {
  UserProfile _profile = mockUserProfile;

  UserProfile get profile => _profile;

  void setUserProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateProfile(UserProfile updatedProfile) {
    _profile = updatedProfile;
    notifyListeners();
  }

  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !_profile.skills.contains(trimmed)) {
      _profile = _profile.copyWith(
        skills: [..._profile.skills, trimmed],
      );
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _profile = _profile.copyWith(
      skills: _profile.skills.where((s) => s != skill).toList(),
    );
    notifyListeners();
  }

  void updateHiredStatus(bool isHired) {
    _profile = _profile.copyWith(isHired: isHired);
    notifyListeners();
  }

  void updateEmploymentStatus(String status) {
    _profile = _profile.copyWith(employmentStatus: status);
    notifyListeners();
  }

  void addSavedProgramme(Programme programme) {
    final updatedSaved = List<Programme>.from(_profile.savedProgrammes)..add(programme);
    _profile = _profile.copyWith(savedProgrammes: updatedSaved);
    notifyListeners();
  }

  void removeSavedProgramme(String programmeId) {
    final updatedSaved = _profile.savedProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    _profile = _profile.copyWith(savedProgrammes: updatedSaved);
    notifyListeners();
  }

  void addEnrolledProgramme(Programme programme) {
    final updatedEnrolled = List<Programme>.from(_profile.enrolledProgrammes)..add(programme);
    _profile = _profile.copyWith(enrolledProgrammes: updatedEnrolled);
    notifyListeners();
  }

  void removeEnrolledProgramme(String programmeId) {
    final updatedEnrolled = _profile.enrolledProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    _profile = _profile.copyWith(enrolledProgrammes: updatedEnrolled);
    notifyListeners();
  }

  void addCompletedProgramme(Programme programme) {
    final updatedCompleted = List<Programme>.from(_profile.completedProgrammes)..add(programme);
    _profile = _profile.copyWith(completedProgrammes: updatedCompleted);
    notifyListeners();
  }

  void clearProfile() {
    _profile = mockUserProfile;
    notifyListeners();
  }
}
