import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/calendar.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/pages/admin/submit_availability_time.dart';
import 'package:nanny_mctea_sitters_flutter/services/db.dart';
import 'package:table_calendar/table_calendar.dart';

class SubmitAvailabilityPage extends StatefulWidget {
  @override
  State createState() => SubmitAvailabilityPageState();
}

class SubmitAvailabilityPageState extends State<SubmitAvailabilityPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';
  final CalendarController _calendarController = CalendarController();
  final GetIt getIt = GetIt.I;
  List<dynamic> _avialableSlots;
  Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();
  Map<User, List<Slot>> _sitterSlotMap = Map<User, List<Slot>>();
  bool _isLoading = true;
  String _sitterOption;
  List<User> _sitters = List<User>();
  List<String> _sitterOptions;
  DateTime _selectedDay;
  User filteredSitter;

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

  _load() async {
    _sitters = await getIt<DB>().getSitters();
    //Create options for dropdown.
    _sitterOptions = _sitters.map((sitter) => sitter.name).toList();
    _sitterOption = _sitterOptions[0];
    await _getAvailability();
    _setCalendar();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _getAvailability() async {
    _sitterSlotMap.clear();
    filteredSitter =
        _sitters.where((sitter) => sitter.name == _sitterOption).first;
    List<Slot> slots =
        await getIt<DB>().getSlots(sitterID: filteredSitter.id, taken: false);
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

  void _onDaySelected(DateTime day, List events) {
    setState(
      () {
        _selectedDay = day;
        _avialableSlots = events;
      },
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: 'Add Sitter Hours',
                    subtitle: 'Select a sitter and date.',
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Pick a sitter from the drop down.'),
                        SizedBox(height: 20),
                        _buildSitterDropDown(),
                      ],
                    ),
                  ),
                  Calendar(
                      calendarController: _calendarController,
                      events: _events,
                      onDaySelected: _onDaySelected,
                      onVisibleDaysChanged: _onVisibleDaysChanged)
                ],
              ),
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
    return _selectedDay == null
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
                      MdiIcons.clock,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'PICK A DATE',
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
                    builder: (context) => SubmitAvailabilityTimePage(
                        takenSlots: _avialableSlots,
                        selectedDay: _selectedDay,
                        sitterID: filteredSitter.id),
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

  DropdownButton _buildSitterDropDown() {
    return DropdownButton<String>(
      value: _sitterOption,
      onChanged: (String newValue) async {
        setState(
          () async {
            _sitterOption = newValue;
            await _getAvailability();
            setState(
              () {
                _setCalendar();
              },
            );
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
}
