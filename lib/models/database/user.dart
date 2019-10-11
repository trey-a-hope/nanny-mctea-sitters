import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  User(
      {@required String bio,
      @required String customerId,
      @required String details,
      @required String email,
      @required String fcmToken,
      @required String id,
      @required String imgUrl,
      @required bool isSitter,
      @required String name,
      @required String phone,
      @required DateTime time,
      @required String uid}) {
    this.bio = bio;
    this.customerId = customerId;
    this.details = details;
    this.email = email;
    this.fcmToken = fcmToken;
    this.id = id;
    this.imgUrl = imgUrl;
    this.isSitter = isSitter;
    this.name = name;
    this.phone = phone;
    this.time = time;
    this.uid = uid;
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'customerId': customerId,
      'details': details,
      'email': email,
      'fcmToken': fcmToken,
      'id': id,
      'imgUrl': imgUrl,
      'isSitter': isSitter,
      'name': name,
      'phone': phone,
      'time': time,
      'uid': uid
    };
  }

  static User extractDocument(DocumentSnapshot ds) {
    return User(
        bio: ds.data['bio'],
        customerId: ds.data['customerId'],
        details: ds.data['details'],
        email: ds.data['email'],
        fcmToken: ds.data['fcmToken'],
        id: ds.data['id'],
        imgUrl: ds.data['imgUrl'],
        isSitter: ds.data['isSitter'],
        name: ds.data['name'],
        phone: ds.data['phone'],
        time: ds.data['time'].toDate(),
        uid: ds.data['uid']);
  }
}
