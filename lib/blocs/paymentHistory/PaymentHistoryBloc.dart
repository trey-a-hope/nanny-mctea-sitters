import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';

import 'Bloc.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc();

  UserModel currentUser;
  CustomerModel customer;

  @override
  PaymentHistoryState get initialState => InitialState();

  @override
  Stream<PaymentHistoryState> mapEventToState(
      PaymentHistoryEvent event) async* {
    // if (event is LoadPageEvent) {
    //   yield LoadingState();

    //   //Fetch current user;
    //   currentUser = await locator<AuthService>().getCurrentUser();

    //   if (currentUser.customerID != null) {
    //     //Fetch customer info.
    //     customer = await locator<StripeCustomerService>()
    //         .retrieve(customerID: currentUser.customerID);

    //     yield InitialState();
    //   } else {
    //     yield NoCardState();
    //   }
    // }

    // if (event is NavigateToAddCardEvent) {
    //   yield NavigateToAddCardState();
    //   yield NoCardState();
    // }
  }
}
