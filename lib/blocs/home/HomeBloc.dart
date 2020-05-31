import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'Bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<UserModel> _sitters;
  UserModel _currentUser;

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
      locator<UserService>()
          .updateUser(userID: _currentUser.id, data: {'fcmToken': fcmToken});
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

      try {
        //Fetch sitters.
        _sitters = await locator<UserService>().retrieveUsers(isSitter: true);

        //Fetch user.
        _currentUser = await locator<AuthService>().getCurrentUser();

        //If user is logged in, setup firebase messaging.
        if (_currentUser != null) {
          _setUpFirebaseMessaging();
        }

        yield LoadedState(sitters: _sitters);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
