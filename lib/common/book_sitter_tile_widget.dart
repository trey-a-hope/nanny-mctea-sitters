import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_calendar.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter.dart';

import '../style/text.dart';

class BookSitterTileWidget extends StatelessWidget {
  final String title;
  final String description;

  const BookSitterTileWidget(
      {Key key, @required this.title, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            description,
          ),
          subtitle: RichText(
            text: TextSpan(children: [
              TextSpan(text: '\n'),
              TextSpan(
                  text: 'Cancellation Policy:',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(text: '\n'),
              TextSpan(
                  text:
                      'Please cancel at least 48 hours in advance if you wish to cancel your sitter service. If you cancel with less than 24 hours before service no refund will be given.',
                  style: TextStyle(color: Colors.grey))
            ]),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(10),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookCalendarPage(title),
                  ),
                );
              },
              color: Colors.blue,
              child: Text(
                'Book It',
                style: TextStyle(color: Colors.white),
              ),
            ))
      ],
    );
  }
}

final List<BookSitterTileWidget> childCareServices = [
  BookSitterTileWidget(
      title: '4 Hour Sitter Service | 4 hr \$77',
      description:
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
  BookSitterTileWidget(
      title: '5 Hour Sitter Service | 5 hr \$90',
      description:
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
  BookSitterTileWidget(
      title: '6 Hour Sitter Service | 6 hr \$103',
      description:
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
];

final List<BookSitterTileWidget> feesRegistration = [
  BookSitterTileWidget(
      title: 'Family Consultation | 2hr \$350',
      description:
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
];

final List<BookSitterTileWidget> monthlySitterMembership = [
  BookSitterTileWidget(
      title: 'Membership Booking | 3hr Waived booking fee!',
      description:
          'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking:- The rate for this service is \$13 / hr + \$25 booking fee-HERE is where you pay the \$25 booking fee, that secures your sitter for the date requested. -YOU are then required to pay your sitter the REMAINING balance owed at the end of your scheduled sit - This service must be booked at least 48 hours in advance- We have a 4 hour minimum requirement.-The booking fee is non refundable.'),
];
