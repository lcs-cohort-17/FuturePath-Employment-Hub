//Sisonke Sprint2 UIUX Ticket No 0019
// lib/screens/admin/admin_applicants_screen.dart

import 'package:flutter/material.dart';
import 'package:futurepath/core/theme/app_theme.dart';
import 'package:futurepath/core/widgets/empty_state.dart';
import 'package:futurepath/core/widgets/error_message.dart';
import 'package:futurepath/core/widgets/loading_indicator.dart';
import 'package:futurepath/core/widgets/status_chip.dart';

// ---------------------------------------------------------------------------
// Mock model — replace with real Applicant model when DB is connected
// ---------------------------------------------------------------------------

class _Applicant {
  final String applicantId;
  final List<String> skills;
  final String qualification;
  final String employmentStatus;
  final String programmeEnrolled;
  final int applicationsSubmitted;
  final String registeredDate;

  const _Applicant({
    required this.applicantId,
    required this.skills,
    required this.qualification,
    required this.employmentStatus,
    required this.programmeEnrolled,
    required this.applicationsSubmitted,
    required this.registeredDate,
  });
}

// ---------------------------------------------------------------------------
// Mock service — swap out for real service call when DB is connected
// [DATA-SERVICE] — replace _MockApplicantService with real ApplicantService
// ---------------------------------------------------------------------------

