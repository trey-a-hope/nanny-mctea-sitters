import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/appointment_details.dart';
import 'package:nanny_mctea_sitters_flutter/pages/edit_profile.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile_appointments.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile_info.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  ProfilePage(this.userID);

  @override
  State createState() => ProfilePageState(this.userID);
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final String id;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  final _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  List<Appointment> _appointments = List<Appointment>();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';

  ProfilePageState(this.id);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: _buildAppBar(),
              body: TabBarView(
                children: [
                  ProfileInfoPage(),
                  ProfileAppointmentPage(),
                ],
              ),
            ),
          );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('MY PROFILE'),
      centerTitle: true,
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text(
              'My Info',
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              'My Appointments',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

}
