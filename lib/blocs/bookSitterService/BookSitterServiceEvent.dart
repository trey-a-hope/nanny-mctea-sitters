import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookSitterServiceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleEvent extends BookSitterServiceEvent {
  final int tab;

  ToggleEvent({@required this.tab});

  @override
  List<Object> get props => [tab];
}
