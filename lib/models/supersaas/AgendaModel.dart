import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendaModel {
  //        "id": 56013317,
  // "start": "2020-06-17T10:00",
  // "finish": "2020-06-17T15:00",
  // "resource_id": 709496,
  // "created_on": "2020-06-15T01:41:28Z",
  // "user_id": 7531873,
  // "res_name": "Talea Chenault",
  // "created_by": "Trey Hope / *",
  // "price": null,
  // "deleted": false,
  // "full_name": "Trey Hope",
  // "phone": null,
  // "schedule_id": 489593,
  // "schedule_name": "Baby Sitting Schedule"

  int id;
  String full_name;
  String phone;
  DateTime start;
  DateTime finish;
  String res_name;
  int user_id;
  int resource_id;

  AgendaModel({
    @required this.id,
    @required this.full_name,
    @required this.phone,
    @required this.res_name,
    @required this.user_id,
    @required this.start,
    @required this.finish,
    @required this.resource_id,
  });

  factory AgendaModel.fromJSON(Map data) {
    return AgendaModel(
      id: data['id'],
      full_name: data['full_name'],
      phone: data['phone'],
      start: DateTime.now(),
      finish: DateTime.now(),
      res_name: data['res_name'],
      user_id: data['user_id'],
      resource_id: data['resource_id'],
    );
  }
}
