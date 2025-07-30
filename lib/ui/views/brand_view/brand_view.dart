import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked/stacked.dart';

import '../../../core/models/brand.dart';
import 'brand_viewmodel.dart';

class BrandView extends StackedView<BrandViewModel> {
  final Brand? selectedBrand;
  final String? selectedCustomBrand;
  final Function(Brand?) onBrandSelected;
  final Function(String?) onCustomBrandSelected;
  final int index;

  const BrandView({
    super.key,
    this.selectedBrand,
    this.selectedCustomBrand,
    required this.onBrandSelected,
    required this.onCustomBrandSelected,
    required this.index,
  });

  @override
  Widget builder(
      BuildContext context, BrandViewModel viewModel, Widget? child) {
    return GestureDetector(
      onTap: null, //viewModel.showBrandSelector,
      child: Container(
        height: 30.sp,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedBrand?.name ?? selectedCustomBrand ?? 'Brand (Optional)',
              style: TextStyle(
                color: (selectedBrand != null || selectedCustomBrand != null)
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF8E8E93),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  BrandViewModel viewModelBuilder(BuildContext context) => BrandViewModel(
        selectedBrand: selectedBrand,
        selectedCustomBrand: selectedCustomBrand,
        onBrandSelected: onBrandSelected,
        onCustomBrandSelected: onCustomBrandSelected,
      );

  @override
  void onViewModelReady(BrandViewModel viewModel) => viewModel.initialize();
}
