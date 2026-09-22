import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../core/utils/app_error.dart';
import '../../../services/group_service.dart';
import '../../../services/local_deletion_service.dart';
import '../../../services/measurement_service.dart';
import '../../common/confirm_sheet.dart';

class ItemDetailViewModel extends BaseViewModel {
  final _measurementService = locator<MeasurementService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();
  final _deletions = locator<LocalDeletionService>();

  final String measurementId;
  ItemDetailViewModel({required this.measurementId});

  Measurement? _measurement;
  Group? _group;

  Measurement? get measurement => _measurement;
  Group? get group => _group;
  String get groupName => _group?.name ?? '';

  Future<void> initialize() => _load();

  Future<void> _load() async {
    setBusy(true);
    try {
      _measurement = await _measurementService.get(measurementId);
      final gid = _measurement?.groupId;
      if (gid != null) _group = await _groupService.get(gid);
      if (_measurement == null) setError('Measurement not found');
    } catch (e) {
      setError(cleanErrorMessage(e, fallback: 'Could not load this measurement.'));
    }
    setBusy(false);
  }

  Future<void> edit() async {
    final m = _measurement;
    if (m == null) return;
    final saved = await _navigationService.navigateToAddMeasurementView(
      groupId: m.groupId,
      existing: m,
    );
    if (saved == true) await _load();
  }

  Future<void> confirmDelete(BuildContext context) async {
    final m = _measurement;
    if (m == null) return;
    final confirmed = await showConfirmSheet(
      context,
      title: 'Delete measurement',
      message: 'Delete "${m.name}"? This cannot be undone.',
      confirmLabel: 'Delete',
      danger: true,
      icon: Icons.delete_outline_rounded,
    );
    if (!confirmed) return;
    await deleteMeasurement(m);
  }

  /// Optimistically hides the measurement and jumps to the main tab, then
  /// removes it from Firestore. The navigation is intentionally NOT awaited -
  /// its future never completes (the root route is never popped), which
  /// previously blocked the Firestore delete from running at all.
  @visibleForTesting
  Future<void> deleteMeasurement(Measurement m) async {
    _deletions.hideMeasurement(m.id);
    unawaited(_navigationService.clearStackAndShow(Routes.rootView));

    try {
      await _measurementService.delete(m.id);
      await _groupService.touch(m.groupId);
    } catch (e) {
      _deletions.unhideMeasurement(m.id);
      showAppError('Could not delete the measurement. Please try again.');
    }
  }

  void back() => _navigationService.back();
}
