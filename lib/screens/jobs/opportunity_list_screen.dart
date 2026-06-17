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

  @override
  void initState() {
    super.initState();
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
            ),
          ],
        ),
      ),
    );
  }
}