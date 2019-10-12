import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/messages_page.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile_appointments.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile_info.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage(this.uid);

  @override
  State createState() => ProfilePageState(this.uid);
}

class ProfilePageState extends State<ProfilePage> {
  ProfilePageState(this.uid);

  final String uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';

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
        ? Spinner()
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
      title: Text('Profile'),
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesPage(),
              ),
            );
          },
        )
      ],
    );
  }
}
