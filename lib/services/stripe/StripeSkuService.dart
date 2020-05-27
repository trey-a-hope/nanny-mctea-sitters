import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/SkuModel.dart';
import 'dart:convert' show json;

abstract class IStripeSkuService {
  Future<SkuModel> retrieve({@required String skuID});
}

class StripeSkuService extends IStripeSkuService {
  @override
  Future<SkuModel> retrieve({String skuID}) async {
    Map data = {'skuID': skuID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrieveSku',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return SkuModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
