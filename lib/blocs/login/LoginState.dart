import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing ƒhas been changed.
class InitialState extends LoginState {
  InitialState();

  @override
  List<Object> get props => [];
}

//State: View of the user when loogging in.
class LoadingState extends LoginState {
  LoadingState();

  @override
  List<Object> get props => [];
}

//State: View of a successful login.
class LoginSuccessfulState extends LoginState {
  final AuthResult authResult;

  LoginSuccessfulState({
    @required this.authResult,
  });

  @override
  List<Object> get props => [authResult];
}

//State: View of an unsuccessful login.
class LoginFailedState extends LoginState {
  final dynamic error;

  LoginFailedState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
