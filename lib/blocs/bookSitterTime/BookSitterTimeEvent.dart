import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class BookSitterTimeEvent extends Equatable {
  BookSitterTimeEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BookSitterTimeEvent {
  LoadPageEvent();
  @override
  List<Object> get props => [];
}

