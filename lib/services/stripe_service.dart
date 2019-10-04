import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';

final String _testSecretKey =
    'sk_test_IM9ti8gurtw7BjCPCtm9hRar'; //THIS IS SCORBORDS!
final String _testPublishableKey = '?';
final String _liveSecretKey = '?';
final String _livePublishableKey = '?';
final String _baseURL =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';

final String apiKey = _testSecretKey;

class StripeService {
  static Future<String> createCustomer(
      {@required String email, @required String description}) async {
    Map data = {'apiKey': apiKey, 'email': email, 'description': description};

    http.Response response = await http.post(
      _baseURL + 'StripeCreateCustomer',
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

  static Future<Customer> retrieveCustomer(
      {@required String customerId}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId};

    http.Response response = await http.post(
      _baseURL + 'StripeRetrieveCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);

      return Customer(
        id: map['id'],
        default_source: map['default_source'],
      );
    } catch (e) {
      throw Exception();
    }
  }
}
