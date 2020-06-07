import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SubscriptionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SubscriptionEvent {}

class SubscribeEvent extends SubscriptionEvent {
  final String planID;

  SubscribeEvent({@required this.planID});

  @override
  List<Object> get props => [];
}

class UnsubscribeEvent extends SubscriptionEvent {}
