import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<FirebaseUser> onAuthStateChanged();
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password});
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  Future<FirebaseUser> getFirebaseUser();
}

class AuthService extends IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      QuerySnapshot querySnapshot = await _usersDB
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
      return UserModel.fromDoc(ds: documentSnapshot);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() {
    try {
      return _auth.signOut();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Stream<FirebaseUser> onAuthStateChanged() {
    try {
      return _auth.onAuthStateChanged;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    try {
      return _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    try {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<FirebaseUser> getFirebaseUser() async {
    try {
      return await _auth.currentUser();
    } catch (e) {
      return null;
    }
  }
}
