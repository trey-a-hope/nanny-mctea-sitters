import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.id,
      this.name,
      this.imageUrl,
      this.text,
      this.timestamp,
      this.userId,
      this.myUserId,
      this.animationController});

  final String id;
  final String name;
  final String imageUrl;
  final String text;
  final String timestamp;
  final String userId;
  final String myUserId;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.purple,
                backgroundImage: NetworkImage(imageUrl),
                child: GestureDetector(
                  onTap: () {
                    if (userId != myUserId) {
                      // Navigator.of(context).push( PageRouteBuilder( pageBuilder: (_, __, ___) => ProfilePage(userId)) );
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name + ' @ ' + timestamp,
                      style: TextStyle(color: Colors.grey)),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
