import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/contact/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/contact/ContactBloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../constants_ui.dart';

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
  ContactBloc contactBloc;
  @override
  void initState() {
    super.initState();

    contactBloc = BlocProvider.of<ContactBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (BuildContext context, ContactState state) {
          if (state is SendEmailFailureState) {
            locator<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: state.error.toString(),
            );
          }
        },
        builder: (BuildContext context, ContactState state) {
          if (state is LoadingState) {
            return Spinner();
          } else if (state is InitialState) {
            return _buildView(autoValidate: false);
          } else if (state is SendEmailSuccessState) {
            return Center(
              child: Text('Email Sent!'),
            );
          } else if (state is SendEmailFailureState) {
            return _buildView(autoValidate: true);
          } else {
            return Center(
              child: Text('You should never see this.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildView({@required bool autoValidate}) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: Column(
          children: <Widget>[
            Text(
              'Email',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              COMPANY_EMAIL,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Phone',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              COMPANY_PHONE,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Text('OR SEND US AN EMAIL'),
            SizedBox(height: 40),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().isEmpty,
              onSaved: (value) {},
              decoration: InputDecoration(
                  hintText: 'Name',
                  icon: Icon(
                    Icons.face,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _subjectController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().isEmpty,
              onSaved: (value) {},
              decoration: InputDecoration(
                  hintText: 'Subject',
                  icon: Icon(Icons.subject, color: Colors.grey)),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLengthEnforced: true,
              maxLines: 5,
              onFieldSubmitted: (term) {},
              validator: locator<ValidatorService>().isEmpty,
              onSaved: (value) {},
              decoration: InputDecoration(
                hintText: 'Message',
                icon: Icon(Icons.message, color: Colors.grey),
              ),
            ),
            Spacer(),
            RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                contactBloc.add(
                  SendEmailEvent(
                      message: _messageController.text,
                      subject: _subjectController.text),
                );
              },
              color: Colors.red,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
