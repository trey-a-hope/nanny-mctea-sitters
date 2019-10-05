import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/conversation.dart';
import 'dart:collection';
import 'package:nanny_mctea_sitters_flutter/pages/messages/message_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage(this.uid);

  final String uid;
  @override
  State createState() => _MessagesPageState(this.uid);
}

class _MessagesPageState extends State<MessagesPage> {
  _MessagesPageState(this.uid);

  List<Conversation> _conversations = List<Conversation>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int convoCharLimit = 60;
  User _currentUser;
  final _db = Firestore.instance;
  final String uid;
  final GetIt getIt = GetIt.I;
  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();

    //Get conversations this user is apart of.
    Firestore.instance
        .collection('Conversations')
        .where(_currentUser.id, isEqualTo: true)
        .snapshots()
        .listen(
      (convoSnapshot) {
        _conversations.clear();

        List<DocumentSnapshot> convoDocs = convoSnapshot.documents;
        for (var convoDoc in convoDocs) {
          Conversation conversation = Conversation();

          LinkedHashMap userNamesMap = convoDoc.data['users'];
          List<String> userIds = List<String>();
          List<String> userNames = List<String>();

          //Build list of users ids and user names.
          userNamesMap.forEach(
            (userId, userName) {
              userIds.add(userId);
              if (userId != _currentUser.id) {
                userNames.add(userName);
              }
            },
          );

          conversation.title = _buildConversationTitle(userNames);
          conversation.lastMessage = convoDoc['lastMessage'];
          conversation.lastImageUrl = convoDoc['lastImageUrl'];
          conversation.userAId = userIds[0];
          conversation.userBId = userIds[1];
          // conversation.userIds = userIds;
          _conversations.add(conversation);
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _conversations.isEmpty
          ? Center(
              child: Text('No Messsages At The Moment'),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _conversations.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(_conversations[index]);
              },
            ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Messages'),
    );
  }

  Widget _buildRow(Conversation conversation) {
    return Container(
        child: ListTile(
            onTap: () {
              _openMessageThread(conversation.userAId, conversation.userBId);
            },
            leading: CircleAvatar(
                backgroundColor: Colors.purple,
                backgroundImage: NetworkImage(conversation.lastImageUrl)),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            title: Text(conversation.title),
            subtitle: Text(conversation.lastMessage.length > convoCharLimit
                ? conversation.lastMessage.substring(0, convoCharLimit) + '...'
                : conversation.lastMessage)),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))));
  }

  String _buildConversationTitle(List<String> userNames) {
    String title = '';
    userNames.asMap().forEach((index, userName) {
      if (index == userNames.length - 1) {
        title += userName;
      } else {
        title += userName + ', ';
      }
    });
    return title;
  }

  void _openMessageThread(String userAId, String userBId) async {
    try {
      final CollectionReference conversationRef =
          _db.collection('Conversations');
      Query query = conversationRef;
      query = query.where(userAId, isEqualTo: true);
      query = query.where(userBId, isEqualTo: true);
      QuerySnapshot result = await query.snapshots().first;
      if (result.documents.length == 0) {
        getIt<Modal>().showInSnackBar(
            scaffoldKey: _scaffoldKey,
            text: 'Could not find conversation thread.');
      }
      DocumentSnapshot conversationDoc = result.documents.first;
      final String convoId = conversationDoc.documentID;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(userAId, userBId, convoId),
        ),
      );
    } catch (e) {
      getIt<Modal>().showInSnackBar(
        scaffoldKey: _scaffoldKey,
        text: e.toString(),
      );
    }
  }

  // void _openNewMessage() {
  //   if (_currentUser == null) {
  //     return;
  //   }
  //   Navigator.of(context).push(PageRouteBuilder(
  //       pageBuilder: (_, __, ___) => NewMessagePage(_currentUser)));
  // }
}
