// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
// import '../../ServiceLocator.dart';
// import '../../constants.dart';
// import 'Bloc.dart';

// class MessagePage extends StatefulWidget {
//   @override
//   MessagePageState createState() => MessagePageState();
// }

// class MessagePageState extends State<MessagePage>
//     implements MessageBlocDelegate {
//   final GlobalKey<DashChatState> chatViewKey = GlobalKey<DashChatState>();
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   List<ChatMessage> messages = List<ChatMessage>();
//   List<ChatMessage> m = List<ChatMessage>();

//   int i = 0;
//   double imageSize = 120;
//   MessageBloc _bloc;

//   @override
//   void initState() {
//     //Assign new instance of bloc and set delegate.
//     _bloc = BlocProvider.of<MessageBloc>(context);
//     _bloc.setDelegate(delegate: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _bloc.close();
//     super.dispose();
//   }

//   @override
//   void showAlert({@required String message}) async {
//     locator<ModalService>()
//         .showAlert(context: context, title: '', message: message);
//   }

//   void systemMessage() {
//     Timer(Duration(milliseconds: 300), () {
//       if (i < 6) {
//         setState(() {
//           messages = [...messages, m[i]];
//         });
//         i++;
//       }
//       Timer(Duration(milliseconds: 300), () {
//         chatViewKey.currentState.scrollController
//           ..animateTo(
//             chatViewKey.currentState.scrollController.position.maxScrollExtent,
//             curve: Curves.easeOut,
//             duration: const Duration(milliseconds: 300),
//           );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<MessageBloc, MessageState>(
//       listener: (BuildContext context, MessageState state) async {},
//       builder: (BuildContext context, MessageState state) {
//         if (state is LoadingState) {
//           return Scaffold(
//             key: scaffoldKey,
//             appBar: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(''),
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
//                   )
//                 ],
//               ),
//             ),
//             body: Center(
//               child: Spinner(),
//             ),
//           );
//         }

//         if (state is NoMessagesState) {
//           return Scaffold(
//             key: scaffoldKey,
//             appBar: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(''),
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
//                   )
//                 ],
//               ),
//             ),
//             body: Center(
//               child: Text('No messages.'),
//             ),
//           );
//         }

//         if (state is MessagesState) {
//           final String sendeeName = state.sendee.name.length > 12
//               ? '${state.sendee.name.substring(0, 13)}...'
//               : state.sendee.name;

//           List<DocumentSnapshot> items = state.querySnapshot.documents;
//           var messages =
//               items.map((i) => ChatMessage.fromJson(i.data)).toList();

//           return Scaffold(
//             key: scaffoldKey,
//             appBar: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(sendeeName),
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(state.sendee.avatar),
//                   )
//                 ],
//               ),
//             ),
//             body: DashChat(
//               key: chatViewKey,
//               inverted: false,
//               onSend: (ChatMessage message) {
//                 _bloc.add(ValidateSendMessageEvent(message: message));
//               },
//               user: state.sender,
//               inputDecoration:
//                   InputDecoration.collapsed(hintText: "Add message here..."),
//               dateFormat: DateFormat('yyyy-MMM-dd'),
//               timeFormat: DateFormat('h:mm a'),
//               messages: messages,
//               showUserAvatar: true,
//               showAvatarForEveryMessage: true,
//               scrollToBottom: false,
//               onLongPressMessage: (ChatMessage chatMessage) {
//                 //Open/download image.
//                 if (chatMessage.image != null) {
//                   showBottomSheet(
//                     context: context,
//                     builder: (context) => Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ListTile(
//                             leading: Icon(Icons.open_in_browser),
//                             title: Text("View image"),
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (ctx) => Scaffold(
//                                     body: Container(
//                                       color: Colors.black,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Center(
//                                           child: Hero(
//                                             tag: chatMessage.image,
//                                             child: Image.network(
//                                                 chatMessage.image),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           ListTile(
//                               leading: Icon(Icons.file_download),
//                               title: Text("Download image"),
//                               onTap: () => _bloc.add(
//                                     DownloadImageEvent(
//                                         imgUrl: chatMessage.image),
//                                   )
//                               //downloadImage(imgUrl: chatMessage.image),
//                               ),
//                           ListTile(
//                             leading: Icon(Icons.cancel),
//                             title: Text("Cancel"),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 } //Copy message.
//                 else {
//                   showBottomSheet(
//                     context: context,
//                     builder: (context) => Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ListTile(
//                             leading: Icon(Icons.content_copy),
//                             title: Text("Copy to clipboard"),
//                             onTap: () {
//                               Clipboard.setData(
//                                   ClipboardData(text: chatMessage.text));
//                               Navigator.pop(context);
//                               locator<ModalService>().showInSnackBar(
//                                   scaffoldKey: scaffoldKey,
//                                   message: 'Message copied.');
//                             },
//                           ),
//                           ListTile(
//                             leading: Icon(Icons.cancel),
//                             title: Text("Cancel"),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               },
//               onPressAvatar: (ChatUser user) {
//                 print("OnPressAvatar: ${user.name}");
//               },
//               onLongPressAvatar: (ChatUser user) {
//                 print("OnLongPressAvatar: ${user.name}");
//               },
//               inputMaxLines: 5,
//               messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
//               alwaysShowSend: true,
//               inputTextStyle: TextStyle(fontSize: 16.0),
//               inputContainerStyle: BoxDecoration(
//                 border: Border.all(width: 0.0),
//                 color: Colors.white,
//               ),
//               onQuickReply: (Reply reply) {
//                 setState(
//                   () {
//                     messages.add(
//                       ChatMessage(
//                           text: reply.value,
//                           createdAt: DateTime.now(),
//                           user: state.sendee),
//                     );

//                     messages = [...messages];
//                   },
//                 );

//                 Timer(Duration(milliseconds: 300), () {
//                   chatViewKey.currentState.scrollController
//                     ..animateTo(
//                       chatViewKey.currentState.scrollController.position
//                           .maxScrollExtent,
//                       curve: Curves.easeOut,
//                       duration: const Duration(milliseconds: 300),
//                     );

//                   if (i == 0) {
//                     systemMessage();
//                     Timer(Duration(milliseconds: 600), () {
//                       systemMessage();
//                     });
//                   } else {
//                     systemMessage();
//                   }
//                 });
//               },
//               onLoadEarlier: () {
//                 print("loading...");
//               },
//               shouldShowLoadEarlier: false,
//               showTraillingBeforeSend: true,
//               trailing: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.photo),
//                   onPressed: () {
//                     _bloc.add(PickImageEvent(context: context));
//                     //pickImage()
//                   },
//                 )
//               ],
//             ),
//           );
//         }

//         if (state is ErrorState) {
//           return Center(
//             child: Text('Error: ${state.error.toString()}'),
//           );
//         }

//         return Container();
//       },
//     );
//   }
// }
