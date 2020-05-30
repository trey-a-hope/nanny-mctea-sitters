import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

class ContactState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends ContactState {
  InitialState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ContactState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class SendEmailSuccessState extends ContactState {
  SendEmailSuccessState();

  @override
  List<Object> get props => [];
}

class SendEmailFailureState extends ContactState {
  final dynamic error;

  SendEmailFailureState({
    @required this.error,
  });

  @override
  List<Object> get props => [];
}

