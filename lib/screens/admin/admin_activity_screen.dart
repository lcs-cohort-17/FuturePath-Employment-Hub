// Antonio ticket 017 starts here
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/activity_log_event.dart';
import '../../services/activity_log_service.dart';

/// Admin — Activity Log screen.
///
/// Standalone screen (no logged ticket ID yet — built on top of INT-013,
/// distinct from the "Anonymized Activity Feed" section embedded in the
/// Admin Dashboard / UIUX-016). Matches the HTML mock's
/// Admin role → "Activity" tab exactly.
///
/// Shows fully anonymised activity events with filter chips for
/// All / Applications / Enrollments / Staff. No user names, emails, or
/// IDs are ever rendered here.
class AdminActivityScreen extends StatefulWidget {
  const AdminActivityScreen({super.key});

  @override
  State<AdminActivityScreen> createState() => _AdminActivityScreenState();
}

enum _LoadState { loading, error, loaded }

class _AdminActivityScreenState extends State<AdminActivityScreen> {
  final ActivityLogService _service = ActivityLogService();

  static const List<Map<String, String>> _filters = [
    {'id': 'all', 'label': 'All'},
    {'id': 'applications', 'label': 'Applications'},
    {'id': 'enrollments', 'label': 'Enrollments'},
    {'id': 'staff', 'label': 'Staff'},
  ];

  String _activeFilter = 'all';
  _LoadState _state = _LoadState.loading;
  List<ActivityLogEvent> _events = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _state = _LoadState.loading;
      _errorMessage = null;
    });

    try {
      final events = await _service.getActivityLog(_activeFilter);
      if (!mounted) return;
      setState(() {
        _events = events;
        _state = _LoadState.loaded;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not load the activity log. Please try again.';
        _state = _LoadState.error;
      });
    }
  }

  void _onFilterTap(String filterId) {
    if (filterId == _activeFilter) return;
    setState(() => _activeFilter = filterId);
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildFilterRow(),
            _buildAnonymisedCaption(),
            Expanded(child: _buildBody()),
            _buildFooterNote(),
          ],
        ),
      ),
    );
  }

  // ---- Top bar (matches .topbar in the HTML mock) ----
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Activity Log',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined,
                  color: AppTheme.mutedText, size: 18),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '2',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Filter pill row (matches .nav-pill-row / .npill) ----
  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: SizedBox(
        height: 28,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isActive = filter['id'] == _activeFilter;
            return GestureDetector(
              onTap: () => _onFilterTap(filter['id']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isActive ? AppTheme.primary : AppTheme.border,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppTheme.mutedText,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---- "Anonymized — no personal data" caption ----
  Widget _buildAnonymisedCaption() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Anonymized — no personal data',
          style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
        ),
      ),
    );
  }

  // ---- Body: loading / error / list ----
  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        );
      case _LoadState.error:
        return _buildErrorState();
      case _LoadState.loaded:
        return _buildEventList();
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppTheme.error, size: 32),
            const SizedBox(height: 10),
            Text(
              _errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _loadEvents,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (_events.isEmpty) {
      return Center(
        child: Text(
          'No activity for this filter yet.',
          style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 4),
      itemCount: _events.length,
      itemBuilder: (context, index) => _buildLogItem(_events[index]),
    );
  }

  // ---- Single log item (matches .log-item) ----
  Widget _buildLogItem(ActivityLogEvent event) {
    final style = _styleFor(event.category);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: Icon(style.icon, size: 13, color: style.foreground),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.type,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
                ),
                const SizedBox(height: 1),
                Text(
                  _timeAgo(event.timestamp),
                  style: const TextStyle(fontSize: 9, color: AppTheme.subtleText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Footer privacy note (matches the bordered footer row) ----
  Widget _buildFooterNote() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 12, color: AppTheme.subtleText),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'All user events anonymized — no names, emails or IDs shown',
              style: TextStyle(fontSize: 10, color: AppTheme.subtleText),
            ),
          ),
        ],
      ),
    );
  }

  _EventStyle _styleFor(ActivityEventCategory category) {
    switch (category) {
      case ActivityEventCategory.application:
        return _EventStyle(
          icon: Icons.description_outlined,
          background: AppTheme.successLow,
          foreground: AppTheme.success,
        );
      case ActivityEventCategory.enrollment:
        return _EventStyle(
          icon: Icons.menu_book_outlined,
          background: AppTheme.infoLow,
          foreground: AppTheme.info,
        );
      case ActivityEventCategory.staffPending:
        return _EventStyle(
          icon: Icons.person_add_alt_outlined,
          background: AppTheme.warningLow,
          foreground: AppTheme.warning,
        );
      case ActivityEventCategory.staffApproved:
        return _EventStyle(
          icon: Icons.check_circle_outline,
          background: AppTheme.successLow,
          foreground: AppTheme.success,
        );
      case ActivityEventCategory.staffRejected:
        return _EventStyle(
          icon: Icons.remove_circle_outline,
          background: AppTheme.errorLow,
          foreground: AppTheme.error,
        );
    }
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}

class _EventStyle {
  final IconData icon;
  final Color background;
  final Color foreground;

  const _EventStyle({
    required this.icon,
    required this.background,
    required this.foreground,
  });
}
// Antonio ticket 017 ends here