import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/enums/list_sort.dart';
import '../../common/app_widgets.dart';
import '../../common/group_widgets.dart';
import '../../common/skeleton.dart';
import '../../common/sort_controls.dart';
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Measurements',
                                style: AppTypography.largePageTitle.copyWith(color: context.neutrals.textPrimary)),
                            const SizedBox(height: 4),
                            Text('Every measurement across your groups',
                                style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary)),
                          ],
                        ),
                      ),
                      if (viewModel.items.isNotEmpty || viewModel.isSearching) ...[
                        const SizedBox(width: 12),
                        SortControls<ItemSort>(
                          options: const [
                            SortOption(value: ItemSort.alphabetical, label: 'Alphabetically', icon: Icons.sort_by_alpha_rounded),
                            SortOption(value: ItemSort.date, label: 'Date', icon: Icons.schedule_rounded),
                            SortOption(value: ItemSort.brand, label: 'Brand', icon: Icons.sell_outlined),
                          ],
                          current: viewModel.sort,
                          ascending: viewModel.ascending,
                          onOrderChanged: viewModel.setSort,
                          onToggleDirection: viewModel.toggleDirection,
                        ),
                      ],
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
    // Shimmering placeholder rows until the first data arrives (StreamViewModel
    // doesn't set isBusy), crossfading into the real list when it lands.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    if (!vm.dataReady) {
      return const MeasurementListSkeleton(key: ValueKey('skeleton'));
    }
    final items = vm.items;
    if (items.isEmpty) {
      return KeyedSubtree(
        key: const ValueKey('empty'),
        child: EmptyState(
          icon: vm.isSearching ? Icons.search_off_rounded : Icons.straighten_rounded,
          title: vm.isSearching ? 'No items match' : 'No items yet',
          subtitle: vm.isSearching
              ? 'Try a different search.'
              : 'Open a group and add measurements - shoes, jeans, sheets and more.',
        ),
      );
    }
    return SoftCard(
      key: const ValueKey('items'),
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
