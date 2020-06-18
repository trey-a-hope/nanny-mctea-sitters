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

        loginBloc = BlocProvider.of<LoginBloc>(context);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state is LoginSuccessfulState) {
            Navigator.of(context).pop();
          }
        },
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
    return Padding(
      padding: EdgeInsets.all(30),
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
                icon: Icon(Icons.email, color: Colors.grey),
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
                  icon: Icon(Icons.lock, color: Colors.grey)),
            ),
            Spacer(),
            RaisedButton(
              child: Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                loginBloc.add(
                  Login(
                      email: _emailController.text,
                      password: _passwordController.text),
                );
              },
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[

            //     OutlineButton.icon(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: 8.0,
            //         horizontal: 15.0,
            //       ),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20.0)),
            //       highlightedBorderColor: Colors.blue,
            //       borderSide: BorderSide(color: Colors.blue),
            //       color: Colors.blue,
            //       textColor: Colors.blue,
            //       icon: Icon(
            //         MdiIcons.send,
            //         size: 18.0,
            //       ),
            //       label: Text('Login'),
            //       onPressed: () {
            //         loginBloc.add(
            //           Login(
            //               email: _emailController.text,
            //               password: _passwordController.text),
            //         );
            //         //_login();
            //       },
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
