import 'package:equatable/equatable.dart';

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
