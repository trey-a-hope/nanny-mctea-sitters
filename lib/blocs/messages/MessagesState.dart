// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// class MessageState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// //State: Initial view, nothing has been changed.
// class NoMessagesState extends MessageState {}

// class MessagesState extends MessageState {
//   final ChatUser sendee;
//   final ChatUser sender;
//   final DocumentReference convoDocRef;
//   final QuerySnapshot querySnapshot;

//   MessagesState(
//       {@required this.sendee,
//       @required this.sender,
//       @required this.convoDocRef,
//       @required this.querySnapshot});

//   @override
//   List<Object> get props => [
//         sendee,
//         sender,
//         convoDocRef,
//         querySnapshot,
//       ];
// }

// class LoadingState extends MessageState {
//   final String text;

//   LoadingState({@required this.text});

//   @override
//   List<Object> get props => [text];
// }

// class ErrorState extends MessageState {
//   final dynamic error;

//   ErrorState({
//     @required this.error,
//   });

//   @override
//   List<Object> get props => [
//         error,
//       ];
// }
