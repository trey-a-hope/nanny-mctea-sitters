import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/protocols.dart';

class Appointment extends ObjectMethods {
  String id;
  String sitterID;
  String userID;
  String slotID;
  String aptNo;
  String city;
  String email;
  String message;
  String name;
  String phone;
  String service;
  String street;

  User sitter;
  Slot slot;

  Appointment(
      {@required String id,
      @required String sitterID,
      @required String userID,
      @required String slotID,
      @required String aptNo,
      @required String city,
      @required String email,
      @required String message,
      @required String name,
      @required String phone,
      @required String service,
      @required String street}) {
    this.id = id;
    this.sitterID = sitterID;
    this.userID = userID;
    this.slotID = slotID;
    this.aptNo = aptNo;
    this.city = city;
    this.email = email;
    this.message = message;
    this.name = name;
    this.phone = phone;
    this.service = service;
    this.street = street;
  }

  static Appointment extractDocument(DocumentSnapshot ds) {
    return Appointment(
        id: ds.data['id'],
        aptNo: ds.data['aptNo'],
        city: ds.data['city'],
        email: ds.data['email'],
        message: ds.data['message'],
        name: ds.data['name'],
        phone: ds.data['phone'],
        service: ds.data['service'],
        sitterID: ds.data['sitterID'],
        slotID: ds.data['slotID'],
        street: ds.data['street'],
        userID: ds.data['userID']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aptNo': aptNo,
      'city': city,
      'email': email,
      'message': message,
      'name': name,
      'phone': phone,
      'service': service,
      'sitterID': sitterID,
      'slotID': slotID,
      'street': street,
      'userID': userID
    };
  }
}
