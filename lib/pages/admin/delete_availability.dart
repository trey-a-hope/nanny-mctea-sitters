import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/calendar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/admin/delete_availability_time.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:table_calendar/table_calendar.dart';

class DeleteAvailabilityPage extends StatefulWidget {
  @override
  State createState() => DeleteAvailabilityPageState();
}

class DeleteAvailabilityPageState extends State<DeleteAvailabilityPage> {
  final String timeFormat = 'hh:mm a';
  final String dateFormat = 'MMM, dd yyyy';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Firestore _db = Firestore.instance;
  Map<User, List<Slot>> _sitterSlotMap = Map<User, List<Slot>>();
  List<dynamic> _avialableSlots;
  bool _isLoading = true;
  String _sitterOption;
  List<User> _sitters = List<User>();
  List<String> _sitterOptions;
  List<Slot> _slots = List<Slot>();
  Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();
  final CalendarController _calendarController = CalendarController();
  DateTime _selectedDay;
  CollectionReference _slotsColRef;

  @override
  void initState() {
    super.initState();

    _load();
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
        _selectedDay = day;
        _avialableSlots = events;
      },
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Future<List<User>> _getSitters() async {
    List<User> sitters = List<User>();

    //Get sitters.
    QuerySnapshot querySnapshot = await _db
        .collection('Users')
        .where('isSitter', isEqualTo: true)
        .getDocuments();
    querySnapshot.documents.forEach(
      (document) {
        User sitter = User.extractDocument(document);
        sitters.add(sitter);
      },
    );

    return sitters;
  }

  void _setOptions() {
    _sitterOptions = _sitters.map((sitter) => sitter.name).toList();
    _sitterOption = _sitterOptions[0];
  }

  _getAvailability() async {
    _sitterSlotMap.clear();

    //Find specific sitter and look for their availability, (slots).
    User filteredSitter =
        _sitters.where((sitter) => sitter.name == _sitterOption).first;

    _slotsColRef =
        _db.collection('Users').document(filteredSitter.id).collection('slots');

    QuerySnapshot slotQuerySnapshot =
        await _slotsColRef.where('taken', isEqualTo: false).getDocuments();

    List<DocumentSnapshot> slotDocumentSnapshots = slotQuerySnapshot.documents;
    List<Slot> slots = List<Slot>();

    for (var j = 0; j < slotDocumentSnapshots.length; j++) {
      Slot slot = Slot(
        id: slotDocumentSnapshots[j].data['id'],
        taken: slotDocumentSnapshots[j].data['taken'],
        time: slotDocumentSnapshots[j].data['time'].toDate(),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Spinner()
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      _buildSitterDropDown(),
                      Calendar(
                          calendarController: _calendarController,
                          events: _events,
                          onDaySelected: _onDaySelected,
                          onVisibleDaysChanged: _onVisibleDaysChanged)
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                      MdiIcons.clock,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'PICK A DATE WITH TAKEN SLOTS',
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
                    builder: (context) => DeleteAvailabilityTimePage(
                        takenSlots: _avialableSlots,
                        selectedDay: _selectedDay,
                        slotsColRef: _slotsColRef),
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
                      'VIEW TIMES',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> deleteAvailability() async {
    // bool confirm = await Modal.showConfirmation(
    //   context: context,
    //   title: 'Delete Availability',
    //   text: '',
    // );
    // if (confirm) {
    //   for (int i = 0; i < _selectedSlots.length; i++) {
    //     DocumentReference docRef = await _slotsColRef.add(
    //       {'taken': false, 'time': _selectedSlots[i].time},
    //     );
    //     _slotsColRef.document(docRef.documentID).updateData(
    //       {'id': docRef.documentID},
    //     );
    //   }
    //   Modal.showAlert(
    //       context: context, title: 'Success', message: 'Time submitted.');
    //   return;
    // }
  }

  _buildAppBar() {
    return AppBar(
      title: Text('DELETE IT'),
      centerTitle: true,
    );
  }

  Widget _buildSlot(Slot slot) {
    //   return InkWell(
    //     child: ListTile(
    //       title: Text(
    //         DateFormat(timeFormat).format(slot.time),
    //       ),
    //       leading: CircleAvatar(
    //         backgroundColor:
    //             _selectedSlots.contains(slot) ? Colors.green : Colors.red,
    //         child: _selectedSlots.contains(slot)
    //             ? Icon(
    //                 Icons.check,
    //                 color: Colors.white,
    //               )
    //             : Icon(Icons.close, color: Colors.white),
    //       ),
    //     ),
    //     onTap: () {
    //       setState(
    //         () {
    //           if (_selectedSlots.contains(slot)) {
    //             _selectedSlots.remove(slot);
    //           } else {
    //             _selectedSlots.add(slot);
    //           }
    //         },
    //       );
    //     },
    //   );
  }
}
