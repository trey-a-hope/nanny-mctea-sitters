import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/appointment_details.dart';
import 'package:nanny_mctea_sitters_flutter/pages/edit_profile.dart';
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
  User _currentUser;
  List<Appointment> _appointments = List<Appointment>();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';

  ProfilePageState(this.id);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<User> _fetchUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents.first;

    return User.extractDocument(ds);
  }

  Future<void> _getAppointments() async {
    Stream<QuerySnapshot> stream = _db
        .collection('Appointments')
        .where('userID', isEqualTo: _currentUser.id)
        .snapshots();

    stream.listen(
      (data) {
        List<DocumentSnapshot> documentSnapshots = data.documents;
        List<Appointment> appointments = List<Appointment>();
        for (var i = 0; i < documentSnapshots.length; i++) {
          Appointment appointment =
              Appointment.extractDocument(documentSnapshots[i]);
          appointments.add(appointment);
        }
        setState(
          () {
            _appointments = appointments;
            return;
          },
        );
      },
    );
  }

  void _load() async {
    _currentUser = await _fetchUserProfile();
    await _getAppointments();
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Trey Hope',
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            _currentUser.email,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Phone',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '(937)270-5527',
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          MaterialButton(
                            child: Text(
                              'EDIT',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                  _appointments.isEmpty
                      ? Center(
                          child: Text('You have nothing booked at the moment.'),
                        )
                      : ListView.builder(
                          itemCount: _appointments.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _buildApointmentCard(_appointments[index]);
                          },
                        ),
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

  Widget _buildApointmentCard(Appointment appointment) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailsPage(appointment),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            'A',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        title: Text(appointment.formData.service),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
