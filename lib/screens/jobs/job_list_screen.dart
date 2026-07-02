import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/skill_chip.dart';
import 'package:futurepath_employment_hub/providers/search_filter_provider.dart';
import 'package:futurepath_employment_hub/models/staff_job_model.dart';
import '../../services/public_data_service.dart';
import 'package:futurepath_employment_hub/models/opportunity.dart';
import 'job_detail_screen.dart';

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
  const OpportunityListScreen({super.key});

  @override
  ConsumerState<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends ConsumerState<OpportunityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSkill = 'All';
  String _selectedJobType = 'All Types';
  SortOption _sortOption = SortOption.mostRelevant;

  List<StaffJobModel> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  Future<void> _loadJobs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final fetched = await PublicDataService.getJobs();
      if (mounted) {
        setState(() {
          _jobs = fetched;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StaffJobModel> get _filtered {
    List<StaffJobModel> list = _jobs;
    final filterState = ref.read(searchFilterProvider);

    if (_searchQuery.isNotEmpty) {
      list = list.where((opportunity) {
        return opportunity.positionTitle.toLowerCase().contains(_searchQuery) ||
            (opportunity.requiredSkills?.any((skill) => skill.toLowerCase().contains(_searchQuery)) ?? false);
      }).toList();
    }

    if (_selectedSkill != 'All') {
      list = list.where((opportunity) =>
          opportunity.requiredSkills?.any((skill) => skill.toLowerCase() == _selectedSkill.toLowerCase()) ?? false).toList();
    }

    // Note: Job Type might not be in StaffJobModel/Schema yet, using a default or mapping if available
    // For now we'll skip job type filter or assume full-time

    if (filterState.selectedLocations.isNotEmpty) {
      // Location is not directly in StaffJobModel, would need Employer join
      // list = list.where((opportunity) =>
      //     filterState.selectedLocations.contains(opportunity.location)).toList();
    }

    switch (_sortOption) {
      case SortOption.mostRelevant:
        break;
      case SortOption.closingDate:
        list = [...list]..sort((a, b) => (a.closingDate ?? DateTime.now()).compareTo(b.closingDate ?? DateTime.now()));
        break;
      case SortOption.salaryHighest:
        // Salary not in schema
        break;
      case SortOption.newest:
        list = [...list]..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
    }

    return list;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
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
                          filterNotifier.toggleLocation(location);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accent,
          onRefresh: _loadJobs,
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
                      final job = filtered[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16, index == 0 ? 4 : 0, 16, 12),
                        child: _OpportunityCard(
                          job: job,
                          onTap: () {
                            // Detail screen needs update to handle StaffJobModel
                          },
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
          hintText: 'Search jobs, skills...',
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
  final StaffJobModel job;
  final VoidCallback onTap;

  const _OpportunityCard({
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final skills = job.requiredSkills ?? [];
    final visibleSkills = skills.take(3).toList();
    final extraSkills = skills.length > 3 ? skills.length - 3 : 0;

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
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      job.positionTitle.isNotEmpty ? job.positionTitle[0].toUpperCase() : '?',
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
                        job.positionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Company Name', // Would need Employer join to display
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (job.opportunityStatus == 'open')
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
                    'Closes ${job.closingDate?.toIso8601String().split('T').first ?? 'N/A'} · ${job.numberAvailablePositions ?? 0} positions',
                    style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                    overflow: TextOverflow.ellipsis,
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
