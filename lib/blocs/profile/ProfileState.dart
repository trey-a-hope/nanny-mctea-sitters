import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';

class ProfileState extends Equatable {
  ProfileState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {
  LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedState extends ProfileState {
  final UserModel currentUser;
  final List<AppointmentModel> appointments;

  LoadedState({
    @required this.currentUser,
    @required this.appointments,
  });

  @override
  List<Object> get props => [
        currentUser,
        appointments,
      ];
}



class ErrorState extends ProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
