import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import '../theme/app_typography.dart';
import '../theme/app_neutrals.dart';

/// Centres content and caps its width so wide (tablet/desktop/web) layouts do
/// not stretch edge-to-edge. Full-width on phones where the screen is narrower
/// than [maxWidth]. Per-breakpoint layout switching itself is done with
/// `ScreenTypeLayout.builder` inside each view.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({super.key, required this.maxWidth, required this.child});
  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// A circular avatar that shows the user's uploaded photo ([imageBytes]) when`
/// one is set, and otherwise falls back to a person icon. Used both for the
/// small chip in the home hero and the large avatar in the profile header, so
/// the same image renders consistently everywhere. The bytes are held in memory
/// (loaded from Firestore), so there is no network fetch or loading state.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    this.imageBytes,
    required this.size,
    required this.iconSize,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
  });

  final Uint8List? imageBytes;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.white.withValues(alpha: 0.2);
    final fallback = Icon(
      Icons.person_rounded,
      size: iconSize,
      color: Colors.white,
    );
    final bytes = imageBytes;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: bytes != null && bytes.isNotEmpty
          ? Image.memory(
              bytes,
              fit: BoxFit.cover,
              width: size,
              height: size,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => Center(child: fallback),
            )
          : Center(child: fallback),
    );
  }
}

/// The circular medallion shown for an entry: the brand [logoUrl] (resolved
/// from the entry name via logo.dev when it was created) sitting on a solid
/// [color] fill, falling back to the category [icon] - drawn in white on that
/// same fill - when no logo was found. While the logo loads - and if it fails to
/// load - the icon is shown, so the medallion is never empty and always has a
/// sensible default.
class EntryAvatar extends StatelessWidget {
  const EntryAvatar({
    super.key,
    required this.logoUrl,
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  final String? logoUrl;
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl != null && logoUrl!.isNotEmpty;
    // Brand logos (often transparent PNGs) sit on white so no accent tint bleeds
    // through; the icon fallback keeps the tinted [color] disc. The fallback icon
    // is drawn in [color] over white when a logo is expected so it stays visible.
    final fallback = Icon(icon, size: iconSize, color: hasLogo ? color : Colors.white);
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: hasLogo ? Colors.white : color,
        shape: BoxShape.circle,
      ),
      child: hasLogo
          // Fill the whole circle: cover edge-to-edge (the circle clip rounds
          // off the corners so it reads as a proper app-icon mark).
          ? Image.network(
              logoUrl!,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (_, _, _) => Center(child: fallback),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : Center(child: fallback),
            )
          : Center(child: fallback),
    );
  }
}

/// App-wide surface styling, provided once at the app root so it acts as a
/// single global switch. When [glass] is true every [SoftCard] that doesn't set
/// its own `glass` (and doesn't pass a custom `color`) renders as a translucent
/// frosted panel, so cards let a wallpaper background show through everywhere -
/// not just on the dashboard. Off by default, so the plain (no wallpaper) look
/// is unchanged.
class SurfaceStyle extends InheritedWidget {
  const SurfaceStyle({super.key, required this.glass, required super.child});

  final bool glass;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SurfaceStyle>()?.glass ??
      false;

  @override
  bool updateShouldNotify(SurfaceStyle oldWidget) => glass != oldWidget.glass;
}

