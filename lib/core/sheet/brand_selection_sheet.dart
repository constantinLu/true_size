import 'package:flutter/material.dart';

import '../utils/sheet_helper.dart';
import '../../ui/common/widgets/select_tile_widge.dart';
import '../models/brand.dart';

class BrandSelectionSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Brand? selectedBrand;
  final String? selectedCustomBrand;
  final List<Brand> availableBrands;
  final Function(Brand) onBrandSelected;
  final VoidCallback onCreateBrandTap;

  const BrandSelectionSheet({
    required this.title,
    required this.subtitle,
    required this.selectedBrand,
    required this.selectedCustomBrand,
    required this.availableBrands,
    required this.onBrandSelected,
    required this.onCreateBrandTap,
  });

  static Future<void> show({
    required BuildContext context,
    required List<Brand> availableBrands,
    required Brand? selectedBrand,
    required String? selectedCustomBrand,
    required Function(Brand) onBrandSelected,
    required VoidCallback onCreateBrandTap,
  }) {
    return showCustomBottomSheet(
      title: 'Brands',
      subtitle: 'Pick one or multiple brands that fit your measurement',
      child: BrandSelectionSheet(
        title: 'Brands',
        subtitle: 'Pick one or multiple brands that fit your measurement',
        availableBrands: availableBrands,
        selectedBrand: selectedBrand,
        selectedCustomBrand: selectedCustomBrand,
        onBrandSelected: onBrandSelected,
        onCreateBrandTap: onCreateBrandTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...availableBrands.map((brand) {
                final isSelected = selectedBrand?.id == brand.id;
                return SelectionTile(
                  icon: Icons.breakfast_dining_outlined,
                  label: brand.name,
                  isSelected: isSelected,
                  onTap: () => onBrandSelected(brand),
                );
              }),
              if (selectedCustomBrand != null)
                SelectionTile(
                  label: selectedCustomBrand!,
                  isSelected: true,
                  onTap: () {},
                ),
              SelectionTile(
                label: "Create your own",
                icon: Icons.add,
                isSelected: false,
                onTap: onCreateBrandTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
