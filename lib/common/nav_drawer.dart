import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/pages/contact.dart';
import 'package:nanny_mctea_sitters_flutter/pages/login.dart';
import 'package:nanny_mctea_sitters_flutter/pages/plans_pricing.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sign_up.dart';
import 'package:nanny_mctea_sitters_flutter/pages/join_team.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_service.dart';
import 'package:nanny_mctea_sitters_flutter/pages/submit_availability.dart';
import 'package:nanny_mctea_sitters_flutter/services/pd_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  State createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
    with SingleTickerProviderStateMixin {
  final PDInfo _pdInfo = PDInfo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _projectVersion;
  String _projectCode;
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
        'Nanny McTea Sitters',
        style: Theme.of(context).accentTextTheme.title,
      ),
      accountEmail: Text('Sitting made simple.',
          style: Theme.of(context).accentTextTheme.subtitle),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
            backgroundImage: asImgGroup_nannies,
            backgroundColor: Colors.transparent,
            radius: 10.0),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
          _buildBookSitter(),
          _buildPlansPricing(),
          _buildJoinTeam(),
          _buildProfile(),
          _buildAvailability(),
          _buildLogout(),
          _buildLogin(),
          _buildSignUp(),
          // _buildContact(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Version $_projectVersion / Build $_projectCode.\n©2019 by Nanny McTea Sitters\nCreated by Tr3umphant.Designs, LLC.',
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

  Widget _buildProfile() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.faceProfile,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'My Profile',
            ),
            subtitle: Text(
              'View your appointments.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user.uid),
                ),
              );
            },
          );
  }

  Widget _buildAvailability() {
    return user != null && ADMIN_UIDS.contains(user.uid)
        ? ListTile(
            leading: Icon(MdiIcons.timelapse,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'Sitter Hours',
            ),
            subtitle: Text(
              'Provide availability for sitters.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitAvailabilityPage(),
                ),
              );
            },
          )
        : Container();
  }

  Widget _buildBookSitter() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.faceAgent,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'Book A Sitter',
            ),
            subtitle: Text(
              'Order a sitter today.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookSitterServicePage(),
                ),
              );
            },
          );
  }

  Widget _buildPlansPricing() {
    return ListTile(
      leading: Icon(Icons.attach_money,
          color: Theme.of(context).primaryIconTheme.color),
      title: Text(
        'Plans & Pricing',
      ),
      subtitle: Text(
        'Get an idea of costs.',
              style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlansPricingPage(),
          ),
        );
      },
    );
  }

  Widget _buildJoinTeam() {
    return ListTile(
      leading:
          Icon(MdiIcons.group, color: Theme.of(context).primaryIconTheme.color),
      title: Text(
        'Join The Team',
      ),
      subtitle: Text(
        'Become a nanny today.',
              style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JoinTeamPage(),
          ),
        );
      },
    );
  }

  Widget _buildLogout() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.login,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'Logout',
            ),
            subtitle: Text(
              'Leave the app.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              bool confirm = await Modal.showConfirmation(
                  context, 'Sign Out', 'Are you sure?');
              if (confirm) {
                _auth.signOut().then(
                      (r) {},
                    );
              }
            },
          );
  }

  Widget _buildLogin() {
    return user == null
        ? ListTile(
            leading: Icon(MdiIcons.login,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'Login',
            ),
            subtitle: Text(
              'Order a sitter today.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          )
        : Container();
  }

  Widget _buildSignUp() {
    return user == null
        ? ListTile(
            leading: Icon(MdiIcons.signText,
                color: Theme.of(context).primaryIconTheme.color),
            title: Text(
              'Sign Up',
            ),
            subtitle: Text(
              'Become a member today.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpPage(),
                ),
              );
            },
          )
        : Container();
  }
}
