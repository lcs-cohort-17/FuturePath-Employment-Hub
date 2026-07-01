// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/models/programme.dart';
import '../../services/sheets_service.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import 'programme_detail_screen.dart';

/// ─────────────────────────────────────────────────────────────
/// SCREEN
/// ─────────────────────────────────────────────────────────────
class ProgrammeListScreen extends StatefulWidget {
  const ProgrammeListScreen({super.key});

  @override
  State<ProgrammeListScreen> createState() =>
      _ProgrammeListScreenState();
}

class _ProgrammeListScreenState extends State<ProgrammeListScreen> {
  final SheetsService sheetsService = SheetsService();

  List<Programme> programmes = [];
  bool isLoading = true;
  bool hasError = false;
  DateTime? lastUpdated;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All',
    'Technology',
    'Business',
    'Marketing',
    'Engineering',
  ];

  @override
  void initState() {
    super.initState();
    loadProgrammes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ─────────────────────────────────────────────────────────────
  /// DATA LOADING
  /// ─────────────────────────────────────────────────────────────
  Future<void> loadProgrammes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Use mockProgrammes from models/programme.dart
    programmes = mockProgrammes;
    lastUpdated = DateTime.now();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleRefresh() async {
    await loadProgrammes();
  }

  /// ─────────────────────────────────────────────────────────────
  /// FILTERING
  /// ─────────────────────────────────────────────────────────────
  List<Programme> get _filteredProgrammes {
    return programmes.where((programme) {
      final matchesCategory = _selectedCategory == 'All' ||
          programme.category == _selectedCategory;

      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          programme.title.toLowerCase().contains(query) ||
          programme.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// ─────────────────────────────────────────────────────────────
  /// BUILD
  /// ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingOverlay(),
      );
    }

    if (hasError) {
      return Scaffold(
        body: ErrorMessage(
          message: "Failed to load programmes",
          onRetry: loadProgrammes,
        ),
      );
    }

    if (programmes.isEmpty) {
      return const Scaffold(
        body: EmptyState(message: "No programmes found"),
      );
    }

    final filtered = _filteredProgrammes;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: RefreshIndicator(
        color: AppTheme.primary,
        backgroundColor: AppTheme.surface2,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            // ── TOP BAR ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surface,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.border, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                          'FuturePath',
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
                        const Icon(
                          Icons.notifications_none,
                          color: AppTheme.mutedText,
                          size: 22,
                        ),
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
              ),
            ),

            // ── PAGE TITLE ────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 2),
                child: Text(
                  'Programmes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ),

            // ── SEARCH BAR ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  border: Border.all(color: AppTheme.border, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppTheme.subtleText, size: 16),
                    const SizedBox(width: 7),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textDark,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search programmes…',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppTheme.subtleText,
                          ),
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── CATEGORY PILL FILTERS ─────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final selected = category == _selectedCategory;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.border,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppTheme.mutedText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── PROGRAMME CARDS ───────────────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final programme = filtered[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProgrammeDetailScreen(
                            programme: programme,
                          ),
                        ),
                      );
                    },
                    child: ProgrammeCard(programme: programme),
                  );
                },
                childCount: filtered.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// PROGRAMME CARD
/// ─────────────────────────────────────────────────────────────
class ProgrammeCard extends StatelessWidget {
  final Programme programme;

  const ProgrammeCard({
    super.key,
    required this.programme,
  });

  // Gradient backgrounds per category matching HTML
  LinearGradient _bannerGradient(String category) {
    switch (category) {
      case 'Technology':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B2A), Color(0xFF1A3A5C)],
        );
      case 'Marketing':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F0A0A), Color(0xFF3D1A0A)],
        );
      case 'Business':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1F0A), Color(0xFF1A3D1A)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF2E2E2E)],
        );
    }
  }

  IconData _bannerIcon(String category) {
    switch (category) {
      case 'Technology':
        return Icons.phone_android;
      case 'Marketing':
        return Icons.campaign;
      case 'Business':
        return Icons.bar_chart;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spotsLeft = programme.spotsRemaining;
    final progress = programme.capacity == 0
        ? 0.0
        : (programme.enrolledCount / programme.capacity);

    final bool almostFull = progress >= 0.9;
    final bool notStarted = programme.enrolledCount == 0;

    // Status badge styling
    Color statusBg;
    Color statusFg;
    String statusText;
    if (programme.status == 'Open' && !almostFull) {
      statusBg = AppTheme.successLow;
      statusFg = AppTheme.success;
      statusText = '● Open';
    } else if (almostFull) {
      statusBg = AppTheme.warningLow;
      statusFg = AppTheme.warning;
      statusText = 'Starting Soon';
    } else {
      statusBg = AppTheme.successLow;
      statusFg = AppTheme.success;
      statusText = '● Open';
    }

    // Spots label
    Color spotsLabelColor = AppTheme.subtleText;
    String spotsLabel;
    if (notStarted) {
      spotsLabel = '0 enrolled yet';
    } else if (almostFull) {
      spotsLabel = 'Almost full!';
      spotsLabelColor = AppTheme.primary;
    } else {
      spotsLabel = '$spotsLeft spots left';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        border: Border.all(color: AppTheme.border, width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BANNER ─────────────────────────────────────────────
          SizedBox(
            height: 80,
            child: Stack(
              children: [
                // Gradient background
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _bannerGradient(programme.category),
                    ),
                  ),
                ),
                // Centred icon
                Center(
                  child: Icon(
                    _bannerIcon(programme.category),
                    size: 32,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                // Category badge — top left
                Positioned(
                  top: 7,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      programme.category,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ),
                // Status badge — top right
                Positioned(
                  top: 7,
                  right: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: statusFg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── BODY ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  programme.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                // Provider · duration · level
                Text(
                  '${programme.provider} · ${programme.duration} · ${programme.level}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress track
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Container(
                    height: 3,
                    color: AppTheme.surface3,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                // Spots label row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spotsLabel,
                      style: TextStyle(
                        fontSize: 9,
                        color: spotsLabelColor,
                      ),
                    ),
                    Text(
                      '${programme.enrolledCount}/${programme.capacity}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppTheme.subtleText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════
