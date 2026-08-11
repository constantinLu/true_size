import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:true_size/core/models/user.dart';

import '../../app/app.locator.dart';
import 'firestore_service.dart';

class AuthService with ListenableServiceMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<TrueUser?> signInWithGoogle() async {
    try {
      print('signInWithGoogle: started');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('signInWithGoogle: googleUser = $googleUser');

      if (googleUser == null) {
        print('signInWithGoogle: user cancelled or signIn returned null');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('signInWithGoogle: accessToken null = ${googleAuth.accessToken == null}');
      print('signInWithGoogle: idToken null = ${googleAuth.idToken == null}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('signInWithGoogle: Firebase credential created');

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      print('signInWithGoogle: Firebase user = ${user?.uid}');

      if (user != null) {
        final userModel = TrueUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestoreService.saveUser(userModel);
        print('signInWithGoogle: user saved to Firestore');
        return userModel;
      }

      print('signInWithGoogle: Firebase user is null');
      return null;
    } on PlatformException catch (e, st) {
      print('Platform exception: ${e.code} - ${e.message}');
      print(st);
      rethrow;
    } on FirebaseAuthException catch (e, st) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      print(st);
      rethrow;
    } catch (e, st) {
      print('Error signing in with Google: $e');
      print(st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  Future<TrueUser?> getCurrentUserModel() async {
    if (currentUser != null) {
      return await _firestoreService.getUser(currentUser!.uid);
    }
    return null;
  }
}
