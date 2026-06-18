import 'package:flutter/material.dart';

import '../../services/sheets_service.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/notification_badge.dart';

class ProgrammeListScreen extends StatefulWidget {
  const ProgrammeListScreen({super.key});

  @override
  State<ProgrammeListScreen> createState() =>
      _ProgrammeListScreenState();
}

class _ProgrammeListScreenState
    extends State<ProgrammeListScreen> {
  bool isLoading = true;
  bool hasError = false;

  List programmes = [];
  DateTime? lastUpdated;

  final sheetsService = SheetsService();

  Future<void> loadProgrammes() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      programmes = await sheetsService.getProgrammes();
      lastUpdated = DateTime.now();

      setState(() {});
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProgrammes();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingOverlay(),
      );
    }

    if (hasError) {
      return Scaffold(
        body: ErrorMessage(
          message: "Failed to load programmes",
          onRetry: loadProgrammes,
        ),
      );
    }

    if (programmes.isEmpty) {
      return const Scaffold(
        body: EmptyState(
          message: "No programmes found",
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmes"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: NotificationBadge(iconColor: Colors.black),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadProgrammes,
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

            Expanded(
              child: ListView.builder(
                itemCount: programmes.length,
                itemBuilder: (context, index) {
                  final programme = programmes[index];

                  return ListTile(
                    title: Text(
                      programme["title"].toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}