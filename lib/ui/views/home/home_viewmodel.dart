import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.router.dart';

import '../../../app/app.locator.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/group.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';

enum ViewMode { grid, list }

class HomeViewModel extends StreamViewModel<List<Group>> {
  final _authService = locator<AuthService>();
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  List<Group> groups = [];
  String _searchQuery = '';
  String _userDisplayName = '';
  ViewMode _currentViewMode = ViewMode.grid;

  List<Group> get filteredMeasurements {
    if (_searchQuery.isEmpty) {
      return groups;
    }

    return groups.where((group) {
      final query = _searchQuery.toLowerCase();
      return group.name.toLowerCase().contains(query);
      // return group.name.toLowerCase().contains(query) ||
      //     group.tags.any((tag) => tag..name.toLowerCase().contains(query)) ||
      //     group.measurements
      //         .any((measurement) => measurement.brand.toLowerCase().contains(query) || measurement.size.toLowerCase().contains(query));
    }).toList();
  }

  bool get isSearching => _searchQuery.isNotEmpty;

  ViewMode get currentViewMode => _currentViewMode;

  String get userInitials {
    if (_userDisplayName.isEmpty) return 'U';
    final names = _userDisplayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return _userDisplayName[0].toUpperCase();
  }

  Future<void> initialize() async {
    await _loadUserInfo();
    notifyListeners();
  }

  Future<void> _loadUserInfo() async {
    final user = await _authService.getCurrentUserModel();
    if (user != null) {
      _userDisplayName = user.displayName;
    }
  }

  @override
  Stream<List<Group>> get stream {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }
    return _firestoreService.getGroups(currentUser.uid);
  }

  @override
  void onData(List<Group>? data) {
    groups = data ?? [];
    notifyListeners();
  }

  void changeViewMode(ViewMode mode) {
    _currentViewMode = mode;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> navigateToAddGroupFormView() async {
    final result = await _navigationService.navigateToAddGroupFormView();

    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement added successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> navigateToMeasurementDetail(Group entry) async {
    final result = await _navigationService
        .navigateTo('/measurement', arguments: {'measurementId': entry.id});
    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement updated successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> navigateToEditMeasurement(Group entry) async {
    final result = await _navigationService
        .navigateTo('/add-measurement', arguments: {'measurementId': entry.id});
    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement updated successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  // INSTANCE METHOD (not static) - This is the one causing issues
  Future<void> showMeasurementOptions(Group entry) async {
    final result = await _dialogService.showCustomDialog(
      title: entry.name,
      description: 'What would you like to do?',
      mainButtonTitle: 'Edit',
      secondaryButtonTitle: 'Delete',
    );

    if (result?.confirmed == true) {
      // Edit button pressed
      await navigateToEditMeasurement(entry);
    } else if (result?.data == 'secondary') {
      // Delete button pressed
      await _confirmDeleteMeasurement(entry);
    }
  }

  Future<void> _confirmDeleteMeasurement(Group entry) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete Measurement',
      description:
          'Are you sure you want to delete "${entry.name}"? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed == true) {
      await _deleteMeasurement(entry);
    }
  }

  Future<void> _deleteMeasurement(Group entry) async {
    setBusy(true);
    try {
      await _firestoreService.deleteGroup(entry.id);
      _snackbarService.showSnackbar(
        message: 'Measurement deleted successfully',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to delete measurement. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }

  Future<void> onMenuItemSelected(String value) async {
    switch (value) {
      case 'profile':
        // Navigate to profile
        break;
      case 'settings':
        // Navigate to settings
        break;
      case 'logout':
        await _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Sign Out',
      description: 'Are you sure you want to sign out?',
      confirmationTitle: 'Sign Out',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed == true) {
      setBusy(true);
      try {
        await _authService.signOut();
        await _navigationService.clearStackAndShow('/login');
      } catch (e) {
        _snackbarService.showSnackbar(
          message: AppStrings.signOutError,
          duration: const Duration(seconds: 3),
        );
      }
      setBusy(false);
    }
  }

  Future<void> refresh() async {
    // Stream will automatically refresh
    notifyListeners();
  }
}
