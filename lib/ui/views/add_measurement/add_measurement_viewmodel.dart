import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/models/measurement_entry.dart';
import '../../../core/models/measurement_item.dart';
import '../../../core/enums/measurement_type.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';

class MeasurementItemForm {
  final TextEditingController brandController;
  final TextEditingController sizeController;
  final TextEditingController notesController;

  MeasurementItemForm({
    String brand = '',
    String size = '',
    String notes = '',
  }) : brandController = TextEditingController(text: brand),
        sizeController = TextEditingController(text: size),
        notesController = TextEditingController(text: notes);

  MeasurementItem toMeasurementItem() {
    return MeasurementItem(
      id: const Uuid().v4(),
      brand: brandController.text.trim(),
      size: sizeController.text.trim(),
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      createdAt: DateTime.now(),
    );
  }

  void dispose() {
    brandController.dispose();
    sizeController.dispose();
    notesController.dispose();
  }
}


class AddMeasurementViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  final String? measurementId;
  MeasurementEntry? _originalEntry;

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final customCategoryController = TextEditingController();
  final tagController = TextEditingController();

  // Form state
  MeasurementType? _selectedCategory;
  bool _isCustomCategory = false;
  String _customIcon = '📏';
  List<MeasurementItemForm> _measurements = [];
  List<String> _tags = [];

  AddMeasurementViewModel({this.measurementId});

  // Getters
  bool get isEditing => measurementId != null;
  MeasurementType? get selectedCategory => _selectedCategory;
  bool get isCustomCategory => _isCustomCategory;
  String get customIcon => _customIcon;
  List<MeasurementItemForm> get measurements => _measurements;
  List<String> get tags => _tags;

  bool get canSave {
    return titleController.text.trim().isNotEmpty &&
        (_selectedCategory != null || _isCustomCategory) &&
        _measurements.any((m) =>
        m.brandController.text.trim().isNotEmpty &&
            m.sizeController.text.trim().isNotEmpty);
  }

  Future<void> initialize() async {
    if (isEditing) {
      await _loadExistingMeasurement();
    } else {
      _addInitialMeasurement();
    }
    notifyListeners();
  }

  Future<void> _loadExistingMeasurement() async {
    setBusy(true);
    try {
      _originalEntry = await _firestoreService.getMeasurement(measurementId!);
      if (_originalEntry != null) {
        titleController.text = _originalEntry!.title;

        // Set category
        final categoryType = MeasurementType.fromString(_originalEntry!.category);
        if (categoryType == MeasurementType.custom) {
          _isCustomCategory = true;
          customCategoryController.text = _originalEntry!.title;
          _customIcon = _originalEntry!.icon;
        } else {
          _selectedCategory = categoryType;
        }

        // Load measurements
        _measurements = _originalEntry!.measurements.map((item) {
          return MeasurementItemForm(
            brand: item.brand,
            size: item.size,
            notes: item.notes ?? '',
          );
        }).toList();

        // Load tags
        _tags = List.from(_originalEntry!.tags);
      }
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to load measurement. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }

  void _addInitialMeasurement() {
    _measurements.add(MeasurementItemForm());
  }

  void onTitleChanged(String value) {
    notifyListeners();
  }

  void onDescriptionChanged(String value) {
    notifyListeners();
  }

  void selectCategory(MeasurementType type) {
    _selectedCategory = type;
    _isCustomCategory = false;
    notifyListeners();
  }

  void selectCustomCategory() {
    _selectedCategory = null;
    _isCustomCategory = true;
    notifyListeners();
  }

  void onCustomCategoryChanged(String value) {
    notifyListeners();
  }

  void showEmojiPicker() {
    // Implement emoji picker or provide common emojis
    _showEmojiDialog();
  }

  void _showEmojiDialog() {
    final emojis = ['📏', '📱', '🎧', '👕', '👔', '🧥', '👗', '🩱', '👙', '🩳',
      '👖', '👘', '🥿', '👠', '👡', '👢', '👞', '👟', '🥾', '🩴'];

    _dialogService.showCustomDialog(
      title: 'Choose Icon',
      description: 'Select an icon for your custom category',
      mainButtonTitle: 'Cancel',
      data: emojis.first, // Pass first emoji as default
    ).then((result) {
      // For now, just cycle through a few common emojis
      // You can implement a proper emoji picker dialog here
      final currentIndex = emojis.indexOf(_customIcon);
      final nextIndex = (currentIndex + 1) % emojis.length;
      _customIcon = emojis[nextIndex];
      notifyListeners();
    });
  }

  void addMeasurement() {
    _measurements.add(MeasurementItemForm());
    notifyListeners();
  }

  void removeMeasurement(int index) {
    if (_measurements.length > 1) {
      _measurements[index].dispose();
      _measurements.removeAt(index);
      notifyListeners();
    }
  }

  void updateMeasurement(int index, {String? brand, String? size, String? notes}) {
    if (index < _measurements.length) {
      final measurement = _measurements[index];
      if (brand != null) measurement.brandController.text = brand;
      if (size != null) measurement.sizeController.text = size;
      if (notes != null) measurement.notesController.text = notes;
      notifyListeners();
    }
  }

  void addTag(String tag) {
    final cleanedTag = Helpers.cleanTag(tag);
    if (cleanedTag.isNotEmpty && !_tags.contains(cleanedTag)) {
      _tags.add(cleanedTag);
      tagController.clear();
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  Future<void> saveMeasurement() async {
    if (!canSave) return;

    setBusy(true);
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      // Create measurement items
      final measurementItems = _measurements
          .where((m) => m.brandController.text.trim().isNotEmpty &&
          m.sizeController.text.trim().isNotEmpty)
          .map((m) => m.toMeasurementItem())
          .toList();

      // Determine category and icon
      String category;
      String icon;

      if (_isCustomCategory) {
        category = MeasurementType.custom.value;
        icon = _customIcon;
      } else {
        category = _selectedCategory!.value;
        icon = _selectedCategory!.icon;
      }

      final entry = MeasurementEntry(
        id: isEditing ? measurementId! : const Uuid().v4(),
        userId: currentUser.uid,
        title: titleController.text.trim(),
        category: category,
        icon: icon,
        measurements: measurementItems,
        tags: _tags,
        createdAt: isEditing ? _originalEntry!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        await _firestoreService.updateMeasurement(entry);
        _snackbarService.showSnackbar(
          message: 'Measurement updated successfully!',
          duration: const Duration(seconds: 2),
        );
      } else {
        await _firestoreService.addMeasurement(entry);
        _snackbarService.showSnackbar(
          message: 'Measurement added successfully!',
          duration: const Duration(seconds: 2),
        );
      }

      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(
        message: 'Failed to save measurement. Please try again.',
        duration: const Duration(seconds: 3),
      );
    }
    setBusy(false);
  }

  Future<void> deleteMeasurement() async {
    if (!isEditing) return;

    final result = await _dialogService.showConfirmationDialog(
      title: 'Delete Measurement',
      description: 'Are you sure you want to delete "${titleController.text}"? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (result?.confirmed == true) {
      setBusy(true);
      try {
        await _firestoreService.deleteMeasurement(measurementId!);
        _snackbarService.showSnackbar(
          message: 'Measurement deleted successfully',
          duration: const Duration(seconds: 2),
        );
        _navigationService.back(result: true);
      } catch (e) {
        _snackbarService.showSnackbar(
          message: 'Failed to delete measurement. Please try again.',
          duration: const Duration(seconds: 3),
        );
      }
      setBusy(false);
    }
  }

  void navigateBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    customCategoryController.dispose();
    tagController.dispose();
    for (final measurement in _measurements) {
      measurement.dispose();
    }
    super.dispose();
  }
}
