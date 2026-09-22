import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/enums/gender.dart';
import '../../core/models/body_part.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// Full-screen annotated silhouette: every part marker with its value shown in a
/// callout beside it. Opened by long-pressing the silhouette on the Body tab.
Future<void> showBodyMarkers({
  required BuildContext context,
  required Gender gender,
  required List<BodyPart> parts,
  required double? Function(String key) valueOf,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Measurements',
    barrierColor: Colors.black.withValues(alpha: 0.88),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, _, _) =>
        _BodyMarkersView(gender: gender, parts: parts, valueOf: valueOf),
    transitionBuilder: (ctx, anim, _, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

/// Parts whose callout sits in the left column; the rest go on the right. Split
/// to keep the two columns roughly balanced with short leader lines.
const _leftKeys = {
  'head', 'shoulder', 'waist', 'inseam',
  'bicep_left', 'forearm_left', 'thigh_left', 'calf_left',
};

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

class _BodyMarkersView extends StatelessWidget {
  const _BodyMarkersView({
    required this.gender,
    required this.parts,
    required this.valueOf,
  });

  final Gender gender;
  final List<BodyPart> parts;
  final double? Function(String key) valueOf;

  static const _colW = 74.0;
  static const _margin = 6.0;
  static const _chipH = 52.0;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 20,
              child: Text('Your measurements',
                  style: AppTypography.subtitle.copyWith(
                      color: Colors.white.withValues(alpha: 0.9), fontSize: 16)),
            ),
            Positioned(
              top: 4,
              right: 8,
              child: PressableScale(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 22, color: Colors.white),
                ),
              ),
            ),
            Positioned.fill(
              top: 52,
              child: LayoutBuilder(
                builder: (context, c) => _diagram(context, c.biggest, primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diagram(BuildContext context, Size size, Color primary) {
    const innerL = _colW + _margin; // right edge of the left column
    final innerR = size.width - _colW - _margin; // left edge of the right column
    final gapW = innerR - innerL;
    final availH = size.height;
    final aspect = gender.silhouetteAspect;

    var imgH = math.min(availH * 0.98, gapW / aspect);
    var imgW = imgH * aspect;
    final imgLeft = innerL + (gapW - imgW) / 2;
    // Shift the diagram ~20% up from centre and keep every callout inside the
    // top 80%, leaving the bottom fifth free for components added later.
    final bottomLimit = availH * 0.80;
    final imgTop = math.max(8.0, (availH - imgH) / 2 - availH * 0.20);

    Offset marker(BodyPart p) {
      final (mx, my) = p.markerFor(gender);
      return Offset(imgLeft + mx * imgW, imgTop + my * imgH);
    }

    final left = parts.where((p) => _leftKeys.contains(p.key)).toList()
      ..sort((a, b) => marker(a).dy.compareTo(marker(b).dy));
    final right = parts.where((p) => !_leftKeys.contains(p.key)).toList()
      ..sort((a, b) => marker(a).dy.compareTo(marker(b).dy));

    // Push callouts apart vertically so they never overlap within a column.
    final chipY = <String, double>{};
    void place(List<BodyPart> col) {
      const step = _chipH + 6;
      double prev = -1e9;
      for (final p in col) {
        var y = math.max(marker(p).dy, prev + step);
        y = y.clamp(_chipH / 2 + 2, bottomLimit - _chipH / 2 - 2);
        prev = y;
        chipY[p.key] = y;
      }
    }

    place(left);
    place(right);

    final lines = <(Offset, Offset)>[
      for (final p in left) (Offset(innerL, chipY[p.key]!), marker(p)),
      for (final p in right) (Offset(innerR, chipY[p.key]!), marker(p)),
    ];

    return Stack(
      children: [
        Positioned(
          left: imgLeft,
          top: imgTop,
          width: imgW,
          height: imgH,
          child: Image.asset(gender.silhouetteAsset, fit: BoxFit.contain),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _LeaderPainter(
                  lines, primary.withValues(alpha: 0.55)),
            ),
          ),
        ),
        for (final p in parts)
          Positioned(
            left: marker(p).dx - 5.5,
            top: marker(p).dy - 5.5,
            child: _Dot(color: primary),
          ),
        for (final p in left)
          Positioned(
            left: _margin,
            width: _colW,
            top: chipY[p.key]! - _chipH / 2,
            height: _chipH,
            child: _Callout(
                part: p, value: valueOf(p.key), alignEnd: true, accent: primary),
          ),
        for (final p in right)
          Positioned(
            right: _margin,
            width: _colW,
            top: chipY[p.key]! - _chipH / 2,
            height: _chipH,
            child: _Callout(
                part: p, value: valueOf(p.key), alignEnd: false, accent: primary),
          ),
        // Left-vs-right comparison strip in the free space beneath the figure.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _OverlayComparisons(valueOf: valueOf, accent: primary),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({
    required this.part,
    required this.value,
    required this.alignEnd,
    required this.accent,
  });

  final BodyPart part;
  final double? value;
  final bool alignEnd;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          part.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value == null ? '—' : '${_fmt(value!)} ${part.unit}',
          maxLines: 1,
          style: AppTypography.listItemTitle.copyWith(
            color: value == null ? Colors.white.withValues(alpha: 0.5) : Colors.white,
            fontWeight: AppTypography.semibold,
            fontSize: 17,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _LeaderPainter extends CustomPainter {
  _LeaderPainter(this.lines, this.color);
  final List<(Offset, Offset)> lines;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = color;
    for (final (from, to) in lines) {
      // A gentle elbow: horizontal out of the callout, then straight to the dot.
      final mid = Offset(from.dx + (to.dx - from.dx) * 0.45, from.dy);
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..lineTo(mid.dx, mid.dy)
        ..lineTo(to.dx, to.dy);
      canvas.drawPath(path, paint);
      canvas.drawCircle(from, 1.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_LeaderPainter old) =>
      old.lines != lines || old.color != color;
}

/// The left-vs-right comparison strip beneath the silhouette in the annotated
/// overlay. One compact row per paired part (biceps, forearms, thighs, calves)
/// that has both sides recorded. Drawn straight onto the dark background - no
/// card - with the larger side a darker tone and the smaller side lighter.
class _OverlayComparisons extends StatelessWidget {
  const _OverlayComparisons({required this.valueOf, required this.accent});
  final double? Function(String key) valueOf;
  final Color accent;

  static const _pairs = [
    ('Biceps', 'bicep'),
    ('Forearms', 'forearm'),
    ('Thighs', 'thigh'),
    ('Calves', 'calf'),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = <_CompareRow>[];
    for (final pair in _pairs) {
      final l = valueOf('${pair.$2}_left');
      final r = valueOf('${pair.$2}_right');
      if (l == null || r == null) continue;
      rows.add(_CompareRow(label: pair.$1, left: l, right: r, accent: accent));
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.compare_arrows_rounded, size: 13, color: Colors.white54),
              const SizedBox(width: 6),
              Text('LEFT VS RIGHT',
                  style: AppTypography.badge
                      .copyWith(color: Colors.white54, letterSpacing: 1.6)),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < rows.length; i++) ...[
            if (i != 0) const SizedBox(height: 10),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.label,
    required this.left,
    required this.right,
    required this.accent,
  });
  final String label;
  final double left;
  final double right;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final leftBigger = left >= right;
    return Row(
      children: [
        SizedBox(
          width: 62,
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: Colors.white70)),
        ),
        SizedBox(
          width: 30,
          child: Text(_fmt(left),
              textAlign: TextAlign.right,
              style: AppTypography.caption.copyWith(
                color: leftBigger ? Colors.white : Colors.white54,
                fontWeight: leftBigger ? AppTypography.semibold : FontWeight.w400,
              )),
        ),
        const SizedBox(width: 8),
        Expanded(child: _MiniDivergingBars(left: left, right: right, accent: accent)),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(_fmt(right),
              textAlign: TextAlign.left,
              style: AppTypography.caption.copyWith(
                color: !leftBigger ? Colors.white : Colors.white54,
                fontWeight: !leftBigger ? AppTypography.semibold : FontWeight.w400,
              )),
        ),
      ],
    );
  }
}

