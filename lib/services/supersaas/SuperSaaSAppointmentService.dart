import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';

abstract class ISuperSaaSAppointmentService {
  Future<List<AppointmentModel>> getAvailableAppointments({
    @required int scheduleID,
    @required String resource,
    @required int limit,
  });
}

class SuperSaaSAppointmentService extends ISuperSaaSAppointmentService {
  @override
  Future<List<AppointmentModel>> getAvailableAppointments({
    @required int scheduleID,
    @required String resource,
    @required int limit,
  }) async {
    Map data = {
      'scheduleID': '$scheduleID',
      'resource': resource,
      'limit': '$limit',
    };

    http.Response response = await http.post(
      '${endpoint}GetAvailableAppointments',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      List<dynamic> map = json.decode(response.body);

      if (response.statusCode == 200) {
        List<AppointmentModel> appointments = List<AppointmentModel>();

        map.forEach(
          (aMap) {
            AppointmentModel appointment = AppointmentModel(
              id: aMap['id'],
              bookings: aMap['bookings'],
              name: aMap['name'],
              count: aMap['count'],
              start: DateTime.parse(
                aMap['start'],
              ),
              finish: DateTime.parse(
                aMap['finish'],
              ),
            );

            appointments.add(appointment);
          },
        );

        return appointments;
      } else {
        throw Error();
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
