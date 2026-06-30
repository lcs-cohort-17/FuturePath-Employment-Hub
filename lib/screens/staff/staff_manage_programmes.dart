// TODO: Replace with final design (PO-UIUX-010)
// ✅ Uses StaffProgrammeModel with correct column names
// ✅ Progress bar added (shows enrolled / capacity)

import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../services/staff_content_service.dart';
import '../../models/staff_programme_model.dart';
import '../../router/app_router.dart';

class StaffManageProgrammes extends StatefulWidget {
  const StaffManageProgrammes({super.key});

  @override
  State<StaffManageProgrammes> createState() => _StaffManageProgrammesState();
}

class _StaffManageProgrammesState extends State<StaffManageProgrammes> {
  late Future<List<StaffProgrammeModel>> _programmesFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProgrammes();
  }

  void _loadProgrammes() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _programmesFuture = StaffContentService.getMyProgrammes(userId);
      });
    }
  }

  Future<void> _deleteProgramme(String programmeId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Programme'),
        content: const Text('Are you sure you want to delete this programme?'),
        backgroundColor: const Color(0xFF2C2E30),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await StaffContentService.deleteProgramme(programmeId);
              _loadProgrammes();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Manage Programmes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.staffAddProgramme).then((_) => _loadProgrammes());
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadProgrammes,
          ),
        ],
      ),
      body: FutureBuilder<List<StaffProgrammeModel>>(
        future: _programmesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final programmes = snapshot.data ?? [];
          if (programmes.isEmpty) {
            return const Center(
              child: Text(
                'No programmes yet. Tap + to add one.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: programmes.length,
            itemBuilder: (context, index) {
              final programme = programmes[index];

              // Calculate progress percentage
              final int enrolled = programme.enrolledCount ?? 0;
              final int capacity = programme.capacity ?? 0;
              final double progress = capacity > 0 ? enrolled / capacity : 0.0;
              final int percent = capacity > 0 ? (progress * 100).round() : 0;

              return Card(
                color: const Color(0xFF2C2E30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Programme Name
                      Text(
                        programme.programmeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Category, Level, Status
                      Text(
                        'Category: ${programme.category ?? 'N/A'} • Level: ${programme.level ?? 'N/A'} • Status: ${programme.programmeStatus}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // =====================
                      // ✅ PROGRESS BAR (from friend's code)
                      // =====================
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Progress bar track
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor: progress.clamp(0.0, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE03A2F),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Enrolled / Capacity text
                                Text(
                                  '$enrolled / $capacity enrolled',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Progress percentage
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              '$percent%',
                              style: const TextStyle(
                                color: Color(0xFFE03A2F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Edit & Delete buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.staffEditProgramme,
                                arguments: programme,
                              ).then((_) => _loadProgrammes());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProgramme(programme.programmeId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}