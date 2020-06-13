import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeTokenService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class AddCardBlocDelegate {
  void openConfirmSaveCardModal();
  void openErrorModal({@required String message});
  void successModal();
}

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  final UserModel currentUser;
  final CustomerModel customer;

  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;

  AddCardBlocDelegate delegate;

  AddCardBloc({
    @required this.currentUser,
    @required this.customer,
  });

  @override
  AddCardState get initialState => InitialState(
        cardNumber: _cardNumber,
        expiryDate: _expiryDate,
        cardHolderName: _cardHolderName,
        cvvCode: _cvvCode,
        isCvvFocused: _isCvvFocused,
      );

  void setDelegate({@required AddCardBlocDelegate delegate}) {
    this.delegate = delegate;
  }

  bool formValid() {
    bool cardNumberValid = _cardNumber.replaceAll(' ', '').length == 16;
    bool expirationDateValid = _expiryDate.length == 5;
    bool cvvValid = _cvvCode.length == 3;
    bool cardHolderNameValid = _cardHolderName.length > 0;

    return cardNumberValid &&
        expirationDateValid &&
        cvvValid &&
        cardHolderNameValid;
  }

  @override
  Stream<AddCardState> mapEventToState(AddCardEvent event) async* {
    if (event is OnCreditCardModelChangeEvent) {
      _cardNumber = event.creditCardModel.cardNumber;
      _expiryDate = event.creditCardModel.expiryDate;
      _cardHolderName = event.creditCardModel.cardHolderName;
      _cvvCode = event.creditCardModel.cvvCode;
      _isCvvFocused = event.creditCardModel.isCvvFocused;

      yield InitialState(
        cardNumber: _cardNumber,
        expiryDate: _expiryDate,
        cardHolderName: _cardHolderName,
        cvvCode: _cvvCode,
        isCvvFocused: _isCvvFocused,
      );
    }

    if (event is SubmitCardEvent) {
      if (formValid()) {
        yield LoadingState();

        try {
          //If user does not have a customerID, create stripe account first.
          if (currentUser.customerID == null) {
            currentUser.customerID = await locator<StripeCustomerService>()
                .create(
                    email: currentUser.email,
                    description: 'Account for $_cardHolderName',
                    name: _cardHolderName);

            //Update customerID for this user in firestore.
            locator<UserService>().updateUser(
                userID: currentUser.id,
                data: {'customerID': currentUser.customerID});
          }

          //Strip fields of white spaces and extra characters.
          final String cardNumberValue = _cardNumber.replaceAll(' ', '');
          final String expMonthValue = _expiryDate.substring(0, 2);
          final String expYearValue =
              _expiryDate.substring(3, 5); //Account for / in form.
          final String cvcValue = _cvvCode;

          //Proceed to creating token from form data.
          final String token = await locator<StripeTokenService>().create(
              number: cardNumberValue,
              expMonth: expMonthValue,
              expYear: expYearValue,
              cvc: cvcValue,
              name: _cardHolderName);

          //Finally, create a card for this customer.
          locator<StripeCardService>()
              .create(customerID: currentUser.customerID, token: token);

          //Show success message.
          delegate.successModal();

          //Keep original state.
          yield InitialState(
            cardNumber: _cardNumber,
            expiryDate: _expiryDate,
            cardHolderName: _cardHolderName,
            cvvCode: _cvvCode,
            isCvvFocused: _isCvvFocused,
          );
        } catch (error) {
          //Open error modal.
          delegate.openErrorModal(message: error.toString());

          //Keep original state.
          yield InitialState(
            cardNumber: _cardNumber,
            expiryDate: _expiryDate,
            cardHolderName: _cardHolderName,
            cvvCode: _cvvCode,
            isCvvFocused: _isCvvFocused,
          );
        }
      }
    }
  }
}
