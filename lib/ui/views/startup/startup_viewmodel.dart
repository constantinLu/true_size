import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/auth_service.dart';

class StartupViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  Future<void> runStartupLogic() async {
    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is already signed in
    if (_authService.isLoggedIn) {
      await _navigationService.clearStackAndShow('/home');
    } else {
      await _navigationService.clearStackAndShow('/login');
    }
  }
}