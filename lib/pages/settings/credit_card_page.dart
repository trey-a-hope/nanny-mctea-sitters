import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/add_credit_card_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe_service.dart';

import '../../asset_images.dart';

class CreditCardPage extends StatefulWidget {
  @override
  State createState() => CreditCardPageState();
}

class CreditCardPageState extends State<CreditCardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  bool _isLoading = true;
  bool _autoValidate = false;
  User _currentUser;
  Customer _customer;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

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

      return await StripeService.retrieveCustomer(
          customerId: _currentUser.customerId);
    } catch (e) {
      throw Exception('Could not fetch credit card information at this time.');
    }
  }

  _load() async {
    try {
      _customer = await _getCustomer();
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

  _deleteCard() async {
    bool confirm = await Modal.showConfirmation(
        context: context,
        title: 'Delete Card',
        text:
            'This will delete the default card on file. You must add another one to continue using payment features in the app.');
    if (confirm) {
      try {
        bool deleted = await StripeService.deleteCard(
            customerId: _customer.id, cardId: _customer.card.id);
        if (deleted) {
          setState(
            () {
              _customer.default_source = null;
            },
          );
          Modal.showInSnackBar(
              scaffoldKey: _scaffoldKey, text: 'Card successfully removed.');
        }
      } catch (e) {
        Modal.showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Credit Card Page'),
      ),
      body: _isLoading
          ? Spinner(text: 'Fetching credit card info...')
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: creditCard,
                    height: 250.0,
                  ),
                  _customer.default_source != null
                      ? SizedBox(
                          child: Column(
                            children: [
                              ListTile(
                                  leading: Icon(Icons.confirmation_number),
                                  title: Text('Card Number'),
                                  subtitle: Text('****-****-****-' +
                                      _customer.card.last4)),
                              Divider(),
                              ListTile(
                                  leading: Icon(Icons.date_range),
                                  title: Text('Expiration'),
                                  subtitle: Text(
                                      _months[_customer.card.exp_month] +
                                          ' ' +
                                          '${_customer.card.exp_year}')),
                              Divider(),
                              ListTile(
                                  leading: Icon(Icons.credit_card),
                                  title: Text('Brand'),
                                  subtitle: Text(_customer.card.brand)),
                              Divider(),
                              ListTile(
                                  leading: Icon(Icons.location_city),
                                  title: Text('Country'),
                                  subtitle: Text(_customer.card.country)),
                              Divider(),
                            ],
                          ),
                        )
                      : Container(
                          height: 300.0,
                          child: Center(
                              child: Text(
                            'Add a card to your account.',
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.grey),
                            textAlign: TextAlign.center,
                          )),
                        ),
                  _customer.default_source != null
                      ? RaisedButton(
                          child: Text('Delete Card'),
                          onPressed: _deleteCard,
                        )
                      : RaisedButton(
                          child: Text('Add Card'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddCreditCardPage(customer: _customer),
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
    );
  }
}
