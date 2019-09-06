import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';

class BookSitterInfoPage extends StatefulWidget {
  BookSitterInfoPage();

  @override
  State createState() => BookSitterInfoPageState();
}

class BookSitterInfoPageState extends State<BookSitterInfoPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aptFloorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

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

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Modal.showInSnackBar(_scaffoldKey, 'SUBMIT...');
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
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      _buildReviewCard(screen_width * 0.9),
                      SizedBox(height: 40),
                      _buildNameFormField(),
                      SizedBox(height: 40),
                      _buildEmailFormField(),
                      SizedBox(height: 40),
                      _buildPhoneFormField(),
                      SizedBox(height: 40),
                      _buildStreetFormField(),
                      SizedBox(height: 40),
                      _buildAptFloorFormField(),
                      SizedBox(height: 40),
                      _buildCityFormField(),
                      SizedBox(height: 40),
                      _buildMessageFormField()
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('ADD YOUR INFO'),
      centerTitle: true,
    );
  }

  Widget _buildReviewCard(double screenWidth) {
    return Container(
      width: screenWidth,
      height: 175,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              'Membership Booking',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              '3 hr Waived booking fee!',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
            ),
            Divider(),
            Text(
              'September 08, 2019 12:00 am',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            ),
            Text(
              'Talea Chenault',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.face),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildEmailFormField() {
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

  Widget _buildPhoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      // validator: Validater.email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone',
        icon: Icon(Icons.phone),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildStreetFormField() {
    return TextFormField(
      controller: _streetController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Street',
        icon: Icon(Icons.location_on),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAptFloorFormField() {
    return TextFormField(
      controller: _streetController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      // validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Apt. / Floor No.',
        icon: Icon(MdiIcons.locationEnter),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildCityFormField() {
    return TextFormField(
      controller: _streetController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'City',
        icon: Icon(Icons.location_city),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildMessageFormField() {
    return TextFormField(
      controller: _messageController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLines: 5,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      // validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Message',
        icon: Icon(Icons.message),
        fillColor: Colors.white,
      ),
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          _submit();
        },
        color: Colors.blue,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.book,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'BOOK IT',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
