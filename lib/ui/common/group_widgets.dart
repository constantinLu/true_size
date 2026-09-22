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

/// A group summary card: a flat circle icon chip in the group colour, the group
/// name, a ruler-marked measurement count, its tags, and a tape-measure tick
/// strip along the foot. Shared by the home grid/list.
class GroupCard extends StatelessWidget {
  const GroupCard(this.group, {super.key, required this.onTap});
  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = groupColor(group.color);
    final count = group.measurements.length;
    return PressableScale.wrap(
      child: SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconMedallion(
                icon: iconForKey(group.icon),
                color: color,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.cardTitle.copyWith(color: context.neutrals.textPrimary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.straighten_rounded, size: 15, color: color),
                        const SizedBox(width: 6),
                        Text(
                          count == 1 ? '1 measurement' : '$count measurements',
                          style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (group.tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in group.tags.take(3)) Pill('#${t.name}', color: color, filled: true),
              ],
            ),
          ],
          const SizedBox(height: 14),
          _TapeMeasureStrip(color: color),
        ],
      ),
      ),
    );
  }
}

/// A slim measuring-tape edge - evenly spaced ticks in the group colour, taller
/// every fifth - that gives each card its tailoring signature.
class _TapeMeasureStrip extends StatelessWidget {
  const _TapeMeasureStrip({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: double.infinity,
      child: CustomPaint(painter: _TapePainter(color)),
    );
  }
}

class _TapePainter extends CustomPainter {
  _TapePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..color = color.withValues(alpha: 0.16)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, 1), Offset(size.width, 1), base);

    const step = 9.0;
    var i = 0;
    for (double x = 0; x <= size.width + 0.1; x += step, i++) {
      final major = i % 5 == 0;
      final len = major ? 12.0 : 6.0;
      final paint = Paint()
        ..color = color.withValues(alpha: major ? 0.5 : 0.26)
        ..strokeWidth = major ? 1.6 : 1.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x, 1), Offset(x, 1 + len), paint);
    }
  }

  @override
  bool shouldRepaint(_TapePainter old) => old.color != color;
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
    return PressableScale.wrap(
      child: Material(
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final s in m.sizes)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            s.unit.symbol.isEmpty ? s.value : '${s.value} ${s.unit.symbol}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: AppTypography.transactionAmount.copyWith(color: context.neutrals.textPrimary),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
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
