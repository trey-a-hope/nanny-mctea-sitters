import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  String service;
  String sitterID;
  String userID;
  DateTime date;


  static Appointment extractDocument(DocumentSnapshot ds) {
    Appointment appointment = Appointment();

    appointment.id = ds.data['id'];
    appointment.service = ds.data['service'];
    appointment.sitterID = ds.data['sitterID'];
    appointment.userID = ds.data['userID'];
    appointment.date = ds.data['date'].toDate();

    return appointment;
  }
}