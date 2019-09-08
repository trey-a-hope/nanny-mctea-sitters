import 'package:nanny_mctea_sitters_flutter/models/appointment.dart';

class User {
  String email;
  String uid;
  String id;
  DateTime time;
  String phone;
  String name;
  List<Appointment> appointments = List<Appointment>();
}