import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  String id;
  DateTime time;
  bool taken;

  static Slot extractDocument(DocumentSnapshot ds) { 
    Slot slot = Slot();

    slot.id = ds.data['id'];
    slot.time = ds.data['time'].toDate();
    slot.taken = ds.data['taken'];
    
    return slot;
  }
}