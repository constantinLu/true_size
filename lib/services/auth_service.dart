import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:true_size/core/models/user.dart';

import '../../app/app.locator.dart';
import 'firestore_service.dart';

class AuthService with ListenableServiceMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  /// The user's uploaded avatar bytes (null when none set). Stored base64 on the
  /// Firestore `users` doc; shown in the top bar chip and profile screen.
  Uint8List? _avatarBytes;
  Uint8List? get avatarBytes => _avatarBytes;

  /// Loads the persisted avatar into memory (call after login / at startup).
  Future<void> loadAvatar() async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    try {
      final b64 = await _firestoreService.getAvatar(uid);
      _avatarBytes = (b64 == null || b64.isEmpty) ? null : base64Decode(b64);
      notifyListeners();
    } catch (_) {
      // Best-effort; keep whatever is in memory.
    }
  }

  Future<void> uploadAvatar(Uint8List bytes) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _firestoreService.saveAvatar(uid, base64Encode(bytes));
    _avatarBytes = bytes;
    notifyListeners();
  }

  Future<void> removeAvatar() async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _firestoreService.saveAvatar(uid, null);
    _avatarBytes = null;
    notifyListeners();
  }

  /// The OAuth *web* client id from google-services.json (client_type 3). Passed
  /// as [GoogleSignIn.initialize]'s serverClientId so the returned idToken has
  /// the audience Firebase expects. Without it, idToken is null on Android under
  /// google_sign_in 7.x.
  static const String _serverClientId =
      '566564532603-kg8rlb793c5cs9u9i1ajsb2n4j1a4pu8.apps.googleusercontent.com';

  bool _googleInitialized = false;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// google_sign_in 7.x requires a one-time [initialize] before authenticating.
  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _googleInitialized = true;
  }

  Future<TrueUser?> signInWithGoogle() async {
    try {
      await _ensureGoogleInitialized();

      // google_sign_in 7.x: authenticate() replaces signIn(); it throws a
      // GoogleSignInException (code == canceled) when the user backs out.
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate(scopeHint: const ['email']);

      // In 7.x the authentication object exposes only the idToken; that is all
      // Firebase needs to build a Google credential.
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
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
        return userModel;
      }
      return null;
    } on GoogleSignInException catch (e) {
      // A user-cancelled sign-in is not an error worth surfacing.
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
    _avatarBytes = null;
    notifyListeners();
  }

  Future<TrueUser?> getCurrentUserModel() async {
    if (currentUser != null) {
      return await _firestoreService.getUser(currentUser!.uid);
    }
    return null;
  }
}
