import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BookSitterInfoState extends Equatable {
  BookSitterInfoState();
  @override
  List<Object> get props => [];
}

class LoadedState extends BookSitterInfoState {
  final DateTime selectedDate;
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoadedState({
    @required this.selectedDate,
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        selectedDate,
        autoValidate,
        formKey,
      ];
}

class NavigateToPaymentPageState extends BookSitterInfoState {
  final DateTime selectedDate;
  final String service;
  final int hours;
  final double cost;
  final String name;
  final String email;
  final String phoneNumber;
  final String street;
  final String aptNo;
  final String city;

  NavigateToPaymentPageState({
    @required this.selectedDate,
    @required this.service,
    @required this.hours,
    @required this.cost,
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    @required this.street,
    @required this.aptNo,
    @required this.city,
  });

  @override
  List<Object> get props => [
        selectedDate,
        service,
        hours,
        cost,
        name,
        email,
        phoneNumber,
        street,
        aptNo,
        city,
      ];
}
