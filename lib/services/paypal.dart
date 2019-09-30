import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'dart:async';

final String _endpoint =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';
final String _contentType = 'application/json';

class PayPalService {
  static Future<http.Response> createPayment(
      {@required String description,
      @required String name,
      @required double price,
      @required String sku}) async {
    var data = json.encode(
      {'description': description, 'name': name, 'price': price, 'sku': sku},
    );

    return http.post(
      '$_endpoint/createPayment',
      body: data,
      headers: {'Content-Type': _contentType},
    );
  }
}

//nannymctea@gmail.com
//Ccw1995!