// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-018
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/notifications_provider.dart';
import '../../router/app_router.dart';

// ---------------------------------------------------------------------------
// Data models — replaced by real Supabase-backed models when service is wired
// ---------------------------------------------------------------------------
class JobPerformanceItem {
  final String title;
  final String company;
  final double percentage; // 0.0 – 1.0

  const JobPerformanceItem({
    required this.title,
    required this.company,
    required this.percentage,
  });
}

class ProgrammePerformanceItem {
  final String name;
  final double completionRate; // 0.0 – 1.0

  const ProgrammePerformanceItem({
    required this.name,
    required this.completionRate,
  });
}
// ---------------------------------------------------------------------------
// Mock service — [SUPABASE-SERVICE] replace body with real service calls
// ---------------------------------------------------------------------------
class _MockPerformanceService {
  // [SUPABASE-SERVICE] — Replace with SupabaseService.getTopAppliedJobs()
  // Returns top-5 jobs ordered by application count desc.
  // Percentage = job_applications / total_applications * 100.
  Future<List<JobPerformanceItem>> fetchTopJobs() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      JobPerformanceItem(
        title: 'Junior Flutter Developer',
        company: 'TechNova Solutions',
        percentage: 0.92,
      ),
      JobPerformanceItem(
        title: 'Data Analyst Trainee',
        company: 'Innovate SA',
        percentage: 0.78,
      ),
      JobPerformanceItem(
        title: 'Digital Marketing Assistant',
        company: 'Digital Growth Hub',
        percentage: 0.65,
      ),
      JobPerformanceItem(
        title: 'Cloud Support Engineer',
        company: 'Amazon SA',
        percentage: 0.54,
      ),
      JobPerformanceItem(
        title: 'Salesforce Admin Intern',
        company: 'FutureTech Africa',
        percentage: 0.41,
      ),
    ];
  }
  // [SUPABASE-SERVICE] — Replace with SupabaseService.getTopEnrolledProgrammes()
  // Returns top-5 programmes ordered by enrolment count desc.
  // Completion rate = completed_enrolments / total_enrolments * 100.
  Future<List<ProgrammePerformanceItem>> fetchTopProgrammes() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      ProgrammePerformanceItem(
        name: 'Flutter Mobile Development',
        completionRate: 0.80,
      ),
      ProgrammePerformanceItem(
        name: 'Digital Marketing Fundamentals',
        completionRate: 0.95,
      ),
      ProgrammePerformanceItem(
        name: 'Salesforce Administration',
        completionRate: 0.80,
      ),
      ProgrammePerformanceItem(
        name: 'Data Analytics Bootcamp',
        completionRate: 0.55,
      ),
      ProgrammePerformanceItem(
        name: 'Cloud Computing Essentials',
        completionRate: 0.60,
      ),
    ];
  }
}
// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class AdminPerformanceScreen extends ConsumerStatefulWidget {
  const AdminPerformanceScreen({super.key});

  @override
  ConsumerState<AdminPerformanceScreen> createState() => _AdminPerformanceScreenState();
}

class _AdminPerformanceScreenState extends ConsumerState<AdminPerformanceScreen> {
  final _service = _MockPerformanceService();

  late Future<List<JobPerformanceItem>> _jobsFuture;
  late Future<List<ProgrammePerformanceItem>> _programmesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _jobsFuture = _service.fetchTopJobs();
    _programmesFuture = _service.fetchTopProgrammes();
  }

  void _retry() => setState(() => _loadData());

  // Bar colours cycle through the same order as the HTML spec
  static const List<Color> _jobBarColors = [
    AppTheme.primary,
    AppTheme.info,
    AppTheme.success,
    AppTheme.warning,
    AppTheme.mutedText,
  ];

  static const List<Color> _programmeBarColors = [
    AppTheme.info,
    AppTheme.primary,
    AppTheme.success,
    AppTheme.warning,
    AppTheme.mutedText,
  ];
  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          _TopBar(),
          Expanded(
            child: FutureBuilder(
              // Wait for both futures together
              future: Future.wait([_jobsFuture, _programmesFuture]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _LoadingState();
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return _ErrorState(onRetry: _retry);
                }

                final jobs =
                snapshot.data![0] as List<JobPerformanceItem>;
                final programmes =
                snapshot.data![1] as List<ProgrammePerformanceItem>;

                return _ContentView(
                  jobs: jobs,
                  programmes: programmes,
                  jobBarColors: _jobBarColors,
                  programmeBarColors: _programmeBarColors,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Top bar — matches HTML .topbar pattern exactly
// ---------------------------------------------------------------------------
class _TopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Brand dot + name
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
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'Content Performance',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Notification bell
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.notifications),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.mutedText,
                  size: 22,
                ),
                if (unreadCount > 0)
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
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Main scrollable content
// ---------------------------------------------------------------------------
class _ContentView extends StatelessWidget {
  final List<JobPerformanceItem> jobs;
  final List<ProgrammePerformanceItem> programmes;
  final List<Color> jobBarColors;
  final List<Color> programmeBarColors;

  const _ContentView({
    required this.jobs,
    required this.programmes,
    required this.jobBarColors,
    required this.programmeBarColors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section 1: Top 5 Jobs ────────────────────────────────────────
          _SectionHeader(label: 'Top 5 Most Applied Jobs'),
          ...List.generate(jobs.length, (i) {
            final item = jobs[i];
            final color = jobBarColors[i % jobBarColors.length];
            return _PerformanceBar(
              primaryLabel: item.title,
              secondaryLabel: item.company,
              percentage: item.percentage,
              barColor: color,
            );
          }),

          // ── Divider ──────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Divider(color: AppTheme.border, thickness: 0.5, height: 1),
          ),

          // ── Section 2: Top 5 Programmes ──────────────────────────────────
          _SectionHeader(label: 'Top 5 Most Enrolled Programmes'),
          ...List.generate(programmes.length, (i) {
            final item = programmes[i];
            final color = programmeBarColors[i % programmeBarColors.length];
            return _PerformanceBar(
              primaryLabel: item.name,
              secondaryLabel: 'Completion rate',
              percentage: item.completionRate,
              barColor: color,
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Section header — matches HTML .sec-h / .sec-t pattern
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          // Red dot accent
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Individual performance bar — matches HTML .perf-bar pattern
// ---------------------------------------------------------------------------
class _PerformanceBar extends StatelessWidget {
  final String primaryLabel;
  final String secondaryLabel;
  final double percentage; // 0.0 – 1.0
  final Color barColor;

  const _PerformanceBar({
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.percentage,
    required this.barColor,
  });

  String get _displayPercent =>
      '${(percentage * 100).toStringAsFixed(0)}%';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: label left, coloured % right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  primaryLabel,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _displayPercent,
                style: TextStyle(
                  color: barColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Secondary label (company or "Completion rate")
          const SizedBox(height: 2),
          Text(
            secondaryLabel,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 9,
            ),
          ),

          // Progress track + fill
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                // Track
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.surface3,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Loading state
// ---------------------------------------------------------------------------
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primary,
        strokeWidth: 2,
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppTheme.errorLow,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.bar_chart_rounded,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Could not load performance data',
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Check your connection and try again.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-018
// ═══════════════════════════════════════════════════════════════════════