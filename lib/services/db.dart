import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

abstract class DB {
  //Users
  Future<User> getUser({@required String id});
  Future<List<User>> getSitters();
  Future<void> updateUser(
      {@required String userId, @required Map<String, dynamic> data});
  Future<void> createUser({@required Map<String, dynamic> data});

  //Appointments
  Future<List<Appointment>> getAppointments({@required String userId});
  Future<void> deleteAppointment({@required String appointmentId});
  Future<void> createAppointment({@required Map<String, dynamic> data});

  //Slots
  Future<List<Slot>> getSlots(
      {@required String sitterId, @required bool taken});
  Future<List<Slot>> setSlotTaken(
      {@required String sitterId,
      @required String slotId,
      @required bool taken});
  Future<Slot> getSlot({@required String sitterId, @required String slotId});
  Future<void> addSlot({@required String sitterId, @required DateTime time});
  Future<void> deleteSlot({@required String sitterId, @required String slotId});
}

class DBImplementation extends DB {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final CollectionReference _appointmentsDB =
      Firestore.instance.collection('Appointments');

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

  @override
  Future<List<Appointment>> getAppointments({String userId}) async {
    try {
      List<Appointment> appointments = List<Appointment>();

      QuerySnapshot querySnapshot = await _appointmentsDB
          .where('userID', isEqualTo: userId)
          .getDocuments();

      List<DocumentSnapshot> appointmentDocs = querySnapshot.documents;
      for (int i = 0; i < appointmentDocs.length; i++) {
        Appointment appointment =
            Appointment.extractDocument(appointmentDocs[i]);
        appointments.add(appointment);
      }
      return appointments;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Slot> getSlot({String sitterId, String slotId}) async {
    try {
      DocumentSnapshot slotDoc = await _usersDB
          .document(sitterId)
          .collection('slots')
          .document(slotId)
          .get();
      Slot slot = Slot.extractDocument(slotDoc);
      return slot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteAppointment({String appointmentId}) async {
    try {
      await _appointmentsDB.document(appointmentId).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> updateUser(
      {@required String userId, @required Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(userId).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addSlot({String sitterId, DateTime time}) async {
    final CollectionReference slotsColRef =
        _usersDB.document(sitterId).collection('slots');
    try {
      DocumentReference docRef = await slotsColRef.add(
        {'taken': false, 'time': time},
      );
      slotsColRef.document(docRef.documentID).updateData(
        {'id': docRef.documentID},
      );
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteSlot({String sitterId, String slotId}) async {
    try {
      await _usersDB
          .document(sitterId)
          .collection('slots')
          .document(slotId)
          .delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> createUser({Map<String, dynamic> data}) async {
    try {
      DocumentReference docRef = await _usersDB.add(data);
      await _usersDB
          .document(docRef.documentID)
          .updateData({'id': docRef.documentID});
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> createAppointment({Map<String, dynamic> data}) async {
    try {
      DocumentReference aptDocRef = await _appointmentsDB.add(data);
      await _appointmentsDB.document(aptDocRef.documentID).updateData(
        {'id': aptDocRef.documentID},
      );
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
