import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSitterCalendarState extends Equatable {
  BookSitterCalendarState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookSitterCalendarState {
  LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedState extends BookSitterCalendarState {
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  // final List<dynamic> availableSlots;
  final List<ResourceModel> resources;
  final ResourceModel selectedResource;

  final DateTime start;
  final DateTime finish;

  LoadedState({
    @required this.calendarController,
    @required this.events,
    // @required this.availableSlots,
    @required this.start,
    @required this.finish,
    @required this.resources,
    @required this.selectedResource,
  });

  @override
  List<Object> get props => [
        calendarController,
        events,
        // availableSlots,
        start,
        finish,
        resources,
        selectedResource,
      ];
}

class ErrorState extends BookSitterCalendarState {
  final dynamic error;

  ErrorState({@required this.error});
  @override
  List<Object> get props => [];
}

class NavigateToBookSitterTimePageState extends BookSitterCalendarState {
  NavigateToBookSitterTimePageState();
  @override
  List<Object> get props => [];
}
