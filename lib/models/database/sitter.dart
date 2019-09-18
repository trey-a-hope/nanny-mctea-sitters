import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

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

    return sitter;
  }
}

// details
// email
// id
// imgUrl
// name
// time
// uid
