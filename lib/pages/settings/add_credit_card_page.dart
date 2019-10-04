import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe_service.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';

class AddCreditCardPage extends StatefulWidget {
  AddCreditCardPage({@required this.customer});
  final Customer customer;
  @override
  State createState() => AddCreditCardPageState(this.customer);
}

class AddCreditCardPageState extends State<AddCreditCardPage> {
  AddCreditCardPageState(this._customer);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  bool _isLoading = false;
  bool _autoValidate = false;
  User _currentUser;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final Customer _customer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _addTestCardInfo() {
    _cardNumberController.text = '4242424242424242';
    _expirationController.text = '0621';
    _cvcController.text = '323';
    _autoValidate = true;
  }

  void _submitCard() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      bool confirm = await Modal.showConfirmation(
          context: context,
          title: 'Add Card',
          text: 'This will become your default card on file.');
      if (confirm) {
        setState(
          () {
            _isLoading = true;
          },
        );

        String number = _cardNumberController.text;
        String exp_month = _expirationController.text.substring(0, 2);
        String exp_year = _expirationController.text.substring(2, 4);
        String cvc = _cvcController.text;

        try {
          String token = await StripeService.createToken(
              number: number,
              exp_month: exp_month,
              exp_year: exp_year,
              cvc: cvc);

          await StripeService.createCard(
              customerId: _customer.id, token: token);

          print(token);

          setState(
            () {
              _isLoading = false;
            },
          );
          Modal.showInSnackBar(
              scaffoldKey: _scaffoldKey, text: 'Card added successfully.');
        } catch (e) {
          Modal.showAlert(
              context: context,
              title: 'Error',
              message: 'Could not save card at this time.');
        }
      }
    }
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Add Credit Card Page'),
          actions: <Widget>[],
        ),
        body: _isLoading
            ? Spinner(text: 'Loading...')
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: creditCard,
                        height: 250.0,
                      ),
                      //Card Number
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        onFieldSubmitted: (term) {},
                        validator: Validater.validateCardNumber,
                        onSaved: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                          icon: Icon(Icons.credit_card),
                          fillColor: Colors.white,
                        ),
                      ),
                      //Expiration
                      TextFormField(
                        controller: _expirationController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        onFieldSubmitted: (term) {},
                        validator: Validater.validateExpiration,
                        onSaved: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Expiration',
                          icon: Icon(Icons.date_range),
                          fillColor: Colors.white,
                        ),
                      ),
                      //CVC
                      TextFormField(
                        controller: _cvcController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        onFieldSubmitted: (term) {},
                        validator: Validater.validateCVC,
                        onSaved: (value) {},
                        decoration: InputDecoration(
                          hintText: 'CVC',
                          icon: Icon(Icons.security),
                          fillColor: Colors.white,
                        ),
                      ),
                      RaisedButton(
                        child: Text('Add Test Card Info'),
                        onPressed: () {
                          _addTestCardInfo();
                        },
                      ),
                      RaisedButton(
                        child: Text('Add Card'),
                        onPressed: () {
                          _submitCard();
                        },
                      )
                    ],
                  ),
                ),
              ));
  }
}
