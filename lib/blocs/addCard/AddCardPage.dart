import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/addCard/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import '../../ServiceLocator.dart';

class AddCardPage extends StatefulWidget {
  @override
  State createState() => AddCardPageState();
}

class AddCardPageState extends State<AddCardPage>
    implements AddCardBlocDelegate {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AddCardBloc addCardBloc;
  @override
  void initState() {
    super.initState();

    addCardBloc = BlocProvider.of<AddCardBloc>(context);
    addCardBloc.setDelegate(delegate: this);
  }

  void showTestInfo() {
    locator<ModalService>().showAlert(
        context: context,
        title: 'Test Card Info',
        message:
            'Type \'4242424242424242\' for the Card Number, then choose a Expired Date after today, and choose any CVV of your choice.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      // floatingActionButton: SpeedDial(
      //   // both default to 16
      //   marginRight: 18,
      //   marginBottom: 20,
      //   animatedIcon: AnimatedIcons.menu_close,
      //   animatedIconTheme: IconThemeData(size: 22.0),
      //   closeManually: false,
      //   curve: Curves.bounceIn,
      //   overlayColor: Colors.black,
      //   overlayOpacity: 0.5,
      //   onOpen: () => print('OPENING DIAL'),
      //   onClose: () => print('DIAL CLOSED'),
      //   tooltip: 'Speed Dial',
      //   heroTag: 'speed-dial-hero-tag',
      //   backgroundColor: Colors.red,
      //   foregroundColor: Colors.white,
      //   elevation: 8.0,
      //   shape: CircleBorder(),
      //   children: [
      //     SpeedDialChild(
      //         child: Icon(Icons.check),
      //         backgroundColor: Colors.blue,
      //         label: 'Save Card',
      //         labelStyle: TextStyle(fontSize: 18.0),
      //         onTap: save),
      //     SpeedDialChild(
      //       child: Icon(Icons.credit_card),
      //       backgroundColor: Colors.green,
      //       label: 'Show Test Card Info',
      //       labelStyle: TextStyle(fontSize: 18.0),
      //       onTap: showTestInfo,
      //     ),
      //   ],
      // ),

      body: BlocConsumer<AddCardBloc, AddCardState>(
        listener: (BuildContext context, AddCardState state) {
          if (state is ErrorState) {
            locator<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: state.error.toString(),
            );
          }
        },
        builder: (BuildContext context, AddCardState state) {
          if (state is LoadingState) {
            return Spinner();
          } else if (state is InitialState) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardWidget(
                    cardNumber: state.cardNumber,
                    expiryDate: state.expiryDate,
                    cardHolderName: state.cardHolderName,
                    cvvCode: state.cvvCode,
                    showBackView: state.isCvvFocused,
                  ),
                  CreditCardForm(
                    onCreditCardModelChange: (CreditCardModel creditCardModel) {
                      addCardBloc.add(OnCreditCardModelChangeEvent(
                          creditCardModel: creditCardModel));
                    },
                  ),
                  RaisedButton(
                    child: Text('Save Card'),
                    onPressed: () async {
                      addCardBloc.add(OpenConfirmSaveCardModalEvent());
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                  )
                ],
              ),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          } else {
            return Center(
              child: Text('You should NEVER see this.'),
            );
          }
        },
      ),
    );
  }

  @override
  void openConfirmSaveCardModal() async {
    //Prompt user about saving this card.
    bool confirm = await locator<ModalService>().showConfirmation(
        context: context, title: 'Save Card', message: 'Are you sure?');

    if (confirm) addCardBloc.add(SubmitCardEvent());
  }

  @override
  void openErrorModal({@required String message}) {
    locator<ModalService>().showAlert(
      context: context,
      title: 'Error',
      message: message,
    );
  }
}

// void onCreditCardModelChange(CreditCardModel creditCardModel) {
//   cardNumber = creditCardModel.cardNumber;
//   expiryDate = creditCardModel.expiryDate;
//   cardHolderName = creditCardModel.cardHolderName;
//   cvvCode = creditCardModel.cvvCode;
//   isCvvFocused = creditCardModel.isCvvFocused;
// }
