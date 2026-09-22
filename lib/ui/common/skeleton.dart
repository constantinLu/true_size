import 'package:flutter/material.dart';

import '../theme/app_neutrals.dart';
import 'app_widgets.dart';

/// A single grey placeholder block. Wrap a tree of these in a [Shimmer] to get
/// the Material-style loading sheen. Size it to roughly match the real content
/// it stands in for so the swap to real data reads as a morph, not a jump.
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 8,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.neutrals.surfaceHigh,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(radius) : null,
      ),
    );
  }
}

/// Sweeps a soft highlight across the opaque (skeleton) pixels of its [child],
/// giving the Google-style shimmer. Wrap a whole placeholder tree in one
/// Shimmer so the sweep runs across all of it in sync.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child});
  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.neutrals.surfaceHigh;
    final highlight = Color.alphaBlend(Colors.white.withValues(alpha: 0.14), base);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [base, highlight, base],
          stops: const [0.30, 0.50, 0.70],
          transform: _SlideTransform(_controller.value),
        ).createShader(bounds),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Slides the shimmer gradient from off the left edge to off the right edge as
/// [t] runs 0 -> 1.
class _SlideTransform extends GradientTransform {
  const _SlideTransform(this.t);
  final double t;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues((t * 2 - 1) * bounds.width, 0, 0);
}

/// Placeholder standing in for a [GroupCard] while the collection loads: a real
/// card surface with shimmering grey bars inside (the shimmer wraps only the
/// content, so the card background keeps its normal colour).
class GroupCardSkeleton extends StatelessWidget {
  const GroupCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: const Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Skeleton(width: 48, height: 48, shape: BoxShape.circle),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(width: 150, height: 14),
                      SizedBox(height: 9),
                      Skeleton(width: 90, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Skeleton(width: double.infinity, height: 10, radius: 6),
          ],
        ),
      ),
    );
  }
}

/// A column of [GroupCardSkeleton]s - the collection view's loading state.
class GroupListSkeleton extends StatelessWidget {
  const GroupListSkeleton({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i != 0) const SizedBox(height: 12),
          const GroupCardSkeleton(),
        ],
      ],
    );
  }
}

/// Placeholder standing in for the flat items list (a [SoftCard] of rows) while
/// it loads. The shimmer wraps only the rows so the card surface stays normal.
class MeasurementListSkeleton extends StatelessWidget {
  const MeasurementListSkeleton({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Shimmer(
        child: Column(
          children: [
            for (int i = 0; i < count; i++) ...[
              if (i != 0)
                Divider(
                    height: 1,
                    thickness: 1,
                    color: context.neutrals.stroke,
                    indent: 68,
                    endIndent: 18),
              const _MeasurementRowSkeleton(),
            ],
          ],
        ),
      ),
    );
  }
}

class _MeasurementRowSkeleton extends StatelessWidget {
  const _MeasurementRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Skeleton(width: 40, height: 40, shape: BoxShape.circle),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 130, height: 13),
                SizedBox(height: 7),
                Skeleton(width: 80, height: 11),
              ],
            ),
          ),
          SizedBox(width: 8),
          Skeleton(width: 48, height: 13),
        ],
      ),
    );
  }
}
