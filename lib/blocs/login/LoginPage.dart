import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/login/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> implements LoginBlocDelegate {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginBloc _bloc;
  @override
  void initState() {
    super.initState();

    //Create instance of bloc and set delegate.
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.setDelegate(delegate: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is LoadedState) {
            return Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                key: state.formKey,
                autovalidate: state.autoValidate,
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
                        _bloc.add(
                          Login(
                              email: _emailController.text,
                              password: _passwordController.text,
                              formKey: state.formKey),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  void navigate() {
    Navigator.of(context).pop();
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(
      scaffoldKey: _scaffoldKey,
      message: message,
    );
  }
}
