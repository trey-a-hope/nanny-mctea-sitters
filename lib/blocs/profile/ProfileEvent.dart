import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  ProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ProfileEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
