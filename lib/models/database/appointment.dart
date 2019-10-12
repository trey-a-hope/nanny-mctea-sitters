import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

class Appointment {
  String id;
  String sitterID;
  String userID;
  String slotID;
  String aptNo;
  String city;
  String email;
  String message;
  String name;
  String phone;
  String service;
  String street;

  User sitter;
  Slot slot;

  static Appointment extractDocument(DocumentSnapshot ds) {
    Appointment appointment = Appointment();

    appointment.aptNo = ds.data['aptNo'];
    appointment.city = ds.data['city'];
    appointment.id = ds.data['id'];
    appointment.email = ds.data['email'];
    appointment.message = ds.data['message'];
    appointment.name = ds.data['name'];
    appointment.phone = ds.data['phone'];
    appointment.service = ds.data['service'];
    appointment.sitterID = ds.data['sitterID'];
    appointment.slotID = ds.data['slotID'];
    appointment.street = ds.data['street'];
    appointment.userID = ds.data['userID'];

    return appointment;
  }
}

