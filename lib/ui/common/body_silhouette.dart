import 'package:flutter/material.dart';

import '../../core/enums/gender.dart';
import '../../core/models/body_part.dart';

/// Renders the gendered body silhouette with optional part markers. Used on the
/// Body tab header and the body-part detail hero.
class BodySilhouette extends StatelessWidget {
  const BodySilhouette({
    super.key,
    required this.gender,
    required this.height,
    this.markers = const [],
    this.highlightKey,
  });

  final Gender gender;
  final double height;
  final List<BodyPart> markers;
  final String? highlightKey;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final width = height * gender.silhouetteAspect;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            gender.silhouetteAsset,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
          for (final p in markers)
            Align(
              alignment: Alignment(p.markerX * 2 - 1, p.markerY * 2 - 1),
              child: _Marker(color: primary, active: p.key == highlightKey),
            ),
        ],
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.color, required this.active});
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final size = active ? 16.0 : 11.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
        boxShadow: active
            ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 10, spreadRadius: 1)]
            : null,
      ),
    );
  }
}
