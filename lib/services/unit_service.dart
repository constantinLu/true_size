import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/custom_unit.dart';

/// Persists user-created units in the `units` collection, one document per unit,
/// scoped by `userId`. Built-in units come from the [Unit] enum and are not
/// stored here - only the ones the user adds from the picker.
class UnitService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('units');

  /// The user's custom units, oldest first (so the picker order is stable).
  /// Sorted client-side to avoid a composite index alongside the userId filter.
  Future<List<CustomUnit>> getAll(String userId) async {
    final snap = await _col.where('userId', isEqualTo: userId).get();
    return snap.docs.map((d) => CustomUnit.fromFirestore(d)).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
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
}
