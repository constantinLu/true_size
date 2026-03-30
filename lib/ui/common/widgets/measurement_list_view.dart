import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:true_size/ui/theme/color_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/models/group.dart';
import '../../../core/utils/helpers.dart';
import '../ui_helpers.dart';

class GroupListView extends StatelessWidget {
  final List<Group> groups;
  final Function(Group) onTap;
  final Function(Group) onLongPress;

  const GroupListView({
    super.key,
    required this.groups,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: UIHelpers.screenPaddingHorizontal,
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final entry = groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.padding),
          child: _buildGroupItem(entry),
        );
      },
    );
  }

  Widget _buildGroupItem(Group entry) {
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
                  color: entry.color.toColors(),
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
                      entry.name,
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
