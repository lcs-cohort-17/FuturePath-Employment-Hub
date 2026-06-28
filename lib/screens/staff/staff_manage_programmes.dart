// TODO: Replace with final design (PO-UIUX-010)
// ✅ Uses StaffProgrammeModel with correct column names

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
              return Card(
                color: const Color(0xFF2C2E30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    programme.programmeName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Category: ${programme.category ?? 'N/A'} • Level: ${programme.level ?? 'N/A'} • Status: ${programme.programmeStatus}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}