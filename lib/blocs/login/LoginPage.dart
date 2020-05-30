import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/login/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
  }

  // _sendForgotEmail() async {
  //   try {
  //     String email =
  //         await getIt<Modal>().showPasswordResetEmail(context: context);
  //     if (email != null) {
  //       setState(
  //         () {
  //           _isLoading = true;
  //         },
  //       );

  //       await _auth.sendPasswordResetEmail(email: email);

  //       setState(
  //         () {
  //           _isLoading = false;
  //           getIt<Modal>().showInSnackBar(
  //               scaffoldKey: _scaffoldKey,
  //               text:
  //                   'Sent - A link to reset your password has been sent via the email provided.');
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     setState(
  //       () {
  //         _isLoading = false;
  //         getIt<Modal>()
  //             .showInSnackBar(scaffoldKey: _scaffoldKey, text: e.message);
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {},
        builder: (BuildContext context, LoginState state) {
          if (state is InitialState) {
            return _buildView(screenWidth: screenWidth, autoValidate: false);
          } else if (state is LoadingState) {
            return Spinner();
          } else if (state is LoginSuccessfulState) {
            return Center(
              child: Text('Login Successful'),
            );
          } else if (state is LoginFailedState) {
            return _buildView(screenWidth: screenWidth, autoValidate: true);
          } else {
            return Center(
              child: Text('You should never see this.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildView({
    @required double screenWidth,
    @required bool autoValidate,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
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
        Container(
          height: autoValidate ? 290 : 240,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 6), blurRadius: 6),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidate: autoValidate,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforced: true,
                    // maxLength: MyFormData.nameCharLimit,
                    onFieldSubmitted: (term) {},
                    validator: locator<ValidatorService>().email,
                    onSaved: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email,
                          color: Theme.of(context).primaryIconTheme.color),
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    onFieldSubmitted: (term) {},
                    validator: locator<ValidatorService>().isEmpty,
                    onSaved: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.lock,
                          color: Theme.of(context).primaryIconTheme.color),
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlineButton.icon(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
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
                      ),
                      OutlineButton.icon(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        highlightedBorderColor: Colors.blue,
                        borderSide: BorderSide(color: Colors.blue),
                        color: Colors.blue,
                        textColor: Colors.blue,
                        icon: Icon(
                          MdiIcons.send,
                          size: 18.0,
                        ),
                        label: Text('Login'),
                        onPressed: () {
                          loginBloc.add(
                            Login(
                                email: _emailController.text,
                                password: _passwordController.text),
                          );
                          //_login();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
