import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import '../../ServiceLocator.dart';
import '../../blocs/bookSitterPayment/Bloc.dart' as BookSitterPaymentBP;
import '../../blocs/addCard/Bloc.dart' as ADD_CARD_BP;

class BookSitterPaymentPage extends StatefulWidget {
  @override
  State createState() => BookSitterPaymentPageState();
}

class BookSitterPaymentPageState extends State<BookSitterPaymentPage>
    implements BookSitterPaymentBP.BookSitterPaymentBlocDelegate {
  BookSitterPaymentBP.BookSitterPaymentBloc bookSitterPaymentBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //Assign instance of bloc and set delegate.
    bookSitterPaymentBloc =
        BlocProvider.of<BookSitterPaymentBP.BookSitterPaymentBloc>(context);
    bookSitterPaymentBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    bookSitterPaymentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Sitter - Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              bookSitterPaymentBloc.add(
                BookSitterPaymentBP.LoadPageEvent(),
              );
            },
          )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<BookSitterPaymentBP.BookSitterPaymentBloc,
          BookSitterPaymentBP.BookSitterPaymentState>(
        builder: (BuildContext context,
            BookSitterPaymentBP.BookSitterPaymentState state) {
          if (state is BookSitterPaymentBP.LoadingState) {
            return Spinner();
          }

          if (state is BookSitterPaymentBP.InitialState) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(''),
                        ),
                        title: Text(state.service),
                        subtitle: Text(
                            'Sitter: Talea Chenault \nTime: Wednesday, June 1st 2020 @ 8:00am'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Details',
                      style: Theme.of(context).primaryTextTheme.title),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('5 Patrick Street, Trotwood'),
                          Divider(),
                          Text(
                            'Phone',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '9372705527',
                            maxLines: 5,
                          ),
                          // Divider(),
                          // Text(
                          //   'Message',
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // Text(
                          //   '${appointment.message}',
                          //   maxLines: 5,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Payment Method',
                      style: Theme.of(context).primaryTextTheme.title),
                  SizedBox(
                    height: 20,
                  ),
                  // _customer.card == null
                  //     ? Card(
                  //         elevation: 3,
                  //         child: ListTile(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => PaymentMethodPage(),
                  //               ),
                  //             );
                  //           },
                  //           leading: Icon(Icons.not_interested,
                  //               color:
                  //                   Theme.of(context).primaryIconTheme.color),
                  //           title: Text('Currently no card on file.'),
                  //           subtitle: Text('Add one now?'),
                  //           trailing: Icon(Icons.chevron_right),
                  //         ),
                  //       )
                  //     : Card(
                  //         elevation: 3,
                  //         child: ListTile(
                  //           leading: Icon(Icons.confirmation_number,
                  //               color:
                  //                   Theme.of(context).primaryIconTheme.color),
                  //           title: Text(
                  //               '${_customer.card.brand} / ****-****-****-${_customer.card.last4}'),
                  //           subtitle: Text('Expires ' +
                  //               MONTHS[_customer.card.expMonth] +
                  //               ' ' +
                  //               '${_customer.card.expYear}'),
                  //         ),
                  //       ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total (Deposit)',
                          style: Theme.of(context).primaryTextTheme.title),
                      Text(
                        '\$25.00',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Rest of payment will be due upon completion of service.'),
                  Spacer(),
                  RaisedButton(
                    child: Text(
                      'Submit Payment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      bookSitterPaymentBloc
                          .add(BookSitterPaymentBP.SubmitPaymentEvent());
                    },
                  )
                ],
              ),
            );
          }

          if (state is BookSitterPaymentBP.NoCardState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No card found for this user.'),
                  RaisedButton(
                    child: Text('Add card now?'),
                    onPressed: () {
                      bookSitterPaymentBloc
                          .add(BookSitterPaymentBP.NavigateToAddCardEvent());
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                  )
                ],
              ),
            );
          }

          if (state is BookSitterPaymentBP.SuccessState) {
            return Center(
              child: Text(
                'Success',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            );
          }

          if (state is BookSitterPaymentBP.ErrorState) {
            return Center(
              child: Text(
                'Error: ${state.error.toString()}',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }

  @override
  void navigateToAddCardPage({UserModel currentUser, CustomerModel customer}) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) => ADD_CARD_BP.AddCardBloc(
          currentUser: currentUser,
          customer: customer,
        ),
        child: ADD_CARD_BP.AddCardPage(),
      ),
    );
    Navigator.push(context, route);
  }
}
