import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget_x.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/message.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/fcm_notification.dart';

import 'messages/message_page.dart';

class SitterDetailsPage extends StatefulWidget {
  final User _sitter;

  SitterDetailsPage(this._sitter);

  @override
  State createState() => SitterDetailsPageState(this._sitter);
}

class SitterDetailsPageState extends State<SitterDetailsPage> {
  SitterDetailsPageState(this._sitter);

  final User _sitter;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';
  final GetIt getIt = GetIt.I;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      key: _scaffoldKey,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        fadeInCurve: Curves.easeIn,
                        imageUrl: _sitter.imgUrl),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 320.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildInfoBox(),
                        SizedBox(height: 20.0),
                        _buildBio(),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _buildInfoBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_sitter.name,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        _sitter.details,
                        style: TextStyle(fontSize: 20),
                      ),
                      // subtitle: Text(_gem.subCategory),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: CachedNetworkImageProvider(_sitter.imgUrl),
                fit: BoxFit.cover),
          ),
          margin: EdgeInsets.only(left: 16.0),
        ),
      ],
    );
  }

  _buildBio() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Bio',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(_sitter.bio),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Sitter Details'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () async {
            User currentUser = await getIt<Auth>().getCurrentUser();
            if(currentUser == null){
              getIt<Modal>().showAlert(context: context, title: 'Sorry', message: 'You must be logged in to use this feature.');
            }else{
              getIt<Message>().openMessageThread(context: context, sendee: currentUser, sender: _sitter, title: _sitter.name);
            }

            // QuerySnapshot querySnapshot =
            //     await _usersDB.where('uid', isEqualTo: user.uid).getDocuments();
            // DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
            // User u = User.extractDocument(documentSnapshot);
            // getIt<Message>().openMessageThread(u.id, _sitter.id);
          },
        )
      ],
    );
  }

  // void _openMessageThread(String userAId, String userBId) async {
  //   try {
  //     final CollectionReference conversationRef =
  //         _db.collection('Conversations');
  //     Query query = conversationRef;
  //     query = query.where(userAId, isEqualTo: true);
  //     query = query.where(userBId, isEqualTo: true);
  //     QuerySnapshot result = await query.snapshots().first;
  //     String convoId = null;
  //     if (!result.documents.isEmpty) {
  //       DocumentSnapshot conversationDoc = result.documents.first;
  //       convoId = conversationDoc.documentID;
  //     }
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MessagePage(userAId, userBId, convoId),
  //       ),
  //     );
  //   } catch (e) {
  //     getIt<Modal>().showInSnackBar(
  //       scaffoldKey: _scaffoldKey,
  //       text: e.toString(),
  //     );
  //   }
  // }
}
