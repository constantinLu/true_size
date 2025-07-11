import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/models/measurement_entry.dart';
import '../ui_helpers.dart';
import 'measurement_tag.dart';

class CustomCard extends StatelessWidget {
  final MeasurementEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomCard({
    Key? key,
    required this.entry,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: UIHelpers.defaultBorderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: UIHelpers.defaultBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: UIHelpers.getCategoryColor(entry.category),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Center(
                      child: Text(
                        entry.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  UIHelpers.horizontalSpaceMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        UIHelpers.verticalSpaceSmall,
                        Text(
                          '${entry.measurements.length} measurement${entry.measurements.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              UIHelpers.verticalSpaceMedium,

              // Sample measurements
              if (entry.measurements.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: entry.measurements.take(3).map((measurement) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                      ),
                      child: Text(
                        '${measurement.brand}: ${measurement.size}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                UIHelpers.verticalSpaceMedium,
              ],

              // Tags
              if (entry.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: entry.tags.map((tag) {
                    return MeasurementTag(tag: tag);
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}