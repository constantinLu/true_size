import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../core/utils/app_error.dart';
import '../../../services/firestore_service.dart';
import '../../../services/local_deletion_service.dart';
import '../../../services/measurement_service.dart';
import '../../common/confirm_sheet.dart';

class GroupDetailViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _measurementService = locator<MeasurementService>();
  final _navigationService = locator<NavigationService>();
  final _deletions = locator<LocalDeletionService>();
  final _snackbarService = locator<SnackbarService>();

  final String groupId;
  Group? _group;
  List<Measurement> _measurements = [];

  GroupDetailViewModel({required this.groupId});

  Group? get group => _group;
  List<Measurement> get measurements => _measurements;

  Future<void> initialize() async {
    await _load();
  }

  Future<void> _load() async {
    setBusy(true);
    try {
      _group = await _firestoreService.getGroup(groupId);
      if (_group == null) {
        setError('Group not found');
      } else {
        _measurements = await _measurementService.getByGroupId(groupId)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      setError(cleanErrorMessage(e, fallback: 'Could not load this group.'));
    }
    setBusy(false);
  }

  Future<void> refresh() => _load();

  /// Opens the add-measurement form for this group, then refreshes on return.
  Future<void> addMeasurement() async {
    final added = await _navigationService.navigateToAddMeasurementView(groupId: groupId);
    if (added == true) {
      await _load();
      _snackbarService.showSnackbar(
        message: 'Measurement added',
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Opens a measurement's detail (edit / delete), refreshing on return.
  Future<void> openMeasurement(Measurement measurement) async {
    await _navigationService.navigateToItemDetailView(measurementId: measurement.id);
    await _load();
  }

  Future<void> confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmSheet(
      context,
      title: 'Delete group',
      message: 'Delete "${_group?.name}" and its measurements? This cannot be undone.',
      confirmLabel: 'Delete',
      danger: true,
      icon: Icons.delete_outline_rounded,
    );
    if (!confirmed) return;
    await deleteGroup();
  }

  /// Optimistically hides the group and returns to the main tab, then removes it
  /// (and its measurements) from Firestore. The navigation is intentionally NOT
  /// awaited - its future only completes when the root route is popped (never),
  /// which previously blocked the Firestore delete from ever running.
  @visibleForTesting
  Future<void> deleteGroup() async {
    _deletions.hideGroup(groupId);
    unawaited(_navigationService.clearStackAndShow(Routes.rootView));

    try {
      // Delete the group's measurements too, so none are left orphaned.
      final items = await _measurementService.getByGroupId(groupId);
      await Future.wait(items.map((m) => _measurementService.delete(m.id)));
      await _firestoreService.deleteGroup(groupId);
    } catch (e) {
      _deletions.unhideGroup(groupId);
      showAppError('Could not delete the group. Please try again.');
    }
  }

  void navigateBack() => _navigationService.back();
}
