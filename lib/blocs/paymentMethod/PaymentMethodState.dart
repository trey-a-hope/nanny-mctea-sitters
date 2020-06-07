import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  NavigateToAddCardState();

  @override
  List<Object> get props => [];
}

class InitialState extends PaymentMethodState {
  InitialState();

  @override
  List<Object> get props => [];
}
