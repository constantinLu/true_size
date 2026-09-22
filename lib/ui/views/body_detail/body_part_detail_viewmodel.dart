import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/gender.dart';
import '../../../core/models/body_measurement.dart';
import '../../../core/models/body_part.dart';
import '../../../services/auth_service.dart';
import '../../../services/body_service.dart';
import '../../../services/settings_service.dart';
import '../../common/confirm_sheet.dart';

class BodyPartDetailViewModel extends BaseViewModel {
  final _auth = locator<AuthService>();
  final _bodyService = locator<BodyService>();
  final _settings = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  final String partKey;
  BodyPartDetailViewModel({required this.partKey});

  BodyPart? get part => BodyPart.byKey(partKey);
  Gender get gender => _settings.gender;

  List<BodyEntry> _entries = const [];
  List<BodyEntry> get entries => _entries;
  BodyEntry? get latest => _entries.isEmpty ? null : _entries.first;

  /// Body parts that come in a left/right pair - the ones that get a symmetry
  /// comparison in the detail view.
  static const _pairedBases = {'bicep', 'forearm', 'thigh', 'calf'};

  /// The shared base (e.g. `bicep`) when this part is one half of a pair.
  String? get _pairBase {
    for (final base in _pairedBases) {
      if (partKey == '${base}_left' || partKey == '${base}_right') return base;
    }
    return null;
  }

  double? _leftValue;
  double? _rightValue;

  /// Latest left/right values, available once both sides have a reading.
  double? get leftValue => _leftValue;
  double? get rightValue => _rightValue;
  bool get hasComparison => _leftValue != null && _rightValue != null;

  Future<void> initialize() => _load();

  Future<void> _load() async {
    setBusy(true);
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final m = await _bodyService.getForPart(uid, partKey);
      _entries = m?.entries ?? const [];
      await _loadPair(uid);
    }
    setBusy(false);
  }

  Future<void> _loadPair(String uid) async {
    final base = _pairBase;
    if (base == null) return;
    final left = await _bodyService.getForPart(uid, '${base}_left');
    final right = await _bodyService.getForPart(uid, '${base}_right');
    _leftValue = (left?.entries.isNotEmpty ?? false) ? left!.entries.first.value : null;
    _rightValue = (right?.entries.isNotEmpty ?? false) ? right!.entries.first.value : null;
  }

  Future<void> deleteEntry(BuildContext context, BodyEntry entry) async {
    final confirmed = await showConfirmSheet(
      context,
      title: 'Delete entry',
      message: 'Remove this snapshot from the history?',
      confirmLabel: 'Delete',
      danger: true,
      icon: Icons.delete_outline_rounded,
    );
    if (!confirmed) return;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Optimistic: drop it from the timeline immediately, then persist.
    final previous = _entries;
    _entries = _entries.where((e) => e != entry).toList();
    notifyListeners();
    try {
      await _bodyService.deleteEntry(uid, partKey, entry);
    } catch (_) {
      _entries = previous;
      notifyListeners();
    }
  }

  void back() => _navigationService.back();
}
