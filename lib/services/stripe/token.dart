// static Future<String> createToken(
//     {@required String number,
//     @required String exp_month,
//     @required String exp_year,
//     @required String cvc}) async {
//   Map data = {
//     'apiKey': apiKey,
//     'number': number,
//     'exp_month': exp_month,
//     'exp_year': exp_year,
//     'cvc': cvc
//   };

//   http.Response response = await http.post(
//     _baseURL + 'StripeCreateToken',
//     body: data,
//     headers: {'content-type': 'application/x-www-form-urlencoded'},
//   );

//   try {
//     Map map = json.decode(response.body);
//     return map['id'];
//   } catch (e) {
//     throw Exception();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/models/stripe/credit_card.dart';
import 'dart:convert' show Encoding, json;

import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';

abstract class StripeToken extends ChangeNotifier {
  Future<String> create(
      {@required String number,
      @required String exp_month,
      @required String exp_year,
      @required String cvc});
}

class StripeTokenImplementation extends StripeToken {
  StripeTokenImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String number,
      @required String exp_month,
      @required String exp_year,
      @required String cvc}) async {
    Map data = {
      'apiKey': apiKey,
      'number': number,
      'exp_month': exp_month,
      'exp_year': exp_year,
      'cvc': cvc
    };

    http.Response response = await http.post(
      endpoint + 'StripeCreateToken',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['id'];
    } catch (e) {
      throw Exception();
    }
  }

  // @override
  // Future<bool> delete(
  //     {@required String customerId, @required String cardId}) async {
  //   Map data = {'apiKey': apiKey, 'customerId': customerId, 'cardId': cardId};

  //   http.Response response = await http.post(
  //     endpoint + 'StripeDeleteCard',
  //     body: data,
  //     headers: {'content-type': 'application/x-www-form-urlencoded'},
  //   );

  //   try {
  //     Map map = json.decode(response.body);
  //     return map['deleted'];
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

}
