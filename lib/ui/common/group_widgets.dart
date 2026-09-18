import 'package:flutter/material.dart';

import '../../core/constants/app_icons.dart';
import '../../core/models/group.dart';
import '../../core/models/measurement.dart';
import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// Parses a stored group colour string (`#2196F3`, `2196F3` or `0xFF2196F3`)
/// into a [Color], falling back to a soft blue when it can't be read.
Color groupColor(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return const Color(0xFF7A97DC);
  s = s.replaceFirst('#', '').replaceFirst('0x', '');
  if (s.length == 6) s = 'FF$s';
  final value = int.tryParse(s, radix: 16);
  return value == null ? const Color(0xFF7A97DC) : Color(value);
}

/// A group summary card: icon medallion in the group colour, the group name,
/// a measurement count, and its tags. Shared by the home grid/list.
class GroupCard extends StatelessWidget {
  const GroupCard(this.group, {super.key, required this.onTap});
  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = groupColor(group.color);
    final count = group.measurements.length;
    return SoftCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          IconMedallion(
            icon: iconForKey(group.icon),
            color: color,
            size: 46,
            iconSize: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textPrimary)),
                const SizedBox(height: 3),
                Text(
                  count == 1 ? '1 item' : '$count items',
                  style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary),
                ),
                if (group.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in group.tags.take(3)) Pill('#${t.name}', color: color, filled: true),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: context.neutrals.textFaint),
        ],
      ),
    );
  }
}

/// A single measurement row: brand logo (or icon) medallion, the item name and
/// brand, and the sized value on the right. [accent] tints the fallback icon
/// (usually the owning group's colour).
class MeasurementTile extends StatelessWidget {
  const MeasurementTile(this.m, {super.key, required this.accent, this.onTap, this.trailingGroup});
  final Measurement m;
  final Color accent;
  final VoidCallback? onTap;

  /// Optional group name shown under the item (used on the flat "Items" list
  /// where rows come from different groups).
  final String? trailingGroup;

  @override
  Widget build(BuildContext context) {
    final brand = m.brandName;
    final hasBrand = brand.isNotEmpty && brand != 'Unknown';
    final meta = [
      if (hasBrand) brand,
      if (trailingGroup != null) trailingGroup!,
    ].join(' · ');
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EntryAvatar(
                logoUrl: m.brand?.logo,
                icon: iconForKey(m.icon),
                color: accent,
                size: 40,
                iconSize: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textPrimary)),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(m.value,
                      style: AppTypography.transactionAmount.copyWith(color: context.neutrals.textPrimary)),
                  const SizedBox(height: 2),
                  Text(m.unit.name, style: AppTypography.caption.copyWith(color: context.neutrals.textFaint)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A [SoftCard] holding measurement rows separated by hairline dividers.
class MeasurementListCard extends StatelessWidget {
  const MeasurementListCard(
    this.measurements, {
    super.key,
    required this.accent,
    this.onTap,
    this.groupNameFor,
  });
  final List<Measurement> measurements;
  final Color accent;
  final void Function(Measurement)? onTap;
  final String Function(Measurement)? groupNameFor;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (int i = 0; i < measurements.length; i++) ...[
              MeasurementTile(
                measurements[i],
                accent: accent,
                onTap: onTap == null ? null : () => onTap!(measurements[i]),
                trailingGroup: groupNameFor?.call(measurements[i]),
              ),
              if (i != measurements.length - 1)
                Divider(height: 1, thickness: 1, color: context.neutrals.stroke, indent: 68, endIndent: 18),
            ],
          ],
        ),
      ),
    );
  }
}
