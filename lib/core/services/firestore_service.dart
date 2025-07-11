import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/measurement_entry.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User operations
  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // Measurement operations
  Future<String> addMeasurement(MeasurementEntry entry) async {
    final docRef = await _db.collection('measurements').add(entry.toFirestore());
    return docRef.id;
  }

  Future<void> updateMeasurement(MeasurementEntry entry) async {
    await _db.collection('measurements').doc(entry.id).update(entry.toFirestore());
  }

  Future<void> deleteMeasurement(String measurementId) async {
    await _db.collection('measurements').doc(measurementId).delete();
  }

  Stream<List<MeasurementEntry>> getMeasurements(String userId) {
    return _db
        .collection('measurements')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MeasurementEntry.fromFirestore(doc))
        .toList());
  }

  Future<MeasurementEntry?> getMeasurement(String measurementId) async {
    final doc = await _db.collection('measurements').doc(measurementId).get();
    if (doc.exists) {
      return MeasurementEntry.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<MeasurementEntry>> searchMeasurements(String userId, String query) {
    return _db
        .collection('measurements')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MeasurementEntry.fromFirestore(doc))
        .where((entry) =>
    entry.title.toLowerCase().contains(query.toLowerCase()) ||
        entry.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
        entry.measurements.any((measurement) =>
            measurement.brand.toLowerCase().contains(query.toLowerCase())))
        .toList());
  }

  Stream<List<MeasurementEntry>> getMeasurementsByTag(String userId, String tag) {
    return _db
        .collection('measurements')
        .where('userId', isEqualTo: userId)
        .where('tags', arrayContains: tag)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MeasurementEntry.fromFirestore(doc))
        .toList());
  }
}