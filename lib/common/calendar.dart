import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  final Function(DateTime, List<dynamic>) onDaySelected;
  final Function(DateTime, DateTime, CalendarFormat) onVisibleDaysChanged;
  const Calendar(
      {@required this.calendarController,
      @required this.events,
      @required this.onDaySelected,
      @required this.onVisibleDaysChanged});

  @override
  Widget build(BuildContext context) {
    HeaderStyle headerStyle = HeaderStyle(
      formatButtonTextStyle:
          TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
      formatButtonDecoration: BoxDecoration(
        color: Colors.deepOrange[400],
        borderRadius: BorderRadius.circular(16.0),
      ),
    );

    CalendarStyle calendarStyle = CalendarStyle(
      selectedColor: Colors.deepOrange[400],
      todayColor: Colors.deepOrange[200],
      markersColor: Colors.brown[700],
      outsideDaysVisible: false,
    );

    return TableCalendar(
      calendarController: calendarController,
      events: events,
      // holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: calendarStyle,
      headerStyle: headerStyle,
      onDaySelected: onDaySelected,
      onVisibleDaysChanged: onVisibleDaysChanged,
    );
  }
}