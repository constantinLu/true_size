import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/constants/background_themes.dart';
import '../core/enums/gender.dart';

/// User-configurable app appearance: theme mode, primary (brand) color and the
/// optional background wallpaper. Persisted to Firestore (`settings/app`) so the
/// look follows the user across devices. A [ChangeNotifier] so the root
/// [MaterialApp] rebuilds whenever any of these change.
///
/// This is the "settings" table the app keeps in Firebase: a single
/// `settings/app` document holding the fields below.
class SettingsService extends ChangeNotifier {
  SettingsService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  DocumentReference<Map<String, dynamic>> get _doc => _db.collection('settings').doc('app');

  /// Default brand color - a muted, dusty purple (the first preset).
  static const Color defaultPrimary = Color(0xFF8E7CB3);

  /// The presets offered in the color picker. Deliberately muted and natural
  /// (low-saturation, "washed") rather than vivid, so the accent reads calm.
  static const List<Color> primaryChoices = [
    Color(0xFF8E7CB3), // dusty purple
    Color(0xFF6C8AB8), // dusty blue
    Color(0xFF4E9A90), // muted teal
    Color(0xFF7DA47A), // sage green
    Color(0xFF98A165), // olive
    Color(0xFFC7A868), // ochre
    Color(0xFFC58C66), // clay
    Color(0xFFB4735A), // terracotta
    Color(0xFFC07F8E), // dusty rose
    Color(0xFFA07FA0), // mauve
  ];

  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = defaultPrimary;
  BackgroundTheme _backgroundTheme = BackgroundThemes.none;
  Gender _gender = Gender.male;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  /// The body silhouette gender used on the Body-measurements tab.
  Gender get gender => _gender;

  /// The wallpaper shown behind the app, or [BackgroundThemes.none] for the
  /// plain solid look. Persisted on the `settings/app` document.
  BackgroundTheme get backgroundTheme => _backgroundTheme;

  /// Loads the persisted settings. Tolerates being offline / missing document
  /// by keeping the defaults above.
  Future<void> init() async {
    try {
      final snap = await _doc.get();
      final data = snap.data();
      if (data != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (m) => m.name == data['themeMode'],
          orElse: () => ThemeMode.system,
        );
        final colorValue = data['primaryColor'];
        if (colorValue is int) _primaryColor = Color(colorValue);
        _backgroundTheme = BackgroundThemes.byId(data['backgroundTheme'] as String?);
        _gender = Gender.values.firstWhere(
          (g) => g.name == data['gender'],
          orElse: () => Gender.male,
        );
      }
    } catch (_) {
      // Offline / unavailable: keep defaults; the user can still change them.
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    _doc.set({'themeMode': mode.name}, SetOptions(merge: true));
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    if (color.toARGB32() == _primaryColor.toARGB32()) return;
    _primaryColor = color;
    _doc.set({'primaryColor': color.toARGB32()}, SetOptions(merge: true));
    notifyListeners();
  }

  void setBackgroundTheme(BackgroundTheme theme) {
    if (theme.id == _backgroundTheme.id) return;
    _backgroundTheme = theme;
    _doc.set({'backgroundTheme': theme.id}, SetOptions(merge: true));
    notifyListeners();
  }

  void setGender(Gender gender) {
    if (gender == _gender) return;
    _gender = gender;
    _doc.set({'gender': gender.name}, SetOptions(merge: true));
    notifyListeners();
  }
}
