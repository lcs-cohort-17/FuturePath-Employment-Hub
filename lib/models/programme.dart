class Programme {
  final String id;
  final String title;
  final String provider;
  final String category;
  final String level;
  final String status;
  final String description;
  final String startDate;
  final String endDate;
  final String duration;
  final int enrolledCount;
  final int capacity;
  final List<String> skills;
  final String careerOpportunities;
  final String imageUrl;

  // Progress tracking fields (used in UserProfile)
  final double progress;
  final bool isCompleted;
  final String? certificateUrl;

  const Programme({
    required this.id,
    this.title = '',
    this.provider = '',
    this.category = '',
    this.level = '',
    this.status = '',
    this.description = '',
    this.startDate = '',
    this.endDate = '',
    this.duration = '',
    this.enrolledCount = 0,
    this.capacity = 0,
    this.skills = const [],
    this.careerOpportunities = '',
    this.imageUrl = '',
    this.progress = 0.0,
    this.isCompleted = false,
    this.certificateUrl,
  });

  // Added alias for compatibility with code using .name
  String get name => title;

  int get spotsRemaining => capacity - enrolledCount;

  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      provider: json['provider'] ?? '',
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      duration: json['duration'] ?? '',
      enrolledCount: json['enrolledCount'] ?? 0,
      capacity: json['capacity'] ?? 0,
      skills: List<String>.from(json['skills'] ?? []),
      careerOpportunities: json['careerOpportunities'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      isCompleted: json['isCompleted'] ?? false,
      certificateUrl: json['certificateUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': title, // for compatibility
      'provider': provider,
      'category': category,
      'level': level,
      'status': status,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
      'enrolledCount': enrolledCount,
      'capacity': capacity,
      'skills': skills,
      'careerOpportunities': careerOpportunities,
      'imageUrl': imageUrl,
      'progress': progress,
      'isCompleted': isCompleted,
      'certificateUrl': certificateUrl,
    };
  }
}

// ───────────────────────────────────────────────────────────────────────
// MOCK DATA — demo/QA default only. Replace via constructor parameter
// once INT-003 PublicDataService.fetchProgrammes() is available.
// ───────────────────────────────────────────────────────────────────────
const List<Programme> mockProgrammes = [
  Programme(
    id: 'prog_001',
    title: 'Flutter Mobile Development',
    provider: 'TechNova Solutions',
    category: 'Technology',
    level: 'Beginner-Intermediate',
    status: 'Open',
    description:
    'Build cross-platform mobile apps using Flutter & Dart for iOS and Android.',
    startDate: '01 Jul 2026',
    endDate: '01 Oct 2026',
    duration: '3 months',
    enrolledCount: 24,
    capacity: 30,
    skills: ['Flutter', 'Dart', 'Mobile UI', 'State Management'],
    careerOpportunities:
    'Completing this programme can qualify you for roles such as mobile developer and app engineer.',
    imageUrl: 'assets/images/programmes/flutter_mobile.jpg',
  ),

  Programme(
    id: 'prog_002',
    title: 'Salesforce Administration',
    provider: 'FutureTech Africa',
    category: 'Business',
    level: 'Beginner',
    status: 'Open',
    description:
    "This 3-month programme covers user management, security configuration, data management, automation with Flow Builder, reports and dashboards, and AppExchange integration. You'll sit the official Salesforce Certified Administrator (SCA) exam at the end, fully sponsored by FutureTech Africa. Our graduates have a 94% pass rate. Real-world scenarios from live Salesforce orgs are used throughout.",
    startDate: '15 Jul 2026',
    endDate: '15 Oct 2026',
    duration: '3 months',
    enrolledCount: 20,
    capacity: 25,
    skills: [
      'Salesforce',
      'CRM',
      'Data Management',
      'Automation',
      'Reports & Dashboards',
      'Admin',
    ],
    careerOpportunities:
    'Completing this programme can qualify you for roles in business such as developer positions, analyst roles, and more. Browse our opportunities to see relevant jobs.',
    imageUrl: 'assets/images/programmes/salesforce_admin.jpg',
  ),
  Programme(
    id: 'prog_003',
    title: 'Digital Marketing Fundamentals',
    provider: 'GrowthLab Academy',
    category: 'Marketing',
    level: 'Beginner',
    status: 'Open',
    description:
    'Learn SEO, social media marketing, content strategy and paid advertising fundamentals.',
    startDate: '10 Jul 2026',
    endDate: '10 Sep 2026',
    duration: '2 months',
    enrolledCount: 18,
    capacity: 20,
    skills: ['SEO', 'Social Media', 'Content Strategy', 'Google Ads'],
    careerOpportunities:
    'Completing this programme can qualify you for roles such as marketing assistant and social media coordinator.',
    imageUrl: 'assets/images/programmes/digital_marketing.jpg',
  ),
];
