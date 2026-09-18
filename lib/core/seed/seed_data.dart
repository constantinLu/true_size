import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../app/app.locator.dart';
import '../../services/logo_service.dart';
import '../enums/unit.dart';
import '../models/brand.dart';
import '../models/group.dart';
import '../models/measurement.dart';
import '../models/measurement_size.dart';

/// One seeded size reading.
class _S {
  const _S(this.value, this.unit);
  final String value;
  final Unit unit;
}

/// One seeded measurement (item within a group).
class _M {
  const _M(this.name, this.icon, this.sizes, {this.brand, this.notes});
  final String name;
  final String icon;
  final List<_S> sizes;
  final String? brand;
  final String? notes;
}

/// One seeded group with its items.
class _G {
  const _G(this.name, this.icon, this.color, this.items);
  final String name;
  final String icon;
  final String color;
  final List<_M> items;
}

/// The catalogue seeded into Firestore for the owner. Mirrors the user's real
/// notes (shoes, body, jeans, underwear, bedding, sunglasses, bike, gear).
const List<_G> _seed = [
  _G('Pantofi', 'footprints', '#D9AC79', [
    _M('Pantofi Zara', 'footprints', [_S('40', Unit.shoeSize)], brand: 'Zara'),
    _M('Ghete Zara', 'footprints', [_S('40', Unit.shoeSize)], brand: 'Zara'),
    _M('Adidas Superstar', 'footprints', [_S('40 2/3', Unit.shoeSize)], brand: 'Adidas'),
    _M('Adidas alergare', 'footprints', [_S('40 2/3', Unit.shoeSize)], brand: 'Adidas', notes: 'Pantofi de alergare'),
    _M('Converse tenisi', 'footprints', [_S('40', Unit.shoeSize)], brand: 'Converse'),
    _M('Converse iarna', 'footprints', [_S('41', Unit.shoeSize)], brand: 'Converse', notes: 'Grosi / de iarna'),
    _M('Nike', 'footprints', [_S('40.5', Unit.shoeSize), _S('41', Unit.shoeSize)], brand: 'Nike'),
    _M('Timberland', 'footprints', [_S('40', Unit.shoeSize)], brand: 'Timberland'),
    _M('Lungime laba picior', 'ruler', [_S('26', Unit.cm), _S('26.5', Unit.cm)]),
  ]),
  _G('Corp', 'user', '#D37387', [
    _M('Piept / Chest', 'user', [_S('97', Unit.cm)], notes: 'Masurat 20.08.2023'),
    _M('Talie / Waist', 'user', [_S('82', Unit.cm)]),
    _M('Sold / Hip', 'user', [_S('95', Unit.cm)]),
    _M('Spate / Back', 'user', [_S('49', Unit.cm)]),
    _M('Craci / Inseam', 'user', [_S('87', Unit.cm)]),
  ]),
  _G('Blugi', 'shirt', '#7A97DC', [
    _M('Blugi skinny', 'shirt', [_S('40', Unit.clothing)], brand: 'Pull&Bear', notes: 'Skinny sau carrot'),
  ]),
  _G('Boxeri', 'shirt', '#57B4A8', [
    _M('Levis', 'shirt', [_S('34', Unit.cm), _S('35', Unit.cm)], brand: 'Levis', notes: '2 maini intinse; marime S'),
    _M('Tommy', 'shirt', [_S('35', Unit.cm)], brand: 'Tommy Hilfiger'),
    _M('Ralph', 'shirt', [_S('33', Unit.cm)], brand: 'Ralph Lauren'),
  ]),
  _G('Marimi pat', 'bed', '#A8A0E6', [
    _M('Saltea', 'bed', [_S('200 x 160', Unit.cm)]),
    _M('Lenjerie alba', 'bed', [_S('220 x 160', Unit.cm)]),
    _M('Pilota vara', 'bed', [_S('220 x 160', Unit.cm)]),
    _M('Pilota iarna', 'bed', [_S('240 x 180', Unit.cm)]),
  ]),
  _G('Lenjerie de cumparat', 'shoppingCart', '#B0B36A', [
    _M('Cearsaf', 'shoppingCart', [_S('180/200 x 220/240', Unit.cm)]),
    _M('Pilota', 'shoppingCart', [_S('180 x 240', Unit.cm)]),
    _M('Perne', 'shoppingCart', [_S('50 x 70', Unit.cm)]),
  ]),
  _G('Ochelari Revo', 'glasses', '#6C8AB8', [
    _M('Latime ochelar (A)', 'glasses', [_S('145', Unit.mm)], brand: 'Revo'),
    _M('Inaltime lentila (B)', 'glasses', [_S('48', Unit.mm)], brand: 'Revo'),
    _M('Lungime rama (C)', 'glasses', [_S('145', Unit.mm)], brand: 'Revo'),
  ]),
  _G('Bicicleta', 'bike', '#58B182', [
    _M('Craci / Inseam', 'bike', [_S('87', Unit.cm)]),
    _M('Mana / Hand', 'bike', [_S('60', Unit.cm)]),
    _M('Wingspan', 'bike', [_S('186', Unit.cm)]),
    _M('Height', 'bike', [_S('180', Unit.cm)]),
    _M('Ghidon Cannondale F', 'bike', [_S('83', Unit.cm)],
        notes: 'Topstone 4 C15501M10LG/MD; Ultegra RX 2 Agave 2020 C15500M10LG/MD'),
  ]),
  _G('Echipament bicla', 'shirt', '#CC8A63', [
    _M('Compleu iarna bibs', 'shirt', [_S('M', Unit.clothing)]),
    _M('Tricou vara', 'shirt', [_S('M', Unit.clothing)]),
    _M('Bluza iarna', 'shirt', [_S('M', Unit.clothing)]),
    _M('Vesta', 'shirt', [_S('S', Unit.clothing)], brand: 'Rose Bikes'),
  ]),
];

