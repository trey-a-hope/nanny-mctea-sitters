import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSResourceService.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'Bloc.dart';

class BookSitterCalendarBloc
    extends Bloc<BookSitterCalendarEvent, BookSitterCalendarState> {
  //todo: dispose this.

  BookSitterCalendarBloc({
    @required this.hours,
    @required this.cost,
  });

  final int hours; //Number of hours this appointment will last.
  final double cost; //Total cost of the appointment.

  final CalendarController _calendarController = CalendarController();
  List<AppointmentModel> _availableAppointments;
  Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();
  List<dynamic> _availableSlots = List<dynamic>();
  UserModel currentUser; //Current user of the app.
  List<ResourceModel> resources; //Available baby sitters.
  ResourceModel
      selectedResource; //Selected baby sitter to filter appointments on.
  DateTime now; //Look for appiontments after this date.

  @override
  BookSitterCalendarState get initialState => BookSitterCalendarState();

  @override
  Stream<BookSitterCalendarState> mapEventToState(
      BookSitterCalendarEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //Fetch current user.
        currentUser = await locator<AuthService>().getCurrentUser();

        //Fetch resources, (baby sitters).
        resources = await locator<SuperSaaSResourceService>()
            .list(scheduleID: SAAS_BABY_SITTING_SCHEDULE_ID);

        //Set default selected resource.
        selectedResource = resources[0];

        //Create variable to represent local time.
        now = DateTime.now();

        //Fetch available appointments.
        _availableAppointments = await locator<SuperSaaSAppointmentService>()
            .getAvailableAppointments(
                scheduleID: SAAS_BABY_SITTING_SCHEDULE_ID,
                resource: selectedResource.name,
                limit: 60,
                fromTime: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  now.hour,
                  now.minute,
                  now.second,
                ) //Get available appointments after today.
                );

        //Group slots by day for calendar presentation.
        _groupAppointmentsByDay();

        //todo: Delete when done testing.
        // locator<SuperSaaSAppointmentService>().create(
        //   scheduleID: 489593,
        //   userID: currentUser.id,
        //   email: currentUser.email,
        //   fullName: '${currentUser.name}',
        //   start: DateTime.now(),
        //   finish: DateTime.now().add(
        //     Duration(hours: 2),
        //   ),
        // );

        yield LoadedState(
          calendarController: _calendarController,
          events: _events,
          availableSlots: [],
          resources: resources,
          selectedResource: selectedResource,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is OnDaySelectedEvent) {
      _availableSlots = event.events;

      yield LoadedState(
        calendarController: _calendarController,
        events: _events,
        availableSlots: _availableSlots,
        resources: resources,
        selectedResource: selectedResource,
      );
    }

    if (event is OnSlotSelectedEvent) {
      //todo:
    }

    if (event is OnResourceSelectedEvent) {
      yield LoadingState();

      //Update selected resource.
      selectedResource = event.resource;

      //Fetch available appointments.
      _availableAppointments =
          await locator<SuperSaaSAppointmentService>().getAvailableAppointments(
        scheduleID: SAAS_BABY_SITTING_SCHEDULE_ID,
        resource: selectedResource.name,
        limit: 60,
        fromTime: DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        ), //Get available appointments after today.
      );

      _groupAppointmentsByDay();

      yield LoadedState(
        calendarController: _calendarController,
        events: _events,
        availableSlots: _availableSlots,
        resources: resources,
        selectedResource: selectedResource,
      );
    }
  }

  void _groupAppointmentsByDay() {
    _availableAppointments.forEach((aa) {
      DateTime dayKey = DateTime(aa.start.year, aa.start.month, aa.start.day);

      if (_events.containsKey(dayKey)) {
        if (!_events[dayKey].contains(aa)) {
          _events[dayKey].add(aa);
        }
      } else {
        _events[dayKey] = [aa];
      }
    });

    return;
  }
}
