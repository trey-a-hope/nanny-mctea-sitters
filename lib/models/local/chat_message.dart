// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// //PROBABLY WONT NEED THESE WITH UPDATED CHAT FLOW
// class ChatMessage extends StatelessWidget {
//   ChatMessage(
//       {this.id,
//       this.name,
//       this.imageUrl,
//       this.text,
//       this.time,
//       this.userID,
//       this.myUserID,
//       this.animationController});

//   final String id;
//   final String name;
//   final String imageUrl;
//   final String text;
//   final DateTime time;
//   final String userID;
//   final String myUserID;
//   final AnimationController animationController;

//   final String timeFormat = 'MMM d, yyyy @ h:mm a';

//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor:
//           CurvedAnimation(parent: animationController, curve: Curves.easeOut),
//       axisAlignment: 0.0,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               margin: const EdgeInsets.only(right: 16.0),
//               child: CircleAvatar(
//                 backgroundColor: Colors.purple,
//                 backgroundImage: NetworkImage(imageUrl),
//                 child: GestureDetector(
//                   onTap: () {
//                     if (userID != myUserID) {
//                       // Navigator.of(context).push( PageRouteBuilder( pageBuilder: (_, __, ___) => ProfilePage(userID)) );
//                     }
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     name + ' - ' + DateFormat(timeFormat).format(time),
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 5.0),
//                     child: Text(text),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
