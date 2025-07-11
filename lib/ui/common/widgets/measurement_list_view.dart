import 'package:flutter/material.dart';
import '../../../core/models/measurement_entry.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../ui_helpers.dart';
import '../../../core/utils/helpers.dart';

class MeasurementListView extends StatelessWidget {
  final List<MeasurementEntry> measurements;
  final Function(MeasurementEntry) onTap;
  final Function(MeasurementEntry) onLongPress;

  const MeasurementListView({
    Key? key,
    required this.measurements,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: UIHelpers.screenPaddingHorizontal,
      itemCount: measurements.length,
      itemBuilder: (context, index) {
        final entry = measurements[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.padding),
          child: _buildListItem(entry),
        );
      },
    );
  }

  Widget _buildListItem(MeasurementEntry entry) {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: UIHelpers.defaultBorderRadius,
      ),
      child: InkWell(
        onTap: () => onTap(entry),
        onLongPress: () => onLongPress(entry),
        borderRadius: UIHelpers.defaultBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Row(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    UIHelpers.verticalSpaceSmall,
                    Text(
                      'Updated ${Helpers.formatRelativeTime(entry.updatedAt)} • ${Helpers.formatMeasurementCount(entry.measurements.length)}',
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
        ),
      ),
    );
  }
}