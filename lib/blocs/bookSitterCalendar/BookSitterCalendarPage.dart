import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/common/CalendarWidget.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../blocs/bookSitterCalendar/Bloc.dart' as BookSitterCalendarBP;
import '../../blocs/bookSitterInfo/Bloc.dart' as BookSitterInfoBP;

class BookSitterCalendarPage extends StatefulWidget {
  @override
  State createState() => BookSitterCalendarPageState();
}

class BookSitterCalendarPageState extends State<BookSitterCalendarPage>
    implements BookSitterCalendarBP.BookSitterCalendarBlocDelegate {
  BookSitterCalendarBP.BookSitterCalendarBloc bookSitterCalendarBloc;
  final DateFormat dateFormat = DateFormat('hh:mm aaa');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bookSitterCalendarBloc =
        BlocProvider.of<BookSitterCalendarBP.BookSitterCalendarBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    bookSitterCalendarBloc.close();
    super.dispose();
  }

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
      body: BlocBuilder<BookSitterCalendarBP.BookSitterCalendarBloc,
          BookSitterCalendarBP.BookSitterCalendarState>(
        builder: (BuildContext context,
            BookSitterCalendarBP.BookSitterCalendarState state) {
          if (state is BookSitterCalendarBP.LoadingState) {
            return Spinner();
          }

          if (state is BookSitterCalendarBP.LoadedState) {
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
                            BookSitterCalendarBP.OnResourceSelectedEvent(
                                resource: newValue),
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
                CalendarWidget(
                  calendarController: state.calendarController,
                  events: state.events,
                  onDaySelected: (DateTime day, List events) {
                    bookSitterCalendarBloc.add(
                      BookSitterCalendarBP.OnDaySelectedEvent(
                        day: day,
                        events: events,
                      ),
                    );
                  },
                  onVisibleDaysChanged:
                      (DateTime first, DateTime last, CalendarFormat format) {
                    bookSitterCalendarBloc.add(
                      BookSitterCalendarBP.OnVisibleDaysChangedEvent(
                          first: first, last: last, format: format),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: (state.start != null && state.finish != null)
                        ? Column(
                            children: <Widget>[
                              Text(
                                'Available from ${dateFormat.format(state.start)} to ${dateFormat.format(state.finish)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  bookSitterCalendarBloc.add(
                                    BookSitterCalendarBP.OnTimeSelectEvent(
                                        context: context),
                                  );
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Select Time',
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(state.selectTime.format(context)),
                                      Icon(Icons.arrow_drop_down,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.grey.shade700
                                              : Colors.white70),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text(
                                  'Book Appointment for This Day?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: () {
                                  //Create date time object from DateTime and TimeOfDay variables.
                                  DateTime selectedDay = state.selectedDay;
                                  TimeOfDay selectedTime = state.selectTime;

                                  DateTime selectedDate = DateTime(
                                    selectedDay.year,
                                    selectedDay.month,
                                    selectedDay.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                    0,
                                  );

                                  bookSitterCalendarBloc.add(
                                    BookSitterCalendarBP
                                        .NavigateToBookSitterInfoPageEvent(
                                            selectedDate: selectedDate),
                                  );

                                  // Route route = MaterialPageRoute(
                                  //   builder: (BuildContext context) =>
                                  //       BlocProvider(
                                  //     create: (BuildContext context) =>
                                  //         BookSitterInfoBP.BookSitterInfoBloc(
                                  //       selectedDate: finalDate,
                                  //     ),
                                  //     child:
                                  //         BookSitterInfoBP.BookSitterInfoPage(),
                                  //   ),
                                  // );

                                  // Navigator.push(context, route);
                                },
                              )
                            ],
                          )
                        : Center(
                            child: Text(
                              'No availability this day...',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ),
              ],
            );
          }

          if (state is BookSitterCalendarBP.ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          }
          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void navigateToBookSitterInfoPageEvent(
      {DateTime selectedDate,
      double cost,
      int hours,
      String service,
      String resourceID}) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) => BookSitterInfoBP.BookSitterInfoBloc(
          selectedDate: selectedDate,
          hours: hours,
          cost: cost,
          service: service,
          resourceID: resourceID,
        ),
        child: BookSitterInfoBP.BookSitterInfoPage(),
      ),
    );
    Navigator.of(context).push(route);
  }
}
