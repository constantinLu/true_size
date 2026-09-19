import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/group_service.dart';
import '../../../services/local_deletion_service.dart';
import '../../../services/measurement_service.dart';
import '../../common/confirm_sheet.dart';

class ItemDetailViewModel extends BaseViewModel {
  final _measurementService = locator<MeasurementService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();
  final _deletions = locator<LocalDeletionService>();
  final _snackbarService = locator<SnackbarService>();

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
      setError(e);
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

    // Optimistic: hide it from every list immediately and jump to the main tab,
    // then let Firestore catch up in the background.
    _deletions.hideMeasurement(m.id);
    await _navigationService.clearStackAndShow(Routes.rootView);

    try {
      await _measurementService.delete(m.id);
      await _groupService.touch(m.groupId);
    } catch (e) {
      _deletions.unhideMeasurement(m.id);
      _snackbarService.showSnackbar(message: 'Failed to delete. Please try again.');
    }
  }

  void back() => _navigationService.back();
}
