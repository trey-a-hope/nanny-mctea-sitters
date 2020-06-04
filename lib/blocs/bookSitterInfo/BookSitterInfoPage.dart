import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/DateTimePicker.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import '../../blocs/bookSitterInfo/Bloc.dart' as BookSitterInfoBP;

class BookSitterInfoPage extends StatefulWidget {
  @override
  State createState() => BookSitterInfoPageState();
}

class BookSitterInfoPageState extends State<BookSitterInfoPage> {
  BookSitterInfoPageState();

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
      body: BlocConsumer<BookSitterInfoBP.BookSitterInfoBloc,
          BookSitterInfoBP.BookSitterInfoState>(
        listener: (BuildContext context,
            BookSitterInfoBP.BookSitterInfoState state) {},
        builder:
            (BuildContext context, BookSitterInfoBP.BookSitterInfoState state) {
          if (state is BookSitterInfoBP.LoadingState) {
            return Spinner();
          } else if (state is BookSitterInfoBP.LoadedState) {
            return Center(
              child: DateTimePicker(
                selectedTime: TimeOfDay.now(),
                selectedDate: DateTime.now(),
                selectTime: (time) => {},
                selectDate: (date) => {},
                labelText: 'New Days',
              ),
            );
          } else if (state is BookSitterInfoBP.ErrorState) {
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
