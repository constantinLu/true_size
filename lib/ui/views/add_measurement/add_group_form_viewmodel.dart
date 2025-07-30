import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/ui/views/add_measurement/add_group_form_view.form.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/unit.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/group.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/measurement_service.dart';
import '../../../services/tag_service.dart';

class AddGroupFormViewModel extends FormViewModel {
  /// controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  /// services
  final navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _groupService = locator<GroupService>();
  final _measurementService = locator<MeasurementService>();
  final _tagService = locator<TagService>();
  final _authService = locator<AuthService>();
  final _bottomSheetService = locator<BottomSheetService>();

  /// props
  String _selectedIcon = 'fitness_center';
  String _selectedColor = '#007AFF';
  bool _showAdvancedOptions = false;

  String icon = 'straighten';
  Unit? unit;
  Brand? brand;
  String? customBrand;
  bool showNotes = false;

  // // List<MeasurementModel> _measurements = [];
  // List<Tag> _selectedTags = [];
  //
  // // Available options
  // final List<Unit> _availableUnits = Unit.values;
  // List<Tag> _availableTags = [];

  /// getters
  String get selectedIcon => _selectedIcon;

  String get selectedColor => _selectedColor;

  Color get selectedColorValue => Color(int.parse(_selectedColor.replaceFirst('#', '0xFF')));

  bool get showAdvancedOptions => _showAdvancedOptions;

  // List<MeasurementModel> get measurements => _measurements;

  // List<Tag> get selectedTags => _selectedTags;
  //
  // List<Unit> get availableUnits => _availableUnits;
  //
  // List<Tag> get availableTags => _availableTags;

