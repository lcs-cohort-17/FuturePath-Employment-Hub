import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/skill_chip.dart';
import 'package:futurepath_employment_hub/providers/search_filter_provider.dart';
import 'opportunity_detail_screen.dart';

class Opportunity {
  final String id;
  final String title;
  final String company;
  final String companyIndustry;
  final String location;
  final String jobType;
  final List<String> skills;
  final String closingDate;
  final int positions;
  final String salaryRange;
  final bool isOpen;
  final String? duration;
  final String description;
  final List<RelatedProgramme> relatedProgrammes;
  final String logoInitials;
  final Color logoColor;

  const Opportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.companyIndustry,
    required this.location,
    required this.jobType,
    required this.skills,
    required this.closingDate,
    required this.positions,
    required this.salaryRange,
    required this.isOpen,
    this.duration,
    required this.description,
    required this.relatedProgrammes,
    required this.logoInitials,
    required this.logoColor,
  });
}

class RelatedProgramme {
  final String title;
  final String duration;
  final String level;
  final bool isOpen;

  const RelatedProgramme({
    required this.title,
    required this.duration,
    required this.level,
    required this.isOpen,
  });
}

final List<Opportunity> _mockOpportunities = [
  Opportunity(
    id: '1',
    title: 'Junior Flutter Developer',
    company: 'TechNova Solutions',
    companyIndustry: 'Technology',
    location: 'Cape Town',
    jobType: 'Full-time',
    skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
    closingDate: '31 Jul 2026',
    positions: 3,
    salaryRange: 'R18,000 – R25,000',
    isOpen: true,
    description: 'TechNova Solutions is looking for a passionate Junior Flutter Developer.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Flutter Development Bootcamp', duration: '3 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'T',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '2',
    title: 'Salesforce Administrator Intern',
    company: 'FutureTech Africa',
    companyIndustry: 'Business',
    location: 'Johannesburg',
    jobType: 'Internship',
    skills: ['Salesforce', 'CRM', 'Data Management', 'Excel', 'Communication'],
    closingDate: '15 Jul 2026',
    positions: 5,
    salaryRange: 'R12,000',
    isOpen: true,
    duration: '4 months',
    description: 'Join FutureTech Africa as a Salesforce Administrator Intern.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Salesforce Administration', duration: '3 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'F',
    logoColor: const Color(0xFF7C3AED),
  ),
];

enum SortOption { mostRelevant, closingDate, salaryHighest, newest }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.mostRelevant:
        return 'Most Relevant';
      case SortOption.closingDate:
        return 'Closing Date';
      case SortOption.salaryHighest:
        return 'Salary (Highest First)';
      case SortOption.newest:
        return 'Newest';
    }
  }
}

const List<String> _skillFilters = ['All', 'Flutter', 'Python', 'SQL', 'Salesforce', 'Digital Marketing'];
const List<String> _jobTypeFilters = ['All Types', 'Full-time', 'Part-time', 'Internship', 'Learnership'];
const List<String> _locationFilters = ['All Locations', 'Cape Town', 'Johannesburg', 'Durban', 'Remote'];

class OpportunityListScreen extends ConsumerStatefulWidget {
  final List<Opportunity> opportunities;
  final Future<void> Function()? onRefresh;

  const OpportunityListScreen({
    super.key,
    this.opportunities = const [],
    this.onRefresh,
  });

  @override
  ConsumerState<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends ConsumerState<OpportunityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSkill = 'All';
  String _selectedJobType = 'All Types';
  SortOption _sortOption = SortOption.mostRelevant;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Opportunity> get _source =>
      widget.opportunities.isNotEmpty ? widget.opportunities : _mockOpportunities;

  List<Opportunity> get _filtered {
    List<Opportunity> list = _source;
    final filterState = ref.read(searchFilterProvider);

    if (_searchQuery.isNotEmpty) {
      list = list.where((opportunity) {
        return opportunity.title.toLowerCase().contains(_searchQuery) ||
            opportunity.company.toLowerCase().contains(_searchQuery) ||
            opportunity.skills.any((skill) => skill.toLowerCase().contains(_searchQuery));
      }).toList();
    }

    if (_selectedSkill != 'All') {
      list = list.where((opportunity) =>
          opportunity.skills.any((skill) => skill.toLowerCase() == _selectedSkill.toLowerCase())).toList();
    }

    if (_selectedJobType != 'All Types') {
      list = list.where((opportunity) => opportunity.jobType == _selectedJobType).toList();
    }

    if (filterState.selectedLocations.isNotEmpty) {
      list = list.where((opportunity) =>
          filterState.selectedLocations.contains(opportunity.location)).toList();
    }

    switch (_sortOption) {
      case SortOption.mostRelevant:
        break;
      case SortOption.closingDate:
        list = [...list]..sort((a, b) => a.closingDate.compareTo(b.closingDate));
        break;
      case SortOption.salaryHighest:
        list = [...list]..sort((a, b) {
          final aVal = _extractMaxSalary(a.salaryRange);
          final bVal = _extractMaxSalary(b.salaryRange);
          return bVal.compareTo(aVal);
        });
        break;
      case SortOption.newest:
        list = list.reversed.toList();
        break;
    }

    return list;
  }

