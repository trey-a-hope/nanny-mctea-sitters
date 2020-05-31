import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentModel {
  List<dynamic> bookings;
  int id;
  String name;
  int count;
  DateTime start;
  DateTime finish;

  AppointmentModel({
    @required List<dynamic> bookings,
    @required int id,
    @required String name,
    @required int count,
    @required DateTime start,
    @required DateTime finish,
  }) {
    this.bookings = bookings;
    this.id = id;
    this.name = name;
    this.count = count;
    this.start = start;
    this.finish = finish;
  }

  factory AppointmentModel.fromJSON(Map data) {
    return AppointmentModel(
      bookings: data['bookings'],
      id: data['id'],
      name: data['name'],
      count: data['count'],
      start: DateTime.now(),
      finish: DateTime.now(),
    );
  }
}
