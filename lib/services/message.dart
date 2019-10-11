import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/chat_message.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/message_page.dart';

abstract class Message {
  void openMessageThread(
      {@required BuildContext context,
      @required User sender,
      @required User sendee,
      @required String title});
  Future<void> createChatMessage(
      {@required CollectionReference messageRef,
      @required String messageId,
      @required String text,
      @required String imageUrl,
      @required String userName,
      @required String userId});
  bool isNewMessage(
      {@required ChatMessage chatMessage,
      @required List<ChatMessage> messages});
}

class MessageImplementation extends Message {
  final CollectionReference _conversationsDB =
      Firestore.instance.collection('Conversations');

  void openMessageThread(
      {@required BuildContext context,
      @required User sender,
      @required User sendee,
      @required String title}) async {
    try {
      //Return conversation documents that have both user ids set to true.
      Query query = _conversationsDB;
      query = query.where(sender.id, isEqualTo: true);
      query = query.where(sendee.id, isEqualTo: true);
      //Grab first and only document.
      QuerySnapshot result = await query.snapshots().first;
      //If convo exits, change from null to the id. Otherwise, keep it null.
      String conversationId;
      if (result.documents.isNotEmpty) {
        DocumentSnapshot conversationDoc = result.documents.first;
        conversationId = conversationDoc.documentID;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(
              sender: sender,
              sendee: sendee,
              conversationId: conversationId,
              title: title),
        ),
      );
    } catch (e) {
      throw Exception('Could not open thread.');
    }
  }

  Future<void> createChatMessage(
      {@required CollectionReference messageRef,
      @required String messageId,
      @required String text,
      @required String imageUrl,
      @required String userName,
      @required String userId}) async {
    var data = {
      'text': text,
      'imageUrl': imageUrl,
      'name': userName,
      'userId': userId,
      'time': DateTime.now()
    };

    return await messageRef.document(messageId).setData(data);
  }

  bool isNewMessage(
      {@required ChatMessage chatMessage,
      @required List<ChatMessage> messages}) {
    for (ChatMessage m in messages) {
      if (m.id == chatMessage.id) {
        return false;
      }
    }
    return true;
  }
}
