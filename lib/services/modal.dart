import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/services/validater.dart';

class Modal {
  static void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey, @required String text}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  static showAlert(
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

  static Future<String> showPasswordResetEmail(BuildContext context) {
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
          // child: InputField(
          //     controller: emailController,
          //     hintText: 'Email',
          //     obscureText: false,
          //     textInputType: TextInputType.emailAddress,
          //     icon: Icons.mail_outline,
          //     iconColor: Colors.black,
          //     bottomMargin: 20.0,
          //     validateFunction: Validater.email),
          child: TextFormField(
            controller: emailController,
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

  static Future<String> showChangeEmail(BuildContext context) {
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
            validator: Validater.email,
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

  static Future<String> showChangePassword(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Password'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLengthEnforced: true,

            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: Validater.password,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Password',
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
                Navigator.of(context).pop(passwordController.text);
              }
            },
          )
        ],
      ),
    );
  }

  static Future<bool> showConfirmation(
      BuildContext context, String title, String text) {
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
