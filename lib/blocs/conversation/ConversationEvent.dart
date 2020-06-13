import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ConversationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ConversationEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class ConversationAddedEvent extends ConversationEvent {
  final QuerySnapshot querySnapshot;

  ConversationAddedEvent({@required this.querySnapshot});

  @override
  List<Object> get props => [querySnapshot];
}

class UpdatePhotoEvent extends ConversationEvent {
  final ImageSource imageSource;

  UpdatePhotoEvent({@required this.imageSource});

  @override
  List<Object> get props => [];
}
