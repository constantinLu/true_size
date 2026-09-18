import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.router.dart';

import '../../../app/app.locator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  Future<void> signInWithGoogle() async {
    setBusy(true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        await _navigationService.navigateToRootView();
      }
    } catch (e) {
      _snackbarService.showSnackbar(
        message: AppStrings.signInError,
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }
}
