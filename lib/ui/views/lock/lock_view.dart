import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import 'lock_viewmodel.dart';

class LockView extends StackedView<LockViewModel> {
  const LockView({super.key});

  @override
  Widget builder(BuildContext context, LockViewModel viewModel, Widget? child) {
    final primary = Theme.of(context).colorScheme.primary;
    final subtitle = viewModel.authenticating
        ? 'Authenticating…'
        : (viewModel.failed ? 'Unlock failed - tap to try again' : 'Unlock to continue');

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  SvgPicture.asset('assets/logos/logo.svg', width: 130, height: 130),
                  const SizedBox(height: 22),
                  Text('TrueSize',
                      style: AppTypography.sectionHeading.copyWith(color: context.neutrals.textPrimary)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle.copyWith(
                        color: viewModel.failed ? const Color(0xFFB36273) : context.neutrals.textSecondary,
                      )),
                  const Spacer(flex: 2),
                  GestureDetector(
                    onTap: viewModel.retry,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(color: primary.withValues(alpha: 0.14), shape: BoxShape.circle),
                      child: viewModel.authenticating
                          ? Padding(
                              padding: const EdgeInsets.all(28),
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: primary))
                          : Icon(Icons.fingerprint_rounded, size: 44, color: primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Tap to unlock', style: AppTypography.caption.copyWith(color: context.neutrals.textFaint)),
                  const Spacer(flex: 2),
                  TextButton(
                    onPressed: viewModel.signOut,
                    child: Text('Sign out', style: AppTypography.button.copyWith(color: context.neutrals.textSecondary)),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LockViewModel viewModelBuilder(BuildContext context) => LockViewModel();

  @override
  void onViewModelReady(LockViewModel viewModel) {
    // Small delay so the logo is seen before the OS biometric sheet appears.
    Future.delayed(const Duration(milliseconds: 500), viewModel.start);
  }
}
