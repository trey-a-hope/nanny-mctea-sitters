import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/addCard/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class AppointmentDetailsEvent extends Equatable {
  AppointmentDetailsEvent();
  @override
  List<Object> get props => [];
}

class DeleteAppointmentEvent extends AppointmentDetailsEvent {
  DeleteAppointmentEvent();
  @override
  List<Object> get props => [];
}
