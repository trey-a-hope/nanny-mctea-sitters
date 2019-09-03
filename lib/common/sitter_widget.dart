import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';

import '../style/text.dart';

class SitterWidget extends StatelessWidget {
  final Sitter sitter;

  const SitterWidget({Key key, @required this.sitter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            
            height: 250,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8),),
                image: DecorationImage(image: sitter.image, fit: BoxFit.cover)),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: sitter.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  TextSpan(text: '\n'),
                  TextSpan(text: sitter.info)
                ]
              ),
            )
            // child: Text(
            //   sitter.name + '\n' + sitter.info,
            //   style: TextStyle(color: Colors.white),
            // ),
          )
        ],
      ),
    );
  }
}
