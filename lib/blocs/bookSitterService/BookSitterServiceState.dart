import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/bookSitterCalendar/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/bookSitterCalendar/BookSitterCalendarPage.dart';

class BookSitterServiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChildCareServiceState extends BookSitterServiceState {
  final List<_BookSitterTileWidget> services = [
    _BookSitterTileWidget(
        title: '4 Hour Sitter Service | 4 hr \$77',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: '5 Hour Sitter Service | 5 hr \$90',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: '6 Hour Sitter Service | 6 hr \$103',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: '7 Hour Sitter Service | 7 hr \$116',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: '8 Hour Sitter Service | 8 hr \$129',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: '9 Hour Sitter Service | 9 hr \$142',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
  ];

  ChildCareServiceState();

  @override
  List<Object> get props => [services];
}

class FeesRegistrationState extends BookSitterServiceState {
  final List<_BookSitterTileWidget> services = [
    _BookSitterTileWidget(
        title: 'Family Consultation | 2hr \$350',
        description:
            'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.'),
    _BookSitterTileWidget(
        title: 'Placement Fee | 1hr \$1,125',
        description:
            'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.'),
    _BookSitterTileWidget(
        title: 'Rush Fee | 1hr \$200',
        description:
            'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.'),
    _BookSitterTileWidget(
        title: 'Last Minute Sitter Care | 1hr \$35',
        description:
            'This is for an initial meeting with a Nanny McTea Consultant following approval of family applications. This meeting usual last 1-2hr depending on conversation & kiddos. Here I will found out more in depth what your family is looking for when it comes to your child care services, every family is different and I want to make sure we cover all your families needs. This is the first step to starting the nanny/sitter placement process.'),
  ];

  FeesRegistrationState();

  @override
  List<Object> get props => [services];
}

class MonthlySitterMembershipState extends BookSitterServiceState {
  final List<_BookSitterTileWidget> services = [
    _BookSitterTileWidget(
        title: 'Membership Booking | 3hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 4hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 5hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 6hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 7hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 8hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
    _BookSitterTileWidget(
        title: 'Membership Booking | 9hr Waived booking fee!',
        description:
            'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
  ];
  MonthlySitterMembershipState();

  @override
  List<Object> get props => [services];
}

//Reusable widget for displaying service info.
class _BookSitterTileWidget extends StatelessWidget {
  final String title;
  final String description;

  const _BookSitterTileWidget(
      {Key key, @required this.title, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            description,
            // style:Theme.of(context).primaryTextTheme.title
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '\n'),
                TextSpan(
                  text: 'Cancellation Policy:',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '\n\n'),
                TextSpan(
                    text:
                        'Please cancel at least 48 hours in advance if you wish to cancel your sitter service. If you cancel with less than 24 hours before service no refund will be given.',
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: RaisedButton(
            color: Colors.red,
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider(
                  create: (BuildContext context) =>
                      BookSitterCalendarBloc(hours: 5, cost: 125.00)
                        ..add(LoadPageEvent()),
                  child: BookSitterCalendarPage(),
                ),
              );
              Navigator.push(context, route);
              // //Probably not the most efficient way lol.
              // Appointment appointment = Appointment(
              //     service: title,
              //     id: '',
              //     city: '',
              //     message: '',
              //     phone: '',
              //     aptNo: '',
              //     name: '',
              //     street: '',
              //     email: '',
              //     sitterID: '',
              //     userID: '',
              //     slotID: '');

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         BookSitterCalendarPage(appointment: appointment),
              //   ),
              // );
            },
            child: Text(
              'Book It',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
