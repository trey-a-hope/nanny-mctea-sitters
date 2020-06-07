import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'Bloc.dart';
//todo: Make this page similar to the Book Sitter Info page.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => InitialState();

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
        yield LoginSuccessfulState(authResult: authResult);
      } catch (error) {
        //Display the error that happened.
        yield LoginFailedState(error: error);
      }
    }
  }
}
