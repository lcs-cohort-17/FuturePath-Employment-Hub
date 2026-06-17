<<<<<<< HEAD
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../services/search_filter_service.dart';

class OpportunityListScreen extends StatefulWidget {
  const OpportunityListScreen({super.key});

  @override
  State<OpportunityListScreen> createState() =>
      _OpportunityListScreenState();
}

class _OpportunityListScreenState
    extends State<OpportunityListScreen> {
  bool isLoading = true;
  bool hasError = false;

  List opportunities = [];

  // UIUX-014
  List<String> selectedLocations = [];

  // UIUX-009
  DateTime? lastUpdated;
=======
// =============================================================================
// PARAMETER CONTRACT
// =============================================================================
// opportunities   List<Opportunity>  required  Injected by INT-003 (mock default provided)
// onRefresh       Future<void> Function()  required  Injected by INT-003 for pull-to-refresh
// =============================================================================

import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/skill_chip.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_detail_screen.dart';

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// MOCK DATA
// ---------------------------------------------------------------------------
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
  Opportunity(
    id: '3',
    title: 'Digital Marketing Assistant',
    company: 'Digital Growth Hub',
    companyIndustry: 'Marketing',
    location: 'Remote (SA-based)',
    jobType: 'Full-time',
    skills: ['SEO', 'Social Media', 'Content Creation', 'Google Ads', 'Canva'],
    closingDate: '20 Jul 2026',
    positions: 4,
    salaryRange: 'R15,000 – R20,000',
    isOpen: true,
    description: 'Digital Growth Hub seeks a creative Digital Marketing Assistant.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Digital Marketing Fundamentals', duration: '2 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'D',
    logoColor: const Color(0xFFEA580C),
  ),
  Opportunity(
    id: '4',
    title: 'Data Analyst Trainee',
    company: 'Innovate SA',
    companyIndustry: 'Technology',
    location: 'Durban',
    jobType: 'Learnership',
    skills: ['Python', 'SQL', 'Power BI', 'Excel', 'Statistics'],
    closingDate: '01 Aug 2026',
    positions: 8,
    salaryRange: 'R14,000',
    isOpen: true,
    description: 'Innovate SA offers a structured Learnership for aspiring Data Analysts.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Data Analytics with Python', duration: '4 months', level: 'Intermediate', isOpen: true),
    ],
    logoInitials: 'I',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '5',
    title: 'Front-End Developer (React)',
    company: 'Innovate SA',
    companyIndustry: 'Technology',
    location: 'Cape Town',
    jobType: 'Contract',
    skills: ['React', 'TypeScript', 'Tailwind CSS', 'GraphQL', 'Git'],
    closingDate: '10 Jul 2026',
    positions: 2,
    salaryRange: 'R350 – R500/hr',
    isOpen: true,
    description: 'Innovate SA needs a skilled Front-End Developer on a contract basis.',
    relatedProgrammes: [
      RelatedProgramme(title: 'React & Modern JS', duration: '3 months', level: 'Intermediate', isOpen: true),
    ],
    logoInitials: 'I',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '6',
    title: 'Social Media Coordinator',
    company: 'Digital Growth Hub',
    companyIndustry: 'Marketing',
    location: 'Remote (SA-based)',
    jobType: 'Part-time',
    skills: ['Social Media', 'Content Creation', 'Canva', 'Analytics', 'Copywriting'],
    closingDate: '05 Jul 2026',
    positions: 3,
    salaryRange: 'R8,000',
    isOpen: true,
    description: 'Digital Growth Hub is hiring a Social Media Coordinator.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Social Media Management', duration: '1 month', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'D',
    logoColor: const Color(0xFFEA580C),
  ),
  Opportunity(
    id: '7',
    title: 'IT Support Technician',
    company: 'TechNova Solutions',
    companyIndustry: 'Technology',
    location: 'Johannesburg',
    jobType: 'Full-time',
    skills: ['Windows Server', 'Networking', 'Help Desk', 'Active Directory', 'CompTIA'],
    closingDate: '15 Aug 2026',
    positions: 5,
    salaryRange: 'R14,000 – R18,000',
    isOpen: true,
    description: 'TechNova Solutions seeks an IT Support Technician.',
    relatedProgrammes: [
      RelatedProgramme(title: 'CompTIA A+ Prep', duration: '2 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'T',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '8',
    title: 'Business Development Intern',
    company: 'FutureTech Africa',
    companyIndustry: 'Business',
    location: 'Pretoria, SA (Hybrid)',
    jobType: 'Internship',
    skills: ['Sales', 'CRM', 'Communication', 'Market Research', 'Microsoft Office'],
    closingDate: '25 Jul 2026',
    positions: 2,
    salaryRange: 'R10,000',
    isOpen: true,
    duration: '6 months',
    description: 'FutureTech Africa\'s Business Development team is looking for an energetic intern.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Salesforce Administration', duration: '3 months', level: 'Beginner', isOpen: true),
      RelatedProgramme(title: 'Financial Literacy & FinTech', duration: '2 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'F',
    logoColor: const Color(0xFF7C3AED),
  ),
  Opportunity(
    id: '9',
    title: 'Cloud Support Engineer',
    company: 'TechNova Solutions',
    companyIndustry: 'Technology',
    location: 'Cape Town',
    jobType: 'Full-time',
    skills: ['AWS', 'Linux', 'Terraform', 'Docker', 'Networking'],
    closingDate: '01 Sep 2026',
    positions: 4,
    salaryRange: 'R22,000 – R30,000',
    isOpen: true,
    description: 'TechNova Solutions is expanding its Cloud team.',
    relatedProgrammes: [
      RelatedProgramme(title: 'AWS Cloud Practitioner', duration: '3 months', level: 'Intermediate', isOpen: true),
    ],
    logoInitials: 'T',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '10',
    title: 'UX Designer (Junior)',
    company: 'Digital Growth Hub',
    companyIndustry: 'Design',
    location: 'Cape Town',
    jobType: 'Full-time',
    skills: ['Figma', 'User Research', 'Prototyping', 'Wireframing', 'Design Systems'],
    closingDate: '10 Aug 2026',
    positions: 2,
    salaryRange: 'R18,000 – R24,000',
    isOpen: true,
    description: 'Digital Growth Hub is looking for a Junior UX Designer.',
    relatedProgrammes: [
      RelatedProgramme(title: 'UX Design Fundamentals', duration: '2 months', level: 'Beginner', isOpen: true),
    ],
    logoInitials: 'D',
    logoColor: const Color(0xFFEA580C),
  ),
  Opportunity(
    id: '11',
    title: 'Cybersecurity Analyst Trainee',
    company: 'Innovate SA',
    companyIndustry: 'Technology',
    location: 'Johannesburg',
    jobType: 'Learnership',
    skills: ['Network Security', 'Ethical Hacking', 'Linux', 'SIEM', 'CompTIA Security+'],
    closingDate: '15 Oct 2026',
    positions: 6,
    salaryRange: 'R15,000',
    isOpen: true,
    description: 'Innovate SA\'s Cybersecurity Learnership is a 12-month programme.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Ethical Hacking Bootcamp', duration: '4 months', level: 'Intermediate', isOpen: true),
    ],
    logoInitials: 'I',
    logoColor: AppTheme.accent,
  ),
  Opportunity(
    id: '12',
    title: 'Financial Data Analyst',
    company: 'FutureTech Africa',
    companyIndustry: 'Finance',
    location: 'Sandton',
    jobType: 'Full-time',
    skills: ['Excel', 'SQL', 'Power BI', 'Financial Modelling', 'Python'],
    closingDate: '20 Aug 2026',
    positions: 3,
    salaryRange: 'R20,000 – R28,000',
    isOpen: true,
    description: 'FutureTech Africa\'s Finance division needs a Financial Data Analyst.',
    relatedProgrammes: [
      RelatedProgramme(title: 'Financial Literacy & FinTech', duration: '2 months', level: 'Beginner', isOpen: true),
      RelatedProgramme(title: 'Data Analytics with Python', duration: '4 months', level: 'Intermediate', isOpen: true),
    ],
    logoInitials: 'F',
    logoColor: const Color(0xFF7C3AED),
  ),
];

