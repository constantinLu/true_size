import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/models/measurement_entry.dart';
import '../../../core/constants/app_strings.dart';

enum ViewMode { grid, list, calendar }

class HomeViewModel extends StreamViewModel<List<MeasurementEntry>> {
  final _authService = locator<AuthService>();
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  List<MeasurementEntry> _allMeasurements = [];
  String _searchQuery = '';
  String _userDisplayName = '';
  ViewMode _currentViewMode = ViewMode.grid;

  List<MeasurementEntry> get filteredMeasurements {
    if (_searchQuery.isEmpty) {
      return _allMeasurements;
    }

    return _allMeasurements.where((entry) {
      final query = _searchQuery.toLowerCase();
      return entry.title.toLowerCase().contains(query) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          entry.measurements.any((measurement) =>
          measurement.brand.toLowerCase().contains(query) ||
              measurement.size.toLowerCase().contains(query));
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
  Stream<List<MeasurementEntry>> get stream {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }
    return _firestoreService.getMeasurements(currentUser.uid);
  }

  @override
  void onData(List<MeasurementEntry>? data) {
    _allMeasurements = data ?? [];
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

  // INSTANCE METHODS (not static)
  Future<void> navigateToAddMeasurement() async {
    final result = await _navigationService.navigateTo('/add-measurement');
    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement added successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> navigateToMeasurementDetail(MeasurementEntry entry) async {
    final result = await _navigationService.navigateTo(
        '/measurement',
        arguments: {'measurementId': entry.id}
    );
    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement updated successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> navigateToEditMeasurement(MeasurementEntry entry) async {
    final result = await _navigationService.navigateTo(
        '/add-measurement',
        arguments: {'measurementId': entry.id}
    );
    if (result == true) {
      _snackbarService.showSnackbar(
        message: 'Measurement updated successfully!',
        duration: const Duration(seconds: 2),
      );
    }
  }

  // INSTANCE METHOD (not static) - This is the one causing issues
  Future<void> showMeasurementOptions(MeasurementEntry entry) async {
    final result = await _dialogService.showCustomDialog(
      title: entry.title,
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

  Future<void> _confirmDeleteMeasurement(MeasurementEntry entry) async {
    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete Measurement',
      description: 'Are you sure you want to delete "${entry.title}"? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed == true) {
      await _deleteMeasurement(entry);
    }
  }

  Future<void> _deleteMeasurement(MeasurementEntry entry) async {
    setBusy(true);
    try {
      await _firestoreService.deleteMeasurement(entry.id);
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