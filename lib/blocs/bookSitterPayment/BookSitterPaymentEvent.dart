import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class BookSitterPaymentEvent extends Equatable {
  BookSitterPaymentEvent();
  @override
  List<Object> get props => [];
}

class SubmitPaymentEvent extends BookSitterPaymentEvent {
  SubmitPaymentEvent();

  @override
  List<Object> get props => [];
}
