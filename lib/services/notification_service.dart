import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_prog_001',
      'type': 'programme',
      'referenceId': 'prog_001',
      'title': 'New Programme Available',
      'body': 'A new Flutter Mobile Development programme is now open for applications.',
      'timestamp': '10 mins ago',
      'isRead': false,
    },
    {
      'id': 'notif_job_001',
      'type': 'job',
      'referenceId': '1',
      'title': 'Job Opening Match',
      'body': 'A Junior Flutter Developer role is available that matches your profile.',
      'timestamp': 'Yesterday',
      'isRead': true,
    },
    {
      'id': 'notif_app_001',
      'type': 'application',
      'referenceId': 'app_001',
      'title': 'Application Progress Update',
      'body': 'Your application has moved to the next stage.',
      'timestamp': '2 days ago',
      'isRead': true,
    },
    {
      'id': 'notif_sys_001',
      'type': 'system',
      'referenceId': '',
      'title': 'System Security Update',
      'body': 'Your local platform device authorization keys were updated successfully.',
      'timestamp': '4 days ago',
      'isRead': true,
    },
    {
      'id': 'notif_app_002',
      'type': 'application',
      'referenceId': 'app_002',
      'title': 'Application Logged',
      'body': 'Your application for UI/UX Design Apprentice has been routed into the recruitment pipeline.',
      'timestamp': '1 week ago',
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
