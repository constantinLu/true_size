import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_widgets.dart';
import '../../common/detail_widgets.dart';
import '../../common/group_widgets.dart';
import '../../../core/constants/app_icons.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'measurement_detail_viewmodel.dart';

class GroupDetailView extends StackedView<GroupDetailViewModel> {
  const GroupDetailView({super.key, required this.measurementId});

  /// The group id (route argument name kept for router compatibility).
  final String measurementId;

  @override
  Widget builder(BuildContext context, GroupDetailViewModel viewModel, Widget? child) {
    if (viewModel.isBusy && viewModel.group == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final group = viewModel.group;
    if (group == null) {
      return Scaffold(
        appBar: AppBar(leading: CircleBackButton(onTap: viewModel.navigateBack)),
        body: Center(
          child: Text('Group not found', style: AppTypography.body.copyWith(color: context.neutrals.textSecondary)),
        ),
      );
    }

    final color = groupColor(group.color);
    final measurements = viewModel.measurements;

    return DetailScaffold(
      title: group.name,
      children: [
        DetailHero(
          icon: iconForKey(group.icon),
          accent: color,
          value: measurements.length == 1 ? '1 item' : '${measurements.length} items',
          title: group.name,
          subtitle: group.tags.isEmpty ? null : group.tags.map((t) => '#${t.name}').join('  '),
        ),
        const SizedBox(height: 24),
        if (measurements.isEmpty)
          const EmptyState(
            icon: Icons.straighten_rounded,
            title: 'No measurements yet',
            subtitle: 'Add sizes for this group - e.g. Nike Air Max · 42, or Zara jeans · W32.',
          )
        else ...[
          SectionHeader('Measurements'),
          MeasurementListCard(measurements, accent: color, onTap: viewModel.openMeasurement),
        ],
        const SizedBox(height: 28),
        _GroupActions(onDelete: viewModel.confirmDelete, onAdd: viewModel.addMeasurement),
      ],
    );
  }

  @override
  GroupDetailViewModel viewModelBuilder(BuildContext context) =>
      GroupDetailViewModel(groupId: measurementId);

  @override
  void onViewModelReady(GroupDetailViewModel viewModel) => viewModel.initialize();
}

/// Bottom actions for a group: a small square icon-only delete on the left (a
/// low accidental-tap target) and a wide "Add measurement" filling the rest.
class _GroupActions extends StatelessWidget {
  const _GroupActions({required this.onDelete, required this.onAdd});
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    const danger = Color(0xFFB36273);
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        // Small square delete.
        GestureDetector(
          onTap: onDelete,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: danger, width: 1.5),
            ),
            child: const Icon(Icons.delete_outline_rounded, size: 22, color: danger),
          ),
        ),
        const SizedBox(width: 12),
        // Wide add.
        Expanded(
          child: GestureDetector(
            onTap: onAdd,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 54,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Add measurement', style: AppTypography.button.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
