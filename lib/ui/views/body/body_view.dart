import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/dates.dart';
import '../../../core/enums/gender.dart';
import '../../../core/models/body_measurement.dart';
import '../../../core/models/body_part.dart';
import '../../common/app_widgets.dart';
import '../../common/body_markers_overlay.dart';
import '../../common/body_silhouette.dart';
import '../../common/ruler_slider.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../root/root_view.dart';
import 'body_viewmodel.dart';

String fmtBody(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

class BodyView extends StackedView<BodyViewModel> {
  const BodyView({super.key});

  @override
  Widget builder(BuildContext context, BodyViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header(viewModel)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                sliver: SliverList.builder(
                  itemCount: viewModel.parts.length,
                  itemBuilder: (context, i) {
                    final part = viewModel.parts[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BodyPartCard(
                        key: ValueKey(part.key),
                        part: part,
                        gender: viewModel.gender,
                        latest: viewModel.latestFor(part.key),
                        onSave: (v) => viewModel.save(part, v),
                        onOpen: () => viewModel.openPart(part),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BodyViewModel viewModelBuilder(BuildContext context) => BodyViewModel();
}

class _Header extends StatelessWidget {
  const _Header(this.vm);
  final BodyViewModel vm;

  @override
  Widget build(BuildContext context) {
    final changed = vm.lastChanged;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topBarInset(context) + 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your body', style: AppTypography.largePageTitle.copyWith(color: context.neutrals.textPrimary)),
          const SizedBox(height: 4),
          Text(
            changed == null ? 'Track your body measurements over time' : 'Last change: ${formatDateTime(changed)}',
            style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary),
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onLongPress: () => showBodyMarkers(
                context: context,
                gender: vm.gender,
                parts: vm.parts,
                valueOf: (key) => vm.latestFor(key)?.value,
              ),
              child: BodySilhouette(gender: vm.gender, height: 220, markers: vm.parts),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _BodyPartCard extends StatefulWidget {
  const _BodyPartCard({
    super.key,
    required this.part,
    required this.gender,
    required this.latest,
    required this.onSave,
    required this.onOpen,
  });

  final BodyPart part;
  final Gender gender;
  final BodyEntry? latest;
  final Future<void> Function(double) onSave;
  final VoidCallback onOpen;

  @override
  State<_BodyPartCard> createState() => _BodyPartCardState();
}

class _BodyPartCardState extends State<_BodyPartCard> {
  double? _pending;
  bool _saving = false;

  double get _current => (_pending ?? widget.latest?.value ?? widget.part.initial)
      .clamp(widget.part.min, widget.part.max);

  bool get _changed {
    if (_pending == null) return false;
    final base = widget.latest?.value;
    return base == null || (_pending! - base).abs() > 0.001;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.onSave(double.parse(_current.toStringAsFixed(1)));
    if (mounted) setState(() { _pending = null; _saving = false; });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final part = widget.part;
    final hasValue = widget.latest != null || _pending != null;
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _BodyPartChip(gender: widget.gender, part: part),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(part.label, style: AppTypography.caption.copyWith(color: context.neutrals.textSecondary)),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(hasValue ? fmtBody(_current) : '—',
                            style: AppTypography.largeBalance.copyWith(color: context.neutrals.textPrimary)),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(part.unit,
                              style: AppTypography.subtitle.copyWith(color: context.neutrals.textFaint)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_changed)
                GestureDetector(
                  onTap: _saving ? null : _save,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
                    child: _saving
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 20, color: Colors.white),
                  ),
                ),
              _RoundIconButton(icon: Icons.timeline_rounded, onTap: widget.onOpen),
            ],
          ),
          const SizedBox(height: 10),
          RulerSlider(
            value: _current,
            min: part.min,
            max: part.max,
            accent: primary,
            onChanged: (v) => setState(() => _pending = v),
          ),
        ],
      ),
    );
  }
}

/// The circular chip on each body card - the gendered part illustration held
/// inside a white disc so the black line-art reads on any theme.
class _BodyPartChip extends StatelessWidget {
  const _BodyPartChip({required this.gender, required this.part});
  final Gender gender;
  final BodyPart part;

  @override
  Widget build(BuildContext context) {
    const size = 58.0;
    // No disc: the illustration sits directly on the card so there's no visible
    // chip edge or colour seam. The white line-art reads against the dark card.
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        gender.partAsset(part.key),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        cacheWidth: 160,
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.neutrals.surfaceHigh),
        child: Icon(icon, size: 19, color: context.neutrals.textSecondary),
      ),
    );
  }
}
