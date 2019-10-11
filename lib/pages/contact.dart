import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_slant.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/slant_scaffold.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class ContactPage extends StatefulWidget {
  @override
  State createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GetIt getIt = GetIt.I;
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
      } catch (e) {
        getIt<Modal>().showInSnackBar(
          scaffoldKey: _scaffoldKey,
          text: e.message,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              SlantScaffold(
                simpleNavbar: SimpleNavbar(
                  leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
                  leftTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: 'Contact',
                subtitle: 'Get in touch with us.',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Email',
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  COMPANY_EMAIL,
                  style: Theme.of(context).primaryTextTheme.display1,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Phone',
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  COMPANY_PHONE,
                  style: Theme.of(context).primaryTextTheme.display1,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('OR SEND US AN EMAIL'),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buildNameFormField(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buildSubjectFormField(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buildMessageFormField(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
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

  Widget _buildSubjectFormField() {
    return TextFormField(
      controller: _subjectController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Subject',
        icon: Icon(Icons.subject,
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
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Message',
        icon: Icon(Icons.message,
            color: Theme.of(context).primaryIconTheme.color),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          _sendEmail();
        },
        color: Theme.of(context).buttonColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.send,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'SUBMIT',
                style: Theme.of(context).accentTextTheme.button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
