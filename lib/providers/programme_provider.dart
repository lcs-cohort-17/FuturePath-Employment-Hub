import 'package:flutter/material.dart';

class ProgrammeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _programmes = [];
  String? _companyName;
  String? _staffCompanyId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get programmes => _programmes;
  String? get companyName => _companyName;


  void setStaffCompany(String companyId) {
    _staffCompanyId = companyId;
    notifyListeners();
  }

  Future<void> loadStaffProgrammes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _companyName = 'Amazon SA';
      _programmes = [
        {
          'id': '1',
          'category': 'Technology',
          'status': 'Active',
          'title': 'Cloud Fundamentals Bootcamp',
          'duration': '3 months',
          'level': 'Beginner',
          'enrolled': 12,
          'capacity': 20,
          'startDate': 'Starts 01 Jul 2026',
          'companyId': 'comp_001',
        },
        {
          'id': '2',
          'category': 'Security',
          'status': 'Upcoming',
          'title': 'Cybersecurity Essentials',
          'duration': '3 months',
          'level': 'Intermediate',
          'enrolled': 0,
          'capacity': 25,
          'startDate': 'Starts 01 Oct 2026',
          'companyId': 'comp_001',
        },
        {
          'id': '3',
          'category': 'Marketing',
          'status': 'Active',
          'title': 'Digital Marketing Fundamentals',
          'duration': '2 months',
          'level': 'Beginner',
          'enrolled': 38,
          'capacity': 40,
          'startDate': 'Starts 01 Aug 2026',
          'companyId': 'comp_002',
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load programmes';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> filteredProgrammes(String query, String filter) {
    return _programmes.where((prog) {
      // Filter by staff company (only show programmes from staff's company)
      if (_staffCompanyId != null && prog['companyId'] != _staffCompanyId) {
        return false;
      }

      final matchesSearch = prog['title']
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          prog['category'].toLowerCase().contains(query.toLowerCase());

      final matchesFilter = filter == 'All' || prog['status'] == filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }


  Future<void> refreshProgrammes() async {
    await loadStaffProgrammes();
  }

  Future<void> createProgramme(Map<String, dynamic> programmeData) async {
    _programmes.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'companyId': _staffCompanyId ?? 'comp_001',
      ...programmeData,
      'enrolled': 0,
    });
    notifyListeners();
  }

  Future<void> updateProgramme(String id, Map<String, dynamic> programmeData) async {
    final index = _programmes.indexWhere((prog) => prog['id'] == id);
    if (index != -1) {
      _programmes[index] = {..._programmes[index], ...programmeData};
      notifyListeners();
    }
  }

  Future<void> deleteProgramme(String id) async {
    _programmes.removeWhere((prog) => prog['id'] == id);
    notifyListeners();
  }
}