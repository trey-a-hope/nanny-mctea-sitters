import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';

abstract class ISuperSaaSResourceService {
  Future<List<ResourceModel>> list({
    @required int scheduleID,
  });
}

class SuperSaaSResourceService extends ISuperSaaSResourceService {
  @override
  Future<List<ResourceModel>> list({
    @required int scheduleID,
  }) async {
    Map data = {
      'scheduleID': '$scheduleID',
    };
    http.Response response = await http.post(
      '${endpoint}ListAllResources',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      List<dynamic> map = json.decode(response.body);

      if (response.statusCode == 200) {
        List<ResourceModel> resources = List<ResourceModel>();

        map.forEach(
          (rMap) {
            ResourceModel resource = ResourceModel(
              id: rMap['id'],
              name: rMap['name'],
            );

            resources.add(resource);
          },
        );

        return resources;
      } else {
        throw Error();
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
