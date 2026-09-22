import 'package:flutter/material.dart';

import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// One selectable sort field: its [value], display [label] and picker [icon].
class SortOption<T> {
  const SortOption({required this.value, required this.label, required this.icon});
  final T value;
  final String label;
  final IconData icon;
}

/// The order controls shown to the right of a list header: an "Order" button
/// that opens a slide-down field picker, a circular ascending/descending toggle,
/// and the current field's label beneath. Generic over the sort enum so the
/// collection and items lists share the exact same control.
class SortControls<T> extends StatelessWidget {
  const SortControls({
    super.key,
    required this.options,
    required this.current,
    required this.ascending,
    required this.onOrderChanged,
    required this.onToggleDirection,
  });

  final List<SortOption<T>> options;
  final T current;
  final bool ascending;
  final ValueChanged<T> onOrderChanged;
  final VoidCallback onToggleDirection;

  SortOption<T> get _currentOption => options.firstWhere(
        (o) => o.value == current,
        orElse: () => options.first,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OrderButton(onTap: () async {
              final picked = await showSortSheet<T>(context,
                  options: options, current: current);
              if (picked != null) onOrderChanged(picked);
            }),
            const SizedBox(width: 8),
            _DirectionButton(ascending: ascending, onTap: onToggleDirection),
          ],
        ),
        const SizedBox(height: 6),
        Text(_currentOption.label,
            style: AppTypography.caption.copyWith(color: context.neutrals.textFaint)),
      ],
    );
  }
}

class _OrderButton extends StatelessWidget {
  const _OrderButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return PressableScale.wrap(
      child: Material(
        color: context.neutrals.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.neutrals.stroke),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_vert_rounded, size: 18, color: primary),
                const SizedBox(width: 6),
                Text('Order',
                    style: AppTypography.button.copyWith(color: context.neutrals.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({required this.ascending, required this.onTap});
  final bool ascending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return PressableScale.wrap(
      child: Material(
        color: context.neutrals.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.neutrals.stroke),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
              child: Icon(
                ascending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                key: ValueKey(ascending),
                size: 19,
                color: primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A sheet that slides down from the top to pick the sort field.
Future<T?> showSortSheet<T>(
  BuildContext context, {
  required List<SortOption<T>> options,
  required T current,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (ctx, _, _) {
      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: ctx.neutrals.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ctx.neutrals.stroke),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sort by',
                            style: AppTypography.sectionHeading
                                .copyWith(color: ctx.neutrals.textPrimary)),
                      ),
                    ),
                    for (final o in options)
                      _SortOptionTile<T>(
                        option: o,
                        selected: o.value == current,
                        onTap: () => Navigator.pop(ctx, o.value),
                      ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

class _SortOptionTile<T> extends StatelessWidget {
  const _SortOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final SortOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(option.icon,
                size: 21, color: selected ? primary : context.neutrals.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(option.label,
                  style: AppTypography.listItemTitle.copyWith(
                      color: selected ? primary : context.neutrals.textPrimary)),
            ),
            if (selected) Icon(Icons.check_rounded, size: 20, color: primary),
          ],
        ),
      ),
    );
  }
}
