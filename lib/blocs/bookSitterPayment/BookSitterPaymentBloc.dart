import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class BookSitterPaymentBloc
    extends Bloc<BookSitterPaymentEvent, BookSitterPaymentState> {
  BookSitterPaymentBloc({
    @required this.selectedDate,
    @required this.service,
    @required this.hours,
    @required this.cost,
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    @required this.street,
    @required this.aptNo,
    @required this.city,
  });

  final DateTime selectedDate;
  final String service;
  final int hours;
  final double cost;
  final String name;
  final String email;
  final String phoneNumber;
  final String street;
  final String aptNo;
  final String city;

  UserModel currentUser;
  CustomerModel customer;

  @override
  BookSitterPaymentState get initialState => BookSitterPaymentState();

  @override
  Stream<BookSitterPaymentState> mapEventToState(
      BookSitterPaymentEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      //Fetch current user;
      currentUser = await locator<AuthService>().getCurrentUser();

      if (currentUser.customerID != null) {
        //Fetch customer info.
        customer = await locator<StripeCustomerService>()
            .retrieve(customerID: currentUser.customerID);

        yield InitialState(
          selectedDate: selectedDate,
          service: service,
          hours: hours,
          cost: cost,
          aptNo: aptNo,
          city: city,
          email: email,
          street: street,
          phoneNumber: phoneNumber,
          name: name,
        );
      } else {
        yield NoCardState();
      }
    }

    if (event is NavigateToAddCardEvent) {
      yield NavigateToAddCardState();
      yield NoCardState();
    }

    if (event is SubmitPaymentEvent) {
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
}
