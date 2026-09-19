import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
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
      setError(e);
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

    // Optimistic: hide the group everywhere and return to the main tab, then
    // delete on Firestore in the background.
    _deletions.hideGroup(groupId);
    await _navigationService.clearStackAndShow(Routes.rootView);

    try {
      await _firestoreService.deleteGroup(groupId);
    } catch (e) {
      _deletions.unhideGroup(groupId);
      _snackbarService.showSnackbar(
        message: 'Failed to delete group. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
  }

  void navigateBack() => _navigationService.back();
}
