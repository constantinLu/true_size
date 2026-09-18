import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/firestore_service.dart';
import '../../../services/measurement_service.dart';

class GroupDetailViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _measurementService = locator<MeasurementService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
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

  Future<void> confirmDelete() async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete group',
      description: 'Delete "${_group?.name}" and its measurements? This cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (result?.confirmed == true) {
      await _delete();
    }
  }

  Future<void> _delete() async {
    setBusy(true);
    try {
      await _firestoreService.deleteGroup(groupId);
      _snackbarService.showSnackbar(
        message: 'Group deleted',
        duration: const Duration(seconds: 2),
      );
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to delete group. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }

  void navigateBack() => _navigationService.back();
}
