import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.router.dart';

import '../../../app/app.locator.dart';
import '../../../core/seed/seed_data.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../../services/update_service.dart';

class StartupViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();
  final _updateService = locator<UpdateService>();

  /// One-off data seeding: build with `--dart-define=SEED=true` to wipe and
  /// re-seed the owner's catalogue, then run again without the flag.
  static const bool _seedOnStartup = bool.fromEnvironment('SEED');

  Future<void> runStartupLogic() async {
    // Load persisted appearance settings (theme, primary color, wallpaper)
    // behind the splash before the first themed screen appears.
    await _settingsService.init();

    // Forced-update gate (Android APK only): if the store's build is newer than
    // this one, send the user to the blocking update screen instead of the app.
    // No-op on web/iOS and fails open on any error, so a slow or unreachable
    // manifest never strands the user on the splash.
    final update = await _updateService.check();
    if (update != null) {
      await _navigationService.navigateToUpdateRequiredView(info: update);
      return;
    }

    if (_seedOnStartup && _authService.isLoggedIn) {
      await runSeed(_authService.currentUser!.uid);
    }

    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(seconds: 1));
    // Check if user is already signed in
    if (_authService.isLoggedIn) {
      await _authService.loadAvatar();
      // Gate behind a biometric lock when enabled and the device supports it.
      if (_settingsService.biometricLock && await _authService.canUseBiometrics()) {
        await _navigationService.navigateToLockView();
      } else {
        // Replace the stack so back can't pop into the startup/login screens.
        await _navigationService.clearStackAndShow(Routes.rootView);
      }
    } else {
      await _navigationService.navigateToLoginView();
    }
  }

//FORM
// - GROUP
// name - BODY
// icon - User selects an icon . Icon.body how does it saves in db?
// color - Color.BLUE
// measurements - EMPTY for now :))
// tags -> #body, #measurements  //select from the selection else create new
// userId -> set the userId from the currently logged user
// createdAt -> now
// updatedAt -> now

// Measurements: >
// icon - User selects an icon
// name - Biceps
// value - 35
// unit - cm
// Brand? = null (this is optional)
// CustomBrand? == null (this is optional)
// Notes? (optional) (Field for writing some notes)
// groupId = at this time (the id is not known !?)

// icon - User selects an icon
// name - Biceps
// value - 35
// unit - cm
// Brand? = null (this is optional)
// CustomBrand? == null (this is optional)
// Notes? (optional) (Field for writing some notes)
// groupId = at this time (the id is not known !?)
}
