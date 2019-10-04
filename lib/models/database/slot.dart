import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Slot {
  String id;
  DateTime time;
  bool taken;

  Slot({@required this.id, @required this.time, @required this.taken});

  static Slot extractDocument(DocumentSnapshot ds) { 
    return Slot(id: ds.data['id'], time: ds.data['time'].toDate(), taken: ds.data['taken']);
  }
}