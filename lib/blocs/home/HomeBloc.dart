import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/DBService.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';

import 'Bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<User> _sitters;
  User currentUser;

  @override
  HomeState get initialState => HomeState();

  //Request notification permissions and register call backs for receiving push notifications.
  void _setUpFirebaseMessaging() async {
    //Request permission on iOS device.
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    //Update user's fcm token.
    final String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      locator<DBService>()
          .updateUser(userID: currentUser.id, data: {'fcmToken': fcmToken});
    }

    //Configure notifications for several action types.
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //todo: Create delegate method for opening modals.
        // locator<Modal>().showAlert(
        //     context: context,
        //     title: message['notification']['title'],
        //     message: message['notification']['body']);
        //  _showItemDialog(message);
      },
      //  onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      //Fetch sitters.
      _sitters = await locator<DBService>().getSitters();

      //Setup firebase messaging.
      currentUser = await locator<AuthService>().getCurrentUser();
      if (currentUser != null) {
        _setUpFirebaseMessaging();
      }

      //Fetch page data.
      yield LoadedState(sitters: _sitters);
    }
  }
}
