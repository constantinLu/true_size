import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/dates.dart';
import '../../../core/models/body_measurement.dart';
import '../../common/app_widgets.dart';
import '../../common/body_silhouette.dart';
import '../../common/detail_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../body/body_view.dart' show fmtBody;
import 'body_part_detail_viewmodel.dart';

class BodyPartDetailView extends StackedView<BodyPartDetailViewModel> {
  const BodyPartDetailView({super.key, required this.partKey});

  final String partKey;

  @override
  Widget builder(BuildContext context, BodyPartDetailViewModel viewModel, Widget? child) {
    final part = viewModel.part;
    if (part == null) {
      return Scaffold(
        appBar: AppBar(leading: CircleBackButton(onTap: viewModel.back)),
        body: const SizedBox.shrink(),
      );
    }
    final primary = Theme.of(context).colorScheme.primary;
    final latest = viewModel.latest;
    final entries = viewModel.entries;

    return DetailScaffold(
      title: part.label,
      children: [
        // Hero: silhouette with this part highlighted + latest value.
        Center(
          child: Column(
            children: [
              BodySilhouette(gender: viewModel.gender, height: 180, markers: [part], highlightKey: part.key),
              const SizedBox(height: 12),
              Text(
                latest == null ? '—' : '${fmtBody(latest.value)} ${part.unit}',
                style: AppTypography.largeBalance.copyWith(color: context.neutrals.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(part.label, style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader('How to measure'),
        const SizedBox(height: 10),
        SoftCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconMedallion(
                  icon: Icons.straighten_rounded, color: primary, size: 40, iconSize: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    part.howTo,
                    style: AppTypography.subtitle.copyWith(
                        color: context.neutrals.textSecondary, height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader('History'),
        if (entries.isEmpty)
          const EmptyState(
            icon: Icons.timeline_rounded,
            title: 'No history yet',
            subtitle: 'Set a value on the Body tab to start tracking this over time.',
          )
        else
          _Timeline(entries: entries, unit: part.unit, accent: primary, onDelete: viewModel.deleteEntry),
      ],
    );
  }

  @override
  BodyPartDetailViewModel viewModelBuilder(BuildContext context) =>
      BodyPartDetailViewModel(partKey: partKey);

  @override
  void onViewModelReady(BodyPartDetailViewModel viewModel) => viewModel.initialize();
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.entries, required this.unit, required this.accent, required this.onDelete});
  final List<BodyEntry> entries;
  final String unit;
  final Color accent;
  final void Function(BuildContext, BodyEntry) onDelete;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++)
            _TimelineRow(
              entry: entries[i],
              previous: i + 1 < entries.length ? entries[i + 1] : null,
              unit: unit,
              accent: accent,
              isFirst: i == 0,
              isLast: i == entries.length - 1,
              onDelete: () => onDelete(context, entries[i]),
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.entry,
    required this.previous,
    required this.unit,
    required this.accent,
    required this.isFirst,
    required this.isLast,
    required this.onDelete,
  });

  final BodyEntry entry;
  final BodyEntry? previous;
  final String unit;
  final Color accent;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final delta = previous == null ? null : entry.value - previous!.value;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline spine + dot.
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(width: 2, height: 12, color: isFirst ? Colors.transparent : context.neutrals.surfaceHigh),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? accent : context.neutrals.surfaceHigh,
                    border: Border.all(color: isFirst ? accent : context.neutrals.textFaint, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(width: 2, color: isLast ? Colors.transparent : context.neutrals.surfaceHigh),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${fmtBody(entry.value)} $unit',
                                style: AppTypography.listItemTitle.copyWith(color: context.neutrals.textPrimary)),
                            if (delta != null && delta.abs() > 0.001) ...[
                              const SizedBox(width: 8),
                              _DeltaPill(delta: delta),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(formatDateTime(entry.date),
                            style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelete,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.delete_outline_rounded, size: 19, color: context.neutrals.textFaint),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeltaPill extends StatelessWidget {
  const _DeltaPill({required this.delta});
  final double delta;

  @override
  Widget build(BuildContext context) {
    final up = delta > 0;
    final color = up ? const Color(0xFF4B966E) : const Color(0xFFB36273);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(8)),
      child: Text(
        '${up ? '+' : '−'}${fmtBody(delta.abs())}',
        style: AppTypography.badge.copyWith(color: color, fontWeight: AppTypography.medium),
      ),
    );
  }
}
