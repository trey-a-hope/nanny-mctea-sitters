import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';

import 'ValidatorService.dart';

abstract class IModalService {
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey, @required String text});
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<String> showPasswordResetEmail({@required BuildContext context});
  Future<String> showChangeEmail({@required BuildContext context});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String text});
}

class ModalService extends IModalService {
  @override
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey, @required String text}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<String> showPasswordResetEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Reset Password'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: locator<ValidatorService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (!form.validate()) {
                _autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<String> showChangeEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Email'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: locator<ValidatorService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (!form.validate()) {
                _autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String text}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: const Text('NO', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('YES', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
