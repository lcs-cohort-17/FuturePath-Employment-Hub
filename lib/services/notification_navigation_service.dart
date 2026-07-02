import '../screens/shell/main_shell.dart';

enum NotificationTargetKind { programme, job, application }

class NotificationNavigationTarget {
  final NotificationTargetKind kind;
  final int tabIndex;
  final String referenceId;

  const NotificationNavigationTarget({
    required this.kind,
    required this.tabIndex,
    required this.referenceId,
  });
}

class NotificationNavigationResolver {
  static NotificationNavigationTarget? resolve(Map<String, dynamic>? item) {
    final type = (item?['type'] as String?)?.toLowerCase().trim();
    final referenceId = (item?['referenceId'] as String?)?.trim() ?? '';

    switch (type) {
      case 'programme':
        return NotificationNavigationTarget(
          kind: NotificationTargetKind.programme,
          tabIndex: AppShell.programmesTabIndex,
          referenceId: referenceId,
        );
      case 'job':
        return NotificationNavigationTarget(
          kind: NotificationTargetKind.job,
          tabIndex: AppShell.jobsTabIndex,
          referenceId: referenceId,
        );
      case 'application':
        return NotificationNavigationTarget(
          kind: NotificationTargetKind.application,
          tabIndex: AppShell.profileTabIndex,
          referenceId: referenceId,
        );
      default:
        return null;
    }
  }
}
