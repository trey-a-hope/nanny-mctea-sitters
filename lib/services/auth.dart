import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

abstract class Auth {
  Future<User> getCurrentUser();
}

class AuthImplementation extends Auth {
  AuthImplementation();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  @override
  Future<User> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      QuerySnapshot querySnapshot = await _db
          .collection('Users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
      return User.extractDocument(documentSnapshot);
    } catch (e) {
      throw Exception('Could not fetch user at this time.');
    }
  }
}
