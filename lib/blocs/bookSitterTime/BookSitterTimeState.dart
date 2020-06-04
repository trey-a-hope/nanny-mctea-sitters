import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSitterTimeState extends Equatable {
  BookSitterTimeState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookSitterTimeState {
  LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedState extends BookSitterTimeState {
  // final CalendarController calendarController;
  // final Map<DateTime, List<dynamic>> events;
  // final List<ResourceModel> resources;
  // final ResourceModel selectedResource;

  // final DateTime start;
  // final DateTime finish;

  LoadedState(
  //   {
  //   @required this.calendarController,
  //   @required this.events,
  //   // @required this.availableSlots,
  //   @required this.start,
  //   @required this.finish,
  //   @required this.resources,
  //   @required this.selectedResource,
  // }
  );

  @override
  List<Object> get props => [
        // calendarController,
        // events,
        // // availableSlots,
        // start,
        // finish,
        // resources,
        // selectedResource,
      ];
}

class ErrorState extends BookSitterTimeState {
  final dynamic error;

  ErrorState({@required this.error});
  @override
  List<Object> get props => [];
}
