import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:device_calendar/device_calendar.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget_x.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final Appointment appointment;

  AppointmentDetailsPage(this.appointment);

  @override
  State createState() => AppointmentDetailsPageState(this.appointment);
}

class AppointmentDetailsPageState extends State<AppointmentDetailsPage>
    with SingleTickerProviderStateMixin {
  AppointmentDetailsPageState(this.appointment);

  final Appointment appointment;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = Firestore.instance;
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';
  final double _fontSize = 20;

  // DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  bool _isLoading = true;
  Slot _slot;
  Sitter _sitter;
  User _user;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<Sitter> _fetchSitter() async {
    DocumentSnapshot documentSnapshot =
        await _db.collection('Sitters').document(appointment.sitterID).get();
    Sitter sitter = Sitter.extractDocument(documentSnapshot);
    return sitter;
  }

  Future<User> _fetchUser() async {
    DocumentSnapshot documentSnapshot =
        await _db.collection('Users').document(appointment.userID).get();
    User user = User.extractDocument(documentSnapshot);
    return user;
  }

  Future<Slot> _fetchSlot() async {
    DocumentSnapshot documentSnapshot = await _db
        .collection('Sitters')
        .document(appointment.sitterID)
        .collection('slots')
        .document(appointment.slotID)
        .get();
    Slot slot = Slot.extractDocument(documentSnapshot);
    return slot;
  }

  _load() async {
    _sitter = await _fetchSitter();
    _user = await _fetchUser();
    _slot = await _fetchSlot();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  // Future _addEventsToCalendar() async {
  //   final eventTime = DateTime.now();
  //   final eventToCreate = Event("SOME ID");
  //   eventToCreate.title = 'Event Name';
  //   eventToCreate.start = eventTime;
  //   eventToCreate.description = 'Description goes here.';
  //   // String mmaEventId = prefs.getString(mmaEvent.getPrefKey());
  //   // if (mmaEventId != null) {
  //   //   eventToCreate.eventId = mmaEventId;
  //   // }
  //   eventToCreate.end = eventTime.add(
  //     Duration(hours: 3),
  //   );
  //   final createEventResult =
  //       await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
  //   print(createEventResult);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTopCard(),
                  _buildSecondCard(),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildTopCard() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0)
          ],
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: <Widget>[
            SitterWidgetX(sitter: _sitter),
            _buildSitterLabel(),
            _buildSitterDate(),
            _buildSitterTime(),
          ],
        ),
      ),
    );
  }

  _buildSecondCard() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 245,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0)
          ],
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Service',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              appointment.formData.service,
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Address',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${appointment.formData.street}, ${appointment.formData.city}',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Message',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              appointment.formData.message,
              style: TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('APPOINTMENT DETAILS'),
      centerTitle: true,
    );
  }

  _buildSitterLabel() {
    return Positioned(
      left: 130,
      top: 25,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Sitter',
              style: TextStyle(fontSize: _fontSize, color: Colors.black),
            ),
            TextSpan(text: '\n'),
            TextSpan(
              text: _sitter.name,
              style: TextStyle(
                fontSize: _fontSize - 2,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildSitterDate() {
    return Positioned(
      left: 130,
      top: 85,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Date',
              style: TextStyle(fontSize: _fontSize, color: Colors.black),
            ),
            TextSpan(text: '\n'),
            TextSpan(
              text: DateFormat(dateFormat).format(_slot.time),
              style: TextStyle(
                fontSize: _fontSize - 2,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildSitterTime() {
    return Positioned(
      left: 130,
      top: 145,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Time',
              style: TextStyle(fontSize: _fontSize, color: Colors.black),
            ),
            TextSpan(text: '\n'),
            TextSpan(
              text: DateFormat(timeFormat).format(_slot.time),
              style: TextStyle(
                fontSize: _fontSize - 2,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  _cancelAppoinment() async {
    bool confirm = await Modal.showConfirmation(
        context, 'Cancel Appointment', 'Are you sure?');
    if (confirm) {
      setState(
        () {
          _isLoading = true;
        },
      );

      //Set sitter slot availability to free.
      await _db
          .collection('Sitters')
          .document(appointment.sitterID)
          .collection('slots')
          .document(appointment.slotID)
          .updateData(
        {'taken': false},
      );

      //Remove appointment.
      await _db.collection('Appointments').document(appointment.id).delete();

      setState(
        () {
          _isLoading = false;
          Navigator.of(context).pop();
        },
      );
    }
  }

  _buildBottomNavigationBar() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50.0,
          child: RaisedButton(
            onPressed: () {
              // _addEventsToCalendar();
            },
            color: Colors.blue,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MdiIcons.calendar,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    'ADD TO CALENDAR',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50.0,
          child: RaisedButton(
            onPressed: () {
              _cancelAppoinment();
            },
            color: Colors.red,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MdiIcons.close,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    'CANCEL APPOINTMENT',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
