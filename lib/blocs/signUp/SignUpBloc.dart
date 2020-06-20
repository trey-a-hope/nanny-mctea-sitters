import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSUserService.dart';
import 'Bloc.dart';

abstract class SignUpBlocDelegate {
  void showMessage({@required String message});
  void navigateHome();
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBlocDelegate _delegate;

  @override
  SignUpState get initialState => UserState(
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );

  void setDelegate({@required SignUpBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  bool sitterSignUp = false;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is ToggleSwitchEvent) {
      sitterSignUp = event.sitterSignUp;

      if (sitterSignUp) {
        yield SitterState(
          autoValidate: true,
          formKey: event.formKey,
        );
      } else {
        yield UserState(
          autoValidate: true,
          formKey: event.formKey,
        );
      }
    }

    if (event is SubmitEvent) {
      if (event.formKey.currentState.validate()) {
        event.formKey.currentState.save();

        try {
          yield LoadingState();

          final String name = event.name;
          final String phone = event.phone;
          final String email = event.email;
          final String password = event.password;

          // Create new user in auth.
          AuthResult authResult =
              await locator<AuthService>().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          //Create new user in SaaS.
          int saasID = await locator<SuperSaaSUserService>().create(
            name: name,
            fullName: name,
            userID: ''
          );

          final FirebaseUser user = authResult.user;

          UserModel newUser;

          //If a sitter is signing up, save user as sitter.
          if (sitterSignUp) {
            newUser = UserModel(
              id: null,
              bio: 'This is a sitters bio.',
              details: 'This is a sitters details.',
              name: name,
              phone: phone,
              fcmToken: null,
              email: email,
              imgUrl: DUMMY_PROFILE_PHOTO_URL,
              time: DateTime.now(),
              uid: user.uid,
              isSitter: true,
              customerID: null,
              subscriptionID: null,
              saasID: '$saasID',
            );
          }
          //Otherwise, save user as basic user.
          else {
            newUser = UserModel(
              id: null,
              bio: null,
              details: null,
              name: name,
              phone: phone,
              fcmToken: null,
              email: email,
              imgUrl: DUMMY_PROFILE_PHOTO_URL,
              time: DateTime.now(),
              uid: user.uid,
              isSitter: false,
              customerID: null,
              subscriptionID: null,
              saasID: '$saasID',
            );
          }

          //Save user to database.
          locator<UserService>().createUser(user: newUser);

          //Call delegate method to navigate back to home page.
          _delegate.navigateHome();
        } catch (error) {
          //Show error message in snackbar.
          _delegate.showMessage(message: error.toString());

          //If sitter signing up, display sitter sign up view.
          if (sitterSignUp) {
            yield SitterState(
              autoValidate: true,
              formKey: event.formKey,
            );
          } 
          //Otherwise, display basic user form.
          else {
            yield UserState(
              autoValidate: true,
              formKey: event.formKey,
            );
          }
        }
      }
    }
  }
}
