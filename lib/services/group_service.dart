import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:true_size/services/tag_service.dart';

import '../../app/app.locator.dart';
import '../core/models/group.dart';
import 'measurement_service.dart';

class GroupService {
  final _measurementService = locator<MeasurementService>();
  final _tagService = locator<TagService>();
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;

  static const String _groupCollection = 'groups';

  CollectionReference get _groupsRef =>
      _firestoreService.collection(_groupCollection);

  // INSERT
  Future<String> add(Group group) async {
    try {
      final docRef = await _groupsRef.add(group.toFirestore());
      return docRef.id;
    } catch (e) {
      throw GroupServiceException('Failed to insert group: $e');
    }
  }

  // GET
  Future<Group?> get(String groupId) async {
    try {
      final doc = await _groupsRef.doc(groupId).get();

      if (!doc.exists) return null;

      return await _loadGroupWithRelations(doc);
    } catch (e) {
      throw GroupServiceException('Failed to get group $groupId: $e');
    }
  }

  // GET ALL
  Future<List<Group>> getAll(String userId) async {
    try {
      final querySnapshot = await _groupsRef
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      final groups = <Group>[];

      for (final doc in querySnapshot.docs) {
        final group = await _loadGroupWithRelations(doc);
        if (group != null) {
          groups.add(group);
        }
      }
      return groups;
    } catch (e) {
      throw GroupServiceException(
          'Failed to get all groups for user $userId: $e');
    }
  }

  // UPDATE
  Future<void> update(String groupId, Group group) async {
    try {
      final updateData = group.toFirestore();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _groupsRef.doc(groupId).update(updateData);
    } catch (e) {
      throw GroupServiceException('Failed to update group $groupId: $e');
    }
  }

  // DELETE
  Future<void> delete(String groupId) async {
    try {
      await _groupsRef.doc(groupId).delete();
    } catch (e) {
      throw GroupServiceException('Failed to delete group $groupId: $e');
    }
  }

  // Private helper method
  Future<Group?> _loadGroupWithRelations(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>;

      final measurementIds = List<String>.from(data['measurementIds'] ?? []);
      final tagIds = List<String>.from(data['tagIds'] ?? []);

      final measurements = await _measurementService.getByGroupId(doc.id);
      final tags = await _tagService.getTagsByIds(tagIds);
      return Group(
        id: doc.id,
        name: data['name'] ?? '',
        icon: data['icon'] ?? 'folder',
        color: data['color'] ?? '#2196F3',
        measurements: measurements,
        tags: tags,
        userId: data['userId'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw GroupServiceException('Failed to load group with relations: $e');
    }
  }
}

class GroupServiceException implements Exception {
  final String message;

  GroupServiceException(this.message);

  @override
  String toString() => 'GroupServiceException: $message';
}
