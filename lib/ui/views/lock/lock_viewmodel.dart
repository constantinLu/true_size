import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';

/// Guards the app when the user is already logged in: prompts a fingerprint /
/// face unlock. Falls back to a "Sign out" escape so the user is never fully
/// locked out (there is no PIN in TrueSize).
class LockViewModel extends BaseViewModel {
  final _auth = locator<AuthService>();
  final _settings = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  bool _authenticating = false;
  bool _failed = false;

  bool get authenticating => _authenticating;
  bool get failed => _failed;

  Future<void> start() async {
    // Safety: if the lock isn't needed, just go straight in.
    if (_auth.isUnlocked || !_settings.biometricLock || !await _auth.canUseBiometrics()) {
      _enter();
      return;
    }
    await _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    _authenticating = true;
    _failed = false;
    rebuildUi();
    final ok = await _auth.authenticateBiometric();
    _authenticating = false;
    if (ok) {
      _enter();
    } else {
      _failed = true;
      rebuildUi();
    }
  }

  Future<void> retry() async {
    if (_authenticating) return;
    await _tryBiometric();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _navigationService.clearStackAndShow(Routes.loginView);
  }

  void _enter() {
    _auth.markUnlocked();
    _navigationService.clearStackAndShow(Routes.rootView);
  }
}
