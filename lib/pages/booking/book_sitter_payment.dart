import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/pages/payments/payment_method.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/db.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';

class BookSitterPaymentPage extends StatefulWidget {
  final Appointment appointment;
  BookSitterPaymentPage({@required this.appointment});

  @override
  State createState() => BookSitterPaymentPageState(appointment: appointment);
}

class BookSitterPaymentPageState extends State<BookSitterPaymentPage> {
  BookSitterPaymentPageState({@required this.appointment});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Appointment appointment;
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';
  bool _isLoading = true;
  User _currentUser;
  Customer _customer;
  final GetIt getIt = GetIt.I;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final CollectionReference _appointmentsDB =
      Firestore.instance.collection('Appointments');

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();
    _customer = await getIt<StripeCustomer>()
        .retrieve(customerId: _currentUser.customerId);

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _submit() async {
    if (_customer.card == null) {
      getIt<Modal>().showInSnackBar(
          scaffoldKey: _scaffoldKey, text: 'You must add a card first.');
      return;
    }

    bool confirm = await getIt<Modal>().showConfirmation(
        context: context,
        title: 'Pay Now',
        text: 'Your card will be charged and appointment created.');
    if (confirm) {
      try {
        setState(
          () {
            _isLoading = true;
          },
        );

        //Make charge for booking fee.
        bool charged = await getIt<StripeCharge>().create(
            amount: 25.00,
            description: appointment.sitter.name + ', ' + appointment.service,
            customerId: _currentUser.customerId);

        if (!charged) {
          throw Exception('Could not charge card at this time.');
        }

        //Create appointment.
        var appointmentData = {
          'aptNo': appointment.aptNo,
          'city': appointment.city,
          'email': appointment.email,
          'message': appointment.message,
          'name': appointment.name,
          'phone': appointment.phone,
          'service': appointment.service,
          'street': appointment.street,
          'sitterID': appointment.sitter.id,
          'slotID': appointment.slot.id,
          'userID': _currentUser.id
        };

        DocumentReference aptDocRef =
            await _appointmentsDB.add(appointmentData);
        await _appointmentsDB.document(aptDocRef.documentID).updateData(
          {'id': aptDocRef.documentID},
        );

        //Set sitters time slot to taken.
        getIt<DB>().setSlotTaken(
            sitterId: appointment.sitter.id,
            slotId: appointment.slot.id,
            taken: true);

        setState(
          () {
            getIt<Modal>().showInSnackBar(
                scaffoldKey: _scaffoldKey, text: 'Appointment Created');
            _isLoading = false;
          },
        );
      } catch (e) {
        setState(
          () {
            _isLoading = false;
          },
        );
        getIt<Modal>().showInSnackBar(
          scaffoldKey: _scaffoldKey,
          text: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
              children: <Widget>[
                ScaffoldClipper(
                  simpleNavbar: SimpleNavbar(
                    leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
                    leftTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: 'Book Sitter',
                  subtitle: 'Review & Pay',
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Text('Service',
                          style: Theme.of(context).primaryTextTheme.title),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  appointment.sitter.imgUrl),
                            ),
                            title: Text(appointment.service),
                            subtitle: Text(
                                'Sitter: ${appointment.sitter.name} \nTime: ${DateFormat(timeFormat).format(appointment.slot.time)}'),
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
                              Text(
                                  '${appointment.street}, ${appointment.city}'),
                              Divider(),
                              Text(
                                'Phone',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${appointment.phone}',
                                maxLines: 5,
                              ),
                              Divider(),
                              Text(
                                'Message',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${appointment.message}',
                                maxLines: 5,
                              ),
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
                      _customer.card == null
                          ? Card(
                              elevation: 3,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentMethodPage(),
                                    ),
                                  );
                                },
                                leading: Icon(Icons.not_interested,
                                    color: Theme.of(context)
                                        .primaryIconTheme
                                        .color),
                                title: Text('Currently no card on file.'),
                                subtitle: Text('Add one now?'),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            )
                          : Card(
                              elevation: 3,
                              child: ListTile(
                                leading: Icon(Icons.confirmation_number,
                                    color: Theme.of(context)
                                        .primaryIconTheme
                                        .color),
                                title: Text(
                                    '${_customer.card.brand} / ****-****-****-${_customer.card.last4}'),
                                subtitle: Text('Expires ' +
                                    MONTHS[_customer.card.exp_month] +
                                    ' ' +
                                    '${_customer.card.exp_year}'),
                              ),
                            ),
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
                          'Rest of payment will be due upon completion of service.')

                      // _buildReviewCard(screen_width * 0.9),
                      // SizedBox(height: 40),
                      // _buildNameFormField(),
                      // SizedBox(height: 40),
                      // _buildEmailFormField(),
                      // SizedBox(height: 40),
                      // _buildPhoneFormField(),
                      // SizedBox(height: 40),
                      // _buildAptFloorFormField(),
                      // SizedBox(height: 40),
                      // _buildStreetFormField(),
                      // SizedBox(height: 40),
                      // _buildCityFormField(),
                      // SizedBox(height: 40),
                      // _buildMessageFormField()
                    ],
                  ),
                ),
              ],
            )),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Container _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () async {
          _submit();
        },
        color: Colors.grey.shade200,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.send,
                color: Colors.red,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'PAY NOW',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
