import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/protocols.dart';

class Conversation extends ObjectMethods {
  String title;
  String lastMessage;
  String imageUrl;
  String senderID;
  String sendeeID;
  DateTime time;
  bool read;
  User oppositeUser;

  Conversation(
      {@required String title,
      @required String lastMessage,
      @required String imageUrl,
      @required String senderID,
      @required String sendeeID,
      @required DateTime time,
      bool read,
      User oppositeUser}) {
    this.title = title;
    this.lastMessage = lastMessage;
    this.imageUrl = imageUrl;
    this.senderID = senderID;
    this.sendeeID = sendeeID;
    this.time = time;
    this.read = read;
    this.oppositeUser = oppositeUser;
  }

  static Conversation extractDocument(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return Conversation(
      title: data['title'],
      lastMessage: data['lastMessage'],
      imageUrl: data['imageUrl'],
      senderID: data['senderID'],
      sendeeID: data['sendeeID'],
      time: data['time'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lastMessage': lastMessage,
      'imageUrl': imageUrl,
      'senderID': senderID,
      'sendeeID': sendeeID,
      'time': time
    };
  }
}
