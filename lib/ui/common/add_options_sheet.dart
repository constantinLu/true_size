import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

enum AddOption { group, item }

/// The sheet shown by the center "+": pick what to create.
Future<AddOption?> showAddOptionsSheet(BuildContext context) {
  return showModalBottomSheet<AddOption>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => const _AddOptionsSheet(),
  );
}

class _AddOptionsSheet extends StatelessWidget {
  const _AddOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: context.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(100)),
              ),
            ),
            const SizedBox(height: 18),
            Text('Add', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('What would you like to create?',
                style: AppTypography.smallMonetary.copyWith(color: context.neutrals.textSecondary)),
            const SizedBox(height: 18),
            _option(context, AddOption.group, Icons.grid_view_rounded, 'Group',
                'A category like Shoes, Jeans or Bedding', const Color(0xFF7A97DC)),
            _option(context, AddOption.item, Icons.straighten_rounded, 'Item',
                'A sized item inside one of your groups', AppColors.positive),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, AddOption value, IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.pop(context, value),
        behavior: HitTestBehavior.opaque,
        child: SoftCard(
          color: context.neutrals.surfaceHigh,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconMedallion(icon: icon, color: color, size: 40, iconSize: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.neutrals.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}
