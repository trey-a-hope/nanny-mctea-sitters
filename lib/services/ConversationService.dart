import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IConversationsService {
  Stream<QuerySnapshot> streamConversations({@required String userID});
  Stream<QuerySnapshot> streamMessages(
      {@required DocumentReference convoDocRef});

  void cancelConversationSubscription();
  void cancelMessagesSubscription();
}
//DELETE THIS CLASS ONCE BLOCS ARE IN PLACE.
class ConversationsService extends IConversationsService {
  final CollectionReference conversationsDB =
      Firestore.instance.collection('Conversations');

  StreamSubscription<QuerySnapshot> conversationStreamSubscription;
  StreamSubscription<QuerySnapshot> messagesStreamSubscription;

  @override
  Stream<QuerySnapshot> streamConversations({String userID}) {
    Query query = conversationsDB;

    //Filter on user ID.
    query = query.where(userID, isEqualTo: true);

    //Order conversations by time.
    query = query.orderBy('time', descending: true);

    query.getDocuments();

    Stream<QuerySnapshot> snapshots = query.snapshots();

    //Get subscription from stream to use for later.
    //conversationStreamSubscription = snapshots.listen((data) {});

    return snapshots;

  }

  @override
  void cancelConversationSubscription() {
    if (conversationStreamSubscription != null) {
      conversationStreamSubscription.cancel();
    }
  }

  @override
  Stream<QuerySnapshot> streamMessages({DocumentReference convoDocRef}) {
    Stream<QuerySnapshot> snapshots =
        convoDocRef.collection('Messages').snapshots();

    messagesStreamSubscription = snapshots.listen((data) {});

    return snapshots;
  }

  @override
  void cancelMessagesSubscription() {
    if (messagesStreamSubscription != null) {
      messagesStreamSubscription.cancel();
    }
  }
}
