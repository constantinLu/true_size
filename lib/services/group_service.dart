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
    if (await _existsByName(group.userId, group.name)) {
      throw DuplicateGroupNameException(group.name);
    }
    try {
      final docRef = await _groupsRef.add(group.toFirestore());
      return docRef.id;
    } catch (e) {
      throw GroupServiceException('Failed to insert group: $e');
    }
  }

  /// Returns the id of the user's group named [name] (case-insensitive),
  /// creating it with [icon]/[color] when it doesn't exist yet. Used by the
  /// global "+ Body measurement" action.
  Future<String> findOrCreate(String userId, String name,
      {required String icon, required String color}) async {
    final snapshot = await _groupsRef.where('userId', isEqualTo: userId).get();
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if ((data['name'] ?? '').toString().trim().toLowerCase() == name.trim().toLowerCase()) {
        return doc.id;
      }
    }
    final now = DateTime.now();
    final ref = await _groupsRef.add(Group(
      id: '',
      name: name,
      icon: icon,
      color: color,
      measurements: const [],
      tags: const [],
      userId: userId,
      createdAt: now,
      updatedAt: now,
    ).toFirestore());
    return ref.id;
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

  // WATCH ALL - a live stream of the user's groups, each with its measurements
  // and tags loaded. Emits a fresh list whenever the groups collection changes.
  Stream<List<Group>> watchAll(String userId) {
    // No orderBy on the query (that would need a composite index alongside the
    // userId filter); groups are sorted client-side by updatedAt instead.
    return _groupsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      // Load every group's relations concurrently instead of one after another.
      // The old serial loop turned N groups into N sequential Firestore
      // round-trips, which is what made the list slow to appear after sign-in.
      final loaded = await Future.wait(snapshot.docs.map(_loadGroupWithRelations));
      return loaded.whereType<Group>().toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    });
  }

  // GET ALL
  Future<List<Group>> getAll(String userId) async {
    try {
      final querySnapshot =
          await _groupsRef.where('userId', isEqualTo: userId).get();

      // Load relations concurrently (see watchAll).
      final loaded =
          await Future.wait(querySnapshot.docs.map(_loadGroupWithRelations));
      return loaded.whereType<Group>().toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw GroupServiceException(
          'Failed to get all groups for user $userId: $e');
    }
  }

  // UPDATE
  Future<void> update(String groupId, Group group) async {
    if (await _existsByName(group.userId, group.name,
        excludeGroupId: groupId)) {
      throw DuplicateGroupNameException(group.name);
    }
    try {
      final updateData = group.toFirestore();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _groupsRef.doc(groupId).update(updateData);
    } catch (e) {
      throw GroupServiceException('Failed to update group $groupId: $e');
    }
  }

  /// Returns true when the user already owns a group with the same name,
  /// compared case-insensitively and ignoring surrounding whitespace.
  /// [excludeGroupId] lets an update skip the group being edited.
  Future<bool> _existsByName(String userId, String name,
      {String? excludeGroupId}) async {
    final target = name.trim().toLowerCase();
    final snapshot =
        await _groupsRef.where('userId', isEqualTo: userId).get();
    return snapshot.docs.any((doc) {
      if (doc.id == excludeGroupId) return false;
      final data = doc.data() as Map<String, dynamic>;
      final existing = (data['name'] ?? '').toString().trim().toLowerCase();
      return existing == target;
    });
  }

  /// Bumps a group's updatedAt so streams watching the groups collection
  /// (home cards, items list) re-fire after a measurement is added/removed -
  /// measurements live in their own collection, so they don't otherwise notify
  /// the group listeners.
  Future<void> touch(String groupId) async {
    try {
      await _groupsRef.doc(groupId).update({'updatedAt': FieldValue.serverTimestamp()});
    } catch (_) {
      // Best-effort freshness signal; never block the caller on it.
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

      final tagIds = List<String>.from(data['tagIds'] ?? []);

      // Kick off both reads before awaiting either, so a group's measurements
      // and tags load concurrently rather than one blocking the other.
      final measurementsFuture = _measurementService.getByGroupId(doc.id);
      final tagsFuture = _tagService.getTagsByIds(tagIds);
      final measurements = await measurementsFuture;
      final tags = await tagsFuture;
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

/// Thrown when creating or renaming a group would collide with an existing
/// group name owned by the same user.
class DuplicateGroupNameException implements Exception {
  final String name;

  DuplicateGroupNameException(this.name);

  @override
  String toString() =>
      'DuplicateGroupNameException: A group named "$name" already exists.';
}
