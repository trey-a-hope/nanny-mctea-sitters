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

class BookSitterCalendarPageState extends State<BookSitterCalendarPage> {
  BookSitterCalendarPageState();
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
      body: BlocConsumer<BookSitterCalendarBP.BookSitterCalendarBloc,
          BookSitterCalendarBP.BookSitterCalendarState>(
        listener: (BuildContext context,
            BookSitterCalendarBP.BookSitterCalendarState state) {},
        builder: (BuildContext context,
            BookSitterCalendarBP.BookSitterCalendarState state) {
          if (state is BookSitterCalendarBP.LoadingState) {
            return Spinner();
          } else if (state is BookSitterCalendarBP.LoadedState) {
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
                                  //todo: Create date from time and date.
                                  DateTime finalDate = DateTime.now();

                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      create: (BuildContext context) =>
                                          BookSitterInfoBP.BookSitterInfoBloc(
                                        selectedDate: finalDate,
                                      )..add(
                                              BookSitterInfoBP.LoadPageEvent(),
                                            ),
                                      child:
                                          BookSitterInfoBP.BookSitterInfoPage(),
                                    ),
                                  );

                                  Navigator.push(context, route);
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
          } else if (state is BookSitterCalendarBP.ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          } else {
            return Center(
              child: Text('You should NEVER see this.'),
            );
          }
        },
      ),
    );
  }
}
