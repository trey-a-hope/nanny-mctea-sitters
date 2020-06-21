import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends LoginState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoadedState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}
