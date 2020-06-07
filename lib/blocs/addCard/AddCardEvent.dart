import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class AddCardEvent extends Equatable {
  AddCardEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends AddCardEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
