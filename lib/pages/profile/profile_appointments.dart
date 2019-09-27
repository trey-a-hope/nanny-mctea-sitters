import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import '../appointment_details.dart';

class ProfileAppointmentPage extends StatefulWidget {
  @override
  State createState() => ProfileAppointmentPageState();
}

class ProfileAppointmentPageState extends State<ProfileAppointmentPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  final _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  List<Appointment> _appointments = List<Appointment>();
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    await _getAppointments();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _getAppointments() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot querySnapshot = await _db
        .collection('Users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

    DocumentSnapshot ds = querySnapshot.documents.first;

    String userID = ds.data['id'];

    Stream<QuerySnapshot> stream = _db
        .collection('Appointments')
        .where('userID', isEqualTo: userID)
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _appointments.isEmpty
            ? Center(
                child: Text('You have nothing booked at the moment.'),
              )
            : ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return _buildApointmentCard(_appointments[index]);
                },
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
