import 'package:flutter/material.dart';

class PublicDataProvider extends ChangeNotifier {
  List<dynamic> _allEmployers = [];
  List<dynamic> _allOpportunities = [];

  List<dynamic> get allEmployers => _allEmployers;

  // Resolves employer meta matrices by ID
  Map<String, dynamic>? getEmployerById(String employerId) {
    try {
      return _allEmployers.firstWhere((emp) => emp['id'] == employerId);
    } catch (_) {
      return null;
    }
  }

  // Filters opportunities list matching targeted employerId matching guideline logic
  List<dynamic> getOpportunitiesByEmployer(String employerId) {
    return _allOpportunities.where((opp) => opp['employerId'] == employerId).toList();
  }
}