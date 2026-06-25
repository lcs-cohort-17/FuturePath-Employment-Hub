import '../models/raw_event.dart';
import 'event_repository.dart';

/// Returns dummy events with PII fields – perfect for testing anonymisation.
class MockEventRepository implements IEventRepository {
  @override
  Future<List<RawEvent>> getEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const RawEvent(
        id: '1',
        type: 'applications',
        description: 'Application submitted by John Doe (john@example.com)',
        timestamp: DateTime.utc(2026, 1, 1, 10, 0),
        userName: 'John Doe',
        userEmail: 'john@example.com',
        userId: 'u123',
      ),
      const RawEvent(
        id: '2',
        type: 'enrollments',
        description: 'Enrollment created for Jane Smith',
        timestamp: DateTime.utc(2026, 1, 2, 11, 0),
        userName: 'Jane Smith',
        userEmail: 'jane@example.com',
        userId: 'u456',
      ),
      const RawEvent(
        id: '3',
        type: 'staff',
        description: 'Staff member Bob Admin added',
        timestamp: DateTime.utc(2026, 1, 3, 12, 0),
        userName: 'Bob Admin',
        userEmail: 'bob@admin.com',
        userId: 'u789',
      ),
      const RawEvent(
        id: '4',
        type: 'applications',
        description: 'Application approved for Alice Cooper (alice@cooper.com)',
        timestamp: DateTime.utc(2026, 1, 4, 13, 0),
        userName: 'Alice Cooper',
        userEmail: 'alice@example.com',
        userId: 'u101',
      ),
    ];
  }
}