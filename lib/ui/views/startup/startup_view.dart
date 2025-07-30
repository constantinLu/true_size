import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:true_size/ui/theme/theme_extension.dart';

import '../../common/ui_helpers.dart';
import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(BuildContext context, StartupViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: context.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            SvgPicture.asset(
              'assets/logos/logo.svg',
              width: 10.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            UIHelpers.verticalSpaceLarge,
            // App Name
            const Text(
              'TrueSize',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            UIHelpers.verticalSpaceLarge,

            // Loading Indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => viewModel.runStartupLogic();
}
