import 'dart:typed_data';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// The floating frosted top bar shown on every main tab: the user chip (opens
/// settings) on the left and a working search field filling the rest. Mirrors
/// the bottom navigation's floating-pill look.
class FloatingTopBar extends StatelessWidget {
  const FloatingTopBar({
    super.key,
    required this.avatarBytes,
    this.photoUrl,
    required this.onOpenProfile,
    required this.controller,
    required this.onChanged,
  });

  final Uint8List? avatarBytes;
  final String? photoUrl;
  final VoidCallback onOpenProfile;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: context.neutrals.surface.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: context.neutrals.surfaceHigh.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        children: [
                          PressableScale(
                            onTap: onOpenProfile,
                            child: AvatarCircle(
                              imageBytes: avatarBytes,
                              photoUrl: photoUrl,
                              size: 40,
                              iconSize: 22,
                              backgroundColor: context.neutrals.surfaceHigh,
                              borderColor: context.neutrals.stroke,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Search has its own framed box inside the bar.
                          Expanded(
                            child: _SearchBox(controller: controller, onChanged: onChanged),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The framed search field inside the top bar. On focus it lifts subtly - a
/// calm primary halo, a brighter border and a ~1.5% grow - as tap feedback.
class _SearchBox extends StatefulWidget {
  const _SearchBox({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (_focus.hasFocus != _focused) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return AnimatedScale(
      scale: _focused ? 1.015 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.neutrals.surfaceHigh.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _focused
                ? primary.withValues(alpha: 0.85)
                : context.neutrals.textFaint.withValues(alpha: 0.25),
            width: _focused ? 1.5 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 14,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                size: 19,
                color: _focused ? primary : context.neutrals.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                onChanged: widget.onChanged,
                textInputAction: TextInputAction.search,
                style: AppTypography.body.copyWith(color: context.neutrals.textPrimary),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: AppTypography.body.copyWith(color: context.neutrals.textFaint),
                ),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              PressableScale(
                onTap: () {
                  widget.controller.clear();
                  widget.onChanged('');
                },
                child: Icon(Icons.close_rounded, size: 18, color: context.neutrals.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
