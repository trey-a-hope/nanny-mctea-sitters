import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  FormData formData = FormData();
  String id;
  String sitterID;
  String slotID;
  String userID;

  static Appointment extractDocument(DocumentSnapshot ds) {
    Appointment appointment = Appointment();

    appointment.formData.aptNo = ds.data['formData']['aptNo'];
    appointment.formData.city = ds.data['formData']['city'];
    appointment.id = ds.data['id'];
    appointment.formData.email = ds.data['formData']['email'];
    appointment.formData.message = ds.data['formData']['message'];
    appointment.formData.name = ds.data['formData']['name'];
    appointment.formData.phone = ds.data['formData']['phone'];
    appointment.formData.service = ds.data['formData']['service'];
    appointment.sitterID = ds.data['sitterID'];
    appointment.slotID = ds.data['slotID'];
    appointment.formData.street = ds.data['formData']['street'];
    appointment.userID = ds.data['userID'];

    return appointment;
  }
}

class FormData {
  String aptNo;
  String city;
  String email;
  String message;
  String name;
  String phone;
  String service;
  String street;


}
