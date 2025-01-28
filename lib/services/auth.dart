import 'dart:async';

import 'package:somegame/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User? _userFromFirebaseUser(user) {
    return user != null ? User(id: user.uid, name: (user.displayName ?? '')) : null;
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Stream<User?> get userChanges {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }

  User? get currentUser => _userFromFirebaseUser(_auth.currentUser);

  Future signInAnonymously(name) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user!.updateDisplayName(name);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    return _auth.signOut();
  }

}