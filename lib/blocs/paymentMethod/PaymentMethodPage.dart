import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/paymentMethod/Bloc.dart'
    as PaymentMethodBP;
import 'package:nanny_mctea_sitters_flutter/blocs/addCard/Bloc.dart'
    as AddCardBP;
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CreditCardModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import '../../ServiceLocator.dart';
import 'package:awesome_card/awesome_card.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  State createState() => PaymentMethodPageState();
}

class PaymentMethodPageState extends State<PaymentMethodPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PaymentMethodBP.PaymentMethodBloc paymentMethodBloc;
  @override
  void initState() {
    super.initState();
    paymentMethodBloc =
        BlocProvider.of<PaymentMethodBP.PaymentMethodBloc>(context);
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
        appBar: AppBar(
          title: Text(
            'Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: BlocConsumer<PaymentMethodBP.PaymentMethodBloc,
                PaymentMethodBP.PaymentMethodState>(
              listener: (BuildContext context,
                  PaymentMethodBP.PaymentMethodState state) async {
                if (state is PaymentMethodBP.NavigateToAddCardState) {
                  Route route = MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider(
                      create: (BuildContext context) => AddCardBP.AddCardBloc(
                          currentUser: state.currentUser,
                          customer: state.customer)
                        ..add(AddCardBP.LoadPageEvent()),
                      child: AddCardBP.AddCardPage(),
                    ),
                  );

                  Navigator.push(context, route);
                }
              },
              builder: (BuildContext context,
                  PaymentMethodBP.PaymentMethodState state) {
                if (state is PaymentMethodBP.LoadingState) {
                  return Spinner();
                } else if (state is PaymentMethodBP.InitialState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.customer.sources.length,
                      itemBuilder: (BuildContext context, int index) {
                        CreditCardModel creditCard =
                            state.customer.sources[index];

                        return Column(
                          children: <Widget>[
                            CreditCard(
                              cardNumber: '**** **** **** ${creditCard.last4}',
                              cardExpiry:
                                  '${creditCard.expMonth}/${creditCard.expYear}',
                              cardHolderName: '${creditCard.name}',
                              cvv: '',
                              bankName: '${creditCard.brand}',
                              showBackSide: false,
                              frontBackground: CardBackgrounds.black,
                              backBackground: CardBackgrounds.white,
                              showShadow: true,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    creditCard.id ==
                                            state.customer.defaultSource
                                        ? 'Default Card'
                                        : '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          //Prompt user for deleting card.
                                          bool confirm = await locator<
                                                  ModalService>()
                                              .showConfirmation(
                                                  context: context,
                                                  title:
                                                      'Delete card ending in ${creditCard.last4}.',
                                                  message: 'Are you sure?');
                                          if (confirm) {
                                            //Alert user that process for deleting card has started.
                                            locator<ModalService>()
                                                .showInSnackBar(
                                                    scaffoldKey: scaffoldKey,
                                                    message:
                                                        'Deleting card now.');
                                            //Delete this credit card.
                                            await locator<StripeCardService>()
                                                .delete(
                                                    customerID:
                                                        state.customer.id,
                                                    cardID: creditCard.id);
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      creditCard.id !=
                                              state.customer.defaultSource
                                          ? IconButton(
                                              icon: Icon(Icons.check,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                //Prompt user for updating card.
                                                bool confirm = await locator<
                                                        ModalService>()
                                                    .showConfirmation(
                                                        context: context,
                                                        title:
                                                            'Make card enÎding in ${creditCard.last4} default.',
                                                        message:
                                                            'Are you sure?');
                                                if (confirm) {
                                                  //Make this credit card the default card.
                                                  await locator<
                                                          StripeCustomerService>()
                                                      .update(
                                                          customerID:
                                                              state.customer.id,
                                                          defaultSource:
                                                              creditCard.id);
                                                  setState(() {});
                                                }
                                              },
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
                  );
                } else if (state is PaymentMethodBP.NoCardState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('You have 0 cards.'),
                        RaisedButton(
                          child: Text('Add Card'),
                          onPressed: () {
                            paymentMethodBloc.add(
                              PaymentMethodBP.NavigateToAddCardEvent(),
                            );
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  );
                }

                return Center(
                  child: Text('here'),
                );
                // if (state is UnsubscribedState) {
                //   return buildUnsubscribedView(
                //       goldPlan: state.goldPlan, silverPlan: state.silverPlan);
                // }
                // if (state is SubscribedState) {
                //   return buildSubscribedView(
                //       plan: state.plan, subscription: state.subscription);
                // }
                // if (state is LoadingState) {
                //   return Spinner();
                // }
                // if (state is ErrorState) {
                //   return Center(
                //     child: Text('Error: ${state.error.toString()}'),
                //   );
                // } else {
                //   return Center(
                //     child: Text(
                //       'You should NEVER see this.',
                //     ),
                //   );
                // }
              },
            ),
          ),
        )

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
