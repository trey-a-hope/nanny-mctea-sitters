import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/protocols.dart';

class Conversation extends ObjectMethods {
  String title;
  String lastMessage;
  String imageUrl;
  String senderId;
  String sendeeId;
  DateTime time;
  bool read;
  User oppositeUser;

  Conversation(
      {@required String title,
      @required String lastMessage,
      @required String imageUrl,
      @required String senderId,
      @required String sendeeId,
      @required DateTime time,
      bool read,
      User oppositeUser}) {
    this.title = title;
    this.lastMessage = lastMessage;
    this.imageUrl = imageUrl;
    this.senderId = senderId;
    this.sendeeId = sendeeId;
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
      senderId: data['senderId'],
      sendeeId: data['sendeeId'],
      time: data['time'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lastMessage': lastMessage,
      'imageUrl': imageUrl,
      'senderId': senderId,
      'sendeeId': sendeeId,
      'time': time
    };
  }
}