/// A soft raised surface used everywhere as the base container. Pass [onTap] to
/// make the whole card tappable with a ripple (clipped to the rounded corners).
///
/// [glass] controls the frosted look: a translucent dark fill over a backdrop
/// blur so the wallpaper behind shows through faintly (the Revolut look). Left
/// null (the default) it follows the global [SurfaceStyle] - on when a wallpaper
/// is active - unless a custom [color] is given, in which case the card stays
/// that solid colour. Pass true/false to force it for one card.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.radius = 24,
    this.onTap,
    this.glass,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;
  final bool? glass;

  @override
  Widget build(BuildContext context) {
    // A card with an explicit colour keeps it; otherwise follow the per-card
    // override, then the global glass config.
    final effectiveGlass = glass ?? (color == null && SurfaceStyle.of(context));
    final border = BorderRadius.circular(radius);
    final fill = effectiveGlass
        ? Colors.white.withValues(alpha: 0.18)
        : (color ?? context.neutrals.surface);
    // Border matches the fill so the rim is seamless with the card body.
    final borderColor = effectiveGlass ? fill : context.neutrals.stroke;

    Widget result;
    if (onTap == null) {
      result = Container(
        padding: padding,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: border,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: child,
      );
    } else {
      // The fill lives on the Material so the InkWell ripple is visible above it.
      result = Material(
        color: fill,
        borderRadius: border,
        child: InkWell(
          onTap: onTap,
          borderRadius: border,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: border,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: child,
          ),
        ),
      );
    }

    if (!effectiveGlass) return result;
    // A dark scrim under the translucent fill keeps content legible over bright
    // wallpapers. There is deliberately no per-card BackdropFilter here: the
    // app-wide AppBackdrop already blurs the whole wallpaper, so a translucent
    // scrim reads the same as a frosted panel while avoiding a backdrop-blur
    // layer per card - the single biggest cost when scrolling a screen of cards.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: border,
      ),
      child: result,
    );
  }
}

/// A round frosted-glass surface: a backdrop blur under a translucent white fill
/// with a hairline rim. Its [child] (usually a coloured icon) sits on top. Used
/// for the dashboard's quick-action and income/expense buttons so only the icon
/// carries colour and the wallpaper shows through the disc.
class GlassCircle extends StatelessWidget {
  const GlassCircle({
    super.key,
    required this.size,
    required this.child,
    this.onTap,
  });

  final double size;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disc = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: size,
          height: size,
          // No rim: the disc reads as one seamless frosted shape. Made a bit
          // more opaque + slightly darker so the icon reads on bright wallpapers.
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x80EEF0F3),
          ),
          child: Center(child: child),
        ),
      ),
    );
    if (onTap == null) return disc;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: disc,
    );
  }
}

/// A circular medallion: an [icon] centred on a tinted disc. The disc is a faint
/// wash of [color] and the icon is drawn in that same colour; pass no [color] and
/// it falls back to a neutral surface disc with a secondary-text icon. This is
/// the single source for the tinted-circle-icon repeated across stock, loan,
/// installment, report and empty-state chips, so they can never drift apart.
class IconMedallion extends StatelessWidget {
  const IconMedallion({
    super.key,
    required this.icon,
    this.color,
    this.size = 40,
    this.iconSize = 20,
    this.tint = 0.16,
  });

  final IconData icon;
  final Color? color;
  final double size;
  final double iconSize;

  /// Opacity of the disc fill when a [color] is given.
  final double tint;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.neutrals.textSecondary;
    final fill = color == null
        ? context.neutrals.surfaceHigh
        : c.withValues(alpha: tint);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
      child: Icon(icon, size: iconSize, color: c),
    );
  }
}

/// Small rounded tag - used for Fixed/Variable and category labels.
class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.color,
    this.filled = false,
    this.large = false,
  });
  final String text;
  final Color? color;
  final bool filled;

  /// A roomier chip with more padding and a slightly larger label - used where
  /// the pill sits on its own line and can breathe (e.g. the loan breakdown).
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.neutrals.textSecondary;
    return Container(
      padding: large
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? c.withValues(alpha: 0.16) : Colors.transparent,
        borderRadius: BorderRadius.circular(large ? 10 : 8),
        border: Border.all(color: c.withValues(alpha: filled ? 0.0 : 0.4)),
      ),
      child: Text(
        text,
        style: (large ? AppTypography.subtitle : AppTypography.badge).copyWith(
          color: c,
          fontWeight: AppTypography.medium,
        ),
      ),
    );
  }
}

