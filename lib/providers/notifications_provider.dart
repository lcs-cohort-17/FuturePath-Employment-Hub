import 'package:flutter/foundation.dart';
import 'package:futurepath_employment_hub/models/notification_item.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_prog_001',
      type: 'programme',
      referenceId: 'prog_001',
      title: 'New Programme Available',
      body: 'A new Flutter Mobile Development programme is now open for applications.',
      timestamp: '10 mins ago',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_job_001',
      type: 'job',
      referenceId: '1',
      title: 'Job Opening Match',
      body: 'A Junior Flutter Developer role is available that matches your profile.',
      timestamp: 'Yesterday',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_app_001',
      type: 'application',
      referenceId: 'app_001',
      title: 'Application Progress Update',
      body: 'Your application has moved to the next stage.',
      timestamp: '2 days ago',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_sys_001',
      type: 'system',
      referenceId: '',
      title: 'System Security Update',
      body: 'Your local platform device authorization keys were updated successfully.',
      timestamp: '4 days ago',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_app_002',
      type: 'application',
      referenceId: 'app_002',
      title: 'Application Logged',
      body: 'Your application for UI/UX Design Apprentice has been routed into the recruitment pipeline.',
      timestamp: '1 week ago',
      isRead: true,
    )
  ];

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications = [];
    notifyListeners();
  }
}
