import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BookSitterPaymentState extends Equatable {
  BookSitterPaymentState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookSitterPaymentState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class NoCardState extends BookSitterPaymentState {
  NoCardState();

  @override
  List<Object> get props => [];
}

class NavigateToAddCardState extends BookSitterPaymentState {
  NavigateToAddCardState();

  @override
  List<Object> get props => [];
}

class InitialState extends BookSitterPaymentState {
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

  InitialState({
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

class SuccessState extends BookSitterPaymentState {
  SuccessState();
  @override
  List<Object> get props => [];
}

class ErrorState extends BookSitterPaymentState {
  ErrorState();
  @override
  List<Object> get props => [];
}
