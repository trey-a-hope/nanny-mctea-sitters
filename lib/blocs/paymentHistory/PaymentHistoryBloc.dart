import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeChargeService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc();

  UserModel currentUser;
  CustomerModel customer;

  @override
  PaymentHistoryState get initialState => PaymentHistoryState();

  @override
  Stream<PaymentHistoryState> mapEventToState(
      PaymentHistoryEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //Fetch current user;
        currentUser = await locator<AuthService>().getCurrentUser();

        if (currentUser.customerID != null) {
          //Get customer id from customer.
          final String customerID = currentUser.customerID;

          //Retrieve all charges for this account.
          List<ChargeModel> charges =
              await locator<StripeChargeService>().list(customerID: customerID);

          charges.add(
            ChargeModel(
              id: '',
              created: DateTime.now(),
              amount: 20.0,
              description: 'Description.'
            ),
          );

          //Display empty list if no charges .
          if (charges.isEmpty) {
            yield EmptyChargesState();
          } else {
            //Display empty list if no charges since the user has not added a card yet (currentUser.customerID == null)
            yield LoadedState(charges: charges);
          }
        } else {
          yield EmptyChargesState();
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
