import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// A left-vs-right "symmetry" comparison for paired body parts (biceps,
/// forearms, thighs, calves). Two bars diverge from a central spine - the
/// heavier side reaching further - and animate outward on first build, with the
/// values counting up, a symmetry score, and a plain-language balance caption.
///
/// Themed to match the app: soft card, the part's accent colour, and a tape-
/// measure tick spine down the middle.
class SymmetryComparison extends StatelessWidget {
  const SymmetryComparison({
    super.key,
    required this.left,
    required this.right,
    required this.unit,
    required this.accent,
  });

  final double left;
  final double right;
  final String unit;
  final Color accent;

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final maxV = math.max(left, right);
    final minV = math.min(left, right);
    final leftBigger = left >= right;
    final diff = (left - right).abs();
    final balanced = diff < 0.1;
    final symmetry = maxV <= 0 ? 100.0 : (minV / maxV) * 100;

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 950),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SideValue(
                    label: 'Left',
                    value: left * t,
                    unit: unit,
                    accent: accent,
                    emphasised: leftBigger,
                    alignEnd: false,
                  ),
                  const Spacer(),
                  _SymmetryBadge(percent: symmetry * t, accent: accent),
                  const Spacer(),
                  _SideValue(
                    label: 'Right',
                    value: right * t,
                    unit: unit,
                    accent: accent,
                    emphasised: !leftBigger,
                    alignEnd: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DivergingBars(
                leftFraction: (maxV <= 0 ? 0.0 : left / maxV) * t,
                rightFraction: (maxV <= 0 ? 0.0 : right / maxV) * t,
                accent: accent,
                leftBigger: leftBigger,
              ),
              const SizedBox(height: 14),
              Opacity(
                opacity: t,
                child: _BalanceCaption(
                  balanced: balanced,
                  heavierIsLeft: leftBigger,
                  diff: diff,
                  unit: unit,
                  accent: accent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SideValue extends StatelessWidget {
  const _SideValue({
    required this.label,
    required this.value,
    required this.unit,
    required this.accent,
    required this.emphasised,
    required this.alignEnd,
  });

  final String label;
  final double value;
  final String unit;
  final Color accent;
  final bool emphasised;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.badge.copyWith(
            color: emphasised ? accent : context.neutrals.textSecondary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              SymmetryComparison._fmt(value),
              style: AppTypography.transactionAmount.copyWith(
                color: context.neutrals.textPrimary,
                fontWeight: AppTypography.semibold,
              ),
            ),
            const SizedBox(width: 3),
            Text(unit,
                style: AppTypography.caption
                    .copyWith(color: context.neutrals.textFaint)),
          ],
        ),
      ],
    );
  }
}

class _SymmetryBadge extends StatelessWidget {
  const _SymmetryBadge({required this.percent, required this.accent});
  final double percent;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${percent.round()}%',
          style: AppTypography.listItemTitle.copyWith(
            color: accent,
            fontWeight: AppTypography.semibold,
          ),
        ),
        Text('symmetry',
            style: AppTypography.badge
                .copyWith(color: context.neutrals.textFaint, letterSpacing: 0.5)),
      ],
    );
  }
}

/// Two bars that meet at a central tick-marked spine and extend outward, the
/// heavier side reaching further and carrying a soft glow.
class _DivergingBars extends StatelessWidget {
  const _DivergingBars({
    required this.leftFraction,
    required this.rightFraction,
    required this.accent,
    required this.leftBigger,
  });

  final double leftFraction;
  final double rightFraction;
  final Color accent;
  final bool leftBigger;

  @override
  Widget build(BuildContext context) {
    const height = 26.0;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final half = constraints.maxWidth / 2;
          const gap = 6.0; // clear space either side of the spine
          final leftWidth = math.max(0.0, (half - gap) * leftFraction);
          final rightWidth = math.max(0.0, (half - gap) * rightFraction);
          return Stack(
            children: [
              // Central spine with tape-measure ticks.
              Positioned(
                left: half - 0.5,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 1,
                  child: CustomPaint(painter: _SpinePainter(accent)),
                ),
              ),
              // Left bar (right edge at the spine, grows leftward).
              Positioned(
                right: half + gap,
                top: 4,
                bottom: 4,
                width: leftWidth,
                child: _Bar(accent: accent, glow: leftBigger, toLeft: true),
              ),
              // Right bar (left edge at the spine, grows rightward).
              Positioned(
                left: half + gap,
                top: 4,
                bottom: 4,
                width: rightWidth,
                child: _Bar(accent: accent, glow: !leftBigger, toLeft: false),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.accent, required this.glow, required this.toLeft});
  final Color accent;
  final bool glow;
  final bool toLeft;

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(9);
    final corners = BorderRadius.horizontal(
      left: toLeft ? radius : Radius.zero,
      right: toLeft ? Radius.zero : radius,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: corners,
        gradient: LinearGradient(
          begin: toLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: toLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: [accent.withValues(alpha: 0.55), accent],
        ),
        boxShadow: glow
            ? [BoxShadow(color: accent.withValues(alpha: 0.45), blurRadius: 12, spreadRadius: 0.5)]
            : null,
      ),
    );
  }
}

class _SpinePainter extends CustomPainter {
  _SpinePainter(this.accent);
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = accent.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), line);
    final tick = Paint()..color = accent.withValues(alpha: 0.5);
    // A few centred ticks so the spine reads as a tape measure.
    for (final f in const [0.15, 0.5, 0.85]) {
      final y = size.height * f;
      canvas.drawCircle(Offset(0, y), 1.4, tick);
    }
  }

  @override
  bool shouldRepaint(_SpinePainter old) => old.accent != accent;
}

class _BalanceCaption extends StatelessWidget {
  const _BalanceCaption({
    required this.balanced,
    required this.heavierIsLeft,
    required this.diff,
    required this.unit,
    required this.accent,
  });

  final bool balanced;
  final bool heavierIsLeft;
  final double diff;
  final String unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = balanced
        ? 'Evenly balanced'
        : '${heavierIsLeft ? 'Left' : 'Right'} is ${SymmetryComparison._fmt(diff)} $unit larger';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          balanced ? Icons.check_circle_rounded : Icons.compare_arrows_rounded,
          size: 15,
          color: balanced ? const Color(0xFF4B966E) : accent,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTypography.caption.copyWith(
            color: context.neutrals.textSecondary,
            fontWeight: AppTypography.medium,
          ),
        ),
      ],
    );
  }
}
