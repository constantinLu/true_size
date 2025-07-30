import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../views/add_measurement/add_group_form_viewmodel.dart';
import '../../views/add_measurement/icons_helper.dart';
import '../palette.dart';
import '../../views/brand_view/brand_view.dart';

class viewModelItemWidget extends StatelessWidget {
  const viewModelItemWidget({
    super.key,
    required this.viewModel,
    required this.index,
  });

  final AddGroupFormViewModel viewModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.backgroundColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
            children: [
              // Icon selector for viewModel
              GestureDetector(
                onTap: null,
                child: Container(
                  width: 20.sp,
                  height: 20.sp,
                  decoration: BoxDecoration(
                    color: Palette.backgroundColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Palette.backgroundColor.withOpacity(0.5)),
                  ),
                  child: Icon(
                    allIcons[viewModel.icon] ?? Icons.arrow_forward_rounded,
                    size: 20,
                    color: Palette.whiteCultured,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name field
              Expanded(
                child: TextFormField(
                  controller: viewModel.nameController,
                  style: const TextStyle(color: whiteCultured),
                  decoration: const InputDecoration(
                    hintText: 'viewModel name',
                    hintStyle: TextStyle(color: greyDim),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

              // Remove button
              IconButton(
                onPressed: () => null,
                //viewModel.removeviewModel(index),
                icon: const Icon(Icons.close, color: greyDim, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Value and Unit row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: viewModel.valueController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: whiteCultured),
                  decoration: InputDecoration(
                    hintText: 'Value',
                    hintStyle: const TextStyle(color: greyDim),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => null,
                  //viewModel.showUnitSelector(index),
                  child: Container(
                    height: 30.sp,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.unit?.name ?? 'Unit',
                          style: TextStyle(
                            color: viewModel.unit != null
                                ? whiteCultured
                                : greyDim,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: whiteCultured, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Brand selector
          BrandView(
            selectedBrand: viewModel.brand,
            selectedCustomBrand: viewModel.customBrand,
            onBrandSelected: (brand) {
              viewModel.brand = brand;
              viewModel.customBrand = null;
              viewModel.notifyListeners();
            },
            onCustomBrandSelected: (customBrand) {
              viewModel.customBrand = customBrand;
              viewModel.brand = null;
              viewModel.notifyListeners();
            },
            index: index,
          ),

          // ADD NOTES BTN / FIELD
          if (viewModel.showNotes) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: viewModel.notesController,
              style: const TextStyle(color: whiteCultured),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add notes...',
                hintStyle: const TextStyle(color: Palette.greyDim),
                filled: true,
                fillColor: Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => null,
              //viewModel.toggleNotes(index),
              child: Row(
                children: [
                  Icon(Icons.add, color: Palette.whiteCultured, size: 16),
                  SizedBox(width: 4, height: 5.h),
                  const Text(
                    'Add Note',
                    style: TextStyle(
                      color: Palette.whiteCultured,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
