
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/models/stripe/credit_card.dart';
import 'dart:convert' show Encoding, json;

import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';

abstract class StripeCustomer extends ChangeNotifier {
  Future<String> create({@required String email, @required String description});
  Future<Customer> retrieve({@required String customerId});
  Future<void> update({@required String customerId, @required String token});
}

class StripeCustomerImplementation extends StripeCustomer {
  StripeCustomerImplementation(
      {@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String email, @required String description}) async {
    Map data = {'apiKey': apiKey, 'email': email, 'description': description};

    http.Response response = await http.post(
      endpoint + 'StripeCreateCustomer',
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

  @override
  Future<Customer> retrieve({@required String customerId}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId};

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveCustomer',
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

    @override
  Future<void> update(
      {@required String customerId, @required String token}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId, 'token': token};

    http.Response response = await http.post(
      endpoint + 'StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception();
    }
  }
}
