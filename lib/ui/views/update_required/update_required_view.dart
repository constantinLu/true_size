import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../services/update_service.dart';
import '../../common/app_widgets.dart';
import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'update_required_viewmodel.dart';

/// Full-screen, non-dismissible gate shown when the deployed APK is newer than
/// the running one. The user cannot get past it without installing the update -
/// it blocks back navigation and offers only the "Update now" action. Reached
/// from the startup splash (on launch) and from the shell (on resume) via a
/// newer manifest.
class UpdateRequiredView extends StackedView<UpdateRequiredViewModel> {
  const UpdateRequiredView({required this.info, super.key});

  final UpdateInfo info;

  @override
  UpdateRequiredViewModel viewModelBuilder(BuildContext context) =>
      UpdateRequiredViewModel(info);

  @override
  Widget builder(BuildContext context, UpdateRequiredViewModel viewModel, Widget? child) {
    final n = context.neutrals;
    final primary = Theme.of(context).colorScheme.primary;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: n.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.system_update_rounded, color: primary, size: 38),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Update required',
                        textAlign: TextAlign.center,
                        style: AppTypography.sectionHeading.copyWith(color: n.textPrimary)),
                    const SizedBox(height: 10),
                    Text(
                      _bodyText(),
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(color: n.textSecondary, height: 1.45, fontSize: 14.5),
                    ),
                    const SizedBox(height: 28),
                    _ActionArea(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _bodyText() {
    final named = info.versionName.isNotEmpty ? ' (version ${info.versionName})' : '';
    return 'A new version of TrueSize$named is available. Update now to keep '
        'tracking your sizes - this version is no longer supported.';
  }
}

/// The button / progress / error states, driven by the view model.
class _ActionArea extends StatelessWidget {
  const _ActionArea(this.viewModel);
  final UpdateRequiredViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final n = context.neutrals;
    final primary = Theme.of(context).colorScheme.primary;

    if (viewModel.installing) {
      final progress = viewModel.progress ?? 0;
      final downloading = progress < 1;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: downloading ? progress : null,
              minHeight: 8,
              backgroundColor: n.surfaceHigh,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            downloading ? 'Downloading  ${(progress * 100).round()}%' : 'Opening installer…',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle.copyWith(color: n.textSecondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (viewModel.errorMessage != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 16, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              Flexible(
                child: Text(viewModel.errorMessage!,
                    style: AppTypography.caption.copyWith(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 52,
          child: PressableScale.wrap(
            child: ElevatedButton.icon(
              onPressed: viewModel.startUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.download_rounded, size: 20),
              label: Text(viewModel.errorMessage != null ? 'Try again' : 'Update now',
                  style: AppTypography.button.copyWith(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
