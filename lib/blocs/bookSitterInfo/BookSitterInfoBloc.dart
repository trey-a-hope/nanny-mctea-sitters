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

  }
}
