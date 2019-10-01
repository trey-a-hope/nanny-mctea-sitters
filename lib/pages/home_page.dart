import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/drawer_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/content_heading_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/photo_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_slant.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_wavy.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/professional_nannies.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sitter_details.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sitter_services.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/pages/event_services.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/services/notification.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';
import 'package:nanny_mctea_sitters_flutter/style/text.dart';

import 'contact.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = Firestore.instance;
  List<Sitter> _sitters = List<Sitter>();
  FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  void _setUpFirebaseMessaging({@required FirebaseUser firebaseUser}) async {
    //Fetch the ID of the user document.
    QuerySnapshot querySnapshot = await _db
        .collection('Users')
        .where('uid', isEqualTo: firebaseUser.uid)
        .getDocuments();
    DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
    String id = documentSnapshot.data['id'];

    if (Platform.isIOS) {
      //Request permission on iOS device.
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    //Update user's fcm token.
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      print(fcmToken);
      _db.collection('Users').document(id).updateData(
        {'fcmToken': fcmToken},
      );
    }

    //Configure notifications for several action types.
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Modal.showAlert(
            context: context,
            title: message['notification']['title'],
            message: message['notification']['body']);
        //  _showItemDialog(message);
      },
      //  onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
    );
  }

  void loadPage() async {
    //Get sitters.
    QuerySnapshot querySnapshot = await _db
        .collection('Users')
        .where('isSitter', isEqualTo: true)
        .getDocuments();
    querySnapshot.documents.forEach(
      (document) {
        Sitter sitter = Sitter.extractDocument(document);
        _sitters.add(sitter);
      },
    );

    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      _setUpFirebaseMessaging(firebaseUser: firebaseUser);
    }

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
      // appBar: _buildAppBar(),
      backgroundColor: Colors.yellow[50],
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 300),
          );
        },
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      ClipperWavy(
                        child: Container(
                          height: 400,
                          color: Colors.red,
                        ),
                      ),
                      SimpleNavbar(
                        leftWidget: Icon(MdiIcons.menu, color: Colors.white),
                        leftTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        rightWidget: Icon(MdiIcons.phone, color: Colors.white),
                        rightTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactPage()),
                          );
                        },
                      ),
                      Positioned(
                        top: 200,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.yellow[50],
                                  style: BorderStyle.solid,
                                  width: 5.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              image: DecorationImage(
                                image: asImgGroup_nannies,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 100,
                          left: 32,
                          right: 0,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Nanny McTea Sitters',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: 'Sitting made simple.',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          )

                          // Text(
                          //   'Nanny McTea Sitters',
                          //   style: TextStyle(
                          //     fontSize: 25,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold
                          //   ),
                          // ),
                          )
                    ],
                  ),

                  // Stack(
                  //   children: <Widget>[
                  //     // SlantHeaderImage(image: floor),
                  //     Positioned(
                  //       top: 80,
                  //       left: 0,
                  //       right: 0,
                  //       child: _buildHeaderImage(),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'About',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  _buildAboutWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  // Stack(
                  //   children: <Widget>[
                  //     // SlantHeaderImage(image: pike_street),
                  //     Positioned(
                  //       top: 220,
                  //       left: 0,
                  //       right: 0,
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 16),
                  //         child: Container(
                  //           width: double.infinity,
                  //           height: 300,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(
                  //                 color: Colors.yellow[50],
                  //                 style: BorderStyle.solid,
                  //                 width: 5.0),
                  //             borderRadius: BorderRadius.all(
                  //               Radius.circular(16),
                  //             ),
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/images/dispicable_me.jpg'),
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ClipperWavy(
                    child: imgPikeStreet,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Text('Services',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),

                  _buildEventServicesButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSitterServicesButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildProfessionalNanniesButton(),
                  SizedBox(height: 20),
                  ClipperWavy(child: imgGroup),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Text('Meet The Team',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  _buildTeamWidget(),
                  SizedBox(height: 40),

                  // ContentHeadingWidget(
                  //   heading: 'Photos',
                  // ),
                  // _buildPhotosWidget(),
                  ClipperWavy(child: imgDispicableMe),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Text('Reviews',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  //Review 1
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '\"I cannot say enough about Nanny McTea and the fantastic caregivers here! We have someone that we trust who loves our kiddo, takes care in planning fun activities, provides guidance for listening skills, and is available on date nights as well.\"',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          TextSpan(text: '\n\n'),
                          TextSpan(
                              text: '~Morales Family',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(),
                  SizedBox(height: 30),
                  //Review 2
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '\"We loved Nanny McTea! We had just moved to the area and were in a pinch. She came prepared! She had felt books for my 1 year old and made slime with my 3.5 year old! I love how she focuses on learning and activities rather than screen time! That was only my 2nd time my kids have had a sitter other than family and and they loved her even my emotional 1 year old! Would recommend to anyone!\"',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          TextSpan(text: '\n\n'),
                          TextSpan(
                              text: '~Cady  Family',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(),
                  SizedBox(height: 30),

                  //Review 3
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '\"Love how easy it is to book and set up a caregiver with set prices for a set time.  Very Easy to work with, great caregivers!\"',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          TextSpan(text: '\n\n'),
                          TextSpan(
                              text: '~Eavenson Family',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  ClipperWavy(child: imgQueenCity),

                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Text('Social Media',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  _buildSocialMedias()
                ],
              ),
            ),
    );
  }

  // _buildHeaderImage() {
  //   return Stack(
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: Container(
  //           width: double.infinity,
  //           height: 300,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //                 color: Colors.yellow[50],
  //                 style: BorderStyle.solid,
  //                 width: 5.0),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(16),
  //             ),
  //             image: DecorationImage(
  //               image: asImgGroup_nannies,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Positioned.fill(
  //         child: Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               borderRadius: BorderRadius.circular(3.0),
  //             ),
  //             padding: EdgeInsets.all(10),
  //             child: Text(
  //               'Nanny McTea Sitters',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 20.0,
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  _buildEventServicesButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Event Services',
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            color: Colors.red,
            child: Text(
              'Read More',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventServicesPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildSitterServicesButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Sitter Services',
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text(
              'Read More',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SitterServicesPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildProfessionalNanniesButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Professional Nannies',
            style: TextStyle(
                fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            color: Colors.amber,
            child: Text(
              'Read More',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfessionalNanniesPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildTeamWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < _sitters.length; i++)
            InkWell(
              child: SitterWidget(
                sitter: _sitters[i],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SitterDetailsPage(_sitters[i])),
                );
              },
            )
        ],
      ),
    );
  }

  _buildAboutWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        about,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }

  _buildSocialMedias() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(30),
          child: InkWell(
            child: Icon(MdiIcons.facebook, color: Colors.red, size: 30),
            onTap: () {
              URLLauncher.launchUrl('https://www.facebook.com/nannymctea');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30),
          child: InkWell(
            child: Icon(MdiIcons.instagram, color: Colors.red, size: 30),
            onTap: () {
              URLLauncher.launchUrl(
                  'https://www.instagram.com/nannymcteasitters');
            },
          ),
        )
      ],
    );
  }
}
