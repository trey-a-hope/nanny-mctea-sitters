import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class BookSitterInfoEvent extends Equatable {
  BookSitterInfoEvent();
  @override
  List<Object> get props => [];
}

class NavigateToPaymentPageEvent extends BookSitterInfoEvent {
  final GlobalKey<FormState> formKey;

  final String name;
  final String email;
  final String street;
  final String aptNo;
  final String city;
  final String phoneNumber;

  NavigateToPaymentPageEvent({
    @required this.formKey,
    @required this.name,
    @required this.email,
    @required this.street,
    @required this.aptNo,
    @required this.city,
    @required this.phoneNumber,
  });

  @override
  List<Object> get props => [
        formKey,
        name,
        email,
        street,
        aptNo,
        city,
        phoneNumber,
      ];
}
