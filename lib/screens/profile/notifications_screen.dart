import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/providers/notifications_provider.dart';
import 'package:futurepath_employment_hub/models/notification_item.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final Set<String> _expandedIds = {};

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unread = notifications.where((n) => !n.isRead).toList();
    final read = notifications.where((n) => n.isRead).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 85,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A365D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFF1A365D),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                if (unread.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A365D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${unread.length} NEW',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ]
              ],
            ),
            const Text(
              'Stay updated with your active alerts.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
        actions: [
          if (unread.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(notificationsProvider.notifier).markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF008080),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                if (unread.isNotEmpty) ...[
                  _buildHeader('NEW ALERTS', const Color(0xFF008080)),
                  _buildList(unread),
                ],
                if (read.isNotEmpty) ...[
                  _buildHeader('EARLIER', const Color(0xFF64748B)),
                  _buildList(read),
                ],
              ],
            ),
    );
  }

  Widget _buildHeader(String label, Color color) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 1,
          ),
        ),
      );

  Widget _buildList(List<NotificationItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
        itemBuilder: (context, idx) {
          final item = items[idx];
          final bool isUnread = !item.isRead;
          final bool isExpanded = _expandedIds.contains(item.id);

          return InkWell(
            onTap: isUnread ? () => ref.read(notificationsProvider.notifier).markAsRead(item.id) : null,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isUnread
                          ? const Color(0xFF008080).withValues(alpha: 0.1)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIcon(item.type),
                      color: isUnread ? const Color(0xFF008080) : const Color(0xFF1A365D),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF008080),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedIds.remove(item.id);
                              } else {
                                _expandedIds.add(item.id);
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.body,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                  height: 1.4,
                                  fontFamily: 'Roboto',
                                ),
                                maxLines: isExpanded ? null : 2,
                                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              ),
                              if (item.body.length > 60) // Simple heuristic for showing the button
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    isExpanded ? 'Show Less' : 'Show More',
                                    style: const TextStyle(
                                      color: Color(0xFF008080),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.timestamp,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    if (type.contains('Accepted')) return Icons.verified_rounded;
    if (type.contains('Update')) return Icons.rate_review_rounded;
    if (type.contains('Submitted')) return Icons.assignment_turned_in_rounded;
    return Icons.notifications_rounded;
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications_none_rounded, size: 48, color: Color(0xFF94A3B8)),
            SizedBox(height: 12),
            Text(
              'All Caught Up!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
          ],
        ),
      );
}
