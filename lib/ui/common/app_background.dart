import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/background_themes.dart';
import '../theme/app_neutrals.dart';
import 'app_widgets.dart';

/// Paints a [BackgroundTheme]'s [asset], picking the right decoder: vector
/// (.svg) themes render through flutter_svg, raster (.jpg) themes through
/// [Image.asset]. Kept in one place so every surface that shows a wallpaper -
/// the app backdrop, the dashboard, and the Settings thumbnails - stays
/// consistent.
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.theme,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final BackgroundTheme theme;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (theme.isVector) {
      return SvgPicture.asset(theme.asset, fit: fit, alignment: alignment);
    }
    return Image.asset(theme.asset, fit: fit, alignment: alignment);
  }
}

/// Full-screen wallpaper shown behind every route when a [BackgroundTheme] is
/// active: the image is blurred and darkened so foreground content stays legible
/// (the "other views" treatment). Wrapped around the whole app in `main.dart`,
/// so page transitions glide over one stable backdrop.
///
/// The dashboard paints its own [DashboardBackground] on top of this, so the
/// Home tab shows the sharp-at-the-top gradient look instead of the blur.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key, required this.theme, required this.child});

  final BackgroundTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = context.neutrals.background;
    return Stack(
      children: [
        // Solid base first, so any letterboxing from the blur clamp reads dark.
        Positioned.fill(child: ColoredBox(color: base)),
        // The blurred wallpaper is static, so isolate it in a RepaintBoundary:
        // it rasterises once and page transitions composite the cached texture
        // instead of re-running the (expensive) blur every frame.
        Positioned.fill(
          child: RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28, tileMode: TileMode.clamp),
              child: BackgroundImage(theme: theme),
            ),
          ),
        ),
        // Darkening scrim so white text and cards read against any wallpaper.
        Positioned.fill(child: ColoredBox(color: base.withValues(alpha: 0.58))),
        child,
      ],
    );
  }
}

/// The Home dashboard backdrop: the wallpaper shown sharp across the top (behind
/// the balance hero) and melting into the solid app background as it descends.
///
/// As the content scrolls the wallpaper reacts: it drifts up at a slower rate
/// (parallax), progressively blurs, and darkens - so by the time you reach the
/// bottom of the list the image has receded into the dark background. Driven by
/// the home [controller] so the scroll view and the backdrop stay in lockstep.
/// Opaque, so it fully covers the blurred [AppBackdrop] behind the Home tab.
class DashboardBackground extends StatelessWidget {
  const DashboardBackground({
    super.key,
    required this.theme,
    required this.controller,
    required this.child,
  });

  final BackgroundTheme theme;
  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = context.neutrals.background;
    // Tall enough to sit behind the enlarged hero and reach into the start of
    // the entries, where the fade to dark begins.
    final imageHeight = MediaQuery.sizeOf(context).height * 0.68;
    // The sharp wallpaper + gradient never changes, so build it once and let it
    // rasterise into a texture (RepaintBoundary). The scroll reaction is carried
    // entirely by the cheap parallax translate + a darkening overlay below - no
    // per-frame image blur, which was the dominant cause of dashboard jank.
    final wallpaper = RepaintBoundary(child: _wallpaper(base));
    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: base)),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, staticWallpaper) {
              final offset = controller.hasClients ? controller.offset : 0.0;
              final scrolled = offset.clamp(0.0, 600.0);
              final parallax = -scrolled * 0.35; // drifts up slower than content
              final darken = (scrolled / 520).clamp(0.0, 0.72); // darkens near the end
              return Transform.translate(
                offset: Offset(0, parallax),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        staticWallpaper!,
                        // Scroll-driven dimming so the image recedes into the
                        // dark background as you reach the bottom of the list.
                        if (darken > 0) ColoredBox(color: base.withValues(alpha: darken)),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: wallpaper,
          ),
        ),
        child,
      ],
    );
  }

  Widget _wallpaper(Color base) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BackgroundImage(theme: theme, alignment: Alignment.topCenter),
        // Top scrim for the status bar / header, and a fade to the solid
        // background over the lower portion so content below sits on dark.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.32),
                Colors.transparent,
                Colors.transparent,
                base.withValues(alpha: 0.55),
                base,
              ],
              stops: const [0.0, 0.16, 0.55, 0.88, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// A scroll-reactive darkening layer for the secondary tabs (Wallet, Analytics)
/// when a wallpaper is active. Those screens are transparent over the app-wide
/// blurred [AppBackdrop], which on its own is not dark enough for the muted grey
/// text on the translucent glass cards to read. This lays a dark scrim over the
/// backdrop - readable from the top and deepening as the list scrolls, mirroring
/// the Home dashboard so the tabs feel consistent. A no-op when no wallpaper is
/// set, since the cards are then solid and already legible.
class TabScrollScrim extends StatelessWidget {
  const TabScrollScrim({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!SurfaceStyle.of(context)) return child;
    final base = context.neutrals.background;
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final offset = controller.hasClients ? controller.offset : 0.0;
                final scrolled = offset.clamp(0.0, 600.0);
                // A readable base darkening at rest, deepening toward the bottom
                // like the dashboard so the muted card text stays legible.
                final darken = (0.4 + scrolled / 600 * 0.4).clamp(0.4, 0.8);
                return IgnorePointer(
                  child: ColoredBox(color: base.withValues(alpha: darken)),
                );
              },
            ),
          ),
        ),
        child,
      ],
    );
  }
}
