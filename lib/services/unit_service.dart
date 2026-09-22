import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/custom_unit.dart';

/// The units a user has personalised: the custom ones they created, plus the
/// ids of built-in units they've hidden from the picker.
class UserUnits {
  const UserUnits({required this.custom, required this.hiddenBuiltinIds});
  final List<CustomUnit> custom;
  final Set<String> hiddenBuiltinIds;
}

/// Persists a user's unit personalisation in the `units` collection, one
/// document per unit, scoped by `userId`. Two kinds of document live here,
/// told apart by the presence of a `hiddenBuiltinId` field:
///  * custom units (name + symbol) the user created, and
///  * "hidden" markers for built-in [Unit] values the user removed from their
///    picker (built-ins can't be deleted from the enum, so we hide them).
class UnitService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('units');

  String _hiddenDocId(String userId, String unitId) => 'hidden_${userId}_$unitId';

  /// Loads the user's custom units (oldest first) and the set of built-in unit
  /// ids they've hidden. Sorted client-side to avoid a composite index.
  Future<UserUnits> load(String userId) async {
    final snap = await _col.where('userId', isEqualTo: userId).get();
    final custom = <CustomUnit>[];
    final hidden = <String>{};
    for (final doc in snap.docs) {
      final hiddenId = doc.data()['hiddenBuiltinId'] as String?;
      if (hiddenId != null) {
        hidden.add(hiddenId);
      } else {
        custom.add(CustomUnit.fromFirestore(doc));
      }
    }
    custom.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return UserUnits(custom: custom, hiddenBuiltinIds: hidden);
  }

  /// Creates a custom unit and returns it (with its new document id) so the
  /// caller can select it immediately.
  Future<CustomUnit> add(String userId,
      {required String name, required String symbol}) async {
    final now = DateTime.now();
    final unit = CustomUnit(
      id: '',
      name: name,
      symbol: symbol,
      userId: userId,
      createdAt: now,
    );
    final ref = await _col.add(unit.toFirestore());
    return CustomUnit(
      id: ref.id,
      name: name,
      symbol: symbol,
      userId: userId,
      createdAt: now,
    );
  }

  /// Removes a custom unit. Existing measurements keep their denormalized unit
  /// label, so deleting one never corrupts saved readings.
  Future<void> delete(String unitId) async {
    await _col.doc(unitId).delete();
  }

  /// Hides a built-in unit from the user's picker. Uses a deterministic doc id
  /// so hiding the same unit twice is idempotent. The [Unit] enum is untouched,
  /// so existing readings that use it still render.
  Future<void> hideBuiltin(String userId, String unitId) async {
    await _col.doc(_hiddenDocId(userId, unitId)).set({
      'userId': userId,
      'hiddenBuiltinId': unitId,
    });
  }

  /// Restores a previously hidden built-in unit.
  Future<void> unhideBuiltin(String userId, String unitId) async {
    await _col.doc(_hiddenDocId(userId, unitId)).delete();
  }
}
