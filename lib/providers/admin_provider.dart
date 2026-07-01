import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;
  String? _error;

  // Dashboard data
  int? _totalUsers;
  int? _newUsersToday;
  int? _activeJobs;
  int? _activeProgrammes;
  int? _totalApplications;
  int? _activeEmployers;

  // Activity log
  List<Map<String, dynamic>> _activityLog = [];

  // Performance data
  List<Map<String, dynamic>> _topJobs = [];
  List<Map<String, dynamic>> _topProgrammes = [];

  // Staff management
  List<Map<String, dynamic>> _staff = [];
  int _pendingCount = 0;

  // System settings
  String? _deployInfo;
  String? _restApiResponse;
  String? _authApiResponse;
  String? _edgeFunctionAvg;
  String? _activeConnections;
  String? _dbSize;
  String? _storageUsed;
  String? _edgeFunctionsStatus;
  String? _supabaseStatus;
  String? _flutterSdk;
  String? _buildNumber;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Dashboard getters
  int? get totalUsers => _totalUsers;
  int? get newUsersToday => _newUsersToday;
  int? get activeJobs => _activeJobs;
  int? get activeProgrammes => _activeProgrammes;
  int? get totalApplications => _totalApplications;
  int? get activeEmployers => _activeEmployers;

  // Activity log getter
  List<Map<String, dynamic>> get activityLog => _activityLog;

  // Performance getters
  List<Map<String, dynamic>> get topJobs => _topJobs;
  List<Map<String, dynamic>> get topProgrammes => _topProgrammes;

  // Staff getters
  List<Map<String, dynamic>> get staff => _staff;
  int get pendingCount => _pendingCount;

  // System settings getters
  String? get deployInfo => _deployInfo;
  String? get restApiResponse => _restApiResponse;
  String? get authApiResponse => _authApiResponse;
  String? get edgeFunctionAvg => _edgeFunctionAvg;
  String? get activeConnections => _activeConnections;
  String? get dbSize => _dbSize;
  String? get storageUsed => _storageUsed;
  String? get edgeFunctionsStatus => _edgeFunctionsStatus;
  String? get supabaseStatus => _supabaseStatus;
  String? get flutterSdk => _flutterSdk;
  String? get buildNumber => _buildNumber;

  // ===== DASHBOARD =====
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _totalUsers = 1284;
      _newUsersToday = 23;
      _activeJobs = 48;
      _activeProgrammes = 12;
      _totalApplications = 847;
      _activeEmployers = 9;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard data';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== ACTIVITY LOG =====
  Future<void> loadActivityLog() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _activityLog = [
        {
          'icon': Icons.file_copy,
          'iconColor': const Color(0xFF2ECC8A),
          'title': 'Application submitted',
          'subtitle': 'Junior Flutter Developer · TechNova',
          'time': 'Just now',
        },
        {
          'icon': Icons.book,
          'iconColor': const Color(0xFF4A9EE8),
          'title': 'Programme enrollment',
          'subtitle': 'Salesforce Admin Bootcamp · 1 new learner',
          'time': '4 min ago',
        },
        {
          'icon': Icons.person_add,
          'iconColor': const Color(0xFFF5A623),
          'title': 'Staff registration: John Smith',
          'subtitle': 'Microsoft SA · Pending approval',
          'time': '1 hour ago',
        },
        {
          'icon': Icons.check_circle,
          'iconColor': const Color(0xFF2ECC8A),
          'title': 'Staff approved: Thabo Nkosi',
          'subtitle': 'Amazon SA account activated',
          'time': '2 hours ago',
        },
        {
          'icon': Icons.file_copy,
          'iconColor': const Color(0xFF4A9EE8),
          'title': '5 applications submitted',
          'subtitle': 'Data Analyst Trainee · Innovate SA',
          'time': '3 hours ago',
        },
        {
          'icon': Icons.cancel,
          'iconColor': const Color(0xFFE03A2F),
          'title': 'Staff rejected',
          'subtitle': 'Unverified company account suspended',
          'time': 'Yesterday',
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load activity log';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> filteredActivityLog(String filter) {
    if (filter == 'All') return _activityLog;

    return _activityLog.where((log) {
      final title = log['title'] as String? ?? '';
      return title.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  // ===== PERFORMANCE =====
  Future<void> loadPerformanceData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _topJobs = [
        {'title': 'Junior Flutter Developer', 'company': 'TechNova', 'percentage': 92},
        {'title': 'Data Analyst Trainee', 'company': 'Innovate SA', 'percentage': 78},
        {'title': 'Digital Marketing Assistant', 'company': 'DGH', 'percentage': 65},
        {'title': 'Cloud Support Engineer', 'company': 'Amazon SA', 'percentage': 54},
        {'title': 'Salesforce Admin Intern', 'company': 'FutureTech', 'percentage': 41},
      ];

      _topProgrammes = [
        {'title': 'Flutter Mobile Development', 'percentage': 80},
        {'title': 'Digital Marketing Fundamentals', 'percentage': 95},
        {'title': 'Salesforce Administration', 'percentage': 80},
        {'title': 'Data Analytics Bootcamp', 'percentage': 55},
        {'title': 'Cloud Computing Essentials', 'percentage': 60},
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load performance data';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== STAFF MANAGEMENT =====
  Future<void> loadStaffData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _staff = [
        {
          'id': '1',
          'name': 'John Smith',
          'company': 'Microsoft SA',
          'email': 'j.smith@microsoft.com',
          'status': 'Pending',
          'registeredAt': 'Registered today',
        },
        {
          'id': '2',
          'name': 'Lerato Molefe',
          'company': 'Shoprite Group',
          'email': 'l.molefe@shoprite.co.za',
          'status': 'Pending',
          'registeredAt': 'Yesterday',
        },
        {
          'id': '3',
          'name': 'Thabo Nkosi',
          'company': 'Amazon SA',
          'email': 't.nkosi@amazon.com',
          'status': 'Active',
          'registeredAt': 'Last login: today',
        },
        {
          'id': '4',
          'name': 'Naledi Dube',
          'company': 'FutureTech Africa',
          'email': 'n.dube@futuretech.co.za',
          'status': 'Active',
          'registeredAt': '2 days ago',
        },
        {
          'id': '5',
          'name': 'Unknown Account',
          'company': 'Unverified',
          'email': 'fake@notreal.io',
          'status': 'Suspended',
          'registeredAt': 'Rejected 3 days ago',
        },
      ];

      _pendingCount = _staff.where((s) => s['status'] == 'Pending').length;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load staff data';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> filteredStaff(String filter) {
    if (filter == 'All') return _staff;
    return _staff.where((s) => s['status'] == filter).toList();
  }

  Future<void> approveStaff(String id) async {
    final index = _staff.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      _staff[index]['status'] = 'Active';
      _pendingCount = _staff.where((s) => s['status'] == 'Pending').length;
      notifyListeners();
    }
  }

  Future<void> rejectStaff(String id) async {
    final index = _staff.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      _staff[index]['status'] = 'Suspended';
      _pendingCount = _staff.where((s) => s['status'] == 'Pending').length;
      notifyListeners();
    }
  }

  // ===== SYSTEM SETTINGS =====
  Future<void> loadSystemData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _deployInfo = 'Last deploy: Today 08:45 · v0.9.2-beta';
      _restApiResponse = '142ms';
      _authApiResponse = '89ms';
      _edgeFunctionAvg = '380ms';
      _activeConnections = '14/100';
      _dbSize = '18.4 MB';
      _storageUsed = '2.4 GB';
      _edgeFunctionsStatus = '1 degraded';
      _supabaseStatus = 'Operational';
      _flutterSdk = '3.22.0';
      _buildNumber = 'v0.9.2';

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load system data';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== PROFILE =====
  Future<void> loadProfileData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load profile data';
      _isLoading = false;
      notifyListeners();
    }
  }
}