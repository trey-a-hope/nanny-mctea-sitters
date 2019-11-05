import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/messages_page.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/appointment_details.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/edit_profile.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/db.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;
  List<Appointment> _appointments = List<Appointment>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();
    _appointments = await getIt<DB>().getAppointments(userID: _currentUser.id);
    setState(
      () {
        _isLoading = false;
      },
    );
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
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                      rightWidget: Icon(Icons.message, color: Colors.white),
                      rightTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesPage(),
                          ),
                        );
                      },
                    ),
                    title: 'Profile',
                    subtitle: 'View appointments and details.',
                  ),
                  SizedBox(height: 20),
                  Text('Info', style: Theme.of(context).primaryTextTheme.title),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.person,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(_currentUser.name),
                        subtitle: Text('Name'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.phone,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(_currentUser.phone),
                        subtitle: Text('Phone'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.email,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(_currentUser.email),
                        subtitle: Text('Email'),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('EDIT PROFILE'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Text('Appointments',
                      style: Theme.of(context).primaryTextTheme.title),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _appointments.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _appointments.isEmpty
                          ? Text('No Appoinents Right Now')
                          : _buildApointment(_appointments[index]);
                    },
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildApointment(Appointment appointment) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentDetailsPage(appointment: appointment),
          ),
        );
      },
      leading: CircleAvatar(
        child: Text(
          'A',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      title: Text(appointment.service),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
