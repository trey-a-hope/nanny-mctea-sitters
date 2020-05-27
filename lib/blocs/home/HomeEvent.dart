import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends HomeEvent {

  LoadPageEvent();

  List<Object> get props => [];
}
