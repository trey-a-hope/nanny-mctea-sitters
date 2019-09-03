import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';

import '../style/text.dart';

class ReviewWidget extends StatelessWidget {
  final String review;
  final String author;

  const ReviewWidget({Key key, @required this.review, @required this.author})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 200,
        // color: Colors.yellow,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(5, 5),
          //   ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[Text('\"${review}\"'), Divider(), Text(author)],
          ),
        ),
      ),
    );
  }
}
