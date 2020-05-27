import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'dart:convert' show json;

import 'package:nanny_mctea_sitters_flutter/models/stripe/SubscriptionModel.dart';

abstract class IStripeSubscriptionService {
  Future<SubscriptionModel> retrieve({@required String subscriptionID});
  Future<String> create({@required String customerID, @required String planID});
  Future<bool> cancel({@required String subscriptionID});
}

class StripeSubscriptionService extends IStripeSubscriptionService {
  @override
  Future<SubscriptionModel> retrieve({@required String subscriptionID}) async {
    Map data = {'subscriptionID': subscriptionID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrieveSubscription',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return SubscriptionModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<bool> cancel(
      {@required String subscriptionID,
      @required bool invoiceNow,
      @required bool prorate}) async {
    Map data = {
      'subscriptionID': subscriptionID,
      'invoice_now': invoiceNow.toString(),
      'prorate': prorate.toString()
    };

    http.Response response = await http.post(
      '${endpoint}StripeCancelSubscription',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['status'] == 'canceled';
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<String> create(
      {@required String customerID, @required String planID}) async {
    Map data = {
      'customerID': customerID,
      'plan': planID,
    };

    http.Response response = await http.post(
      '${endpoint}StripeCreateSubscription',
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
}
