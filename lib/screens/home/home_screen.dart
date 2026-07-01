import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

typedef DashboardFetcher = Future<HomeDashboardData> Function();

class JobSummary {
  final String id;
  final String title;
  final String company;
  final String companyInitials;
  final List<String> skills;
  final String employmentType;
  final String closingLabel;
  final bool isOpen;

  const JobSummary({
    required this.id,
    required this.title,
    required this.company,
    required this.companyInitials,
    required this.skills,
    required this.employmentType,
    required this.closingLabel,
    this.isOpen = true,
  });
}

enum ProgrammeStatus { open, startingSoon, closed }

class ProgrammeSummary {
  final String id;
  final String title;
  final String provider;
  final String? imageUrl;
  final String duration;
  final String level;
  final int enrolled;
  final int capacity;
  final ProgrammeStatus status;

  const ProgrammeSummary({
    required this.id,
    required this.title,
    required this.provider,
    this.imageUrl,
    required this.duration,
    required this.level,
    required this.enrolled,
    required this.capacity,
    this.status = ProgrammeStatus.open,
  });
}

class HomeDashboardData {
  final int programmesCount;
  final int openJobsCount;
  final int employersCount;
  final List<JobSummary> recommendedJobs;
  final List<ProgrammeSummary> featuredProgrammes;

  const HomeDashboardData({
    required this.programmesCount,
    required this.openJobsCount,
    required this.employersCount,
    required this.recommendedJobs,
    required this.featuredProgrammes,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'there',
    this.userInitials = 'U',
    this.notificationCount = 0,
    this.fetchDashboardData = _mockFetchDashboardData,
    this.onSearch,
    this.onSeeAllJobs,
    this.onSeeAllProgrammes,
    this.onJobTap,
    this.onProgrammeTap,
    this.onNotificationsTap,
  });

  final String userName;
  final String userInitials;
  final int notificationCount;
  final DashboardFetcher fetchDashboardData;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onSeeAllJobs;
  final VoidCallback? onSeeAllProgrammes;
  final ValueChanged<JobSummary>? onJobTap;
  final ValueChanged<ProgrammeSummary>? onProgrammeTap;
  final VoidCallback? onNotificationsTap;

