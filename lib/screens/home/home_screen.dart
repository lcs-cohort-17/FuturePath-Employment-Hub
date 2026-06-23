import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class HomeOverviewStats {
  final int programmesCount;
  final int openJobsCount;
  final int employersCount;

  const HomeOverviewStats({
    required this.programmesCount,
    required this.openJobsCount,
    required this.employersCount,
  });
}

class JobListing {
  final String id;
  final String title;
  final String company;
  final String companyInitials;
  final String location;
  final List<String> skills;
  final String employmentType;
  final String closingLabel;
  final bool isOpen;

  const JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.companyInitials,
    required this.location,
    required this.skills,
    required this.employmentType,
    required this.closingLabel,
    this.isOpen = true,
  });
}

class ProgrammeListing {
  final String id;
  final String title;
  final String organization;
  final String durationLabel;
  final String levelLabel;
  final String statusLabel;
  final bool isOpen;
  final int enrolled;
  final int capacity;
  final IconData bannerIcon;
  final String bannerImageUrl;

  const ProgrammeListing({
    required this.id,
    required this.title,
    required this.organization,
    required this.durationLabel,
    required this.levelLabel,
    required this.statusLabel,
    required this.isOpen,
    required this.enrolled,
    required this.capacity,
    required this.bannerIcon,
    required this.bannerImageUrl,
  });

  double get progress => capacity == 0 ? 0 : (enrolled / capacity).clamp(0, 1);
}

class HomeDashboardData {
  final HomeOverviewStats stats;
  final List<JobListing> recommendedJobs;
  final List<ProgrammeListing> featuredProgrammes;

