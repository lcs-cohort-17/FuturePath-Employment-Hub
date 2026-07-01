import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../core/widgets/notification_badge.dart';

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
    this.fetchDashboardData = _mockFetchDashboardData,
    this.onSearch,
    this.onSeeAllJobs,
    this.onSeeAllProgrammes,
    this.onJobTap,
    this.onProgrammeTap,
  });

  final String userName;
  final String userInitials;
  final DashboardFetcher fetchDashboardData;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onSeeAllJobs;
  final VoidCallback? onSeeAllProgrammes;
  final ValueChanged<JobSummary>? onJobTap;
  final ValueChanged<ProgrammeSummary>? onProgrammeTap;

  static Future<HomeDashboardData> _mockFetchDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return HomeDashboardData(
      programmesCount: 6,
      openJobsCount: 12,
      employersCount: 4,
      recommendedJobs: [
        const JobSummary(
          id: 'job-tn-flutter',
          title: 'Junior Flutter Developer',
          company: 'TechNova Solutions',
          companyInitials: 'TN',
          skills: ['Flutter', 'Dart', 'Firebase'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 31 Jul',
        ),
        const JobSummary(
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
        const ProgrammeSummary(
          id: 'prog-flutter-dev',
          title: 'Flutter Mobile Development',
          provider: 'TechNova Solutions',
          duration: '3 months',
          level: 'Beginner–Intermediate',
          enrolled: 24,
          capacity: 30,
        ),
        const ProgrammeSummary(
          id: 'prog-salesforce',
          title: 'Salesforce Administration',
          provider: 'FutureTech Africa',
          duration: '3 months',
          level: 'Beginner',
          enrolled: 20,
          capacity: 25,
        ),
        const ProgrammeSummary(
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
    if (widget.onSeeAllJobs != null) {
      widget.onSeeAllJobs!();
    }
  }

  void _handleSeeAllProgrammes() {
    if (widget.onSeeAllProgrammes != null) {
      widget.onSeeAllProgrammes!();
    }
  }

  void _handleJobTap(JobSummary job) {
    if (widget.onJobTap != null) {
      widget.onJobTap!(job);
    }
  }

  void _handleProgrammeTap(ProgrammeSummary programme) {
    if (widget.onProgrammeTap != null) {
      widget.onProgrammeTap!(programme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildGreeting(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              FutureBuilder<HomeDashboardData>(
                future: _dashboardFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.accent),
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
                      _buildOverviewSection(data),
                      const SizedBox(height: 24),
                      _buildRecommendedSection(data),
                      const SizedBox(height: 24),
                      _buildFeaturedSection(data),
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

  Widget _buildTopBar() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppTheme.primary,
          child: Text('FP', style: TextStyle(color: AppTheme.card, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        const Text(
          'FuturePath',
          style: TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const NotificationBadge(iconColor: AppTheme.primary),
      ],
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppTheme.secondary,
          child: Text(widget.userInitials,
              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_greeting 👋', style: const TextStyle(color: AppTheme.mutedText, fontSize: 13)),
              Text(widget.userName,
                  style: const TextStyle(
                      color: AppTheme.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Icon(Icons.wb_sunny_outlined, color: AppTheme.mutedText),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onSubmitted: _handleSearchSubmitted,
      style: const TextStyle(color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: 'Search jobs, programmes, skills...',
        hintStyle: const TextStyle(color: AppTheme.mutedText),
        prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText),
        filled: true,
        fillColor: AppTheme.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(title,
              style: const TextStyle(color: AppTheme.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Row(
            children: [
              Text('See all', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w600)),
              Icon(Icons.chevron_right, color: AppTheme.accent, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(HomeDashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.trending_up, color: AppTheme.accent, size: 20),
            SizedBox(width: 6),
            Text('Overview',
                style: TextStyle(color: AppTheme.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _statCard(Icons.school_outlined, '${data.programmesCount}', 'Programmes')),
            const SizedBox(width: 12),
            Expanded(child: _statCard(Icons.work_outline, '${data.openJobsCount}', 'Open Jobs')),
            const SizedBox(width: 12),
            Expanded(child: _statCard(Icons.apartment_outlined, '${data.employersCount}', 'Employers')),
          ],
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accent, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppTheme.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(HomeDashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.star_border_rounded,
          iconColor: AppTheme.accent,
          title: 'Recommended for You',
          onSeeAll: _handleSeeAllJobs,
        ),
        const SizedBox(height: 12),
        ...data.recommendedJobs.take(3).map(
              (job) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _jobCard(job)),
        ),
      ],
    );
  }

  Widget _jobCard(JobSummary job) {
    return GestureDetector(
      onTap: () => _handleJobTap(job),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.secondary,
                  child: Text(job.companyInitials,
                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(job.company, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
                    ],
                  ),
                ),
                _statusPill(label: job.isOpen ? 'Open' : 'Closed', color: job.isOpen ? AppTheme.accent : AppTheme.mutedText),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: job.skills.map(_skillChip).toList()),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 14, color: AppTheme.mutedText),
                const SizedBox(width: 4),
                Text('${job.employmentType} · ${job.closingLabel}',
                    style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _statusPill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(HomeDashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.rocket_launch_outlined,
          iconColor: AppTheme.primary,
          title: 'Featured Programmes',
          onSeeAll: _handleSeeAllProgrammes,
        ),
        const SizedBox(height: 12),
        ...data.featuredProgrammes.take(3).map(
              (p) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _programmeCard(p)),
        ),
      ],
    );
  }

  Widget _programmeCard(ProgrammeSummary programme) {
    final statusColor = switch (programme.status) {
      ProgrammeStatus.open => AppTheme.accent,
      ProgrammeStatus.startingSoon => AppTheme.primary,
      ProgrammeStatus.closed => AppTheme.mutedText,
    };
    final statusLabel = switch (programme.status) {
      ProgrammeStatus.open => 'Open',
      ProgrammeStatus.startingSoon => 'Starting Soon',
      ProgrammeStatus.closed => 'Closed',
    };

    return GestureDetector(
      onTap: () => _handleProgrammeTap(programme),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  programme.imageUrl != null
                      ? Image.network(programme.imageUrl!,
                      fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.secondary))
                      : Container(
                    color: AppTheme.secondary,
                    child: const Center(child: Icon(Icons.image_outlined, color: AppTheme.primary, size: 32)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.primary.withValues(alpha: 0.0), AppTheme.primary.withValues(alpha: 0.75)],
                      ),
                    ),
                  ),
                  Positioned(top: 10, right: 10, child: _statusPill(label: statusLabel, color: statusColor)),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(programme.title,
                            style: const TextStyle(color: AppTheme.card, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(programme.provider, style: TextStyle(color: AppTheme.card.withValues(alpha: 0.85), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: AppTheme.mutedText),
                      const SizedBox(width: 4),
                      Text('${programme.duration} · ${programme.level}',
                          style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: programme.capacity == 0 ? 0 : programme.enrolled / programme.capacity,
                            minHeight: 6,
                            backgroundColor: AppTheme.secondary,
                            color: AppTheme.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${programme.enrolled}/${programme.capacity}',
                          style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
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
