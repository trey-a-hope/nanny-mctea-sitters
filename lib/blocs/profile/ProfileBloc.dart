import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';

import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc();

  UserModel _currentUser;
  List<AppointmentModel> _appointments;

  @override
  ProfileState get initialState => ProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //Load current user.
        _currentUser = await locator<AuthService>().getCurrentUser();

        //Load appointments.
        _appointments = []; //todo:

        yield LoadedState(
            currentUser: _currentUser, appointments: _appointments);
      } catch (error) {
        //Display error page.
        yield ErrorState(error: error);
      }

      // try {
      //   //Fetch current user;
      //   currentUser = await locator<AuthService>().getCurrentUser();

      //   if (currentUser.customerID != null) {
      //     //Get customer id from customer.
      //     final String customerID = currentUser.customerID;

      //     //Retrieve all charges for this account.
      //     List<ChargeModel> charges =
      //         await locator<StripeChargeService>().list(customerID: customerID);

      //     charges.add(
      //       ChargeModel(
      //         id: '',
      //         created: DateTime.now(),
      //         amount: 20.0,
      //         description: 'Description.'
      //       ),
      //     );

      //     //Display empty list if no charges .
      //     if (charges.isEmpty) {
      //       yield EmptyChargesState();
      //     } else {
      //       //Display empty list if no charges since the user has not added a card yet (currentUser.customerID == null)
      //       yield LoadedState(charges: charges);
      //     }
      //   } else {
      //     yield EmptyChargesState();
      //   }
      // } catch (error) {
      //   yield ErrorState(error: error);
      // }
    }
  }
}
