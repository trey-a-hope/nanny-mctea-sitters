import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc.dart';

class BookSitterCalendarBloc
    extends Bloc<BookSitterCalendarEvent, BookSitterCalendarState> {
  @override
  BookSitterCalendarState get initialState => BookSitterCalendarState();

  @override
  Stream<BookSitterCalendarState> mapEventToState(
      BookSitterCalendarEvent event) async* {
    //if event is...
  }
}
