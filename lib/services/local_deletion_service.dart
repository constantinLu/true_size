import 'package:flutter/foundation.dart';

/// Tracks items/groups the user has just deleted so the UI can hide them
/// immediately (optimistic delete), before Firestore confirms the removal.
///
/// The list views filter these ids out and listen for changes, so a deleted
/// entry vanishes instantly; the actual Firestore delete runs in the
/// background. On failure the caller un-hides the id and shows an error.
class LocalDeletionService extends ChangeNotifier {
  final Set<String> _measurements = {};
  final Set<String> _groups = {};

  bool isMeasurementHidden(String id) => _measurements.contains(id);
  bool isGroupHidden(String id) => _groups.contains(id);

  bool get hasHidden => _measurements.isNotEmpty || _groups.isNotEmpty;

  void hideMeasurement(String id) {
    if (_measurements.add(id)) notifyListeners();
  }

  void unhideMeasurement(String id) {
    if (_measurements.remove(id)) notifyListeners();
  }

  void hideGroup(String id) {
    if (_groups.add(id)) notifyListeners();
  }

  void unhideGroup(String id) {
    if (_groups.remove(id)) notifyListeners();
  }
}
