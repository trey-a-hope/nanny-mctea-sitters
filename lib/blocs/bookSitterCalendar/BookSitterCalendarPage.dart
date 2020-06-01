import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/calendar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Bloc.dart';

class BookSitterCalendarPage extends StatefulWidget {
  @override
  State createState() => BookSitterCalendarPageState();
}

class BookSitterCalendarPageState extends State<BookSitterCalendarPage> {
  BookSitterCalendarPageState();
  BookSitterCalendarBloc bookSitterCalendarBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // String _sitterOption;
  // List<UserModel> _sitters = List<UserModel>();
  // List<String> _sitterOptions;
  // Map<DateTime, List<dynamic>> _events = Map<DateTime, List<dynamic>>();

  @override
  void initState() {
    super.initState();

    bookSitterCalendarBloc = BlocProvider.of<BookSitterCalendarBloc>(context);
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  // _getAvailability({@required bool all}) async {
  //   _sitterSlotMap.clear();
  //   if (all) {
  //     //Iterate through each sitter and look for their availability, (slots).
  //     for (var i = 0; i < _sitters.length; i++) {
  //       List<Slot> slots = await locator<DBService>()
  //           .getSlots(sitterID: _sitters[i].id, taken: false);
  //       _sitterSlotMap[_sitters[i]] = slots;
  //     }
  //   } else {
  //     //Find specific sitter and look for their availability, (slots).
  //     UserModel filteredSitter =
  //         _sitters.where((sitter) => sitter.name == _sitterOption).first;
  //     List<Slot> slots = await locator<DBService>()
  //         .getSlots(sitterID: filteredSitter.id, taken: false);
  //     _sitterSlotMap[filteredSitter] = slots;
  //   }
  // }

  // void _setCalendar() {
  //   final _selectedDay = DateTime.now();
  //   _events.clear();

  //   //Iterate through all slots on each sitter.
  //   _sitterSlotMap.forEach(
  //     (sitter, slots) {
  //       //Iterate through each slot and add to 'events' map.
  //       slots.forEach(
  //         (slot) {
  //           DateTime dayKey =
  //               DateTime(slot.time.year, slot.time.month, slot.time.day);

  //           if (_events.containsKey(dayKey)) {
  //             //Add time slot to day if it's hasn't been added already.
  //             if (!_events[dayKey].contains(slot)) {
  //               _events[dayKey].add(slot);
  //             }
  //           }
  //           //Set first time slot to day.
  //           else {
  //             _events[dayKey] = [slot];
  //           }
  //         },
  //       );
  //     },
  //   );

  //   _avialableSlots = _events[_selectedDay] ?? [];
  // }

  void _onDaySelected(DateTime day, List events) {
    // setState(
    //   () {
    //     _avialableSlots = events;
    //   },
    // );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Book Sitter - Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<BookSitterCalendarBloc, BookSitterCalendarState>(
          listener: (BuildContext context, BookSitterCalendarState state) {},
          builder: (BuildContext context, BookSitterCalendarState state) {
            if (state is LoadingState) {
              return Spinner();
            } else if (state is LoadedState) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Choose Sitter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<ResourceModel>(
                          value: state.selectedResource,
                          onChanged: (ResourceModel newValue) async {
                            bookSitterCalendarBloc.add(
                              OnResourceSelectedEvent(resource: newValue),
                            );
                          },
                          items: state.resources
                              .map<DropdownMenuItem<ResourceModel>>(
                            (ResourceModel value) {
                              return DropdownMenuItem<ResourceModel>(
                                value: value,
                                child: Text(value.name),
                              );
                            },
                          ).toList(),
                        )
                      ],
                    ),
                  ),
                  Calendar(
                    calendarController: state.calendarController,
                    events: state.events,
                    onDaySelected: (DateTime day, List events) {
                      bookSitterCalendarBloc.add(
                        OnDaySelectedEvent(
                          day: day,
                          events: events,
                        ),
                      );
                    },
                    onVisibleDaysChanged: (DateTime first, DateTime last,
                        CalendarFormat format) {},
                    // onDaySelected: _onDaySelected,
                    // onVisibleDaysChanged: _onVisibleDaysChanged,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.availableSlots.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('$index'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            bookSitterCalendarBloc.add(
                              OnSlotSelectedEvent(
                                slot: state.availableSlots[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            } else if (state is ErrorState) {
              return Center(
                child: Text('Error: ${state.error.toString()}'),
              );
            } else {
              return Center(
                child: Text('You should NEVER see this.'),
              );
            }
          },
        )

