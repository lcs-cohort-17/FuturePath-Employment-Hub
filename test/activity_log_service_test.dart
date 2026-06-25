import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/activity_log/activity_log_service.dart';
import 'package:your_app/activity_log/models/activity_log_filter.dart';
import 'package:your_app/activity_log/models/raw_event.dart';
import 'package:your_app/activity_log/repositories/mock_event_repository.dart';
import 'package:your_app/activity_log/exceptions/activity_log_exception.dart';

void main() {
  group('ActivityLogService', () {
    late ActivityLogService service;

    setUp(() {
      final repository = MockEventRepository();
      service = ActivityLogService(repository);
    });

    test('returns all events when filter is all', () async {
      final events = await service.getActivityLog(ActivityLogFilter.all);
      expect(events.length, 4);
      // No PII fields
      for (var e in events) {
        expect(e, isA<ActivityEvent>());
        // ensure no PII fields are present (by checking toString)
        expect(e.toString(), isNot(contains('userName')));
        expect(e.toString(), isNot(contains('userEmail')));
        expect(e.toString(), isNot(contains('userId')));
      }
    });

    test('filters by applications', () async {
      final events = await service.getActivityLog(ActivityLogFilter.applications);
      expect(events.length, 2);
      expect(events.every((e) => e.type == 'applications'), true);
    });

    test('filters by enrollments', () async {
      final events = await service.getActivityLog(ActivityLogFilter.enrollments);
      expect(events.length, 1);
      expect(events.first.type, 'enrollments');
    });

    test('filters by staff', () async {
      final events = await service.getActivityLog(ActivityLogFilter.staff);
      expect(events.length, 1);
      expect(events.first.type, 'staff');
    });

    test('throws ActivityLogException when repository fails', () async {
      final failingRepo = _FailingRepository();
      final failingService = ActivityLogService(failingRepo);
      expect(
            () => failingService.getActivityLog(ActivityLogFilter.all),
        throwsA(isA<ActivityLogException>()),
      );
    });
  });
}

class _FailingRepository implements IEventRepository {
  @override
  Future<List<RawEvent>> getEvents() async {
    throw Exception('DB connection lost');
  }
}