import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

class ConversationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends ConversationState {
  final QuerySnapshot querySnapshot;
  final UserModel currentUser;

  LoadedState({@required this.querySnapshot, @required this.currentUser});

  @override
  List<Object> get props => [querySnapshot, currentUser];
}

class NoConversationsState extends ConversationState {
  final UserModel currentUser;

  NoConversationsState({@required this.currentUser});

  @override
  List<Object> get props => [currentUser];
}

class LoadingState extends ConversationState {
  final String text;

  LoadingState({@required this.text});

  @override
  List<Object> get props => [text];
}

class ErrorState extends ConversationState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