        // body: _isLoading
        //     ? Spinner()
        //     : SingleChildScrollView(
        //         child: Column(
        //           mainAxisSize: MainAxisSize.max,
        //           children: <Widget>[
        //             ScaffoldClipper(
        //               simpleNavbar: SimpleNavbar(
        //                 leftWidget:
        //                     Icon(MdiIcons.chevronLeft, color: Colors.white),
        //                 leftTap: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 rightWidget: Icon(Icons.refresh, color: Colors.white),
        //                 rightTap: () async {
        //                   await _getSlotsAndCaledar();
        //                 },
        //               ),
        //               title: 'Book Sitter',
        //               subtitle: 'Select a date.',
        //             ),
        //             SizedBox(height: 20),
        //             Padding(
        //               padding: EdgeInsets.all(16),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   Text(
        //                     appointment.service,
        //                     textAlign: TextAlign.center,
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.bold, fontSize: 20),
        //                   ),
        //                   Text('Pick a sitter from the drop down.'),
        //                   SizedBox(height: 20),
        //                   _buildSitterDropDown(),
        //                 ],
        //               ),
        //             ),
        //             Calendar(
        //                 calendarController: _calendarController,
        //                 events: _events,
        //                 onDaySelected: _onDaySelected,
        //                 onVisibleDaysChanged: _onVisibleDaysChanged),
        //           ],
        //         ),
        //       ),

        // bottomNavigationBar: _buildBottomNavigationBar(),
        );
  }

  // Container _buildBottomNavigationBar() {
  //   return (_avialableSlots == null || _avialableSlots.isEmpty)
  //       ? Container(
  //           width: MediaQuery.of(context).size.width,
  //           height: 50.0,
  //           child: RaisedButton(
  //             onPressed: () {},
  //             color: Colors.grey.shade200,
  //             child: Center(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Icon(
  //                     MdiIcons.close,
  //                     color: Colors.red,
  //                   ),
  //                   SizedBox(
  //                     width: 4.0,
  //                   ),
  //                   Text(
  //                     'NO AVAILABILITY',
  //                     style: TextStyle(color: Colors.red),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       : Container(
  //           width: MediaQuery.of(context).size.width,
  //           height: 50.0,
  //           child: RaisedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => BookSitterTimePage(
  //                     slots: _avialableSlots,
  //                     sitterSlotMap: _sitterSlotMap,
  //                     appointment: appointment,
  //                   ),
  //                 ),
  //               );
  //             },
  //             color: Colors.grey.shade200,
  //             child: Center(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Icon(
  //                     MdiIcons.clock,
  //                     color: Colors.black,
  //                   ),
  //                   SizedBox(
  //                     width: 4.0,
  //                   ),
  //                   Text(
  //                     'PICK A TIME',
  //                     style: TextStyle(color: Colors.black),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  // }

  // DropdownButton _buildSitterDropDown() {
  //   return DropdownButton<String>(
  //     value: _sitterOption,
  //     onChanged: (String newValue) async {
  //       setState(
  //         () async {
  //           _sitterOption = newValue;
  //           await _getSlotsAndCaledar();
  //         },
  //       );
  //     },
  //     items: _sitterOptions.map<DropdownMenuItem<String>>(
  //       (String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value),
  //         );
  //       },
  //     ).toList(),
  //   );
  // }

  // _getSlotsAndCaledar() async {
  //   if (_sitterOption == 'All Staff') {
  //     await _getAvailability(all: true);
  //     setState(
  //       () {
  //         _setCalendar();
  //       },
  //     );
  //   } else {
  //     await _getAvailability(all: false);
  //     setState(
  //       () {
  //         _setCalendar();
  //       },
  //     );
  //   }
  // }
}
