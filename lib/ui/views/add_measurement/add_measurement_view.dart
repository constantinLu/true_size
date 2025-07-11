import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'add_measurement_viewmodel.dart';
import '../../common/ui_helpers.dart';
import '../../common/widgets/measurement_tag.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/enums/measurement_type.dart';

class AddMeasurementView extends StackedView<AddMeasurementViewModel> {
  final String? measurementId;

  const AddMeasurementView({Key? key, this.measurementId}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      AddMeasurementViewModel viewModel,
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
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AddMeasurementViewModel viewModel) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: viewModel.navigateBack,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        viewModel.isEditing ? AppStrings.editMeasurement : AppStrings.addMeasurement,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: viewModel.canSave ? viewModel.saveMeasurement : null,
          child: Text(
            AppStrings.save,
            style: TextStyle(
              color: viewModel.canSave ? AppColors.primary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        UIHelpers.horizontalSpaceSmall,
      ],
    );
  }

  Widget _buildBody(AddMeasurementViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: UIHelpers.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInfoSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildCategorySection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildMeasurementsSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          _buildTagsSection(viewModel),
          UIHelpers.verticalSpaceLarge,
          if (viewModel.isEditing) _buildDeleteSection(viewModel),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(AddMeasurementViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        TextFormField(
          controller: viewModel.titleController,
          decoration: const InputDecoration(
            labelText: AppStrings.measurementTitle,
            hintText: 'e.g., Shoes, Shirts, Custom item...',
          ),
          onChanged: viewModel.onTitleChanged,
        ),
        UIHelpers.verticalSpaceMedium,
        TextFormField(
          controller: viewModel.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Brief description...',
          ),
          onChanged: viewModel.onDescriptionChanged,
        ),
      ],
    );
  }

  Widget _buildCategorySection(AddMeasurementViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category & Icon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: MeasurementType.values.length + 1, // +1 for custom
          itemBuilder: (context, index) {
            if (index == MeasurementType.values.length) {
              return _buildCustomCategoryTile(viewModel);
            }

            final type = MeasurementType.values[index];
            final isSelected = viewModel.selectedCategory == type;

            return GestureDetector(
              onTap: () => viewModel.selectCategory(type),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: UIHelpers.defaultBorderRadius,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    UIHelpers.verticalSpaceSmall,
                    Text(
                      type.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (viewModel.isCustomCategory) ...[
          UIHelpers.verticalSpaceMedium,
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: viewModel.customCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Category Name',
                    hintText: 'Enter category name...',
                  ),
                  onChanged: viewModel.onCustomCategoryChanged,
                ),
              ),
              UIHelpers.horizontalSpaceMedium,
              GestureDetector(
                onTap: viewModel.showEmojiPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: UIHelpers.defaultBorderRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      viewModel.customIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCustomCategoryTile(AddMeasurementViewModel viewModel) {
    final isSelected = viewModel.isCustomCategory;

    return GestureDetector(
      onTap: viewModel.selectCustomCategory,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: UIHelpers.defaultBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
            style: isSelected ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 24,
              color: isSelected ? Colors.white : AppColors.textTertiary,
            ),
            UIHelpers.verticalSpaceSmall,
            Text(
              'Custom',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementsSection(AddMeasurementViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Measurements',
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
            color: AppColors.surfaceVariant,
            borderRadius: UIHelpers.defaultBorderRadius,
          ),
          child: Column(
            children: [
              ...viewModel.measurements.asMap().entries.map((entry) {
                final index = entry.key;
                final measurement = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == viewModel.measurements.length - 1 ? 0 : 12,
                  ),
                  child: _buildMeasurementItem(viewModel, index, measurement),
                );
              }),
              UIHelpers.verticalSpaceMedium,
              GestureDetector(
                onTap: viewModel.addMeasurement,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: UIHelpers.smallBorderRadius,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add New Measurement',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementItem(
      AddMeasurementViewModel viewModel,
      int index,
      MeasurementItemForm measurement,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: UIHelpers.smallBorderRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: measurement.brandController,
              decoration: const InputDecoration(
                labelText: 'Brand/Store',
                hintText: 'e.g., Nike, Zara',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) => viewModel.updateMeasurement(index, brand: value),
            ),
          ),
          UIHelpers.horizontalSpaceSmall,
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: measurement.sizeController,
              decoration: const InputDecoration(
                labelText: 'Size',
                hintText: '40⅔',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) => viewModel.updateMeasurement(index, size: value),
            ),
          ),
          UIHelpers.horizontalSpaceSmall,
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: measurement.notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Optional',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) => viewModel.updateMeasurement(index, notes: value),
            ),
          ),
          UIHelpers.horizontalSpaceSmall,
          IconButton(
            onPressed: () => viewModel.removeMeasurement(index),
            icon: const Icon(
              Icons.close,
              color: AppColors.error,
              size: 18,
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(AddMeasurementViewModel viewModel) {
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
          children: [
            ...viewModel.tags.map((tag) {
              return MeasurementTag(
                tag: tag,
                onTap: () => viewModel.removeTag(tag),
              );
            }),
            SizedBox(
              width: 120,
              child: TextFormField(
                controller: viewModel.tagController,
                decoration: const InputDecoration(
                  hintText: 'Add tag...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: const TextStyle(fontSize: 14),
                onFieldSubmitted: viewModel.addTag,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeleteSection(AddMeasurementViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danger Zone',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        UIHelpers.verticalSpaceMedium,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: viewModel.deleteMeasurement,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete Measurement'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  AddMeasurementViewModel viewModelBuilder(BuildContext context) =>
      AddMeasurementViewModel(measurementId: measurementId);

  @override
  void onViewModelReady(AddMeasurementViewModel viewModel) =>
      viewModel.initialize();
}