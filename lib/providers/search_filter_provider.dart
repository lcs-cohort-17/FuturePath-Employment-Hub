import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilterState {
  final List<String> selectedLocations;

  SearchFilterState({
    this.selectedLocations = const [],
  });

  SearchFilterState copyWith({
    List<String>? selectedLocations,
  }) {
    return SearchFilterState(
      selectedLocations: selectedLocations ?? this.selectedLocations,
    );
  }

  int get activeFilterCount {
    return selectedLocations.length;
  }
}

class SearchFilterNotifier extends Notifier<SearchFilterState> {
  @override
  SearchFilterState build() {
    return SearchFilterState();
  }

  void toggleLocation(String location) {
    if (location == "All Locations") {
      state = state.copyWith(selectedLocations: []);
    } else {
      final currentLocations = List<String>.from(state.selectedLocations);
      if (currentLocations.contains(location)) {
        currentLocations.remove(location);
      } else {
        currentLocations.add(location);
      }
      state = state.copyWith(selectedLocations: currentLocations);
    }
  }

  void clearFilters() {
    state = SearchFilterState();
  }
}

final searchFilterProvider =
    NotifierProvider<SearchFilterNotifier, SearchFilterState>(() {
  return SearchFilterNotifier();
});
