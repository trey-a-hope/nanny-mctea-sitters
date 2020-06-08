import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';

class PaymentMethodState extends Equatable {
  PaymentMethodState();
  @override
  List<Object> get props => [];
}

class LoadingState extends PaymentMethodState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class NoCardState extends PaymentMethodState {
  NoCardState();

  @override
  List<Object> get props => [];
}

class NavigateToAddCardState extends PaymentMethodState {
  final CustomerModel customer;
  final UserModel currentUser;
  NavigateToAddCardState({
    @required this.customer,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        customer,
        currentUser,
      ];
}

class InitialState extends PaymentMethodState {
  final CustomerModel customer;
  InitialState({
    @required this.customer,
  });

  @override
  List<Object> get props => [
        customer,
      ];
}
