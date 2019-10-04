import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/payment_history_details_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';

import '../../asset_images.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  State createState() => PaymentHistoryPageState();
}

class PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  bool _isLoading = true;
  User _currentUser;
  Customer _customer;
  GetIt getIt = GetIt.instance;
  List<Charge> _charges = List<Charge>();
  final int detailsCharLimit = 60;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Customer> _getCustomer() async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();

      QuerySnapshot querySnapshot = await _db
          .collection('Users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
      _currentUser = User.extractDocument(documentSnapshot);

      return await getIt<StripeCustomer>()
          .retrieve(customerId: _currentUser.customerId);
    } catch (e) {
      throw Exception('Could not fetch credit card information at this time.');
    }
  }

  Future<List<Charge>> _getCharges() async {
    try {
      return await getIt<StripeCharge>()
          .listAll(customerId: _currentUser.customerId);
    } catch (e) {
      throw Exception('Could not fetch charges at this time.');
    }
  }

  _load() async {
    try {
      _customer = await _getCustomer();
      _charges = await _getCharges();
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      Modal.showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: _isLoading
          ? Spinner(text: 'Fetching payment history...')
          : _charges.isEmpty
              ? Center(
                  child: Text('No charges at the moment.'),
                )
              : ListView.builder(
                  itemCount: _charges.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return _buildCharge(_charges[index]);
                  },
                ),
    );
  }

  Widget _buildCharge(Charge charge) {
    return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PaymentHistoryDetailsPage(charge: charge)),
          );
        },
        leading: Icon(MdiIcons.cash),
        title: Text(
            FlutterMoneyFormatter(amount: charge.amount).output.symbolOnLeft),
        subtitle: Text(charge.description.length > detailsCharLimit
            ? charge.description.substring(0, detailsCharLimit) + '...'
            : charge.description),
        trailing: Icon(Icons.chevron_right));
  }
}
