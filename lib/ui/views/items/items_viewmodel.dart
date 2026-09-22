import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/enums/list_sort.dart';
import '../../../core/models/group.dart';
import '../../../core/models/measurement.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/local_deletion_service.dart';
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
  final _deletions = locator<LocalDeletionService>();

  ItemsViewModel() {
    _searchService.addListener(notifyListeners);
    _deletions.addListener(notifyListeners);
  }

  List<GroupedMeasurement> _all = const [];

  bool get isSearching => _searchService.isActive;

  /// All items, with optimistically-deleted items/groups removed.
  List<GroupedMeasurement> get _visible => _all
      .where((gm) =>
          !_deletions.isMeasurementHidden(gm.measurement.id) &&
          !_deletions.isGroupHidden(gm.group.id))
      .toList();

  /// All items filtered by the shared search query, then ordered by the chosen
  /// sort field and direction.
  List<GroupedMeasurement> get items {
    final q = _searchService.query.trim().toLowerCase();
    final base = q.isEmpty
        ? _visible
        : _visible.where((gm) {
            final m = gm.measurement;
            return m.name.toLowerCase().contains(q) ||
                m.brandName.toLowerCase().contains(q) ||
                gm.group.name.toLowerCase().contains(q) ||
                m.sizes.any((s) => s.value.toLowerCase().contains(q));
          }).toList();
    return _applySort(base);
  }

  // --- Ordering (in-memory; defaults to A-Z) --------------------------------

  ItemSort _sort = ItemSort.alphabetical;
  bool _ascending = true;

  ItemSort get sort => _sort;
  bool get ascending => _ascending;

  void setSort(ItemSort value) {
    if (value == _sort) return;
    _sort = value;
    notifyListeners();
  }

  void toggleDirection() {
    _ascending = !_ascending;
    notifyListeners();
  }

  List<GroupedMeasurement> _applySort(List<GroupedMeasurement> list) {
    final sorted = [...list];
    sorted.sort((a, b) {
      final ma = a.measurement, mb = b.measurement;
      switch (_sort) {
        case ItemSort.alphabetical:
          return ma.name.toLowerCase().compareTo(mb.name.toLowerCase());
        case ItemSort.date:
          return ma.createdAt.compareTo(mb.createdAt);
        case ItemSort.brand:
          final t = ma.brandName.toLowerCase().compareTo(mb.brandName.toLowerCase());
          return t != 0 ? t : ma.name.toLowerCase().compareTo(mb.name.toLowerCase());
      }
    });
    return _ascending ? sorted : sorted.reversed.toList();
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
    _deletions.removeListener(notifyListeners);
    super.dispose();
  }
}
