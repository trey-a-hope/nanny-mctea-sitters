import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'package:awesome_card/awesome_card.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  State createState() => PaymentMethodPageState();
}

class PaymentMethodPageState extends State<PaymentMethodPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  showCardActionsDialog() {
    return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  }

  iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Actions'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Make Default'),
                onPressed: () {
                  print('Make default card...');
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Delete'),
                onPressed: () {
                  print('Delete card...');
                  Navigator.pop(context);
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Actions'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Make Default'),
              onPressed: () {
                print('Make default card...');
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('Delete'),
              onPressed: () {
                print('Delete card...');
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(child: Text('here'),)
      
      
      // FutureBuilder(
      //   future: locator<AuthService>().getCurrentUser(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return Spinner(
      //           text: 'Loading...',
      //         );
      //         break;
      //       default:
      //         UserModel currentUser = snapshot.data;

      //         return Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
      //               child: SilentNavbar(
      //                 title: 'Payment Method',
      //                 leftTap: () => {Navigator.of(context).pop()},
      //                 rightTapTitle: 'Add',
      //                 rightTap: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => AddCardPage(),
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ),
      //             //If the customer has no customerID set, that means they are not a customer in Stripe yet.
      //             //Therefore, display no cards.
      //             currentUser.customerID == null
      //                 ? noCardsDisplay()
      //                 :
      //                 //Send another future to fetch the customer info tied to this user.
      //                 FutureBuilder(
      //                     future: locator<StripeCustomerService>()
      //                         .retrieve(customerID: currentUser.customerID),
      //                     builder:
      //                         (BuildContext context, AsyncSnapshot snapshot) {
      //                       switch (snapshot.connectionState) {
      //                         case ConnectionState.waiting:
      //                           return Spinner(
      //                             text: 'Loading...',
      //                           );
      //                           break;
      //                         default:
      //                           CustomerModel customer = snapshot.data;

      //                           if (customer.sources.isEmpty) {
      //                             return noCardsDisplay();
      //                           }

      //                           return Expanded(
      //                             child: ListView.builder(
      //                               itemCount: customer.sources.length,
      //                               itemBuilder:
      //                                   (BuildContext context, int index) {
      //                                 CreditCardModel creditCard =
      //                                     customer.sources[index];

      //                                 return Column(
      //                                   children: <Widget>[
      //                                     CreditCard(
      //                                       cardNumber:
      //                                           '**** **** **** ${creditCard.last4}',
      //                                       cardExpiry:
      //                                           '${creditCard.expMonth}/${creditCard.expYear}',
      //                                       cardHolderName:
      //                                           '${creditCard.name}',
      //                                       cvv: '',
      //                                       bankName: '${creditCard.brand}',
      //                                       showBackSide: false,
      //                                       frontBackground:
      //                                           CardBackgrounds.black,
      //                                       backBackground:
      //                                           CardBackgrounds.white,
      //                                       showShadow: true,
      //                                     ),
      //                                     Padding(
      //                                       padding: EdgeInsets.all(20),
      //                                       child: Row(
      //                                         mainAxisAlignment:
      //                                             MainAxisAlignment
      //                                                 .spaceBetween,
      //                                         children: <Widget>[
      //                                           Text(
      //                                             creditCard.id ==
      //                                                     customer.defaultSource
      //                                                 ? 'Default Card'
      //                                                 : '',
      //                                             style: TextStyle(
      //                                                 fontWeight:
      //                                                     FontWeight.bold),
      //                                           ),
      //                                           Row(
      //                                             children: <Widget>[
      //                                               IconButton(
      //                                                 icon: Icon(Icons.delete,
      //                                                     color: Colors.red),
      //                                                 onPressed: () async {
      //                                                   //Prompt user for deleting card.
      //                                                   bool confirm = await locator<
      //                                                           ModalService>()
      //                                                       .showConfirmation(
      //                                                           context:
      //                                                               context,
      //                                                           title:
      //                                                               'Delete card ending in ${creditCard.last4}.',
      //                                                           message:
      //                                                               'Are you sure?');
      //                                                   if (confirm) {
      //                                                     //Alert user that process for deleting card has started.
      //                                                     locator<ModalService>()
      //                                                         .showInSnackBar(
      //                                                             scaffoldKey:
      //                                                                 scaffoldKey,
      //                                                             message:
      //                                                                 'Deleting card now.');
      //                                                     //Delete this credit card.
      //                                                     await locator<
      //                                                             StripeCardService>()
      //                                                         .delete(
      //                                                             customerID:
      //                                                                 customer
      //                                                                     .id,
      //                                                             cardID:
      //                                                                 creditCard
      //                                                                     .id);
      //                                                     setState(() {});
      //                                                   }
      //                                                 },
      //                                               ),
      //                                               creditCard.id !=
      //                                                       customer
      //                                                           .defaultSource
      //                                                   ? IconButton(
      //                                                       icon: Icon(
      //                                                           Icons.check,
      //                                                           color:
      //                                                               Colors.red),
      //                                                       onPressed:
      //                                                           () async {
      //                                                         //Prompt user for updating card.
      //                                                         bool confirm = await locator<
      //                                                                 ModalService>()
      //                                                             .showConfirmation(
      //                                                                 context:
      //                                                                     context,
      //                                                                 title:
      //                                                                     'Make card ending in ${creditCard.last4} default.',
      //                                                                 message:
      //                                                                     'Are you sure?');
      //                                                         if (confirm) {
      //                                                           //Make this credit card the default card.
      //                                                           await locator<StripeCustomerService>().update(
      //                                                               customerID:
      //                                                                   customer
      //                                                                       .id,
      //                                                               defaultSource:
      //                                                                   creditCard
      //                                                                       .id);
      //                                                           setState(() {});
      //                                                         }
      //                                                       },
      //                                                     )
      //                                                   : SizedBox.shrink()
      //                                             ],
      //                                           )
      //                                         ],
      //                                       ),
      //                                     ),
      //                                     SizedBox(
      //                                       height: 20,
      //                                     )
      //                                   ],
      //                                 );
      //                               },
      //                             ),
      //                           );
      //                       }
      //                     },
      //                   )
      //           ],
      //         );
      //     }
      //   },
      // ),
    );
  }


}
