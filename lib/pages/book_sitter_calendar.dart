import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_time.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSitterCalendarPage extends StatefulWidget {
  final String service_name;

  BookSitterCalendarPage(this.service_name);

  @override
  State createState() => BookSitterCalendarPageState(this.service_name);
}

class BookSitterCalendarPageState extends State<BookSitterCalendarPage>
    with SingleTickerProviderStateMixin {
  final String service_name;

  BookSitterCalendarPageState(this.service_name);

  CalendarController _calendarController;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> events = Map<DateTime, List<dynamic>>();
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

    var onePM = DateTime(2019, _selectedDay.month, _selectedDay.day, 13, 0);
    var twoPM = DateTime(2019, _selectedDay.month, _selectedDay.day, 14, 0);

    events = {
      _selectedDay.subtract(
        Duration(days: 1),
      ): [onePM, twoPM],
      _selectedDay: [onePM],
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
    setState(
      () {
        _selectedEvents = events;
      },
    );
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
                // Divider(),
                // Expanded(
                //   child: _buildEventList(),
                // ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Container _buildBottomNavigationBar() {
    return _selectedEvents.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookSitterTimePage(this._selectedEvents),
                  ),
                );
              },
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.close,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'NO AVAILABILITY',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookSitterTimePage(this._selectedEvents),
                  ),
                );
              },
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.clock,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'PICK A TIME',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
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
                title: Text(
                  event.toString(),
                ),
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
        setState(
          () {
            _sitter = newValue;
          },
        );
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
