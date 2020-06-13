import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';

class PaymentHistoryState extends Equatable {
  PaymentHistoryState();
  @override
  List<Object> get props => [];
}

class LoadingState extends PaymentHistoryState {
  LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedState extends PaymentHistoryState {
  final List<ChargeModel> charges;

  LoadedState({
    @required this.charges,
  });

  @override
  List<Object> get props => [];
}

class EmptyChargesState extends PaymentHistoryState {
  EmptyChargesState();

  @override
  List<Object> get props => [];
}

class ErrorState extends PaymentHistoryState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
