import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'home_viewmodel.dart';
import '../../common/ui_helpers.dart';
import '../../common/widgets/custom_card.dart';
import '../../common/widgets/search_bar.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/view_mode_selector.dart';
import '../../common/widgets/measurement_grid_view.dart';
import '../../common/widgets/measurement_list_view.dart';
import '../../common/widgets/measurement_calendar_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(viewModel),
          body: SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: UIHelpers.screenPaddingHorizontal,
                  child: CustomSearchBar(
                    hintText: AppStrings.searchPlaceholder,
                    onChanged: viewModel.onSearchChanged,
                    onClear: viewModel.clearSearch,
                  ),
                ),
                UIHelpers.verticalSpaceMedium,

                // View Mode Selector
                Padding(
                  padding: UIHelpers.screenPaddingHorizontal,
                  child: ViewModeSelector(
                    currentMode: viewModel.currentViewMode,
                    onModeChanged: viewModel.changeViewMode,
                  ),
                ),
                UIHelpers.verticalSpaceMedium,

                // Content
                Expanded(
                  child: _buildContent(viewModel, sizingInformation),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFAB(viewModel),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(HomeViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.myMeasurements,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Text(
            AppStrings.keepTrackSizes,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: viewModel.onMenuItemSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, size: 20),
                  SizedBox(width: 12),
                  Text('Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 12),
                  Text('Sign Out'),
                ],
              ),
            ),
          ],
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              viewModel.userInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        UIHelpers.horizontalSpaceMedium,
      ],
    );
  }

  Widget _buildContent(HomeViewModel viewModel, SizingInformation sizingInformation) {
    if (viewModel.isBusy) {
      return const Center(
        child: LoadingIndicator(message: 'Loading measurements...'),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            UIHelpers.verticalSpaceMedium,
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            UIHelpers.verticalSpaceSmall,
            Text(
              viewModel.modelError.toString(),
              style: const TextStyle(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelpers.verticalSpaceLarge,
            ElevatedButton(
              onPressed: viewModel.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.filteredMeasurements.isEmpty) {
      return UIHelpers.buildEmptyState(
        title: viewModel.isSearching
            ? AppStrings.noMeasurementsFound
            : AppStrings.addFirstMeasurement,
        subtitle: viewModel.isSearching
            ? 'Try adjusting your search terms'
            : 'Tap the + button to add your first measurement',
        icon: viewModel.isSearching ? Icons.search_off : Icons.straighten,
        action: viewModel.isSearching ? null : ElevatedButton.icon(
          onPressed: viewModel.navigateToAddMeasurement,
          icon: const Icon(Icons.add),
          label: const Text('Add Measurement'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: UIHelpers.defaultBorderRadius,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: _buildMeasurementsView(viewModel, sizingInformation),
    );
  }

  Widget _buildMeasurementsView(HomeViewModel viewModel, SizingInformation sizingInformation) {
    switch (viewModel.currentViewMode) {
      case ViewMode.grid:
        return _buildGridView(viewModel, sizingInformation);
      case ViewMode.list:
        return MeasurementListView(
          measurements: viewModel.filteredMeasurements,
          onTap: viewModel.navigateToMeasurementDetail,
          onLongPress: viewModel.showMeasurementOptions,
        );
      case ViewMode.calendar:
        return MeasurementCalendarView(
          measurements: viewModel.filteredMeasurements,
          onTap: viewModel.navigateToMeasurementDetail,
        );
    }
  }

  Widget _buildGridView(HomeViewModel viewModel, SizingInformation sizingInformation) {
    final isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
    final crossAxisCount = isTablet ? 2 : 1;

    if (crossAxisCount == 1) {
      // Single column for mobile
      return ListView.builder(
        padding: UIHelpers.screenPaddingHorizontal,
        itemCount: viewModel.filteredMeasurements.length,
        itemBuilder: (context, index) {
          final entry = viewModel.filteredMeasurements[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.padding),
            child: CustomCard(
              entry: entry,
              onTap: () => viewModel.navigateToMeasurementDetail(entry),
              onLongPress: () => viewModel.showMeasurementOptions(entry),
            ),
          );
        },
      );
    }

    // Grid for tablet
    return GridView.builder(
      padding: UIHelpers.screenPaddingHorizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.padding,
        mainAxisSpacing: AppSizes.padding,
        childAspectRatio: 1.2,
      ),
      itemCount: viewModel.filteredMeasurements.length,
      itemBuilder: (context, index) {
        final entry = viewModel.filteredMeasurements[index];
        return CustomCard(
          entry: entry,
          onTap: () => viewModel.navigateToMeasurementDetail(entry),
          onLongPress: () => viewModel.showMeasurementOptions(entry),
        );
      },
    );
  }

  Widget _buildFAB(HomeViewModel viewModel) {
    return FloatingActionButton(
      onPressed: viewModel.navigateToAddMeasurement,
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialize();
}