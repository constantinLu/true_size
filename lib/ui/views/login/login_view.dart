import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../theme/app_neutrals.dart';
import '../../theme/app_typography.dart';
import '../../theme/color_utils.dart';
import 'login_viewmodel.dart';

const _heroShadows = [Shadow(color: Color(0x59000000), blurRadius: 12, offset: Offset(0, 2))];

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel, Widget? child) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Column(
        children: [
          // Branded hero.
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: brandGradient(primary),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo on a soft white disc so the teal mark reads on the gradient.
                      Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: SvgPicture.asset('assets/logos/logo.svg'),
                      ),
                      const SizedBox(height: 24),
                      Text('TrueSize',
                          style: AppTypography.displayBalance
                              .copyWith(color: Colors.white, fontSize: 40, shadows: _heroShadows)),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Every size you forget - shoes, jeans, bedding and body - in one calm place.',
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                              color: Colors.white.withValues(alpha: 0.9), height: 1.4, shadows: _heroShadows),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Sign-in section.
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              children: [
                Text('Sign in to sync your sizes across devices',
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle.copyWith(color: context.neutrals.textSecondary)),
                const SizedBox(height: 18),
                _GoogleButton(busy: viewModel.isBusy, onTap: viewModel.signInWithGoogle),
              ],
            ),
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('by DevLab',
                  style: AppTypography.caption.copyWith(color: context.neutrals.textFaint)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.busy, required this.onTap});
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E2E6)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (busy)
              const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Color(0xFF4285F4))))
            else ...[
              Image.asset('assets/icons/google_logo.png', width: 22, height: 22),
              const SizedBox(width: 12),
              Text('Continue with Google',
                  style: AppTypography.button.copyWith(color: const Color(0xFF1F1F1F), fontWeight: AppTypography.medium)),
            ],
          ],
        ),
      ),
    );
  }
}
