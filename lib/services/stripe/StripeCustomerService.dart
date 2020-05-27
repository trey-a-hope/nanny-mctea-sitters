import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nanny_mctea_sitters_flutter/models/stripe/CreditCardModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ShippingModel.dart';
import 'dart:convert' show json;

import '../../constants.dart';


abstract class IStripeCustomerService {
  Future<String> create({String email, String name});
  Future<CustomerModel> retrieve({@required String customerID});
  Future<void> update(
      {@required String customerID,
      String city,
      String country,
      String line1,
      String postalCode,
      String state,
      String defaultSource,
      String name,
      String email});
  Future<bool> delete({@required String customerID});
}

class StripeCustomerService extends IStripeCustomerService {
  @override
  Future<String> create(
      {@required String email,
      @required String description,
      @required String name}) async {
    Map data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (description != null) {
      data['description'] = description;
    }

    if (email != null) {
      data['email'] = email;
    }

    http.Response response = await http.post(
      '${endpoint}StripeCreateCustomer',
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
  Future<CustomerModel> retrieve({@required String customerID}) async {
    Map data = {'customerID': customerID};

    http.Response response = await http.post(
      '${endpoint}StripeRetrieveCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);

      if (map['statusCode'] == null) {
        Map shippingMap = map['shipping'];
        Map sourcesMap = map['sources'];

        //Add default card if one is active.
        CreditCardModel card;
        if (map['default_source'] != null) {
          Map cardMap = map['sources']['data'][0];
          card = CreditCardModel(
              id: cardMap['id'],
              brand: cardMap['brand'],
              country: cardMap['country'],
              expMonth: cardMap['exp_month'],
              expYear: cardMap['exp_year'],
              last4: cardMap['last4'],
              name: cardMap['name']);
        }

        //Add sources if available.
        List<CreditCardModel> sources = List<CreditCardModel>();
        if (sourcesMap != null) {
          for (int i = 0; i < sourcesMap['data'].length; i++) {
            Map sourceMap = sourcesMap['data'][i];
            CreditCardModel creditCard = CreditCardModel(
                id: sourceMap['id'],
                country: sourceMap['country'],
                expMonth: sourceMap['exp_month'],
                expYear: sourceMap['exp_year'],
                brand: sourceMap['brand'],
                last4: sourceMap['last4'],
                name: sourceMap['name']);
            sources.add(creditCard);
          }
        }

        return CustomerModel(
            id: map['id'],
            email: map['email'],
            defaultSource: map['default_source'],
            card: card,
            name: map['name'],
            shipping: ShippingModel.fromMap(map: shippingMap),
            sources: sources);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> update(
      {String customerID,
      String city,
      String country,
      String line1,
      String postalCode,
      String state,
      String defaultSource,
      String name,
      String email}) async {
    Map data = {
      'customerID': customerID,
    };

    if (name != null) {
      data['name'] = name;
    }

    if (line1 != null) {
      data['line1'] = line1;
    }

    if (city != null) {
      data['city'] = city;
    }

    if (country != null) {
      data['country'] = country;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (defaultSource != null) {
      data['default_source'] = defaultSource;
    }

    if (postalCode != null) {
      data['postal_code'] = postalCode;
    }

    if (state != null) {
      data['state'] = state;
    }

    http.Response response = await http.post(
      '${endpoint}StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return;
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<bool> delete({String customerID}) async {
    Map data = {'customerID': customerID};

    http.Response response = await http.post(
      '${endpoint}StripeDeleteCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return map['deleted'];
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }
}