  int _extractMaxSalary(String salaryRange) {
    final digits = RegExp(r'\d+').allMatches(salaryRange.replaceAll(',', ''));
    if (digits.isEmpty) return 0;
    return digits.map((match) => int.parse(match.group(0)!)).reduce((a, b) => a > b ? a : b);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          // Get both state and notifier
          final filterState = ref.watch(searchFilterProvider);
          final filterNotifier = ref.watch(searchFilterProvider.notifier);

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _locationFilters.map((location) {
                      final isSelected = location == 'All Locations'
                          ? filterState.selectedLocations.isEmpty
                          : filterState.selectedLocations.contains(location);

                      return _FilterChip(
                        label: location,
                        selected: isSelected,
                        onTap: () {
                          // Use notifier to call method
                          filterNotifier.toggleLocation(location);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Job Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _jobTypeFilters.map((jobType) {
                      final isSelected = jobType == 'All Types'
                          ? _selectedJobType == 'All Types'
                          : _selectedJobType == jobType;

                      return _FilterChip(
                        label: jobType,
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedJobType = jobType;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use the skills chips above the list to filter by skill',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Use notifier to call method
                            filterNotifier.clearFilters();
                            setState(() {
                              _selectedJobType = 'All Types';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white38),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accent,
          onRefresh: widget.onRefresh ?? () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildSkillFilterRow()),
              SliverToBoxAdapter(child: _buildCountRow(filtered.length)),
              SliverToBoxAdapter(child: _buildSortFilterRow()),
              if (filtered.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No opportunities match your filters.',
                      style: TextStyle(color: AppTheme.mutedText),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16, index == 0 ? 4 : 0, 16, 12),
                        child: _OpportunityCard(
                          opportunity: filtered[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpportunityDetailScreen(
                                opportunity: filtered[index],
                              ),
                            ),
                          ),
                          onCompanyTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const _PlaceholderScreen(
                                message: 'Employer Detail Screen - coming soon',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Opportunities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          Row(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  // Get state only (for reading properties)
                  final filterState = ref.watch(searchFilterProvider);
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: _showFilterBottomSheet,
                        icon: const Icon(Icons.filter_list, color: AppTheme.textDark, size: 28),
                      ),
                      if (filterState.activeFilterCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${filterState.activeFilterCount}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: AppTheme.textDark, size: 28),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '4',
                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search jobs, companies, skills...',
          hintStyle: const TextStyle(color: AppTheme.mutedText, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText, size: 20),
          filled: true,
          fillColor: AppTheme.card,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.mutedText.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.mutedText.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.accent),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillFilterRow() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _skillFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _skillFilters[index];
          final selected = _selectedSkill == label;
          return _FilterChipItem(
            label: label,
            selected: selected,
            onTap: () => setState(() => _selectedSkill = label),
          );
        },
      ),
    );
  }

  Widget _buildCountRow(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Text(
        '$count ${count == 1 ? 'opportunity' : 'opportunities'} found',
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.mutedText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSortFilterRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Text(
            'SORT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedText,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: SortOption.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final option = SortOption.values[index];
              final selected = _sortOption == option;
              return _FilterChipItem(
                label: option.label,
                selected: selected,
                onTap: () => setState(() => _sortOption = option),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : Colors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accent : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool outlined;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : (outlined ? Colors.transparent : AppTheme.card),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.accent
                : outlined
                ? AppTheme.mutedText.withValues(alpha: 0.4)
                : AppTheme.mutedText.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : AppTheme.textDark,
          ),
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;
  final VoidCallback onCompanyTap;

  const _OpportunityCard({
    required this.opportunity,
    required this.onTap,
    required this.onCompanyTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibleSkills = opportunity.skills.take(3).toList();
    final extraSkills = opportunity.skills.length > 3 ? opportunity.skills.length - 3 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: opportunity.logoColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      opportunity.logoInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: onCompanyTap,
                        child: Text(
                          opportunity.company,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (opportunity.isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.circle, size: 6, color: Color(0xFF16A34A)),
                        SizedBox(width: 4),
                        Text(
                          'Open',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.mutedText),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    opportunity.location,
                    style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: AppTheme.mutedText),
                const SizedBox(width: 4),
                Text(
                  opportunity.jobType,
                  style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...visibleSkills.map((skill) => SkillChip(label: skill)),
                if (extraSkills > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+$extraSkills',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Closes ${opportunity.closingDate} · ${opportunity.positions} ${opportunity.positions == 1 ? 'position' : 'positions'}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  opportunity.salaryRange,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String message;

  const _PlaceholderScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Coming Soon'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}