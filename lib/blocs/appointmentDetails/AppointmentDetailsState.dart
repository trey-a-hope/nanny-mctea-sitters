import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';

class AppointmentDetailsState extends Equatable {
  AppointmentDetailsState();
  @override
  List<Object> get props => [];
}

class InitialState extends AppointmentDetailsState {
  final AgendaModel agenda;

  InitialState({
    @required this.agenda,
  });

  @override
  List<Object> get props => [agenda];
}

class ErrorState extends AppointmentDetailsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
