// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-018
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
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
class PerformanceService {
  final _supabase = Supabase.instance.client;

  Future<List<JobPerformanceItem>> fetchTopJobs() async {
    try {
      final apps = await _supabase
          .from('job_applications')
          .select('employment_opportunity_id');
      final jobs = await _supabase
          .from('Employment Opportunity')
          .select('opportunity_id, Position_Title, employer_id');
      final employers = await _supabase
          .from('Employer')
          .select('employer_id, Company_Name');

      final totalApps = apps.length;
      final appCounts = <String, int>{};
      for (final app in apps) {
        final jobIdx = app['employment_opportunity_id']?.toString() ?? '';
        if (jobIdx.isNotEmpty) {
          appCounts[jobIdx] = (appCounts[jobIdx] ?? 0) + 1;
        }
      }

      final jobItems = <JobPerformanceItem>[];
      for (final job in jobs) {
        final id = job['opportunity_id']?.toString() ?? '';
        final title = job['Position_Title']?.toString() ?? 'Unknown Position';
        final empId = job['employer_id']?.toString() ?? '';

        final employer = employers.firstWhere(
          (e) => e['employer_id']?.toString() == empId,
          orElse: () => <String, dynamic>{},
        );
        final company = employer['Company_Name']?.toString() ?? 'Unknown Company';

        final count = appCounts[id] ?? 0;
        final pct = totalApps > 0 ? (count / totalApps) : 0.0;

        jobItems.add(JobPerformanceItem(
          title: title,
          company: company,
          percentage: pct,
        ));
      }

      jobItems.sort((a, b) => b.percentage.compareTo(a.percentage));
      return jobItems.take(5).toList();
    } catch (e) {
      print('❌ Error fetching top jobs performance: $e');
      rethrow;
    }
  }

  Future<List<ProgrammePerformanceItem>> fetchTopProgrammes() async {
    try {
      final enrollments = await _supabase
          .from('programme_enrollments')
          .select('training_programme_id, enrolment_status');
      final programmes = await _supabase
          .from('Training Programme')
          .select('programme_id, Programme_Name');

      final enrolCounts = <String, int>{};
      final completedCounts = <String, int>{};
      for (final enrolment in enrollments) {
        final progId = enrolment['training_programme_id']?.toString() ?? '';
        final status = enrolment['enrolment_status']?.toString() ?? '';
        if (progId.isNotEmpty) {
          enrolCounts[progId] = (enrolCounts[progId] ?? 0) + 1;
          if (status == 'completed') {
            completedCounts[progId] = (completedCounts[progId] ?? 0) + 1;
          }
        }
      }

      final progItems = <Map<String, dynamic>>[];
      for (final prog in programmes) {
        final id = prog['programme_id']?.toString() ?? '';
        final name = prog['Programme_Name']?.toString() ?? 'Unknown Programme';

        final totalEnrolled = enrolCounts[id] ?? 0;
        final completed = completedCounts[id] ?? 0;
        final completionRate = totalEnrolled > 0 ? (completed / totalEnrolled) : 0.0;

        progItems.add({
          'name': name,
          'completionRate': completionRate,
          'enrolCount': totalEnrolled,
        });
      }

      progItems.sort((a, b) => (b['enrolCount'] as int).compareTo(a['enrolCount'] as int));
      return progItems
          .take(5)
          .map((p) => ProgrammePerformanceItem(
                name: p['name'] as String,
                completionRate: p['completionRate'] as double,
              ))
          .toList();
    } catch (e) {
      print('❌ Error fetching top programmes performance: $e');
      rethrow;
    }
  }
}
// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class AdminPerformanceScreen extends StatefulWidget {
  const AdminPerformanceScreen({super.key});

  @override
  State<AdminPerformanceScreen> createState() => _AdminPerformanceScreenState();
}

class _AdminPerformanceScreenState extends State<AdminPerformanceScreen> {
  final _service = PerformanceService();

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
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
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
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
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