import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/unit.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/measurement.dart';
import '../../../core/models/measurement_size.dart';
import '../../../core/models/unit_option.dart';
import '../../../core/utils/app_error.dart';
import '../../../services/auth_service.dart';
import '../../../services/group_service.dart';
import '../../../services/logo_service.dart';
import '../../../services/measurement_service.dart';
import '../../../services/unit_service.dart';

/// One editable size row on the add-measurement form: a value field paired with
/// a unit. Several of these can be added so a single item carries multiple
/// sizes (e.g. a shoe as both `42 EU` and `25.5 cm`).
class SizeEntry {
  SizeEntry(this.unit) : controller = TextEditingController();
  final TextEditingController controller;
  UnitOption unit;
}

class AddMeasurementViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _measurementService = locator<MeasurementService>();
  final _groupService = locator<GroupService>();
  final _logoService = locator<LogoService>();
  final _unitService = locator<UnitService>();
  final _authService = locator<AuthService>();

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
      if (_sizeEntries.isEmpty) _sizeEntries.add(SizeEntry(UnitOption.fromBuiltin(Unit.shoeSize)));
    }
    nameController.addListener(notifyListeners);
    for (final entry in _sizeEntries) {
      _attach(entry);
    }
    _loadCustomUnits();
  }

  bool get isEditing => existing != null;

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final notesController = TextEditingController();

  // Shoe size is the app's default for the first row.
  final List<SizeEntry> _sizeEntries = [SizeEntry(UnitOption.fromBuiltin(Unit.shoeSize))];
  List<SizeEntry> get sizeEntries => _sizeEntries;

  String iconKey = 'ruler';

  /// The fixed built-in units offered in the picker. Liters, milliliters and
  /// kilograms are intentionally left out of the default set.
  static final List<UnitOption> _builtinUnits = [
    UnitOption.fromBuiltin(Unit.shoeSize),
    UnitOption.fromBuiltin(Unit.clothing),
    UnitOption.fromBuiltin(Unit.m),
    UnitOption.fromBuiltin(Unit.cm),
    UnitOption.fromBuiltin(Unit.mm),
    UnitOption.fromBuiltin(Unit.g),
  ];

  /// User-created units, loaded from Firestore on open.
  final List<UnitOption> _customUnits = [];

  /// Built-in unit ids the user has hidden from their picker.
  Set<String> _hiddenBuiltins = {};

  /// The picker options: built-ins the user hasn't hidden, then their custom
  /// units.
  List<UnitOption> get units => [
        ..._builtinUnits.where((u) => !_hiddenBuiltins.contains(u.id)),
        ..._customUnits,
      ];

  Future<void> _loadCustomUnits() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    try {
      final result = await _unitService.load(uid);
      _customUnits
        ..clear()
        ..addAll(result.custom.map(UnitOption.fromCustom));
      _hiddenBuiltins = result.hiddenBuiltinIds;
      rebuildUi();
    } catch (_) {
      // Non-fatal: built-in units still work if custom ones fail to load.
    }
  }

  /// Creates a custom unit, keeps it in the local list, and returns it so the
  /// picker can select it immediately. Returns null if it couldn't be saved.
  Future<UnitOption?> createUnit(String name, String symbol) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return null;
    try {
      final created = await _unitService.add(uid, name: name.trim(), symbol: symbol.trim());
      final option = UnitOption.fromCustom(created);
      _customUnits.add(option);
      rebuildUi();
      return option;
    } catch (e) {
      showErrorFor(e, fallback: 'Could not add the unit. Please try again.');
      return null;
    }
  }

  /// Removes a unit from the picker. Custom units are deleted outright; built-in
  /// units are hidden (the [Unit] enum can't be edited), so both disappear from
  /// the picker. Existing readings keep their stored label, so nothing breaks.
  Future<void> deleteUnit(UnitOption unit) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    try {
      if (unit.builtIn) {
        await _unitService.hideBuiltin(uid, unit.id);
        _hiddenBuiltins = {..._hiddenBuiltins, unit.id};
      } else {
        await _unitService.delete(unit.id);
        _customUnits.removeWhere((u) => u.id == unit.id);
      }
      rebuildUi();
    } catch (e) {
      showErrorFor(e, fallback: 'Could not remove the unit. Please try again.');
    }
  }

  /// Any unit can be removed from the picker - custom ones are deleted, built-in
  /// ones are hidden.
  bool canDeleteUnit(UnitOption unit) => true;

  void _attach(SizeEntry e) => e.controller.addListener(notifyListeners);

  void setUnit(int index, UnitOption u) {
    _sizeEntries[index].unit = u;
    rebuildUi();
  }

  /// Adds another size row (defaults to cm - the common "and also in cm" case).
  void addSize() {
    final e = SizeEntry(UnitOption.fromBuiltin(Unit.cm));
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
      showErrorFor(e, fallback: 'Could not add the measurement. Please try again.');
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
