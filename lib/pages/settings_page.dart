import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/credit_card_page.dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/paymet_history_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  User _currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Payment Method'),
              subtitle: Text('Manage your payment method.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreditCardPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Payment History'),
              subtitle: Text('View your past transactions.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryPage(),
                  ),
                );
              },
            )
          ],
        ));
  }
}
