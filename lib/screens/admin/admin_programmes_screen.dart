import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../router/app_router.dart';
import '../../models/programme.dart';

class AdminProgrammesScreen extends StatefulWidget {
  const AdminProgrammesScreen({super.key});

  @override
  State<AdminProgrammesScreen> createState() => _AdminProgrammesScreenState();
}

class _AdminProgrammesScreenState extends State<AdminProgrammesScreen> {
  final _supabase = Supabase.instance.client;
  List<Programme> _programmes = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProgrammes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProgrammes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Fetching from 'Training Programme'
      final response = await _supabase
          .from('Training Programme')
          .select();

      final data = List<Map<String, dynamic>>.from(response);
      setState(() {
        _programmes = data.map((m) => Programme.fromJson(m)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading admin programmes: $e');
      setState(() {
        _error = 'Failed to load programmes. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<Programme> get _filteredProgrammes {
    if (_searchQuery.isEmpty) return _programmes;
    return _programmes
        .where((p) =>
            p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.provider.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
              child: _isLoading
                  ? const Center(child: LoadingIndicator(color: AppTheme.primary))
                  : _error != null
                      ? ErrorMessage(message: _error!, onRetry: _loadProgrammes)
                      : _buildList(),
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
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.mutedText, size: 18),
            onPressed: _loadProgrammes,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
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
      return const EmptyState(message: 'No programmes found.');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _AdminProgrammeCard(programme: list[index]);
      },
    );
  }
}

class _AdminProgrammeCard extends StatelessWidget {
  final Programme programme;

  const _AdminProgrammeCard({required this.programme});

  @override
  Widget build(BuildContext context) {
    final progress = programme.capacity > 0
        ? (programme.enrolledCount / programme.capacity).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.adminEnrolments,
          arguments: {
            'programmeId': programme.id,
            'programmeName': programme.title,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                const Icon(Icons.chevron_right_rounded, color: AppTheme.subtleText, size: 18),
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
                      : AppTheme.warning,
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
