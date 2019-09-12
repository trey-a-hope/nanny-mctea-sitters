import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  DateTime date;
  String id;
  String service;
  String sitterID;
  String userID;

  static Appointment extractDocument(DocumentSnapshot ds) {
    Appointment appointment = Appointment();

    appointment.date = ds.data['date'].toDate();
    appointment.id = ds.data['id'];
    appointment.service = ds.data['service'];
    appointment.sitterID = ds.data['sitterID'];
    appointment.userID = ds.data['userID'];

    return appointment;
  }
}
