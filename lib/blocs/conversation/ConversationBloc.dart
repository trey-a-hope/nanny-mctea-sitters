import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/StorageService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:timeago/timeago.dart';
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

    if (event is UpdatePhotoEvent) {
      //Pick an image.
      File file = await ImagePicker.pickImage(source: event.imageSource);

      //Check that user picked an image.
      if (file == null) return;

      //Crop an image.
      File image = await ImageCropper.cropImage(sourcePath: file.path);

      //Check that user cropped the image.
      if (image == null) return;

      // //Display spinner.
      // yield LoadingState(text: 'Loading...');

      //Get image upload url.
      final String newImgUrl = await locator<StorageService>().uploadImage(
          file: image, path: 'Images/Users/${currentUser.id}/Profile');

      //Save image upload url.
      await locator<UserService>()
          .updateUser(userID: currentUser.id, data: {'imgUrl': newImgUrl});

      //Update image url on user.
      currentUser.imgUrl = newImgUrl;

      add(LoadPageEvent()); //Relaod page.
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