/// Two bars diverging from a centre spine, animating outward on build. The
/// larger side is a darker gradient of [accent], the smaller side a lighter one.
class _MiniDivergingBars extends StatelessWidget {
  const _MiniDivergingBars({required this.left, required this.right, required this.accent});
  final double left;
  final double right;
  final Color accent;

  static Color _shade(Color c, double delta) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final maxV = math.max(left, right);
    final leftFraction = maxV <= 0 ? 0.0 : left / maxV;
    final rightFraction = maxV <= 0 ? 0.0 : right / maxV;
    final leftBigger = left >= right;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return SizedBox(
          height: 12,
          child: LayoutBuilder(
            builder: (context, c) {
              final half = c.maxWidth / 2;
              const gap = 3.0;
              final lw = math.max(0.0, (half - gap) * leftFraction * t);
              final rw = math.max(0.0, (half - gap) * rightFraction * t);
              return Stack(
                children: [
                  Positioned(
                    left: half - 0.5,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 1, color: Colors.white.withValues(alpha: 0.22)),
                  ),
                  Positioned(
                    right: half + gap,
                    top: 1,
                    bottom: 1,
                    width: lw,
                    child: _bar(toLeft: true, bigger: leftBigger),
                  ),
                  Positioned(
                    left: half + gap,
                    top: 1,
                    bottom: 1,
                    width: rw,
                    child: _bar(toLeft: false, bigger: !leftBigger),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _bar({required bool toLeft, required bool bigger}) {
    // Larger side: darker gradient of the accent; smaller side: lighter.
    final colors = bigger
        ? [accent, _shade(accent, -0.16)]
        : [_shade(accent, 0.16), _shade(accent, 0.30)];
    const radius = Radius.circular(6);
    final corners = BorderRadius.horizontal(
      left: toLeft ? radius : Radius.zero,
      right: toLeft ? Radius.zero : radius,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: corners,
        gradient: LinearGradient(
          // Start at the spine, deepen toward the tip.
          begin: toLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: toLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: colors,
        ),
      ),
    );
  }
}
