import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_neutrals.dart';
import 'app_widgets.dart';

/// Full-screen detail scaffold: a minimal transparent app bar with a back
/// button and a scrolling body capped to a comfortable reading width. Shared by
/// the entry / stock / loan detail screens so they feel like one family.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    super.key,
    required this.children,
    this.title,
    this.actions,
  });
  final List<Widget> children;
  final String? title;

  /// Optional trailing app-bar actions (e.g. an edit button top-right).
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: title == null ? null : Text(title!),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        centerTitle: false,
        actions: actions,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

/// The top-right "edit" action shared by the entry / stock / loan detail
/// screens. Pass a null [onTap] to disable it (e.g. while the screen is busy).
class DetailEditButton extends StatelessWidget {
  const DetailEditButton({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit_rounded, size: 20),
      onPressed: onTap,
      tooltip: 'Edit',
    );
  }
}

/// Revolut-style detail header: a large colored icon medallion, a headline
/// value, and a title + subtitle underneath.
class DetailHero extends StatelessWidget {
  const DetailHero({
    super.key,
    required this.icon,
    required this.accent,
    required this.value,
    required this.title,
    this.subtitle,
    this.valueColor,
    this.badge,
    this.logoUrl,
    this.onIconTap,
  });

  final IconData icon;
  final Color accent;
  final String value;
  final String title;
  final String? subtitle;
  final Color? valueColor;
  final Widget? badge;

  /// Optional brand logo shown in the medallion instead of [icon] (falling back
  /// to [icon] while it loads or if it fails). Null for details with no logo.
  final String? logoUrl;

  /// When set, the medallion becomes tappable and shows an edit badge - used to
  /// open the icon / logo picker for the entry (works whether or not a logo is
  /// currently set, so the user can switch between an icon and a brand logo).
  final VoidCallback? onIconTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _medallion(context),
        const SizedBox(height: 16),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTypography.largeBalance.copyWith(
            color: valueColor ?? context.neutrals.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.cardTitle.copyWith(
            color: context.neutrals.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: AppTypography.smallMonetary.copyWith(
              color: context.neutrals.textSecondary,
            ),
          ),
        ],
        if (badge != null) ...[const SizedBox(height: 12), badge!],
      ],
    );
  }

  Widget _medallion(BuildContext context) {
    final avatar = EntryAvatar(
      logoUrl: logoUrl,
      icon: icon,
      color: accent,
      size: 72,
      iconSize: 34,
    );
    // The medallion is editable whenever a tap handler is given - the picker
    // itself lets the user switch between a Lucide icon and a brand logo.
    if (onIconTap == null) return avatar;
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onIconTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
                border: Border.all(color: context.neutrals.background, width: 2),
              ),
              child: const Icon(
                Icons.brush_rounded,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small section title used above a detail group / timeline.
class DetailSectionLabel extends StatelessWidget {
  const DetailSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: AppTypography.badge.copyWith(color: context.neutrals.textSecondary),
      ),
    );
  }
}

/// A label → value row used inside detail groups.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.subtitle.copyWith(
              color: context.neutrals.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: valueColor ?? context.neutrals.textPrimary,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTypography.subtitle.copyWith(
                      color: valueColor ?? context.neutrals.textPrimary,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Groups [DetailRow]s inside a [SoftCard] with hairline dividers between them.
class DetailGroup extends StatelessWidget {
  const DetailGroup({super.key, required this.rows});
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Divider(height: 1, thickness: 1, color: context.neutrals.stroke),
          ],
        ],
      ),
    );
  }
}

/// The shared archive + delete action row at the bottom of every detail screen
/// (entries, loans, holdings), so deletion feels the same everywhere. Delete is a
/// small, square, icon-only button on the left - deliberately a low
/// accidental-tap target - and Archive is the larger, labelled action filling the
/// rest. [onDelete] is expected to confirm before it deletes; pass null to either
/// callback to disable that action (e.g. while busy).
class ArchiveDeleteActions extends StatelessWidget {
  const ArchiveDeleteActions({
    super.key,
    required this.archived,
    required this.onToggleArchive,
    required this.onDelete,
  });

  final bool archived;
  final VoidCallback? onToggleArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Small, square, icon-only delete - a low accidental-tap surface.
        SizedBox(
          width: 54,
          height: 54,
          child: OutlinedButton(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.negative,
              side: BorderSide(
                color: AppColors.negative.withValues(alpha: 0.5),
              ),
              backgroundColor: AppColors.negative.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 22,
              color: AppColors.negative,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Archive is the larger, labelled action.
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onToggleArchive,
              icon: Icon(
                archived ? Icons.unarchive_rounded : Icons.archive_rounded,
                size: 20,
                color: context.neutrals.textPrimary,
              ),
              label: Text(
                archived ? 'Unarchive' : 'Archive',
                style: AppTypography.button.copyWith(
                  color: context.neutrals.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.neutrals.textPrimary,
                side: BorderSide(color: context.neutrals.stroke),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
