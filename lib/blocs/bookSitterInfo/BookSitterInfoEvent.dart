import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class BookSitterInfoEvent extends Equatable {
  BookSitterInfoEvent();
  @override
  List<Object> get props => [];
}

class ValidateFormEvent extends BookSitterInfoEvent {
  final GlobalKey<FormState> formKey;

  ValidateFormEvent({
    @required this.formKey,
  });
  @override
  List<Object> get props => [
        formKey,
      ];
}