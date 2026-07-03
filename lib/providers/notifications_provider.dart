import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/models/notification_item.dart';

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    return [
      NotificationItem(
        id: '1',
        type: 'Accepted',
        referenceId: 'app_001',
        title: 'Application Accepted',
        body: 'Your application for Digital Marketing Assistant has been accepted.',
        timestamp: '2 hours ago',
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        type: 'Update',
        referenceId: 'user_001',
        title: 'Profile View',
        body: 'TechNova Solutions viewed your profile recently.',
        timestamp: '5 hours ago',
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        type: 'Submitted',
        referenceId: 'app_002',
        title: 'Application Submitted',
        body: 'You have successfully applied for Junior Flutter Developer.',
        timestamp: '1 day ago',
        isRead: true,
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isRead: true)
        else
          item,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final item in state)
        item.copyWith(isRead: true)
    ];
  }

  void addNotification(NotificationItem item) {
    state = [item, ...state];
  }

  void clearNotifications() {
    state = [];
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, List<NotificationItem>>(() {
  return NotificationsNotifier();
});
