import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/enums/gender.dart';
import '../../core/models/body_part.dart';
import '../theme/app_typography.dart';

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
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
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
    final imgTop = (availH - imgH) / 2;

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
        y = y.clamp(_chipH / 2 + 2, availH - _chipH / 2 - 2);
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
