import 'package:flutter/material.dart';

class ApplicationsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void setApplications(List<Map<String, dynamic>> applications) {
    _items = applications;
    notifyListeners();
  }
}