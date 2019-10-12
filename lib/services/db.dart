import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

abstract class DB {
  Future<User> getUser({@required String id});
  Future<List<User>> getSitters();
  Future<List<Slot>> getSlots(
      {@required String sitterId, @required bool taken});
  Future<List<Slot>> setSlotTaken(
      {@required String sitterId,
      @required String slotId,
      @required bool taken});
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

  @override
  Future<List<Slot>> getSlots(
      {@required String sitterId, @required bool taken}) async {
    try {
      List<Slot> slots = List<Slot>();

      QuerySnapshot querySnapshot = await _usersDB
          .document(sitterId)
          .collection('slots')
          .where('taken', isEqualTo: taken)
          .getDocuments();

      List<DocumentSnapshot> slotDocs = querySnapshot.documents;

      for (int i = 0; i < slotDocs.length; i++) {
        Slot slot = Slot(
          id: slotDocs[i].data['id'],
          taken: slotDocs[i].data['taken'],
          time: slotDocs[i].data['time'].toDate(),
        );
        slots.add(slot);
      }

      return slots;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Slot>> setSlotTaken(
      {@required String sitterId,
      @required String slotId,
      @required bool taken}) {
    try {
      _usersDB
          .document(sitterId)
          .collection('slots')
          .document(slotId)
          .updateData(
        {'taken': taken},
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
