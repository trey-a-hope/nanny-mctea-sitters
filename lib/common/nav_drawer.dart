import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/login/LoginPage.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/main.dart';
import 'package:nanny_mctea_sitters_flutter/pages/admin/delete_availability.dart';
import 'package:nanny_mctea_sitters_flutter/pages/admin/submit_availability.dart';
import 'package:nanny_mctea_sitters_flutter/pages/authentication/login_page.dart';
import 'package:nanny_mctea_sitters_flutter/pages/authentication/sign_up_page.dart';
import 'package:nanny_mctea_sitters_flutter/pages/plans_pricing.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_service.dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/login/Bloc.dart' as loginBloc;

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  State createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
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
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildBookSitter(),
                _buildPlansPricing(),
                _buildJoinTeam(),
                _buildProfile(),
                _buildAddAvailability(),
                _buildDeleteAvailability(),
                _buildLogout(),
                _buildLogin(),
                _buildSignUp(),
                _buildSettings(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Version $version / Build $buildNumber.\n©2020 by Nanny McTea Sitters\n',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
            leading: Icon(MdiIcons.faceProfile, color: Colors.red),
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
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          );
  }

  Widget _buildAddAvailability() {
    return user != null && ADMIN_UIDS.contains(user.uid)
        ? ListTile(
            leading: Icon(MdiIcons.plus, color: Colors.red),
            title: Text(
              'Add Sitter Hours',
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

  Widget _buildDeleteAvailability() {
    return user != null && ADMIN_UIDS.contains(user.uid)
        ? ListTile(
            leading: Icon(MdiIcons.delete, color: Colors.red),
            title: Text(
              'Delete Sitter Hours',
            ),
            subtitle: Text(
              'Delete availability for sitters.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteAvailabilityPage(),
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
            leading: Icon(MdiIcons.faceAgent, color: Colors.red),
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
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(Icons.attach_money, color: Colors.red),
            title: Text(
              'Plans & Pricing',
            ),
            subtitle: Text(
              'Get an idea of costs.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PlansPricingPage(),
              //   ),
              // );
            },
          );
  }

  Widget _buildJoinTeam() {
    return ListTile(
      leading: Icon(MdiIcons.group, color: Colors.red),
      title: Text(
        'Join The Team',
      ),
      subtitle: Text(
        'Become a nanny today.',
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => JoinTeamPage(),
        //   ),
        // );
      },
    );
  }

  Widget _buildLogout() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.login, color: Colors.red),
            title: Text(
              'Logout',
            ),
            subtitle: Text(
              'Leave the app.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              bool confirm = await locator<ModalService>().showConfirmation(
                  context: context,
                  title: 'Sign Out',
                  message: 'Are you sure?');
              if (confirm) {
                await _auth.signOut();
              }
            },
          );
  }

  Widget _buildLogin() {
    return user == null
        ? ListTile(
            leading: Icon(MdiIcons.login, color: Colors.red),
            title: Text(
              'Login',
            ),
            subtitle: Text(
              'Order a sitter today.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider(
                  create: (BuildContext context) => loginBloc.LoginBloc(),
                  child: LoginPage(),
                ),
              );
              Navigator.push(context, route);
            },
          )
        : Container();
  }

  Widget _buildSignUp() {
    return user == null
        ? ListTile(
            leading: Icon(MdiIcons.signText, color: Colors.red),
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

  Widget _buildSettings() {
    return user == null
        ? Container()
        : ListTile(
            leading: Icon(MdiIcons.settings, color: Colors.red),
            title: Text(
              'Settings',
            ),
            subtitle: Text(
              'Manage your settings.',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          );
  }
}
