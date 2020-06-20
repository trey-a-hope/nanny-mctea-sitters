import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserState extends SignUpState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  UserState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class SitterState extends SignUpState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  SitterState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

//State: View of the user when loogging in.
class LoadingState extends SignUpState {
  LoadingState();

  @override
  List<Object> get props => [];
}
