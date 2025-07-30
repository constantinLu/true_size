import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/exception/user_exception.dart';
import '../core/models/user.dart';


// Assuming your User model is imported
// import 'models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  // Get collection reference
  CollectionReference get _usersRef => _firestore.collection(_collection);

  // =============================================================================
  // CREATE OPERATIONS
  // =============================================================================

  /// Create a new user with auto-generated ID
  Future<String> createUser(TrueUser user) async {
    try {
      final docRef = await _usersRef.add(user.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Create a user with specific ID (useful for Firebase Auth UID)
  Future<void> createUserWithId(String userId, TrueUser user) async {
    try {
      await _usersRef.doc(userId).set(user.toFirestore());
    } catch (e) {
      throw UserServiceException('Failed to create user with ID $userId: $e');
    }
  }

  /// Create user if it doesn't exist, update if it does
  Future<void> createOrUpdateUser(String userId, TrueUser user) async {
    try {
      await _usersRef.doc(userId).set(
            user.toFirestore(),
            SetOptions(merge: true), // Merge with existing data
          );
    } catch (e) {
      throw UserServiceException('Failed to create or update user $userId: $e');
    }
  }

  // =============================================================================
  // READ OPERATIONS
  // =============================================================================

  /// Get user by ID
  Future<TrueUser?> getUserById(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();

      if (doc.exists) {
        return TrueUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw UserServiceException('Failed to get user $userId: $e');
    }
  }

  /// Get user by email
  Future<TrueUser?> getUserByEmail(String email) async {
    try {
      final querySnapshot =
          await _usersRef.where('email', isEqualTo: email).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        return TrueUser.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw UserServiceException('Failed to get user by email $email: $e');
    }
  }

  /// Get all users with pagination
  Future<List<TrueUser>> getAllUsers({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query =
          _usersRef.orderBy('createdAt', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => TrueUser.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw UserServiceException('Failed to get all users: $e');
    }
  }

  /// Search users by display name
  Future<List<TrueUser>> searchUsersByDisplayName(String searchTerm) async {
    try {
      final querySnapshot = await _usersRef
          .where('displayName', isGreaterThanOrEqualTo: searchTerm)
          .where('displayName', isLessThan: searchTerm + 'z')
          .orderBy('displayName')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => TrueUser.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw UserServiceException('Failed to search users by display name: $e');
    }
  }

  // /// Get users created in date range
  //  Future<List<TrueUser>> getUsersCreatedBetween(
  //   DateTime startDate,
  //   DateTime endDate,
  // ) async {
  //   try {
  //     final querySnapshot = await _usersRef
  //         .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
  //         .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
  //         .orderBy('createdAt', descending: true)
  //         .get();
  //
  //     return querySnapshot.docs.map((doc) => TrueUser.fromFirestore(doc)).toList();
  //   } catch (e) {
  //     throw UserServiceException('Failed to get users created between dates: $e');
  //   }
  // }
  //
  // /// Get recent users (last 30 days)
  //  Future<List<TrueUser>> getRecentUsers({int limit = 10}) async {
  //   final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
  //
  //   try {
  //     final querySnapshot = await _usersRef
  //         .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
  //         .orderBy('createdAt', descending: true)
  //         .limit(limit)
  //         .get();
  //
  //     return querySnapshot.docs.map((doc) => TrueUser.fromFirestore(doc)).toList();
  //   } catch (e) {
  //     throw UserServiceException('Failed to get recent users: $e');
  //   }
  // }
  //
  // /// Check if user exists
  //  Future<bool> userExists(String userId) async {
  //   try {
  //     final doc = await _usersRef.doc(userId).get();
  //     return doc.exists;
  //   } catch (e) {
  //     throw UserServiceException('Failed to check if user exists: $e');
  //   }
  // }
  //
  // /// Get user count
  // Future<int> getUserCount() async {
  //   try {
  //     final querySnapshot = await _usersRef.count().get();
  //     return querySnapshot.count ?? 0;
  //   } catch (e) {
  //     throw UserServiceException('Failed to get user count: $e');
  //   }
  // }
  //
  // // =============================================================================
  // // REAL-TIME STREAMS
  // // =============================================================================
  //
  // /// Stream user by ID (real-time updates)
  //  Stream<TrueUser?> streamUserById(String userId) {
  //   return _usersRef.doc(userId).snapshots().map((doc) {
  //     if (doc.exists) {
  //       return TrueUser.fromFirestore(doc);
  //     }
  //     return null;
  //   });
  // }
  //
  // /// Stream all users (real-time updates)
  //  Stream<List<TrueUser>> streamAllUsers({int limit = 20}) {
  //   return _usersRef
  //       .orderBy('createdAt', descending: true)
  //       .limit(limit)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => TrueUser.fromFirestore(doc)).toList());
  // }
  //
  // /// Stream recent users (real-time updates)
  //  Stream<List<TrueUser>> streamRecentUsers({int limit = 10}) {
  //   final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
  //
  //   return _usersRef
  //       .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
  //       .orderBy('createdAt', descending: true)
  //       .limit(limit)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => TrueUser.fromFirestore(doc)).toList());
  // }

  // =============================================================================
  // UPDATE OPERATIONS
  // =============================================================================

  /// Update entire user
  Future<void> updateUser(String userId, TrueUser user) async {
    try {
      await _usersRef.doc(userId).update(user.toFirestore());
    } catch (e) {
      throw UserServiceException('Failed to update user $userId: $e');
    }
  }

  /// Update specific fields
  Future<void> updateUserFields(
      String userId, Map<String, dynamic> fields) async {
    try {
      await _usersRef.doc(userId).update(fields);
    } catch (e) {
      throw UserServiceException(
          'Failed to update user fields for $userId: $e');
    }
  }

  /// Update display name
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await _usersRef.doc(userId).update({
        'displayName': displayName,
      });
    } catch (e) {
      throw UserServiceException(
          'Failed to update display name for $userId: $e');
    }
  }

  /// Update email
  Future<void> updateEmail(String userId, String email) async {
    try {
      await _usersRef.doc(userId).update({
        'email': email,
      });
    } catch (e) {
      throw UserServiceException('Failed to update email for $userId: $e');
    }
  }

  /// Update photo URL
  Future<void> updatePhotoURL(String userId, String? photoURL) async {
    try {
      await _usersRef.doc(userId).update({
        'photoURL': photoURL,
      });
    } catch (e) {
      throw UserServiceException('Failed to update photo URL for $userId: $e');
    }
  }

  /// Update last login timestamp
  Future<void> updateLastLogin(String userId) async {
    try {
      await _usersRef.doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserServiceException('Failed to update last login for $userId: $e');
    }
  }

  // =============================================================================
  // DELETE OPERATIONS
  // =============================================================================

  /// Delete user by ID
  Future<void> deleteUser(String userId) async {
    try {
      await _usersRef.doc(userId).delete();
    } catch (e) {
      throw UserServiceException('Failed to delete user $userId: $e');
    }
  }

  /// Delete multiple users by IDs
  Future<void> deleteMultipleUsers(List<String> userIds) async {
    if (userIds.isEmpty) return;

    try {
      final batch = _firestore.batch();

      for (final userId in userIds) {
        batch.delete(_usersRef.doc(userId));
      }

      await batch.commit();
    } catch (e) {
      throw UserServiceException('Failed to delete multiple users: $e');
    }
  }

  // /// Delete users created before a certain date
  //  Future<int> deleteUsersCreatedBefore(DateTime date) async {
  //   try {
  //     final querySnapshot = await _usersRef.where('createdAt', isLessThan: Timestamp.fromDate(date)).get();
  //
  //     if (querySnapshot.docs.isEmpty) return 0;
  //
  //     final batch = _firestore.batch();
  //     int deleteCount = 0;
  //
  //     for (final doc in querySnapshot.docs) {
  //       batch.delete(doc.reference);
  //       deleteCount++;
  //     }
  //
  //     await batch.commit();
  //     return deleteCount;
  //   } catch (e) {
  //     throw UserServiceException('Failed to delete users created before date: $e');
  //   }
  // }
}
