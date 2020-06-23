// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
// import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/FCMNotificationService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
// import '../../ServiceLocator.dart';
// import 'Bloc.dart';

// abstract class MessageBlocDelegate {
//   void showAlert({@required String message});
// }

// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   MessageBloc(
//       {@required this.sendee,
//       @required this.sender,
//       @required this.convoDocRef});

//   final ChatUser sendee;
//   final ChatUser sender;
//   final DocumentReference convoDocRef;

//   UserModel currentUser;
//   StreamSubscription subscription;
//   MessageBlocDelegate delegate;

//   void setDelegate({@required MessageBlocDelegate delegate}) {
//     this.delegate = delegate;
//   }

//   @override
//   MessageState get initialState => LoadingState(text: 'Loading...');

//   @override
//   Stream<MessageState> mapEventToState(MessageEvent event) async* {
//     if (event is LoadPageEvent) {
//       //Display spinner.
//       yield LoadingState(text: 'Loading...');

//       //Fetch the current user.
//       currentUser = await locator<AuthService>().getCurrentUser();

//       //Update my read status to true, and the person I'm sending to false.
//       convoDocRef.updateData(
//           {'${sender.uid}_read': true, '${sendee.uid}_read': false});

//       Query query = convoDocRef.collection('Messages');

//       //Determine if any messages exist for this convo.
//       if ((await query.getDocuments()).documents.isEmpty) {
//         yield NoMessagesState();
//       } else {
//         Stream<QuerySnapshot> snapshots = query.snapshots();
//         subscription = snapshots.listen(
//           (querySnapshot) {
//             add(
//               MessageAddedEvent(querySnapshot: querySnapshot),
//             );
//           },
//         );
//       }
//     }

//     if (event is MessageAddedEvent) {
//       yield MessagesState(
//         sendee: sendee,
//         sender: sender,
//         convoDocRef: convoDocRef,
//         querySnapshot: event.querySnapshot,
//       );
//     }

//     if (event is DownloadImageEvent) {
//       // void downloadImage({@required String imgUrl}) async {
//       try {
//         // Saved with this method.
//         var imageId = await ImageDownloader.downloadImage(event.imgUrl);
//         if (imageId == null) {
//           delegate.showAlert(
//               message: 'Could not download message at this time.');
//         } else {
//           // Below is a method of obtaining saved image information.
//           var fileName = await ImageDownloader.findName(imageId);
//           var path = await ImageDownloader.findPath(imageId);
//           var size = await ImageDownloader.findByteSize(imageId);
//           var mimeType = await ImageDownloader.findMimeType(imageId);

//           delegate.showAlert(message: 'Image downloaded.');
//         }
//       } on PlatformException catch (error) {
//         print(error);
//       }
//       // }
//     }

//     //Validate user has messages left.
//     if (event is ValidateSendMessageEvent) {
//       add(
//         SendMessageEvent(message: event.message),
//       );
//     }



//     if (event is SendMessageEvent) {
//       try {
//         //Extract chat message from event.
//         ChatMessage message = event.message;
//         //print(message.toJson());

//         //Create firestore database instance.
//         Firestore db = Firestore.instance;

//         //Create batch
//         WriteBatch batch = db.batch();

//         //Update fields on convo document.
//         batch.updateData(convoDocRef, {
//           '${sender.uid}_read': true, //I have seen the message.
//           '${sendee.uid}_read':
//               false, //The person I'm sending to, has not seen the message.
//           'lastMessage': message.image == null
//               ? message.text
//               : 'Image', //The most recent message in the convo
//           'time': DateTime.now() //Time message was sent.
//         });

//         //Create new message.
//         DocumentReference newMessageDocRef =
//             convoDocRef.collection('Messages').document(
//                   DateTime.now().millisecondsSinceEpoch.toString(),
//                 );

//         batch.setData(
//           newMessageDocRef,
//           message.toJson(),
//         );

//         //Commit batch.
//         await batch.commit();

//         //Send notification to user.
//         await locator<FCMNotificationService>().sendNotificationToUser(
//             fcmToken: sendee.fcmToken,
//             title: 'New message from ${sender.name}',
//             body: message.text);

//         //Fetch latest user and customer info.
//         currentUser = await locator<AuthService>().getCurrentUser();

//       } catch (error) {
//         yield ErrorState(error: error);
//       }
//     }

//     if (event is PickImageEvent) {
//       File result = await ImagePicker.pickImage(
//         source: ImageSource.gallery,
//         // imageQuality: 80,
//         // maxHeight: 400,
//         // maxWidth: 400,
//       );

//       if (result != null) {
//         try {
//           bool confirm = await locator<ModalService>()
//               .showConfirmationWithImage(
//                   context: event.context,
//                   title: 'Send This Image?',
//                   message: 'Are you sure?',
//                   file: result);
//           if (confirm) {
//             final StorageReference storageRef =
//                 FirebaseStorage.instance.ref().child(convoDocRef.path).child(
//                       DateTime.now().toString(),
//                     );

//             StorageUploadTask uploadTask = storageRef.putFile(
//               result,
//               StorageMetadata(
//                 contentType: 'image/jpg',
//               ),
//             );
//             StorageTaskSnapshot download = await uploadTask.onComplete;

//             String url = await download.ref.getDownloadURL();

//             ChatMessage message =
//                 ChatMessage(text: '', user: sender, image: url);

//             var documentReference = convoDocRef
//                 .collection('Messages')
//                 .document(DateTime.now().millisecondsSinceEpoch.toString());

//             Firestore.instance.runTransaction((transaction) async {
//               await transaction.set(
//                 documentReference,
//                 message.toJson(),
//               );
//             });
//           }
//         } catch (e) {
//           locator<ModalService>().showAlert(
//             context: event.context,
//             title: 'Error',
//             message: e.toString(),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Future<void> close() {
//     subscription?.cancel();
//     return super.close();
//   }
// }