  static Future<HomeDashboardData> _mockFetchDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const HomeDashboardData(
      programmesCount: 6,
      openJobsCount: 12,
      employersCount: 4,
      recommendedJobs: [
        JobSummary(
          id: 'job-tn-flutter',
          title: 'Junior Flutter Developer',
          company: 'TechNova Solutions',
          companyInitials: 'TN',
          skills: ['Flutter', 'Dart', 'Firebase'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 31 Jul',
        ),
        JobSummary(
          id: 'job-dgh-marketing',
          title: 'Digital Marketing Assistant',
          company: 'Digital Growth Hub',
          companyInitials: 'DG',
          skills: ['SEO', 'Social Media', 'Content Creation'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 20 Jul',
        ),
      ],
      featuredProgrammes: [
        ProgrammeSummary(
          id: 'prog-flutter-dev',
          title: 'Flutter Mobile Development',
          provider: 'TechNova Solutions',
          duration: '3 months',
          level: 'Beginner–Intermediate',
          enrolled: 24,
          capacity: 30,
        ),
        ProgrammeSummary(
          id: 'prog-salesforce',
          title: 'Salesforce Administration',
          provider: 'FutureTech Africa',
          duration: '3 months',
          level: 'Beginner',
          enrolled: 20,
          capacity: 25,
        ),
        ProgrammeSummary(
          id: 'prog-digital-marketing',
          title: 'Digital Marketing Fundamentals',
          provider: 'Digital Growth Hub',
          duration: '2 months',
          level: 'Beginner',
          enrolled: 38,
          capacity: 40,
          status: ProgrammeStatus.startingSoon,
        ),
      ],
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;
  late Future<HomeDashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _dashboardFuture = widget.fetchDashboardData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _handleSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    widget.onSearch?.call(query.trim());
  }

  void _handleSeeAllJobs() {
    widget.onSeeAllJobs != null
        ? widget.onSeeAllJobs!()
        : _showWiringSnackBar('See all jobs (NAV-003)');
  }

  void _handleSeeAllProgrammes() {
    widget.onSeeAllProgrammes != null
        ? widget.onSeeAllProgrammes!()
        : _showWiringSnackBar('See all programmes (NAV-002)');
  }

  void _handleJobTap(JobSummary job) {
    widget.onJobTap != null
        ? widget.onJobTap!(job)
        : _showWiringSnackBar('Open job detail: ${job.title}');
  }

  void _handleProgrammeTap(ProgrammeSummary programme) {
    widget.onProgrammeTap != null
        ? widget.onProgrammeTap!(programme)
        : _showWiringSnackBar('Open programme detail: ${programme.title}');
  }

  void _showWiringSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$message — navigation not wired yet')));
  }

  /// Returns a background/foreground colour pair for a job avatar based on
  /// the initials string, cycling through the app's semantic colour pairs so
  /// each card feels distinct without requiring a data-model field.
  ({Color bg, Color fg}) _avatarColours(String initials) {
    final pairs = [
      (bg: AppTheme.infoLow, fg: AppTheme.info),
      (bg: AppTheme.successLow, fg: AppTheme.success),
      (bg: AppTheme.warningLow, fg: AppTheme.warning),
      (bg: AppTheme.primaryLow, fg: AppTheme.primary),
    ];
    final index = initials.codeUnits.fold(0, (sum, c) => sum + c) % pairs.length;
    return pairs[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildGreeting(),
              _buildSearchBar(),
              const SizedBox(height: 6),
              FutureBuilder<HomeDashboardData>(
                future: _dashboardFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.primary),
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Text(
                          'Could not load your dashboard. Pull to refresh.',
                          style: TextStyle(color: AppTheme.mutedText),
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsGrid(data),
                      _buildSectionHeader(title: 'Recommended', onSeeAll: _handleSeeAllJobs),
                      ...data.recommendedJobs.take(3).map(
                            (job) => _jobCard(job),
                      ),
                      _buildSectionHeader(
                          title: 'Featured Programmes', onSeeAll: _handleSeeAllProgrammes),
                      ...data.featuredProgrammes.take(3).map(
                            (p) => _programmeCard(p),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Topbar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
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
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'FuturePath',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: widget.onNotificationsTap,
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.mutedText,
                  size: 22,
                ),
              ),
              if (widget.notificationCount > 0)
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
                      '${widget.notificationCount}',
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
        ],
      ),
    );
  }

  // ── Greeting ──────────────────────────────────────────────────────────────

  Widget _buildGreeting() {
    // [UIUX-PRIV-001] — userName removed from display. Generic greeting only.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Text(
        _greeting,
        style: const TextStyle(
          color: AppTheme.mutedText,
          fontSize: 11,
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              onSubmitted: _handleSearchSubmitted,
              style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Search jobs, programmes, skills…',
                hintStyle: TextStyle(color: AppTheme.subtleText, fontSize: 12),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats grid ────────────────────────────────────────────────────────────

  Widget _buildStatsGrid(HomeDashboardData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(child: _statCard('${data.programmesCount}', 'Programmes', isRed: true)),
          const SizedBox(width: 7),
          Expanded(child: _statCard('${data.openJobsCount}', 'Open Jobs')),
          const SizedBox(width: 7),
          Expanded(child: _statCard('${data.employersCount}', 'Employers')),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, {bool isRed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        border: Border.all(color: AppTheme.border, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isRed ? AppTheme.primary : AppTheme.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppTheme.mutedText, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Section header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all ›',
              style: TextStyle(color: AppTheme.primary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ── Job card ──────────────────────────────────────────────────────────────

  Widget _jobCard(JobSummary job) {
    final colours = _avatarColours(job.companyInitials);
    return GestureDetector(
      onTap: () => _handleJobTap(job),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          border: Border.all(color: AppTheme.border, width: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: avatar + title/company + status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colours.bg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    job.companyInitials,
                    style: TextStyle(
                      color: colours.fg,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        job.company,
                        style: const TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _openBadge(),
              ],
            ),
            // Skill tags
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: job.skills.map(_skillTag).toList(),
              ),
            ),
            // Meta row
            Row(
              children: [
                const Icon(Icons.work_outline, size: 11, color: AppTheme.subtleText),
                const SizedBox(width: 3),
                Text(
                  job.employmentType,
                  style: const TextStyle(color: AppTheme.subtleText, fontSize: 9),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.access_time, size: 11, color: AppTheme.subtleText),
                const SizedBox(width: 3),
                Text(
                  job.closingLabel,
                  style: const TextStyle(color: AppTheme.subtleText, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        border: Border.all(color: AppTheme.border, width: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppTheme.mutedText, fontSize: 9),
      ),
    );
  }

  Widget _openBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.successLow,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        '● Open',
        style: TextStyle(
          color: AppTheme.success,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Programme card ────────────────────────────────────────────────────────

  Widget _programmeCard(ProgrammeSummary programme) {
    final statusLabel = switch (programme.status) {
      ProgrammeStatus.open         => '● Open',
      ProgrammeStatus.startingSoon => 'Starting Soon',
      ProgrammeStatus.closed       => 'Closed',
    };
    final statusColor = switch (programme.status) {
      ProgrammeStatus.open         => AppTheme.success,
      ProgrammeStatus.startingSoon => AppTheme.warning,
      ProgrammeStatus.closed       => AppTheme.mutedText,
    };
    final statusBg = switch (programme.status) {
      ProgrammeStatus.open         => AppTheme.successLow,
      ProgrammeStatus.startingSoon => AppTheme.warningLow,
      ProgrammeStatus.closed       => AppTheme.surface3,
    };

    final fillRatio = programme.capacity == 0
        ? 0.0
        : programme.enrolled / programme.capacity;
    final isFull = fillRatio >= 0.95;

    return GestureDetector(
      onTap: () => _handleProgrammeTap(programme),
      child: Container(
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
            // Image / banner area — 80px tall
            SizedBox(
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  programme.imageUrl != null
                      ? Image.network(
                    programme.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: AppTheme.surface3),
                  )
                      : Container(
                    color: AppTheme.surface3,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppTheme.subtleText,
                      size: 28,
                    ),
                  ),
                  // Status pill — top right
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
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programme.title,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${programme.provider} · ${programme.duration} · ${programme.level}',
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 10,
                    ),
                  ),
                  // Progress track
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: fillRatio,
                      minHeight: 3,
                      backgroundColor: AppTheme.surface3,
                      color: AppTheme.primary,
                    ),
                  ),
                  // Progress label
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isFull ? 'Almost full!' : 'Spots',
                        style: TextStyle(
                          color: isFull ? AppTheme.primary : AppTheme.subtleText,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        '${programme.enrolled}/${programme.capacity}',
                        style: const TextStyle(
                            color: AppTheme.subtleText, fontSize: 9),
                      ),
                    ],
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