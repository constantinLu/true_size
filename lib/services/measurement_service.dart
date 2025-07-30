import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/app.locator.dart';
import '../core/models/measurement.dart';
import 'firestore_service.dart';

class MeasurementService {
  static const String _collection = 'measurements';
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;

  CollectionReference get _measurementsRef =>
      _firestoreService.collection(_collection);

  // INSERT
  Future<String> insert(Measurement measurement) async {
    try {
      final docRef = await _measurementsRef.add(measurement.toFirestore());
      return docRef.id;
    } catch (e) {
      throw MeasurementServiceException('Failed to insert measurement: $e');
    }
  }

  // GET
  Future<Measurement?> get(String measurementId) async {
    try {
      final doc = await _measurementsRef.doc(measurementId).get();

      if (!doc.exists) return null;

      return Measurement.fromFirestore(doc);
    } catch (e) {
      throw MeasurementServiceException(
          'Failed to get measurement $measurementId: $e');
    }
  }

  Future<List<Measurement>> getByGroupId(String groupId) async {
    try {
      final querySnapshot = await _measurementsRef
          .where('groupId', isEqualTo: groupId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Measurement.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw MeasurementServiceException(
          'Failed to get measurements by groupId $groupId: $e');
    }
  }

  // GET ALL
  Future<List<Measurement>> getAll(String groupId) async {
    try {
      final querySnapshot = await _measurementsRef
          .where('groupId', isEqualTo: groupId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Measurement.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw MeasurementServiceException(
          'Failed to get all measurements for group $groupId: $e');
    }
  }

  // UPDATE
  Future<void> update(String measurementId, Measurement measurement) async {
    try {
      await _measurementsRef
          .doc(measurementId)
          .update(measurement.toFirestore());
    } catch (e) {
      throw MeasurementServiceException(
          'Failed to update measurement $measurementId: $e');
    }
  }

  // DELETE
  Future<void> delete(String measurementId) async {
    try {
      await _measurementsRef.doc(measurementId).delete();
    } catch (e) {
      throw MeasurementServiceException(
          'Failed to delete measurement $measurementId: $e');
    }
  }
}

class MeasurementServiceException implements Exception {
  final String message;

  MeasurementServiceException(this.message);

  @override
  String toString() => 'MeasurementServiceException: $message';
}
