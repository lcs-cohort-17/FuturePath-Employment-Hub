//track profile.dart
import 'package:flutter/material.dart';
// import 'package:futurepath/theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class TrackApplicationsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> applications;

  const TrackApplicationsScreen({
    super.key,
    required this.applications,
  });

  @override
  State<TrackApplicationsScreen> createState() => _TrackApplicationsScreenState();
}

class _TrackApplicationsScreenState extends State<TrackApplicationsScreen> {
  int? _expandedIndex;
  late List<Map<String, dynamic>> _displayList;

  @override
  void initState() {
    super.initState();
    _displayList = List<Map<String, dynamic>>.from(widget.applications);
  }

  void _confirmRemoval(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface2,
        title: const Text('Remove Application', style: TextStyle(color: AppTheme.textDark)),
        content: const Text('Are you sure you want to remove this application from your tracking list?', style: TextStyle(color: AppTheme.mutedText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppTheme.mutedText))),
          TextButton(
            onPressed: () {
              setState(() {
                _displayList.removeAt(index);
                _expandedIndex = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        titleSpacing: 16,
        toolbarHeight: 56,
        title: const Text(
          'Track Applications',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
      ),
      body: _displayList.isEmpty
          ? Center(
        child: Text(
          'No active applications.',
          style: const TextStyle(color: AppTheme.mutedText, fontSize: 12),
        ),
      )
          : ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        itemCount: _displayList.length,
        itemBuilder: (context, index) {
          final app = _displayList[index];
          return _buildApplicationCard(app, index, _expandedIndex == index);
        },
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app, int index, bool isExpanded) {
    final status = app['status'] ?? 'Pending';
    final statusColor = _getStatusColor(status);
    final progress = (app['progress'] ?? 0) / 100.0;

    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 9),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded ? statusColor.withValues(alpha: 0.5) : AppTheme.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(14),
              bottom: isExpanded ? Radius.zero : const Radius.circular(14),
            ),
            onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon avatar matching HTML's 28x28 icon container style
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Icon(
                          status == 'Accepted'
                              ? Icons.check_rounded
                              : status == 'Under Review'
                              ? Icons.access_time_rounded
                              : Icons.circle_outlined,
                          color: statusColor,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    app['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusBadge(status, statusColor),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              app['company'] ?? '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  // Progress track
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      backgroundColor: AppTheme.surface3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(height: 0.5, color: AppTheme.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _confirmRemoval(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLow,
                          border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete_outline_rounded, size: 13, color: AppTheme.error),
                            SizedBox(width: 5),
                            Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return AppTheme.success;
      case 'Under Review':
        return AppTheme.warning;
      case 'Pending':
        return AppTheme.info;
      default:
        return AppTheme.mutedText;
    }
  }
}