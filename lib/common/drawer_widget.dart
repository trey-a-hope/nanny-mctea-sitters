import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/blog.dart';
import 'package:nanny_mctea_sitters_flutter/pages/event_services.dart';
import 'package:nanny_mctea_sitters_flutter/pages/login.dart';
import 'package:nanny_mctea_sitters_flutter/pages/plans_pricing.dart';
import 'package:nanny_mctea_sitters_flutter/pages/professional_nannies.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sign_up.dart';
import 'package:nanny_mctea_sitters_flutter/pages/contact.dart';
import 'package:nanny_mctea_sitters_flutter/pages/join_team.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sitter_services.dart';
import 'package:nanny_mctea_sitters_flutter/services/pd_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

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
        'Nanny McTea Sitters',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('Sitting made simple.'),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                'https://scontent-ort2-2.xx.fbcdn.net/v/t1.0-9/66689284_475953953204392_7694893442219900928_n.jpg?_nc_cat=108&_nc_oc=AQk71V5zlZVYi2JyEL9EYYveAKqn8zr22jz3cNHtohzaXPj9NEPSc3u_Io7347klBqAXPy-kPganFCUv8qVAql4I&_nc_ht=scontent-ort2-2.xx&oh=5fe010348e079c12854d062af3d2a871&oe=5E1040B2'),
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
          _buildBlog(),
          _buildLogout(),
          _buildLogin(),
          _buildSignUp(),
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

  Widget _buildBookSitter() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.faceAgent, color: _drawerIconColor),
            title: Text(
              'Book A Sitter',
            ),
            subtitle: Text(
              'Order a sitter today.',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookSitterPage(),
                ),
              );
            },
          );
  }

  Widget _buildPlansPricing() {
    return ListTile(
      leading: Icon(Icons.attach_money, color: _drawerIconColor),
      title: Text(
        'Plans & Pricing',
      ),
      subtitle: Text(
        'Get an idea of costs.',
        style: TextStyle(color: Colors.black),
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
      leading: Icon(MdiIcons.group, color: _drawerIconColor),
      title: Text(
        'Join The Team',
      ),
      subtitle: Text(
        'Become a nanny today.',
        style: TextStyle(color: Colors.black),
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
            leading: Icon(MdiIcons.login, color: _drawerIconColor),
            title: Text(
              'Logout',
            ),
            subtitle: Text(
              'Leave the app.',
              style: TextStyle(color: Colors.black),
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
            leading: Icon(MdiIcons.login, color: _drawerIconColor),
            title: Text(
              'Login',
            ),
            subtitle: Text(
              'Order a sitter today.',
              style: TextStyle(color: Colors.black),
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
            leading: Icon(MdiIcons.signText, color: _drawerIconColor),
            title: Text(
              'Sign Up',
            ),
            subtitle: Text(
              'Become a member today.',
              style: TextStyle(color: Colors.black),
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

  Widget _buildBlog() {
    return ListTile(
      leading: Icon(MdiIcons.book, color: _drawerIconColor),
      title: Text(
        'Blog',
      ),
      subtitle: Text(
        'Read all about us.',
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogPage(),
          ),
        );
      },
    );
  }
}
