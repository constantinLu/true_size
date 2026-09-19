import 'package:ota_update/ota_update.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/update_service.dart';

/// Drives the forced-update screen. On tap it streams the APK download progress
/// and hands off to the Android installer. There is no "later" - the user must
/// update to keep using the app (the view also blocks back navigation).
class UpdateRequiredViewModel extends BaseViewModel {
  UpdateRequiredViewModel(this.info);

  final UpdateInfo info;
  final _updateService = locator<UpdateService>();

  /// Download progress in 0..1, or null before the user starts. Reaches 1.0 once
  /// the bytes are down and the OS installer has been launched.
  double? _progress;
  double? get progress => _progress;

  bool _installing = false;
  bool get installing => _installing;

  String? _error;
  String? get errorMessage => _error;

  /// Begins (or retries) the download + install. Safe to ignore taps while a
  /// download is already in flight.
  void startUpdate() {
    if (_installing) return;
    _error = null;
    _installing = true;
    _progress = 0;
    notifyListeners();
    try {
      _updateService.install(info.apkUrl).listen(
        _onEvent,
        onError: (Object _) => _fail(),
      );
    } catch (_) {
      _fail();
    }
  }

  void _onEvent(OtaEvent event) {
    switch (event.status) {
      case OtaStatus.DOWNLOADING:
        final pct = double.tryParse(event.value ?? '');
        if (pct != null) {
          _progress = (pct / 100).clamp(0.0, 1.0);
          notifyListeners();
        }
      case OtaStatus.INSTALLING:
        // Bytes are down; the system installer is now in front of the app.
        _progress = 1;
        notifyListeners();
      default:
        // DOWNLOAD_ERROR / PERMISSION_NOT_GRANTED_ERROR / INTERNAL_ERROR /
        // ALREADY_RUNNING_ERROR / CHECKSUM_ERROR - all recoverable by retrying.
        _fail();
    }
  }

  void _fail() {
    _error = "The update couldn't be installed. Please try again.";
    _installing = false;
    _progress = null;
    notifyListeners();
  }
}
