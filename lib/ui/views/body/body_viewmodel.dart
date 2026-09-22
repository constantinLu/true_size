import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/enums/gender.dart';
import '../../../core/models/body_measurement.dart';
import '../../../core/models/body_part.dart';
import '../../../core/utils/app_error.dart';
import '../../../services/auth_service.dart';
import '../../../services/body_service.dart';
import '../../../services/search_service.dart';
import '../../../services/settings_service.dart';

class BodyViewModel extends StreamViewModel<Map<String, BodyMeasurement>> {
  final _auth = locator<AuthService>();
  final _bodyService = locator<BodyService>();
  final _settings = locator<SettingsService>();
  final _search = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  BodyViewModel() {
    _settings.addListener(notifyListeners);
    _search.addListener(notifyListeners);
  }

  Map<String, BodyMeasurement> _measurements = const {};
  Map<String, BodyMeasurement> get measurements => _measurements;

  Gender get gender => _settings.gender;

  /// The full catalogue (used for the silhouette markers, which always show).
  List<BodyPart> get parts => BodyPart.all;

  bool get isSearching => _search.isActive;

  /// The cards to list, filtered by the shared top-bar search (matches the part
  /// label).
  List<BodyPart> get filteredParts {
    final q = _search.query.trim().toLowerCase();
    if (q.isEmpty) return BodyPart.all;
    return BodyPart.all
        .where((p) => p.label.toLowerCase().contains(q))
        .toList();
  }

  BodyEntry? latestFor(String key) => _measurements[key]?.latest;

  DateTime? get lastChanged {
    DateTime? d;
    for (final m in _measurements.values) {
      final e = m.latest;
      if (e != null && (d == null || e.date.isAfter(d))) d = e.date;
    }
    return d;
  }

  @override
  Stream<Map<String, BodyMeasurement>> get stream {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const {});
    return _bodyService.watchAll(uid);
  }

  @override
  void onData(Map<String, BodyMeasurement>? data) {
    _measurements = data ?? const {};
    notifyListeners();
  }

  Future<void> save(BodyPart part, double value) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _bodyService.addEntry(uid, part.key, value);
    } catch (e) {
      showAppError('Could not save the measurement. Please try again.');
    }
  }

  Future<void> openPart(BodyPart part) async {
    await _navigationService.navigateToBodyPartDetailView(partKey: part.key);
  }

  @override
  void dispose() {
    _settings.removeListener(notifyListeners);
    _search.removeListener(notifyListeners);
    super.dispose();
  }
}
