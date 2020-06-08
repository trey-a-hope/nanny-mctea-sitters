import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  AddCardBloc({
    @required this.currentUser,
    @required this.customer,
  });

  final UserModel currentUser;
  final CustomerModel customer;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  AddCardState get initialState => InitialState(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        isCvvFocused: isCvvFocused,
      );

  @override
  Stream<AddCardState> mapEventToState(AddCardEvent event) async* {
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
    //     // yield NoCardState();
    //   }
    // }

    if (event is OnCreditCardModelChangeEvent) {
      cardNumber = event.creditCardModel.cardNumber;
      expiryDate = event.creditCardModel.expiryDate;
      cardHolderName = event.creditCardModel.cardHolderName;
      cvvCode = event.creditCardModel.cvvCode;
      isCvvFocused = event.creditCardModel.isCvvFocused;

      yield InitialState(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        isCvvFocused: isCvvFocused,
      );
    }

    if (event is AddCardEvent) {
      // //If user does not have a customerID, create stripe account first.
      // if (currentUser.customerID == null) {
      //   currentUser.customerID = await locator<StripeCustomerService>().create(
      //       email: currentUser.email,
      //       description: 'Account for $cardHolderName',
      //       name: cardHolderName);

      //   //Update customerID for this user in firestore.
      //   locator<UsersDBService>().updateUser(
      //       userID: currentUser.id,
      //       data: {'customerID': currentUser.customerID});
      // }

      // //Strip fields of white spaces and extra characters.
      // final String cardNumberValue = cardNumber.replaceAll(' ', '');
      // final String expMonthValue = expiryDate.substring(0, 2);
      // final String expYearValue =
      //     expiryDate.substring(3, 5); //Account for / in form.
      // final String cvcValue = cvvCode;

      // //Proceed to creating token from form data.
      // final String token = await locator<StripeTokenService>().create(
      //     number: cardNumberValue,
      //     expMonth: expMonthValue,
      //     expYear: expYearValue,
      //     cvc: cvcValue,
      //     name: cardHolderName);

      // //Finally, create a card for this customer.
      // locator<StripeCardService>()
      //     .create(customerID: currentUser.customerID, token: token);

      // //Alert user of success.
      // locator<ModalService>().showInSnackBar(
      //     scaffoldKey: scaffoldKey, message: 'Card added successfully!');
    }
  }

  bool formValid() {
    bool cardNumberValid = cardNumber.replaceAll(' ', '').length == 16;
    bool expirationDateValid = expiryDate.length == 5;
    bool cvvValid = cvvCode.length == 3;
    bool cardHolderNameValid = cardHolderName.length > 0;

    return cardNumberValid &&
        expirationDateValid &&
        cvvValid &&
        cardHolderNameValid;
  }
}
