import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/unit.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/measurement.dart';
import '../../../services/logo_service.dart';
import '../../../services/measurement_service.dart';

/// Add-a-measurement form: item name, value + unit, optional brand (whose logo
/// is looked up automatically), an icon fallback and notes.
class AddMeasurementViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _measurementService = locator<MeasurementService>();
  final _logoService = locator<LogoService>();

  final String groupId;
  AddMeasurementViewModel({required this.groupId});

  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final brandController = TextEditingController();
  final notesController = TextEditingController();

  Unit unit = Unit.cm;
  String iconKey = 'ruler';

  List<Unit> get units => Unit.values;

  void setUnit(Unit u) {
    unit = u;
    rebuildUi();
  }

  void setIcon(String key) {
    iconKey = key;
    rebuildUi();
  }

  bool get canSubmit =>
      nameController.text.trim().isNotEmpty && valueController.text.trim().isNotEmpty;

  Future<void> submit() async {
    final name = nameController.text.trim();
    final value = valueController.text.trim();
    if (name.isEmpty || value.isEmpty) return;

    setBusy(true);
    try {
      final brandName = brandController.text.trim();
      Brand? brand;
      if (brandName.isNotEmpty) {
        // Resolve a brand logo the same way Wadger does: guess the brand's
        // domain and fetch its logo from logo.dev (cached in Firestore).
        final logo = await _logoService.findLogo(brandName);
        brand = Brand(
          id: const Uuid().v4(),
          name: brandName,
          logo: logo,
          createdAt: DateTime.now(),
        );
      }

      final measurement = Measurement(
        id: const Uuid().v4(),
        icon: iconKey,
        name: name,
        value: value,
        unit: unit,
        brand: brand,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        groupId: groupId,
        createdAt: DateTime.now(),
      );
      await _measurementService.insert(measurement);
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Could not add measurement: $e');
    }
    setBusy(false);
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    brandController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