  const HomeDashboardData({
    required this.stats,
    required this.recommendedJobs,
    required this.featuredProgrammes,
  });
}

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? avatarInitials;
  final int notificationCount;
  final Future<HomeDashboardData> Function() dataLoader;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onSeeAllJobs;
  final VoidCallback onSeeAllProgrammes;
  final ValueChanged<JobListing> onJobTap;
  final ValueChanged<ProgrammeListing> onProgrammeTap;

  const HomeScreen({
    super.key,
    this.userName = 'Sipho',
    this.avatarInitials,
    this.notificationCount = 0,
    Future<HomeDashboardData> Function()? dataLoader,
    required this.onSearchSubmitted,
    required this.onSeeAllJobs,
    required this.onSeeAllProgrammes,
    required this.onJobTap,
    required this.onProgrammeTap,
  }) : dataLoader = dataLoader ?? _mockDataLoader;

  static Future<HomeDashboardData> _mockDataLoader() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const HomeDashboardData(
      stats: HomeOverviewStats(
        programmesCount: 6,
        openJobsCount: 12,
        employersCount: 4,
      ),
      recommendedJobs: [
        JobListing(
          id: 'job-1',
          title: 'Junior Flutter Developer',
          company: 'TechNova Solutions',
          companyInitials: 'TN',
          location: 'Cape Town',
          skills: ['Flutter', 'Dart', 'Firebase'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 31 Jul',
        ),
        JobListing(
          id: 'job-2',
          title: 'Digital Marketing Assistant',
          company: 'Digital Growth Hub',
          companyInitials: 'DG',
          location: 'Remote (SA-based)',
          skills: ['SEO', 'Social Media', 'Content Creation'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 20 Jul',
        ),
        JobListing(
          id: 'job-3',
          title: 'Salesforce Administrator Intern',
          company: 'FutureTech Africa',
          companyInitials: 'FT',
          location: 'Johannesburg',
          skills: ['Salesforce', 'CRM', 'Support'],
          employmentType: 'Internship',
          closingLabel: 'Closes 15 Aug',
        ),
        JobListing(
          id: 'job-4',
          title: 'Data Analyst Trainee',
          company: 'Innovate SA',
          companyInitials: 'IS',
          location: 'Durban',
          skills: ['Excel', 'SQL', 'Data Analysis'],
          employmentType: 'Full-time',
          closingLabel: 'Closes 5 Aug',
        ),
      ],
      featuredProgrammes: [
        ProgrammeListing(
          id: 'prog-1',
          title: 'Flutter Mobile Development',
          organization: 'TechNova Solutions',
          durationLabel: '3 months',
          levelLabel: 'Beginner–Intermediate',
          statusLabel: 'Open',
          isOpen: true,
          enrolled: 24,
          capacity: 30,
          bannerIcon: Icons.smartphone_rounded,
          bannerImageUrl:
          'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600&q=80',
        ),
        ProgrammeListing(
          id: 'prog-2',
          title: 'Salesforce Administration',
          organization: 'FutureTech Africa',
          durationLabel: '3 months',
          levelLabel: 'Beginner',
          statusLabel: 'Open',
          isOpen: true,
          enrolled: 20,
          capacity: 25,
          bannerIcon: Icons.bar_chart_rounded,
          bannerImageUrl:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&q=80',
        ),
        ProgrammeListing(
          id: 'prog-3',
          title: 'Digital Marketing Fundamentals',
          organization: 'Digital Growth Hub',
          durationLabel: '2 months',
          levelLabel: 'Beginner',
          statusLabel: 'Starting Soon',
          isOpen: false,
          enrolled: 38,
          capacity: 40,
          bannerIcon: Icons.campaign_rounded,
          bannerImageUrl:
          'https://images.unsplash.com/photo-1611926653458-09294b3142bf?w=600&q=80',
        ),
      ],
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeDashboardData> _futureData;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureData = widget.dataLoader();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retry() => setState(() => _futureData = widget.dataLoader());

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildGreeting(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 20),
              FutureBuilder<HomeDashboardData>(
                future: _futureData,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              'Could not load your dashboard.',
                              style: TextStyle(color: AppTheme.mutedText),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: _retry,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverview(data.stats),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.star_rounded,
                        title: 'Recommended for You',
                        onSeeAll: widget.onSeeAllJobs,
                      ),
                      const SizedBox(height: 12),
                      ...data.recommendedJobs.take(3).map(
                            (job) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _JobCard(
                            job: job,
                            onTap: () => widget.onJobTap(job),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSectionHeader(
                        icon: Icons.menu_book_rounded,
                        title: 'Featured Programmes',
                        onSeeAll: widget.onSeeAllProgrammes,
                      ),
                      const SizedBox(height: 12),
                      ...data.featuredProgrammes.take(3).map(
                            (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ProgrammeCard(
                            programme: p,
                            onTap: () => widget.onProgrammeTap(p),
                          ),
                        ),
                      ),
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
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'FP',
            style: TextStyle(
              color: AppTheme.card,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'FuturePath',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.textDark,
              size: 26,
            ),
            if (widget.notificationCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.notificationCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.card,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final initials = widget.avatarInitials ??
        (widget.userName.isNotEmpty
            ? widget.userName[0].toUpperCase()
            : '?');
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppTheme.secondary,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting 👋',
                style: const TextStyle(fontSize: 13, color: AppTheme.mutedText),
              ),
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.secondary),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: widget.onSearchSubmitted,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search jobs, programmes, skills...',
          hintStyle: TextStyle(color: AppTheme.mutedText, fontSize: 13.5),
          prefixIcon: Icon(Icons.search_rounded, color: AppTheme.mutedText, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildOverview(HomeOverviewStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.trending_up_rounded, color: AppTheme.accent, size: 18),
            SizedBox(width: 6),
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(
              icon: Icons.school_rounded,
              value: stats.programmesCount,
              label: 'Programmes',
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: Icons.work_outline_rounded,
              value: stats.openJobsCount,
              label: 'Open Jobs',
            ),
            const SizedBox(width: 10),
            _StatCard(
              icon: Icons.apartment_rounded,
              value: stats.employersCount,
              label: 'Employers',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.accent),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onSeeAll,
          child: Row(
            children: const [
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.accent),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppTheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppTheme.accent),
            ),
            const SizedBox(height: 10),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, color: AppTheme.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool isOpen;

  const _StatusPill({required this.label, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final bool isClosed = label.toLowerCase() == 'closed';
    final Color bg = isClosed
        ? AppTheme.mutedText
        : (isOpen ? AppTheme.accent : AppTheme.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.card,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.card,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobListing job;
  final VoidCallback onTap;

  const _JobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.secondary,
                  child: Text(
                    job.companyInitials,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.company} · ${job.location}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  label: job.isOpen ? 'Open' : 'Closed',
                  isOpen: job.isOpen,
                ),
              ],
            ),
            if (job.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.skills.map((s) => _SkillChip(label: s)).toList(),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.work_outline_rounded,
                    size: 14, color: AppTheme.mutedText),
                const SizedBox(width: 5),
                Text(
                  '${job.employmentType} · ${job.closingLabel}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgrammeCard extends StatelessWidget {
  final ProgrammeListing programme;
  final VoidCallback onTap;

  const _ProgrammeCard({required this.programme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    programme.bannerImageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: AppTheme.secondary,
                      child: Center(
                        child: Icon(
                          programme.bannerIcon,
                          size: 40,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _StatusPill(
                    label: programme.statusLabel,
                    isOpen: programme.isOpen,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programme.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    programme.organization,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${programme.durationLabel} • ${programme.levelLabel}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: programme.progress,
                            minHeight: 6,
                            backgroundColor: AppTheme.secondary,
                            valueColor:
                            const AlwaysStoppedAnimation(AppTheme.accent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${programme.enrolled}/${programme.capacity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
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