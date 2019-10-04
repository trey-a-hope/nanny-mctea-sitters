import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/credit_card.dart';

class Charge {
  String id;
  double amount;
  DateTime created;
  String description;

  Charge({@required this.id, @required this.amount, @required this.created, @required this.description}) {
    id = this.id;
    amount = this.amount;
    created = this.created;
    description = this.description;
  }
}
