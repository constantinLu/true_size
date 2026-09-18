import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/enums/gender.dart';
import '../../core/models/body_part.dart';
import '../theme/app_neutrals.dart';

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

  static const double _aspect = 200 / 420; // svg viewBox ratio

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final width = height * _aspect;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            gender.silhouetteAsset,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(
              context.neutrals.textFaint.withValues(alpha: 0.30),
              BlendMode.srcIn,
            ),
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
