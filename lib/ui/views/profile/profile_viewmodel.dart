import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/constants/background_themes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _settings = locator<SettingsService>();
  final _auth = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  ProfileViewModel() {
    _loadVersion();
  }

  String get displayName {
    final name = _auth.currentUser?.displayName;
    return (name == null || name.isEmpty) ? 'TrueSize user' : name;
  }

  String get email => _auth.currentUser?.email ?? '';
  String? get photoUrl => _auth.currentUser?.photoURL;

  ThemeMode get themeMode => _settings.themeMode;
  Color get primaryColor => _settings.primaryColor;
  List<Color> get colorChoices => SettingsService.primaryChoices;

  List<BackgroundTheme> get backgroundThemes => BackgroundThemes.all;
  BackgroundTheme get backgroundTheme => _settings.backgroundTheme;

  String _version = '';
  String get versionLabel => _version.isEmpty ? '-' : 'v$_version';

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      rebuildUi();
    } catch (_) {
      // Version is best-effort; leave the placeholder if it can't be read.
    }
  }

  void setThemeMode(ThemeMode mode) {
    _settings.setThemeMode(mode);
    rebuildUi();
  }

  void setPrimaryColor(Color color) {
    _settings.setPrimaryColor(color);
    rebuildUi();
  }

  void setBackgroundTheme(BackgroundTheme theme) {
    _settings.setBackgroundTheme(theme);
    rebuildUi();
  }

  Future<void> signOut() async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Sign out',
      description: 'Are you sure you want to sign out?',
      confirmationTitle: 'Sign out',
      cancelTitle: 'Cancel',
    );
    if (result?.confirmed == true) {
      await _auth.signOut();
      await _navigationService.clearStackAndShow('/login');
    }
  }

  void close() => _navigationService.back();
}
