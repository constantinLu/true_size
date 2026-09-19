import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/constants/background_themes.dart';
import '../../../core/constants/dates.dart';
import '../../../core/enums/gender.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../common/confirm_sheet.dart';

class ProfileViewModel extends BaseViewModel {
  final _settings = locator<SettingsService>();
  final _auth = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _imagePicker = ImagePicker();

  ProfileViewModel() {
    _auth.addListener(rebuildUi);
    _loadVersion();
  }

  String get displayName {
    final name = _auth.currentUser?.displayName;
    return (name == null || name.isEmpty) ? 'TrueSize user' : name;
  }

  String get email => _auth.currentUser?.email ?? '';
  String? get photoUrl => _auth.currentUser?.photoURL;

  /// The uploaded avatar bytes (null when using the Google photo / icon).
  Uint8List? get avatarBytes => _auth.avatarBytes;
  bool get hasAvatar => _auth.avatarBytes != null;

  bool _uploadingAvatar = false;
  bool get uploadingAvatar => _uploadingAvatar;

  /// Picks an image from the gallery, downscales it and stores it (base64) on
  /// the user's Firestore document. The top-bar chip updates automatically.
  Future<void> pickAndUploadAvatar() async {
    if (_uploadingAvatar) return;
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    _uploadingAvatar = true;
    rebuildUi();
    try {
      await _auth.uploadAvatar(bytes);
    } finally {
      _uploadingAvatar = false;
      rebuildUi();
    }
  }

  Future<void> removeAvatar() async {
    await _auth.removeAvatar();
    rebuildUi();
  }

  ThemeMode get themeMode => _settings.themeMode;
  Color get primaryColor => _settings.primaryColor;
  List<Color> get colorChoices => SettingsService.primaryChoices;

  List<BackgroundTheme> get backgroundThemes => BackgroundThemes.all;
  BackgroundTheme get backgroundTheme => _settings.backgroundTheme;

  Gender get gender => _settings.gender;
  void setGender(Gender gender) {
    _settings.setGender(gender);
    rebuildUi();
  }

  bool get biometricLock => _settings.biometricLock;
  void setBiometricLock(bool value) {
    _settings.setBiometricLock(value);
    rebuildUi();
  }

  String _version = '';
  String _build = '';
  String get versionLabel {
    if (_version.isEmpty) return '-';
    return _build.isEmpty ? 'v$_version' : 'v$_version build $_build';
  }

  /// The build date/time (date + hour:minute). Injected at build time with
  /// `--dart-define=BUILD_TIME=<ISO8601>`; falls back to the current time so a
  /// dev build still shows a real timestamp.
  final DateTime _buildTime = _resolveBuildTime();
  String get buildDateLabel => formatDateTime(_buildTime);

  static DateTime _resolveBuildTime() {
    const raw = String.fromEnvironment('BUILD_TIME');
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      _build = info.buildNumber;
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

  Future<void> signOut(BuildContext context) async {
    final confirmed = await showConfirmSheet(
      context,
      title: 'Sign out',
      message: 'Are you sure you want to sign out?',
      confirmLabel: 'Sign out',
      danger: true,
      icon: Icons.logout_rounded,
    );
    if (confirmed) {
      await _auth.signOut();
      await _navigationService.clearStackAndShow('/login');
    }
  }

  void close() => _navigationService.back();

  @override
  void dispose() {
    _auth.removeListener(rebuildUi);
    super.dispose();
  }
}