/// Circular quick-action button with a label underneath. Pass [color] to tint
/// the icon and give the circle a matching soft fill (defaults to a neutral
/// surface with the primary text color).
class CircleAction extends StatelessWidget {
  const CircleAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color == null
              ? context.neutrals.surfaceHigh
              : color!.withValues(alpha: 0.16),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                icon,
                color: color ?? context.neutrals.textPrimary,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: context.neutrals.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// A Revolut-style circular back button, shown top-left on the dashboard tabs
/// (and any inner screen that wants the softer, filled affordance rather than
/// the plain app-bar arrow). Pops the current route by default.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.neutrals.surfaceHigh,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: context.neutrals.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// A compact toggle for showing / hiding archived items, shown top-right on the
/// income, expense and wallet screens. Reads as a muted outline when archived
/// items are hidden (the default) and switches to a filled, primary-tinted mark
/// when they are being shown, so the icon itself signals the current state.
class ArchiveToggle extends StatelessWidget {
  const ArchiveToggle({super.key, required this.showing, required this.onTap});

  /// Whether archived items are currently visible.
  final bool showing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return IconButton(
      onPressed: onTap,
      tooltip: showing ? 'Hide archived' : 'Show archived',
      icon: Icon(
        showing ? Icons.archive_rounded : Icons.archive_outlined,
        size: 22,
        color: showing ? primary : context.neutrals.textSecondary,
      ),
    );
  }
}

/// The dashboard top bar shared by the Home, Wallet and Analytics tabs: a
/// profile avatar (tap to open Settings), a search pill that opens search, and
/// an optional [trailing] action to its right. Pass [light] on a coloured hero
/// (gradient or wallpaper) so it renders white / translucent; left false it uses
/// the theme surface colours for a plain background.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.avatarBytes,
    required this.onOpenProfile,
    required this.onSearch,
    this.trailing,
    this.light = false,
  });

  final Uint8List? avatarBytes;
  final VoidCallback onOpenProfile;
  final VoidCallback onSearch;

  /// Optional action shown to the right of the search pill (e.g. the analytics
  /// shortcut on Home or the archive toggle on Wallet). Null lets the search
  /// pill run to the edge.
  final Widget? trailing;

  /// White / translucent styling for a coloured hero when true; theme surface
  /// styling otherwise.
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onOpenProfile,
          child: AvatarCircle(
            imageBytes: avatarBytes,
            size: 40,
            iconSize: 22,
            borderColor: light
                ? Colors.white.withValues(alpha: 0.35)
                : context.neutrals.stroke,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _HeaderSearchPill(onTap: onSearch, light: light)),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class _HeaderSearchPill extends StatelessWidget {
  const _HeaderSearchPill({required this.onTap, required this.light});
  final VoidCallback onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final fill = light
        ? Colors.white.withValues(alpha: 0.18)
        : context.neutrals.surfaceHigh;
    final fg = light ? Colors.white70 : context.neutrals.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 18, color: fg),
            const SizedBox(width: 8),
            Text('Search', style: AppTypography.subtitle.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}

