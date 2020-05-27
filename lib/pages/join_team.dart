// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/common/job_posting_widget.dart';
// import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/constants.dart';

// class JoinTeamPage extends StatefulWidget {
//   @override
//   State createState() => JoinTeamPageState();
// }

// class JoinTeamPageState extends State<JoinTeamPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             ScaffoldClipper(
//               simpleNavbar: SimpleNavbar(
//                 leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
//                 leftTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               title: 'Jobs',
//               subtitle: 'Join the team.',
//             ),
//             SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Row(
//                   children: <Widget>[
//                     RaisedButton(
//                       child: Text('FULL TIME'),
//                       onPressed: () {
//                         setState(
//                           () {
//                             selectedIndex = 0;
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             JobPostingWidget(
//               title: JP_FULL_TIME.title,
//               description: JP_FULL_TIME.description,
//               posted: JP_FULL_TIME.posted,
//               imgUrl: JP_FULL_TIME.imgUrl,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
