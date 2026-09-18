import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_widgets.dart';
import '../../common/detail_widgets.dart';
import '../../common/form_widgets.dart';
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
        const SizedBox(height: 22),
        PrimaryButton(label: 'Add measurement', onTap: viewModel.addMeasurement),
        const SizedBox(height: 20),
        if (measurements.isEmpty)
          const EmptyState(
            icon: Icons.straighten_rounded,
            title: 'No measurements yet',
            subtitle: 'Add sizes for this group - e.g. Nike Air Max · 42, or Zara jeans · W32.',
          )
        else ...[
          SectionHeader('Measurements'),
          MeasurementListCard(measurements, accent: color),
        ],
        const SizedBox(height: 28),
        ArchiveDeleteActions(
          archived: false,
          onToggleArchive: null,
          onDelete: viewModel.confirmDelete,
        ),
      ],
    );
  }

  @override
  GroupDetailViewModel viewModelBuilder(BuildContext context) =>
      GroupDetailViewModel(groupId: measurementId);

  @override
  void onViewModelReady(GroupDetailViewModel viewModel) => viewModel.initialize();
}
