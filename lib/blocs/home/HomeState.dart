import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends HomeState {}

class LoadedState extends HomeState {
  final List<UserModel> sitters;

  LoadedState({@required this.sitters});

  @override
  List<Object> get props => [];
}

class ErrorState extends HomeState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
