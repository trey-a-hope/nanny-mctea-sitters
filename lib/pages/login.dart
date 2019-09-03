import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sign_up.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(
          () {
            _isLoading = true;
          },
        );
        AuthResult authResult = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        Navigator.pop(context);
      } catch (e) {
        setState(
          () {
            _isLoading = false;
            Modal.showInSnackBar(
              _scaffoldKey,
              e.message,
            );
          },
        );
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  Widget emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.email),
        fillColor: Colors.white,
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: true,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }

  _sendForgotEmail() async {
    try {
      String email = await Modal.showPasswordResetEmail(context);
      if (email != null) {
        setState(
          () {
            _isLoading = true;
          },
        );

        await _auth.sendPasswordResetEmail(email: email);

        setState(
          () {
            _isLoading = false;
            Modal.showInSnackBar(_scaffoldKey,
                'Sent - A link to reset your password has been sent via the email provided.');
          },
        );
      }
    } catch (e) {
      setState(
        () {
          _isLoading = false;
          Modal.showInSnackBar(_scaffoldKey, e.message);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  void loadPage() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: background,
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
                          stops: [0, 1]),
                    ),
                  ),
                  Positioned(
                    left: (screenWidth * 0.1) / 2,
                    top: 50,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
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
                    height: 350,
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
                            emailFormField(),
                            SizedBox(height: 30),
                            passwordFormField(),
                            SizedBox(height: 30),
                            RaisedButton(
                              padding: EdgeInsets.all(10),
                              color: Colors.green,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))),
                              onPressed: () {
                                //_subm;
                                _login();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(width: 40.0),
                                  Icon(
                                    MdiIcons.send,
                                    size: 18.0,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
      ),
    );
  }
}
