import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';

class BookSitterInfoPage extends StatefulWidget {
  final ServiceOrder serviceOrder;
  BookSitterInfoPage(this.serviceOrder);

  @override
  State createState() => BookSitterInfoPageState(this.serviceOrder);
}

class BookSitterInfoPageState extends State<BookSitterInfoPage> {
  BookSitterInfoPageState(this.serviceOrder);

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ServiceOrder serviceOrder;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aptFloorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _db = Firestore.instance;
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
    _setTextFields();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(
          () {
            _isLoading = true;
          },
        );

        //Make charge for booking fee.
        bool charged = await getIt<StripeCharge>().create(
            amount: 25.00,
            description:
                serviceOrder.sitter.name + ', ' + serviceOrder.serviceName,
            customerId: _currentUser.customerId);

        if (!charged) {
          throw Exception('Could not charge card at this time.');
        }

        //Create appointment.
        var appointmentData = {
          'formData': {
            'aptNo': _aptFloorController.text,
            'city': _cityController.text,
            'email': _emailController.text,
            'message': _messageController.text,
            'name': _nameController.text,
            'phone': _phoneController.text,
            'service': serviceOrder.serviceName,
            'street': _streetController.text,
          },
          'sitterID': serviceOrder.sitter.id,
          'slotID': serviceOrder.slot.id,
          'userID': _currentUser.id
        };

        CollectionReference aptColRef = _db.collection('Appointments');
        DocumentReference aptDocRef = await aptColRef.add(appointmentData);
        await aptColRef.document(aptDocRef.documentID).updateData(
          {'id': aptDocRef.documentID},
        );

        //Set sitters time slot to taken.
        _db
            .collection('Users')
            .document(serviceOrder.sitter.id)
            .collection('slots')
            .document(serviceOrder.slot.id)
            .updateData(
          {'taken': true},
        );

        setState(
          () {
            getIt<Modal>().showInSnackBar(
                scaffoldKey: _scaffoldKey, text: 'Appointment Created');
            _isLoading = false;
          },
        );
      } catch (e) {
        getIt<Modal>().showInSnackBar(
          scaffoldKey: _scaffoldKey,
          text: e.toString(),
        );
        setState(
          () {
            _autoValidate = true;
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

  void _setTextFields() {
    _emailController.text = _currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

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
              serviceOrder.serviceName,
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
            ),
            Divider(),
            Text(
              DateFormat(timeFormat).format(serviceOrder.slot.time),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            ),
            Text(
              serviceOrder.sitter.name,
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
        icon: Icon(MdiIcons.locationEnter),
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
                MdiIcons.paypal,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'PAY WITH PAYPAL',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
