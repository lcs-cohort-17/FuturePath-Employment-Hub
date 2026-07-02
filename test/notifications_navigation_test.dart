import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/shell/main_shell.dart';
import 'package:futurepath_employment_hub/services/notification_navigation_service.dart';

void main() {
  group('NotificationNavigationResolver', () {
    test('returns the programme tab for programme notifications', () {
      final target = NotificationNavigationResolver.resolve({
        'type': 'programme',
        'referenceId': 'prog_001',
      });

      expect(target, isNotNull);
      expect(target!.kind, NotificationTargetKind.programme);
      expect(target.tabIndex, AppShell.programmesTabIndex);
      expect(target.referenceId, 'prog_001');
    });

    test('returns the jobs tab for job notifications', () {
      final target = NotificationNavigationResolver.resolve({
        'type': 'job',
        'referenceId': '1',
      });

      expect(target, isNotNull);
      expect(target!.kind, NotificationTargetKind.job);
      expect(target.tabIndex, AppShell.jobsTabIndex);
      expect(target.referenceId, '1');
    });

    test('returns the profile tab for application notifications', () {
      final target = NotificationNavigationResolver.resolve({
        'type': 'application',
        'referenceId': 'app_001',
      });

      expect(target, isNotNull);
      expect(target!.kind, NotificationTargetKind.application);
      expect(target.tabIndex, AppShell.profileTabIndex);
      expect(target.referenceId, 'app_001');
    });

    test('returns null for unsupported notification types', () {
      final target = NotificationNavigationResolver.resolve({
        'type': 'system',
        'referenceId': '',
      });

      expect(target, isNull);
    });
  });
}
