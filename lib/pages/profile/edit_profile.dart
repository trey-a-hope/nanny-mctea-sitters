// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
// import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
// import 'package:nanny_mctea_sitters_flutter/services/db.dart';
// import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
// import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

// class EditProfilePage extends StatefulWidget {
//   @override
//   State createState() => EditProfilePageState();
// }

// class EditProfilePageState extends State<EditProfilePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _autoValidate = false;
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//   User _currentUser;
//   FirebaseUser _firebaseUser;
//   final GetIt getIt = GetIt.I;
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   _load() async {
//     _currentUser = await getIt<Auth>().getCurrentUser();
//     _nameController.text = _currentUser.name;
//     _phoneController.text = _currentUser.phone;
//     _emailController.text = _currentUser.email;

//     setState(
//       () {
//         _isLoading = false;
//       },
//     );
//   }

//   void _submit() async {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();

//       bool confirm = await getIt<Modal>().showConfirmation(
//           context: context, title: 'Update Profile', text: 'Are you sure?');

//       if (confirm) {
//         try {
//           setState(
//             () {
//               _isLoading = true;
//             },
//           );

//           await _submitFormData();

//           setState(
//             () {
//               _isLoading = false;
//               getIt<Modal>().showInSnackBar(
//                   scaffoldKey: _scaffoldKey, text: 'Profile updated.');
//             },
//           );
//         } catch (e) {
//           setState(
//             () {
//               _isLoading = false;
//               getIt<Modal>()
//                   .showInSnackBar(scaffoldKey: _scaffoldKey, text: e.message);
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

//   Future<void> _submitFormData() async {
//     await _firebaseUser.updateEmail(_emailController.text);

//     var data = {
//       'name': _nameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.text
//     };

//     getIt<DB>().updateUser(userID: _currentUser.id, data: data);

//     return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: _isLoading
//           ? Spinner()
//           : SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   ScaffoldClipper(
//                     simpleNavbar: SimpleNavbar(
//                       leftWidget:
//                           Icon(MdiIcons.chevronLeft, color: Colors.white),
//                       leftTap: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     title: 'Edit Profile',
//                     subtitle: 'Update yourself.',
//                   ),
//                   Form(
//                     key: _formKey,
//                     autovalidate: _autoValidate,
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 20),
//                           _nameFormField(),
//                           SizedBox(height: 30),
//                           _emailFormField(),
//                           SizedBox(height: 30),
//                           _phoneFormField(),
//                           SizedBox(height: 30),
//                           RaisedButton(
//                             child: Text('SUBMIT'),
//                             onPressed: () async {
//                               _submit();
//                             },
//                             color: Theme.of(context).buttonColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               // child: Padding(
//               //   padding: EdgeInsets.all(20),
//               //   child: Form(
//               //     key: _formKey,
//               //     autovalidate: _autoValidate,
//               //     child:
//               //   ),
//               // ),
//             ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text('EDIT PROFILE'),
//       centerTitle: true,
//     );
//   }

//   Widget _nameFormField() {
//     return TextFormField(
//       controller: _nameController,
//       keyboardType: TextInputType.text,
//       textInputAction: TextInputAction.next,
//       maxLengthEnforced: true,
//       // maxLength: MyFormData.nameCharLimit,
//       onFieldSubmitted: (term) {},
//       validator: getIt<Validator>().isEmpty,
//       onSaved: (value) {},
//       decoration: InputDecoration(
//         hintText: 'Name',
//         icon:
//             Icon(Icons.person, color: Theme.of(context).primaryIconTheme.color),
//         fillColor: Colors.white,
//       ),
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
//       validator: getIt<Validator>().email,
//       onSaved: (value) {},
//       decoration: InputDecoration(
//         hintText: 'Email',
//         icon:
//             Icon(Icons.email, color: Theme.of(context).primaryIconTheme.color),
//         fillColor: Colors.white,
//       ),
//     );
//   }

//   Widget _phoneFormField() {
//     return TextFormField(
//       controller: _phoneController,
//       keyboardType: TextInputType.phone,
//       textInputAction: TextInputAction.next,
//       maxLengthEnforced: true,
//       // maxLength: MyFormData.nameCharLimit,
//       onFieldSubmitted: (term) {},
//       validator: getIt<Validator>().mobile,
//       onSaved: (value) {},
//       decoration: InputDecoration(
//         hintText: 'Phone',
//         icon:
//             Icon(Icons.phone, color: Theme.of(context).primaryIconTheme.color),
//         fillColor: Colors.white,
//       ),
//     );
//   }
// }
