import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_time.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSitterCalendarPage extends StatefulWidget {
  final ServiceOrder serviceOrder;

  BookSitterCalendarPage(this.serviceOrder);

  @override
  State createState() => BookSitterCalendarPageState(this.serviceOrder);
}

class BookSitterCalendarPageState extends State<BookSitterCalendarPage>
    with SingleTickerProviderStateMixin {
  final ServiceOrder serviceOrder;

  BookSitterCalendarPageState(this.serviceOrder);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarController _calendarController;
  List<dynamic> _avialableSlots;
  Map<DateTime, List<dynamic>> _dateTimeMap = Map<DateTime, List<dynamic>>();
  Map<Sitter, List<Slot>> _sitterSlotMap = Map<Sitter, List<Slot>>();
  final _db = Firestore.instance;
  bool _isLoading = true;
  String _sitterOption;
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
    QuerySnapshot querySnapshot =
        await _db.collection('Sitters').getDocuments();
    querySnapshot.documents.forEach(
      (document) {
        Sitter sitter = Sitter.extractDocument(document);
        sitters.add(sitter);
      },
    );

    return sitters;
  }

  _getAvailability({@required bool all}) async {
    _sitterSlotMap.clear();

    if (all) {
      //Iterate through each sitter and look for their availability, (slots).
      for (var i = 0; i < _sitters.length; i++) {
        QuerySnapshot slotQuerySnapshot = await _db
            .collection('Sitters')
            .document(_sitters[i].id)
            .collection('slots')
            .where('taken', isEqualTo: false)
            .getDocuments();
        List<DocumentSnapshot> slotDocumentSnapshots =
            slotQuerySnapshot.documents;

        List<Slot> slots = List<Slot>();

        for (var j = 0; j < slotDocumentSnapshots.length; j++) {
          Slot slot = Slot();

          slot.id = slotDocumentSnapshots[j].data['id'];
          slot.taken = slotDocumentSnapshots[j].data['taken'];
          slot.time = slotDocumentSnapshots[j].data['time'].toDate();

          slots.add(slot);
        }

        _sitterSlotMap[_sitters[i]] = slots;
      }
    } else {
      //Find specific sitter and look for their availability, (slots).
      Sitter filteredSitter =
          _sitters.where((sitter) => sitter.name == _sitterOption).first;

      // for (var i = 0; i < _sitters.length; i++) {
      QuerySnapshot slotQuerySnapshot = await _db
          .collection('Sitters')
          .document(filteredSitter.id)
          .collection('slots')
          .where('taken', isEqualTo: false)
          .getDocuments();
      List<DocumentSnapshot> slotDocumentSnapshots =
          slotQuerySnapshot.documents;

      List<Slot> slots = List<Slot>();

      for (var j = 0; j < slotDocumentSnapshots.length; j++) {
        Slot slot = Slot();

        slot.id = slotDocumentSnapshots[j].data['id'];
        slot.taken = slotDocumentSnapshots[j].data['taken'];
        slot.time = slotDocumentSnapshots[j].data['time'].toDate();

        slots.add(slot);
      }

      _sitterSlotMap[filteredSitter] = slots;
    }
  }

  void _setOptions() {
    //Create options for dropdown.
    _sitterOptions = _sitters.map((sitter) => sitter.name).toList();
    _sitterOptions.insert(0, 'All Staff');
    _sitterOption = _sitterOptions[0];
  }

  void _setCalendar() {
    final _selectedDay = DateTime.now();
    _dateTimeMap.clear();

    //Iterate through all slots on each sitter.
    _sitterSlotMap.forEach(
      (sitter, slots) {
        //Iterate through each slot and add to 'events' map.
        slots.forEach(
          (slot) {
            DateTime dayKey =
                DateTime(slot.time.year, slot.time.month, slot.time.day);

            if (_dateTimeMap.containsKey(dayKey)) {
              //Add time slot to day if it's hasn't been added already.
              if (!_dateTimeMap[dayKey].contains(slot)) {
                _dateTimeMap[dayKey].add(slot);
              }
            }
            //Set first time slot to day.
            else {
              _dateTimeMap[dayKey] = [slot];
            }
          },
        );
      },
    );

    _avialableSlots = _dateTimeMap[_selectedDay] ?? [];
  }

  _load() async {
    _sitters = await _getSitters();
    await _getAvailability(all: true);
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
        _avialableSlots = events;
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
      appBar: _buildAppBar(),
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
                        serviceOrder.serviceName,
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

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('PICK A DATE'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            await _getSlotsAndCaledar();
          },
        )
      ],
    );
  }

  Container _buildBottomNavigationBar() {
    return (_avialableSlots == null || _avialableSlots.isEmpty)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {},
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
                    builder: (context) => BookSitterTimePage(
                        _avialableSlots, _sitterSlotMap, serviceOrder),
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
      events: _dateTimeMap,
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

  DropdownButton _buildSitterDropDown() {
    return DropdownButton<String>(
      value: _sitterOption,
      onChanged: (String newValue) async {
        setState(
          () async {
            _sitterOption = newValue;
            await _getSlotsAndCaledar();
          },
        );
      },
      items: _sitterOptions.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  _getSlotsAndCaledar() async {
    if (_sitterOption == 'All Staff') {
      await _getAvailability(all: true);
      setState(
        () {
          _setCalendar();
        },
      );
    } else {
      await _getAvailability(all: false);
      setState(
        () {
          _setCalendar();
        },
      );
    }
  }
}
