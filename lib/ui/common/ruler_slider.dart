import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A tailor's-tape style value picker: a white measuring-tape band with black
/// tick marks that you drag horizontally under a fixed centre pointer, the way
/// you'd slide a real tape measure. The number under the pointer is the current
/// [value]. Controlled component - it holds no state; drive it with [onChanged].
class RulerSlider extends StatelessWidget {
  const RulerSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.accent,
    this.pxPerUnit = 11,
    this.height = 76,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  /// Colour of the fixed centre pointer.
  final Color accent;

  /// Horizontal pixels per whole unit (cm). Fixed so tick spacing reads the
  /// same on every card regardless of that part's range.
  final double pxPerUnit;
  final double height;

  static const _tape = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF1A1A1A);

  void _onDrag(DragUpdateDetails d) {
    final next = (value - d.delta.dx / pxPerUnit).clamp(min, max).toDouble();
    if (next.round() != value.round()) HapticFeedback.selectionClick();
    onChanged(double.parse(next.toStringAsFixed(1)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: _onDrag,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The tape band.
            Container(
              decoration: BoxDecoration(
                color: _tape,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Tick marks + numbers, offset by the current value.
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomPaint(
                  painter: _RulerPainter(
                    value: value,
                    min: min,
                    max: max,
                    pxPerUnit: pxPerUnit,
                    ink: _ink,
                  ),
                ),
              ),
            ),
            // Fixed centre pointer.
            IgnorePointer(child: _Pointer(color: accent, height: height)),
          ],
        ),
      ),
    );
  }
}

class _Pointer extends StatelessWidget {
  const _Pointer({required this.color, required this.height});
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: height,
      child: Column(
        children: [
          CustomPaint(size: const Size(14, 9), painter: _TrianglePainter(color)),
          Expanded(
            child: Center(
              child: Container(
                width: 2.5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.pxPerUnit,
    required this.ink,
  });

  final double value;
  final double min;
  final double max;
  final double pxPerUnit;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    const top = 16.0;
    final units = center / pxPerUnit + 1;
    final first = (value - units).floor();
    final last = (value + units).ceil();

    for (int u = first; u <= last; u++) {
      final x = center + (u - value) * pxPerUnit;
      // Ticks beyond the part's range are drawn faint and unlabeled so the tape
      // always looks continuous instead of ending in empty white.
      final outOfRange = u < min || u > max;
      final isMajor = u % 10 == 0;
      final isMed = u % 5 == 0;
      final len = isMajor
          ? 28.0
          : isMed
              ? 19.0
              : 11.0;
      final baseAlpha = isMajor ? 0.95 : (isMed ? 0.75 : 0.45);
      final paint = Paint()
        ..color = ink.withValues(alpha: outOfRange ? baseAlpha * 0.3 : baseAlpha)
        ..strokeWidth = isMajor ? 2.0 : 1.3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x, top), Offset(x, top + len), paint);

      if (isMajor && !outOfRange) {
        final tp = TextPainter(
          text: TextSpan(
            text: '$u',
            style: TextStyle(
              color: ink.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, top + len + 4));
      }
    }
  }

  @override
  bool shouldRepaint(_RulerPainter old) =>
      old.value != value || old.min != min || old.max != max;
}
