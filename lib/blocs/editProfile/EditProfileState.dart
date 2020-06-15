import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';

class EditProfileState extends Equatable {
  EditProfileState();
  @override
  List<Object> get props => [];
}

class LoadingState extends EditProfileState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends EditProfileState {
  final UserModel currentUser;

  LoadedState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [currentUser];
}

class ErrorState extends EditProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
