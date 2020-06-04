import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import '../../blocs/bookSitterTime/Bloc.dart' as BookSitterTimeBP;

class BookSitterTimePage extends StatefulWidget {
  @override
  State createState() => BookSitterTimePageState();
}

class BookSitterTimePageState extends State<BookSitterTimePage> {
  BookSitterTimePageState();

  // BookSitterCalendarBP.BookSitterCalendarBloc bookSitterCalendarBloc;
  // final DateFormat dateFormat = DateFormat('hh:mm aaa');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // bookSitterCalendarBloc = BlocProvider.of<BookSitterCalendarBP.BookSitterCalendarBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    // bookSitterCalendarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Sitter - Time',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<BookSitterTimeBP.BookSitterTimeBloc,
          BookSitterTimeBP.BookSitterTimeState>(
        listener: (BuildContext context,
            BookSitterTimeBP.BookSitterTimeState state) {},
        builder: (BuildContext context,
            BookSitterTimeBP.BookSitterTimeState state) {
          if (state is BookSitterTimeBP.LoadingState) {
            return Spinner();
          } else if (state is BookSitterTimeBP.LoadedState) {
            return Center(
              child: Text('Text'),
            );
            // return Column(
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: <Widget>[
            //           Text(
            //             'Choose Sitter',
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           DropdownButton<ResourceModel>(
            //             value: state.selectedResource,
            //             onChanged: (ResourceModel newValue) async {
            //               bookSitterTimeBloc.add(
            //                 BookSitterTimeBP.OnResourceSelectedEvent(resource: newValue),
            //               );
            //             },
            //             items: state.resources
            //                 .map<DropdownMenuItem<ResourceModel>>(
            //               (ResourceModel value) {
            //                 return DropdownMenuItem<ResourceModel>(
            //                   value: value,
            //                   child: Text(value.name),
            //                 );
            //               },
            //             ).toList(),
            //           )
            //         ],
            //       ),
            //     ),
            //     TimeWidget(
            //       TimeController: state.TimeController,
            //       events: state.events,
            //       onDaySelected: (DateTime day, List events) {
            //         bookSitterTimeBloc.add(
            //           BookSitterTimeBP.OnDaySelectedEvent(
            //             day: day,
            //             events: events,
            //           ),
            //         );
            //       },
            //       onVisibleDaysChanged:
            //           (DateTime first, DateTime last, TimeFormat format) {
            //         bookSitterTimeBloc.add(
            //           BookSitterTimeBP.OnVisibleDaysChangedEvent(
            //               first: first, last: last, format: format),
            //         );
            //       },
            //     ),
            //     Expanded(
            //       child: Padding(
            //         padding: EdgeInsets.all(20),
            //         child: (state.start != null && state.finish != null)
            //             ? Column(
            //                 children: <Widget>[
            //                   Text(
            //                     'Available from ${dateFormat.format(state.start)} to ${dateFormat.format(state.finish)}',
            //                     style: TextStyle(fontWeight: FontWeight.bold),
            //                   ),
            //                   Spacer(),
            //                   RaisedButton(
            //                     child: Text(
            //                       'Book Appointment for This Day?',
            //                       style: TextStyle(fontWeight: FontWeight.bold),
            //                     ),
            //                     color: Colors.red,
            //                     textColor: Colors.white,
            //                     onPressed: () {
            //                       //todo:
            //                     },
            //                   )
            //                 ],
            //               )
            //             : Center(
            //                 child: Text(
            //                   'No availability this day...',
            //                   style: TextStyle(fontWeight: FontWeight.bold),
            //                 ),
            //               ),
            //       ),
            //     ),
            //   ],
            // );
          } else if (state is BookSitterTimeBP.ErrorState) {
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
