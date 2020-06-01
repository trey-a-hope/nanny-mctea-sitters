import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/common/CalendarWidget.dart';
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
  final DateFormat dateFormat = DateFormat('hh:mm aaa');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bookSitterCalendarBloc = BlocProvider.of<BookSitterCalendarBloc>(context);
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
                CalendarWidget(
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
                  onVisibleDaysChanged:
                      (DateTime first, DateTime last, CalendarFormat format) {
                    bookSitterCalendarBloc.add(
                      OnVisibleDaysChangedEvent(
                          first: first, last: last, format: format),
                    );
                  },
                  // onDaySelected: _onDaySelected,
                  // onVisibleDaysChanged: _onVisibleDaysChanged,
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
                              Spacer(),
                              RaisedButton(
                                child: Text(
                                  'Book Appointment for This Day?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: () {
                                  //todo:
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
      ),
    );
  }
}
