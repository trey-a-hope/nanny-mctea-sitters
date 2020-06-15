import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';

class AppointmentsState extends Equatable {
  AppointmentsState();
  @override
  List<Object> get props => [];
}

class InitialState extends AppointmentsState {
  final List<AgendaModel> agendas;

  InitialState({
    @required this.agendas,
  });

  @override
  List<Object> get props => [agendas];
}

class ErrorState extends AppointmentsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
