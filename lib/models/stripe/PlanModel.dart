import 'package:flutter/material.dart';

class PlanModel {
  final DateTime created;
  final String id;
  final String product;
  final int amount;

  PlanModel({
    @required this.created,
    @required this.id,
    @required this.product,
    @required this.amount,
  });

  factory PlanModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : PlanModel(
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            product: map['product'],
            amount: map['amount'],
          );
  }
}
