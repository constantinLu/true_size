import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/utils/helpers.dart';
import '../../../services/firestore_service.dart';

class MeasurementDetailViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  final String measurementId;
  Group? _measurement;

  MeasurementDetailViewModel({required this.measurementId});

  Group? get measurement => _measurement;

  Future<void> initialize() async {
    await _loadMeasurement();
  }

  Future<void> _loadMeasurement() async {
    setBusy(true);
    try {
      _measurement = await _firestoreService.getGroup(measurementId);
      if (_measurement == null) {
        setError('Measurement not found');
      }
    } catch (e) {
      setError(e);
    }
    setBusy(false);
  }

  Future<void> refresh() async {
    await _loadMeasurement();
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
      description:
          'Are you sure you want to delete "${_measurement?.name}"? This action cannot be undone.',
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
      await _firestoreService.deleteGroup(measurementId);
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
