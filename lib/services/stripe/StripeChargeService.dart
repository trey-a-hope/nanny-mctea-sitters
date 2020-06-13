import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';
import 'dart:convert' show Encoding, json;

import '../../constants.dart';

abstract class IStripeChargeService {
  Future<String> create(
      {@required int amount,
      @required String description,
      @required String customerID});
  Future<ChargeModel> retrieve({@required String chargeID});
  Future<List<ChargeModel>> list({@required String customerID});
}

class StripeChargeService extends IStripeChargeService {
  @override
  Future<String> create(
      {@required int amount,
      @required String description,
      @required String customerID}) async {
    Map data = {
      'amount': amount.toString(),
      'description': description,
      'customerID': customerID,
    };

    http.Response response = await http.post(
      '${endpoint}StripeCreateCharge',
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
  Future<ChargeModel> retrieve({@required String chargeID}) async {
    Map data = {'chargeID': chargeID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrieveCharge',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return ChargeModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<List<ChargeModel>> list({@required String customerID}) async {
    Map data = {'customerID': customerID};

    http.Response response = await http.post(
      '${endpoint}StripeListAllCharges',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        List<ChargeModel> charges = List<ChargeModel>();
        for (var i = 0; i < map['data'].length; i++) {
          Map chargeMap = map['data'][i];
          charges.add(
            ChargeModel.fromMap(map: chargeMap),
          );
        }
        return charges;
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
