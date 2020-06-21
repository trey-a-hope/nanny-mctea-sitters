import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/PlanModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/SubscriptionModel.dart';

class SubscriptionState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubscribedState extends SubscriptionState {
  final PlanModel plan;
  final SubscriptionModel subscription;

  SubscribedState({
    @required this.plan,
    @required this.subscription,
  });

  @override
  List<Object> get props => [
        plan,
        subscription,
      ];
}

class UnsubscribedState extends SubscriptionState {
  final PlanModel goldPlan;
  final PlanModel silverPlan;

  UnsubscribedState({@required this.goldPlan, @required this.silverPlan});

  @override
  List<Object> get props => [goldPlan, silverPlan];
}

class LoadingState extends SubscriptionState {
  final String text;

  LoadingState({@required this.text});

  @override
  List<Object> get props => [text];
}

class ErrorState extends SubscriptionState {
  final dynamic error;

  ErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
