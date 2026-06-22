import 'package:flutter/material.dart';

import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../services/search_filter_service.dart';
import '../../services/sheets_service.dart';


class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState
    extends State<SearchResultsScreen> {
  final TextEditingController searchController =
  TextEditingController();

  bool isLoading = false;
  bool hasError = false;

  List programmes = [];
  List opportunities = [];
  List results = [];

  final sheetsService = SheetsService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      programmes =
      await sheetsService.getProgrammes();

      opportunities =
      await sheetsService.getOpportunities();

      results = [
        ...programmes,
        ...opportunities,
      ];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void onSearch(String query) {
    setState(() {
      results = SearchFilterService.searchAll(
        query: query,
        programmes: programmes,
        opportunities: opportunities,
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          message: "Something went wrong",
          onRetry: loadData,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText:
                "Search programmes and jobs...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onSearch,
            ),
          ),

          Expanded(
            child: results.isEmpty
                ? const EmptyState(
              message:
              "No results found",
            )
                : ListView.builder(
              itemCount:
              results.length,
              itemBuilder:
                  (context, index) {
                final item =
                results[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      item["title"]
                          .toString(),
                    ),
                    trailing: Chip(
                      label: Text(
                        item["type"]
                            ?.toString() ??
                            "Item",
                      ),
                    ),
                    onTap: () {
                      // NAV-004 handles navigation
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}