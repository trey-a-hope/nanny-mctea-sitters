// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/constants.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
// import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
// import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
// import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

// import '../asset_images.dart';

// class PlansPricingPage extends StatefulWidget {
//   @override
//   State createState() => PlansPricingState();
// }

// class PlansPricingState extends State<PlansPricingPage> {
//   bool _isLoading = true;
//   final GetIt getIt = GetIt.I;
//   CustomerModel _customer;
//   User _currentUser;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   _load() async {
//     try {
//       _currentUser = await getIt<Auth>().getCurrentUser();
//       _customer = await getIt<StripeCustomer>()
//           .retrieve(customerID: _currentUser.customerID);

//       setState(
//         () {
//           _isLoading = false;
//         },
//       );
//     } catch (e) {
//       setState(
//         () {
//           _isLoading = false;
//         },
//       );
//       getIt<Modal>().showAlert(
//         context: context,
//         title: 'Error',
//         message: e.toString(),
//       );
//     }
//   }

//   void _startSubscription() async {
//     if (_customer.isSubscribed) {
//       getIt<Modal>().showAlert(
//           context: context,
//           title: 'Error',
//           message: 'You are already apart of the subscription.');
//       return;
//     }

//     bool confirm = await getIt<Modal>().showConfirmation(
//         context: context,
//         title: 'Start Subscription',
//         text:
//             'You will start your monthly plan today, and will be billed every month for \$100. Continue with plan?');
//     if (confirm) {
//       try {
//         setState(
//           () {
//             _isLoading = true;
//           },
//         );

//         String subscriptionID = await getIt<StripeSubscription>().create(
//             customerID: _currentUser.customerID, plan: STRIPE_GOLD_PLAN_ID);
//         print(subscriptionID);

//         setState(() {
//           _isLoading = false;
//         });

//         getIt<Modal>().showAlert(
//             context: context,
//             title: 'Success',
//             message: 'Your subscription has started.');
//       } catch (e) {
//         setState(
//           () {
//             _isLoading = false;
//           },
//         );

//         getIt<Modal>().showAlert(
//           context: context,
//           title: 'Error',
//           message: e.toString(),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

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
//                     ),
//                     title: 'Plans & Pricing',
//                     subtitle: 'Get a membership.',
//                   ),
//                   Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           'Choose Your Pricing Plan',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           'Sitter Membership',
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           '\$100',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 80,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           'Every month',
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           'Get your life back, enjoy your secured sitter.',
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       ),
//                       RaisedButton(
//                         color: Theme.of(context).buttonColor,
//                         child: Text(
//                           'SELECT'
//                         ),
//                         onPressed: () {
//                           _startSubscription();
//                         },
//                       ),
//                       Divider(color: Colors.black),
//                       Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           '*Unlimited week night sits after 5 pm',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           '*Unlimited weekend sits',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           '*Sitter must be given 32 hours before sit begins',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           '*You are required to pay your sitter the \$13 hourly rate',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );

//     // Stack(
//     //   alignment: Alignment.center,
//     //   children: <Widget>[
//     //     Container(
//     //       decoration: BoxDecoration(
//     //           image: DecorationImage(
//     //               image: asImgFloorCrayons,
//     //               fit: BoxFit.cover,
//     //               alignment: Alignment.center)),
//     //     ),
//     //     Container(
//     //       decoration: BoxDecoration(
//     //         gradient: LinearGradient(
//     //             colors: [
//     //               Colors.white.withOpacity(0.7),
//     //               Colors.white.withOpacity(1)
//     //             ],
//     //             begin: Alignment.topLeft,
//     //             end: Alignment.bottomRight,
//     //             stops: [0, 1]),
//     //       ),
//     //     ),
//     //     Center(
//     //       child: Container(
//     //         height: 520,
//     //         width: screenWidth * 0.9,
//     //         decoration: BoxDecoration(
//     //           border: Border.all(
//     //               color: Colors.white, width: 2.0, style: BorderStyle.solid),
//     //           boxShadow: [
//     //             BoxShadow(
//     //                 color: Colors.grey,
//     //                 offset: Offset(0.0, 2.0),
//     //                 blurRadius: 4.0,
//     //                 spreadRadius: 4.0)
//     //           ],
//     //           gradient: LinearGradient(
//     //             colors: [Colors.grey.shade800, Colors.grey.shade500],
//     //             begin: Alignment.topCenter,
//     //             end: Alignment.bottomCenter,
//     //             stops: [0, 1],
//     //           ),
//     //           borderRadius: BorderRadius.all(
//     //             Radius.circular(8),
//     //           ),
//     //         ),
//     //         child: Column(
//     //           children: <Widget>[
//     //             Padding(
//     //               padding: EdgeInsets.all(10),
//     //               child: Text(
//     //                 'Choose Your Pricing Plan',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 25,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             ),
//     //             Divider(
//     //               color: Colors.white,
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(10),
//     //               child: Text(
//     //                 'Sitter Membership',
//     //                 style: TextStyle(color: Colors.white, fontSize: 20),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(10),
//     //               child: Text(
//     //                 '\$100',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 80,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(10),
//     //               child: Text(
//     //                 'Every month',
//     //                 style: TextStyle(color: Colors.white, fontSize: 20),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(10),
//     //               child: Text(
//     //                 'Get your life back, enjoy your secured sitter.',
//     //                 style: TextStyle(color: Colors.white, fontSize: 15),
//     //               ),
//     //             ),
//     //             MaterialButton(
//     //               color: Colors.white,
//     //               child: Text('SELECT'),
//     //               onPressed: () {
//     //                 _startSubscription();
//     //               },
//     //             ),
//     //             Divider(color: Colors.white),
//     //             Padding(
//     //               padding: EdgeInsets.all(5),
//     //               child: Text(
//     //                 '*Unlimited week night sits after 5 pm',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 12,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(5),
//     //               child: Text(
//     //                 '*Unlimited weekend sits',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 12,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(5),
//     //               child: Text(
//     //                 '*Sitter must be given 32 hours before sit begins',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 12,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: EdgeInsets.all(5),
//     //               child: Text(
//     //                 '*You are required to pay your sitter the \$13 hourly rate',
//     //                 style: TextStyle(
//     //                     color: Colors.white,
//     //                     fontSize: 12,
//     //                     fontWeight: FontWeight.bold),
//     //               ),
//     //             )
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // ),
//     // );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text('PLANS & PRICING'),
//       centerTitle: true,
//     );
//   }
// }
