import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeChargeService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class BookSitterPaymentBlocDelegate {
  void showMessage({@required String message});
  void navigateToAddCardPage({
    @required UserModel currentUser,
    @required CustomerModel customer,
  });
}

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
    @required this.resourceID,
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
  final String resourceID;

  BookSitterPaymentBlocDelegate _delegate;
  UserModel _currentUser;
  CustomerModel _customer;

  void setDelegate({@required BookSitterPaymentBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  @override
  BookSitterPaymentState get initialState => BookSitterPaymentState();

  @override
  Stream<BookSitterPaymentState> mapEventToState(
      BookSitterPaymentEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      //Fetch current user;
      _currentUser = await locator<AuthService>().getCurrentUser();

      if (_currentUser.customerID != null) {
        //Fetch customer info.
        _customer = await locator<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);

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
      _delegate.navigateToAddCardPage(
        currentUser: _currentUser,
        customer: _customer,
      );
    }

    if (event is SubmitPaymentEvent) {
      yield LoadingState();

      try {
        //Charge users card.
        locator<StripeChargeService>().create(
          amount: cost.toInt(),
          description: service,
          customerID: _customer.id,
        );

        //Create appointment.
        locator<SuperSaaSAppointmentService>().create(
          resourceID: resourceID,
          userID: _currentUser.id,
          email: _currentUser.email,
          fullName: '${_currentUser.name}',
          start: selectedDate,
          finish: selectedDate.add(
            Duration(hours: hours),
          ),
          address: '$street $city',
          phone: '$phoneNumber',
        );

        //Display success state if both methods succeed.
        yield SuccessState();
      } catch (error) {
        //Display error state.
        yield ErrorState(error: error);
      }
    }
  }
}
