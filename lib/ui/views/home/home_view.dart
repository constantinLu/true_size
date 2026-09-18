import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_widgets.dart';
import '../../common/group_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../../theme/color_utils.dart';
import 'home_viewmodel.dart';

/// Soft drop shadow so the hero's white text stays legible over a bright
/// wallpaper or the coloured gradient behind it.
const _heroShadows = [Shadow(color: Color(0x73000000), blurRadius: 10, offset: Offset(0, 1))];

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
              SliverToBoxAdapter(child: _Hero(viewModel)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 130),
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

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialize();
}

class _Hero extends StatelessWidget {
  const _Hero(this.vm);
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final count = vm.groups.length;
    return Container(
      decoration: BoxDecoration(
        gradient: brandGradient(Theme.of(context).colorScheme.primary),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            children: [
              DashboardHeader(
                avatarBytes: null,
                onOpenProfile: vm.openProfile,
                onSearch: vm.toggleSearch,
                light: true,
                trailing: HeaderCircleButton(
                  icon: vm.searching ? Icons.close_rounded : Icons.search_rounded,
                  onTap: vm.toggleSearch,
                  light: true,
                  active: vm.searching,
                ),
              ),
              const SizedBox(height: 34),
              Text('Your collection',
                  style: AppTypography.caption
                      .copyWith(color: Colors.white.withValues(alpha: 0.85), shadows: _heroShadows)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$count',
                      style: AppTypography.displayBalance.copyWith(color: Colors.white, shadows: _heroShadows)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(count == 1 ? 'group' : 'groups',
                        style: AppTypography.cardTitle.copyWith(color: Colors.white70, shadows: _heroShadows)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${vm.totalItems} items measured',
                  style: AppTypography.subtitle
                      .copyWith(color: Colors.white.withValues(alpha: 0.85), shadows: _heroShadows)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups(this.vm);
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.isBusy && vm.groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final groups = vm.filteredMeasurements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (vm.searching) ...[
          _SearchField(vm),
          const SizedBox(height: 16),
        ],
        if (groups.isEmpty)
          EmptyState(
            icon: vm.isSearching ? Icons.search_off_rounded : Icons.grid_view_rounded,
            title: vm.isSearching ? 'No groups match' : 'No groups yet',
            subtitle: vm.isSearching
                ? 'Try a different search.'
                : 'Create your first group (Shoes, Jeans, Bedding…) with the + button.',
          )
        else
          for (int i = 0; i < groups.length; i++) ...[
            if (i != 0) const SizedBox(height: 12),
            GroupCard(groups[i], onTap: () => vm.navigateToMeasurementDetail(groups[i])),
          ],
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField(this.vm);
  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: TextField(
        autofocus: true,
        onChanged: vm.onSearchChanged,
        style: AppTypography.body.copyWith(color: context.neutrals.textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, size: 20, color: context.neutrals.textSecondary),
          hintText: 'Search groups',
          hintStyle: AppTypography.body.copyWith(color: context.neutrals.textFaint),
        ),
      ),
    );
  }
}
