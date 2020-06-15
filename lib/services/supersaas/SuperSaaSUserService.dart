import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';

abstract class ISuperSaaSUserService {
  Future<int> create({
    @required String name,
    @required String fullName,
    @required String userID,
  });
}

class SuperSaaSUserService extends ISuperSaaSUserService {
  @override
  Future<int> create({
    @required String name,
    @required String fullName,
    @required String userID,
  }) async {
    Map data = {
      'name': name,
      'full_name': fullName,
      'userID': userID,
    };
    http.Response response = await http.post(
      '${endpoint}SuperSaaSCreateUser',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      var responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody != null && responseBody['errors'] != null) {
          String errorMessage = responseBody['errors'][0]['title'];
          throw PlatformException(message: errorMessage, code: '200');
        }

        //Extract saas idea from location url.
        final String location = responseBody['location'];

        //Create list for chacters.
        List<String> characters = List<String>();

        //Iterate over each characters unicode code-point. This is used to extract the id from the location string.
        location.runes.forEach((int rune) {
          String character = String.fromCharCode(rune);

          //Attempt to parse this character.
          int value = int.tryParse(character);

          //If parse failed, the character is not a number.
          if (value != null) {
            characters.add(character);
            print(character);
          }
        });

        //Convert array to string.
        final String saasIDString = characters.join();

        //Parse an int from the id.
        final int saasID = int.parse(saasIDString);

        //Return user id.
        return saasID;
      } else {
        throw Error();
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
