import 'package:flutter/material.dart';
import '../../../core/models/measurement_entry.dart';
import '../../../core/constants/app_sizes.dart';
import '../ui_helpers.dart';
import 'custom_card.dart';

class MeasurementGridView extends StatelessWidget {
  final List<MeasurementEntry> measurements;
  final Function(MeasurementEntry) onTap;
  final Function(MeasurementEntry) onLongPress;

  const MeasurementGridView({
    Key? key,
    required this.measurements,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: UIHelpers.screenPaddingHorizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.padding,
        mainAxisSpacing: AppSizes.padding,
        childAspectRatio: 1.2,
      ),
      itemCount: measurements.length,
      itemBuilder: (context, index) {
        final entry = measurements[index];
        return CustomCard(
          entry: entry,
          onTap: () => onTap(entry),
          onLongPress: () => onLongPress(entry),
        );
      },
    );
  }
}