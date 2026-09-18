import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_widgets.dart';
import '../../common/group_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'items_viewmodel.dart';

/// A flat list of every measurement across all groups, each row showing the
/// brand logo (or icon) - the app-wide view of everything you've sized.
class ItemsView extends StackedView<ItemsViewModel> {
  const ItemsView({super.key});

  @override
  Widget builder(BuildContext context, ItemsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All items', style: AppTypography.largePageTitle.copyWith(color: context.neutrals.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Every measurement across your groups',
                            style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
                  sliver: SliverToBoxAdapter(child: _Body(viewModel)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  ItemsViewModel viewModelBuilder(BuildContext context) => ItemsViewModel();

  @override
  void onViewModelReady(ItemsViewModel viewModel) => viewModel.initialize();
}

class _Body extends StatelessWidget {
  const _Body(this.vm);
  final ItemsViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.isBusy) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (vm.items.isEmpty) {
      return const EmptyState(
        icon: Icons.straighten_rounded,
        title: 'No items yet',
        subtitle: 'Open a group and add measurements - shoes, jeans, sheets and more.',
      );
    }
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (int i = 0; i < vm.items.length; i++) ...[
              MeasurementTile(
                vm.items[i].measurement,
                accent: groupColor(vm.items[i].group.color),
                trailingGroup: vm.items[i].group.name,
                onTap: () => vm.openGroup(vm.items[i].group),
              ),
              if (i != vm.items.length - 1)
                Divider(height: 1, thickness: 1, color: context.neutrals.stroke, indent: 68, endIndent: 18),
            ],
          ],
        ),
      ),
    );
  }
}
