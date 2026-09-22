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
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, topBarInset(context) + 8, 16, 8),
                sliver: SliverToBoxAdapter(child: _Heading(viewModel)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                sliver: SliverToBoxAdapter(child: _Groups(viewModel)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class _Heading extends StatelessWidget {
  const _Heading(this.vm);
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final count = vm.groups.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Collection', style: AppTypography.largePageTitle.copyWith(color: context.neutrals.textPrimary)),
              const SizedBox(height: 4),
              Text(
                '${count == 1 ? '1 group' : '$count groups'} · ${vm.totalItems == 1 ? '1 item' : '${vm.totalItems} items'}',
                style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary),
              ),
            ],
          ),
        ),
        if (vm.groups.isNotEmpty) ...[
          const SizedBox(width: 12),
          SortControls<GroupSort>(
            options: const [
              SortOption(value: GroupSort.alphabetical, label: 'Alphabetically', icon: Icons.sort_by_alpha_rounded),
              SortOption(value: GroupSort.measurements, label: 'Measurements', icon: Icons.straighten_rounded),
              SortOption(value: GroupSort.date, label: 'Date', icon: Icons.schedule_rounded),
            ],
            current: vm.sort,
            ascending: vm.ascending,
            onOrderChanged: vm.setSort,
            onToggleDirection: vm.toggleDirection,
          ),
        ],
      ],
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups(this.vm);
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    // Until the first data arrives, fill the view with shimmering placeholder
    // cards (StreamViewModel doesn't set isBusy, so gate on dataReady). The
    // AnimatedSwitcher crossfades the skeletons into the real cards when they
    // land, so the data appears to morph in rather than pop after a spinner.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    if (!vm.dataReady) {
      return const GroupListSkeleton(key: ValueKey('skeleton'));
    }
    final groups = vm.filteredGroups;
    if (groups.isEmpty) {
      return KeyedSubtree(
        key: const ValueKey('empty'),
        child: EmptyState(
          icon: vm.isSearching ? Icons.search_off_rounded : Icons.grid_view_rounded,
          title: vm.isSearching ? 'No groups match' : 'No groups yet',
          subtitle: vm.isSearching
              ? 'Try a different search.'
              : 'Create your first group (Shoes, Jeans, Bedding…) with the + button.',
        ),
      );
    }
    return Column(
      key: const ValueKey('groups'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < groups.length; i++) ...[
          if (i != 0) const SizedBox(height: 12),
          GroupCard(groups[i], onTap: () => vm.openGroup(groups[i])),
        ],
      ],
    );
  }
}
