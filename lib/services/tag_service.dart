import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/exception/tag_exception.dart';
import '../core/models/tag.dart';


class TagService {
  static const String _tagCollection = 'tags';
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;

  CollectionReference get _tagsRefCollection =>
      _firestoreService.collection(_tagCollection);

  // CREATE
  Future<String> createTag(Tag tag) async {
    try {
      final docRef = await _tagsRefCollection.add(tag.toFirestore());
      return docRef.id;
    } catch (e) {
      throw TagServiceException('Failed to create tag: $e');
    }
  }

  // READ - Single tag
  Future<Tag?> getTagById(String tagId) async {
    try {
      final doc = await _tagsRefCollection.doc(tagId).get();

      if (!doc.exists) return null;

      return Tag.fromFirestore(doc);
    } catch (e) {
      throw TagServiceException('Failed to get tag $tagId: $e');
    }
  }

  // READ - Multiple tags by IDs
  Future<List<Tag>> getTagsByIds(List<String> tagIds) async {
    if (tagIds.isEmpty) return [];

    try {
      final querySnapshot = await _tagsRefCollection
          .where(FieldPath.documentId, whereIn: tagIds)
          .get();

      return querySnapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();
    } catch (e) {
      throw TagServiceException('Failed to get tags by IDs: $e');
    }
  }

  Future<List<Tag>> getByGroupId(String groupId) async {
    try {
      final querySnapshot = await _tagsRefCollection
          .where('groupId', isEqualTo: groupId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();
    } catch (e) {
      throw TagServiceException(
          'Failed to get measurements by groupId $groupId: $e');
    }
  }

  // UPDATE
  Future<void> updateTag(String tagId, Tag tag) async {
    try {
      await _tagsRefCollection.doc(tagId).update(tag.toFirestore());
    } catch (e) {
      throw TagServiceException('Failed to update tag $tagId: $e');
    }
  }

  // DELETE
  Future<void> deleteTag(String tagId) async {
    try {
      await _tagsRefCollection.doc(tagId).delete();
    } catch (e) {
      throw TagServiceException('Failed to delete tag $tagId: $e');
    }
  }
}
