import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChargeModel {
  final String id;
  final double amount;
  final DateTime created;
  final String description;

  ChargeModel(
      {@required this.id,
      @required this.amount,
      @required this.created,
      @required this.description});

  factory ChargeModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : ChargeModel(
            description: map['description'],
            id: map['id'],
            amount: map['amount'] / 100,
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
          );
  }
}
