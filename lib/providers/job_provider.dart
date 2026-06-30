import 'package:flutter/material.dart';

class JobProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];
  String? _companyName;
  String? _staffCompanyId; // ← ADD THIS

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get jobs => _jobs;
  String? get companyName => _companyName;

  // ← ADD THIS METHOD
  void setStaffCompany(String companyId) {
    _staffCompanyId = companyId;
    notifyListeners();
  }

  Future<void> loadStaffJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _companyName = 'Amazon SA';
      _jobs = [
        {
          'id': '1',
          'companyInitials': 'AM',
          'title': 'Cloud Support Engineer',
          'company': 'Amazon SA · Cape Town',
          'location': 'Cape Town',
          'type': 'Full-time',
          'positions': 4,
          'skills': ['AWS', 'Linux', 'Terraform'],
          'closingDate': 'Closes 01 Sept',
          'salary': 'R22k–R30k',
          'status': 'Active',
          'meta': 'Cape Town · Full-time · 4 positions',
          'companyId': 'comp_001',
        },
        {
          'id': '2',
          'companyInitials': 'AM',
          'title': 'UX Designer (Junior)',
          'company': 'Amazon SA · Cape Town',
          'location': 'Cape Town',
          'type': 'Full-time',
          'positions': 2,
          'skills': ['Figma', 'User Research'],
          'closingDate': 'Closes 10 Aug',
          'salary': 'R28k–R34k',
          'status': 'Draft',
          'meta': 'Cape Town · Full-time · 2 positions',
          'companyId': 'comp_001',
        },
        {
          'id': '3',
          'companyInitials': 'AM',
          'title': 'Cybersecurity Analyst Trainee',
          'company': 'Amazon SA · Johannesburg',
          'location': 'Johannesburg',
          'type': 'Learnership',
          'positions': 6,
          'skills': ['Network Security', 'Linux'],
          'closingDate': 'Closes 15 Oct',
          'salary': 'R15,000',
          'status': 'Active',
          'meta': 'Johannesburg · Learnership · 6 positions',
          'companyId': 'comp_001',
        },

        {
          'id': '4',
          'companyInitials': 'FT',
          'title': 'Salesforce Admin',
          'company': 'FutureTech · Johannesburg',
          'location': 'Johannesburg',
          'type': 'Internship',
          'positions': 5,
          'skills': ['Salesforce', 'CRM'],
          'closingDate': 'Closes 15 Jul',
          'salary': 'R12,000',
          'status': 'Active',
          'meta': 'Johannesburg · Internship · 5 positions',
          'companyId': 'comp_002',
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load jobs';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ← MODIFY THIS METHOD to filter by staff company
  List<Map<String, dynamic>> filteredJobs(String query, String filter) {
    return _jobs.where((job) {
      // Filter by staff company (only show jobs from staff's company)
      if (_staffCompanyId != null && job['companyId'] != _staffCompanyId) {
        return false;
      }

      final matchesSearch = job['title']
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          job['company'].toLowerCase().contains(query.toLowerCase());

      final matchesFilter = filter == 'All' || job['status'] == filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> refreshJobs() async {
    await loadStaffJobs();
  }

  Future<void> createJob(Map<String, dynamic> jobData) async {
    _jobs.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'companyInitials': 'AM',
      'companyId': _staffCompanyId ?? 'comp_001',
      ...jobData,
    });
    notifyListeners();
  }

  Future<void> updateJob(String id, Map<String, dynamic> jobData) async {
    final index = _jobs.indexWhere((job) => job['id'] == id);
    if (index != -1) {
      _jobs[index] = {..._jobs[index], ...jobData};
      notifyListeners();
    }
  }

  Future<void> deleteJob(String id) async {
    _jobs.removeWhere((job) => job['id'] == id);
    notifyListeners();
  }
}