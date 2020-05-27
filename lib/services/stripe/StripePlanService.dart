import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'dart:convert' show json;
import 'package:nanny_mctea_sitters_flutter/models/stripe/PlanModel.dart';

abstract class IStripePlanService {
  Future<PlanModel> retrieve({@required String planID});
}

class StripePlanService extends IStripePlanService {
  @override
  Future<PlanModel> retrieve({@required String planID}) async {
    Map data = {'id': planID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrievePlan',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return PlanModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
