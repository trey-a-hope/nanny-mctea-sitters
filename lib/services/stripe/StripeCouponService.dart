import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'dart:convert' show json;

import 'package:nanny_mctea_sitters_flutter/models/stripe/CouponModel.dart';


abstract class IStripeCouponService {
  Future<CouponModel> retrieve({@required String couponID});
}

class StripeCouponService extends IStripeCouponService {
  @override
  Future<CouponModel> retrieve({String couponID}) async {
    Map data = {'couponID': couponID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrieveCoupon',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return CouponModel.fromMap(map: map);
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }
}
