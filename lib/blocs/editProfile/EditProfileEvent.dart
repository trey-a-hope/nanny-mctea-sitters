import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/addCard/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class EditProfileEvent extends Equatable {
  EditProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends EditProfileEvent {
  LoadPageEvent();
  @override
  List<Object> get props => [];
}

class SubmitEvent extends EditProfileEvent {
  final String name;
  final String phone;

  SubmitEvent({
    @required this.name,
    @required this.phone,
  });
  @override
  List<Object> get props => [
        name,
        phone,
      ];
}
