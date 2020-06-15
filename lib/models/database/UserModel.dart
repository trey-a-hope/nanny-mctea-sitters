import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String bio;
  String customerID;
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
  String subscriptionID;
  String saasID;

  UserModel(
      {@required this.bio,
      @required this.customerID,
      @required this.details,
      @required this.email,
      @required this.fcmToken,
      @required this.id,
      @required this.imgUrl,
      @required this.isSitter,
      @required this.name,
      @required this.phone,
      @required this.time,
      @required this.uid,
      @required this.subscriptionID,
      @required this.saasID});

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'customerID': customerID,
      'details': details,
      'email': email,
      'fcmToken': fcmToken,
      'id': id,
      'imgUrl': imgUrl,
      'isSitter': isSitter,
      'name': name,
      'phone': phone,
      'time': time,
      'uid': uid,
      'subscriptionID': subscriptionID,
      'saasID': saasID,
    };
  }

  factory UserModel.fromDoc({@required DocumentSnapshot ds}) {
    return UserModel(
      bio: ds.data['bio'],
      customerID: ds.data['customerID'],
      details: ds.data['details'],
      email: ds.data['email'],
      fcmToken: ds.data['fcmToken'],
      id: ds.data['id'],
      imgUrl: ds.data['imgUrl'],
      isSitter: ds.data['isSitter'],
      name: ds.data['name'],
      phone: ds.data['phone'],
      time: ds.data['time'].toDate(),
      uid: ds.data['uid'],
      subscriptionID: ds.data['subscriptionID'],
      saasID: ds.data['saasID'],
    );
  }
}
