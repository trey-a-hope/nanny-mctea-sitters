import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BookSitterInfoState extends Equatable {
  BookSitterInfoState();
  @override
  List<Object> get props => [];
}

class LoadedState extends BookSitterInfoState {
  final DateTime selectedDate;
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoadedState({
    @required this.selectedDate,
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        selectedDate,
        autoValidate,
        formKey,
      ];
}
