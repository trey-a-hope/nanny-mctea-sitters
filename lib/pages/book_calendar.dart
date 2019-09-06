import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_sitter.dart';
import 'package:table_calendar/table_calendar.dart';

class BookCalendarPage extends StatefulWidget {
  final String service_name;

  BookCalendarPage(this.service_name);

  @override
  State createState() => BookCalendarPageState(this.service_name);
}

class BookCalendarPageState extends State<BookCalendarPage>
    with SingleTickerProviderStateMixin {
  final String service_name;

  BookCalendarPageState(this.service_name);

  CalendarController _calendarController;
  List _selectedEvents;
  Map<DateTime, List> events = Map<DateTime, List>();
  String _sitter = _sitters[0];
  bool _isLoading = true;

  static List<String> _sitters = [
    'All Staff',
    'Deaira Mitchell',
    'Mariah Johnson',
    'Talea Chenault',
    'Tameara Samedy',
    'Tkeyah James'
  ];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _load();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  _load() async {
    final _selectedDay = DateTime.now();
    events = {
      _selectedDay.subtract(
        Duration(days: 3),
      ): ['12:00pm', '1:00pm', '2:00pm'],
      _selectedDay: ['1:00pm'],
    };

    _selectedEvents = events[_selectedDay] ?? [];

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PICK A DATE'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        service_name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      _buildSitterDropDown(),
                    ],
                  ),
                ),
                Divider(),
                _buildTableCalendar(),
                Divider(),
                Expanded(
                  child: _buildEventList(),
                ),
              ],
            ),
    );
  }

  TableCalendar _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: events,
      // holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(event.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSitterSitterPage(),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }

  DropdownButton _buildSitterDropDown() {
    return DropdownButton<String>(
      value: _sitter,
      onChanged: (String newValue) {
        setState(() {
          _sitter = newValue;
        });
      },
      items: _sitters.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
