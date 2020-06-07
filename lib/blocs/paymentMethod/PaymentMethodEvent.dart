import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class PaymentMethodEvent extends Equatable {
  PaymentMethodEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends PaymentMethodEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class NavigateToAddCardEvent extends PaymentMethodEvent {
  NavigateToAddCardEvent();
  @override
  List<Object> get props => [];
}
