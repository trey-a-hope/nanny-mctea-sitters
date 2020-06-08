import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SignUpEvent {}

