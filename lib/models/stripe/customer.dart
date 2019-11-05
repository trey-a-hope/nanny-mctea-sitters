import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/credit_card.dart';

class Customer {
  String id;
  String email;
  String default_source;
  CreditCard card;
  bool isSubscribed;

  Customer({@required this.id, @required this.default_source, @required this.card, @required this.isSubscribed}) {
    id = this.id;
    email = this.email;
    default_source = this.default_source;
    card = this.card;
    isSubscribed = this.isSubscribed;
  }
}
