import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {

  StreamSubscription subscription;
  UserModel currentUser;

  @override
  ConversationState get initialState => LoadingState(text: 'Loading...');

  @override
  Stream<ConversationState> mapEventToState(ConversationEvent event) async* {
    //Load page data for initial view.
    if (event is LoadPageEvent) {
      //Display spinner.
      yield LoadingState(text: 'Loading...');

      //Fetch current user.
      currentUser = await locator<AuthService>().getCurrentUser();

      //Query conversations table.
      Query query = Firestore.instance.collection('Conversations');

      //Filter on user ID.
      query = query.where(currentUser.id, isEqualTo: true);

      //Order conversations by time.
      // query = query.orderBy('time', descending: true);

      //Check to see if conversations are empty.
      if ((await query.getDocuments()).documents.isEmpty) {
        yield NoConversationsState(currentUser: currentUser);
      } else {
        Stream<QuerySnapshot> snapshots = query.snapshots();

        subscription = snapshots.listen((querySnapshot) {
          add(ConversationAddedEvent(querySnapshot: querySnapshot));
        });
      }
    }

    if (event is ConversationAddedEvent) {
      yield LoadedState(
          querySnapshot: event.querySnapshot, currentUser: currentUser);
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
