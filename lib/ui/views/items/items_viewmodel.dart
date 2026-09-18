import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/search_service.dart';

/// A measurement paired with the group it belongs to, for the flat "Items" list.
class GroupedMeasurement {
  GroupedMeasurement(this.measurement, this.group);
  final Measurement measurement;
  final Group group;
}

class ItemsViewModel extends StreamViewModel<List<GroupedMeasurement>> {
  final _auth = locator<AuthService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();
  final _searchService = locator<SearchService>();

  ItemsViewModel() {
    _searchService.addListener(notifyListeners);
  }

  List<GroupedMeasurement> _all = const [];

  bool get isSearching => _searchService.isActive;

  /// All items filtered by the shared search query.
  List<GroupedMeasurement> get items {
    final q = _searchService.query.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((gm) {
      final m = gm.measurement;
      return m.name.toLowerCase().contains(q) ||
          m.brandName.toLowerCase().contains(q) ||
          gm.group.name.toLowerCase().contains(q) ||
          m.sizes.any((s) => s.value.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Stream<List<GroupedMeasurement>> get stream {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _groupService.watchAll(uid).map((groups) {
      final flat = <GroupedMeasurement>[
        for (final g in groups)
          for (final m in g.measurements) GroupedMeasurement(m, g),
      ]..sort((a, b) => b.measurement.createdAt.compareTo(a.measurement.createdAt));
      return flat;
    });
  }

  @override
  void onData(List<GroupedMeasurement>? data) {
    _all = data ?? const [];
    notifyListeners();
  }

  Future<void> openMeasurement(GroupedMeasurement gm) async {
    await _navigationService.navigateToItemDetailView(measurementId: gm.measurement.id);
  }

  @override
  void dispose() {
    _searchService.removeListener(notifyListeners);
    super.dispose();
  }
}
