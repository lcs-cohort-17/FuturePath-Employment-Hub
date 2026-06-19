//track profile.dart
import 'package:flutter/material.dart';

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
        title: const Text('Remove Application'),
        content: const Text('Are you sure you want to remove this application from your tracking list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _displayList.removeAt(index);
                _expandedIndex = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 85,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Track Applications', style: TextStyle(color: Color(0xFF1A365D), fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 2),
            Text('Monitor your status across active opportunities.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          ],
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: const Color(0xFFE2E8F0), height: 1)),
      ),
      body: _displayList.isEmpty
          ? const Center(child: Text("No active applications.", style: TextStyle(color: Color(0xFF64748B))))
          : ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // FIXED: Replaced withOpacity with withValues
        border: Border.all(color: isExpanded ? statusColor.withValues(alpha: 0.5) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(status == 'Accepted' ? Icons.check_circle_outline_rounded : Icons.access_time_rounded, color: statusColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(app['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        if (!isExpanded) Text(app['company'] ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  // FIXED: Replaced StatusChip with a simple Chip widget
                  Chip(
                    label: Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    side: BorderSide(color: statusColor),
                  ),
                  const SizedBox(width: 8),
                  Icon(isExpanded ? Icons.expand_more_rounded : Icons.chevron_right_rounded, color: const Color(0xFF64748B), size: 20),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app['company'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A365D))),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: (app['progress'] ?? 0) / 100, valueColor: AlwaysStoppedAnimation(statusColor)),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => _confirmRemoval(index),
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                    label: const Text('Remove application', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted': return Colors.teal;
      case 'Under Review': return Colors.orange;
      case 'Pending': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }
}