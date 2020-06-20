import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleSwitchEvent extends SignUpEvent {
  final bool sitterSignUp;
  final GlobalKey<FormState> formKey;

  ToggleSwitchEvent({
    @required this.sitterSignUp,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        sitterSignUp,
        formKey,
      ];
}

class SubmitEvent extends SignUpEvent {
  final GlobalKey<FormState> formKey;
  final String name;
  final String phone;
  final String email;
  final String password;

  SubmitEvent({
    @required this.formKey,
    @required this.name,
    @required this.phone,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [
        formKey,
        name,
        phone,
        email,
        password,
      ];
}
