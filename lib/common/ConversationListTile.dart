import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/firebase/Conversation.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/MessagePage.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../ServiceLocator.dart';

// A list tile that displays information about a user's conversation.
class ConversationListTile extends StatefulWidget {
  const ConversationListTile(
      {Key key, @required this.conversationDoc, @required this.currentUser})
      : super(key: key);
  final DocumentSnapshot conversationDoc;
  final UserModel currentUser;

  @override
  State createState() => ConversationListTileState(
      conversationDoc: conversationDoc, currentUser: currentUser);
}

class ConversationListTileState extends State<ConversationListTile> {
  ConversationListTileState(
      {@required this.conversationDoc, @required this.currentUser});
  final DocumentSnapshot conversationDoc;
  final UserModel currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<ConversationModel> createConversation() async {
    dynamic userIDs = conversationDoc.data['users'];

    //Determine the user you are speaking with.
    UserModel oppositeUser = currentUser.id == userIDs[0]
        ? await locator<UserService>().retrieveUser(id: userIDs[1])
        : await locator<UserService>().retrieveUser(id: userIDs[0]);

    //Create conversation item.
    return ConversationModel(
      title: oppositeUser.name,
      lastMessage: conversationDoc.data['lastMessage'],
      imageUrl: oppositeUser.imgUrl,
      sender: ChatUser(
          uid: currentUser.id,
          name: currentUser.name,
          avatar: currentUser.imgUrl,
          fcmToken: currentUser.fcmToken),
      sendee: ChatUser(
          uid: oppositeUser.id,
          name: oppositeUser.name,
          avatar: oppositeUser.imgUrl,
          fcmToken: oppositeUser.fcmToken),
      reference: conversationDoc.reference,
      time: conversationDoc.data['time'].toDate(),
      read: conversationDoc['${currentUser.id}_read'],
      oppositeUser: oppositeUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createConversation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Spinner();
            break;
          default:
            ConversationModel conversation = snapshot.data;

            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagePage(
                          sendee: conversation.sendee,
                          sender: conversation.sender,
                          convoDocRef: conversation.reference,
                        ),
                      ),
                    );

                    // Route route = MaterialPageRoute(
                    //   builder: (BuildContext context) => BlocProvider(
                    //     create: (BuildContext context) => MessageBloc(
                    //       sendee: conversation.sendee,
                    //       sender: conversation.sender,
                    //       convoDocRef: conversation.reference,
                    //     )..add(LoadPageEvent()),
                    //     child: MessagePage(),
                    //   ),
                    // );

                    // Navigator.push(
                    //   context,
                    //   route,
                    // );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    backgroundImage: NetworkImage(conversation.imageUrl),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          conversation.read
                              ? Container()
                              : Icon(
                                  MdiIcons.circle,
                                  size: 10,
                                  color: Colors.lightBlue,
                                ),
                          conversation.read
                              ? Container()
                              : SizedBox(
                                  width: 10,
                                ),
                          Text(
                            conversation.title,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: conversation.read
                                    ? FontWeight.normal
                                    : FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${conversation.lastMessage == '' ? '\"No Last Message\"' : conversation.lastMessage}',
                        maxLines: 1,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        timeago.format(
                          conversation.time,
                        ),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Divider()
              ],
            );
        }
      },
    );
  }
}
