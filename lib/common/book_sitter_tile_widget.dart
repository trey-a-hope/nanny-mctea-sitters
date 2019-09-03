import 'package:flutter/material.dart';

import '../style/text.dart';

class BookSitterTileWidget extends StatelessWidget {
  final String title;

  const BookSitterTileWidget({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            "Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking: - The rate for this service is \$13 / hr + \$25 booking fee -HERE is...",
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                  onPressed: () {
                    // Modal.showInSnackBar(_scaffoldKey, 'Proceed to Calendar');
                  },
                  color: Colors.green,
                  child: Text('Get More Info',
                      style: TextStyle(color: Colors.white))),
              MaterialButton(
                  onPressed: () {
                    // Modal.showInSnackBar(_scaffoldKey, 'Proceed to Calendar');
                  },
                  color: Colors.blue,
                  child: Text('Book It', style: TextStyle(color: Colors.white)))
            ],
          ),
        )
      ],
    );
  }
}

final List<BookSitterTileWidget> childCareServices = [
  BookSitterTileWidget(title: '4 Hour Sitter Service | 4 hr \$77'),
  BookSitterTileWidget(title: '5 Hour Sitter Service | 5 hr \$90'),
  BookSitterTileWidget(title: '6 Hour Sitter Service | 6 hr \$103'),
];

final List<BookSitterTileWidget> feesRegistration = [
  BookSitterTileWidget(title: 'Family Consultation | 2hr \$350'),
];

final List<BookSitterTileWidget> monthlySitterMembership = [
  BookSitterTileWidget(title: 'Membership Booking | 3hr Waived booking fee!'),
];
