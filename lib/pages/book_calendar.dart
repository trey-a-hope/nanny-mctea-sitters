import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static List<String> _sitters = [
    'All Staff',
    'Deaira Mitchell',
    'Mariah Johnson',
    'Talea Chenault',
    'Tameara Samedy',
    'Tkeyah James'
  ];

  String _sitter = _sitters[0];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PICK A DATE'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text(service_name,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    height: 30,
                  ),
                  DropdownButton<String>(
                    value: _sitter,
                    onChanged: (String newValue) {
                      setState(() {
                        _sitter = newValue;
                      });
                    },
                    items:
                        _sitters.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                          text: 'Cancellation Policy:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: '\n\n'),
                      TextSpan(
                          text:
                              'Please cancel at least 48 hours in advance if you wish to cancel your sitter service. If you cancel with less than 24 hours before service no refund will be given.',
                          style: TextStyle(color: Colors.grey))
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
