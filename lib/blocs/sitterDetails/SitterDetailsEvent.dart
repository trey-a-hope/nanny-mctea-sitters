import 'package:equatable/equatable.dart';

abstract class SitterDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SitterDetailsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends SitterDetailsEvent {
  SendMessageEvent();

  @override
  List<Object> get props => [];
}
