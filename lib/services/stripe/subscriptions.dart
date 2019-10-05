import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class StripeSubscription extends ChangeNotifier {
  Future<String> create({@required String customerId, @required String plan});
}

class StripeSubscriptionImplementation extends StripeSubscription {
  StripeSubscriptionImplementation(
      {@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String customerId, @required String plan}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerId, 'plan': plan};

    http.Response response = await http.post(
      endpoint + 'StripeCreateSubscription',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);

      if (map['id'] == null) {
        throw Exception(['Could not create subscription.']);
      }

      return map['id'];
    } catch (e) {
      throw Exception();
    }
  }
}