class _MockApplicantService {
  static Future<List<_Applicant>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const [
      _Applicant(
        applicantId: 'APP-00147',
        skills: ['Flutter', 'Dart', 'Firebase'],
        qualification: 'Matric / NSC',
        employmentStatus: 'Unemployed',
        programmeEnrolled: 'Flutter Mobile Development',
        applicationsSubmitted: 3,
        registeredDate: '12 Mar 2026',
      ),
      _Applicant(
        applicantId: 'APP-00198',
        skills: ['Python', 'SQL', 'Power BI'],
        qualification: 'National Diploma',
        employmentStatus: 'Seeking',
        programmeEnrolled: 'Data Analytics Bootcamp',
        applicationsSubmitted: 5,
        registeredDate: '01 Apr 2026',
      ),
      _Applicant(
        applicantId: 'APP-00203',
        skills: ['Salesforce', 'CRM', 'Excel'],
        qualification: 'Bachelor\'s Degree',
        employmentStatus: 'Employed',
        programmeEnrolled: 'Salesforce Administration',
        applicationsSubmitted: 1,
        registeredDate: '18 Apr 2026',
      ),
      _Applicant(
        applicantId: 'APP-00231',
        skills: ['SEO', 'Social Media', 'Content Writing'],
        qualification: 'Matric / NSC',
        employmentStatus: 'Unemployed',
        programmeEnrolled: 'Digital Marketing Fundamentals',
        applicationsSubmitted: 4,
        registeredDate: '22 Apr 2026',
      ),
      _Applicant(
        applicantId: 'APP-00255',
        skills: ['AWS', 'Linux', 'Terraform'],
        qualification: 'National Diploma',
        employmentStatus: 'Seeking',
        programmeEnrolled: 'Cloud Fundamentals Bootcamp',
        applicationsSubmitted: 2,
        registeredDate: '05 May 2026',
      ),
      _Applicant(
        applicantId: 'APP-00267',
        skills: ['Figma', 'User Research', 'Prototyping'],
        qualification: 'Bachelor\'s Degree',
        employmentStatus: 'Unemployed',
        programmeEnrolled: 'None',
        applicationsSubmitted: 6,
        registeredDate: '10 May 2026',
      ),
      _Applicant(
        applicantId: 'APP-00284',
        skills: ['Network Security', 'Linux', 'Wireshark'],
        qualification: 'National Diploma',
        employmentStatus: 'Seeking',
        programmeEnrolled: 'Cybersecurity Essentials',
        applicationsSubmitted: 2,
        registeredDate: '14 May 2026',
      ),
      _Applicant(
        applicantId: 'APP-00301',
        skills: ['Microsoft Office', 'Communication', 'Problem Solving'],
        qualification: 'Matric / NSC',
        employmentStatus: 'Unemployed',
        programmeEnrolled: 'None',
        applicationsSubmitted: 7,
        registeredDate: '19 May 2026',
      ),
      _Applicant(
        applicantId: 'APP-00318',
        skills: ['JavaScript', 'React', 'Node.js'],
        qualification: 'Bachelor\'s Degree',
        employmentStatus: 'Employed',
        programmeEnrolled: 'Flutter Mobile Development',
        applicationsSubmitted: 1,
        registeredDate: '02 Jun 2026',
      ),
      _Applicant(
        applicantId: 'APP-00332',
        skills: ['Accounting', 'Pastel', 'Excel'],
        qualification: 'National Certificate',
        employmentStatus: 'Seeking',
        programmeEnrolled: 'None',
        applicationsSubmitted: 3,
        registeredDate: '08 Jun 2026',
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// Status helpers
// ---------------------------------------------------------------------------

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'employed':
      return AppTheme.success;
    case 'seeking':
      return AppTheme.warning;
    case 'unemployed':
    default:
      return AppTheme.primary;
  }
}

Color _statusBg(String status) {
  switch (status.toLowerCase()) {
    case 'employed':
      return AppTheme.successLow;
    case 'seeking':
      return AppTheme.warningLow;
    case 'unemployed':
    default:
      return AppTheme.primaryLow;
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AdminApplicantsScreen extends StatefulWidget {
  const AdminApplicantsScreen({super.key});

  @override
  State<AdminApplicantsScreen> createState() => _AdminApplicantsScreenState();
}

class _AdminApplicantsScreenState extends State<AdminApplicantsScreen> {
  List<_Applicant> _all = [];
  List<_Applicant> _filtered = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'All';

  static const List<String> _filters = [
    'All',
    'Unemployed',
    'Seeking',
    'Employed',
  ];

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _MockApplicantService.fetchAll();
      setState(() {
        _all = data;
        _filtered = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load applicants. Please try again.';
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _all.where((a) {
        final matchesSearch = query.isEmpty ||
            a.applicantId.toLowerCase().contains(query) ||
            a.skills.any((s) => s.toLowerCase().contains(query));
        final matchesFilter = _activeFilter == 'All' ||
            a.employmentStatus.toLowerCase() ==
                _activeFilter.toLowerCase();
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _setFilter(String filter) {
    setState(() => _activeFilter = filter);
    _applyFilters();
  }

  void _openDetail(_Applicant applicant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ApplicantDetailSheet(applicant: applicant),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          _TopBar(),
          Expanded(
            child: _loading
                ? const LoadingIndicator()
                : _error != null
                ? ErrorMessage(
              message: _error!,
              onRetry: _load,
            )
                : _Body(
              filtered: _filtered,
              all: _all,
              searchController: _searchController,
              activeFilter: _activeFilter,
              filters: _filters,
              onFilterTap: _setFilter,
              onCardTap: _openDetail,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            'Applicants',
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
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.2),
                width: 0.5,
              ),
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
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _Body extends StatelessWidget {
  final List<_Applicant> filtered;
  final List<_Applicant> all;
  final TextEditingController searchController;
  final String activeFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterTap;
  final ValueChanged<_Applicant> onCardTap;

  const _Body({
    required this.filtered,
    required this.all,
    required this.searchController,
    required this.activeFilter,
    required this.filters,
    required this.onFilterTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats strip
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Row(
                  children: [
                    _StatPill(
                      label: 'Total',
                      value: '${all.length}',
                      color: AppTheme.textDark,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      label: 'Unemployed',
                      value: '${all.where((a) => a.employmentStatus == 'Unemployed').length}',
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      label: 'Seeking',
                      value: '${all.where((a) => a.employmentStatus == 'Seeking').length}',
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      label: 'Employed',
                      value: '${all.where((a) => a.employmentStatus == 'Employed').length}',
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 16, color: AppTheme.subtleText),
                    const SizedBox(width: 7),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textDark,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search by ID or skill…',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppTheme.subtleText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Filter pills
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final f = filters[i];
                    final active = f == activeFilter;
                    return GestureDetector(
                      onTap: () => onFilterTap(f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: active ? AppTheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: active
                                ? AppTheme.primary
                                : AppTheme.border,
                            width: active ? 1 : 0.5,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? Colors.white
                                : AppTheme.mutedText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Result count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${filtered.length} applicant${filtered.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Privacy notice
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline,
                        size: 12, color: AppTheme.subtleText),
                    SizedBox(width: 6),
                    Text(
                      'Personal data (name, email, phone, ID) is never shown',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.subtleText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // List
        filtered.isEmpty
            ? const SliverFillRemaining(
          child: EmptyState(
            message: 'No applicants match your search.',
          ),
        )
            : SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final applicant = filtered[index];
              return _ApplicantCard(
                applicant: applicant,
                onTap: () => onCardTap(applicant),
              );
            },
            childCount: filtered.length,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stat pill
// ---------------------------------------------------------------------------

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppTheme.mutedText),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Applicant card — minimal info only
// ---------------------------------------------------------------------------

class _ApplicantCard extends StatelessWidget {
  final _Applicant applicant;
  final VoidCallback onTap;

  const _ApplicantCard({required this.applicant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: ID + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.surface3,
                        borderRadius: BorderRadius.circular(9),
                        border:
                        Border.all(color: AppTheme.border2, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppTheme.mutedText,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.applicantId,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          applicant.qualification,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _StatusBadge(status: applicant.employmentStatus),
              ],
            ),
            const SizedBox(height: 9),

            // Skills chips
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: applicant.skills
                  .take(3)
                  .map(
                    (s) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.surface3,
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 8),

            // Footer: tap hint
            Row(
              children: [
                const Spacer(),
                Text(
                  'View details',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppTheme.primary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: AppTheme.primary.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _statusBg(status),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: _statusColor(status).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: _statusColor(status),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail modal bottom sheet — still zero PII
// ---------------------------------------------------------------------------

class _ApplicantDetailSheet extends StatelessWidget {
  final _Applicant applicant;

  const _ApplicantDetailSheet({required this.applicant});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.88,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(color: AppTheme.border2, width: 0.5),
              left: BorderSide(color: AppTheme.border, width: 0.5),
              right: BorderSide(color: AppTheme.border, width: 0.5),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surface4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Sheet header
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surface3,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                            color: AppTheme.border2, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_outline,
                          size: 20, color: AppTheme.mutedText),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.applicantId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Row(
                          children: [
                            Icon(Icons.lock_outline,
                                size: 10, color: AppTheme.subtleText),
                            SizedBox(width: 3),
                            Text(
                              'Identity protected',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.subtleText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    _StatusBadge(status: applicant.employmentStatus),
                  ],
                ),
              ),

              const Divider(
                  color: AppTheme.border, thickness: 0.5, height: 1),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  children: [
                    // Info grid
                    _SectionLabel(label: 'APPLICANT DETAILS'),
                    const SizedBox(height: 10),
                    _InfoGrid(children: [
                      _InfoCell(
                          label: 'APPLICANT ID',
                          value: applicant.applicantId),
                      _InfoCell(
                          label: 'QUALIFICATION',
                          value: applicant.qualification),
                      _InfoCell(
                          label: 'STATUS',
                          value: applicant.employmentStatus,
                          valueColor: _statusColor(applicant.employmentStatus)),
                      _InfoCell(
                          label: 'APPLICATIONS',
                          value:
                          '${applicant.applicationsSubmitted} submitted'),
                      _InfoCell(
                          label: 'REGISTERED',
                          value: applicant.registeredDate),
                      _InfoCell(
                          label: 'PROGRAMME',
                          value: applicant.programmeEnrolled),
                    ]),

                    const SizedBox(height: 16),

                    // Skills
                    _SectionLabel(label: 'SKILLS'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: applicant.skills
                          .map(
                            (s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLow,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.2),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    // Privacy block
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface3,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: AppTheme.border, width: 0.5),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lock_outline,
                              size: 14, color: AppTheme.subtleText),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Name, email, phone number, ID number, date of birth, and address are never accessible to admin accounts.',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.mutedText,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // [UIUX-022] — job applications list for this applicant goes here

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Detail sheet sub-widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppTheme.mutedText,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> children;

  const _InfoGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: children,
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: AppTheme.subtleText,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: valueColor ?? AppTheme.textDark,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}