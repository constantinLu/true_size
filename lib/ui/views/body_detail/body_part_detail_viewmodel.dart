import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/gender.dart';
import '../../../core/models/body_measurement.dart';
import '../../../core/models/body_part.dart';
import '../../../services/auth_service.dart';
import '../../../services/body_service.dart';
import '../../../services/settings_service.dart';

class BodyPartDetailViewModel extends BaseViewModel {
  final _auth = locator<AuthService>();
  final _bodyService = locator<BodyService>();
  final _settings = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final String partKey;
  BodyPartDetailViewModel({required this.partKey});

  BodyPart? get part => BodyPart.byKey(partKey);
  Gender get gender => _settings.gender;

  List<BodyEntry> _entries = const [];
  List<BodyEntry> get entries => _entries;
  BodyEntry? get latest => _entries.isEmpty ? null : _entries.first;

  Future<void> initialize() => _load();

  Future<void> _load() async {
    setBusy(true);
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final m = await _bodyService.getForPart(uid, partKey);
      _entries = m?.entries ?? const [];
    }
    setBusy(false);
  }

  Future<void> deleteEntry(BodyEntry entry) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete entry',
      description: 'Remove this snapshot from the history?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (result?.confirmed != true) return;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _bodyService.deleteEntry(uid, partKey, entry);
    await _load();
  }

  void back() => _navigationService.back();
}
