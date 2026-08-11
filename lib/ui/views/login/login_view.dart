import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:true_size/ui/theme/theme_extension.dart';

import '../../../core/constants/app_strings.dart';
import '../../common/ui_helpers.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (ctx, sizingInformation) {
        return Scaffold(
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
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      UIHelpers.verticalSpaceMedium,
                      const Text(
                        AppStrings.appTagline,
                        style: TextStyle(
                          fontSize: 16,
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
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: UIHelpers.defaultBorderRadius,
                            ),
                          ),
                          icon: viewModel.isBusy
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                                  ),
                                )
                              : Image.asset(
                                  'assets/icons/google_logo.png',
                                  width: 24,
                                  height: 24,
                                ),
                          label: const Text(AppStrings.continueWithGoogle,
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
