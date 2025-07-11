import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_strings.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  Future<void> signInWithGoogle() async {
    setBusy(true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        await _navigationService.clearStackAndShow('/home');
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