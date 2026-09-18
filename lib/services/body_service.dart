import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/body_measurement.dart';

/// Persists body measurements with full history. One Firestore document per
/// (user, body part) in the `body_measurements` collection, holding an
/// `entries` array of snapshots. Each save appends a snapshot, so the previous
/// values remain as history.
class BodyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('body_measurements');

  DocumentReference<Map<String, dynamic>> _doc(String userId, String part) =>
      _col.doc('${userId}_$part');

  /// Live map of the user's body measurements, keyed by part. Sorted/filtered
  /// client-side so no composite index is required.
  Stream<Map<String, BodyMeasurement>> watchAll(String userId) {
    return _col.where('userId', isEqualTo: userId).snapshots().map((snap) {
      final map = <String, BodyMeasurement>{};
      for (final doc in snap.docs) {
        final bm = BodyMeasurement.fromFirestore(doc);
        map[bm.partKey] = bm;
      }
      return map;
    });
  }

  Future<BodyMeasurement?> getForPart(String userId, String part) async {
    final doc = await _doc(userId, part).get();
    if (!doc.exists) return null;
    return BodyMeasurement.fromFirestore(doc);
  }

  /// Appends a new snapshot for [part]. Keeps prior values as history.
  Future<void> addEntry(String userId, String part, double value) async {
    await _doc(userId, part).set({
      'userId': userId,
      'part': part,
      'entries': FieldValue.arrayUnion([
        {'value': value, 'date': Timestamp.fromDate(DateTime.now())}
      ]),
    }, SetOptions(merge: true));
  }

  /// Removes a specific snapshot from a part's history.
  Future<void> deleteEntry(String userId, String part, BodyEntry entry) async {
    await _doc(userId, part).update({
      'entries': FieldValue.arrayRemove([entry.toMap()])
    });
  }
}
