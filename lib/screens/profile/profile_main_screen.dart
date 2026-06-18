import 'dart:ui';
import 'package:flutter/material.dart';

// Mock SessionService providing the requested data dependencies
class SessionService {
  static Map<String, dynamic> getUserData() {
    return {
      'name': 'Sipho Dlamini',
      'email': 'sipho.dlamini@gmail.com',
      'qualification': 'National Senior Certificate (Matric)',
      'status': 'Unemployed',
      'id': '000101****083',
      'location': 'Cape Town, Western Cape',
      'bio': 'Motivated youth looking to build technical skills and launch a career in technology.'
    };
  }

  static List<String> getSkills() => ['Microsoft Office', 'Communication', 'Problem Solving', 'Teamwork'];

  static List<Map<String, dynamic>> getProgrammeHistory() => [
    {'title': 'Data Analytics Bootcamp', 'subtitle': 'Certificate Issued · Innovate SA', 'isCompleted': true},
    {'title': 'Flutter Mobile Development', 'subtitle': 'Starts 01 Jul', 'isCompleted': false},
    {'title': 'Digital Marketing Fundamentals', 'subtitle': 'Starts 01 Aug', 'isCompleted': false},
  ];
}

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  int activeTab = 0; // 0: Details, 1: Applications

  @override
  Widget build(BuildContext context) {
    final userData = SessionService.getUserData();
    final skills = SessionService.getSkills();
    final history = SessionService.getProgrammeHistory();

    const Color canvasColor = Color(0xFF050505);
    const Color accentColor = Color(0xFF2196F3);
    const Color subtitleColor = Color(0xFF9E9E9E);

    return Scaffold(
      backgroundColor: canvasColor,
      appBar: AppBar(
        backgroundColor: canvasColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF1565C0),
            child: Text('FP', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        title: const Text('FuturePath', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(onPressed: () {}, icon: const Badge(label: Text('4'), child: Icon(Icons.notifications_none, color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(userData, subtitleColor, accentColor),
            const SizedBox(height: 24),
            _buildTabSwitcher(),
            const SizedBox(height: 24),
            _buildPersonalInfo(userData, subtitleColor, accentColor),
            const SizedBox(height: 16),
            
            // 1. CV/Resume section container with navigation handler
            _buildCvNavigationSection(userData, skills, history, accentColor, subtitleColor),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> user, Color subColor, Color accent) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white60)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: accent, border: Border.all(color: accent.withOpacity(0.3), width: 2)),
                    alignment: Alignment.center,
                    child: const Text('SD', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF121212), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(user['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(user['qualification'], style: TextStyle(color: subColor, fontSize: 14)),
              Text(user['status'], style: TextStyle(color: subColor, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            _tabItem("Details", activeTab == 0, () => setState(() => activeTab = 0)),
            _tabItem("Applications", activeTab == 1, () => setState(() => activeTab = 1)),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: active ? const Color(0xFF30363D) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(Map<String, dynamic> user, Color subColor, Color accent) {
    return _sectionWrapper(
      title: "Personal Information",
      action: Row(children: [
        Icon(Icons.edit_outlined, size: 16, color: accent),
        const SizedBox(width: 4),
        Text("Edit Profile", style: TextStyle(color: accent, fontSize: 13)),
      ]),
      child: Column(
        children: [
          _infoRow("Qualification", user['qualification'], subColor),
          _infoRow("Employment Status", user['status'], subColor),
          _infoRow("Email", user['email'], subColor),
          _infoRow("ID Number", user['id'], subColor),
          _infoRow("Location", user['location'], subColor),
          _infoRow("Bio", user['bio'], subColor, isLast: true),
        ],
      ),
    );
  }

  Widget _buildCvNavigationSection(dynamic user, List<String> skills, List<dynamic> history, Color accent, Color sub) {
    return _sectionWrapper(
      title: "CV / Resume",
      titleIcon: Icons.upload_outlined,
      action: TextButton(
        onPressed: () => _navigateToCvDetail(user, skills, history),
        child: Text("Upload", style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
      ),
      child: Material(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _navigateToCvDetail(user, skills, history),
          borderRadius: BorderRadius.circular(12),
          hoverColor: accent.withOpacity(0.08),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CustomPaint(
              painter: DashedBorderPainter(color: accent.withOpacity(0.4)),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, color: accent, size: 28),
                  const SizedBox(height: 8),
                  Text("Upload your CV (PDF, DOC)", style: TextStyle(color: sub, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCvDetail(dynamic user, List<String> skills, List<dynamic> history) {
    // 1 & 4. Navigator.push using nested context to keep Bottom Nav visible
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CvDetailScreen(userData: user, skills: skills, programmeHistory: history),
      ),
    );
  }

  Widget _sectionWrapper({required String title, IconData? titleIcon, Widget? action, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (titleIcon != null) ...[Icon(titleIcon, color: const Color(0xFF2196F3), size: 18), const SizedBox(width: 8)],
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (action != null) action,
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, Color sub, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: sub, fontSize: 14))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, height: 1.4))),
        ],
      ),
    );
  }
}

// 2. Stylized sub-screen matching design criteria
class CvDetailScreen extends StatefulWidget {
  final dynamic userData;
  final List<String> skills;
  final List<dynamic> programmeHistory;

  const CvDetailScreen({super.key, required this.userData, required this.skills, required this.programmeHistory});

  @override
  State<CvDetailScreen> createState() => _CvDetailScreenState();
}

class _CvDetailScreenState extends State<CvDetailScreen> {
  String _simulatedFileName = "No file selected";

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFF2196F3);
    const Color sub = Color(0xFF9E9E9E);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        elevation: 0,
        // 4. Back button smoothly returns user to main Profile view
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("CV / Resume", style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Simulation Container
            Text("Upload", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(12)),
              child: CustomPaint(
                painter: DashedBorderPainter(color: accent.withOpacity(0.4)),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: accent, size: 32),
                    const SizedBox(height: 12),
                    Text(_simulatedFileName, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 24),
                    // 3. Simulated Upload Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _simulatedFileName = "my_cv_resume.pdf (Simulated Upload)";
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
                      child: const Text("Open File Explorer"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Skills Wrap
            Text("Skills", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: widget.skills.map((s) => _skillChip(s, accent)).toList(),
            ),
            const SizedBox(height: 32),
            // History Timeline
            Text("Programme History", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              children: widget.programmeHistory.map((h) => _historyCard(h)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillChip(String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(color: accent, fontSize: 13)),
    );
  }

  Widget _historyCard(dynamic item) {
    final bool done = item['isCompleted'] ?? false;
    final Color color = done ? Colors.green : Colors.blue;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(done ? Icons.workspace_premium : Icons.book_outlined, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(item['subtitle'], style: TextStyle(color: color, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color..strokeWidth = 1..style = PaintingStyle.stroke;
    const double dashWidth = 5, dashSpace = 3, radius = 12;
    final RRect rrect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(radius));
    final Path path = Path()..addRRect(rrect);
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
