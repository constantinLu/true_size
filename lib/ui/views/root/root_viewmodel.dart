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
import '../../common/add_options_sheet.dart';
import '../../common/form_widgets.dart';

/// Owns the tab state, the shared top-bar search field, the avatar chip and the
/// three-way "add" action for the shell.
class RootViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _auth = locator<AuthService>();
  final _groupService = locator<GroupService>();
  final _search = locator<SearchService>();

  final searchController = TextEditingController();

  RootViewModel() {
    _auth.addListener(notifyListeners);
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
    searchController.dispose();
    super.dispose();
  }
}
