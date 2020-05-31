import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  List<Object> get props => [];
}
