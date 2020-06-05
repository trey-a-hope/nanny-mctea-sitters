import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

class BookSitterInfoBloc
    extends Bloc<BookSitterInfoEvent, BookSitterInfoState> {
  BookSitterInfoBloc({
    @required this.selectedDate,
  });

  final DateTime selectedDate;

  @override
  BookSitterInfoState get initialState => LoadedState(
        selectedDate: selectedDate,
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );

  @override
  Stream<BookSitterInfoState> mapEventToState(
      BookSitterInfoEvent event) async* {
    if (event is ValidateFormEvent) {
      //If form is valid, navigate to the payment page.
      if (event.formKey.currentState.validate()) {
        yield NavigateToPaymentPageState();
      }
      yield LoadedState(
        autoValidate: true,
        selectedDate: selectedDate,
        formKey: event.formKey,
      );
    }

    //todo: This will go in the final screen after collecting payment.
    // locator<SuperSaaSAppointmentService>().create(
    //   scheduleID: 489593,
    //   userID: currentUser.id,
    //   email: currentUser.email,
    //   fullName: '${currentUser.name}',
    //   start: DateTime.now(),
    //   finish: DateTime.now().add(
    //     Duration(hours: 2),
    //   ),
    // );
  }
}
