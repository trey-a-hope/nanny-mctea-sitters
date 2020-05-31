import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../ServiceLocator.dart';
import 'Bloc.dart';

class BookSitterCalendarBloc
    extends Bloc<BookSitterCalendarEvent, BookSitterCalendarState> {
  //todo: dispose this.
  final CalendarController _calendarController = CalendarController();
  List<AppointmentModel> _availableAppointments;
  Map<DateTime, List<AppointmentModel>> _events =
      Map<DateTime, List<AppointmentModel>>();

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
        );

        _groupAppointmentsByDay();

        yield LoadedState(
          calendarController: _calendarController,
          events: _events,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
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
