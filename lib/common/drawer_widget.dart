import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/login.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/editProfile.dart';
import 'package:nanny_mctea_sitters_flutter/services/pdInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';

class DrawerWidget extends StatefulWidget {

  const DrawerWidget({Key key}):super(key:key);

  @override
  State createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  final PDInfo _pdInfo = PDInfo();
  final _drawerIconColor = Colors.blueGrey;
  String _projectVersion, _projectCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    load();

    _auth.onAuthStateChanged.listen(
      (firebaseUser) {
        setState(
          () {
            user = firebaseUser;
          },
        );
      },
    );
  }

  load() async {
    _projectCode = await _pdInfo.getAppBuildNumber();
    _projectVersion = await _pdInfo.getAppVersionNumber();

    setState(
      () => {},
    );
  }

  Widget _buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        'Hidden Gems',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('Dayton has more to offer...'),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(''),
            backgroundColor: Colors.transparent,
            radius: 10.0),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          // user == null
          //     ? Container()
          //     : ListTile(
          //         leading: Icon(MdiIcons.settings, color: _drawerIconColor),
          //         title: Text(
          //           'Settings',
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => SettingsPage(),
          //             ),
          //           );
          //         },
          //       ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Version $_projectVersion / Build $_projectCode.\nCreated by Tr3umphant.Designs, LLC.\nSearch powered by Algolia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
