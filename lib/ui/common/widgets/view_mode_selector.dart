import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../views/home/home_viewmodel.dart';

class ViewModeSelector extends StatelessWidget {
  final ViewMode currentMode;
  final Function(ViewMode) onModeChanged;

  const ViewModeSelector({
    Key? key,
    required this.currentMode,
    required this.onModeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Row(
        children: [
          _buildModeButton(
            mode: ViewMode.grid,
            icon: Icons.grid_view,
            label: 'Grid',
          ),
          _buildModeButton(
            mode: ViewMode.list,
            icon: Icons.list,
            label: 'List',
          ),
          _buildModeButton(
            mode: ViewMode.calendar,
            icon: Icons.calendar_month,
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required ViewMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}