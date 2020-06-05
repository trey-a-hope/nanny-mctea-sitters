// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_sitter.dart';

// class BookSitterTimePage extends StatefulWidget {
//   final List<dynamic> slots;
//   final Map<UserModel, List<Slot>> sitterSlotMap;
//   final Appointment appointment;

//   BookSitterTimePage(
//       {@required this.slots,
//       @required this.sitterSlotMap,
//       @required this.appointment});

//   @override
//   State createState() => BookSitterTimePageState(
//       slots: this.slots,
//       sitterSlotMap: this.sitterSlotMap,
//       appointment: this.appointment);
// }

// class BookSitterTimePageState extends State<BookSitterTimePage> {
//   BookSitterTimePageState(
//       {@required this.slots,
//       @required this.sitterSlotMap,
//       @required this.appointment});

//   final List<dynamic> slots;
//   final Map<UserModel, List<Slot>> sitterSlotMap;
//   final Appointment appointment;
//   final String timeFormat = 'hh:mm a';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isLoading = true;
//   Slot _selectedSlot;

//   @override
//   void initState() {
//     super.initState();

//     _load();
//   }

//   _load() async {
//     //Sort slots.
//     slots.sort(
//       (a, b) => a.time.compareTo(
//         b.time,
//       ),
//     );

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
//                     ),
//                     title: 'Book Sitter',
//                     subtitle: 'Select a time.',
//                   ),
//                   ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: slots.length,
//                     itemBuilder: (BuildContext ctxt, int index) {
//                       //Ensure times do not duplicate visually.
//                       if (index == 0) {
//                         return _buildSlot(
//                           slots[index],
//                         );
//                       } else if (slots[index - 1].time != slots[index].time) {
//                         return _buildSlot(
//                           slots[index],
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Container _buildBottomNavigationBar() {
//     return _selectedSlot == null
//         ? Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50.0,
//             child: RaisedButton(
//               onPressed: () {},
//               color: Colors.grey.shade200,
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(
//                       MdiIcons.close,
//                       color: Colors.red,
//                     ),
//                     SizedBox(
//                       width: 4.0,
//                     ),
//                     Text(
//                       'NO TIME SELECTED',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         : Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50.0,
//             child: RaisedButton(
//               onPressed: () {
//                 List<UserModel> availableSitters = List<UserModel>();

//                 //Pick sitters for the slot selected.
//                 sitterSlotMap.forEach(
//                   (sitter, slots) {
//                     slots.forEach(
//                       (slot) {
//                         if (_selectedSlot.time == slot.time) {
//                           //Ensure sitters arent duplicated on next page.
//                           if (!availableSitters.contains(sitter)) {
//                             availableSitters.add(sitter);
//                           }
//                         }
//                       },
//                     );
//                   },
//                 );

//                 //Attach slot to order.
//                 appointment.slot = _selectedSlot;

//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => BookSitterSitterPage(
//                 //         availableSitters: availableSitters,
//                 //         appointment: appointment),
//                 //   ),
//                 // );
//               },
//               color: Colors.grey.shade200,
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(
//                       MdiIcons.faceAgent,
//                       color: Colors.black,
//                     ),
//                     SizedBox(
//                       width: 4.0,
//                     ),
//                     Text(
//                       'PICK A SITTER',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }

//   Widget _buildSlot(Slot slot) {
//     return InkWell(
//       child: ListTile(
//         title: Text(
//           DateFormat(timeFormat).format(slot.time),
//         ),
//         leading: CircleAvatar(
//           backgroundColor: _selectedSlot == slot ? Colors.green : Colors.red,
//           child: _selectedSlot == slot
//               ? Icon(
//                   Icons.check,
//                   color: Colors.white,
//                 )
//               : Icon(Icons.close, color: Colors.white),
//         ),
//       ),
//       onTap: () {
//         setState(
//           () {
//             _selectedSlot = slot;
//           },
//         );
//       },
//     );
//   }
// }
