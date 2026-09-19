import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.router.dart';

import '../../../app/app.locator.dart';
import '../../../core/models/group.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/local_deletion_service.dart';
import '../../../services/search_service.dart';

class HomeViewModel extends StreamViewModel<List<Group>> {
  final _authService = locator<AuthService>();
  final _groupService = locator<GroupService>();
  final _navigationService = locator<NavigationService>();
  final _searchService = locator<SearchService>();
  final _deletions = locator<LocalDeletionService>();

  HomeViewModel() {
    _searchService.addListener(notifyListeners);
    _deletions.addListener(notifyListeners);
  }

  /// Groups with any optimistically-deleted groups removed and any
  /// optimistically-deleted items stripped from each group (so card counts stay
  /// correct the instant a delete happens).
  List<Group> get groups => _groups
      .where((g) => !_deletions.isGroupHidden(g.id))
      .map((g) => g.measurements.any((m) => _deletions.isMeasurementHidden(m.id))
          ? g.copyWith(
              measurements:
                  g.measurements.where((m) => !_deletions.isMeasurementHidden(m.id)).toList())
          : g)
      .toList();
  List<Group> _groups = [];

  /// Groups filtered by the shared search query (matches the group name, its
  /// tags, and its items' names / brands / sizes).
  List<Group> get filteredGroups {
    final q = _searchService.query.trim().toLowerCase();
    if (q.isEmpty) return groups;
    return groups.where((g) {
      if (g.name.toLowerCase().contains(q)) return true;
      if (g.tags.any((t) => t.name.toLowerCase().contains(q))) return true;
      return g.measurements.any((m) =>
          m.name.toLowerCase().contains(q) ||
          m.brandName.toLowerCase().contains(q) ||
          m.sizes.any((s) => s.value.toLowerCase().contains(q)));
    }).toList();
  }

  int get totalItems => groups.fold(0, (sum, g) => sum + g.measurements.length);
  bool get isSearching => _searchService.isActive;

  @override
  Stream<List<Group>> get stream {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return Stream.value(const []);
    return _groupService.watchAll(currentUser.uid);
  }

  @override
  void onData(List<Group>? data) {
    _groups = data ?? [];
    notifyListeners();
  }

  Future<void> openGroup(Group group) async {
    await _navigationService.navigateToGroupDetailView(measurementId: group.id);
  }

  @override
  void dispose() {
    _searchService.removeListener(notifyListeners);
    _deletions.removeListener(notifyListeners);
    super.dispose();
  }
}
