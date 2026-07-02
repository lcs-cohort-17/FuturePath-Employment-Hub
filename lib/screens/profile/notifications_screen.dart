//notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> notifications;
  const NotificationsScreen({super.key, required this.notifications});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final Set<String> _expandedIds = {};
  late List<Map<String, dynamic>> _localNotifications;

  @override
  void initState() {
    super.initState();
    _localNotifications = List<Map<String, dynamic>>.from(widget.notifications);
  }

  void _toggleRead(Map<String, dynamic> item, {bool all = false}) {
    setState(() {
      if (all) {
        for (var n in _localNotifications) {
          n['isRead'] = true;
        }
        ref.read(notificationsProvider.notifier).markAllAsRead();
      } else {
        item['isRead'] = true;
        ref.read(notificationsProvider.notifier).markAsRead(item['id']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = _localNotifications.where((n) => !n['isRead']).toList();
    final read = _localNotifications.where((n) => n['isRead']).toList();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        toolbarHeight: 52,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: const Text('FP', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 7),
            const Text(
              'Notifications',
              style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
        actions: [
          if (unread.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () => _toggleRead({}, all: true),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 11),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_outlined, color: AppTheme.mutedText, size: 20),
                if (unread.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        '${unread.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
      ),
      body: _localNotifications.isEmpty
          ? _buildEmptyState()
          : ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          if (unread.isNotEmpty) ...[
            _buildSectionHeader('NEW ALERTS', AppTheme.primary),
            ..._buildItems(unread, 'un'),
          ],
          if (read.isNotEmpty) ...[
            _buildSectionHeader('EARLIER', AppTheme.mutedText),
            ..._buildItems(read, 'r'),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems(List<Map<String, dynamic>> items, String prefix) {
    return List.generate(items.length, (idx) {
      final item = items[idx];
      final bool isUnread = !item['isRead'];
      final String id = '${prefix}_$idx';
      final bool isExpanded = _expandedIds.contains(id);

      return GestureDetector(
        onTap: isUnread ? () => _toggleRead(item) : null,
        child: Container(
          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border, width: 0.5),
          ),
          padding: const EdgeInsets.all(11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isUnread ? AppTheme.primaryLow : AppTheme.surface3,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _getIcon(item['type'] ?? ''),
                  color: isUnread ? AppTheme.primary : AppTheme.mutedText,
                  size: 13,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] ?? '',
                            style: TextStyle(
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: AppTheme.textDark,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () => setState(() => isExpanded ? _expandedIds.remove(id) : _expandedIds.add(id)),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppTheme.mutedText, fontSize: 10, height: 1.4),
                          children: [
                            TextSpan(text: item['body'] ?? ''),
                            TextSpan(
                              text: isExpanded ? '  Show Less' : ' ... Show More',
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 9),
                            ),
                          ],
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['timestamp'] ?? '',
                      style: const TextStyle(color: AppTheme.subtleText, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getIcon(String type) {
    if (type.contains('Accepted')) return Icons.verified_rounded;
    if (type.contains('Update')) return Icons.rate_review_rounded;
    if (type.contains('Submitted')) return Icons.assignment_turned_in_rounded;
    return Icons.notifications_rounded;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surface3,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.notifications_none_rounded, size: 32, color: AppTheme.mutedText),
          ),
          const SizedBox(height: 16),
          const Text(
            'All Caught Up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'No new notifications at this time.',
            style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}