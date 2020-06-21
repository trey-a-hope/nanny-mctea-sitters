import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'Bloc.dart';

abstract class LoginBlocDelegate {
  void showMessage({@required String message});
  void navigate();
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBlocDelegate _delegate;

  @override
  LoginState get initialState => LoadedState(
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );

  void setDelegate({@required LoginBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //Event, user attempts login.
    if (event is Login) {
      //Display loading screen initially...
      yield LoadingState();
      try {
        //Proceed to login via service.
        AuthResult authResult = await locator<AuthService>()
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);

        //Continue to success screen.
        _delegate.navigate();
      } catch (error) {
        //Display the error that happened.
        _delegate.showMessage(message: error.toString());
      }

      yield LoadedState(
        autoValidate: true,
        formKey: event.formKey,
      );
    }
  }
}
