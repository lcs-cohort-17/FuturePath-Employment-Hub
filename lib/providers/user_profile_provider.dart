import 'package:flutter/foundation.dart';
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

class UserProfileNotifier extends ChangeNotifier {
  UserProfile _state = mockUserProfile;

  UserProfile get state => _state;

  void setUserProfile(UserProfile profile) {
    _state = profile;
    notifyListeners();
  }

  void updateProfile(UserProfile updatedProfile) {
    _state = updatedProfile;
    notifyListeners();
  }

  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !_state.skills.contains(trimmed)) {
      _state = _state.copyWith(
        skills: [..._state.skills, trimmed],
      );
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _state = _state.copyWith(
      skills: _state.skills.where((s) => s != skill).toList(),
    );
    notifyListeners();
  }

  void updateHiredStatus(bool isHired) {
    _state = _state.copyWith(isHired: isHired);
    notifyListeners();
  }

  void updateEmploymentStatus(String status) {
    _state = _state.copyWith(employmentStatus: status);
    notifyListeners();
  }

  void addSavedProgramme(Programme programme) {
    final updatedSaved = List<Programme>.from(_state.savedProgrammes)..add(programme);
    _state = _state.copyWith(savedProgrammes: updatedSaved);
    notifyListeners();
  }

  void removeSavedProgramme(String programmeId) {
    final updatedSaved = _state.savedProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    _state = _state.copyWith(savedProgrammes: updatedSaved);
    notifyListeners();
  }

  void addEnrolledProgramme(Programme programme) {
    final updatedEnrolled = List<Programme>.from(_state.enrolledProgrammes)..add(programme);
    _state = _state.copyWith(enrolledProgrammes: updatedEnrolled);
    notifyListeners();
  }

  void removeEnrolledProgramme(String programmeId) {
    final updatedEnrolled = _state.enrolledProgrammes
        .where((p) => p.id != programmeId)
        .toList();
    _state = _state.copyWith(enrolledProgrammes: updatedEnrolled);
    notifyListeners();
  }

  void addCompletedProgramme(Programme programme) {
    final updatedCompleted = List<Programme>.from(_state.completedProgrammes)..add(programme);
    _state = _state.copyWith(completedProgrammes: updatedCompleted);
    notifyListeners();
  }

  void clearProfile() {
    _state = mockUserProfile;
    notifyListeners();
  }
}