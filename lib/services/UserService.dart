import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

abstract class IUserService {
  Future<UserModel> retrieveUser({@required String id});
  Future<List<UserModel>> retrieveUsers({@required bool isSitter});
  // Future<List<UserModel>> getSitters();
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data});
  Future<void> createUser({@required UserModel user});
}

class UserService extends IUserService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<UserModel> retrieveUser({@required String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.document(id).get();
      return UserModel.fromDoc(ds: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserModel>> retrieveUsers({@required bool isSitter}) async {
    try {
      Query query = _usersDB;

      if (isSitter != null) {
        query = query.where('isSitter', isEqualTo: isSitter);
      }

      List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
      List<UserModel> users = List<UserModel>();
      for (int i = 0; i < docs.length; i++) {
        users.add(
          UserModel.fromDoc(ds: docs[i]),
        );
      }

      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      DocumentReference docRef = _usersDB.document();
      user.id = docRef.documentID;
      docRef.setData(user.toMap());
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(userID).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
