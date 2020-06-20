import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

abstract class BookSitterInfoBlocDelegate {
  void navigateToPaymentPage({
    @required DateTime selectedDate,
    @required String service,
    @required int hours,
    @required double cost,
    @required String aptNo,
    @required String street,
    @required String city,
    @required String name,
    @required String email,
    @required String phoneNumber,
    @required String resourceID,
  });
}

class BookSitterInfoBloc
    extends Bloc<BookSitterInfoEvent, BookSitterInfoState> {
  BookSitterInfoBloc({
    @required this.selectedDate,
    @required this.service,
    @required this.hours,
    @required this.cost,
    @required this.resourceID,
  });

  final DateTime selectedDate; //Selected date and time of the appointment.
  final String service; //Title of the service provided.
  final int hours; //Number of hours of the appointment.
  final double cost; //Cost of the appointment.
  final String resourceID; //ID of the sitter for the appointment.

  BookSitterInfoBlocDelegate _delegate;

  void setDelegate({@required BookSitterInfoBlocDelegate delegate}) {
    this._delegate = delegate;
  }

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
        _delegate.navigateToPaymentPage(
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
          resourceID: resourceID,
        );
      }

      //Start auto validation on this form.
      yield LoadedState(
        autoValidate: true,
        selectedDate: selectedDate,
        formKey: event.formKey,
      );
    }
  }
}
