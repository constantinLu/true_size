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
    required this.onOpenProfile,
    required this.controller,
    required this.onChanged,
  });

  final Uint8List? avatarBytes;
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
                          GestureDetector(
                            onTap: onOpenProfile,
                            child: AvatarCircle(
                              imageBytes: avatarBytes,
                              size: 40,
                              iconSize: 22,
                              backgroundColor: context.neutrals.surfaceHigh,
                              borderColor: context.neutrals.stroke,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              onChanged: onChanged,
                              textInputAction: TextInputAction.search,
                              style: AppTypography.body.copyWith(color: context.neutrals.textPrimary),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                icon: Icon(Icons.search_rounded, size: 20, color: context.neutrals.textSecondary),
                                hintText: 'Search',
                                hintStyle: AppTypography.body.copyWith(color: context.neutrals.textFaint),
                              ),
                            ),
                          ),
                          if (controller.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                controller.clear();
                                onChanged('');
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.close_rounded, size: 20, color: context.neutrals.textSecondary),
                              ),
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
