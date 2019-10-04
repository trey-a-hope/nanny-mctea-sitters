import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final String text;

  Spinner({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 3.0,
          ),
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(fontSize: 15.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
