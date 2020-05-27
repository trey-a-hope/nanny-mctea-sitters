import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import '../../constants.dart';


abstract class IStripeChargeService {
  Future<String> create(
      {@required int amount,
      @required String description,
      @required String customerID});
}

class StripeChargeService extends IStripeChargeService {
  @override
  Future<String> create(
      {@required int amount,
      @required String description,
      @required String customerID}) async {
    Map data = {
      'amount': amount.toString(),
      'description': description,
      'customerID': customerID,
    };

    http.Response response = await http.post(
      '${endpoint}StripeCreateCharge',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
