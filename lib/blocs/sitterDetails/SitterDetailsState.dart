import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';

class SitterDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends SitterDetailsState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends SitterDetailsState {
  final UserModel sitter;

  LoadedState({
    @required this.sitter,
  });

  @override
  List<Object> get props => [
        sitter,
      ];
}
