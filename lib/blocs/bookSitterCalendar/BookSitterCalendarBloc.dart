import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSResourceService.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'Bloc.dart';

class BookSitterCalendarBloc
    extends Bloc<BookSitterCalendarEvent, BookSitterCalendarState> {
  BookSitterCalendarBloc({
    @required this.hours,
    @required this.cost,
  });

  final int hours; //Number of hours this appointment will last.
  final double cost; //Total cost of the appointment.

  final CalendarController _calendarController = CalendarController();
  List<AppointmentModel>
      _availableAppointments; //Available appointments for this resource.
  Map<DateTime, List<dynamic>> _events = Map<
      DateTime,
      List<
          dynamic>>(); //Available appointments that have been mapped to a date.
  UserModel currentUser; //Current user of the app.
  List<ResourceModel> resources; //Available baby sitters.
  ResourceModel
      selectedResource; //Selected baby sitter to filter appointments on.
  DateTime now = DateTime.now(); //Look for appiontments after this date.
  TimeOfDay selectedTime = TimeOfDay.now(); //Default time for picker.

  final int limit = 120; //Number of appointments to return on each call.

  DateTime start;
  DateTime finish;

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

        //Fetch available appointments.
        _availableAppointments = await locator<SuperSaaSAppointmentService>()
            .getAvailableAppointments(
                scheduleID: SAAS_BABY_SITTING_SCHEDULE_ID,
                resource: selectedResource.name,
                limit: limit,
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

        yield LoadedState(
          calendarController: _calendarController,
          events: _events,
          start: null,
          finish: null,
          resources: resources,
          selectedResource: selectedResource,
          selectTime: selectedTime,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is OnDaySelectedEvent) {
      start = null;
      finish = null;

      if (event.events.isNotEmpty) {
        start = event.events[0].start;
        finish = event.events[event.events.length - 1].finish;

        //Default the select time to the first available time.
        selectedTime = TimeOfDay.fromDateTime(
          start,
        );
      }

      yield LoadedState(
        calendarController: _calendarController,
        events: _events,
        start: start,
        finish: finish,
        resources: resources,
        selectedResource: selectedResource,
        selectTime: selectedTime,
      );
    }

    if (event is OnVisibleDaysChangedEvent) {
      //todo:
    }

    if (event is OnSlotSelectedEvent) {
      //todo:
    }

    if (event is NavigateToBookSitterTimePageEvent) {
      yield NavigateToBookSitterTimePageState();
    }

    if (event is OnTimeSelectEvent) {
      await _selectTime(event.context);

      yield LoadedState(
        calendarController: _calendarController,
        events: _events,
        start: start,
        finish: finish,
        resources: resources,
        selectedResource: selectedResource,
        selectTime: selectedTime,
      );
    }

    if (event is OnResourceSelectedEvent) {
      yield LoadingState();

      //Clear events list.
      _events.clear();

      //Update selected resource.
      selectedResource = event.resource;

      //Fetch available appointments.
      _availableAppointments =
          await locator<SuperSaaSAppointmentService>().getAvailableAppointments(
        scheduleID: SAAS_BABY_SITTING_SCHEDULE_ID,
        resource: selectedResource.name,
        limit: limit,
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
          start: DateTime.now(),
          finish: DateTime.now(),
          // availableSlots: _availableSlots,
          resources: resources,
          selectedResource: selectedResource,
          selectTime: TimeOfDay.now());
    }
  }

//Map the available appointments to a day.
  void _groupAppointmentsByDay() {
    _availableAppointments.forEach(
      (aa) {
        DateTime dayKey = DateTime(aa.start.year, aa.start.month, aa.start.day);

        if (_events.containsKey(dayKey)) {
          if (!_events[dayKey].contains(aa)) {
            _events[dayKey].add(aa);
          }
        } else {
          _events[dayKey] = [aa];
        }
      },
    );

    return;
  }

  //Set selectedTime variable from modal.
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
    }
  }
}
