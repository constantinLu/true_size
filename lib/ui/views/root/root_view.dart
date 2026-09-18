import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/top_bar.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../../theme/color_utils.dart';
import '../body/body_view.dart';
import '../items/items_view.dart';
import '../home/home_view.dart';
import 'root_viewmodel.dart';

/// App shell: hosts the tabs in an IndexedStack behind a floating top bar
/// (user chip + search) and a floating bottom navigation with an add action.
class RootView extends StackedView<RootViewModel> {
  const RootView({super.key});

  @override
  Widget builder(BuildContext context, RootViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: viewModel.index,
            children: const [
              HomeView(),
              ItemsView(),
              BodyView(),
            ],
          ),
          // Floating top bar - present on every tab.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FloatingTopBar(
              avatarBytes: viewModel.avatarBytes,
              onOpenProfile: viewModel.openProfile,
              controller: viewModel.searchController,
              onChanged: viewModel.onSearchChanged,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.neutrals.background.withValues(alpha: 0.0),
                      context.neutrals.background.withValues(alpha: 0.6),
                      context.neutrals.background.withValues(alpha: 0.82),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FloatingNav(
              index: viewModel.index,
              onTap: viewModel.setIndex,
              onAdd: () => viewModel.showAddSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  RootViewModel viewModelBuilder(BuildContext context) => RootViewModel();
}

/// The top inset that tab content should leave clear for the floating top bar.
double topBarInset(BuildContext context) => MediaQuery.of(context).padding.top + 74;

class _FloatingNav extends StatelessWidget {
  const _FloatingNav({required this.index, required this.onTap, required this.onAdd});
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8)),
                ],
              ),
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(34),
                        ),
                        child: Row(
                          children: [
                            _item(context, 0, Icons.grid_view_rounded, 'Groups'),
                            _item(context, 1, Icons.straighten_rounded, 'Items'),
                            _item(context, 2, Icons.accessibility_new_rounded, 'Body'),
                            Expanded(child: Center(child: _AddButton(onTap: onAdd))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int i, IconData icon, String label) {
    final active = index == i;
    final color = active ? Theme.of(context).colorScheme.primary : context.neutrals.textFaint;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(label, style: AppTypography.tabLabel.copyWith(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: brandGradient(primary),
            boxShadow: [
              BoxShadow(color: primary.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: const Icon(Icons.add_rounded, size: 26, color: Colors.white),
        ),
      ),
    );
  }
}
