import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_widgets.dart';
import '../../common/group_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../root/root_view.dart';
import 'items_viewmodel.dart';

/// A flat list of every measurement across all groups, each row showing the
/// brand logo (or icon). Tap a row to open its detail.
class ItemsView extends StackedView<ItemsViewModel> {
  const ItemsView({super.key});

  @override
  Widget builder(BuildContext context, ItemsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, topBarInset(context) + 8, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('All items',
                          style: AppTypography.largePageTitle.copyWith(color: context.neutrals.textPrimary)),
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
    );
  }

  @override
  ItemsViewModel viewModelBuilder(BuildContext context) => ItemsViewModel();
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
    final items = vm.items;
    if (items.isEmpty) {
      return EmptyState(
        icon: vm.isSearching ? Icons.search_off_rounded : Icons.straighten_rounded,
        title: vm.isSearching ? 'No items match' : 'No items yet',
        subtitle: vm.isSearching
            ? 'Try a different search.'
            : 'Open a group and add measurements - shoes, jeans, sheets and more.',
      );
    }
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              MeasurementTile(
                items[i].measurement,
                accent: groupColor(items[i].group.color),
                trailingGroup: items[i].group.name,
                onTap: () => vm.openMeasurement(items[i]),
              ),
              if (i != items.length - 1)
                Divider(height: 1, thickness: 1, color: context.neutrals.stroke, indent: 68, endIndent: 18),
            ],
          ],
        ),
      ),
    );
  }
}
