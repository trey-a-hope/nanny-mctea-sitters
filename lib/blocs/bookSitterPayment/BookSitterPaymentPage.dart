import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../ServiceLocator.dart';
import '../../blocs/bookSitterPayment/Bloc.dart' as BookSitterPaymentBP;

class BookSitterPaymentPage extends StatefulWidget {
  @override
  State createState() => BookSitterPaymentPageState();
}

class BookSitterPaymentPageState extends State<BookSitterPaymentPage> {
  BookSitterPaymentBP.BookSitterPaymentBloc bookSitterPaymentBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bookSitterPaymentBloc =
        BlocProvider.of<BookSitterPaymentBP.BookSitterPaymentBloc>(context);
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
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<BookSitterPaymentBP.BookSitterPaymentBloc,
          BookSitterPaymentBP.BookSitterPaymentState>(
        listener: (BuildContext context,
            BookSitterPaymentBP.BookSitterPaymentState state) {
          if (state is BookSitterPaymentBP.NavigateToAddCardState) {
            //todo: Create route to add card page.
            //             Route route = MaterialPageRoute(
            //   builder: (BuildContext context) => BlocProvider(
            //     create: (BuildContext context) =>
            //         BookSitterPaymentBP.BookSitterPaymentBloc(
            //       aptNo: state.aptNo,
            //       cost: state.cost,
            //       hours: state.hours,
            //       service: state.service,
            //       city: state.city,
            //       selectedDate: state.selectedDate,
            //       street: state.street,
            //       phoneNumber: state.phoneNumber,
            //       email: state.email,
            //       name: state.name,
            //     )..add(BookSitterPaymentBP.LoadPageEvent()),
            //     child: BookSitterPaymentBP.BookSitterPaymentPage(),
            //   ),
            // );
            // Navigator.push(context, route);
          }
        },
        builder: (BuildContext context,
            BookSitterPaymentBP.BookSitterPaymentState state) {
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
          } else if (state is BookSitterPaymentBP.NoCardState) {
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
          } else {
            return Center(
              child: Text('You should NEVER see this.'),
            );
          }
        },
      ),
    );
  }
}
