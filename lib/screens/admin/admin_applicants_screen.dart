import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/empty_state.dart';
import 'package:futurepath_employment_hub/core/widgets/error_message.dart';
import 'package:futurepath_employment_hub/core/widgets/loading_indicator.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class Applicant {
  final String applicantId;
  final String idNumber;
  final List<String> skills;
  final String qualification;
  final String employmentStatus;
  final String programmeEnrolled;
  final int applicationsSubmitted;
  final String registeredDate;

  const Applicant({
    required this.applicantId,
    required this.idNumber,
    required this.skills,
    required this.qualification,
    required this.employmentStatus,
    required this.programmeEnrolled,
    required this.applicationsSubmitted,
    required this.registeredDate,
  });

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      applicantId: map['user_id']?.toString().substring(0, 8).toUpperCase() ?? 'APP-UNK',
      idNumber: map['ID_Number']?.toString() ?? 'N/A',
      skills: (map['Skills'] as List?)?.map((e) => e.toString()).toList() ?? (map['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      qualification: map['Highest_Qualification'] ?? map['highest_qualification'] ?? 'N/A',
      employmentStatus: map['Current_Employment_Status'] ?? map['employment_status'] ?? 'N/A',
      programmeEnrolled: 'N/A', // Would need join with enrolments
      applicationsSubmitted: 0, // Would need join/count from applications
      registeredDate: map['updated_at'] != null 
          ? '${DateTime.parse(map['updated_at']).day} ${DateTime.parse(map['updated_at']).month}' 
          : 'N/A',
    );
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
  final _supabase = Supabase.instance.client;
  List<Applicant> _all = [];
  List<Applicant> _filtered = [];
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
      final response = await _supabase
          .from('Applicant')
          .select()
          .eq('role', 'job_seeker'); // Only fetch job seekers

      final data = List<Map<String, dynamic>>.from(response);
      setState(() {
        _all = data.map((m) => Applicant.fromMap(m)).toList();
        _filtered = _all;
        _loading = false;
      });
    } catch (e) {
      print('❌ Error loading applicants: $e');
      setState(() {
        _error = 'Failed to load applicants from database.';
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

  void _openDetail(Applicant applicant) {
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
                ? const LoadingIndicator(color: AppTheme.primary)
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

class _Body extends StatelessWidget {
  final List<Applicant> filtered;
  final List<Applicant> all;
  final TextEditingController searchController;
  final String activeFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterTap;
  final ValueChanged<Applicant> onCardTap;

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
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Row(
                  children: [
                    _StatPill(label: 'Total', value: '${all.length}', color: AppTheme.textDark),
                    const SizedBox(width: 8),
                    _StatPill(
                      label: 'Unemployed',
                      value: '${all.where((a) => a.employmentStatus.toLowerCase() == 'unemployed').length}',
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      label: 'Seeking',
                      value: '${all.where((a) => a.employmentStatus.toLowerCase() == 'seeking').length}',
                      color: AppTheme.warning,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
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
                        controller: searchController,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search by ID or skill…',
                          hintStyle: TextStyle(fontSize: 12, color: AppTheme.subtleText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final f = filters[i];
                    final active = f == activeFilter;
                    return GestureDetector(
                      onTap: () => onFilterTap(f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: active ? AppTheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: active ? AppTheme.primary : AppTheme.border,
                            width: active ? 1 : 0.5,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : AppTheme.mutedText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${filtered.length} applicant${filtered.length == 1 ? '' : 's'} found',
                  style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 12, color: AppTheme.subtleText),
                    SizedBox(width: 6),
                    Text(
                      'Personal data (name, email, phone, ID) is never shown',
                      style: TextStyle(fontSize: 9, color: AppTheme.subtleText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        filtered.isEmpty
            ? const SliverFillRemaining(child: EmptyState(message: 'No applicants found.'))
            : SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => _ApplicantCard(applicant: filtered[index], onTap: () => onCardTap(filtered[index])),
            childCount: filtered.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});
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
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.mutedText)),
        ],
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  final Applicant applicant;
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
                        border: Border.all(color: AppTheme.border2, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_outline, size: 16, color: AppTheme.mutedText),
                    ),
                    const SizedBox(width: 9),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(applicant.applicantId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                        Text(applicant.qualification, style: const TextStyle(fontSize: 10, color: AppTheme.mutedText)),
                      ],
                    ),
                  ],
                ),
                _StatusBadge(status: applicant.employmentStatus),
              ],
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: applicant.skills.take(3).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surface3,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppTheme.border, width: 0.5),
                ),
                child: Text(s, style: const TextStyle(fontSize: 9, color: AppTheme.mutedText)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

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
      ),
      child: Text(status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _statusColor(status))),
    );
  }
}

class _ApplicantDetailSheet extends StatelessWidget {
  final Applicant applicant;
  const _ApplicantDetailSheet({required this.applicant});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Text(applicant.applicantId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 10),
            Text('Qualification: ${applicant.qualification}', style: const TextStyle(color: AppTheme.mutedText)),
            const SizedBox(height: 5),
            Text('Status: ${applicant.employmentStatus}', style: const TextStyle(color: AppTheme.mutedText)),
            const SizedBox(height: 20),
            const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: applicant.skills.map((s) => Chip(label: Text(s))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
