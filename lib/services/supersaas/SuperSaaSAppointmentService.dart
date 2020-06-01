import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' show Encoding, json;
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';

abstract class ISuperSaaSAppointmentService {
  Future<List<AppointmentModel>> getAvailableAppointments({
    @required int scheduleID,
    String resource,
    @required int limit,
    @required DateTime fromTime,
  });

  Future<void> create({
    @required int scheduleID,
    @required String userID,
    @required String email,
    @required String fullName,
    @required DateTime start,
    @required DateTime finish,
  });
}

class SuperSaaSAppointmentService extends ISuperSaaSAppointmentService {
  final DateFormat dateFormat = DateFormat(
      'yyyy-MM-dd HH:mm:ss'); //This format is needed for making api calls.

  @override
  Future<List<AppointmentModel>> getAvailableAppointments({
    @required int scheduleID,
    String resource,
    @required int limit,
    @required DateTime fromTime,
  }) async {
    Map data = {
      'scheduleID': '$scheduleID',
      'limit': '$limit',
      'fromTime': dateFormat.format(fromTime),
    };

    if (resource != null) {
      data['resource'] = resource;
    }

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

  @override
  Future<void> create({
    @required int scheduleID,
    @required String userID,
    @required String email,
    @required String fullName,
    @required DateTime start,
    @required DateTime finish,
  }) async {
    Map data = {
      'scheduleID': '$scheduleID',
      'userID': userID,
      'email': email,
      'fullName': fullName,
      'start': start.toString(),
      'finish': finish.toString(),
    };

    http.Response response = await http.post(
      '${endpoint}CreateAppointment',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      if (response.statusCode == 200) {
        //Response is simply json url where appointment is held, so just return.
        return;
      } else {
        throw Error();
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
