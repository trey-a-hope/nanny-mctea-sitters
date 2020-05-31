import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
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
  final Map<DateTime, List<AppointmentModel>> events;

  LoadedState({
    @required this.calendarController,
    @required this.events,
  });

  @override
  List<Object> get props => [];
}

class ErrorState extends BookSitterCalendarState {
  final dynamic error;

  ErrorState({@required this.error});
  @override
  List<Object> get props => [];
}
