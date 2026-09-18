import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/unit.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/measurement.dart';
import '../../../core/models/measurement_size.dart';
import '../../../services/group_service.dart';
import '../../../services/logo_service.dart';
import '../../../services/measurement_service.dart';

/// One editable size row on the add-measurement form: a value field paired with
/// a unit. Several of these can be added so a single item carries multiple
/// sizes (e.g. a shoe as both `42 EU` and `25.5 cm`).
class SizeEntry {
  SizeEntry(this.unit) : controller = TextEditingController();
  final TextEditingController controller;
  Unit unit;
}

class AddMeasurementViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _measurementService = locator<MeasurementService>();
  final _groupService = locator<GroupService>();
  final _logoService = locator<LogoService>();

  final String groupId;

  /// When set, the form edits this measurement (pre-filled) and updates it on
  /// submit instead of inserting a new one.
  final Measurement? existing;

  AddMeasurementViewModel({required this.groupId, this.existing}) {
    final e = existing;
    if (e != null) {
      nameController.text = e.name;
      brandController.text = e.brand?.name ?? e.customBrand ?? '';
      notesController.text = e.notes ?? '';
      iconKey = e.icon;
      _sizeEntries
        ..clear()
        ..addAll(e.sizes.map((s) {
          final entry = SizeEntry(s.unit);
          entry.controller.text = s.value;
          return entry;
        }));
      if (_sizeEntries.isEmpty) _sizeEntries.add(SizeEntry(Unit.shoeSize));
    }
    nameController.addListener(notifyListeners);
    for (final entry in _sizeEntries) {
      _attach(entry);
    }
  }

  bool get isEditing => existing != null;

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final notesController = TextEditingController();

  // Shoe size is the app's default for the first row.
  final List<SizeEntry> _sizeEntries = [SizeEntry(Unit.shoeSize)];
  List<SizeEntry> get sizeEntries => _sizeEntries;

  String iconKey = 'ruler';

  List<Unit> get units => [
        Unit.shoeSize,
        Unit.clothing,
        ...Unit.values.metricUnits.where((u) => u != Unit.shoeSize && u != Unit.clothing),
      ];

  void _attach(SizeEntry e) => e.controller.addListener(notifyListeners);

  void setUnit(int index, Unit u) {
    _sizeEntries[index].unit = u;
    rebuildUi();
  }

  /// Adds another size row (defaults to cm - the common "and also in cm" case).
  void addSize() {
    final e = SizeEntry(Unit.cm);
    _attach(e);
    _sizeEntries.add(e);
    rebuildUi();
  }

  void removeSize(int index) {
    if (_sizeEntries.length <= 1) return;
    _sizeEntries[index].controller.dispose();
    _sizeEntries.removeAt(index);
    rebuildUi();
  }

  void setIcon(String key) {
    iconKey = key;
    rebuildUi();
  }

  bool get canSubmit =>
      nameController.text.trim().isNotEmpty &&
      _sizeEntries.any((e) => e.controller.text.trim().isNotEmpty);

  Future<void> submit() async {
    final name = nameController.text.trim();
    final sizes = [
      for (final e in _sizeEntries)
        if (e.controller.text.trim().isNotEmpty)
          MeasurementSize(value: e.controller.text.trim(), unit: e.unit),
    ];
    if (name.isEmpty || sizes.isEmpty) return;

    setBusy(true);
    try {
      final brandName = brandController.text.trim();
      Brand? brand;
      if (brandName.isNotEmpty) {
        final logo = await _logoService.findLogo(brandName);
        brand = Brand(
          id: const Uuid().v4(),
          name: brandName,
          logo: logo,
          createdAt: DateTime.now(),
        );
      }

      final notes = notesController.text.trim().isEmpty ? null : notesController.text.trim();
      final e = existing;
      if (e != null) {
        final updated = Measurement(
          id: e.id,
          icon: iconKey,
          name: name,
          sizes: sizes,
          brand: brand,
          notes: notes,
          groupId: e.groupId,
          createdAt: e.createdAt,
        );
        await _measurementService.update(e.id, updated);
      } else {
        final measurement = Measurement(
          id: const Uuid().v4(),
          icon: iconKey,
          name: name,
          sizes: sizes,
          brand: brand,
          notes: notes,
          groupId: groupId,
          createdAt: DateTime.now(),
        );
        await _measurementService.insert(measurement);
      }
      await _groupService.touch(groupId);
      _navigationService.back(result: true);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Could not add measurement: $e');
    }
    setBusy(false);
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    notesController.dispose();
    for (final e in _sizeEntries) {
      e.controller.dispose();
    }
    super.dispose();
  }
}
