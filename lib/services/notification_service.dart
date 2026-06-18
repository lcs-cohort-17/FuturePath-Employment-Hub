import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  // Singleton Pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Application Shortlisted!',
      'body': 'Your engineering submission for Junior Mobile Developer has been approved for round 2 technical review assessments.',
      'timestamp': '10 mins ago',
      'type': 'Accepted',
      'isRead': false,
    },
    {
      'title': 'Profile Visited',
      'body': 'An internal HR acquisition officer from Vuka Digital Studio evaluated your engineering experience profile block.',
      'timestamp': 'Yesterday',
      'type': 'Update',
      'isRead': true,
    },
    {
      'title': 'Document Acknowledged',
      'body': 'The academic transcript certificate update attached to your dashboard workspace profile has been indexed successfully.',
      'timestamp': '2 days ago',
      'type': 'Submitted',
      'isRead': true,
    },
    {
      'title': 'System Security Update',
      'body': 'Your local platform device authorization keys were updated successfully from your Windows workspace target environment context.',
      'timestamp': '4 days ago',
      'type': 'System',
      'isRead': true,
    },
    {
      'title': 'Application Logged',
      'body': 'Your digital application for UI/UX Design Apprentice at Siyakha Media House was cleanly routed into their recruiting queue pipeline structure.',
      'timestamp': '1 week ago',
      'type': 'Submitted',
      'isRead': true,
    }
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n['isRead']).length;

  void markAsRead(int index) {
    _notifications[index]['isRead'] = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n['isRead'] = true;
    }
    notifyListeners();
  }
}
