import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/models/notification_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  @override
  List<NotificationItem> build() {
    // We start with an empty list for real-time notifications.
    // In a full implementation, we might fetch existing notifications from a 'Notifications' table.
    return [];
  }

  /// Initializes Supabase Realtime listener for the given applicant.
  void initRealtime(int applicantId) {
    if (_channel != null) return;

    _channel = _supabase
        .channel('public:Job_Applications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Job_Applications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'Applicant_id',
            value: applicantId,
          ),
          callback: (payload) {
            _handleApplicationChange(payload);
          },
        )
        .subscribe();
  }

  /// Initializes Supabase Realtime listener for staff (notifies on new applications).
  void initStaffRealtime() {
    if (_channel != null) return;

    _channel = _supabase
        .channel('public:Job_Applications_Staff')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Job_Applications',
          callback: (payload) {
            _handleStaffApplicationInsert(payload);
          },
        )
        .subscribe();
  }

  void _handleStaffApplicationInsert(PostgresChangePayload payload) {
    final data = payload.newRecord;
    if (data == null || data.isEmpty) return;

    final appId = data['Job_Application_id'] as String?;

    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'Update',
      referenceId: appId ?? '',
      title: 'New Application Received',
      body: 'A new applicant has applied for a position.',
      timestamp: 'Just now',
      isRead: false,
    );

    state = [newItem, ...state];
  }

  void _handleApplicationChange(PostgresChangePayload payload) {
    final data = payload.newRecord;
    // For DELETE events, newRecord is null.
    if (data == null || data.isEmpty) return;

    final status = data['Application_Status'] as String?;
    final appId = data['Job_Application_id'] as String?;

    String title = 'Application Update';
    String body = 'Your application status has been updated.';
    String type = 'Update';

    if (payload.eventType == PostgresChangeEvent.insert) {
      title = 'Application Submitted';
      body = 'Your application has been successfully received by the employer.';
      type = 'Submitted';
    } else if (payload.eventType == PostgresChangeEvent.update) {
      switch (status) {
        case 'accepted':
          title = 'Application Accepted';
          body = 'Congratulations! Your application has been accepted.';
          type = 'Accepted';
          break;
        case 'rejected':
          title = 'Application Rejected';
          body = 'Your application for this position was not successful.';
          type = 'Rejected';
          break;
        case 'under_review':
          title = 'Application Under Review';
          body = 'An employer is currently reviewing your application.';
          type = 'Update';
          break;
        case 'approved':
          title = 'Application Approved';
          body = 'Your application has been approved and moved to the next stage.';
          type = 'Accepted';
          break;
      }
    }

    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      referenceId: appId ?? '',
      title: title,
      body: body,
      timestamp: 'Just now',
      isRead: false,
    );

    // Add new notification to the top of the list
    state = [newItem, ...state];
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

  void dispose() {
    _channel?.unsubscribe();
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, List<NotificationItem>>(() {
  return NotificationsNotifier();
});
