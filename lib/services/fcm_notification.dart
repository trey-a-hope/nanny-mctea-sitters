// import 'dart:async';
// import 'dart:convert' show Encoding, json;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
// final String _contentType = 'application/json';
// final String _authorization =
//     'key=AAAA7hZrUAE:APA91bG5Rfqtmc5mKUxw4Ugsj0b7spk4iFGYdRcvAeaZ_rEJzeuifsyApW1PIfUU1nUO9Fdim7T0qASnq-fdpw4dZGPsrmO4iWdEs41a4FqXsQf5KJkdvyvI7WSRD3ysLad9G6Yk68Fi';

// class NotificationService {
//   static Future<http.Response> _sendNotification(
//       String to, String title, String body) async {
//     final dynamic data = json.encode(
//       {
//         'to': to,
//         'priority': 'high',
//         'notification': {'title': title, 'body': body},
//         'content_available': true
//       },
//     );
//     return http.post(
//       _endpoint,
//       body: data,
//       headers: {'Content-Type': _contentType, 'Authorization': _authorization},
//     );
//   }

//   // static Future<void> unsubscribeFromTopic(String topic) {
//   //   return _firebaseMessaging.subscribeToTopic(topic);
//   // }

//   // static Future<void> subscribeToTopic(String topic) {
//   //   return _firebaseMessaging.subscribeToTopic(topic);
//   // }

//   static Future<void> sendNotificationToUser(
//       {@required String fcmToken,
//       @required String title,
//       @required String body}) {
//     return _sendNotification(fcmToken, title, body);
//   }

//   static Future<void> sendNotificationToGroup(
//       String group, String title, String body) {
//     return _sendNotification('/topics/' + group, title, body);
//   }
// }

import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class IFCMNotificationService {
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body});
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body});
  Future<void> unsubscribeFromTopic({@required String topic});
  Future<void> subscribeToTopic({@required String topic});
}

class FCMNotificationService extends IFCMNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAA7hZrUAE:APA91bG5Rfqtmc5mKUxw4Ugsj0b7spk4iFGYdRcvAeaZ_rEJzeuifsyApW1PIfUU1nUO9Fdim7T0qASnq-fdpw4dZGPsrmO4iWdEs41a4FqXsQf5KJkdvyvI7WSRD3ysLad9G6Yk68Fi';

  Future<http.Response> _sendNotification(
      String to, String title, String body) async {
    final dynamic data = json.encode(
      {
        'to': to,
        'priority': 'high',
        'notification': {'title': title, 'body': body},
        'content_available': true
      },
    );
    return http.post(
      _endpoint,
      body: data,
      headers: {'Content-Type': _contentType, 'Authorization': _authorization},
    );
  }

  @override
  Future<void> unsubscribeFromTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> subscribeToTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body}) {
    return _sendNotification(fcmToken, title, body);
  }

  @override
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body}) {
    return _sendNotification('/topics/' + group, title, body);
  }
}
