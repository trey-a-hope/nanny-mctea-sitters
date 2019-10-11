import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';
import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final _db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GetIt getIt = GetIt.I;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Submit', text: 'Are you ready?');
      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Create new user in auth.
          AuthResult authResult = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          final FirebaseUser user = authResult.user;

          String customerId = await getIt<StripeCustomer>()
              .create(email: user.email, description: '');

          User newUser = User(
              id: '',
              bio: '',
              details: '',
              name: '',
              phone: '',
              fcmToken: '',
              email: user.email,
              imgUrl: DUMMY_PROFILE_PHOTO_URL,
              time: DateTime.now(),
              uid: user.uid,
              isSitter: false,
              customerId: customerId);

          DocumentReference docRef = await _usersDB.add(
            newUser.toMap(),
          );
          await _usersDB
              .document(docRef.documentID)
              .updateData({'id': docRef.documentID});

          Navigator.of(context).pop();
        } catch (e) {
          setState(
            () {
              _isLoading = true;
              getIt<Modal>()
                  .showInSnackBar(scaffoldKey: _scaffoldKey, text: e.message);
            },
          );
        }
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Spinner()
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: (screenWidth * 0.1) / 2,
                  bottom: (screenWidth * 0.1) / 2,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: asImgFloorCrayons,
                          fit: BoxFit.cover,
                          alignment: Alignment.center)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow.withOpacity(0.3),
                        Colors.red.withOpacity(0.9)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 6),
                                blurRadius: 6),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              children: <Widget>[
                                _emailFormField(),
                                SizedBox(height: 30),
                                _passwordFormField(),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _cancelButton(),
                                    _signUpButton()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.email),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: true,
      maxLengthEnforced: true,
      maxLength: 25,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().password,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _cancelButton() {
    return OutlineButton.icon(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      highlightedBorderColor: Colors.red,
      borderSide: BorderSide(color: Colors.red),
      color: Colors.red,
      textColor: Colors.red,
      icon: Icon(
        MdiIcons.arrowLeft,
        size: 18.0,
      ),
      label: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _signUpButton() {
    return OutlineButton.icon(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      highlightedBorderColor: Colors.blue,
      borderSide: BorderSide(color: Colors.blue),
      color: Colors.blue,
      textColor: Colors.blue,
      icon: Icon(
        MdiIcons.send,
        size: 18.0,
      ),
      label: Text('Submit'),
      onPressed: () {
        _signUp();
      },
    );
  }
}
