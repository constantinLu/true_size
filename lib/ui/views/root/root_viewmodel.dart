import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/models/group.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/search_service.dart';
import '../../../services/update_service.dart';
import '../../common/add_options_sheet.dart';
import '../../common/form_widgets.dart';

/// Owns the tab state, the shared top-bar search field, the avatar chip and the
/// three-way "add" action for the shell.
class RootViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _navigationService = locator<NavigationService>();
  final _auth = locator<AuthService>();
  final _groupService = locator<GroupService>();
  final _search = locator<SearchService>();
  final _updateService = locator<UpdateService>();

  final searchController = TextEditingController();

  RootViewModel() {
    _auth.addListener(notifyListeners);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForUpdate();
    }
  }

  bool _promptingUpdate = false;

  /// A new APK may have been deployed while the app was backgrounded. On resume,
  /// re-check the version manifest and, if the store is ahead, drop the user onto
  /// the forced-update screen with the stack cleared so there's no way back into
  /// the stale build. Guarded so overlapping resumes don't push it twice.
  Future<void> _checkForUpdate() async {
    if (_promptingUpdate) return;
    final update = await _updateService.check();
    if (update == null) return;
    _promptingUpdate = true;
    await _navigationService.clearStackAndShow(
      Routes.updateRequiredView,
      arguments: UpdateRequiredViewArguments(info: update),
    );
  }

  int _index = 0;
  int get index => _index;

  Uint8List? get avatarBytes => _auth.avatarBytes;
  String? get photoUrl => _auth.currentUser?.photoURL;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }

  void onSearchChanged(String value) {
    _search.setQuery(value);
    notifyListeners(); // refresh the clear button
  }

  Future<void> openProfile() => _navigationService.navigateToProfileView();

  /// The center "+" offers three things to create.
  Future<void> showAddSheet(BuildContext context) async {
    final choice = await showAddOptionsSheet(context);
    switch (choice) {
      case AddOption.group:
        await _navigationService.navigateToAddGroupFormView();
        break;
      case AddOption.item:
        await _addItem(context);
        break;
      case null:
        break;
    }
  }

  /// "+ Item" first asks which group the item belongs to.
  Future<void> _addItem(BuildContext context) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final groups = await _groupService.getAll(uid);
    if (!context.mounted) return;
    if (groups.isEmpty) {
      await _navigationService.navigateToAddGroupFormView();
      return;
    }
    final picked = await showSelectionSheet<Group>(
      context,
      title: 'Add item to…',
      options: groups,
      selected: null,
      labelOf: (g) => g.name,
    );
    if (picked != null) {
      await _navigationService.navigateToAddMeasurementView(groupId: picked.id);
    }
  }

  @override
  void dispose() {
    _auth.removeListener(notifyListeners);
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }
}
