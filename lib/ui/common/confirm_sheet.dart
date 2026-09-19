import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../theme/app_neutrals.dart';
import '../theme/app_typography.dart';

/// A confirm/cancel prompt shown as a bottom sheet (never a center dialog).
/// Returns true when the user confirms. Use [danger] for destructive actions
/// so the confirm button reads as a warning.
Future<bool> showConfirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool danger = false,
  IconData? icon,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.neutrals.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => _ConfirmSheet(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      danger: danger,
      icon: icon,
    ),
  );
  return result ?? false;
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.danger,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool danger;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? AppColors.negative : Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: context.neutrals.surfaceHigh,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (icon != null) ...[
              Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.14),
                  ),
                  child: Icon(icon, color: accent, size: 26),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Text(title,
                textAlign: TextAlign.center,
                style: AppTypography.sectionHeading.copyWith(color: context.neutrals.textPrimary)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary, height: 1.4)),
            const SizedBox(height: 22),
            _SheetButton(
              label: confirmLabel,
              color: accent,
              textColor: Colors.white,
              onTap: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 10),
            _SheetButton(
              label: cancelLabel,
              color: context.neutrals.surfaceHigh,
              textColor: context.neutrals.textPrimary,
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style: AppTypography.button.copyWith(color: textColor, fontWeight: AppTypography.semibold)),
      ),
    );
  }
}
