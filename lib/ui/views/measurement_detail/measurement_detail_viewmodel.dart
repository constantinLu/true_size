import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/models/group.dart';
import '../../../core/utils/helpers.dart';
import '../../../services/firestore_service.dart';

class GroupDetailViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  final String groupId;
  Group? _group;

  GroupDetailViewModel({required this.groupId});

  Group? get group => _group;

  Future<void> initialize() async {
    await _loadGroup();
  }

  Future<void> _loadGroup() async {
    setBusy(true);
    try {
      _group = await _firestoreService.getGroup(groupId);
      if (_group == null) {
        setError('Measurement not found');
      }
    } catch (e) {
      setError(e);
    }
    setBusy(false);
  }

  Future<void> refresh() async {
    await _loadGroup();
  }

  String getRelativeTime(DateTime dateTime) {
    return Helpers.formatRelativeTime(dateTime);
  }

  String getFormattedDate(DateTime dateTime) {
    return Helpers.formatDate(dateTime);
  }

  Future<void> navigateToEdit() async {
    // final result = await _navigationService.navigateToAddMeasurementView(
    //   measurementId: measurementId,
    // );
    if (true) {
      await refresh();
      _snackbarService.showSnackbar(
        message: 'Measurement updated successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onMenuItemSelected(String value) async {
    switch (value) {
      case 'edit':
        await navigateToEdit();
        break;
      case 'delete':
        await _confirmDelete();
        break;
    }
  }

  Future<void> _confirmDelete() async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete Measurement',
      description: 'Are you sure you want to delete "${_group?.name}"? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed == true) {
      await _deleteMeasurement();
    }
  }

  Future<void> _deleteMeasurement() async {
    setBusy(true);
    try {
      await _firestoreService.deleteGroup(groupId);
      _snackbarService.showSnackbar(
        message: 'Measurement deleted successfully',
        duration: const Duration(seconds: 2),
      );
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to delete measurement. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }

  void navigateBack() {
    _navigationService.back();
  }
}
