import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddCardState extends Equatable {
  AddCardState();
  @override
  List<Object> get props => [];
}

class LoadingState extends AddCardState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class InitialState extends AddCardState {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isCvvFocused;

  InitialState({
    @required this.cardNumber,
    @required this.expiryDate,
    @required this.cardHolderName,
    @required this.cvvCode,
    @required this.isCvvFocused,
  });

  @override
  List<Object> get props => [
        cardNumber,
        expiryDate,
        cardHolderName,
        cvvCode,
        isCvvFocused,
      ];
}

class SuccessState extends AddCardState {
  SuccessState();

  @override
  List<Object> get props => [];
}

class ErrorState extends AddCardState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
