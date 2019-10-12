import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_payment.dart';
import 'package:nanny_mctea_sitters_flutter/pages/plans_pricing.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

class BookSitterInfoPage extends StatefulWidget {
  final Appointment appointment;
  BookSitterInfoPage({@required this.appointment});

  @override
  State createState() => BookSitterInfoPageState(appointment: appointment);
}

class BookSitterInfoPageState extends State<BookSitterInfoPage> {
  BookSitterInfoPageState({@required this.appointment});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Appointment appointment;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aptFloorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';
  bool _isLoading = true;
  bool _autoValidate = false;
  User _currentUser;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();
    _nameController.text = _currentUser.name;
    _emailController.text = _currentUser.email;
    _phoneController.text = _currentUser.phone;
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Add form data to appointment information.
      appointment.aptNo = _aptFloorController.text;
      appointment.city = _cityController.text;
      appointment.email = _emailController.text;
      appointment.message = _messageController.text;
      appointment.name = _nameController.text;
      appointment.phone = _phoneController.text;
      appointment.service = appointment.service;
      appointment.street = _streetController.text;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookSitterPaymentPage(appointment: appointment),
        ),
      );
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
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
              children: <Widget>[
                ScaffoldClipper(
                  simpleNavbar: SimpleNavbar(
                    leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
                    leftTap: () {
                      Navigator.of(context).pop();
                    },
                    // rightWidget: Icon(Icons.refresh, color: Colors.white),
                    // rightTap: () async {
                    //   await _getSlotsAndCaledar();
                    // },
                  ),
                  title: 'Book Sitter',
                  subtitle: 'Enter your information.',
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        // _buildReviewCard(screen_width * 0.9),
                        // SizedBox(height: 40),
                        _buildNameFormField(),
                        SizedBox(height: 40),
                        _buildEmailFormField(),
                        SizedBox(height: 40),
                        _buildPhoneFormField(),
                        SizedBox(height: 40),
                        _buildAptFloorFormField(),
                        SizedBox(height: 40),
                        _buildStreetFormField(),
                        SizedBox(height: 40),
                        _buildCityFormField(),
                        SizedBox(height: 40),
                        _buildMessageFormField()
                      ],
                    ),
                  ),
                ),
              ],
            )),
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
              appointment.service,
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
            ),
            Divider(),
            Text(
              DateFormat(timeFormat).format(appointment.slot.time),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            ),
            Text(
              appointment.sitter.name,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            ),
            Text(
              'Minimum Deposit: \$25',
              style: TextStyle(fontSize: 25),
            ),
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
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.face, color: Theme.of(context).primaryIconTheme.color),
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
      validator: getIt<Validator>().email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon:
            Icon(Icons.email, color: Theme.of(context).primaryIconTheme.color),
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
      validator: getIt<Validator>().mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone',
        icon:
            Icon(Icons.phone, color: Theme.of(context).primaryIconTheme.color),
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
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Street',
        icon: Icon(Icons.location_on,
            color: Theme.of(context).primaryIconTheme.color),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAptFloorFormField() {
    return TextFormField(
      controller: _aptFloorController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      // validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Apt. / Floor No.',
        icon: Icon(MdiIcons.locationEnter,
            color: Theme.of(context).primaryIconTheme.color),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildCityFormField() {
    return TextFormField(
      controller: _cityController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'City',
        icon: Icon(Icons.location_city,
            color: Theme.of(context).primaryIconTheme.color),
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
        icon: Icon(Icons.message,
            color: Theme.of(context).primaryIconTheme.color),
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
            // Icon(MdiIcons.cubeSend),
            Icon(MdiIcons.send, color: Colors.white),

            SizedBox(
              width: 8,
            ),
            Text(
              'REVIEW AND PAY',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        )),
      ),
    );
  }
}
