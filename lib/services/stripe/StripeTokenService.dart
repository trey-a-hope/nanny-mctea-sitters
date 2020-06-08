import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import 'package:nanny_mctea_sitters_flutter/constants.dart';

abstract class IStripeTokenService extends ChangeNotifier {
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc});
}

class StripeTokenService extends IStripeTokenService {
  @override
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc,
      @required String name}) async {
    Map data = {
      'number': number,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvc': cvc,
      'name': name
    };

    http.Response response = await http.post(
      '${endpoint}StripeCreateToken',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['statusCode']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
