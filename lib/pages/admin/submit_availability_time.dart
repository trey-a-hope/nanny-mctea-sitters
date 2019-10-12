import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/services/db.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class SubmitAvailabilityTimePage extends StatefulWidget {
  final List<dynamic> takenSlots;
  final DateTime selectedDay;
  final String sitterId;

  SubmitAvailabilityTimePage(
      {@required this.takenSlots,
      @required this.selectedDay,
      @required this.sitterId});

  @override
  State createState() => SubmitAvailabilityTimePageState(
      this.takenSlots, this.selectedDay, this.sitterId);
}

class SubmitAvailabilityTimePageState
    extends State<SubmitAvailabilityTimePage> {
  SubmitAvailabilityTimePageState(
      this._takenSlots, this._selectedDay, this.sitterId);

  final String timeFormat = 'hh:mm a';
  final String dateFormat = 'MMM, dd yyyy';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateTime _selectedDay;
  final List<dynamic> _takenSlots;
  final String sitterId;
  List<dynamic> _availableSlots = List<dynamic>();
  List<Slot> _selectedSlots = List<Slot>();
  bool _isLoading = true;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _buildSlots();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _buildSlots() async {
    //Create 24 hours time slots for available slots.
    for (int i = 0; i < 24; i++) {
      bool hit = false; //Slot is already active.

      for (int j = 0; j < _takenSlots.length; j++) {
        int takenHour = _takenSlots[j].time.hour;
        if (takenHour == i) {
          hit = true;
          break;
        }
      }

      if (!hit) {
        Slot slot = Slot(
          id: '',
          taken: false,
          time: DateTime(
              _selectedDay.year, _selectedDay.month, _selectedDay.day, i),
        );

        _availableSlots.add(slot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
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
                    subtitle: 'Select time(s)',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _availableSlots.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _buildSlot(
                        _availableSlots[index],
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Future<void> saveAvailability() async {
    bool confirm = await getIt<Modal>().showConfirmation(
      context: context,
      title: 'Submit Availability',
      text: _slotsToString(),
    );
    if (confirm) {
      for (int i = 0; i < _selectedSlots.length; i++) {
        getIt<DB>().addSlot(sitterId: sitterId, time: _selectedSlots[i].time);
      }
      getIt<Modal>().showAlert(
          context: context, title: 'Success', message: 'Time submitted.');
      return;
    }
  }

  Container _buildBottomNavigationBar() {
    return _selectedSlots.isEmpty
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
                      'NO TIME SELECTED',
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
              onPressed: saveAvailability,
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.send,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'SUBMIT TIMES',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  String _slotsToString() {
    String s = '';
    _selectedSlots.sort(
      (a, b) => a.time.compareTo(
        b.time,
      ),
    );

    for (int i = 0; i < _selectedSlots.length; i++) {
      s += DateFormat(timeFormat).format(_selectedSlots[i].time);
      if (i < _selectedSlots.length - 1) {
        s += ', ';
      }
    }
    return s;
  }

  _buildAppBar() {
    return AppBar(
      title: Text(DateFormat(dateFormat).format(_selectedDay)),
      centerTitle: true,
    );
  }

  Widget _buildSlot(Slot slot) {
    return InkWell(
      child: ListTile(
        title: Text(
          DateFormat(timeFormat).format(slot.time),
        ),
        leading: CircleAvatar(
          backgroundColor:
              _selectedSlots.contains(slot) ? Colors.green : Colors.red,
          child: _selectedSlots.contains(slot)
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(Icons.close, color: Colors.white),
        ),
      ),
      onTap: () {
        setState(
          () {
            if (_selectedSlots.contains(slot)) {
              _selectedSlots.remove(slot);
            } else {
              _selectedSlots.add(slot);
            }
          },
        );
      },
    );
  }
}
