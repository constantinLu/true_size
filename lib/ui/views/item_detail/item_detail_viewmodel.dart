import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/group_service.dart';
import '../../../services/measurement_service.dart';

class ItemDetailViewModel extends BaseViewModel {
  final _measurementService = locator<MeasurementService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
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

  Future<void> confirmDelete() async {
    final m = _measurement;
    if (m == null) return;
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete measurement',
      description: 'Delete "${m.name}"? This cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (result?.confirmed != true) return;
    setBusy(true);
    try {
      await _measurementService.delete(m.id);
      await _groupService.touch(m.groupId);
      _snackbarService.showSnackbar(message: 'Measurement deleted', duration: const Duration(seconds: 2));
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to delete. Please try again.');
    }
    setBusy(false);
  }

  void back() => _navigationService.back();
}
