import 'package:flutter/material.dart';

class StaffProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _staffName;
  int? _totalJobs;
  int? _activeJobs;
  int? _totalProgrammes;
  int? _activeProgrammes;
  List<Map<String, dynamic>> _recentJobs = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get staffName => _staffName;
  int? get totalJobs => _totalJobs;
  int? get activeJobs => _activeJobs;
  int? get totalProgrammes => _totalProgrammes;
  int? get activeProgrammes => _activeProgrammes;
  List<Map<String, dynamic>> get recentJobs => _recentJobs;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call - replace with real Supabase calls
      await Future.delayed(const Duration(seconds: 1));

      _staffName = 'Thabo Nkosi';
      _totalJobs = 8;
      _activeJobs = 5;
      _totalProgrammes = 4;
      _activeProgrammes = 3;
      _recentJobs = [
        {
          'title': 'Cloud Support Engineer',
          'company': 'Amazon SA · Cape Town',
          'skills': ['AWS', 'Linux', 'Terraform'],
          'meta': 'Added 2 days ago · 4 positions',
          'status': 'Active',
        },
        {
          'title': 'Business Development Intern',
          'company': 'Amazon SA · Pretoria',
          'skills': ['Sales', 'CRM'],
          'meta': 'Added 5 days ago · 2 positions',
          'status': 'Draft',
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard data';
      _isLoading = false;
      notifyListeners();
    }
  }
}