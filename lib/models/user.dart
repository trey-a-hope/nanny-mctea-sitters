import 'package:nanny_mctea_sitters_flutter/models/appointment.dart';

class User{
  String email;
  String imgUrl;
  String uid;
  String id;
  DateTime time;
  String phone;
  String fullName;
  
  List<Appointment> appointments = List<Appointment>();
}