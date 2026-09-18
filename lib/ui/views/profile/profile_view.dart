import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/constants/background_themes.dart';
import '../../../core/enums/gender.dart';
import '../../common/app_background.dart';
import '../../common/app_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _header(context, viewModel),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _appearanceCard(context, viewModel),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _bodyCard(context, viewModel),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _backgroundCard(context, viewModel),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _aboutCard(context, viewModel),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _signOutButton(context, viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ProfileViewModel vm) {
    final primary = Theme.of(context).colorScheme.primary;
    final photo = vm.photoUrl;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary, primary.withValues(alpha: 0.55), primary.withValues(alpha: 0.0)],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: vm.close,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.18)),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _avatar(context, vm, photo),
              const SizedBox(height: 14),
              Text(vm.displayName, style: AppTypography.sectionHeading.copyWith(color: Colors.white)),
              if (vm.email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(vm.email, style: AppTypography.subtitle.copyWith(color: Colors.white70)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, ProfileViewModel vm, String? photo) {
    final primary = Theme.of(context).colorScheme.primary;
    final bytes = vm.avatarBytes;
    Widget image;
    if (bytes != null) {
      image = Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
    } else if (photo != null && photo.isNotEmpty) {
      image = Image.network(photo, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, color: Colors.white, size: 44));
    } else {
      image = const Icon(Icons.person_rounded, color: Colors.white, size: 44);
    }
    return GestureDetector(
      onTap: vm.uploadingAvatar ? null : () => _editAvatar(context, vm),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 88,
            height: 88,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: Center(child: image),
          ),
          if (vm.uploadingAvatar)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.35)),
                child: const Center(
                  child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                ),
              ),
            ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primary, border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editAvatar(BuildContext context, ProfileViewModel vm) async {
    if (!vm.hasAvatar) {
      await vm.pickAndUploadAvatar();
      return;
    }
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.neutrals.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 44, height: 4,
                decoration: BoxDecoration(color: ctx.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(100))),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: ctx.neutrals.textPrimary),
              title: Text('Change photo',
                  style: AppTypography.body.copyWith(color: ctx.neutrals.textPrimary, fontWeight: AppTypography.medium)),
              onTap: () => Navigator.pop(ctx, 'change'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFB36273)),
              title: Text('Remove photo',
                  style: AppTypography.body.copyWith(color: const Color(0xFFB36273), fontWeight: AppTypography.medium)),
              onTap: () => Navigator.pop(ctx, 'remove'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == 'change') {
      await vm.pickAndUploadAvatar();
    } else if (action == 'remove') {
      await vm.removeAvatar();
    }
  }

  Widget _appearanceCard(BuildContext context, ProfileViewModel vm) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          Text('Theme',
              style: AppTypography.smallMonetary
                  .copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
          const SizedBox(height: 10),
          _themeSelector(context, vm),
          const SizedBox(height: 22),
          Text('Primary color',
              style: AppTypography.smallMonetary
                  .copyWith(color: context.neutrals.textSecondary, fontWeight: AppTypography.medium)),
          const SizedBox(height: 12),
          _colorSwatches(context, vm),
        ],
      ),
    );
  }

  Widget _themeSelector(BuildContext context, ProfileViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: context.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          _segment(context, vm, ThemeMode.light, 'Light', Icons.light_mode_rounded),
          _segment(context, vm, ThemeMode.dark, 'Dark', Icons.dark_mode_rounded),
          _segment(context, vm, ThemeMode.system, 'System', Icons.phone_iphone_rounded),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, ProfileViewModel vm, ThemeMode mode, String label, IconData icon) {
    final selected = vm.themeMode == mode;
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setThemeMode(mode),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: selected ? BoxDecoration(color: primary, borderRadius: BorderRadius.circular(10)) : null,
          child: Column(
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : context.neutrals.textSecondary),
              const SizedBox(height: 4),
              Text(label,
                  style: AppTypography.tabLabel
                      .copyWith(color: selected ? Colors.white : context.neutrals.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorSwatches(BuildContext context, ProfileViewModel vm) {
    const columns = 5;
    const spacing = 12.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final c in vm.colorChoices)
              GestureDetector(
                onTap: () => vm.setPrimaryColor(c),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(14),
                    border: c.toARGB32() == vm.primaryColor.toARGB32()
                        ? Border.all(color: context.neutrals.textPrimary, width: 3)
                        : null,
                  ),
                  child: c.toARGB32() == vm.primaryColor.toARGB32()
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _bodyCard(BuildContext context, ProfileViewModel vm) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Body', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('The silhouette used on the Body-measurements tab',
              style: AppTypography.smallMonetary.copyWith(color: context.neutrals.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: context.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                _genderSegment(context, vm, Gender.male, Icons.male_rounded),
                _genderSegment(context, vm, Gender.female, Icons.female_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderSegment(BuildContext context, ProfileViewModel vm, Gender gender, IconData icon) {
    final selected = vm.gender == gender;
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setGender(gender),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: selected ? BoxDecoration(color: primary, borderRadius: BorderRadius.circular(10)) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : context.neutrals.textSecondary),
              const SizedBox(width: 8),
              Text(gender.label,
                  style: AppTypography.button.copyWith(
                      color: selected ? Colors.white : context.neutrals.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backgroundCard(BuildContext context, ProfileViewModel vm) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Background', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('A wallpaper behind your dashboard and screens',
              style: AppTypography.smallMonetary.copyWith(color: context.neutrals.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 136,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: vm.backgroundThemes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _backgroundThumb(context, vm, vm.backgroundThemes[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundThumb(BuildContext context, ProfileViewModel vm, BackgroundTheme theme) {
    final primary = Theme.of(context).colorScheme.primary;
    final selected = vm.backgroundTheme.id == theme.id;
    return GestureDetector(
      onTap: () => vm.setBackgroundTheme(theme),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 74,
            height: 108,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? primary : context.neutrals.surfaceHigh, width: selected ? 3 : 1.5),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (theme.isNone)
                  Container(
                    color: context.neutrals.surfaceHigh,
                    alignment: Alignment.center,
                    child: Icon(Icons.block_rounded, color: context.neutrals.textFaint, size: 26),
                  )
                else
                  BackgroundImage(theme: theme),
                if (selected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
                      child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 74,
            child: Text(
              theme.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tabLabel.copyWith(
                color: selected ? primary : context.neutrals.textSecondary,
                fontWeight: selected ? AppTypography.medium : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutCard(BuildContext context, ProfileViewModel vm) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _infoRow(context, 'Version', vm.versionLabel),
          const SizedBox(height: 10),
          _infoRow(context, 'Build date', vm.buildDateLabel),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(color: context.neutrals.surfaceHigh, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Text(label, style: AppTypography.body.copyWith(color: context.neutrals.textSecondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body
                    .copyWith(color: context.neutrals.textPrimary, fontWeight: AppTypography.medium)),
          ),
        ],
      ),
    );
  }

  Widget _signOutButton(BuildContext context, ProfileViewModel vm) {
    const danger = Color(0xFFB36273);
    return GestureDetector(
      onTap: vm.signOut,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: danger, width: 1.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 19, color: danger),
            const SizedBox(width: 8),
            Text('Sign out', style: AppTypography.button.copyWith(color: danger)),
          ],
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
