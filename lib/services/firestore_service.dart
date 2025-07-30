import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/group.dart';
import '../core/models/user.dart';


class FirestoreService {
  final FirebaseFirestore _firestoreDatabase = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreDatabase => _firestoreDatabase;

  Future<void> saveUser(TrueUser user) async {
    await _firestoreDatabase
        .collection('users')
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<TrueUser?> getUser(String userId) async {
    final doc = await _firestoreDatabase.collection('users').doc(userId).get();
    if (doc.exists) {
      return TrueUser.fromFirestore(doc);
    }
    return null;
  }

  // Measurement operations
  Future<String> addGroupWithMeasurement(Group group) async {
    final docRef =
        await _firestoreDatabase.collection('groups').add(group.toFirestore());
    return docRef.id;
  }

  Future<void> updateGroup(Group group) async {
    await _firestoreDatabase
        .collection('groups')
        .doc(group.id)
        .update(group.toFirestore());
  }

  Future<void> deleteGroup(String groupId) async {
    await _firestoreDatabase.collection('groups').doc(groupId).delete();
  }

  Stream<List<Group>> getGroups(String userId) {
    return _firestoreDatabase
        .collection('groups')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Group.fromFirestore(doc)).toList());
  }

  Future<Group?> getGroup(String measurementId) async {
    final doc =
        await _firestoreDatabase.collection('groups').doc(measurementId).get();
    if (doc.exists) {
      return Group.fromFirestore(doc);
    }
    return null;
  }

// Stream<List<Group>> searchGroups(String userId, String query) {
//   return _db
//       .collection('measurements')
//       .where('userId', isEqualTo: userId)
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//       .map((doc) => Group.fromFirestore(doc))
//       .where((entry) =>
//   entry.title.toLowerCase().contains(query.toLowerCase()) ||
//       entry.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
//       entry.measurements.any((measurement) =>
//           measurement.brand.toLowerCase().contains(query.toLowerCase())))
//       .toList());
// }
//
// Stream<List<Group>> getMeasurementsByTag(String userId, String tag) {
//   return _db
//       .collection('measurements')
//       .where('userId', isEqualTo: userId)
//       .where('tags', arrayContains: tag)
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//       .map((doc) => Group.fromFirestore(doc))
//       .toList());
// }
}
