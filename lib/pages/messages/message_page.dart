import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/chat_message.dart';
import 'package:nanny_mctea_sitters_flutter/services/message.dart';
import 'package:nanny_mctea_sitters_flutter/services/fcm_notification.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MessagePage extends StatelessWidget {
  MessagePage(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId,
      @required this.title});

  final User sender;
  final User sendee;
  final String conversationId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: ChatScreen(
          sender: sender, sendee: sendee, conversationId: conversationId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId});

  final User sender; //Myself
  final User sendee; //Person I'm talking to.
  final String conversationId;

  @override
  State createState() => ChatScreenState(
      sender: sender, sendee: sendee, conversationId: conversationId);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId});

  final User sender;
  final User sendee;
  final CollectionReference _conversationsRef =
      Firestore.instance.collection('Conversations');
  final List<ChatMessage> _messages = List<ChatMessage>();
  final TextEditingController _textController = TextEditingController();
  final GetIt getIt = GetIt.I;
  bool _isComposing = false;
  DocumentReference _thisConversationDoc;
  CollectionReference _messagesDB;
  String conversationId;

  @override
  void initState() {
    super.initState();

    //Mark conversation as read as soon as user opens it.
    if (conversationId != null) {
      _conversationsRef.document(conversationId).updateData(
        {'${sender.id}_read': true},
      );
    }
    _load();
  }

  _load() {
    if (conversationId != null) {
      _thisConversationDoc = _conversationsRef.document(conversationId);
      _messagesDB = _thisConversationDoc.collection('messages');

      //Listen for incoming messages.
      _messagesDB.snapshots().listen(
        (messageSnapshot) {
          //Sort messages by time.
          messageSnapshot.documents.sort(
            (a, b) => a['time'].compareTo(
              b['time'],
            ),
          );
          //
          messageSnapshot.documents.forEach(
            (messageDoc) {
              //Build chat message.
              ChatMessage message = ChatMessage(
                id: messageDoc.documentID,
                name: messageDoc['name'],
                imageUrl: messageDoc['imageUrl'],
                text: messageDoc['text'],
                time: messageDoc['time'].toDate(),
                userId: messageDoc['userId'],
                myUserId: sender.id,
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              );

              setState(
                () {
                  //Add message if it is new.
                  if (getIt<Message>().isNewMessage(
                      chatMessage: message, messages: _messages)) {
                    _messages.insert(0, message);
                  }
                },
              );

              message.animationController.forward();
            },
          );
        },
      );
    }
  }

  void _handleSubmitted(String text) {
    //If this is a new message...
    if (conversationId == null) {
      //Create thread.
      _thisConversationDoc = _conversationsRef.document();
      conversationId = _thisConversationDoc.documentID;
      //Set collection reference for messages on this thread.
      _messagesDB = _thisConversationDoc.collection('messages');
      //List for incoming messages.
      _messagesDB.snapshots().listen(
        (messageSnapshot) {
          messageSnapshot.documents.forEach(
            (messageDoc) {
              //Build chat message.
              ChatMessage message = ChatMessage(
                id: messageDoc.documentID,
                name: messageDoc['name'],
                imageUrl: messageDoc['imageUrl'],
                text: messageDoc['text'],
                time: messageDoc['time'].toDate(),
                userId: messageDoc['userId'],
                myUserId: sender.id,
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              );

              setState(
                () {
                  //Add message is it is new.
                  if (getIt<Message>().isNewMessage(
                      chatMessage: message, messages: _messages)) {
                    _messages.insert(0, message);
                  }
                },
              );
              message.animationController.forward();
            },
          );
        },
      );

      //Set user id's to true for this thread for searching purposes.
      //Also save each user's username to display as thread title.
      Map<String, dynamic> convoData = Map<String, dynamic>();
      // Map<String, dynamic> usersData = Map<String, dynamic>();

      //For sender...
      convoData[sender.id] = true;
      // usersData[sender.id] = sender.name;

      //For sendee...
      convoData[sendee.id] = true;
      // usersData[sendee.id] = sendee.name;

      //Apply "array" of user ids to the convo data.
      convoData['users'] = [sender.id, sendee.id];

      _thisConversationDoc.setData(convoData);

      // _analytics.logEvent(name: 'Message_Sent');
    }

    //Save messagea data.
    String messageId = _messagesDB.document().documentID;
    getIt<Message>().createChatMessage(
        messageRef: _messagesDB,
        messageId: messageId,
        text: text,
        imageUrl: sender.imgUrl,
        userName: sender.name,
        userId: sender.id);

    //Update message thread.
    _thisConversationDoc.updateData(
      {
        'lastMessage': text,
        'imageUrl': sender.imgUrl,
        'time': DateTime.now(),
        '${sender.id}_read': true,
        '${sendee.id}_read': false
      },
    );

    //Notifiy user of new message.
    getIt<FCMNotification>().sendNotificationToUser(
        fcmToken: sendee.fcmToken,
        title: 'New Message From ${sender.name}',
        body: text.length > 25 ? text.substring(0, 25) + '...' : text);

    _textController.clear();

    ChatMessage message = ChatMessage(
      id: messageId,
      name: sender.name,
      imageUrl: sender.imgUrl,
      text: text,
      time: DateTime.now(),
      userId: sendee.id,
      myUserId: sender.id,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState(
      () {
        _isComposing = false;
        _messages.insert(0, message);
      },
    );

    message.animationController.forward();
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ),
              )
            : null); //new
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String text) {
                    setState(
                      () {
                        _isComposing = text.length > 0;
                      },
                    );
                  },
                  onSubmitted: _handleSubmitted,
                  decoration:
                      InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      ),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]),
                  ),
                )
              : null),
    );
  }
}
