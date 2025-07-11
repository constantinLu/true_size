import 'package:flutter/material.dart';
import '../../../core/models/measurement_entry.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../ui_helpers.dart';
import '../../../core/utils/helpers.dart';

class MeasurementCalendarView extends StatelessWidget {
  final List<MeasurementEntry> measurements;
  final Function(MeasurementEntry) onTap;

  const MeasurementCalendarView({
    Key? key,
    required this.measurements,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group measurements by date
    final groupedMeasurements = <DateTime, List<MeasurementEntry>>{};

    for (final entry in measurements) {
      final date = DateTime(
        entry.updatedAt.year,
        entry.updatedAt.month,
        entry.updatedAt.day,
      );
      groupedMeasurements.putIfAbsent(date, () => []).add(entry);
    }

    final sortedDates = groupedMeasurements.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: UIHelpers.screenPaddingHorizontal,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final entries = groupedMeasurements[date]!;

        return Column(
          children: entries.map((entry) => _buildCalendarItem(date, entry)).toList(),
        );
      },
    );
  }

  Widget _buildCalendarItem(DateTime date, MeasurementEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: UIHelpers.defaultBorderRadius,
        ),
        child: InkWell(
          onTap: () => onTap(entry),
          borderRadius: UIHelpers.defaultBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getWeekdayShort(date),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelpers.horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.title} Updated',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _generateUpdateDescription(entry),
                        style: const TextStyle(
                          fontSize: 12,
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
      ),
    );
  }

  String _getWeekdayShort(DateTime date) {
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return weekdays[date.weekday - 1];
  }

  String _generateUpdateDescription(MeasurementEntry entry) {
    if (entry.measurements.isNotEmpty) {
      final recentMeasurement = entry.measurements.first;
      return 'Added ${recentMeasurement.brand} ${recentMeasurement.size} measurement';
    }
    return 'Updated measurement details';
  }
}