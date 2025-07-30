import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IconSelectorViewModel extends BaseViewModel {
  final Map<String, IconData> allIcons;
  final Function(String) onIconSelected;
  final TextEditingController searchController = TextEditingController();
  final _navigatorService = StackedService.navigatorKey!.currentState!;

  late Map<String, IconData> filteredIcons;
  String searchQuery = '';
  bool _showingEmoji = false;

  bool get showingEmoji => _showingEmoji;

  final Map<String, List<String>> categories = {
    'Activities': [
      'fitness_center',
      'directions_run',
      'pool',
      'sports_basketball',
      'sports_soccer',
      'sports_tennis',
      'sports_golf',
      'sports_baseball',
      'sports_football',
      'sports_hockey',
      'accessibility_new',
      'self_improvement',
    ],
    'Sports': [
      'directions_bike',
      'snowboarding',
      'surfing',
      'skateboarding',
      'rowing',
      'kayaking',
      'hiking',
      'downhill_skiing',
    ],
    'Food and Beverages': [
      'restaurant',
      'local_dining',
      'coffee',
      'wine_bar',
      'nightlife',
      'fastfood',
      'local_pizza',
      'cake',
    ],
  };

  IconSelectorViewModel({
    required this.allIcons,
    required this.onIconSelected,
  });

  void initialize() {
    filteredIcons = allIcons;
    searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterIcons() {
    searchQuery = searchController.text.toLowerCase();

    if (searchQuery.isEmpty) {
      filteredIcons = allIcons;
    } else {
      filteredIcons = Map.fromEntries(
        allIcons.entries.where(
          (entry) => entry.key.toLowerCase().contains(searchQuery),
        ),
      );
    }
    notifyListeners();
  }

  void toggleBtn(bool showEmoji) {
    _showingEmoji = showEmoji;
    notifyListeners();
  }

  void selectIcon(String iconName) {
    onIconSelected(iconName);
  }

  void goBack() {
    _navigatorService.pop();
  }

  void setShowingEmoji(bool value) {
    _showingEmoji = true;
    notifyListeners();
  }
}
