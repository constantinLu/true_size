import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TileWidget extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final bool isSelected;
  final VoidCallback? onTap;

  const TileWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
