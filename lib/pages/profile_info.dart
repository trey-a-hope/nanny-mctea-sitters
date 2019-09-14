import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/edit_profile.dart';

class ProfileInfoPage extends StatefulWidget {
  @override
  State createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  final _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    await _fetchUserProfile();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _fetchUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    Stream<QuerySnapshot> stream = await _db
        .collection('Users')
        .where('uid', isEqualTo: user.uid)
        .snapshots();

    stream.listen(
      (data) {
        DocumentSnapshot ds = data.documents.first;
        setState(
          () {
            _user = User.extractDocument(ds);
            return;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading || _user == null //Added _user == null check because of latency issue with snapshots vs documents.
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                    _user.name,
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
                    _user.email,
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
                    _user.phone,
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
          );
  }
}
