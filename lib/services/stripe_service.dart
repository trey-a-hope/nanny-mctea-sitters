import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/models/stripe/CreditCard.dart';
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
      Map customerMap = json.decode(response.body);

      //Add default card if one is active.
      CreditCard card;
      if (customerMap['default_source'] != null) {
        Map cardMap = customerMap['sources']['data'][0];
        card = CreditCard(
          id: cardMap['id'],
          brand: cardMap['brand'],
          country: cardMap['country'],
          exp_month: cardMap['exp_month'],
          exp_year: cardMap['exp_year'],
          last4: cardMap['last4'],
        );
      }

      return Customer(
          id: customerMap['id'],
          default_source: customerMap['default_source'],
          card: card);
    } catch (e) {
      throw Exception();
    }
  }

  static Future<bool> deleteCard(
      {@required String customerId, @required String cardId}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId, 'cardId': cardId};

    http.Response response = await http.post(
      _baseURL + 'StripeDeleteCard',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['deleted'];
    } catch (e) {
      throw Exception();
    }
  }

  static Future<String> createToken(
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
      _baseURL + 'StripeCreateToken',
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

  static Future<String> createCard(
      {@required String customerId, @required String token}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId, 'token': token};

    http.Response response = await http.post(
      _baseURL + 'StripeCreateCard',
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
}
