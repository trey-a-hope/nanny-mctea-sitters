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
        List<String> characters = List<String>();

        location.runes.forEach((int rune) {
          String character = String.fromCharCode(rune);

          int value = int.tryParse(character);
          if (value != null) {
            characters.add(character);
            print(character);
          }
        });

        final String saasIDString = characters.join();
        final int saasID = int.parse(saasIDString);
        return saasID;

        //Create regex to extract number from string.
        // final RegExp regex = RegExp(r'^\D+$');

        // final String saasIDString = location.replaceAll("@[\d-]", "");
        // final int saasID = int.parse(saasIDString);
        // return saasID;

        // List<ResourceModel> resources = List<ResourceModel>();

        // responseBody.forEach(
        //   (rMap) {
        //     ResourceModel resource = ResourceModel(
        //       id: rMap['id'],
        //       name: rMap['name'],
        //     );

        //     resources.add(resource);
        //   },
        // );

        // return 0;
      } else {
        throw Error();
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
