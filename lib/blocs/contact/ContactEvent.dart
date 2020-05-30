import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendEmailEvent extends ContactEvent {
  final String subject;
  final String message;

  SendEmailEvent({@required this.subject, @required this.message});

  @override
  List<Object> get props => [subject, message];
}
