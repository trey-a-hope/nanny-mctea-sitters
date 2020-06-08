// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
// import 'package:nanny_mctea_sitters_flutter/services/DBService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';

// class DeleteAvailabilityTimePage extends StatefulWidget {
//   final List<dynamic> takenSlots;
//   final DateTime selectedDay;
//   final String sitterID;

//   DeleteAvailabilityTimePage(
//       {@required this.takenSlots,
//       @required this.selectedDay,
//       @required this.sitterID});

//   @override
//   State createState() => DeleteAvailabilityTimePageState(
//       this.takenSlots, this.selectedDay, this.sitterID);
// }

// class DeleteAvailabilityTimePageState
//     extends State<DeleteAvailabilityTimePage> {
//   DeleteAvailabilityTimePageState(
//       this._takenSlots, this._selectedDay, this.sitterID);

//   final String timeFormat = 'hh:mm a';
//   final String dateFormat = 'MMM, dd yyyy';
//   final String sitterID;

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final DateTime _selectedDay;
//   final List<dynamic> _takenSlots;
//   List<Slot> _selectedSlots = List<Slot>();
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
//                     ),
//                     title: 'Delete Sitter Hours',
//                     subtitle: 'Select time(s)',
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: _takenSlots.length,
//                     itemBuilder: (BuildContext ctxt, int index) {
//                       return _buildSlot(
//                         _takenSlots[index],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Future<void> deleteAvailability() async {
//     bool confirm = await locator<ModalService>().showConfirmation(
//       context: context,
//       title: 'Delete Availability',
//       message: _slotsToString(),
//     );
//     if (confirm) {
//       for (int i = 0; i < _selectedSlots.length; i++) {
//         await locator<DBService>()
//             .deleteSlot(sitterID: sitterID, slotID: _selectedSlots[i].id);
//       }
//       locator<ModalService>().showAlert(
//           context: context, title: 'Success', message: 'Time removed.');
//       return;
//     }
//   }

//   Container _buildBottomNavigationBar() {
//     return _selectedSlots.isEmpty
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
//               onPressed: deleteAvailability,
//               color: Colors.grey.shade200,
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(
//                       MdiIcons.send,
//                       color: Colors.black,
//                     ),
//                     SizedBox(
//                       width: 4.0,
//                     ),
//                     Text(
//                       'DELETE TIMES',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }

//   String _slotsToString() {
//     String s = '';
//     _selectedSlots.sort(
//       (a, b) => a.time.compareTo(
//         b.time,
//       ),
//     );

//     for (int i = 0; i < _selectedSlots.length; i++) {
//       s += DateFormat(timeFormat).format(_selectedSlots[i].time);
//       if (i < _selectedSlots.length - 1) {
//         s += ', ';
//       }
//     }
//     return s;
//   }

//   _buildAppBar() {
//     return AppBar(
//       title: Text(DateFormat(dateFormat).format(_selectedDay)),
//       centerTitle: true,
//     );
//   }

//   Widget _buildSlot(Slot slot) {
//     return InkWell(
//       child: ListTile(
//         title: Text(
//           DateFormat(timeFormat).format(slot.time),
//         ),
//         leading: CircleAvatar(
//           backgroundColor:
//               _selectedSlots.contains(slot) ? Colors.green : Colors.red,
//           child: _selectedSlots.contains(slot)
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
//             if (_selectedSlots.contains(slot)) {
//               _selectedSlots.remove(slot);
//             } else {
//               _selectedSlots.add(slot);
//             }
//           },
//         );
//       },
//     );
//   }
// }