// ---------------------------------------------------------------------------
// SORT OPTIONS
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// FILTER CONSTANTS
// ---------------------------------------------------------------------------
const List<String> _skillFilters = ['All', 'Flutter', 'Python', 'SQL', 'Salesforce', 'Digital Marketing'];
const List<String> _jobTypeFilters = ['All Types', 'Full-time', 'Part-time', 'Internship', 'Learnership'];
const List<String> _locationFilters = ['All Locations', 'Cape Town', 'Johannesburg', 'Durban', 'Remote'];

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------
class OpportunityListScreen extends StatefulWidget {
  final List<Opportunity> opportunities;
  final Future<void> Function()? onRefresh;

  const OpportunityListScreen({
    super.key,
    this.opportunities = const [],
    this.onRefresh,
  });

  @override
  State<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends State<OpportunityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSkill = 'All';
  String _selectedJobType = 'All Types';
  String _selectedLocation = 'All Locations';
  SortOption _sortOption = SortOption.mostRelevant;
>>>>>>> 8667def18c7b4a0bbd3c26f350566073c3c62a80

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    loadCachedOpportunities();
    loadOpportunities();
  }

  Future<void> loadCachedOpportunities() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('opportunities');

    if (cached != null) {
      setState(() {
        opportunities = List.from(
          jsonDecode(cached),
        );
      });
    }
  }

  Future<void> saveOpportunitiesToCache(
      List data,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'opportunities',
      jsonEncode(data),
    );
  }

  Future<void> loadOpportunities() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Replace with real service later
      final data = [];

      await saveOpportunitiesToCache(data);

      setState(() {
        opportunities = data;
        lastUpdated = DateTime.now();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  List get filteredOpportunities {
    return SearchFilterService
        .filterOpportunitiesByLocation(
      opportunities: opportunities,
      locations: selectedLocations,
    );
=======
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

    if (_selectedLocation != 'All Locations') {
      list = list.where((opportunity) =>
          opportunity.location.toLowerCase().contains(_selectedLocation.toLowerCase())).toList();
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
>>>>>>> 8667def18c7b4a0bbd3c26f350566073c3c62a80
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (isLoading) {
      return const Scaffold(
        body: LoadingOverlay(),
      );
    }

    if (hasError) {
      return Scaffold(
        body: ErrorMessage(
          message: "Failed to load opportunities",
          onRetry: loadOpportunities,
        ),
      );
    }

    if (opportunities.isEmpty) {
      return const Scaffold(
        body: EmptyState(
          message: "No opportunities found",
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Opportunities"),
      ),
      body: RefreshIndicator(
        onRefresh: loadOpportunities,
        child: Column(
          children: [
            if (lastUpdated != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Last updated ${DateTime.now().difference(lastUpdated!).inMinutes} minute(s) ago',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  "All Locations",
                  "Cape Town",
                  "Johannesburg",
                  "Durban",
                  "Remote",
                ].map((location) {
                  final isSelected =
                  selectedLocations.isEmpty
                      ? location ==
                      "All Locations"
                      : selectedLocations
                      .contains(location);

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: ChoiceChip(
                      label: Text(location),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          if (location ==
                              "All Locations") {
                            selectedLocations.clear();
                          } else {
                            if (selectedLocations
                                .contains(location)) {
                              selectedLocations
                                  .remove(location);
                            } else {
                              selectedLocations
                                  .add(location);
                            }
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            if (selectedLocations.isNotEmpty)
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        '${selectedLocations.length} filter(s) active',
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedLocations.clear();
                        });
                      },
                      child: const Text(
                        'Clear Filters',
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: ListView.builder(
                itemCount:
                filteredOpportunities.length,
                itemBuilder:
                    (context, index) {
                  final job =
                  filteredOpportunities[index];

                  return ListTile(
                    title: Text(
                      job["title"]
                          .toString(),
                    ),
                    subtitle: Text(
                      job["location"]
                          .toString(),
                    ),
                  );
                },
              ),
=======
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
              SliverToBoxAdapter(child: _buildJobTypeFilterRow()),
              SliverToBoxAdapter(child: _buildLocationFilterRow()),
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
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.textDark),
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

  Widget _buildJobTypeFilterRow() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _jobTypeFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final label = _jobTypeFilters[index];
          final selected = _selectedJobType == label;
          return GestureDetector(
            onTap: () => setState(() => _selectedJobType = label),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AppTheme.textDark : AppTheme.mutedText,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationFilterRow() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _locationFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _locationFilters[index];
          final selected = _selectedLocation == label;
          return _FilterChipItem(
            label: label,
            selected: selected,
            onTap: () => setState(() => _selectedLocation = label),
            outlined: true,
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

// ---------------------------------------------------------------------------
// FILTER CHIP ITEM
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// OPPORTUNITY CARD
// ---------------------------------------------------------------------------
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
    final opportunity = this.opportunity;
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
>>>>>>> 8667def18c7b4a0bbd3c26f350566073c3c62a80
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======
}

// ---------------------------------------------------------------------------
// PLACEHOLDER SCREEN
// ---------------------------------------------------------------------------
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
>>>>>>> 8667def18c7b4a0bbd3c26f350566073c3c62a80
}