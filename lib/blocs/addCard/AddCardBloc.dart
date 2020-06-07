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

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  AddCardBloc();

  UserModel currentUser;
  CustomerModel customer;

  @override
  AddCardState get initialState => AddCardState();

  @override
  Stream<AddCardState> mapEventToState(AddCardEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      //Fetch current user;
      currentUser = await locator<AuthService>().getCurrentUser();

      if (currentUser.customerID != null) {
        //Fetch customer info.
        customer = await locator<StripeCustomerService>()
            .retrieve(customerID: currentUser.customerID);

        yield InitialState();
      } else {
        // yield NoCardState();
      }
    }

  }
}
