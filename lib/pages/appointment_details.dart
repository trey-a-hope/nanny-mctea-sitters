import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
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

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

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

  void _addEventToCalendar() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      Iterable<Calendar> calendar =
          calendarsResult.data.where((c) => c.isReadOnly == false);
      String calendarID = calendar.first.id;

      final Event eventToCreate = Event(calendarID);
      eventToCreate.title = 'Sitter - ' + _sitter.name;
      eventToCreate.start = _slot.time;
      eventToCreate.description = appointment.formData.service;
      eventToCreate.end = _slot.time.add(
        Duration(hours: 1),
      );
      final Result<String> createEventResult =
          await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
      print(createEventResult);

      Modal.showInSnackBar(_scaffoldKey, 'Event added to calendar.');
    } catch (e) {
      Modal.showInSnackBar(
        _scaffoldKey,
        e.toString(),
      );
    }
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
        height: 235,
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
              style: TextStyle(fontSize: 15),
            ),
            Text(
              appointment.formData.service,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Address',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '${appointment.formData.street}, ${appointment.formData.city}',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Message',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              appointment.formData.message,
              style: TextStyle(fontSize: 20, color: Colors.black),
              maxLines: 2,
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
      actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.trashCan),
          onPressed: () {
            _cancelAppoinment();
          },
        )
      ],
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          _addEventToCalendar();
        },
        color: Colors.red,
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
    );
  }
}
