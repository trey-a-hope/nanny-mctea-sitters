import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSitterInfoState extends Equatable {
  BookSitterInfoState();
  @override
  List<Object> get props => [];
}

class InitialState extends BookSitterInfoState {
  InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookSitterInfoState {
  LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedState extends BookSitterInfoState {
  LoadedState();

  @override
  List<Object> get props => [];
}

class ErrorState extends BookSitterInfoState {
  final dynamic error;

  ErrorState({@required this.error});
  @override
  List<Object> get props => [];
}
