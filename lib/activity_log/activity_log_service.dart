import '../models/activity_event.dart';
import '../models/activity_log_filter.dart';
import '../../../lib/activity_log/models/raw_event.dart';
import '../../../lib/activity_log/repositories/event_repository.dart';
import '../activity_log/exceptions/activity_log_exception.dart';

class ActivityLogService {
  final IEventRepository _repository;

  const ActivityLogService(this._repository);

  // Returns a list of anonymised activity events.
  // Throws [ActivityLogExceptions] if filter is invalid or repository fails.
  Future<List<ActivityEvent>> getActivityLog(ActivityFilter filter) async {
    try {
      final rawEvents = await _repository.getEvents();

      // Filter by type (if not 'all')
      final filtered = filter == ActivityLogFilter.all
      ? rawEvents
      : rawEvents.where((e) => e.type == _filterToString(filter)).toList();

      // Map to public shape - strip every PII field
      return filtered.map(_toPublicEvent).toList();
    } catch(e) {
      // Wrap any repository error
      throw ActivityLogException(
        'Faile to retrieve activity log: ${e.toString()}',
      );
    }
  }

  String _filterToString(ActivityLogFilter filter) {
    switch (filter) {
      case ActivityLogFilter.applications:
        return 'applications';
      case ActivityLogFilter.enrollments:
        return 'enrollments';
      case ActivityLogFilter.staff:
        return 'staff';
      case ActivityLogFilter.all:
        return '';
    }
  }

  ActivityEvent _toPublicEvent(rawEvent raw) {
    // Ensure description itsel does not contain PII.
    // If the raw description contains placeholders or PII, sanitise it here.
    return ActivityEvent(
      type: raw.type,
      description: raw.description,
      timestamp: raw.timestamp,
    );
  }
}