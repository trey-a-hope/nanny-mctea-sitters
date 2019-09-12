import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/models/appointment.dart';

class User {
  String email;
  String uid;
  String id;
  DateTime time;
  String phone;
  String name;

  static User extractDocument(DocumentSnapshot ds) {
    User user = User();

    user.id = ds.data['id'];
    user.uid = ds.data['uid'];
    user.email = ds.data['email'];
    user.name = ds.data['name'];
    user.phone = ds.data['phone'];

    return user;
  }
}
