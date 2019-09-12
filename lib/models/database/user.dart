import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';

class User {
  String email;
  String id;
  DateTime time;
  String uid;

  static User extractDocument(DocumentSnapshot ds) {
    User user = User();

    user.id = ds.data['id'];
    user.uid = ds.data['uid'];
    user.email = ds.data['email'];
    user.time = ds.data['time'].toDate();

    return user;
  }
}
