import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_time.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarController _calendarController;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> dateTimeMap = Map<DateTime, List<dynamic>>();
  Map<String, List<DateTime>> sitterSlotMap = Map<String, List<DateTime>>();

  String _sitter;
  bool _isLoading = true;
  final _db = Firestore.instance;
  List<Sitter> _sitters = List<Sitter>();

  List<String> _sitterOptions;

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

  Future<List<Sitter>> _getSitters() async {
    List<Sitter> sitters = List<Sitter>();

    //Get sitters.
    QuerySnapshot querySnapshot = await _db
        .collection('Users')
        .where('isSitter', isEqualTo: true)
        .getDocuments();
    querySnapshot.documents.forEach(
      (document) {
        Sitter sitter = Sitter();
        sitter.id = document['id'];
        sitter.imgUrl = document['imgUrl'];
        sitter.name = document['name'];
        sitter.details = document['details'];

        sitters.add(sitter);
      },
    );

    return sitters;
  }

  _getAvailability() async {
    //Iterate through each sitter and look for their availability, (slots).
    for (var i = 0; i < _sitters.length; i++) {
      QuerySnapshot slotQuerySnapshot = await _db
          .collection('Users')
          .document(_sitters[i].id)
          .collection('slots')
          .getDocuments();
      List<DocumentSnapshot> slotDocumentSnapshots =
          slotQuerySnapshot.documents;

      List<DateTime> slots = List<DateTime>();

      for (var j = 0; j < slotDocumentSnapshots.length; j++) {
        DateTime slot = slotDocumentSnapshots[j].data['time'].toDate();
        slots.add(slot);
      }

      sitterSlotMap[_sitters[i].name] = slots;
    }
  }

  void _setOptions() {
    //Create options for dropdown.
    _sitterOptions = _sitters.map((sitter) => sitter.name).toList();
    _sitterOptions.insert(0, 'All Staff');
    _sitter = _sitterOptions[0];
  }

  void _setCalendar() {
    print(sitterSlotMap);

    final _selectedDay = DateTime.now();

    //Iterate through all slots on each sitter.
    sitterSlotMap.forEach((sitter, slots) {
      //Iterate through each slot and add to 'events' map.
      slots.forEach((slot) {
        DateTime dayWithoutTime = DateTime(slot.year, slot.month, slot.day);

        if (dateTimeMap.containsKey(dayWithoutTime)) {
          dateTimeMap[dayWithoutTime].add(slot);
        } else {
          dateTimeMap[dayWithoutTime] = [slot];
        }
      });
    });

    _selectedEvents = dateTimeMap[_selectedDay] ?? [];
  }

  _load() async {
    _sitters = await _getSitters();
    await _getAvailability();
    _setOptions();
    _setCalendar();

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
      key: _scaffoldKey,
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
    return (_selectedEvents == null || _selectedEvents.isEmpty)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                Modal.showInSnackBar(
                    _scaffoldKey, 'Please select an available day.');
              },
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.close,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'NO AVAILABILITY',
                      style: TextStyle(color: Colors.red),
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
      events: dateTimeMap,
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
      items: _sitterOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
