import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

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

class OnVisibleDaysChangedEvent extends BookSitterCalendarEvent {
  final DateTime first;
  final DateTime last;
  final CalendarFormat format;

  OnVisibleDaysChangedEvent({
    @required this.first,
    @required this.last,
    @required this.format,
  });

  @override
  List<Object> get props => [first, last, format];
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

class NavigateToBookSitterInfoPageEvent extends BookSitterCalendarEvent {
  final DateTime selectedDate;

  NavigateToBookSitterInfoPageEvent({
    @required this.selectedDate,
  });

  @override
  List<Object> get props => [selectedDate];
}

class OnTimeSelectEvent extends BookSitterCalendarEvent {
  final BuildContext context;

  OnTimeSelectEvent({
    @required this.context,
  });
  @override
  List<Object> get props => [
        context,
      ];
}
