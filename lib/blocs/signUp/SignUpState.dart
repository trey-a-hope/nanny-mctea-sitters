import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing ƒhas been changed.
class InitialState extends SignUpState {
  InitialState();

  @override
  List<Object> get props => [];
}

//State: View of the user when loogging in.
class LoadingState extends SignUpState {
  LoadingState();

  @override
  List<Object> get props => [];
}
