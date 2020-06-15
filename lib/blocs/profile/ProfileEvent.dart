import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

class HandleImageEvent extends ProfileEvent {
  final ImageSource imageSource;
  final String userID;

  HandleImageEvent({
    @required this.imageSource,
    @required this.userID,
  });

  @override
  List<Object> get props => [
        imageSource,
        userID,
      ];
}
