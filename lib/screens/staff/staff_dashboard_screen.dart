import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
// import '../jobs/staff_manage_jobs_screen.dart';
// import '../programmes/staff_manage_programmes_screen.dart';
// import '../content/staff_content_screen.dart';
// import '../profile/staff_profile_screen.dart';
// import '../services/staff_service.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  int _currentNavIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  String _companyName = '';
  int _totalJobs = 0;
  int _activeJobs = 0;
  int _totalProgrammes = 0;
  int _activeProgrammes = 0;
  List<Map<String, dynamic>> _recentUploads = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Replace with the real INT-010 call, e.g.:
      // final data = await StaffService.instance.getDashboardSummary();

      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _companyName = 'FuturePath-Employment-Hub';
        _totalJobs = 8;
        _activeJobs = 5;
        _totalProgrammes = 4;
        _activeProgrammes = 3;
        _recentUploads = [
          {
            'avatar': 'AM',
            'avatarColor': AppColors.blueLow,
            'avatarTextColor': AppColors.blue,
            'title': 'Cloud Support Engineer',
            'company': 'Amazon SA · Cape Town',
            'tags': ['AWS', 'Linux', 'Terraform'],
            'meta': 'Added 2 days ago · 4 positions',
            'status': StatusType.active,
            'statusLabel': '● Active',
          },
          {
            'avatar': 'AM',
            'avatarColor': AppColors.blueLow,
            'avatarTextColor': AppColors.blue,
            'title': 'Business Development Intern',
            'company': 'Amazon SA · Pretoria',
            'tags': ['Sales', 'CRM'],
            'meta': 'Added 5 days ago · 2 positions',
            'status': StatusType.pending,
            'statusLabel': '● Draft',
          },
        ];
      });
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load dashboard. Pull down to retry.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateTo(String destination) {
    // Wire to real screens, e.g.:
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffManageJobsScreen()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $destination')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surf,
      body: SafeArea(
        child: _isLoading
            ? const Center(
            child: CircularProgressIndicator(color: AppColors.brand))
            : _errorMessage != null
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!,
                  style: const TextStyle(color: AppColors.t2)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDashboardData,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand),
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.brand,
          backgroundColor: AppColors.surf2,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopbar(),
                _buildGreeting(),
                const SizedBox(height: 10),
                _buildStatGrid(),
                _buildSectionHeader('Quick Actions'),
                _buildQuickActionsGrid(),
                _buildSectionHeader('Recent Uploads',
                    trailing: 'Manage ›'),
                ..._recentUploads.map(_buildJobCard),
                _buildPrivacyNotice(),
                const SizedBox(height: 70), // clearance for bottom nav
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // topbar() equivalent
  Widget _buildTopbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.surf,
        border: Border(bottom: BorderSide(color: AppColors.bdr, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FP',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Staff Portal',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.t1),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none,
                  color: AppColors.t2, size: 20),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: AppColors.brand,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '2',
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome back',
              style: TextStyle(fontSize: 11, color: AppColors.t2)),
          Row(
            children: [
              Text(
                _companyName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.t1),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.blueLow,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'STAFF',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // .stats2 / .scard equivalent
  Widget _buildStatGrid() {
    final stats = [
      {'n': '$_totalJobs', 'l': 'Total Jobs', 'color': AppColors.t1},
      {'n': '$_activeJobs', 'l': 'Active Jobs', 'color': AppColors.green},
      {'n': '$_totalProgrammes', 'l': 'Total Programmes', 'color': AppColors.t1},
      {'n': '$_activeProgrammes', 'l': 'Active Programmes', 'color': AppColors.brand},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.9,
        children: stats.map((s) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surf2,
              border: Border.all(color: AppColors.bdr, width: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.cardSm),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s['n'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: s['color'] as Color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s['l'] as String,
                  style: const TextStyle(fontSize: 10, color: AppColors.t2),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // .sec-h equivalent
  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.t1),
              ),
            ],
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(fontSize: 11, color: AppColors.brand),
            ),
        ],
      ),
    );
  }

  // .action-row / .acard equivalent
  Widget _buildQuickActionsGrid() {
    final actions = [
      {
        'icon': Icons.add,
        'color': AppColors.brand,
        'label': 'Add Job',
        'sub': 'Post a new vacancy',
        'dest': 'Manage Jobs',
      },
      {
        'icon': Icons.upload_file_outlined,
        'color': AppColors.blue,
        'label': 'Add Programme',
        'sub': 'Create training',
        'dest': 'Manage Programmes',
      },
      {
        'icon': Icons.bar_chart_outlined,
        'color': AppColors.green,
        'label': 'View Analytics',
        'sub': 'Aggregated only',
        'dest': 'Staff Content',
      },
      {
        'icon': Icons.description_outlined,
        'color': AppColors.amber,
        'label': 'My Activity',
        'sub': 'Your action log',
        'dest': 'Staff Content',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
        children: actions.map((a) {
          return InkWell(
            onTap: () => _navigateTo(a['dest'] as String),
            borderRadius: BorderRadius.circular(AppRadii.cardSm),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surf2,
                border: Border.all(color: AppColors.bdr, width: 0.5),
                borderRadius: BorderRadius.circular(AppRadii.cardSm),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    a['label'] as String,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.t1),
                  ),
                  Text(
                    a['sub'] as String,
                    style: const TextStyle(fontSize: 10, color: AppColors.t2),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // jcard() equivalent
  Widget _buildJobCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surf2,
        border: Border.all(color: AppColors.bdr, width: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item['avatarColor'] as Color,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  item['avatar'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: item['avatarTextColor'] as Color,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.t1),
                    ),
                    Text(
                      item['company'] as String,
                      style: const TextStyle(fontSize: 10, color: AppColors.t2),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: item['statusLabel'] as String,
                type: item['status'] as StatusType,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: (item['tags'] as List<String>).map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: AppColors.bdr, width: 0.5),
                  borderRadius: BorderRadius.circular(AppRadii.tag),
                ),
                child: Text(
                  t,
                  style: const TextStyle(fontSize: 9, color: AppColors.t2),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.access_time, size: 11, color: AppColors.t3),
              const SizedBox(width: 4),
              Text(
                item['meta'] as String,
                style: const TextStyle(fontSize: 9, color: AppColors.t3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.bdr, width: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, size: 12, color: AppColors.t3),
          SizedBox(width: 5),
          Text(
            'Applicant personal data is never visible to staff',
            style: TextStyle(fontSize: 10, color: AppColors.t3),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.work_outline, 'label': 'Jobs'},
      {'icon': Icons.menu_book_outlined, 'label': 'Programmes'},
      {'icon': Icons.upload_outlined, 'label': 'Content'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surf,
        border: Border(top: BorderSide(color: AppColors.bdr, width: 0.5)),
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isActive = i == _currentNavIndex;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _currentNavIndex = i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 18,
                    color: isActive ? AppColors.brand : AppColors.t3,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 8,
                      color: isActive ? AppColors.brand : AppColors.t3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
