//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
//Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//INTL
import 'package:intl/intl.dart';
//Models
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/chat_message.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/notification.dart';

import '../../constants.dart';

//Services
// import 'package:campcentral_flutter/services/notification.dart';

final CollectionReference _conversationsRef =
    Firestore.instance.collection('Conversations');
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final String timeFormat = 'h:mm a';
DocumentReference _thisConversationDoc;
CollectionReference _messageRef;

class MessagePage extends StatelessWidget {
  MessagePage(this.userAId, this.userBId, this._conversationId);

  final String userAId;
  final String userBId;
  final String _conversationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Message'),
      ),
      body: ChatScreen(userAId, userBId, _conversationId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(this._userAId, this._userBId, this._conversationId);

  final String _userAId; //Myself
  final String _userBId; //Person I'm talking to.
  final String _conversationId;

  @override
  State createState() => ChatScreenState(_userAId, _userBId, _conversationId);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(this._userAId, this._userBId, this._conversationId);

  final String _userAId;
  User _userA;
  final String _userBId;
  User _userB;
  String _conversationId;

  final List<ChatMessage> _messages = List<ChatMessage>();
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  final _db = Firestore.instance;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<User> _getUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection('Users').document(id).get();
    return User.extractDocument(documentSnapshot);
  }

  _load() async {
    _userA = await _getUser(_userAId);
    _userB = await _getUser(_userBId);

    setState(
      () {
        if (_conversationId != null) {
          print(_conversationId);

          _thisConversationDoc = _conversationsRef.document(_conversationId);
          _messageRef = _thisConversationDoc.collection('messages');

          //List for incoming messages.
          _messageRef.snapshots().listen(
            (messageSnapshot) {
              //Sort messages by timestamp.
              messageSnapshot.documents.sort(
                (a, b) => a['timestamp'].compareTo(
                  b['timestamp'],
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
                    time: messageDoc['timestamp'].toDate(),
                    userId: messageDoc['userId'],
                    myUserId: _userA.id,
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
        } else {
          print('This is a message.');
        }
      },
    );
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
    if (_userA == null) {
      return;
    }

    //If this is a new message...
    if (_conversationId == null) {
      //Create thread.
      _thisConversationDoc = _conversationsRef.document();
      _conversationId = _thisConversationDoc.documentID;
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
                time: messageDoc['timestamp'].toDate(),
                userId: messageDoc['userId'],
                myUserId: _userA.id,
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

      //For user A...
      convoData[_userA.id] = true;
      usersData[_userA.id] = _userA.name;

      //For user B...
      convoData[_userB.id] = true;
      usersData[_userB.id] = _userB.name;

      //Apply "array" of user emails to the convo data.
      convoData['users'] = usersData;

      //Apply the number of users to the convo data.
      convoData['userCount'] = 2;

      //Apply the last message to the convo data.
      convoData['lastMessage'] = text;

      //Apply the image url of the last person to message the group.
      convoData['lastImageUrl'] = DUMMY_PROFILE_PHOTO_URL;

      _thisConversationDoc.setData(convoData);

      // _analytics.logEvent(name: 'Message_Sent');
    }

    //Save messagea data.
    String messageId = _messageRef.document().documentID;
    createChatMessage(_messageRef, messageId, text, DUMMY_PROFILE_PHOTO_URL,
        _userA.name, _userA.id);

    //Update message thread.
    _thisConversationDoc.updateData(
        {'lastMessage': text, 'lastImageUrl': DUMMY_PROFILE_PHOTO_URL});

    //Notifiy user of new message.
    NotificationService.sendNotificationToUser(
        fcmToken: _userB.fcmToken,
        title: 'New Message From ${_userA.name}',
        body: text.length > 25 ? text.substring(0, 25) + '...' : text);

    _textController.clear();

    ChatMessage message = ChatMessage(
      id: messageId,
      name: _userA.name,
      imageUrl: DUMMY_PROFILE_PHOTO_URL,
      text: text,
      time: DateTime.now(),
      userId: _userB.id,
      myUserId: _userA.id,
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
          child: Row(children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
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
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200])))
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

  createChatMessage(CollectionReference messageRef, String messageId,
      String text, String imageUrl, String userName, String userId) async {
    var data = {
      'text': text,
      'imageUrl': imageUrl,
      'name': userName,
      'userId': userId,
      'timestamp': DateTime.now()
    };

    await messageRef.document(messageId).setData(data);
  }
}
