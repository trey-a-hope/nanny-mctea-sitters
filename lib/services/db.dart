import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

abstract class DB {
  Future<User> getUser({@required String id});
  Future<List<User>> getSitters();
}

class DBImplementation extends DB {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<User> getUser({@required String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.document(id).get();
      return User.extractDocument(documentSnapshot);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<User>> getSitters() async {
    try {
      List<User> sitters = List<User>();

      //Get sitters.
      QuerySnapshot querySnapshot =
          await _usersDB.where('isSitter', isEqualTo: true).getDocuments();
      querySnapshot.documents.forEach(
        (document) {
          User sitter = User.extractDocument(document);
          sitters.add(sitter);
        },
      );

      return sitters;
    } catch (e) {
      return null;
    }
  }
}
