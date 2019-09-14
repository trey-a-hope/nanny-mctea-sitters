import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String id;
  DateTime time;
  String uid;
  String name;
  String phone;

  static User extractDocument(DocumentSnapshot ds) {
    User user = User();

    user.id = ds.data['id'];
    user.uid = ds.data['uid'];
    user.email = ds.data['email'];
    user.time = ds.data['time'].toDate();
    user.name = ds.data['name'];
    user.phone = ds.data['phone'];

    return user;
  }
}
