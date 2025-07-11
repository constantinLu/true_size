import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'measurement_detail_viewmodel.dart';
import '../../common/ui_helpers.dart';
import '../../common/widgets/measurement_tag.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';

class MeasurementDetailView extends StackedView<MeasurementDetailViewModel> {
  final String measurementId;

  const MeasurementDetailView({Key? key, required this.measurementId}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      MeasurementDetailViewModel viewModel,
      Widget? child,
      ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(viewModel),
          body: SafeArea(
            child: _buildBody(viewModel),
          ),
          floatingActionButton: _buildEditFAB(viewModel),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(MeasurementDetailViewModel viewModel) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: viewModel.navigateBack,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        viewModel.measurement?.title ?? '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: viewModel.onMenuItemSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 12),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 12),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(MeasurementDetailViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(
        child: LoadingIndicator(message: 'Loading measurement...'),
      );
    }

    if (viewModel.hasError || viewModel.measurement == null) {
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
              'Failed to load measurement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
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

    return SingleChildScrollView(
      padding: UIHelpers.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildMeasurementsSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildAdditionalInfoSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildTagsSection(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(MeasurementDetailViewModel viewModel) {
    final measurement = viewModel.measurement!;

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: UIHelpers.getCategoryColor(measurement.category),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Center(
            child: Text(
              measurement.icon,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        UIHelpers.horizontalSpaceLarge,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                measurement.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              UIHelpers.verticalSpaceSmall,
              Text(
                '${measurement.measurements.length} measurements',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              UIHelpers.verticalSpaceSmall,
              Text(
                'Updated ${viewModel.getRelativeTime(measurement.updatedAt)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsSection(MeasurementDetailViewModel viewModel) {
    final measurements = viewModel.measurement!.measurements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.measurementsByBrand,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        Container(
          padding: const EdgeInsets.all(AppSizes.padding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: UIHelpers.defaultBorderRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: measurements.asMap().entries.map((entry) {
              final index = entry.key;
              final measurement = entry.value;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: index < measurements.length - 1
                      ? const Border(bottom: BorderSide(color: AppColors.borderLight))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            measurement.brand,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (measurement.notes != null) ...[
                            UIHelpers.verticalSpaceSmall,
                            Text(
                              measurement.notes!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      measurement.size,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(MeasurementDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.additionalInfo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        Container(
          padding: const EdgeInsets.all(AppSizes.padding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: UIHelpers.defaultBorderRadius,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              _buildInfoRow('Category', viewModel.measurement!.category),
              _buildInfoRow('Created', viewModel.getFormattedDate(viewModel.measurement!.createdAt)),
              _buildInfoRow('Last Updated', viewModel.getFormattedDate(viewModel.measurement!.updatedAt)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(MeasurementDetailViewModel viewModel) {
    final tags = viewModel.measurement!.tags;

    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.tags,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return MeasurementTag(tag: tag);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEditFAB(MeasurementDetailViewModel viewModel) {
    return FloatingActionButton(
      onPressed: viewModel.navigateToEdit,
      backgroundColor: AppColors.primary,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  @override
  MeasurementDetailViewModel viewModelBuilder(BuildContext context) =>
      MeasurementDetailViewModel(measurementId: measurementId);

  @override
  void onViewModelReady(MeasurementDetailViewModel viewModel) =>
      viewModel.initialize();
}