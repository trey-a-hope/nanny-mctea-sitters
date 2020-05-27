import 'package:flutter/material.dart';

class SubscriptionModel {
  final DateTime created;
  final String id;
  final String status;
  final String plan;

  SubscriptionModel({
    @required this.created,
    @required this.id,
    @required this.status,
    @required this.plan,
  });

  factory SubscriptionModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : SubscriptionModel(
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            status: map['status'],
            plan: map['plan']['id']
            // product: map['product'],
            // price: map['price'],
            // updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] * 1000),
            );
  }
}
