import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  User _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  FirebaseUser _firebaseUser;
  final GetIt getIt = GetIt.I;
  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    await _fetchUserProfile();
    await _setFields();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _fetchUserProfile() async {
    _firebaseUser = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Users')
        .where('uid', isEqualTo: _firebaseUser.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents[0];

    _user = User.extractDocument(ds);
  }

  Future<void> _setFields() async {
    _nameController.text = _user.name;
    _phoneController.text = _user.phone;
    _emailController.text = _user.email;
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Update Profile', text: 'Are you sure?');

      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          await _submitFormData();

          setState(
            () {
              _isLoading = false;
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, text: 'Profile updated.');
            },
          );
        } catch (e) {
          setState(
            () {
              _isLoading = false;
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

  Future<void> _submitFormData() async {
    await _firebaseUser.updateEmail(_emailController.text);

    var data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text
    };

    await _db.collection('Users').document(_user.id).updateData(data);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      _nameFormField(),
                      SizedBox(height: 30),
                      _emailFormField(),
                      SizedBox(height: 30),
                      _phoneFormField(),
                      SizedBox(height: 30),
                      MaterialButton(
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _submit();
                        },
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('EDIT PROFILE'),
      centerTitle: true,
    );
  }

  Widget _nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
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

  Widget _phoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone',
        icon: Icon(Icons.phone),
        fillColor: Colors.white,
      ),
    );
  }
}
