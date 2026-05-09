import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class AuthService {
  AuthService({required this.firebaseReady});

  final bool firebaseReady;
  AppUser? _demoUser;

  Stream<AppUser?> authStateChanges() {
    if (!firebaseReady) {
      return Stream.value(_demoUser ?? AppUser.demo());
    }

    return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final profile = AppUser(
          uid: user.uid,
          name: user.displayName ?? 'Student',
          email: user.email ?? '',
          bio: '',
          skillsOffered: const [],
          skillsWanted: const [],
          ratingAvg: 0,
          ratingCount: 0,
        );
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(profile.toMap());
        return profile;
      }
      return AppUser.fromMap(user.uid, doc.data()!);
    });
  }

  Future<AppUser> signIn(String email, String password) async {
    if (!firebaseReady) {
      _demoUser = AppUser.demo();
      return _demoUser!;
    }
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return AppUser.fromMap(uid, doc.data() ?? {});
  }

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!firebaseReady) {
      _demoUser = AppUser.demo().copyWith(name: name);
      return _demoUser!;
    }

    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user!.updateDisplayName(name);
    final profile = AppUser(
      uid: credential.user!.uid,
      name: name,
      email: email,
      bio: '',
      skillsOffered: const [],
      skillsWanted: const [],
      ratingAvg: 0,
      ratingCount: 0,
    );
    await FirebaseFirestore.instance.collection('users').doc(profile.uid).set({
      ...profile.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return profile;
  }

  Future<void> updateProfile(AppUser user) async {
    if (!firebaseReady) {
      _demoUser = user;
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<void> resetPassword(String email) async {
    if (!firebaseReady) return;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    _demoUser = null;
    if (firebaseReady) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
