import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String bio;
  String customerId;
  String details;
  String email;
  String fcmToken;
  String id;
  String imgUrl;
  bool isSitter;
  String name;
  String phone;
  DateTime time;
  String uid;

  static User extractDocument(DocumentSnapshot ds) {
    User user = User();

    user.bio = ds.data['bio'];
    user.customerId = ds.data['customerId'];
    user.details = ds.data['details'];
    user.email = ds.data['email'];
    user.fcmToken = ds.data['fcmToken'];
    user.id = ds.data['id'];
    user.imgUrl = ds.data['imgUrl'];
    user.isSitter = ds.data['isSitter'];
    user.name = ds.data['name'];
    user.phone = ds.data['phone'];
    user.time = ds.data['time'].toDate();
    user.uid = ds.data['uid'];

    return user;
  }
}

// class Sitter extends User {
//   String imgUrl;
//   String details;
//   String bio;

//   static Sitter extractDocument(DocumentSnapshot ds) {
//     Sitter sitter = Sitter();

//     sitter.details = ds.data['details'];
//     sitter.email = ds.data['email'];
//     sitter.id = ds.data['id'];
//     sitter.imgUrl = ds.data['imgUrl'];
//     sitter.name = ds.data['name'];
//     sitter.time = ds.data['time'].toDate();
//     sitter.uid = ds.data['uid'];
//     sitter.bio = ds.data['bio'];
//     sitter.phone = ds.data['phone'];
//     sitter.isSitter = ds.data['isSitter'];
//     sitter.fcmToken = ds.data['fcmToken'];

//     return sitter;
//   }
// }
