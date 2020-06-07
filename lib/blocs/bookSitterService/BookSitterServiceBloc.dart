import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

class BookSitterServiceBloc
    extends Bloc<BookSitterServiceEvent, BookSitterServiceState> {
  @override
  BookSitterServiceState get initialState => ChildCareServiceState();

  @override
  Stream<BookSitterServiceState> mapEventToState(
      BookSitterServiceEvent event) async* {
    if (event is NavigateToBookSitterCalendarEvent) {
      yield NavigateToBookSitterCalendarState(
        hours: event.hours,
        service: event.service,
        cost: event.cost,
      );
      //Keep this page in a default state after navigating away.
      yield ChildCareServiceState();
    }

    if (event is ToggleEvent) {
      switch (event.tab) {
        case 0:
          yield ChildCareServiceState();
          break;
        case 1:
          yield FeesRegistrationState();
          break;
        case 2:
          yield MonthlySitterMembershipState();
          break;
        default:
          break;
      }
    }
  }
}
