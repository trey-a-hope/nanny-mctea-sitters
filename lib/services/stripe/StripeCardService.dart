import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:nanny_mctea_sitters_flutter/constants.dart';

abstract class IStripeCardService {
  Future<String> create({@required String customerID, @required String token});
  Future<bool> delete({@required String customerID, @required String cardID});
}

class StripeCardService extends IStripeCardService {
  @override
  Future<String> create(
      {@required String customerID, @required String token}) async {
    Map data = {'customerID': customerID, 'token': token};

    http.Response response = await http.post(
      '${endpoint}StripeCreateCard',
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

  @override
  Future<bool> delete(
      {@required String customerID, @required String cardID}) async {
    Map data = {'customerID': customerID, 'cardID': cardID};

    http.Response response = await http.post(
      '${endpoint}StripeDeleteCard',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['deleted'];
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
