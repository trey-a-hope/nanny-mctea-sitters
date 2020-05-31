import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../ServiceLocator.dart';
import 'Bloc.dart';

class BookSitterCalendarBloc
    extends Bloc<BookSitterCalendarEvent, BookSitterCalendarState> {
  //todo: dispose this.
  final CalendarController _calendarController = CalendarController();
  List<AppointmentModel> _availableAppointments;
  Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();
  List<dynamic> _availableSlots = List<dynamic>();
  UserModel currentUser;

  @override
  BookSitterCalendarState get initialState => BookSitterCalendarState();

  @override
  Stream<BookSitterCalendarState> mapEventToState(
      BookSitterCalendarEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //Fetch available appointments.
        _availableAppointments = await locator<SuperSaaSAppointmentService>()
            .getAvailableAppointments(
                scheduleID: 489593,
                resource: 'Trey Hope',
                limit: 60,
                fromTime:
                    DateTime.now() //Get available appointments after today.
                );

        //Fetch current user.
        currentUser = await locator<AuthService>().getCurrentUser();

        //Group slots by day for calendar presentation.
        _groupAppointmentsByDay();

        //todo: Delete when done testing.
        locator<SuperSaaSAppointmentService>().create(
          scheduleID: 489593,
          userID: currentUser.id,
          email: currentUser.email,
          fullName: '${currentUser.name}',
          start: DateTime.now(),
          finish: DateTime.now().add(
            Duration(hours: 2),
          ),
        );

        yield LoadedState(
            calendarController: _calendarController,
            events: _events,
            availableSlots: []);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is OnDaySelectedEvent) {
      _availableSlots = event.events;

      yield LoadedState(
          calendarController: _calendarController,
          events: _events,
          availableSlots: _availableSlots);
    }

    if (event is OnSlotSelectedEvent) {
      //todo:
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
