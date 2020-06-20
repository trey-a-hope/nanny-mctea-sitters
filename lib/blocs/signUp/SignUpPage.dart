import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../constants.dart';
import 'Bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> implements SignUpBlocDelegate {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sitterCodeController =
      TextEditingController(text: SITTER_SIGN_UP_CODE);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpBloc signUpBloc;

  @override
  void initState() {
    super.initState();

    //Create BLoC instance and set delegate.
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
    signUpBloc.setDelegate(delegate: this);

    // _nameController.text = 'Trey Hope';
    // _phoneController.text = '9372705527';
    // _emailController.text = 'trey.a.hope@gmail.com';
    // _passwordController.text = 'Peachy33';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (BuildContext context, SignUpState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is UserState) {
            return _buildUserView(
              screenWidth: screenWidth,
              autoValidate: state.autoValidate,
              formKey: state.formKey,
            );
          }

          if (state is SitterState) {
            return _buildSitterView(
              screenWidth: screenWidth,
              autoValidate: state.autoValidate,
              formKey: state.formKey,
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildSitterView({
    @required double screenWidth,
    @required bool autoValidate,
    @required GlobalKey<FormState> formKey,
  }) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Column(
          children: <Widget>[
            SwitchListTile(
              activeColor: Colors.purple,
              value: true,
              title: Text("I am a sitter."),
              onChanged: (val) {
                signUpBloc.add(
                  ToggleSwitchEvent(sitterSignUp: false, formKey: formKey),
                );
              },
            ),
            //Name
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              // maxLength: MyFormData.nameCharLimit,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().isEmpty,
              onSaved: (value) {},
              decoration: InputDecoration(
                hintText: 'Name',
                icon: Icon(Icons.face, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            //Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              // maxLength: MyFormData.nameCharLimit,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().mobile,
              onSaved: (value) {},
              decoration: InputDecoration(
                hintText: 'Phone',
                icon: Icon(Icons.phone, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            //Email
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
            //Password
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
            SizedBox(height: 30),
            //Sitter code
            TextFormField(
              controller: _sitterCodeController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              obscureText: false,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().sitterCode,
              onSaved: (value) {},
              decoration: InputDecoration(
                  hintText: 'Sitter Code',
                  icon: Icon(Icons.lock_outline, color: Colors.grey)),
            ),
            Spacer(),
            RaisedButton(
              child: Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                signUpBloc.add(
                  SubmitEvent(
                    formKey: formKey,
                    name: _nameController.text,
                    password: _passwordController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserView({
    @required double screenWidth,
    @required bool autoValidate,
    @required GlobalKey<FormState> formKey,
  }) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Column(
          children: <Widget>[
            SwitchListTile(
              activeColor: Colors.purple,
              value: false,
              title: Text("I am a sitter."),
              onChanged: (val) {
                signUpBloc.add(
                  ToggleSwitchEvent(
                    sitterSignUp: true,
                    formKey: formKey,
                  ),
                );
              },
            ),
            //Name
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              // maxLength: MyFormData.nameCharLimit,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().isEmpty,
              onSaved: (value) {},
              decoration: InputDecoration(
                hintText: 'Name',
                icon: Icon(Icons.face, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            //Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              // maxLength: MyFormData.nameCharLimit,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().mobile,
              onSaved: (value) {},
              decoration: InputDecoration(
                hintText: 'Phone',
                icon: Icon(Icons.phone, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            //Email
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
            //Password
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
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                signUpBloc.add(
                  SubmitEvent(
                    formKey: formKey,
                    name: _nameController.text,
                    password: _passwordController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }

  @override
  void navigateHome() {
    Navigator.of(context).pop();
  }
}
