// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
// import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/MessageService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';

// class SitterDetailsPage extends StatefulWidget {
//   final UserModel _sitter;

//   SitterDetailsPage(this._sitter);

//   @override
//   State createState() => SitterDetailsPageState(this._sitter);
// }

// class SitterDetailsPageState extends State<SitterDetailsPage> {
//   SitterDetailsPageState(this._sitter);

//   final UserModel _sitter;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final String dateFormat = 'MMM d, yyyy';
//   final String timeFormat = 'hh:mm a';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();

//     _load();
//   }

//   _load() async {
//     setState(
//       () {
//         _isLoading = false;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: _isLoading
//           ? Spinner()
//           : SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   ScaffoldClipper(
//                     simpleNavbar: SimpleNavbar(
//                       leftWidget:
//                           Icon(MdiIcons.chevronLeft, color: Colors.white),
//                       leftTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       rightWidget: Icon(Icons.message, color: Colors.white),
//                       rightTap: () async {
//                         UserModel currentUser =
//                             await locator<AuthService>().getCurrentUser();
//                         if (currentUser == null) {
//                           locator<ModalService>().showAlert(
//                               context: context,
//                               title: 'Sorry',
//                               message:
//                                   'You must be logged in to use this feature.');
//                         } else {
//                           //todo: Open message thread.
//                           // locator<MessageService>().openMessageThread(
//                           //     context: context,
//                           //     sendee: _sitter,
//                           //     sender: currentUser,
//                           //     title: _sitter.name);
//                         }
//                       },
//                     ),
//                     title: _sitter.name,
//                     subtitle: _sitter.email,
//                   ),
//                   Stack(
//                     children: <Widget>[
//                       SizedBox(
//                         height: 400,
//                         width: double.infinity,
//                         child: CachedNetworkImage(
//                             fit: BoxFit.contain,
//                             fadeInCurve: Curves.easeIn,
//                             imageUrl: _sitter.imgUrl),
//                       ),
//                       Container(
//                         margin: EdgeInsets.fromLTRB(16.0, 320.0, 16.0, 16.0),
//                         child: Column(
//                           children: <Widget>[
//                             // _buildInfoBox(),
//                             SizedBox(height: 20.0),
//                             _buildBio(),
//                             SizedBox(height: 20.0),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // _buildInfoBox() {
//   //   return Stack(
//   //     children: <Widget>[
//   //       Container(
//   //         padding: EdgeInsets.all(16.0),
//   //         margin: EdgeInsets.only(top: 20.0),
//   //         decoration: BoxDecoration(
//   //           color: Colors.white,
//   //           borderRadius: BorderRadius.circular(5.0),
//   //         ),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: <Widget>[
//   //             Container(
//   //               margin: EdgeInsets.only(left: 120.0),
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: <Widget>[
//   //                   Text(_sitter.name,
//   //                       style: TextStyle(
//   //                           fontSize: 25, fontWeight: FontWeight.bold)),
//   //                   ListTile(
//   //                     contentPadding: EdgeInsets.all(0),
//   //                     title: Text(
//   //                       _sitter.details,
//   //                       style: TextStyle(fontSize: 20),
//   //                     ),
//   //                     // subtitle: Text(_gem.subCategory),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //             SizedBox(height: 10.0),
//   //           ],
//   //         ),
//   //       ),
//   //       Container(
//   //         height: 100,
//   //         width: 100,
//   //         decoration: BoxDecoration(
//   //           border: Border.all(width: 2.0, color: Colors.black),
//   //           borderRadius: BorderRadius.circular(10.0),
//   //           image: DecorationImage(
//   //               image: CachedNetworkImageProvider(_sitter.imgUrl),
//   //               fit: BoxFit.cover),
//   //         ),
//   //         margin: EdgeInsets.only(left: 16.0),
//   //       ),
//   //     ],
//   //   );
//   // }

//   _buildBio() {
//     return Card(
//       elevation: 4,
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               'Bio',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Divider(),
//           Padding(
//             padding: EdgeInsets.all(15),
//             child: Text(_sitter.bio),
//           )
//         ],
//       ),
//     );
//   }

//   // AppBar _buildAppBar() {
//   //   return AppBar(
//   //     title: Text('Sitter Details'),
//   //     centerTitle: true,
//   //     actions: <Widget>[
//   //       IconButton(
//   //         icon: Icon(Icons.message),
//   //         onPressed: () async {
//   //           User currentUser = await getIt<Auth>().getCurrentUser();
//   //           if (currentUser == null) {
//   //             getIt<Modal>().showAlert(
//   //                 context: context,
//   //                 title: 'Sorry',
//   //                 message: 'You must be logged in to use this feature.');
//   //           } else {
//   //             getIt<Message>().openMessageThread(
//   //                 context: context,
//   //                 sendee: currentUser,
//   //                 sender: _sitter,
//   //                 title: _sitter.name);
//   //           }
//   //         },
//   //       )
//   //     ],
//   //   );
//   // }
// }
