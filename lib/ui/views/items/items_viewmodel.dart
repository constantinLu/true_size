import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';

/// A measurement paired with the group it belongs to, for the flat "Items" list
/// where rows are drawn from every group at once.
class GroupedMeasurement {
  GroupedMeasurement(this.measurement, this.group);
  final Measurement measurement;
  final Group group;
}

class ItemsViewModel extends BaseViewModel {
  final _auth = locator<AuthService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();

  List<GroupedMeasurement> _items = [];
  List<GroupedMeasurement> get items => _items;

  Future<void> initialize() async {
    setBusy(true);
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final groups = await _groupService.getAll(uid);
        _items = [
          for (final g in groups)
            for (final m in g.measurements) GroupedMeasurement(m, g),
        ]..sort((a, b) => b.measurement.createdAt.compareTo(a.measurement.createdAt));
      }
    } catch (_) {
      _items = [];
    }
    setBusy(false);
  }

  Future<void> openGroup(Group group) async {
    await _navigationService.navigateToGroupDetailView(measurementId: group.id);
    await initialize();
  }
}
