import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/loading_widget.dart';

class AdminActivityLogScreen extends StatefulWidget {
  const AdminActivityLogScreen({super.key});

  @override
  State<AdminActivityLogScreen> createState() => _AdminActivityLogScreenState();
}

class _AdminActivityLogScreenState extends State<AdminActivityLogScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Applications', 'Enrollments', 'Staff'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadActivityLog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading activity log...');
          }

          final filtered = provider.filteredActivityLog(_selectedFilter);

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    'Activity Log',
                    style: TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Filter pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = filter == _selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE03A2F) : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE03A2F)
                                      : const Color(0xFF2E2E2E),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF9E9B96),
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Anonymized notice
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Anonymized — no personal data',
                    style: const TextStyle(
                      color: Color(0xFF9E9B96),
                      fontSize: 10,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Log items
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No activity to show',
                        style: TextStyle(color: Color(0xFF5C5A57)),
                      ),
                    ),
                  )
                else
                  for (final log in filtered)
                    _LogItem(
                      icon: log['icon'] as IconData? ?? Icons.info,
                      iconColor: log['iconColor'] as Color? ?? const Color(0xFF4A9EE8),
                      title: log['title'] as String? ?? '',
                      subtitle: log['subtitle'] as String? ?? '',
                      time: log['time'] as String? ?? '',
                    ),

                // Privacy footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF5C5A57),
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'All user events anonymized — no names, emails or IDs shown',
                        style: TextStyle(
                          color: Color(0xFF5C5A57),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _LogItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, color: iconColor, size: 13),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF9E9B96),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF5C5A57),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}