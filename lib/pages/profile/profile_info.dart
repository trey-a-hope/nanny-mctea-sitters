import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/main.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/edit_profile.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';

class ProfileInfoPage extends StatefulWidget {
  @override
  State createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> {
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _currentUser;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ||
            _currentUser ==
                null //Added _user == null check because of latency issue with snapshots vs documents.
        ? Spinner()
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildName(),
                  _buildEmail(),
                  _buildPhone(),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: MaterialButton(
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
                    ),
                  )
                ],
              ),
            ),
          );
  }

  _buildName() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 95,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0)
          ],
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _currentUser.name,
              style: TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  _buildEmail() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 95,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0)
          ],
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Email',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _currentUser.email,
              style: TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  _buildPhone() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 95,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0)
          ],
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Phone',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _currentUser.phone,
              style: TextStyle(fontSize: 25, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
