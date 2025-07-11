import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'login_viewmodel.dart';
import '../../common/ui_helpers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      LoginViewModel viewModel,
      Widget? child,
      ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: UIHelpers.screenPadding,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [UIHelpers.defaultShadow],
                        ),
                        child: const Center(
                          child: Text(
                            '📏',
                            style: TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                      UIHelpers.verticalSpaceLarge,
                      UIHelpers.verticalSpaceLarge,

                      // Welcome Text
                      const Text(
                        AppStrings.welcomeTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      UIHelpers.verticalSpaceMedium,
                      const Text(
                        AppStrings.appTagline,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      UIHelpers.verticalSpaceLarge,
                      UIHelpers.verticalSpaceLarge,

                      // Google Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: viewModel.isBusy ? null : viewModel.signInWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: UIHelpers.defaultBorderRadius,
                              side: const BorderSide(color: AppColors.border),
                            ),
                          ),
                          icon: viewModel.isBusy
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                              : Image.asset(
                            'assets/icons/google_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text(
                            AppStrings.continueWithGoogle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}