  /// METHODS
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    valueController.dispose();
    notesController.dispose();
  }

  bool get isFormValid {
    return hasGroupName &&
        hasGroupDescription &&
        !hasAnyValidationMessage && // This checks if there are validation errors
        groupNameValue!.trim().isNotEmpty &&
        groupDescriptionValue!.trim().isNotEmpty;
  }

  // Call this when you want to show validation errors
  void showValidationErrors() {
    // If there are errors, show a general message
    if (hasAnyValidationMessage) {
      String errorMessage = 'Please fix the following errors:\n';

      if (hasGroupNameValidationMessage) {
        errorMessage += '• ${groupNameValidationMessage}\n';
      }

      if (hasGroupDescriptionValidationMessage) {
        errorMessage += '• ${groupDescriptionValidationMessage}\n';
      }

      _snackbarService.showSnackbar(
        message: errorMessage.trim(),
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> initializeForm() async {
    setBusy(true);
    setValidationMessage(null);
    try {
      // Load available brands and tags
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Error loading data: $e');
    } finally {
      setBusy(false);
    }
  }

  // Future<void> onAccept() async {
  //   User user = User.create(
  //       Name.value(formValueMap[FirstNameValueKey]),
  //       Name.value(formValueMap[LastNameValueKey]),
  //       EmailAddress.value(formValueMap[EmailValueKey]), Password.value(formValueMap[PasswordValueKey]));
  //
  //   notifyListeners();
  //
  //   if (!isFormValid) {
  //     //here maybe compose all the errors
  //     setValidationMessage("User credentials not valid");
  //     rebuildUi();
  //     return;
  //   }

  void selectIcon(String iconName) {
    _selectedIcon = iconName;
    notifyListeners();
  }

  void selectColor(Color color) {
    _selectedColor = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    notifyListeners();
  }

  void toggleAdvancedOptions() {
    _showAdvancedOptions = !_showAdvancedOptions;
    notifyListeners();
  }

  // void addMeasurement() {
  //   _measurements.add(MeasurementModel());
  //   notifyListeners();
  // }
  //
  // void removeMeasurement(int index) {
  //   if (index < _measurements.length) {
  //     _measurements[index].dispose();
  //     _measurements.removeAt(index);
  //     notifyListeners();
  //   }
  // }

  // Future<void> showMeasurementIconSelector(int index) async {
  //   final icons = [
  //     Icons.thermostat,
  //     Icons.water,
  //     Icons.scale,
  //     Icons.rule,
  //   ];
  //
  //   final result = await _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.iconSelector,
  //     data: icons,
  //     title: 'Select Measurement Icon',
  //     description: 'Tap an icon to select it',
  //   );
  //
  //   if (result?.confirmed == true && result?.data != null) {
  //     IconData selectedIcon = result!.data;
  //     // Update your model with selected icon
  //   }
  // }

  // void showMeasurementIconSelector(int index) {
  //   _showIconSelectorBottomSheet(
  //     title: 'Select Measurement Icon',
  //     icons: [
  //       'straighten', 'fitness_center', 'accessibility_new', 'favorite',
  //       'monitor_weight', 'scale', 'directions_run', 'pool',
  //       'sports_basketball', 'sports_soccer', 'thermostat', 'speed',
  //     ],
  //     onIconSelected: (iconName) {
  //       if (index < _measurements.length) {
  //         _measurements[index].icon = iconName;
  //         notifyListeners();
  //       }
  //     },
  //   );
  // }

  // void showUnitSelector(int index) {
  //   _showUnitSelectionBottomSheet(
  //     selectedUnit: _measurements[index].unit,
  //     onUnitSelected: (unit) {
  //       if (index < _measurements.length) {
  //         _measurements[index].unit = unit;
  //         notifyListeners();
  //       }
  //     },
  //   );
  // }
  //
  // void toggleNotes(int index) {
  //   if (index < _measurements.length) {
  //     _measurements[index].showNotes = !_measurements[index].showNotes;
  //     notifyListeners();
  //   }
  // }

  // void showTagSelector() {
  //   _showTagSelectionBottomSheet(
  //     availableTags: _availableTags.where((tag) => !_selectedTags.contains(tag)).toList(),
  //     onTagSelected: (tag) {
  //       if (!_selectedTags.contains(tag)) {
  //         _selectedTags.add(tag);
  //         notifyListeners();
  //       }
  //     },
  //     onNewTagCreated: (tagName) {
  //       final newTag = Tag(
  //         id: const Uuid().v4(),
  //         name: tagName,
  //         groupIds: [],
  //       );
  //       _availableTags.add(newTag);
  //       _selectedTags.add(newTag);
  //       notifyListeners();
  //     },
  //   );
  // }
  //
  // void removeTag(Tag tag) {
  //   _selectedTags.remove(tag);
  //   notifyListeners();
  // }

  void closeForm() {
    navigationService.back();
  }

  Future<void> saveGroup() async {
    validateForm();

    if (!isFormValid) {
      return;
    }
    setBusy(true);
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        _snackbarService.showSnackbar(message: 'User not authenticated');
        return;
      }

      final now = DateTime.now();
      final groupId = const Uuid().v4();

      // // Create measurements first
      // final measurements = <Measurement>[];
      // for (final measurementForm in _measurements) {
      //   if (measurementForm.nameController.text.trim().isNotEmpty) {
      //     final measurement = Measurement(
      //       id: const Uuid().v4(),
      //       icon: measurementForm.icon,
      //       name: measurementForm.nameController.text.trim(),
      //       value: measurementForm.valueController.text.trim().isEmpty ? '0' : measurementForm.valueController.text.trim(),
      //       unit: measurementForm.unit ?? Unit.cm,
      //       brand: measurementForm.brand,
      //       customBrand: measurementForm.customBrand,
      //       notes: measurementForm.showNotes && measurementForm.notesController.text.trim().isNotEmpty
      //           ? measurementForm.notesController.text.trim()
      //           : null,
      //       groupId: groupId,
      //       createdAt: now,
      //     );
      //     measurements.add(measurement);
      //   }
      // }
      //
      // // Save tags first (create new ones if needed)
      // for (final tag in _selectedTags) {
      //   if (!_availableTags.any((t) => t.name == tag.name)) {
      //     await _tagService.createTag(tag);
      //   }
      // }

      // Create group
      final group = Group(
        id: groupId,
        name: groupNameValue!.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        measurements: [],
        tags: [],
        userId: currentUser.uid,
        createdAt: now,
        updatedAt: now,
      );

      // Save group
      await _groupService.add(group);

      // // Save measurements
      // for (final measurement in measurements) {
      //   await _measurementService.insert(measurement);
      // }

      _snackbarService.showSnackbar(
        message: 'Group created successfully!',
        duration: const Duration(seconds: 2),
      );
      navigationService.back();
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Error saving group: $e');
    } finally {
      setBusy(false);
    }
  }
}

//@override
// void dispose() {
//   for (final measurement in _measurements) {
//     measurement.dispose();
//   }
//   super.dispose();
// }
