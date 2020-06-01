import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';

abstract class BookSitterCalendarEvent extends Equatable {
  BookSitterCalendarEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BookSitterCalendarEvent {
  LoadPageEvent();
  @override
  List<Object> get props => [];
}

class OnDaySelectedEvent extends BookSitterCalendarEvent {
  final DateTime day;
  final List<dynamic> events;

  OnDaySelectedEvent({
    @required this.day,
    @required this.events,
  });

  @override
  List<Object> get props => [day, events];
}

class OnSlotSelectedEvent extends BookSitterCalendarEvent {
  final dynamic slot;

  OnSlotSelectedEvent({
    @required this.slot,
  });

  @override
  List<Object> get props => [slot];
}

class OnResourceSelectedEvent extends BookSitterCalendarEvent {
  final ResourceModel resource;

  OnResourceSelectedEvent({
    @required this.resource,
  });

  @override
  List<Object> get props => [resource];
}