/// A circular action styled to sit in a [DashboardHeader]: a 40pt disc with a
/// centred [icon]. Pass [light] on a coloured hero, and [active] to tint it with
/// the primary colour (e.g. the archive toggle when archived items are shown).
class HeaderCircleButton extends StatelessWidget {
  const HeaderCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.light = false,
    this.active = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool light;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final fill = light
        ? Colors.white.withValues(alpha: 0.18)
        : context.neutrals.surfaceHigh;
    final fg = active
        ? primary
        : (light ? Colors.white : context.neutrals.textPrimary);
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: fill),
        child: Icon(icon, size: 20, color: fg),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action});
  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (action != null)
            Text(
              action!,
              style: AppTypography.tabLabel.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Friendly placeholder shown in a section that has no data yet. Sits inside a
/// [SoftCard] so it matches the surrounding cards on every screen.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });
  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          IconMedallion(icon: icon, size: 52, iconSize: 24),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.listItemTitle.copyWith(
              color: context.neutrals.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTypography.smallMonetary.copyWith(
                color: context.neutrals.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The Wadger brand mark: a photographic wad of banknotes - a stack of bills
/// bound by a blue strap - named for "wad" (a lump of money). Rendered from the
/// transparent-background logo asset (assets/logo/wad.png, keyed out of
/// wad.svg by tool/build_brand_assets.dart) so it sits cleanly on any
/// background.
class WadgerLogo extends StatelessWidget {
  const WadgerLogo({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/wad.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// Donut chart used in Analytics. Renders proportional arcs with a gap.
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.slices,
    this.size = 200,
    this.centerTop,
    this.centerBottom,
  });
  final List<DonutSlice> slices;
  final double size;
  final String? centerTop;
  final String? centerBottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size(size, size), painter: _DonutPainter(slices)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (centerTop != null)
                Text(
                  centerTop!,
                  style: AppTypography.caption.copyWith(
                    color: context.neutrals.textSecondary,
                  ),
                ),
              if (centerBottom != null)
                Text(
                  centerBottom!,
                  style: AppTypography.sectionHeading.copyWith(
                    color: context.neutrals.textPrimary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutSlice {
  const DonutSlice(this.value, this.color);
  final double value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices);
  final List<DonutSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) return;
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ).deflate(size.width * 0.12);
    const gap = 0.06; // radians between slices
    double start = -math.pi / 2 + gap / 2;
    final stroke = size.width * 0.14;
    for (final slice in slices) {
      final sweep = (slice.value / total) * (2 * math.pi) - gap;
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, start, math.max(sweep, 0.001), false, paint);
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Revolut-style vertical bar chart used in Analytics. Renders one rounded bar
/// per value, each rising from a muted full-height track and animating up on
/// first build, with an optional category icon chip beneath every bar. Bars
/// share the available width equally, so pass a curated set (the tallest few)
/// rather than an unbounded list.
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.bars,
    this.height = 150,
    this.barWidth = 22,
  });

  final List<BarData> bars;

  /// Height of the plotted bar area (labels sit below this).
  final double height;

  /// Width of an individual bar; columns are wider than this and centre the bar.
  final double barWidth;

  @override
  Widget build(BuildContext context) {
    final maxValue = bars.fold<double>(0, (m, b) => b.value > m ? b.value : m);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final bar in bars)
          Expanded(
            child: _BarColumn(
              bar: bar,
              fraction: maxValue <= 0 ? 0 : bar.value / maxValue,
              areaHeight: height,
              barWidth: barWidth,
            ),
          ),
      ],
    );
  }
}

/// One bar in a [BarChart]: a value, the colour it is drawn in, and an optional
/// icon shown in a tinted chip beneath the bar to identify it.
class BarData {
  const BarData({required this.value, required this.color, this.icon});
  final double value;
  final Color color;
  final IconData? icon;
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.bar,
    required this.fraction,
    required this.areaHeight,
    required this.barWidth,
  });

  final BarData bar;
  final double fraction;
  final double areaHeight;
  final double barWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: areaHeight,
          width: barWidth,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Muted track spanning the full height.
              Container(
                decoration: BoxDecoration(
                  color: context.neutrals.surfaceHigh,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              // Coloured fill, rising from the bottom and animating on build.
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
                builder: (context, value, _) => FractionallySizedBox(
                  // Keep a sliver visible so tiny categories still read as bars.
                  heightFactor: value <= 0.02 ? 0.02 : value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [bar.color.withValues(alpha: 0.7), bar.color],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (bar.icon != null) ...[
          const SizedBox(height: 12),
          IconMedallion(
            icon: bar.icon!,
            color: bar.color,
            size: 30,
            iconSize: 16,
          ),
        ],
      ],
    );
  }
}
