import 'package:flutter/material.dart';

import 'CreditCardModel.dart';
import 'ShippingModel.dart';

class CustomerModel {
  final String id;
  final String email;
  final String defaultSource;
  final CreditCardModel card;
  final String name;
  final ShippingModel shipping;
  final List<CreditCardModel> sources;

  CustomerModel(
      {@required this.id,
      @required this.defaultSource,
      @required this.card,
      @required this.email,
      @required this.name,
      @required this.shipping,
      @required this.sources});
}
