import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class ContactPage extends StatefulWidget {
  @override
  State createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  // TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  bool _isLoading = true;
  bool _autoValidate = false;

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

  _sendEmail() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        String uri =
            'mailto:${COMPANY_EMAIL}?subject=${_subjectController.text}&body=${_messageController.text}';
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          throw 'Could not launch $uri';
        }
        //   final MailOptions mailOptions = MailOptions(
        //     // body: _messageController.text,
        //     // subject: _subjectController.text,
        //     // recipients: [COMPANY_EMAIL],

        //     body: 'a long body for the email <br> with a subset of HTML',
        // subject: 'the Email Subject',
        // recipients: ['example@example.com'],

        //     // isHTML: true,
        //     // bccRecipients: ['other@example.com'],
        //     // ccRecipients: ['third@example.com'],
        //     // attachments: [
        //     //   'path/to/image.png',
        //     // ],
        //   );

        //   await FlutterMailer.send(mailOptions);
      } catch (e) {
        Modal.showInSnackBar(
          _scaffoldKey,
          e.message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                Text(
                  'Email',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  COMPANY_EMAIL,
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  'Phone',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  COMPANY_PHONE,
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
                SizedBox(height: 40),
                Text('OR SEND US AN EMAIL'),
                SizedBox(height: 40),
                _buildNameFormField(),
                // SizedBox(height: 20),
                // _buildAddressFormField(),
                // SizedBox(height: 20),
                // _buildEmailFormField(),
                // SizedBox(height: 20),
                // _buildPhoneFormField(),
                SizedBox(height: 20),
                _buildSubjectFormField(),
                SizedBox(height: 20),
                _buildMessageFormField(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'CONTACT US',
        style: TextStyle(letterSpacing: 2.0),
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

  Widget _buildAddressFormField() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      // validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Address',
        icon: Icon(Icons.location_on),
        fillColor: Colors.white,
      ),
    );
  }

  // Widget _buildEmailFormField() {
  //   return TextFormField(
  //     controller: _emailController,
  //     keyboardType: TextInputType.emailAddress,
  //     textInputAction: TextInputAction.next,
  //     maxLengthEnforced: true,
  //     // maxLength: MyFormData.nameCharLimit,
  //     onFieldSubmitted: (term) {},
  //     validator: Validater.email,
  //     onSaved: (value) {},
  //     decoration: InputDecoration(
  //       hintText: 'Email',
  //       icon: Icon(Icons.email),
  //       fillColor: Colors.white,
  //     ),
  //   );
  // }

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

  Widget _buildSubjectFormField() {
    return TextFormField(
      controller: _subjectController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Subject',
        icon: Icon(Icons.subject),
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
      validator: Validater.isEmpty,
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
          _sendEmail();
        },
        color: Colors.redAccent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.faceAgent,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
