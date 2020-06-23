import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanny_mctea_sitters_flutter/services/ConversationService.dart';
import 'package:nanny_mctea_sitters_flutter/services/FCMNotificationService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import '../../ServiceLocator.dart';

class MessagePage extends StatefulWidget {
  MessagePage(
      {@required this.sendee,
      @required this.sender,
      @required this.convoDocRef});
  final ChatUser sendee;
  final ChatUser sender;
  final DocumentReference convoDocRef;
  @override
  MessagePageState createState() => MessagePageState(
      sendee: sendee, sender: sender, convoDocRef: convoDocRef);
}

class MessagePageState extends State<MessagePage> {
  MessagePageState(
      {@required this.sendee,
      @required this.sender,
      @required this.convoDocRef});
  final ChatUser sendee;
  final ChatUser sender;
  final DocumentReference convoDocRef;

  final GlobalKey<DashChatState> chatViewKey = GlobalKey<DashChatState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ChatMessage> messages = List<ChatMessage>();
  List<ChatMessage> m = List<ChatMessage>();

  int i = 0;

  double imageSize = 120;
  double listViewBuilderPadding = 10;

  @override
  void initState() {
    super.initState();

    print('${sender.name} ${sender.avatar}');
    print('${sendee.name} ${sendee.avatar}');
    convoDocRef
        .updateData({'${sender.uid}_read': true, '${sendee.uid}_read': false});
  }

  @override
  void dispose() {
    locator<ConversationsService>().cancelConversationSubscription();
    super.dispose();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        chatViewKey.currentState.scrollController
          ..animateTo(
            chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    //Update fields on convo document.
    convoDocRef.updateData({
      '${sender.uid}_read': true,
      '${sendee.uid}_read': false,
      'lastMessage': message.image == null ? message.text : 'Image',
      'time': DateTime.now()
    });

    //Create new message.
    DocumentReference docRef = convoDocRef
        .collection('Messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        docRef,
        message.toJson(),
      );
    });

    //Send notification to user.
    await locator<FCMNotificationService>().sendNotificationToUser(
        fcmToken: sendee.fcmToken,
        title: 'New message from ${sender.name}',
        body: message.text);

    print('Message sent');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final String sendeeName = sendee.name.length > 12
        ? '${sendee.name.substring(0, 13)}...'
        : sendee.name;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(sendeeName),
            CircleAvatar(
              backgroundImage: NetworkImage(sendee.avatar),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: convoDocRef.collection('Messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              List<DocumentSnapshot> items = snapshot.data.documents;
              var messages =
                  items.map((i) => ChatMessage.fromJson(i.data)).toList();
              return DashChat(
                key: chatViewKey,
                inverted: false,
                onSend: onSend,
                user: sender,
                inputDecoration:
                    InputDecoration.collapsed(hintText: "Add message here..."),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('h:mm a'),
                messages: messages,
                showUserAvatar: true,
                showAvatarForEveryMessage: true,
                scrollToBottom: false,
                onLongPressMessage: (ChatMessage chatMessage) {
                  //Open/download image.
                  if (chatMessage.image != null) {
                    showBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.open_in_browser),
                              title: Text("View image"),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => Scaffold(
                                      body: Container(
                                        color: Colors.black,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Center(
                                            child: Hero(
                                              tag: chatMessage.image,
                                              child: Image.network(
                                                  chatMessage.image),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.file_download),
                              title: Text("Download image"),
                              onTap: () =>
                                  downloadImage(imgUrl: chatMessage.image),
                            ),
                            ListTile(
                              leading: Icon(Icons.cancel),
                              title: Text("Cancel"),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  } //Copy message.
                  else {
                    showBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.content_copy),
                              title: Text("Copy to clipboard"),
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: chatMessage.text));
                                Navigator.pop(context);
                                locator<ModalService>().showInSnackBar(
                                    scaffoldKey: scaffoldKey,
                                    message: 'Message copied.');
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.cancel),
                              title: Text("Cancel"),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
                },
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  color: Colors.white,
                ),
                onQuickReply: (Reply reply) {
                  setState(
                    () {
                      messages.add(
                        ChatMessage(
                            text: reply.value,
                            createdAt: DateTime.now(),
                            user: sendee),
                      );

                      messages = [...messages];
                    },
                  );

                  Timer(Duration(milliseconds: 300), () {
                    chatViewKey.currentState.scrollController
                      ..animateTo(
                        chatViewKey.currentState.scrollController.position
                            .maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );

                    if (i == 0) {
                      systemMessage();
                      Timer(Duration(milliseconds: 600), () {
                        systemMessage();
                      });
                    } else {
                      systemMessage();
                    }
                  });
                },
                onLoadEarlier: () {
                  print("loading...");
                },
                shouldShowLoadEarlier: false,
                showTraillingBeforeSend: true,
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: pickImage,
                  )
                ],
              );
            }
          }),
    );
  }

  void downloadImage({@required String imgUrl}) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(imgUrl);
      if (imageId == null) {
        locator<ModalService>().showInSnackBar(
            scaffoldKey: scaffoldKey,
            message: 'Could not download image at this time.');
      } else {
        // Below is a method of obtaining saved image information.
        var fileName = await ImageDownloader.findName(imageId);
        var path = await ImageDownloader.findPath(imageId);
        var size = await ImageDownloader.findByteSize(imageId);
        var mimeType = await ImageDownloader.findMimeType(imageId);
        locator<ModalService>().showInSnackBar(
            scaffoldKey: scaffoldKey, message: 'Image downloaded.');
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void pickImage() async {
    File result = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 80,
      // maxHeight: 400,
      // maxWidth: 400,
    );

    if (result != null) {
      try {
        bool confirm = await locator<ModalService>().showConfirmationWithImage(
            context: context,
            title: 'Send This Image?',
            message: 'Are you sure?',
            file: result);
        if (confirm) {
          final StorageReference storageRef =
              FirebaseStorage.instance.ref().child(convoDocRef.path).child(
                    DateTime.now().toString(),
                  );

          StorageUploadTask uploadTask = storageRef.putFile(
            result,
            StorageMetadata(
              contentType: 'image/jpg',
            ),
          );
          StorageTaskSnapshot download = await uploadTask.onComplete;

          String url = await download.ref.getDownloadURL();

          ChatMessage message = ChatMessage(text: '', user: sendee, image: url);

          var documentReference = convoDocRef
              .collection('Messages')
              .document(DateTime.now().millisecondsSinceEpoch.toString());

          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              documentReference,
              message.toJson(),
            );
          });
        }
      } catch (e) {
        locator<ModalService>().showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }
}
