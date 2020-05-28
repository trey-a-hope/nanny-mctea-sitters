import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/chat_message.dart';
import 'package:nanny_mctea_sitters_flutter/services/fcm_notification.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MessagePage extends StatelessWidget {
  MessagePage(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationID,
      @required this.title});

  final UserModel sender;
  final UserModel sendee;
  final String conversationID;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ChatScreen(
          sender: sender, sendee: sendee, conversationID: conversationID),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationID});

  final UserModel sender;
  final UserModel sendee;
  final String conversationID;

  @override
  State createState() => ChatScreenState(
      sender: sender, sendee: sendee, conversationID: conversationID);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationID});

  final UserModel sender;
  final UserModel sendee;
  final CollectionReference _conversationsRef =
      Firestore.instance.collection('Conversations');
  final List<ChatMessage> _messages = List<ChatMessage>();
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  DocumentReference _thisConversationDoc;
  CollectionReference _messageRef;
  String conversationID;

  @override
  void initState() {
    super.initState();

    //Mark conversation as read as soon as user opens it.
    if (conversationID != null) {
      _conversationsRef.document(conversationID).updateData(
        {'${sender.id}_read': true},
      );
    }
    _load();
  }

  _load() {
    if (conversationID != null) {
      _thisConversationDoc = _conversationsRef.document(conversationID);
      _messageRef = _thisConversationDoc.collection('messages');

      //Listen for incoming messages.
      _messageRef.snapshots().listen(
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
                userID: messageDoc['userID'],
                myUserID: sender.id,
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              );

              setState(
                () {
                  //Add message if it is new.
                  if (_isNewMessage(message)) {
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

  bool _isNewMessage(ChatMessage cm) {
    for (ChatMessage chatMessage in _messages) {
      if (chatMessage.id == cm.id) {
        return false;
      }
    }
    return true;
  }

  void _handleSubmitted(String text) {
    //If this is a new message...
    if (conversationID == null) {
      //Create thread.
      _thisConversationDoc = _conversationsRef.document();
      conversationID = _thisConversationDoc.documentID;
      //Set collection reference for messages on this thread.
      _messageRef = _thisConversationDoc.collection('messages');
      //List for incoming messages.
      _messageRef.snapshots().listen(
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
                userID: messageDoc['userID'],
                myUserID: sender.id,
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              );

              setState(
                () {
                  //Add message is it is new.
                  if (_isNewMessage(message)) {
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
      Map<String, dynamic> usersData = Map<String, dynamic>();

      //For sender...
      convoData[sender.id] = true;
      usersData[sender.id] = sender.name;

      //For sendee...
      convoData[sendee.id] = true;
      usersData[sendee.id] = sendee.name;

      //Apply "array" of user ids to the convo data.
      convoData['users'] = usersData;

      _thisConversationDoc.setData(convoData);

      // _analytics.logEvent(name: 'Message_Sent');
    }

    //Save messagea data.
    String messageID = _messageRef.document().documentID;
    createChatMessage(
        _messageRef, messageID, text, sender.imgUrl, sender.name, sender.id);

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
    locator<FCMNotificationService>().sendNotificationToUser(
        fcmToken: sendee.fcmToken,
        title: 'New Message From ${sender.name}',
        body: text.length > 25 ? text.substring(0, 25) + '...' : text);

    _textController.clear();

    ChatMessage message = ChatMessage(
      id: messageID,
      name: sender.name,
      imageUrl: sender.imgUrl,
      text: text,
      time: DateTime.now(),
      userID: sendee.id,
      myUserID: sender.id,
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

  createChatMessage(CollectionReference messageRef, String messageID,
      String text, String imageUrl, String userName, String userID) async {
    var data = {
      'text': text,
      'imageUrl': imageUrl,
      'name': userName,
      'userID': userID,
      'time': DateTime.now()
    };

    await messageRef.document(messageID).setData(data);
  }
}