/// Wipes the `groups`, `measurements` and `tags` collections and re-seeds the
/// owner's real catalogue. Leaves `users`, `settings` and `logo_cache` alone.
///
/// Triggered once from the splash when built with `--dart-define=SEED=true`.
Future<void> runSeed(String uid) async {
  final db = FirebaseFirestore.instance;
  final logoService = locator<LogoService>();

  // 1) Wipe existing data (not the user / settings).
  for (final col in ['groups', 'measurements', 'tags']) {
    final snap = await db.collection(col).get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // 2) Resolve each distinct brand's logo once (best-effort).
  final brandNames = {
    for (final g in _seed)
      for (final m in g.items)
        if (m.brand != null) m.brand!,
  };
  final logos = <String, String?>{};
  for (final name in brandNames) {
    logos[name] = await logoService.findLogo(name);
  }

  // 3) Create groups and their measurements.
  final now = DateTime.now();
  for (final g in _seed) {
    final group = Group(
      id: const Uuid().v4(),
      name: g.name,
      icon: g.icon,
      color: g.color,
      measurements: const [],
      tags: const [],
      userId: uid,
      createdAt: now,
      updatedAt: now,
    );
    final groupRef = await db.collection('groups').add(group.toFirestore());

    for (final m in g.items) {
      Brand? brand;
      if (m.brand != null) {
        brand = Brand(
          id: const Uuid().v4(),
          name: m.brand!,
          logo: logos[m.brand!],
          createdAt: now,
        );
      }
      final measurement = Measurement(
        id: const Uuid().v4(),
        icon: m.icon,
        name: m.name,
        sizes: [for (final s in m.sizes) MeasurementSize(value: s.value, unit: s.unit)],
        brand: brand,
        notes: m.notes,
        groupId: groupRef.id,
        createdAt: now,
      );
      await db.collection('measurements').add(measurement.toFirestore());
    }
  }
}
