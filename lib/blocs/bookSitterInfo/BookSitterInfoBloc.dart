import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

class BookSitterInfoBloc
    extends Bloc<BookSitterInfoEvent, BookSitterInfoState> {
  BookSitterInfoBloc({
    @required this.selectedDate,
    @required this.service,
    @required this.hours,
    @required this.cost,
  });

  final DateTime selectedDate;
  final String service;
  final int hours;
  final double cost;

  @override
  BookSitterInfoState get initialState => LoadedState(
        selectedDate: selectedDate,
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );

  @override
  Stream<BookSitterInfoState> mapEventToState(
      BookSitterInfoEvent event) async* {
    if (event is NavigateToPaymentPageEvent) {
      //If form is valid, navigate to the payment page.
      if (event.formKey.currentState.validate()) {
        yield NavigateToPaymentPageState(
          selectedDate: selectedDate,
          service: service,
          hours: hours,
          cost: cost,
          aptNo: event.aptNo,
          street: event.street,
          city: event.city,
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
        );
      }
      yield LoadedState(
        autoValidate: true,
        selectedDate: selectedDate,
        formKey: event.formKey,
      );
    }
  }
}
