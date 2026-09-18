import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/group.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';

/// Create-a-group form: name, an icon and a colour. Measurements are added
/// afterwards from the group's detail screen.
class AddGroupFormViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _groupService = locator<GroupService>();
  final _authService = locator<AuthService>();

  final nameController = TextEditingController();

  /// The chosen icon key (a Lucide icon name) and accent colour.
  String iconKey = 'ruler';
  Color color = AppColors.categoryPalette.first;

  List<Color> get colorChoices => AppColors.categoryPalette;

  void setIcon(String key) {
    iconKey = key;
    rebuildUi();
  }

  void setColor(Color c) {
    color = c;
    rebuildUi();
  }

  bool get canSubmit => nameController.text.trim().isNotEmpty;

  String _hex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  Future<void> submit() async {
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      _snackbarService.showSnackbar(message: 'You need to be signed in.');
      return;
    }

    setBusy(true);
    try {
      final now = DateTime.now();
      final group = Group(
        id: const Uuid().v4(),
        name: name,
        icon: iconKey,
        color: _hex(color),
        measurements: const [],
        tags: const [],
        userId: uid,
        createdAt: now,
        updatedAt: now,
      );
      await _groupService.add(group);
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Could not create group: $e');
    }
    setBusy(false);
  }

  void closeForm() => _navigationService.back();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
