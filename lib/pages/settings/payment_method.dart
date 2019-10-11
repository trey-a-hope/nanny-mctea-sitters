import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_slant.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/add_credit_card_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/card.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';

import '../../asset_images.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  State createState() => PaymentMethodPageState();
}

class PaymentMethodPageState extends State<PaymentMethodPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GetIt getIt = GetIt.instance;
  bool _isLoading = true;
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

  _load() async {
    try {
      _currentUser = await getIt<Auth>().getCurrentUser();
      _customer = await getIt<StripeCustomer>()
          .retrieve(customerId: _currentUser.customerId);

      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      setState(
        () {
          _isLoading = false;
        },
      );
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  _deleteCard() async {
    bool confirm = await getIt<Modal>().showConfirmation(
        context: context,
        title: 'Delete Card',
        text:
            'This will delete the default card on file. You must add another one to continue using payment features in the app.');
    if (confirm) {
      try {
        setState(() {
          _isLoading = true;
        });

        await getIt<StripeCard>()
            .delete(customerId: _customer.id, cardId: _customer.card.id);
        setState(
          () {
            _isLoading = false;

            _customer.default_source = null;
          },
        );
        getIt<Modal>().showInSnackBar(
            scaffoldKey: _scaffoldKey, text: 'Card successfully removed.');
      } catch (e) {
        setState(
          () {
            _isLoading = false;
          },
        );
        getIt<Modal>().showAlert(
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: 'Payment Method',
                    subtitle: 'How do you want to pay?',
                  ),
                  Container(
                    child: creditCard,
                    height: 250.0,
                  ),
                  _customer.default_source != null
                      ? SizedBox(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 3,
                                  child: ListTile(
                                    leading: Icon(Icons.confirmation_number,
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color),
                                    title: Text(
                                        '${_customer.card.brand} / ****-****-****-${_customer.card.last4}'),
                                    subtitle: Text('Expires ' +
                                        _months[_customer.card.exp_month] +
                                        ' ' +
                                        '${_customer.card.exp_year}'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 150.0,
                          child: Center(
                            child: Text(
                              'Add a card to your account.',
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  _customer.default_source != null
                      ? RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text('Delete Card',
                              style: Theme.of(context).accentTextTheme.button),
                          onPressed: _deleteCard,
                        )
                      : RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text('Add Card',
                              style: Theme.of(context).accentTextTheme.button),
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
