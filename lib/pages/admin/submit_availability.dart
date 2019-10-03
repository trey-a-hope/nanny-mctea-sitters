import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/calendar.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget_x.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:table_calendar/table_calendar.dart';

class SubmitAvailabilityPage extends StatefulWidget {
  SubmitAvailabilityPage();

  @override
  State createState() => SubmitAvailabilityPageState();
}

class SubmitAvailabilityPageState extends State<SubmitAvailabilityPage>
    with SingleTickerProviderStateMixin {
  SubmitAvailabilityPageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';
  final CalendarController _calendarController = CalendarController();
  List<dynamic> _avialableSlots;
  Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();
  Map<User, List<Slot>> _sitterSlotMap = Map<User, List<Slot>>();
  final _db = Firestore.instance;
  bool _isLoading = true;
  String _sitterOption;
  List<User> _sitters = List<User>();
  List<String> _sitterOptions;

  @override
  void initState() {
    super.initState();

    _load();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<List<User>> _getSitters() async {
    List<User> sitters = List<User>();

    //Get sitters.
    QuerySnapshot querySnapshot = await _db.collection('Users').getDocuments();
    querySnapshot.documents.forEach(
      (document) {
        User sitter = User.extractDocument(document);
        sitters.add(sitter);
      },
    );

    return sitters;
  }

  void _setOptions() {
    //Create options for dropdown.
    _sitterOptions = _sitters.map((sitter) => sitter.name).toList();
    _sitterOption = _sitterOptions[0];
  }

  _getAvailability() async {
    _sitterSlotMap.clear();

    //Find specific sitter and look for their availability, (slots).
    User filteredSitter =
        _sitters.where((sitter) => sitter.name == _sitterOption).first;

    // for (var i = 0; i < _sitters.length; i++) {
    QuerySnapshot slotQuerySnapshot = await _db
        .collection('Users')
        .document(filteredSitter.id)
        .collection('slots')
        .where('taken', isEqualTo: false)
        .getDocuments();
    List<DocumentSnapshot> slotDocumentSnapshots = slotQuerySnapshot.documents;

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

  void _setCalendar() {
    final _selectedDay = DateTime.now();
    _events.clear();

    //Iterate through all slots on each sitter.
    _sitterSlotMap.forEach(
      (sitter, slots) {
        //Iterate through each slot and add to 'events' map.
        slots.forEach(
          (slot) {
            DateTime dayKey =
                DateTime(slot.time.year, slot.time.month, slot.time.day);

            if (_events.containsKey(dayKey)) {
              //Add time slot to day if it's hasn't been added already.
              if (!_events[dayKey].contains(slot)) {
                _events[dayKey].add(slot);
              }
            }
            //Set first time slot to day.
            else {
              _events[dayKey] = [slot];
            }
          },
        );
      },
    );

    _avialableSlots = _events[_selectedDay] ?? [];
  }

  _load() async {
    _sitters = await _getSitters();
    _setOptions();
    await _getAvailability();
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
      appBar: _buildAppBar(),
      key: _scaffoldKey,
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
                      // Text(
                      //   serviceOrder.serviceName,
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 20),
                      // ),
                      SizedBox(height: 20),
                      _buildSitterDropDown(),
                    ],
                  ),
                ),
                Divider(),
                Calendar(
                    calendarController: _calendarController,
                    events: _events,
                    onDaySelected: _onDaySelected,
                    onVisibleDaysChanged: _onVisibleDaysChanged)
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('SUBMIT AVAILABILITY'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            //await _getSlotsAndCaledar();
          },
        )
      ],
    );
  }

  Container _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          Modal.showInSnackBar(
              scaffoldKey: _scaffoldKey, text: 'Proceed to Times...');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BookSitterTimePage(
          //         _avialableSlots, _sitterSlotMap, serviceOrder),
          //   ),
          // );
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
    await _getAvailability();
    setState(
      () {
        _setCalendar();
      },
    );
  }
}
