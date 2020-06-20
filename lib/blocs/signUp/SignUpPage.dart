// import 'package:flutter/material.dart';
// import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
// import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/DBService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nanny_mctea_sitters_flutter/constants.dart';
// import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSUserService.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   State createState() => SignUpPageState();
// }

// class SignUpPageState extends State<SignUpPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _autoValidate = false;
//   bool _isLoading = true;

//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   _load() async {
//     setState(
//       () {
//         _isLoading = false;
//       },
//     );
//   }

//   _signUp() async {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();

//       bool confirm = await locator<ModalService>().showConfirmation(
//           context: context, title: 'Submit', message: 'Are you ready?');
//       if (confirm) {
//         try {
//           setState(
//             () {
//               _isLoading = true;
//             },
//           );

//           //Create new user in auth.
//           AuthResult authResult =
//               await locator<AuthService>().createUserWithEmailAndPassword(
//             email: _emailController.text,
//             password: _passwordController.text,
//           );

//           final FirebaseUser user = authResult.user;

//           //Create new user in SaaS.
//           int saasID = await locator<SuperSaaSUserService>().create(
//             name: 'NAME',
//             fullName: 'FULLNAME',
//             userID: '${user.email}',
//           );

//           UserModel newUser = UserModel(
//             id: null,
//             bio: null,
//             details: null,
//             name: null,
//             phone: null,
//             fcmToken: null,
//             email: user.email,
//             imgUrl: DUMMY_PROFILE_PHOTO_URL,
//             time: DateTime.now(),
//             uid: user.uid,
//             isSitter: false,
//             customerID: null,
//             subscriptionID: null,
//             saasID: '$saasID',
//           );

//           locator<UserService>().createUser(user: newUser);

//           Navigator.of(context).pop();
//         } catch (e) {
//           setState(
//             () {
//               _isLoading = true;
//               locator<ModalService>().showInSnackBar(
//                   scaffoldKey: _scaffoldKey, message: e.message);
//             },
//           );
//         }
//       }
//     } else {
//       setState(
//         () {
//           _autoValidate = true;
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       key: _scaffoldKey,
//       body: _isLoading
//           ? Spinner()
//           : Stack(
//               alignment: Alignment.center,
//               children: <Widget>[
//                 Positioned(
//                   left: (screenWidth * 0.1) / 2,
//                   bottom: (screenWidth * 0.1) / 2,
//                   child: FloatingActionButton(
//                     mini: true,
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     backgroundColor: Colors.blue,
//                     child: Icon(Icons.arrow_back),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: asImgFloorCrayons,
//                           fit: BoxFit.cover,
//                           alignment: Alignment.center)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.yellow.withOpacity(0.3),
//                         Colors.red.withOpacity(0.9)
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       stops: [0, 1],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: (screenWidth * 0.1) / 2,
//                   top: 50,
//                   child: Text(
//                     'Sign Up',
//                     style: TextStyle(color: Colors.white, fontSize: 30),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: _autoValidate ? 290 : 260,
//                         width: screenWidth * 0.9,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black12,
//                                 offset: Offset(0, 6),
//                                 blurRadius: 6),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(20),
//                           child: Form(
//                             key: _formKey,
//                             autovalidate: _autoValidate,
//                             child: Column(
//                               children: <Widget>[
//                                 _emailFormField(),
//                                 SizedBox(height: 30),
//                                 _passwordFormField(),
//                                 SizedBox(height: 30),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     _cancelButton(),
//                                     _signUpButton()
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//     );
//   }

//   Widget _emailFormField() {
//     return TextFormField(
//       controller: _emailController,
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       maxLengthEnforced: true,
//       // maxLength: MyFormData.nameCharLimit,
//       onFieldSubmitted: (term) {},
//       validator: locator<ValidatorService>().email,
//       onSaved: (value) {},
//       decoration: InputDecoration(
//         hintText: 'Email',
//         icon: Icon(Icons.email),
//         fillColor: Colors.white,
//       ),
//     );
//   }

//   Widget _passwordFormField() {
//     return TextFormField(
//       controller: _passwordController,
//       keyboardType: TextInputType.text,
//       textInputAction: TextInputAction.next,
//       obscureText: true,
//       maxLengthEnforced: true,
//       maxLength: 25,
//       onFieldSubmitted: (term) {},
//       validator: locator<ValidatorService>().password,
//       onSaved: (value) {},
//       decoration: InputDecoration(
//         hintText: 'Password',
//         icon: Icon(Icons.lock),
//         fillColor: Colors.white,
//       ),
//     );
//   }

//   Widget _cancelButton() {
//     return OutlineButton.icon(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8.0,
//         horizontal: 15.0,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       highlightedBorderColor: Colors.red,
//       borderSide: BorderSide(color: Colors.red),
//       color: Colors.red,
//       textColor: Colors.red,
//       icon: Icon(
//         MdiIcons.arrowLeft,
//         size: 18.0,
//       ),
//       label: Text('Cancel'),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//   }

//   Widget _signUpButton() {
//     return OutlineButton.icon(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8.0,
//         horizontal: 15.0,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       highlightedBorderColor: Colors.blue,
//       borderSide: BorderSide(color: Colors.blue),
//       color: Colors.blue,
//       textColor: Colors.blue,
//       icon: Icon(
//         MdiIcons.send,
//         size: 18.0,
//       ),
//       label: Text('Sign Up'),
//       onPressed: () {
//         _signUp();
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../constants.dart';
import 'Bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> implements SignUpBlocDelegate {
  TextEditingController _nameController =
      TextEditingController(text: 'Trey Hope');
  TextEditingController _phoneController =
      TextEditingController(text: '9372705527');
  TextEditingController _emailController =
      TextEditingController(text: 'trey.a.hope@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: 'Peachy33');
        TextEditingController _sitterCodeController =
      TextEditingController(text: SITTER_SIGN_UP_CODE);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpBloc signUpBloc;

  @override
  void initState() {
    super.initState();

    //Create BLoC instance and set delegate.
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
    signUpBloc.setDelegate(delegate: this);
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
