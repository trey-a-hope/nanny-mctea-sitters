import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String id;
  DateTime time;
  String uid;
  String name;
  String phone;
  bool isSitter;

  static User extractDocument(DocumentSnapshot ds) {
    User user = User();

    user.id = ds.data['id'];
    user.uid = ds.data['uid'];
    user.email = ds.data['email'];
    user.time = ds.data['time'].toDate();
    user.name = ds.data['name'];
    user.phone = ds.data['phone'];
    user.isSitter = ds.data['isSitter'];

    return user;
  }
}

class Sitter extends User {
  String imgUrl;
  String details;
  String bio;

  static Sitter extractDocument(DocumentSnapshot ds) {
    Sitter sitter = Sitter();

    sitter.details = ds.data['details'];
    sitter.email = ds.data['email'];
    sitter.id = ds.data['id'];
    sitter.imgUrl = ds.data['imgUrl'];
    sitter.name = ds.data['name'];
    sitter.time = ds.data['time'].toDate();
    sitter.uid = ds.data['uid'];
    sitter.bio = ds.data['bio'];
    sitter.phone = ds.data['phone'];
    sitter.isSitter = ds.data['isSitter'];

    return sitter;
  }
}
