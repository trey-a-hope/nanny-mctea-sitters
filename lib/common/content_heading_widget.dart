import 'package:flutter/material.dart';

class ContentHeadingWidget extends StatelessWidget {
  final String heading;

  const ContentHeadingWidget({Key key, @required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
