import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';

abstract class IDBService {
  //Appointments
  Future<List<Appointment>> getAppointments({@required String userID});
  Future<void> deleteAppointment({@required String appointmentID});
  Future<void> createAppointment({@required Map<String, dynamic> data});

  //Slots
  Future<List<Slot>> getSlots(
      {@required String sitterID, @required bool taken});
  Future<void> setSlotTaken(
      {@required String sitterID,
      @required String slotID,
      @required bool taken});
  Future<Slot> getSlot({@required String sitterID, @required String slotID});
  Future<void> addSlot({@required String sitterID, @required DateTime time});
  Future<void> deleteSlot({@required String sitterID, @required String slotID});
}

class DBService extends IDBService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final CollectionReference _appointmentsDB =
      Firestore.instance.collection('Appointments');

  @override
  Future<List<Slot>> getSlots(
      {@required String sitterID, @required bool taken}) async {
    try {
      List<Slot> slots = List<Slot>();

      QuerySnapshot querySnapshot = await _usersDB
          .document(sitterID)
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
  Future<void> setSlotTaken(
      {@required String sitterID,
      @required String slotID,
      @required bool taken}) {
    try {
      return _usersDB
          .document(sitterID)
          .collection('slots')
          .document(slotID)
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
  Future<List<Appointment>> getAppointments({String userID}) async {
    try {
      List<Appointment> appointments = List<Appointment>();

      QuerySnapshot querySnapshot = await _appointmentsDB
          .where('userID', isEqualTo: userID)
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
  Future<Slot> getSlot({String sitterID, String slotID}) async {
    try {
      DocumentSnapshot slotDoc = await _usersDB
          .document(sitterID)
          .collection('slots')
          .document(slotID)
          .get();
      Slot slot = Slot.extractDocument(slotDoc);
      return slot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteAppointment({String appointmentID}) async {
    try {
      await _appointmentsDB.document(appointmentID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addSlot({String sitterID, DateTime time}) async {
    final CollectionReference slotsColRef =
        _usersDB.document(sitterID).collection('slots');
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
  Future<void> deleteSlot({String sitterID, String slotID}) async {
    try {
      await _usersDB
          .document(sitterID)
          .collection('slots')
          .document(slotID)
          .delete();
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
