import 'package:flutter/foundation.dart';

class SearchFilterProvider extends ChangeNotifier {
  List<String> selectedLocations = [];

  void toggleLocation(String location) {
    if (location == "All Locations") {
      selectedLocations.clear();
    } else {
      if (selectedLocations.contains(location)) {
        selectedLocations.remove(location);
      } else {
        selectedLocations.add(location);
      }
    }

    notifyListeners();
  }

  void clearFilters() {
    selectedLocations.clear();
    notifyListeners();
  }

  int get activeFilterCount {
    return selectedLocations.length;
  }
}