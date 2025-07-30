// icon_selector_view.dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/palette.dart';
import 'icon_selector_viewmodel.dart';

class IconSelectorView extends StackedView<IconSelectorViewModel> {
  final Map<String, IconData> allIcons;
  final Function(String) onIconSelected;

  const IconSelectorView({
    super.key,
    required this.allIcons,
    required this.onIconSelected,
  });

  @override
  Widget builder(
      BuildContext context, IconSelectorViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildAppBar(viewModel),
          ),
          _buildSearchField(viewModel),
          if (!viewModel.showingEmoji)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: viewModel.categories.entries
                      .map((entry) => _buildCategorySection(
                          entry.key, entry.value, viewModel))
                      .toList(),
                ),
              ),
            ),
          if (viewModel.searchQuery.isNotEmpty || viewModel.showingEmoji)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: viewModel.filteredIcons.length,
                  itemBuilder: (context, index) {
                    final entry =
                        viewModel.filteredIcons.entries.elementAt(index);
                    return GestureDetector(
                      onTap: () => onIconSelected(entry.key),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(entry.value, size: 24, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(IconSelectorViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Palette.whiteCultured),
            onPressed: () => viewModel.goBack(),
          ),
          const SizedBox(width: 30),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggle(viewModel, true, 'Icon'),
                _buildToggle(viewModel, false, 'Emoji'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
      IconSelectorViewModel viewModel, bool isEmoji, String label) {
    final isSelected = viewModel.showingEmoji == isEmoji;
    return GestureDetector(
      onTap: () => viewModel.toggleBtn(isEmoji),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A3A3C) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(IconSelectorViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: viewModel.searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Type a search term',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF2C2C2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      String title, List<String> iconNames, IconSelectorViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: iconNames.length,
            itemBuilder: (context, index) {
              final iconName = iconNames[index];
              final iconData = allIcons[iconName];
              if (iconData == null) return const SizedBox.shrink();

              return GestureDetector(
                onTap: () => onIconSelected(iconName),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconData,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  IconSelectorViewModel viewModelBuilder(BuildContext context) =>
      IconSelectorViewModel(
        allIcons: allIcons,
        onIconSelected: onIconSelected,
      );

  @override
  void onViewModelReady(IconSelectorViewModel viewModel) =>
      viewModel.initialize();
}
