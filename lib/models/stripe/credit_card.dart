import 'package:flutter/material.dart';

class CreditCard {
  String id;
  String brand;
  String country;
  int exp_month;
  int exp_year;
  String last4;

  CreditCard(
      {@required this.id, @required this.brand, @required this.country, @required this.exp_month, @required this.exp_year, @required this.last4}) {
    id = this.id;
    brand = this.brand;
    country = this.country;
    exp_month = this.exp_month;
    exp_year = this.exp_year;
    last4 = this.last4;
  }
}
