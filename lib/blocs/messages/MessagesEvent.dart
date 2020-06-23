import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
abstract class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChargeSendMessageEvent extends MessageEvent {
  final ChatMessage message;

  ChargeSendMessageEvent({@required this.message});

  List<Object> get props => [message];
}

class ValidateSendMessageEvent extends MessageEvent {
  final ChatMessage message;

  ValidateSendMessageEvent({@required this.message});

  List<Object> get props => [message];
}

class SendMessageEvent extends MessageEvent {
  final ChatMessage message;
  SendMessageEvent({@required this.message});

  List<Object> get props => [message];
}

class MessageAddedEvent extends MessageEvent {
  final QuerySnapshot querySnapshot;

  MessageAddedEvent({@required this.querySnapshot});

  List<Object> get props => [querySnapshot];
}

class LoadPageEvent extends MessageEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class DownloadImageEvent extends MessageEvent {
  final String imgUrl;
  DownloadImageEvent({@required this.imgUrl});

  @override
  List<Object> get props => [imgUrl];
}

class PickImageEvent extends MessageEvent {
  final BuildContext context;

  PickImageEvent({@required this.context});

  @override
  List<Object> get props => [];
}
