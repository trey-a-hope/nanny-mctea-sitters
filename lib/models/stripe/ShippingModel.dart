import 'package:flutter/material.dart';

import 'AddressModel.dart';

class ShippingModel {
  final String name;
  final AddressModel address;

  ShippingModel({@required this.name, @required this.address});

  factory ShippingModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : ShippingModel(name: map['name'], address: AddressModel.fromMap(map: map['address']));
  }
}
