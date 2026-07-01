import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../router/app_router.dart';
import '../../models/programme.dart';

/// Admin screen to view and manage all programmes.
/// [UIUX-017 / UIUX-021]
class AdminProgrammesScreen extends StatefulWidget {
  const AdminProgrammesScreen({super.key});

  @override
  State<AdminProgrammesScreen> createState() => _AdminProgrammesScreenState();
}

class _AdminProgrammesScreenState extends State<AdminProgrammesScreen> {
  final List<Programme> _programmes = mockProgrammes;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Programme> get _filteredProgrammes {
    if (_searchQuery.isEmpty) return _programmes;
    return _programmes
        .where((p) =>
            p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.provider.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _navigateToEnrolments(Programme programme) {
    // [UIUX-021] — Navigate to enrolments for this programme
    Navigator.pushNamed(
      context,
      AppRouter.adminEnrolments,
      arguments: {
        'programmeId': programme.id,
        'programmeName': programme.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
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
            'Programmes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primaryLow,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'ADMIN',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 16, color: AppTheme.subtleText),
          const SizedBox(width: 7),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
              decoration: const InputDecoration.collapsed(
                hintText: 'Search programmes…',
                hintStyle: TextStyle(fontSize: 12, color: AppTheme.subtleText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final list = _filteredProgrammes;
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No programmes found.',
          style: TextStyle(color: AppTheme.mutedText, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final p = list[index];
        return _AdminProgrammeCard(
          programme: p,
          onTap: () => _navigateToEnrolments(p),
        );
      },
    );
  }
}

class _AdminProgrammeCard extends StatelessWidget {
  final Programme programme;
  final VoidCallback onTap;

  const _AdminProgrammeCard({required this.programme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = programme.capacity == 0
        ? 0.0
        : programme.enrolledCount / programme.capacity;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        programme.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        programme.provider,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: AppTheme.mutedText),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  label: 'ENROLLED',
                  value: '${programme.enrolledCount}',
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 20),
                _StatItem(
                  label: 'CAPACITY',
                  value: '${programme.capacity}',
                  color: AppTheme.textDark,
                ),
                const SizedBox(width: 20),
                _StatItem(
                  label: 'STATUS',
                  value: programme.status.toUpperCase(),
                  color: programme.status.toLowerCase() == 'open'
                      ? AppTheme.success
                      : AppTheme.mutedText,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: AppTheme.surface3,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 8, color: AppTheme.subtleText),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
